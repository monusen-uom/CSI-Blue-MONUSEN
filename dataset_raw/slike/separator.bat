@echo off
setlocal enabledelayedexpansion

:: Create output directory
mkdir output 2>nul

:: Create temporary files
set "tempfile=%temp%\imagelist.txt"
set "randfile=%temp%\randomlist.txt"
del "%tempfile%" 2>nul
del "%randfile%" 2>nul

:: First pass - collect all image paths and count them
set total=0
for /r %%i in (*.jpg *.jpeg *.png *.gif *.bmp) do (
    set filepath=%%i
    if not "!filepath:output=!"=="!filepath!" (
        rem Skip files in output folder
    ) else (
        echo %%i>> "%tempfile%"
        set /a total+=1
    )
)

:: Calculate images per folder
set /a base_per_folder=%total% / 46
set /a remainder=%total% %% 46

echo Total images found: !total!
echo Base images per folder: !base_per_folder!
echo Remainder: !remainder!

:: Create 46 folders
for /l %%i in (1,1,46) do (
    mkdir "output\folder%%i" 2>nul
)

:: Generate random order
for /f "tokens=*" %%a in ('type "%tempfile%" ^| powershell -Command "$input | Get-Random -Count !total!"') do (
    echo %%a>> "%randfile%"
)

:: Initialize counters
set current_folder=1
set files_in_current_folder=0

:: Read the randomized file list and distribute images
for /f "usebackq delims=" %%i in ("%randfile%") do (
    :: Calculate how many files should go in current folder
    set /a files_needed=!base_per_folder!
    if !current_folder! leq !remainder! (
        set /a files_needed=!base_per_folder!+1
    )
    
    :: Copy file to current folder
    copy "%%i" "output\folder!current_folder!\" >nul
    echo Copying to folder!current_folder!: %%i
    
    :: Increment counter for current folder
    set /a files_in_current_folder=!files_in_current_folder!+1
    
    :: Check if we need to move to next folder
    if !files_in_current_folder! equ !files_needed! (
        set /a current_folder=!current_folder!+1
        set files_in_current_folder=0
    )
)

echo.
echo Distribution complete. Starting to zip folders...

:: Zip each folder using PowerShell
for /l %%i in (1,1,46) do (
    echo Zipping folder%%i...
    powershell -command "Compress-Archive -Path 'output\folder%%i\*' -DestinationPath 'output\folder%%i.zip' -Force"
)

:: Clean up temporary files
del "%tempfile%" 2>nul
del "%randfile%" 2>nul

:: Optional: Remove the original folders after zipping
echo.
echo Do you want to remove the original folders? (Y/N)
choice /c YN /m "Remove original folders?"
if errorlevel 2 goto :skipDelete
if errorlevel 1 (
    for /l %%i in (1,1,46) do (
        rd /s /q "output\folder%%i"
    )
)

:skipDelete
echo.
echo Process complete.
echo Total images processed: !total!
echo Base images per folder: !base_per_folder!
echo Folders with extra image: !remainder!
echo All folders have been zipped.
pause