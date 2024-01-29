---
comments: true
title: Passthrough Physical Disk (Partition) to VM
image:
    path: /assets/img/images_preview/ProxmoxPreview.png
date: 2024-1-27 12:00:00
categories: [Server, Proxmox]
tags: [server, hardware, gpu-server, proxmox]
---

## Devices in Linux

> Everything is a file.
{: .prompt-tip }

|    File Type     | Indicator |            Description             |
| :--------------: | :-------: | :--------------------------------: |
|      Normal      |    `-`    |                                    |
|   Directories    |    `d`    |                                    |
|    Hard Link     |    `-`    |                                    |
|  Symbolic Link   |    `l`    |                                    |
|      Socket      |    `s`    | [See below](#named-pipe-vs-socket) |
|    Named Pipe    |    `p`    | [See below](#named-pipe-vs-socket) |
| Character Device |    `c`    |                                    |
| **Block Device** |    `b`    |                                    |


> A block device is a nonvolatile mass storage device that allows information to be accessed in any order. Block devices include: Hard drives, SSDs, eNVM, Optical drives, USB drives, Tape drives.
{: .prompt-info }


### Disks in Linux

```shell
$ ls /dev -al | grep nvme
crw-------  1 root root    242,   0 Jan 28 19:06 nvme0
brw-rw----  1 root disk    259,   0 Jan 28 19:06 nvme0n1
brw-rw----  1 root disk    259,   2 Jan 28 19:06 nvme0n1p1
brw-rw----  1 root disk    259,   3 Jan 28 19:06 nvme0n1p2
brw-rw----  1 root disk    259,   4 Jan 28 19:06 nvme0n1p3
crw-------  1 root root    242,   1 Jan 28 19:06 nvme1
brw-rw----  1 root disk    259,   1 Jan 28 20:33 nvme1n1

$ lsblk
NAME                         MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
nvme0n1                      259:0    0  1.8T  0 disk 
├─nvme0n1p1                  259:2    0 1007K  0 part 
├─nvme0n1p2                  259:3    0    1G  0 part /boot/efi
└─nvme0n1p3                  259:4    0  1.8T  0 part 
  ├─pve-swap                 252:0    0    8G  0 lvm  [SWAP]
  ├─pve-root                 252:1    0   96G  0 lvm  /
  ├─pve-data_tmeta           252:2    0 15.9G  0 lvm  
  │ └─pve-data-tpool         252:4    0  1.7T  0 lvm  
  │   ├─pve-data             252:5    0  1.7T  1 lvm  
  │   ├─pve-vm--101--disk--0 252:6    0    4M  0 lvm  
  │   ├─pve-vm--101--disk--1 252:7    0  200G  0 lvm  
  │   ├─pve-vm--101--disk--2 252:8    0    4M  0 lvm  
  │   ├─pve-vm--100--disk--0 252:9    0    4M  0 lvm  
  │   ├─pve-vm--100--disk--1 252:10   0  200G  0 lvm  
  │   ├─pve-vm--102--disk--0 252:11   0    4M  0 lvm  
  │   └─pve-vm--102--disk--1 252:12   0   16G  0 lvm  
  └─pve-data_tdata           252:3    0  1.7T  0 lvm  
    └─pve-data-tpool         252:4    0  1.7T  0 lvm  
      ├─pve-data             252:5    0  1.7T  1 lvm  
      ├─pve-vm--101--disk--0 252:6    0    4M  0 lvm  
      ├─pve-vm--101--disk--1 252:7    0  200G  0 lvm  
      ├─pve-vm--101--disk--2 252:8    0    4M  0 lvm  
      ├─pve-vm--100--disk--0 252:9    0    4M  0 lvm  
      ├─pve-vm--100--disk--1 252:10   0  200G  0 lvm  
      ├─pve-vm--102--disk--0 252:11   0    4M  0 lvm  
      └─pve-vm--102--disk--1 252:12   0   16G  0 lvm  
nvme1n1                      259:1    0  1.8T  0 disk
```

#### Alternatives

```shell
$ lshw -class disk
$ hwinfo --disk
$ fdisk -l
```

## Folder `/dev/disk`

```shell
$ cd /dev/disk
$ tree
.
├── by-diskseq
│   ├── 1 -> ../../loop0
│   ├── 10 -> ../../nvme1n1
│   ├── 2 -> ../../loop1
│   ├── 3 -> ../../loop2
│   ├── 4 -> ../../loop3
│   ├── 5 -> ../../loop4
│   ├── 6 -> ../../loop5
│   ├── 7 -> ../../loop6
│   ├── 8 -> ../../loop7
│   └── 9 -> ../../nvme0n1
├── by-id
│   ├── dm-name-pve-root -> ../../dm-1
│   ├── dm-name-pve-swap -> ../../dm-0
│   ├── dm-name-pve-vm--100--disk--0 -> ../../dm-9
│   ├── dm-name-pve-vm--100--disk--1 -> ../../dm-10
│   ├── dm-name-pve-vm--101--disk--0 -> ../../dm-6
│   ├── dm-name-pve-vm--101--disk--1 -> ../../dm-7
│   ├── dm-name-pve-vm--101--disk--2 -> ../../dm-8
│   ├── dm-name-pve-vm--102--disk--0 -> ../../dm-11
│   ├── dm-name-pve-vm--102--disk--1 -> ../../dm-12
│   ├── dm-uuid-LVM-xVi29aAiDR3iIkZ3Tf9gLpsKkFOTW63[str] -> ../../dm-6
│   ├── dm-uuid-LVM-xVi29aAiDR3iIkZ3Tf9gLpsKkFOTW63[str] -> ../../dm-0
│   ├── dm-uuid-LVM-xVi29aAiDR3iIkZ3Tf9gLpsKkFOTW63[str] -> ../../dm-10
│   ├── dm-uuid-LVM-xVi29aAiDR3iIkZ3Tf9gLpsKkFOTW63[str] -> ../../dm-1
│   ├── dm-uuid-LVM-xVi29aAiDR3iIkZ3Tf9gLpsKkFOTW63[str] -> ../../dm-9
│   ├── dm-uuid-LVM-xVi29aAiDR3iIkZ3Tf9gLpsKkFOTW63[str] -> ../../dm-12
│   ├── dm-uuid-LVM-xVi29aAiDR3iIkZ3Tf9gLpsKkFOTW63[str] -> ../../dm-11
│   ├── dm-uuid-LVM-xVi29aAiDR3iIkZ3Tf9gLpsKkFOTW63[str] -> ../../dm-8
│   ├── dm-uuid-LVM-xVi29aAiDR3iIkZ3Tf9gLpsKkFOTW63[str] -> ../../dm-7
│   ├── lvm-pv-uuid-S8yRLW-UnAv-JiTb-OheU-3WuK-MIXr-fhfaWJ -> ../../nvme0n1p3
│   ├── nvme-eui.00000000000000008ce38e03008361f3 -> ../../nvme0n1
│   ├── nvme-eui.00000000000000008ce38e03008361f3-part1 -> ../../nvme0n1p1
│   ├── nvme-eui.00000000000000008ce38e03008361f3-part2 -> ../../nvme0n1p2
│   ├── nvme-eui.00000000000000008ce38e03008361f3-part3 -> ../../nvme0n1p3
│   ├── nvme-eui.00000000000000008ce38e030088d2d8 -> ../../nvme1n1
│   ├── nvme-KIOXIA-EXCERIA_G2_SSD_339A208TKMK5 -> ../../nvme1n1
│   ├── nvme-KIOXIA-EXCERIA_G2_SSD_339A208TKMK5_1 -> ../../nvme1n1
│   ├── nvme-KIOXIA-EXCERIA_G2_SSD_X2RA31A4KML5 -> ../../nvme0n1
│   ├── nvme-KIOXIA-EXCERIA_G2_SSD_X2RA31A4KML5_1 -> ../../nvme0n1
│   ├── nvme-KIOXIA-EXCERIA_G2_SSD_X2RA31A4KML5_1-part1 -> ../../nvme0n1p1
│   ├── nvme-KIOXIA-EXCERIA_G2_SSD_X2RA31A4KML5_1-part2 -> ../../nvme0n1p2
│   ├── nvme-KIOXIA-EXCERIA_G2_SSD_X2RA31A4KML5_1-part3 -> ../../nvme0n1p3
│   ├── nvme-KIOXIA-EXCERIA_G2_SSD_X2RA31A4KML5-part1 -> ../../nvme0n1p1
│   ├── nvme-KIOXIA-EXCERIA_G2_SSD_X2RA31A4KML5-part2 -> ../../nvme0n1p2
│   └── nvme-KIOXIA-EXCERIA_G2_SSD_X2RA31A4KML5-part3 -> ../../nvme0n1p3
├── by-partuuid
│   ├── 50921ebe-b83d-4eae-91cc-a4d78bf08b13 -> ../../nvme0n1p3
│   ├── 5aa57936-4a86-4bad-896a-41920628912b -> ../../nvme0n1p1
│   └── a6a6db66-38f0-4b79-86f3-59253177fd7f -> ../../nvme0n1p2
├── by-path
│   ├── pci-0000:02:00.0-nvme-1 -> ../../nvme0n1
│   ├── pci-0000:02:00.0-nvme-1-part1 -> ../../nvme0n1p1
│   ├── pci-0000:02:00.0-nvme-1-part2 -> ../../nvme0n1p2
│   ├── pci-0000:02:00.0-nvme-1-part3 -> ../../nvme0n1p3
│   └── pci-0000:03:00.0-nvme-1 -> ../../nvme1n1
└── by-uuid
    ├── 8125-70B6 -> ../../nvme0n1p2
    ├── b38852aa-b11b-45f1-9a14-b63adbe93908 -> ../../dm-0
    └── cd6d218d-7aba-4ead-86f3-fc09a6b0b137 -> ../../dm-1

6 directories, 55 files

# Note they are symlinks (symbolic links).
```

## Passthrough Disks on Proxmox

> Block Device Passthrough
>
> - Not passing through the controller, so no IOMMU required.
> - Can be shared via multiple VMs.
> - [PCI(e) Passthrough](https://pve.proxmox.com/pve-docs/pve-admin-guide.html#qm_pci_passthrough) & [USB Passthrough](https://pve.proxmox.com/pve-docs/pve-admin-guide.html#qm_usb_passthrough).
>

1. Get the disk (partition) by `by-{}`
    ```shell
    $ ls /dev/disk/by-path -al
    
    drwxr-xr-x 2 root root 140 Jan 28 19:06 .
    drwxr-xr-x 7 root root 140 Jan 28 19:06 ..
    lrwxrwxrwx 1 root root  13 Jan 28 19:06 pci-0000:02:00.0-nvme-1 -> ../../nvme0n1
    lrwxrwxrwx 1 root root  15 Jan 28 19:06 pci-0000:02:00.0-nvme-1-part1 -> ../../nvme0n1p1
    lrwxrwxrwx 1 root root  15 Jan 28 19:06 pci-0000:02:00.0-nvme-1-part2 -> ../../nvme0n1p2
    lrwxrwxrwx 1 root root  15 Jan 28 19:06 pci-0000:02:00.0-nvme-1-part3 -> ../../nvme0n1p3
    lrwxrwxrwx 1 root root  13 Jan 28 19:06 pci-0000:03:00.0-nvme-1 -> ../../nvme1n1
    ```
2. Hot-plug
    ```shell
    # You can passthrough the entire disk or a partition
    $ qm set <vmid> -scsi2 /dev/disk/by-path/pci-0000:02:00.0-nvme-1
    update VM <vmid>: -scsi2 /dev/disk/by-path/pci-0000:02:00.0-nvme-1
    
    $ qm set <vmid> -scsi2 /dev/disk/by-path/pci-0000:02:00.0-nvme-1-part1
    update VM <vmid>: -scsi2 /dev/disk/by-path/pci-0000:02:00.0-nvme-1-part1
    ```
    
3. Hot-unplug
    ```shell
    $ qm unlink <vmid> --idlist scsi2
    ```

## Slightly More Advanced

### Named Pipe V.S. Socket

|        **Feature**         |                        **Named Pipe**                        |                          **Socket**                          |
| :------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
|       **Connection**       |                     Local (same machine)                     |            Local and Network (different machines)            |
| **Communication Channels** |                    Two-way, bidirectional                    |             Two-way and One-way (connectionless)             |
|  **Data transfer order**   |                  FIFO (First-in-First-out)                   | Order depends on protocol <br />(TCP preserves order, UDP doesn't) |
|    **Setup Complexity**    |                Low, just create a named file                 | Moderate, involves specifying protocols <br /> and address details |
|      **Performance**       |                Faster for local communication                |           Varies depending on network and protocol           |
|      **Flexibility**       |      No network protocols needed,<br />simpler for IPC       |   Supports wide range of protocols <br />and applications    |
|        **Security**        |       Access limited to file <br />system permissions        | More secure with network layers <br />and authentication options |
|      **Scalability**       |        Limited to processes on <br />the same machine        |      Scales across networks and <br />multiple machines      |
|       **Use cases**        | Inter-process communication<br /> Command chaining<br /> Temporary data exchange | Web servers, <br />Database connections, <br />Remote procedure calls, <br />Distributed applications |

## `/dev & /media & /mnt`

| Directory |               Purpose               |                       Use Cases                       |
| :-------: | :---------------------------------: | :---------------------------------------------------: |
|  `/dev`   |      Device files for hardware      |       Accessing raw devices, Debugging drivers        |
|  `/mnt`   |      Manual mounts of any kind      | Temporary partitions, Network drives, External drives |
| `/media`  | Automatic mounts of removable media |      USB drives, SD cards, External hard drives       |

To access the files within a disk, it (raw device file) must be mounted first.

```shell
$ mkdir /media/NVME1
$ mount /dev/nvme1n1 /media/NVME1

$ unmount /dev/nvme1n1
```

## Reference

[How To List Disks on Linux](https://devconnected.com/how-to-list-disks-on-linux/)

[Proxmox - Passthrough Physical Disk to Virtual Machine (VM)](https://pve.proxmox.com/wiki/Passthrough_Physical_Disk_to_Virtual_Machine_(VM))

[Proxmox Forum - Is it possible to passthrough a partition of a drive to a VM? and not the entire disk?](https://forum.proxmox.com/threads/is-it-possible-to-passthrough-a-partition-of-a-drive-to-a-vm-and-not-the-entire-disk.109974/)