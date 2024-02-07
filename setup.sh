#!/bin/bash
set -e # Always stop on error
set -u # Always stop if variable undefined

# Cuda installer
CUDA_COMPILATION_TOOLS_VERSION=12.1.105
CUDA_DRIVER_VERSION=535.104.12

# Python 3.8 causes webui.sh to fail with this error:
# https://github.com/AUTOMATIC1111/stable-diffusion-webui/issues/13054
PYTHON_VERSION=3.9
python_cmd=python${PYTHON_VERSION}

# disable the restart dialogue and install several packages
sudo sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
sudo apt-get update
sudo apt install wget git ${python_cmd} ${python_cmd}-venv build-essential net-tools awscli -y

# Useful for ubuntu20.04:
sudo apt install libgoogle-perftools4 libtcmalloc-minimal4 -y

# install CUDA (from https://developer.nvidia.com/cuda-downloads)
if ( test nvcc ); then
    INSTALLED_CUDA_COMPILATION_TOOLS_VERSION=$( nvcc -V | grep "Cuda compilation tools" | sed -e 's/.*V\([0-9.]*\)/\1/' )
else
    wget https://developer.download.nvidia.com/compute/cuda/${CUDA_COMPILATION_TOOLS_VERSION}/local_installers/cuda_${CUDA_COMPILATION_TOOLS_VERSION}_${CUDA_DRIVER_VERSION}_linux.run
    sudo sh cuda_${CUDA_COMPILATION_TOOLS_VERSION}_${CUDA_DRIVER_VERSION}_linux.run --silent
fi

# install git-lfs
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get install git-lfs
sudo -u ubuntu git lfs install --skip-smudge

sdxl_base_url=https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors
sdxl_base_path=stable-diffusion-webui/models/Stable-diffusion/SDXL-Base.safetensors
if [ ! -f ${sdxl_base_path} ]; then
    echo "Downloading: SDXL-Base Checkpoint"
    curl -L -o ${sdxl_base_path} \
        ${sdxl_base_url}
fi


sdxl_turbo_url=https://huggingface.co/stabilityai/sdxl-turbo/resolve/main/sd_xl_turbo_1.0_fp16.safetensors
sdxl_turbo_path=stable-diffusion-webui/models/Stable-diffusion/SDXL-Turbo.safetensors
if [ ! -f ${sdxl_turbo_path} ]; then
    echo "Downloading: SDXL-Turbo Checkpoint"
    curl -L -o ${sdxl_turbo_path} \
        ${sdxl_turbo_url}
fi


sdxl_refiner_url=https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors
sdxl_refiner_path=stable-diffusion-webui/models/Stable-diffusion/SDXL-Refiner.safetensors
if [ ! -f ${sdxl_refiner_path} ]; then
    echo "Downloading: SDXL-Refiner Checkpoint"
    curl -L -o ${sdxl_refiner_path} \
        ${sdxl_refiner_url}
fi


sdxl_vae_url=https://huggingface.co/stabilityai/sdxl-vae/resolve/main/sdxl_vae.safetensors
sdxl_vae_path=stable-diffusion-webui/models/VAE/SDXL_vae.safetensors
if [ ! -f ${sdxl_vae_path} ]; then
    echo "Downloading: SDXL VAE"
    curl -L -o ${sdxl_vae_path} \
        ${sdxl_vae_url}
fi

# SDFX Lora
mkdir -p stable-diffusion-webui/models/Lora

sdxl_lora_url=https://civitai.com/api/download/models/177999?type=Model&format=SafeTensor
sdxl_lora_path=stable-diffusion-webui/models/Lora/SDXL_Ink_Stains.safetensors
if [ ! -f ${sdxl_lora_path} ]; then
    echo "Downloading Lora: SDXL_Ink_Stains"
    curl -L -o "${sdxl_lora_path}" \
        ${sdxl_lora_url}
fi

sdxl_lora_url=https://civitai.com/api/download/models/180951?type=Model&format=SafeTensor
sdxl_lora_path=stable-diffusion-webui/models/Lora/SDXL_Ink_Splashing.safetensors
if [ ! -f ${sdxl_lora_path} ]; then
    echo "Downloading Lora: SDXL_Ink_Splashing"
    curl -L -o ${sdxl_lora_path} \
        ${sdxl_lora_url}
fi

sdxl_lora_url=https://civitai.com/api/download/models/215816?type=Model&format=SafeTensor
sdxl_lora_path=stable-diffusion-webui/models/Lora/SDXL_Sketch_For_Art_Examination.safetensors
if [ ! -f ${sdxl_lora_path} ]; then
    echo "Downloading Lora: SDXL_Sketch_For_Art_Examination"
    curl -L -o ${sdxl_lora_path} \
        ${sdxl_lora_url}
fi

sdxl_lora_url=https://civitai.com/api/download/models/196618?type=Model&format=SafeTensor
sdxl_lora_path=stable-diffusion-webui/models/Lora/SDXL_Cream_Style_Rooms.safetensors
if [ ! -f ${sdxl_lora_path} ]; then
    echo "Downloading Lora: SDXL_Cream_Style_Rooms"
    curl -L -o ${sdxl_lora_path} \
        ${sdxl_lora_url}
fi


sdxl_lora_url=https://civitai.com/api/download/models/203327?type=Model&format=SafeTensor
sdxl_lora_path=stable-diffusion-webui/models/Lora/SDXL_DiTerlizziArtAI.safetensors
if [ ! -f ${sdxl_lora_path} ]; then
    echo "Downloading Lora: SDXL_DiTerlizziArtAI"
    curl -L -o ${sdxl_lora_path} \
        ${sdxl_lora_url}
fi


sdxl_lora_url=https://civitai.com/api/download/models/155511?type=Model&format=SafeTensor
sdxl_lora_path=stable-diffusion-webui/models/Lora/SDXL_Paint_Splash_Style.safetensors
if [ ! -f ${sdxl_lora_path} ]; then
    echo "Downloading Lora: SDXL_Paint_Splash_Style"
    curl -L -o ${sdxl_lora_path} \
        ${sdxl_lora_url}
fi


sdxl_lora_url=https://civitai.com/api/download/models/128212
sdxl_lora_path=stable-diffusion-webui/models/Lora/SDXL_Oil_Painting.safetensors
if [ ! -f ${sdxl_lora_path} ]; then
    echo "Downloading Lora: SDXL_Oil_Painting"
    curl -L -o ${sdxl_lora_path} \
        ${sdxl_lora_url}
fi


sdxl_lora_url=https://civitai.com/api/download/models/227662?type=Model&format=SafeTensor
sdxl_lora_path=stable-diffusion-webui/models/Lora/SDXL_Oil_And_Watercolor_Painting.safetensors
if [ ! -f ${sdxl_lora_path} ]; then
    echo "Downloading Lora: SDXL_Oil_And_Watercolor_Painting"
    curl -L -o ${sdxl_lora_path} \
        ${sdxl_lora_url}
fi

sdxl_lora_url=https://civitai.com/api/download/models/285484?type=Model&format=SafeTensor
sdxl_lora_path=stable-diffusion-webui/models/Lora/SDXL_Pomological_Watercolor_Redmond.safetensors
if [ ! -f ${sdxl_lora_path} ]; then
    echo "Downloading Lora: SDXL_Pomological_Watercolor_Redmond"
    curl -L -o ${sdxl_lora_path} \
        ${sdxl_lora_url}
fi

sdxl_lora_url=https://civitai.com/api/download/models/270405?type=Model&format=SafeTensor
sdxl_lora_path=stable-diffusion-webui/models/Lora/SDXL_Echoes_Of_The_Verdant_Twilight.safetensors
if [ ! -f ${sdxl_lora_path} ]; then
    echo "Downloading Lora: SDXL_Echoes_Of_The_Verdant_Twilight"
    curl -L -o ${sdxl_lora_path} \
        ${sdxl_lora_url}
fi

# Force python3.9
sed -i "s/#python_cmd=.*/python_cmd=\"${python_cmd}\"/" stable-diffusion-webui/webui-user.sh 

# change ownership of the web UI so that a regular user can start the server
sudo chown -R ubuntu:ubuntu stable-diffusion-webui/

# start the server as user 'ubuntu'
echo "Starting stable diffusion web-UI"
sudo -u ubuntu nohup bash stable-diffusion-webui/webui.sh | tee log.txt

