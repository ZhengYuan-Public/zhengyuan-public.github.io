---
title: Docker mmRotate
date: 2023-01-01 12:00:00 -500
categories: [homelab, environment]
tags: [gpu-server]
---

# Create a docker dev env for mmrotate

# Step 1: Pull docker/cuda and install nvidia-container-toolkit

Pull docker image from [NVIDIA/CUDA](https://hub.docker.com/r/nvidia/cuda/tags)


`base`: starting from CUDA 9.0, contains the bare minimum (libcudart) to deploy a pre-built CUDA application. Use this 
image if you want to manually select which CUDA packages you want to install.

`runtime`: extends the base image by adding all the shared libraries from the CUDA toolkit. Use this image if you have 
a pre-built application using multiple CUDA libraries.

`devel`: extends the runtime image by adding the compiler toolchain, the debugging tools, the headers and the static 
libraries. Use this image to compile a CUDA application from sources.


```bash
# <host_terminal>

docker pull nvidia/cuda:11.7.1-runtime-ubuntu20.04

# list all images
docker images

REPOSITORY       TAG                                 IMAGE ID       CREATED        SIZE
nvidia/cuda      11.7.1-cudnn8-runtime-ubuntu20.04   0b5ba72bc741   6 weeks ago    2.92GB
nvidia/cuda      10.1-cudnn7-runtime-ubuntu18.04     b22710d3a31a   4 months ago   1.71GB
```

Install nvidia-container-toolkit
```bash
# Setup the package repository and the GPG key
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Restart docker
sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
```


---
# Step 2: Run the image
```bash
# <host_terminal>
# docker run -idt -gpus all -p <host_port>:<container_port> <container_name/id>

docker run -idt -gpus all -p 23333:22 0b
```

`-i`: interactive

`-d`: detached

`-t`: allocate a TTY

`-p`: mapping port eg,`-p <host_port>:<container_port>`

`--gpus`: start a container to access GPU resources

```bash
# list all running containers
docker ps -a

CONTAINER ID   IMAGE     COMMAND                  CREATED       STATUS       PORTS                                   NAMES
02539952fa41   cd4       "bash"                   2 hours ago   Up 2 hours   0.0.0.0:2333->22/tcp, :::2333->22/tcp   sharp_swirles
0e93ed15dc8d   cd4       "-p 2333:22 -idt /bi…"   2 hours ago   Created                                              suspicious_elbakyan
f693f86a0403   cd4       "-p 23333:22 -idt /b…"   2 hours ago   Created                                              gracious_mcclintock
60cdfabac78a   cd4       "-p 22 -idt /bin/bash"   2 hours ago   Created                                              upbeat_faraday

```
---
# Step 3: Install package with `apt-get`
## Connect ot container
```bash
# docker exec -it <container_id/name> <command>

docker exec -it 025 /bin/bash
```
## Change to Huawei Mirror [Tutorial](https://www.cnblogs.com/0bug/p/16092552.html)

```bash
# <container_terminal>
cp -a /etc/apt/sources.list /etc/apt/sources.list.old
sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list
sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list
apt-get update
```

## Install packages with `apt-get install <package-name>`
* `wget`
* `vim` or `nano`
* `openssh-server` 
* `pip3`
## CV2 dependencies
* `ffmpeg` 
* `libsm6`
* `libxext6`

```bash
# <container_terminal>
apt-get install wget, vim, openssh-server, pip3, ffmpeg, libsm6, libxext6
```

---

# Step 4: Allow SSH connections

## Set root password
```
# <container_terminal>
passwd
```
## Allow root login
```
# <container_terminal>
vi /etc/ssh/sshd_config
```
add `PermitRootLogin yes` under `#Authentication`

## Start ssh service
```bash
# <container_terminal>
service --status-all
service ssh start

# auto start at creation
echo "service ssh start" >> /root/.bashrc
```


```bash
# Test ssh connection
# <host_terminal>
# ssh -p <port> <usr>@<IP>
ssh -p 2333 root@127.0.0.1

# Copy file via scp
# scp -P 2333 <path_to_file> <usr>@<IP>:<path_to_file>
scp -P 2333 ~/Downloads/Python-3.7.14.tgz root@127.0.0.1:/root 

```


---
# Step 4: Install dev packages

## Install PyTorch 1.11.0
```bash
# <container_terminal>
pip install torch==1.11.0+cu113 torchvision==0.12.0+cu113 torchaudio==0.11.0 --extra-index-url https://download.pytorch.org/whl/cu113
```
## Install mmcv, mmdet, mmrotate
```bash
# <container_terminal>
# mmcv==1.6.0 (CUDA=11.5, pytorch=1.11), mmdet, mmrotate
pip install mmcv-full==1.6.0 -f https://download.openmmlab.com/mmcv/dist/cu115/torch1.11.0/index.html
pip install mmrotate
pip install mmdet
```

---

# Step 5: Verify

```python3
# <container_python_console>
import torch
torch.cuda.is_available()

# imports used in mmrotate/tools/train.py
import argparse
import copy
import os
import os.path as osp
import time
import warnings

import mmcv
import torch
import torch.distributed as dist
from mmcv import Config, DictAction
from mmcv.runner import get_dist_info, init_dist
from mmcv.utils import get_git_hash
from mmdet import __version__
from mmdet.apis import init_random_seed, set_random_seed

from mmrotate.apis import train_detector
from mmrotate.datasets import build_dataset
from mmrotate.models import build_detector
from mmrotate.utils import collect_env, get_root_logger, setup_multi_processes
```

---
# Step 6: Save container to new image

## Clean cache 
```bash
# <container_terminal>
du -sh ~/.cache  # pip cache
rm -r ~/.cache

du -sh /var/cache  # other cache
rm -r ~/var/cache

apt-get clean  # apt-get cache

exit
```

## Save container to image

```bash
# list all running containers
docker ps -a

CONTAINER ID   IMAGE     COMMAND                  CREATED       STATUS       PORTS                                   NAMES
02539952fa41   cd4       "bash"                   2 hours ago   Up 2 hours   0.0.0.0:2333->22/tcp, :::2333->22/tcp   sharp_swirles
0e93ed15dc8d   cd4       "-p 2333:22 -idt /bi…"   2 hours ago   Created                                              suspicious_elbakyan
f693f86a0403   cd4       "-p 23333:22 -idt /b…"   2 hours ago   Created                                              gracious_mcclintock
60cdfabac78a   cd4       "-p 22 -idt /bin/bash"   2 hours ago   Created                                              upbeat_faraday

```

```bash
# Commit into new image
docker commit 025 zheng-dev

REPOSITORY    TAG                                 IMAGE ID       CREATED          SIZE
zheng-dev     latest                              35ef247a4cab   11 minutes ago   7.86GB
nvidia/cuda   11.7.1-cudnn8-runtime-ubuntu20.04   0b5ba72bc741   6 weeks ago      2.92GB
nvidia/cuda   10.1-cudnn7-runtime-ubuntu18.04     b22710d3a31a   4 months ago     1.71GB

docker run -idt --gpus all -p 2333:22 zheng-dev
```
