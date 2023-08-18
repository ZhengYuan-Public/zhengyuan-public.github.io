---
comments: true
title: Homelab GPU Server Build
date: 2023-07-28 12:00:00
categories: [homelab, hardware, gpu-server]
tags: [homelab, hardware, gpu-server]
---

## Specification Sheet

| Component |                            Model                             | Number |           Price           |
| :-------: | :----------------------------------------------------------: | :----: | :-----------------------: |
|    MB     | AsRock [EPYC-D8](https://www.asrockrack.com/general/productdetail.jp.asp?Model=EPYCD8#Specifications) |   1    |   ¥1100 CNY / ~$150 USD   |
|    CPU    | AMD [EPYC-7642](https://www.amd.com/en/products/cpu/amd-epyc-7642) (48C 96T) |   1    |   ¥2900 CNY / ~$400 USD   |
|    RAM    |              Samsung-32GB-DDR4-RECC-2Rx4-2666V               |   8    |  ¥1600 CNY / ~ $220 USD   |
|    GPU    |             Gigabyte-NVIDIA-2080Ti-**22**GB-300A             |   4    | ¥10000 CNY / ~ $1500 USD  |
|   Case    |                            BC1 V2                            |   1    |  ¥1100 CNY / ~ $150 USD   |
|    PSU    |                         EVGA-1600-T2                         |   1    |   ¥800 CNY / ~ $110 USD   |
|   Disk    |                  Kioxia-RC20-NVME-SSD (2TB)                  |   2    |  ¥1300 CNY / ~ $180 USD   |
|    NAS    |                QNAP-TVS-951X - 32TB (RAID-5)                 |   1    |             /             |
|  *Total*  |                                                              |        | ¥18,700 CNY / ~ $2710 USD |

\*Currency convertion rate: 1USD = 7.33CNY

## GPU

I started choosing components for this build after I found the trend of upgrading the 2080Ti VRAM to **22GB** for AI image generation with [Stable Diffusion](https://stability.ai/blog/stable-diffusion-public-release). I chose the Gigabyte 2080Ti Turbo Edition (the power connectors are located at the rear) which has [TU102-300A-K1-A1](https://www.techpowerup.com/gpu-specs/nvidia-tu102.g813) and full X+X phase power. 

> A comparison of turbo edition 2080Ti from different brands can be found in [this video](https://www.bilibili.com/video/BV1os4y1b7z3).

### Theoretical Performance

|                   | [2080Ti](https://www.techpowerup.com/gpu-specs/geforce-rtx-2080-ti.c3305)-22GB | [4090](https://www.techpowerup.com/gpu-specs/geforce-rtx-4090.c3889) | 2080Ti x 4 (This Build) |
| :---------------: | :----------------------------------------------------------: | :----------------------------------------------------------: | :---------------------: |
|    Pixel Rate     |                        136.0 GPixel/s                        |                        443.5 GPixel/s                        |      544 GPixel/s       |
|   Texture Rate    |                        420.2 GTexel/s                        |                        1,290 GTexel/s                        |     1680.8 GTexel/s     |
|  **FP16 (half)**  |                         26.90 TFLOPS                         |                         82.58 TFLOPS                         |      107.6 TFLOPS       |
| **FP32 (float)**  |                         13.45 TFLOPS                         |                         82.58 TFLOPS                         |       53.8 TFLOPS       |
|   FP64 (double)   |                         420.2 GFLOPS                         |                         1,290 GFLOPS                         |      1680.8 GFLOPS      |
|     **VRAM**      |                          GDDR6-22GB                          |                         GDDR6X-24GB                          |       GDDR6-88GB        |
| Power Consumption |                             250W                             |                             450W                             |          1000W          |
|       Price       |                        ¥2500 / ~ $340                        |                       ¥13000 / ~ $1770                       |    ¥10000 / ~ $1500     |

Compared with a single 4090, this build has 

- 130.30% FP16 Performance :+1:
- 366.67% VRAM size :+1::+1::+1:
- 76.92% Price :+1:
- 65.15% FP32 Performance :-1:
- 222.22% Power Consumption :-1:

### A NOT Too Difficult Choice

My major reasons for choosing 2080Ti x 4 over 4090 x1 are as follows:

1. The FP32 performance in this build has a huge drop, but [networks rarely need full FP32 accuracy](https://pytorch.org/blog/what-every-user-should-know-about-mixed-precision-training-in-pytorch/#:~:text=It%E2%80%99s%20rare%20that%20networks%20need%20this%20much%20numerical%20accuracy.). Instead, the bottleneck is usually the VRAM size when training large networks.
2. I want and like the **88**GB VRAM in this build. :heart_eyes_cat:
3. Training with lower precision is still the trend and lots of interesting research is going on in this field.
4. Federated learning is one of my research interests. Having multiple GPUs can help me set up a virtual training/benching environment in one machine.
5. Last but not least, it's cheaper.

>  Some major time stamps
>
>  - In *2018*, NVIDIA released an extension for PyTorch called [Apex](https://github.com/NVIDIA/apex), which contained *Automatic Mixed Precision* (AMP).
>  - In *2020*, AMP became a core function [torch.cuda.amp](https://pytorch.org/docs/stable/amp.html) in PyTorch since version 1.6. 
>
>  - In *2023*, the latest NVIDIA H100 even added support for FP8. [NVIDIA Hopper: H100 And FP8 Support (lambdalabs)](https://lambdalabs.com/blog/nvidia-hopper-h100-and-fp8-support).

## Motherboard

I needed a motherboard that can support 4 GPUs. It was a little different from my previous experience with building a gaming PC so I'd like to briefly show my research results. To have [PCI-e x 16] x 4 or more, you would typically want to search for workstation / server motherboards. For this build, here is my priorities: `[PCI-e x 16] x4` > `CPU Cores` = `RAM Size` > `NVME Disk Slotes` > `STAT/SAS Ports` = `10Gb Ethernet`

As a novice in building servers, server motherboards have some really interesting features, such as Intelligent Platform Management Interface ([IPMI](https://en.wikipedia.org/wiki/Intelligent_Platform_Management_Interface)), that I'd like to try. So I decided to go with the server motherboard. Due to the budget, I wanted to use a set of retired (but not too old) server motherboards and CPUs.

Here is the list:

- AsRock [EPYC-D8](https://www.asrockrack.com/general/productdetail.jp.asp?Model=EPYCD8#Specifications)
- Gigabyte [MZ01-CE0](https://www.gigabyte.com/Enterprise/Server-Motherboard/MZ01-CE0-rev-3x) / [MZ01-CE1](https://www.gigabyte.com/Enterprise/Server-Motherboard/MZ01-CE1-rev-3x) 
- Supermicro [H12SSL-i](https://www.supermicro.com/en/products/motherboard/h12ssl-i)

![EPYC-D8](https://www.asrockrack.com/photo/EPYCD8-1(L).jpg){: w="600" h="400" }
*EPYC-D8*

![MZ01-CE0 (rev. 3.x) - Server Motherboard](https://static.gigabyte.com/StaticFile/Image/Global/284d2a3920661552bfc2b76170f0fdad/Product/28791/png/880){: width="800" }
*MZ01-CE0*

![Supermicro](https://www.supermicro.com/a_images/products/Aplus/MB/H12SSL-i_spec.jpg)
*H12SSL-i*


## Case

The case is a little expensive, but the anodized aluminum with titanium color gives it a premium outlook. It also has a durable design which makes it an expensive good deal.

![Official Image](https://streacom.com/wp-content/uploads/bc1t-v2-overhead.jpg)





