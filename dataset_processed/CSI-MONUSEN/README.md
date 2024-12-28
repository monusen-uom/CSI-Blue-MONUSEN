# CSI Monusen Object Detection Dataset

This repository contains a YOLOv8-based object detection project with a custom dataset and training pipeline.

The dataset includes 494 images.
Boat-and-buoy are annotated in YOLOv8 format.

The following pre-processing was applied to each image:
* Auto-orientation of pixel data (with EXIF-orientation stripping)
* Resize to 640x640 (Stretch)

No image augmentation techniques were applied.

## Project Structure

```
├── test/          # Test dataset
│   ├── images/    # Test images
│   └── labels/    # Test annotations in YOLO format
├── train/         # Training dataset
│   ├── images/    # Training images
│   └── labels/    # Training annotations in YOLO format
├── valid/         # Validation dataset
│   ├── images/    # Validation images
│   └── labels/    # Validation annotations in YOLO format
├── data.yaml      # Dataset configuration file
└── README.txt     # This file
```

## Requirements

Install the required packages:

```bash
pip install ultralytics
```

## Dataset

### Structure
The dataset follows the YOLOv8 format:
- Images: JPG/PNG format
- Labels: TXT files in YOLO format (normalized coordinates)
- Organized into train, validation, and test sets

### data.yaml
Configuration file containing:
- Paths to train, validation, and test sets
- Class names and number of classes
- Dataset metadata

## Training

The training process is implemented in `train.ipynb`. To train the model:

1. Open `train.ipynb` in Jupyter Notebook or Google Colab
2. Ensure your dataset path in data.yaml is correct
3. Run all cells in the notebook

### Training Parameters

The default configuration uses:
- Model: YOLOv8n (nano)
- Epochs: 40
- Image size: 640x640
- Batch size: 16
- Early stopping patience: 10
- Optimizer: Adam

You can modify these parameters in the training notebook according to your needs.

### Example Training Code

```python
from ultralytics import YOLO

# Load model
model = YOLO('yolov8n.pt')

# Train
results = model.train(
    data="path/to/your/data.yaml",
    epochs=40,
    imgsz=640,
    batch=16,
    patience=10
)
```

## Model Validation

The training notebook includes validation code:
```python
# Validate the model
results = model.val()
```

## Inference

To run inference on new images:
```python
# Predict on an image
results = model.predict("path/to/image.jpg", save=True)
```

## Model Export

The trained model can be exported to various formats:
```python
# Export the model
model.export(format='onnx')  # Available formats: torchscript, onnx, openvino, engine, coreml
```

## Results

Training results are saved in the `runs/train` directory:
- Best weights: `best.pt`
- Training metrics and plots
- Validation results

## Customization

To customize the training:
1. Modify training parameters in `train.ipynb`
2. Change model size (available options: yolov8n.pt, yolov8s.pt, yolov8m.pt, yolov8l.pt, yolov8x.pt)
3. Adjust data augmentation and training strategies

## Troubleshooting

Common issues and solutions:
1. CUDA out of memory
   - Reduce batch size
   - Use smaller model variant
   - Reduce image size

2. Training not converging
   - Check dataset annotations
   - Increase number of epochs
   - Adjust learning rate

3. Path errors
   - Verify data.yaml paths
   - Check file structure matches YOLO format