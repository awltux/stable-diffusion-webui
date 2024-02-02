# Cuda installer
CUDA_COMPILATION_TOOLS_VERSION=12.1.105
CUDA_DRIVER_VERSION=535.104.12
STABLE_DIFFUSION_MODEL_VERSION=2-1
STABLE_DIFFUSION_IMAGE_SIZE=512

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

# download the SD model and move it to the SD model directory
STABLE_DIFFUSION_CHECK_POINT_PROJECT=stable-diffusion-${STABLE_DIFFUSION_MODEL_VERSION}-base
STABLE_DIFFUSION_BASE_FILENAME=v${STABLE_DIFFUSION_MODEL_VERSION}_${STABLE_DIFFUSION_IMAGE_SIZE}-ema-pruned
STABLE_DIFFUSION_CHECK_POINT_FILENAME=${STABLE_DIFFUSION_BASE_FILENAME}.ckpt
STABLE_DIFFUSION_YAML_FILENAME=${STABLE_DIFFUSION_BASE_FILENAME}.yaml

sudo -u ubuntu git clone --depth 1 https://huggingface.co/stabilityai/${STABLE_DIFFUSION_CHECK_POINT_PROJECT}
cd ${STABLE_DIFFUSION_CHECK_POINT_PROJECT}/
sudo -u ubuntu git lfs pull --include "${STABLE_DIFFUSION_CHECK_POINT_FILENAME}"
sudo -u ubuntu git lfs install --force
cd ..
mv ${STABLE_DIFFUSION_CHECK_POINT_PROJECT}/${STABLE_DIFFUSION_CHECK_POINT_FILENAME} stable-diffusion-webui/models/Stable-diffusion/
rm -rf ${STABLE_DIFFUSION_CHECK_POINT_PROJECT}/

# download the corresponding config file and move it also to the model directory (make sure the name matches the model name)
wget https://raw.githubusercontent.com/Stability-AI/stablediffusion/main/configs/stable-diffusion/v2-inference.yaml
cp v2-inference.yaml stable-diffusion-webui/models/Stable-diffusion/${STABLE_DIFFUSION_YAML_FILENAME}

# change ownership of the web UI so that a regular user can start the server
sudo chown -R ubuntu:ubuntu stable-diffusion-webui/

# start the server as user 'ubuntu'
echo "Starting stable diffusion web-UI"
sudo -u ubuntu --preserve-env=python_cmd nohup bash stable-diffusion-webui/webui.sh --listen | tee log.txt

