# Start FROM Nvidia PyTorch image https://ngc.nvidia.com/catalog/containers/nvidia:pytorch
#FROM 763104351884.dkr.ecr.us-east-1.amazonaws.com/pytorch-inference:1.10.0-gpu-py38-cu113-ubuntu20.04-e3
FROM 763104351884.dkr.ecr.us-east-1.amazonaws.com/pytorch-inference:1.10.2-gpu-py38-cu113-ubuntu20.04-e3

# RUN apt-get -y update && apt-get install -y --no-install-recommends \
#     wget \
#     python3 \
#     python3-pip \
#     python3-setuptools \
#     python3-distutils \
#     nginx \
#     ca-certificates \
#     python-setuptools \
#     cmake \
#     curl \
#     emacs \
#     git \
#     jq \
#     libgl1-mesa-glx \
#     libglib2.0-0 \
#     libgomp1 \
#     libibverbs-dev \
#     libnuma1 \
#     libnuma-dev \
#     libsm6 \
#     libssl1.1 \
#     libxext6 \
#     libxrender-dev \
#     openjdk-11-jdk \
#     openssl \
#     vim \
#     wget \
#     unzip \
#     zlib1g-dev \
#     ffmpeg \
#     libgl1 \
#     && rm -rf /var/lib/apt/lists/*
    
# RUN ln -s -f /usr/bin/python3 /usr/bin/python
# RUN ln -s /usr/bin/pip3 /usr/bin/pip

# Install python dependencies
COPY requirements.txt .
RUN python -m pip install --upgrade pip
RUN pip uninstall -y nvidia-tensorboard nvidia-tensorboard-plugin-dlprof
RUN pip install --no-cache -r requirements.txt coremltools gsutil notebook 

ENV PATH="/opt/ml/code:${PATH}"

# /opt/ml and all subdirectories are utilized by SageMaker, we use the /code subdirectory to store our user code.
COPY py_od /opt/ml/code

# this environment variable is used by the SageMaker PyTorch container to determine our user code directory.
ENV SAGEMAKER_SUBMIT_DIRECTORY /opt/ml/code

# this environment variable is used by the SageMaker PyTorch container to determine our program entry point
# for training and serving.
# For more information: https://github.com/aws/sagemaker-pytorch-container
ENV SAGEMAKER_PROGRAM predictor.py