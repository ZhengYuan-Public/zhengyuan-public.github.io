---
comments: true
title: Proxmox Installation and GPU Passthrough
date: 2023-08-06 12:00:00
image:
  path: https://cdn.servermania.com/images/f_webp,q_auto:best/v1681847299/kb/Proxmox/Proxmox.webp?_i=AA
categories: [home-lab, proxmox, server, Linux]
tags: [home-lab, proxmox, server, Linux, PCI-Passthrough, KVM, Virtualization]
---

## Network Configuration

### Bonding a.k.a. Link Aggregation

[Understanding and Configuring Linux Network Interfaces](https://www.baeldung.com/linux/network-interface-configure)

[Network Configuration (Proxmox Documentation)](https://pve.proxmox.com/wiki/Network_Configuration#sysadmin_network_bond)

```shell
# /etc/network/interfaces
auto lo
iface lo inet loopback

iface enp66s0f0 inet manual
iface enp66s0f1 inet manual

auto bond0
iface bond0 inet static
        bond-slaves enp66s0f0 enp66s0f1
        bond-miimon 100
        bond-mode balance-alb
        bond-xmit-hash-policy layer2+3

auto vmbr0
iface vmbr0 inet dhcp
        address 192.168.1.252/24
        gateway 192.168.1.1
        bridge-ports bond0
        bridge-stp off
        bridge-fd 0
```

bond-mode

- **Round-robin (balance-rr):** Transmit network packets in sequential order from the first available network interface (NIC) slave through the last. This mode provides ***load balancing*** and ***fault tolerance***.
- **Active-backup (active-backup):** Only one NIC slave in the bond is active. A different slave becomes active if, and only if, the active slave fails. The single logical bonded interface’s MAC address is externally visible on only one NIC (port) to avoid distortion in the network switch. This mode provides ***fault tolerance***.
- **XOR (balance-xor):** Transmit network packets based on [(source MAC address XOR’d with destination MAC address) modulo NIC slave count]. This selects the same NIC slave for each destination MAC address. This mode provides ***load balancing*** and ***fault tolerance***.
- **Broadcast (broadcast):** Transmit network packets on all slave network interfaces. This mode provides ***fault tolerance***.
- **IEEE 802.3ad Dynamic link aggregation (802.3ad)(LACP):** Creates aggregation groups that share the same speed and duplex settings. Utilizes all slave network interfaces in the active aggregator group according to the 802.3ad specification.
- **Adaptive transmit load balancing (balance-tlb):** Linux bonding driver mode that does not require any special network-switch support. The outgoing network packet traffic is distributed according to the current load (computed relative to the speed) on each network interface slave. Incoming traffic is received by one currently designated slave network interface. If this receiving slave fails, another slave takes over the MAC address of the failed receiving slave.
- **Adaptive load balancing (balance-alb):** Includes balance-tlb plus receive load balancing (rlb) for IPV4 traffic, and does not require any special network switch support. The receive load balancing is achieved by ARP negotiation. The bonding driver intercepts the ARP Replies sent by the local system on their way out and overwrites the source hardware address with the unique hardware address of one of the NIC slaves in the single logical bonded interface such that different network-peers use different MAC addresses for their network packet traffic.

:page_facing_up: Related Files 

```bash
/etc/network/interfaces
/etc/hosts
/etc/resolv.conf
```

## GPU Passthrough

### Web Resources 

​	[PCI Passthrough(Proxmox Documentation)](https://pve.proxmox.com/wiki/PCI_Passthrough) :link:

​	[The Ultimate Beginner's Guide to GPU Passthrough (Reddit)](https://www.reddit.com/r/homelab/comments/b5xpua/the_ultimate_beginners_guide_to_gpu_passthrough/) :link:

​	[AMD/NVIDIA GPU Passthrough in Window 11 - Proxmox Guide(YouTube Video)](https://www.youtube.com/watch?v=S6jQx4AJlFw) :link:

### Step 0 - Check your hardware

### Step 1 -  Enable IOMMU

> IOMMU = (Input/Output Memory Management Unit)

``````bash
#--- Check if IOMMU is enabled ---#

$ dmesg | grep -e DMAR -e IOMMU

[    1.406181] pci 0000:c0:00.2: AMD-Vi: IOMMU performance counters supported
[    1.413634] pci 0000:80:00.2: AMD-Vi: IOMMU performance counters supported
[    1.424222] pci 0000:40:00.2: AMD-Vi: IOMMU performance counters supported
[    1.435644] pci 0000:00:00.2: AMD-Vi: IOMMU performance counters supported
[    1.446665] pci 0000:c0:00.2: AMD-Vi: Found IOMMU cap 0x40
[    1.446678] pci 0000:80:00.2: AMD-Vi: Found IOMMU cap 0x40
[    1.446684] pci 0000:40:00.2: AMD-Vi: Found IOMMU cap 0x40
[    1.446689] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40
[    1.447894] perf/amd_iommu: Detected AMD IOMMU #0 (2 banks, 4 counters/bank).
[    1.447905] perf/amd_iommu: Detected AMD IOMMU #1 (2 banks, 4 counters/bank).
[    1.447916] perf/amd_iommu: Detected AMD IOMMU #2 (2 banks, 4 counters/bank).
[    1.447927] perf/amd_iommu: Detected AMD IOMMU #3 (2 banks, 4 counters/bank).
# If you see any output with the words "DMAR" or "IOMMU," then it's likely that 
# your system has IOMMU enabled.

$ cat /proc/cmdline

BOOT_IMAGE=/boot/vmlinuz-6.2.16-3-pve root=/dev/mapper/pve-root ro quiet amd_iommu=on
# If you find iommu=on in the output, it confirms that IOMMU is enabled.
``````

``````bash
#--- Modify GRUB ---#
$ nano /etc/default/grub

# Change the following line
GRUB_CMDLINE_LINUX_DEFAULT="quiet" 

GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on" # ===> If you are using Intel CPUs
GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on"   # ===> If you are using AMD CPUs

# Update grub
$ update-grub
``````

### Step 2 - VFIO Modules

``````bash
#--- Add modules ---#
$ nano /etc/modules

# Add the following lines
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
``````

### Step 3: IOMMU Interrupt Remapping

``````bash
$ echo "options vfio_iommu_type1 allow_unsafe_interrupts=1" > \
	/etc/modprobe.d/iommu_unsafe_interrupts.conf
$ echo "options kvm ignore_msrs=1" > /etc/modprobe.d/kvm.conf
``````

### Step 4: Blacklisting Drivers

``````bash
# Nouveau [noo-voh] adj. newly or recently created, developed, or come to prominence
$ echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
# AMD Drivers
$ echo "blacklist radeon" >> /etc/modprobe.d/blacklist.conf
# Nvidia Drivers
$ echo "blacklist nvidia" >> /etc/modprobe.d/blacklist.conf
``````

\*Reboot the system after this step.

### Step 5: Adding GPU to VFIO

``````bash
#--- Find your GPUs ---#\
$ lspci | grep NVIDIA

# Take a note for all IDs
01:00.0 VGA compatible controller: NVIDIA Corporation TU102 [GeForce RTX 2080 Ti Rev. A]
01:00.1 Audio device: NVIDIA Corporation TU102 High Definition Audio Controller
01:00.2 USB controller: NVIDIA Corporation TU102 USB 3.1 Host Controller
01:00.3 Serial bus controller: NVIDIA Corporation TU102 USB Type-C UCSI Controller
41:00.0 VGA compatible controller: NVIDIA Corporation TU102 [GeForce RTX 2080 Ti Rev. A]
41:00.1 Audio device: NVIDIA Corporation TU102 High Definition Audio Controller
41:00.2 USB controller: NVIDIA Corporation TU102 USB 3.1 Host Controller
41:00.3 Serial bus controller: NVIDIA Corporation TU102 USB Type-C UCSI Controller
81:00.0 VGA compatible controller: NVIDIA Corporation TU102 [GeForce RTX 2080 Ti Rev. A]
81:00.1 Audio device: NVIDIA Corporation TU102 High Definition Audio Controller
81:00.2 USB controller: NVIDIA Corporation TU102 USB 3.1 Host Controller
81:00.3 Serial bus controller: NVIDIA Corporation TU102 USB Type-C UCSI Controller
82:00.0 VGA compatible controller: NVIDIA Corporation TU102 [GeForce RTX 2080 Ti Rev. A]
82:00.1 Audio device: NVIDIA Corporation TU102 High Definition Audio Controller
82:00.2 USB controller: NVIDIA Corporation TU102 USB 3.1 Host Controller
82:00.3 Serial bus controller: NVIDIA Corporation TU102 USB Type-C UCSI Controller
# IDs for this system are 01:00, 41:00, 81:00, and 82:00.
``````

``````bash
#--- Find GPU card's Vendor IDs ---#
$ lspci -n -s 01:00

01:00.0 0300: 10de:1e07 (rev a1)  
01:00.1 0403: 10de:10f7 (rev a1)  
01:00.2 0c03: 10de:1ad6 (rev a1)  
01:00.3 0c80: 10de:1ad7 (rev a1)  

$ lspci -n -s 41:00
01:00.0 0300: 10de:1e07 (rev a1)
01:00.1 0403: 10de:10f7 (rev a1)
01:00.2 0c03: 10de:1ad6 (rev a1)
01:00.3 0c80: 10de:1ad7 (rev a1)
# Got the same result because I had 4 identical GPU

# Change ids to your own ids
$ echo "options vfio-pci ids=10de:1e07, 10de:10f7, 10de:1ad6, 10de:1ad7, disable_vga=1"> \
	/etc/modprobe.d/vfio.conf

# Update initramfs
$ update-initramfs -u

# Reboot the system
``````

### Step6: Create VM

System Settings

- Graphic Card: `Default`
- Machine:  `q35`
- BIOS: `OVMF(UEFI)`
- SCSI Controller: `VirtIO SCSI`

Disk Settings

- [Disk Cache Mode (Proxmox Documentation)](https://pve.proxmox.com/wiki/Performance_Tweaks#Disk_Cache) :link:

### Additional tips

#### Ubuntu 

NVIDIA Driver

``````bash
#--- Remove Old Drivers ---#
$ sudo apt update
$ sudo apt remove --purge nvidia-*
$ sudo apt autoremove --purge
$ sudo apt clean
$ sudo reboot  
# Reboot can be necessary before reinstall the driver

#--- Install New Drivers ---#
$ sudo apt search nvidia-driver  
# Find available versions
$ sudo apt install nvidia-driver-535  
# Might need to set a secure boot password or disable secure boot if necessary
$ sudo reboot
``````

VNC

``````bash
#--- Install Dependencies ---#
$ sudo apt install vino
$ sudo apt install dconf-editor
``````
\*Navigate to `/org/gnome/desktop/remote-access` with `dconf-editor` and disable `require-encryption`


#### Windows

Additional CPU Flags

``````bash
# /etc/pve/qemu-server/<vmid>.conf
$ nano /etc/pve/qemu-server/101.conf

# Add the following lines at the end of the file
machine: q35
cpu: host,hidden=1,flags=+pcid
args: -cpu 'host,+kvm_pv_unhalt,+kvm_pv_eoi,hv_vendor_id=NV43FIX,kvm=off'
``````

*The final config file will update automatically after booting the VM

## Useful commands

Kill non-responding VMs

```bash
$ ps aux | grep "/usr/bin/kvm -id <vmid>"
$ kill -9 <PID>
```

## **Installation Resources** 

[Proxmox](https://proxmox.com/en/downloads) :link:

[Rufus](https://rufus.ie/en/) :link:

[VirtIO Driver for Windows](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso) :link:
