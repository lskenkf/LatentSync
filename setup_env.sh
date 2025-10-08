#!/bin/bash

# Create a new conda environment
conda create -y -n latentsync python=3.10.13
conda activate latentsync

# Install ffmpeg
conda install -y -c conda-forge ffmpeg

conda install -c conda-forge libgcc-ng libstdcxx-ng

# Python dependencies
pip install -r requirements.txt

# OpenCV dependencies
sudo apt -y install libgl1

# Download the checkpoints required for inference from HuggingFace
huggingface-cli download ByteDance/LatentSync-1.6 whisper/tiny.pt --local-dir checkpoints
huggingface-cli download ByteDance/LatentSync-1.6 latentsync_unet.pt --local-dir checkpoints
