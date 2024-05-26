---
comments: true
title: Enable vGPU on Consumer Cards (Proxmox 8.0)
image:
    path: /assets/img/images_preview/ProxmoxPreview.png
date: 2023-11-18 12:00:00
categories: [Virtualization, Proxmox]
tags: [virtualization, proxmox, vGPU]
---

## Compatible Consumer Cards

- Most GPUs from the Maxwell 2.0 generation (GTX 9xx, Quadro Mxxxx, Tesla Mxx) **EXCEPT ~~GTX 970~~**

- All GPUs from the Pascal generation (GTX 10xx, Quadro Pxxxx, Tesla Pxx)

- All GPUs from the Turing generation (GTX 16xx, RTX 20xx, Txxxx)

- ~~**RTX30XX or RTX40XX**~~

## Getting Prepared

### Install Proxmox

#### Change Proxmox Repo

Change the Debian and Proxmox repos if you are in China. ([Debian](https://mirrors.tuna.tsinghua.edu.cn/help/debian/) + [Proxmox](https://mirrors.tuna.tsinghua.edu.cn/help/proxmox/))

```bash
$ nano/etc/apt/sources.list

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware
deb https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/proxmox/debian/pve bookworm pve-no-subscription
```

#### Update Proxmox

```bash
$ apt update
$ apt dist-upgrade
```


### Install Necessary Tools

```bash
# Install necessary tools
$ apt install -y git build-essential dkms pve-headers mdevctl unzip

# Install the rust compiler
$ curl https://sh.rustup.rs -sSf | sh -s -- -y --profile minimal
$ source $HOME/.cargo/env
```

### Enable IOMMU (Optional)

#### GRUB

```bash
$ nano /etc/default/grub

# Change this line => GRUB_CMDLINE_LINUX_DEFAULT="quiet"
# For Intel Systems
GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on iommu=pt"
# For AMD Systems
GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on iommu=pt"

$ update-grub
```

#### systemd-boot

[Check the Guide Here](https://gitlab.com/polloloco/vgpu-proxmox/-/tree/master?ref_type=heads#:~:text=GRUB-,systemd%2Dboot,-Loading%20required%20kernel)

### Blacklisting Open-Source Driver

```bash
$ echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
```

### Load Kernel Modules

```bash
$ echo -e "vfio\nvfio_iommu_type1\nvfio_pci\nvfio_virqfd" >> /etc/modules
$ update-initramfs -u -k all
$ reboot
```

## vGPU-Unlock-RS

```bash
# Download vgpu_unlock-rs => /opt
cd /opt
git clone https://github.com/mbilker/vgpu_unlock-rs.git
cd vgpu_unlock-rs/
cargo build --release

# Create files used by vgpu_unlock
$ mkdir /etc/vgpu_unlock
$ touch /etc/vgpu_unlock/profile_override.toml

$ mkdir /etc/systemd/system/{nvidia-vgpud.service.d,nvidia-vgpu-mgr.service.d}
$ echo -e "[Service]\nEnvironment=LD_PRELOAD=/opt/vgpu_unlock-rs/target/release/libvgpu_unlock_rs.so" \
	> /etc/systemd/system/nvidia-vgpud.service.d/vgpu_unlock.conf
$ echo -e "[Service]\nEnvironment=LD_PRELOAD=/opt/vgpu_unlock-rs/target/release/libvgpu_unlock_rs.so" \
	> /etc/systemd/system/nvidia-vgpu-mgr.service.d/vgpu_unlock.conf
```

## Custom NVIDIA vGPU Driver

Download driver from [NVIDIA-VGPU-Driver-Archive](https://github.com/justin-himself/NVIDIA-VGPU-Driver-Archive/releases), I'm using `NVIDIA-GRID-Linux-KVM-535.129.03-537.70.zip` from the release [NVIDIA vGPU Drivers 16.2](https://github.com/justin-himself/NVIDIA-VGPU-Driver-Archive/releases/tag/16.2)

```bash
# Download Official Driver => /root
$ wget https://github.com/justin-himself/NVIDIA-VGPU-Driver-Archive/releases/download/16.2/NVIDIA-GRID-Linux-KVM-535.129.03-537.70.zip
$ mkdir vGPU-Driver
$ unzip NVIDIA-GRID-Linux-KVM-535.129.03-537.70.zip -d vGPU-Driver

# vgpu-proxmox => /root
$ git clone https://gitlab.com/polloloco/vgpu-proxmox.git

# Patch the driver
$ cd /root/vGPU-Driver/Host_Drivers
$ chmod +x NVIDIA-Linux-x86_64-535.129.03-vgpu-kvm.run
$ ./NVIDIA-Linux-x86_64-535.129.03-vgpu-kvm.run --apply-patch ~/vgpu-proxmox/535.129.03.patch
# "NVIDIA-Linux-x86_64-535.129.03-vgpu-kvm-custom.run" should be generated.

# Install the custom driver, choose yes for all prompts
$ ./NVIDIA-Linux-x86_64-535.129.03-vgpu-kvm-custom.run --dkms
$ reboot
```

## Verification

Make sure all of the following commands have proper output, and then vGPU is unlocked! :1st_place_medal:

### nvidia-smi

```bash
$ nvidia-smi
+---------------------------------------------------------------------------------------+
| NVIDIA-SMI 535.129.03             Driver Version: 535.129.03   CUDA Version: N/A      |
|-----------------------------------------+----------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
|                                         |                      |               MIG M. |
|=========================================+======================+======================|
|   0  NVIDIA GeForce RTX 2080 Ti     On  | 00000000:01:00.0 Off |                  N/A |
| 69%   61C    P8              36W / 260W |    153MiB / 22528MiB |      0%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
|   1  NVIDIA GeForce RTX 2080 Ti     On  | 00000000:41:00.0 Off |                  N/A |
| 32%   44C    P8              31W / 260W |    153MiB / 22528MiB |      0%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
|   2  NVIDIA GeForce RTX 2080 Ti     On  | 00000000:81:00.0 Off |                  N/A |
| 55%   56C    P8              36W / 260W |    153MiB / 22528MiB |      0%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
|   3  NVIDIA GeForce RTX 2080 Ti     On  | 00000000:82:00.0 Off |                  N/A |
| 46%   52C    P8              28W / 260W |    153MiB / 22528MiB |      0%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
                                                                                         
+---------------------------------------------------------------------------------------+
| Processes:                                                                            |
|  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
|        ID   ID                                                             Usage      |
|=======================================================================================|
|  No running processes found                                                           |
+---------------------------------------------------------------------------------------+
```

### nvidia-smi vgpu

```bash
$ nvidia-smi vgpu
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 535.129.03             Driver Version: 535.129.03                |
|---------------------------------+------------------------------+------------+
| GPU  Name                       | Bus-Id                       | GPU-Util   |
|      vGPU ID     Name           | VM ID     VM Name            | vGPU-Util  |
|=================================+==============================+============|
|   0  NVIDIA GeForce RTX 208...  | 00000000:01:00.0             |   0%       |
+---------------------------------+------------------------------+------------+
|   1  NVIDIA GeForce RTX 208...  | 00000000:41:00.0             |   0%       |
+---------------------------------+------------------------------+------------+
|   2  NVIDIA GeForce RTX 208...  | 00000000:81:00.0             |   0%       |
+---------------------------------+------------------------------+------------+
|   3  NVIDIA GeForce RTX 208...  | 00000000:82:00.0             |   0%       |
+---------------------------------+------------------------------+------------+
```

### mdevctl types

```bash
$ mdevctl types
0000:01:00.0
  nvidia-256
    Available instances: 24
    Device API: vfio-pci
    Name: GRID RTX6000-1Q
    Description: num_heads=4, frl_config=60, framebuffer=1024M, max_resolution=5120x2880, max_instance=24
  nvidia-257
    Available instances: 12
    Device API: vfio-pci
    Name: GRID RTX6000-2Q
    Description: num_heads=4, frl_config=60, framebuffer=2048M, max_resolution=7680x4320, max_instance=12
  nvidia-258
    Available instances: 8
    Device API: vfio-pci
    Name: GRID RTX6000-3Q
    Description: num_heads=4, frl_config=60, framebuffer=3072M, max_resolution=7680x4320, max_instance=8
  nvidia-259
    Available instances: 6
    Device API: vfio-pci
    Name: GRID RTX6000-4Q
    Description: num_heads=4, frl_config=60, framebuffer=4096M, max_resolution=7680x4320, max_instance=6
  nvidia-260
    Available instances: 4
    Device API: vfio-pci
    Name: GRID RTX6000-6Q
    Description: num_heads=4, frl_config=60, framebuffer=6144M, max_resolution=7680x4320, max_instance=4
  nvidia-261
    Available instances: 3
    Device API: vfio-pci
    Name: GRID RTX6000-8Q
    Description: num_heads=4, frl_config=60, framebuffer=8192M, max_resolution=7680x4320, max_instance=3
  nvidia-262
    Available instances: 2
    Device API: vfio-pci
    Name: GRID RTX6000-12Q
    Description: num_heads=4, frl_config=60, framebuffer=12288M, max_resolution=7680x4320, max_instance=2
  nvidia-263
    Available instances: 1
    Device API: vfio-pci
    Name: GRID RTX6000-24Q
    Description: num_heads=4, frl_config=60, framebuffer=24576M, max_resolution=7680x4320, max_instance=1
  nvidia-435
    Available instances: 24
    Device API: vfio-pci
    Name: GRID RTX6000-1B
    Description: num_heads=4, frl_config=45, framebuffer=1024M, max_resolution=5120x2880, max_instance=24
  nvidia-436
    Available instances: 12
    Device API: vfio-pci
    Name: GRID RTX6000-2B
    Description: num_heads=4, frl_config=45, framebuffer=2048M, max_resolution=5120x2880, max_instance=12
  nvidia-437
    Available instances: 24
    Device API: vfio-pci
    Name: GRID RTX6000-1A
    Description: num_heads=1, frl_config=60, framebuffer=1024M, max_resolution=1280x1024, max_instance=24
  nvidia-438
    Available instances: 12
    Device API: vfio-pci
    Name: GRID RTX6000-2A
    Description: num_heads=1, frl_config=60, framebuffer=2048M, max_resolution=1280x1024, max_instance=12
  nvidia-439
    Available instances: 8
    Device API: vfio-pci
    Name: GRID RTX6000-3A
    Description: num_heads=1, frl_config=60, framebuffer=3072M, max_resolution=1280x1024, max_instance=8
  nvidia-440
    Available instances: 6
    Device API: vfio-pci
    Name: GRID RTX6000-4A
    Description: num_heads=1, frl_config=60, framebuffer=4096M, max_resolution=1280x1024, max_instance=6
  nvidia-441
    Available instances: 4
    Device API: vfio-pci
    Name: GRID RTX6000-6A
    Description: num_heads=1, frl_config=60, framebuffer=6144M, max_resolution=1280x1024, max_instance=4
  nvidia-442
    Available instances: 3
    Device API: vfio-pci
    Name: GRID RTX6000-8A
    Description: num_heads=1, frl_config=60, framebuffer=8192M, max_resolution=1280x1024, max_instance=3
  nvidia-443
    Available instances: 2
    Device API: vfio-pci
    Name: GRID RTX6000-12A
    Description: num_heads=1, frl_config=60, framebuffer=12288M, max_resolution=1280x1024, max_instance=2
  nvidia-444
    Available instances: 1
    Device API: vfio-pci
    Name: GRID RTX6000-24A
    Description: num_heads=1, frl_config=60, framebuffer=24576M, max_resolution=1280x1024, max_instance=1
0000:41:00.0
  nvidia-256
    Available instances: 24
    Device API: vfio-pci
    Name: GRID RTX6000-1Q
    Description: num_heads=4, frl_config=60, framebuffer=1024M, max_resolution=5120x2880, max_instance=24
  nvidia-257
    Available instances: 12
    Device API: vfio-pci
    Name: GRID RTX6000-2Q
    Description: num_heads=4, frl_config=60, framebuffer=2048M, max_resolution=7680x4320, max_instance=12
  nvidia-258
    Available instances: 8
    Device API: vfio-pci
    Name: GRID RTX6000-3Q
    Description: num_heads=4, frl_config=60, framebuffer=3072M, max_resolution=7680x4320, max_instance=8
  nvidia-259
    Available instances: 6
    Device API: vfio-pci
    Name: GRID RTX6000-4Q
    Description: num_heads=4, frl_config=60, framebuffer=4096M, max_resolution=7680x4320, max_instance=6
  nvidia-260
    Available instances: 4
    Device API: vfio-pci
    Name: GRID RTX6000-6Q
    Description: num_heads=4, frl_config=60, framebuffer=6144M, max_resolution=7680x4320, max_instance=4
  nvidia-261
    Available instances: 3
    Device API: vfio-pci
    Name: GRID RTX6000-8Q
    Description: num_heads=4, frl_config=60, framebuffer=8192M, max_resolution=7680x4320, max_instance=3
  nvidia-262
    Available instances: 2
    Device API: vfio-pci
    Name: GRID RTX6000-12Q
    Description: num_heads=4, frl_config=60, framebuffer=12288M, max_resolution=7680x4320, max_instance=2
  nvidia-263
    Available instances: 1
    Device API: vfio-pci
    Name: GRID RTX6000-24Q
    Description: num_heads=4, frl_config=60, framebuffer=24576M, max_resolution=7680x4320, max_instance=1
  nvidia-435
    Available instances: 24
    Device API: vfio-pci
    Name: GRID RTX6000-1B
    Description: num_heads=4, frl_config=45, framebuffer=1024M, max_resolution=5120x2880, max_instance=24
  nvidia-436
    Available instances: 12
    Device API: vfio-pci
    Name: GRID RTX6000-2B
    Description: num_heads=4, frl_config=45, framebuffer=2048M, max_resolution=5120x2880, max_instance=12
  nvidia-437
    Available instances: 24
    Device API: vfio-pci
    Name: GRID RTX6000-1A
    Description: num_heads=1, frl_config=60, framebuffer=1024M, max_resolution=1280x1024, max_instance=24
  nvidia-438
    Available instances: 12
    Device API: vfio-pci
    Name: GRID RTX6000-2A
    Description: num_heads=1, frl_config=60, framebuffer=2048M, max_resolution=1280x1024, max_instance=12
  nvidia-439
    Available instances: 8
    Device API: vfio-pci
    Name: GRID RTX6000-3A
    Description: num_heads=1, frl_config=60, framebuffer=3072M, max_resolution=1280x1024, max_instance=8
  nvidia-440
    Available instances: 6
    Device API: vfio-pci
    Name: GRID RTX6000-4A
    Description: num_heads=1, frl_config=60, framebuffer=4096M, max_resolution=1280x1024, max_instance=6
  nvidia-441
    Available instances: 4
    Device API: vfio-pci
    Name: GRID RTX6000-6A
    Description: num_heads=1, frl_config=60, framebuffer=6144M, max_resolution=1280x1024, max_instance=4
  nvidia-442
    Available instances: 3
    Device API: vfio-pci
    Name: GRID RTX6000-8A
    Description: num_heads=1, frl_config=60, framebuffer=8192M, max_resolution=1280x1024, max_instance=3
  nvidia-443
    Available instances: 2
    Device API: vfio-pci
    Name: GRID RTX6000-12A
    Description: num_heads=1, frl_config=60, framebuffer=12288M, max_resolution=1280x1024, max_instance=2
  nvidia-444
    Available instances: 1
    Device API: vfio-pci
    Name: GRID RTX6000-24A
    Description: num_heads=1, frl_config=60, framebuffer=24576M, max_resolution=1280x1024, max_instance=1
0000:81:00.0
  nvidia-256
    Available instances: 24
    Device API: vfio-pci
    Name: GRID RTX6000-1Q
    Description: num_heads=4, frl_config=60, framebuffer=1024M, max_resolution=5120x2880, max_instance=24
  nvidia-257
    Available instances: 12
    Device API: vfio-pci
    Name: GRID RTX6000-2Q
    Description: num_heads=4, frl_config=60, framebuffer=2048M, max_resolution=7680x4320, max_instance=12
  nvidia-258
    Available instances: 8
    Device API: vfio-pci
    Name: GRID RTX6000-3Q
    Description: num_heads=4, frl_config=60, framebuffer=3072M, max_resolution=7680x4320, max_instance=8
  nvidia-259
    Available instances: 6
    Device API: vfio-pci
    Name: GRID RTX6000-4Q
    Description: num_heads=4, frl_config=60, framebuffer=4096M, max_resolution=7680x4320, max_instance=6
  nvidia-260
    Available instances: 4
    Device API: vfio-pci
    Name: GRID RTX6000-6Q
    Description: num_heads=4, frl_config=60, framebuffer=6144M, max_resolution=7680x4320, max_instance=4
  nvidia-261
    Available instances: 3
    Device API: vfio-pci
    Name: GRID RTX6000-8Q
    Description: num_heads=4, frl_config=60, framebuffer=8192M, max_resolution=7680x4320, max_instance=3
  nvidia-262
    Available instances: 2
    Device API: vfio-pci
    Name: GRID RTX6000-12Q
    Description: num_heads=4, frl_config=60, framebuffer=12288M, max_resolution=7680x4320, max_instance=2
  nvidia-263
    Available instances: 1
    Device API: vfio-pci
    Name: GRID RTX6000-24Q
    Description: num_heads=4, frl_config=60, framebuffer=24576M, max_resolution=7680x4320, max_instance=1
  nvidia-435
    Available instances: 24
    Device API: vfio-pci
    Name: GRID RTX6000-1B
    Description: num_heads=4, frl_config=45, framebuffer=1024M, max_resolution=5120x2880, max_instance=24
  nvidia-436
    Available instances: 12
    Device API: vfio-pci
    Name: GRID RTX6000-2B
    Description: num_heads=4, frl_config=45, framebuffer=2048M, max_resolution=5120x2880, max_instance=12
  nvidia-437
    Available instances: 24
    Device API: vfio-pci
    Name: GRID RTX6000-1A
    Description: num_heads=1, frl_config=60, framebuffer=1024M, max_resolution=1280x1024, max_instance=24
  nvidia-438
    Available instances: 12
    Device API: vfio-pci
    Name: GRID RTX6000-2A
    Description: num_heads=1, frl_config=60, framebuffer=2048M, max_resolution=1280x1024, max_instance=12
  nvidia-439
    Available instances: 8
    Device API: vfio-pci
    Name: GRID RTX6000-3A
    Description: num_heads=1, frl_config=60, framebuffer=3072M, max_resolution=1280x1024, max_instance=8
  nvidia-440
    Available instances: 6
    Device API: vfio-pci
    Name: GRID RTX6000-4A
    Description: num_heads=1, frl_config=60, framebuffer=4096M, max_resolution=1280x1024, max_instance=6
  nvidia-441
    Available instances: 4
    Device API: vfio-pci
    Name: GRID RTX6000-6A
    Description: num_heads=1, frl_config=60, framebuffer=6144M, max_resolution=1280x1024, max_instance=4
  nvidia-442
    Available instances: 3
    Device API: vfio-pci
    Name: GRID RTX6000-8A
    Description: num_heads=1, frl_config=60, framebuffer=8192M, max_resolution=1280x1024, max_instance=3
  nvidia-443
    Available instances: 2
    Device API: vfio-pci
    Name: GRID RTX6000-12A
    Description: num_heads=1, frl_config=60, framebuffer=12288M, max_resolution=1280x1024, max_instance=2
  nvidia-444
    Available instances: 1
    Device API: vfio-pci
    Name: GRID RTX6000-24A
    Description: num_heads=1, frl_config=60, framebuffer=24576M, max_resolution=1280x1024, max_instance=1
0000:82:00.0
  nvidia-256
    Available instances: 24
    Device API: vfio-pci
    Name: GRID RTX6000-1Q
    Description: num_heads=4, frl_config=60, framebuffer=1024M, max_resolution=5120x2880, max_instance=24
  nvidia-257
    Available instances: 12
    Device API: vfio-pci
    Name: GRID RTX6000-2Q
    Description: num_heads=4, frl_config=60, framebuffer=2048M, max_resolution=7680x4320, max_instance=12
  nvidia-258
    Available instances: 8
    Device API: vfio-pci
    Name: GRID RTX6000-3Q
    Description: num_heads=4, frl_config=60, framebuffer=3072M, max_resolution=7680x4320, max_instance=8
  nvidia-259
    Available instances: 6
    Device API: vfio-pci
    Name: GRID RTX6000-4Q
    Description: num_heads=4, frl_config=60, framebuffer=4096M, max_resolution=7680x4320, max_instance=6
  nvidia-260
    Available instances: 4
    Device API: vfio-pci
    Name: GRID RTX6000-6Q
    Description: num_heads=4, frl_config=60, framebuffer=6144M, max_resolution=7680x4320, max_instance=4
  nvidia-261
    Available instances: 3
    Device API: vfio-pci
    Name: GRID RTX6000-8Q
    Description: num_heads=4, frl_config=60, framebuffer=8192M, max_resolution=7680x4320, max_instance=3
  nvidia-262
    Available instances: 2
    Device API: vfio-pci
    Name: GRID RTX6000-12Q
    Description: num_heads=4, frl_config=60, framebuffer=12288M, max_resolution=7680x4320, max_instance=2
  nvidia-263
    Available instances: 1
    Device API: vfio-pci
    Name: GRID RTX6000-24Q
    Description: num_heads=4, frl_config=60, framebuffer=24576M, max_resolution=7680x4320, max_instance=1
  nvidia-435
    Available instances: 24
    Device API: vfio-pci
    Name: GRID RTX6000-1B
    Description: num_heads=4, frl_config=45, framebuffer=1024M, max_resolution=5120x2880, max_instance=24
  nvidia-436
    Available instances: 12
    Device API: vfio-pci
    Name: GRID RTX6000-2B
    Description: num_heads=4, frl_config=45, framebuffer=2048M, max_resolution=5120x2880, max_instance=12
  nvidia-437
    Available instances: 24
    Device API: vfio-pci
    Name: GRID RTX6000-1A
    Description: num_heads=1, frl_config=60, framebuffer=1024M, max_resolution=1280x1024, max_instance=24
  nvidia-438
    Available instances: 12
    Device API: vfio-pci
    Name: GRID RTX6000-2A
    Description: num_heads=1, frl_config=60, framebuffer=2048M, max_resolution=1280x1024, max_instance=12
  nvidia-439
    Available instances: 8
    Device API: vfio-pci
    Name: GRID RTX6000-3A
    Description: num_heads=1, frl_config=60, framebuffer=3072M, max_resolution=1280x1024, max_instance=8
  nvidia-440
    Available instances: 6
    Device API: vfio-pci
    Name: GRID RTX6000-4A
    Description: num_heads=1, frl_config=60, framebuffer=4096M, max_resolution=1280x1024, max_instance=6
  nvidia-441
    Available instances: 4
    Device API: vfio-pci
    Name: GRID RTX6000-6A
    Description: num_heads=1, frl_config=60, framebuffer=6144M, max_resolution=1280x1024, max_instance=4
  nvidia-442
    Available instances: 3
    Device API: vfio-pci
    Name: GRID RTX6000-8A
    Description: num_heads=1, frl_config=60, framebuffer=8192M, max_resolution=1280x1024, max_instance=3
  nvidia-443
    Available instances: 2
    Device API: vfio-pci
    Name: GRID RTX6000-12A
    Description: num_heads=1, frl_config=60, framebuffer=12288M, max_resolution=1280x1024, max_instance=2
  nvidia-444
    Available instances: 1
    Device API: vfio-pci
    Name: GRID RTX6000-24A
    Description: num_heads=1, frl_config=60, framebuffer=24576M, max_resolution=1280x1024, max_instance=1
```

## Customize vGPU

```bash
$ nano /etc/vgpu_unlock/profile_override.toml

[profile.nvidia-259]
num_displays = 1
# Max number of virtual displays. 
# Usually 1 if you want a simple remote gaming VM.
display_width = 1920
# Maximum display width in the VM
display_height = 1080
# Maximum display height in the VM
max_pixels = 2073600
# This is the product of display_width and display_height.
cuda_enabled = 1
# Enables CUDA support.
frl_enabled = 1          
# This controls the frame rate limiter to 60fps.
framebuffer = 0x74000000
framebuffer_reservation = 0xC000000   
# framebuffer + framebuffer_reservation = VRAM size in bytes

[vm.100]
frl_enabled = 0
# You can override all the options from above here too. 
# If you want to add more overrides for a new VM, just copy this block and change the VM ID
```

## Add vGPU Pool

1. Go to `Datacenter` => `Resource Mappings` => `PCE Devices` => `Add`

2. Add a name, such as `vGPU-Pool`

3. Check `Use with Mediated Devices` and select GPU(s) that you'd like to use

## Reference

[vGPU-Proxmox](https://gitlab.com/polloloco/vgpu-proxmox/-/tree/master?ref_type=heads)
