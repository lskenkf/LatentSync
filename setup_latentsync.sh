#!/bin/bash

# LatentSync Setup Script
# This script sets up the complete environment for LatentSync

set -e  # Exit on any error

echo "🚀 Starting LatentSync setup..."

# Create a new conda environment
echo "📦 Creating conda environment 'latentsync' with Python 3.10.13..."
conda create -y -n latentsync python=3.10.13

# Activate the environment
echo "🔧 Activating conda environment..."
source $(conda info --base)/etc/profile.d/conda.sh
conda activate latentsync

# Install system dependencies
echo "🛠️ Installing system dependencies..."
sudo apt update
sudo apt install -y libgl1

# Install conda packages
echo "📚 Installing conda packages..."
conda install -y -c conda-forge ffmpeg
conda install -y -c conda-forge libiconv
conda install -y -c nvidia cuda-toolkit cuda-runtime

# Install Python dependencies
echo "🐍 Installing Python dependencies..."
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt --break-system-packages
else
    echo "⚠️ requirements.txt not found. Make sure you're in the LatentSync directory."
fi

# Download checkpoints from HuggingFace
echo "📥 Downloading checkpoints from HuggingFace..."
huggingface-cli download ByteDance/LatentSync-1.6 whisper/tiny.pt --local-dir checkpoints
huggingface-cli download ByteDance/LatentSync-1.6 latentsync_unet.pt --local-dir checkpoints

# Set up environment variables for better GPU memory management
echo "⚙️ Setting up environment variables..."
echo 'export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True' >> ~/.bashrc

# Verify installation
echo "✅ Verifying installation..."
python -c "import torch; print(f'PyTorch version: {torch.__version__}')"
python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}')"
ffmpeg -version | head -1

echo ""
echo "🎉 LatentSync setup complete!"
echo ""
echo "To use LatentSync:"
echo "1. conda activate latentsync"
echo "2. cd /path/to/LatentSync"
echo "3. Run your inference commands"
echo ""
echo "Example inference command:"
echo "python -m scripts.inference \\"
echo "    --unet_config_path \"configs/unet/stage2_512.yaml\" \\"
echo "    --inference_ckpt_path \"checkpoints/latentsync_unet.pt\" \\"
echo "    --inference_steps 20 \\"
echo "    --guidance_scale 1.5 \\"
echo "    --enable_deepcache \\"
echo "    --video_path \"assets/demo1_video.mp4\" \\"
echo "    --audio_path \"assets/demo1_audio.wav\" \\"
echo "    --video_out_path \"video_out.mp4\""