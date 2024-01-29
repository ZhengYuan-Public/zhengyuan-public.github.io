---
comments: true
title: Neural System - Physical Statistics
date: 2024-1-10 12:00:00
image:
    path: /assets/img/images_preview_default/Cat1.jpeg
math: true
categories: [Temporary]
tags: [temporary]
---

## Some Neuron Statistics

### Spinal Cord Nerve Fibers

{% cite Liu2015Jul --file reference_statistics %}

|         | Diameter(mm) |             | Number of nerve fibers |             |
| :-----: | :----------: | :---------: | :--------------------: | :---------: |
| Segment | Ventral root | Dorsal root |      Ventral root      | Dorsal root |
|   C1    |  0.97±0.16   |  1.21±0.28  |        2751±639        |  6430±1606  |
|   C2    |  1.34±0.30   |  2.61±0.51  |        3116±724        | 11947±2977  |
|   C3    |  0.80±0.23   |  2.87±0.52  |        2460±471        | 21876±1916  |
|   C4    |  1.39±0.24   |  2.49±0.34  |        3833±408        |  10647±887  |
|   C5    |  2.50±0.55   |  3.43±0.77  |       7841±1020        | 23300±2856  |
|   C6    |  2.23±0.73   |  3.99±0.75  |       7048±1157        | 36353±7451  |
|   C7    |  2.22±0.50   |  4.61±0.87  |       8467±1019        | 39653±8458  |
|   C8    |  1.71±0.60   |  3.92±0.62  |       5883±1000        | 31156±8273  |
|   T1    |  1.03±0.23   |  2.18±0.31  |       5788±1186        | 26507±7617  |
|   T2    |  0.75±0.11   |  1.30±0.14  |        3576±398        | 10234±1728  |
|   T3    |  0.78±0.10   |  1.35±0.16  |       5499±1126        | 14888±2514  |
|   T4    |  0.77±0.17   |  1.13±0.13  |        5485±973        | 10849±1832  |
|   T5    |  0.64±0.08   |  1.21±0.30  |       5326±1314        |  8355±1390  |
|   T6    |  0.71±0.18   |  1.07±0.16  |       3666±1407        | 10015±1666  |
|   T7    |  0.78±0.15   |  1.25±0.27  |       4297±1130        |  9123±1178  |
|   T8    |  0.83±0.25   |  1.29±0.18  |       3643±1340        |  7619±903   |
|   T9    |  0.81±0.15   |  1.33±0.25  |        5209±704        |  8369±967   |
|   T10   |  0.72±0.08   |  1.27±0.15  |        5269±963        | 11329±2724  |
|   T11   |  0.69±0.08   |  1.26±0.16  |        4870±895        |  9713±1824  |
|   T12   |  0.76±0.14   |  1.45±0.19  |        6538±892        |  10420±802  |
|   L1    |  0.81±0.07   |  1.55±0.28  |        5384±833        | 16820±3456  |
|   L2    |  0.96±0.16   |  1.93±0.27  |        7374±720        | 18615±±3284 |
|   L3    |  1.19±0.07   |  2.24±0.30  |       9169±1160        | 26191±2772  |
|   L4    |  1.04±0.07   |  2.48±0.38  |       7878±1386        | 31175±2686  |
|   L5    |  1.37±0.16   |  2.66±0.40  |       8657±1396        | 34455±2740  |
|   S1    |  1.43±0.16   |  2.95±0.57  |       8253±1419        | 41543±3036  |
|   S2    |  0.93±0.11   |  2.02±0.53  |       4766±1035        | 18642±1716  |
|   S3    |  0.55±0.07   |  1.32±0.60  |        2233±299        |  11971±964  |
|   S4    |  0.34±0.03   |  0.52±0.17  |        1356±193        |  3402±304   |
|   S5    |  0.14±0.02   |  0.27±0.13  |        906±111         |  2206±197   |

### Lower Bound of the Axon Diameter

{% cite Faisal2005Jun --file reference_statistics %} Axon diameters are pushed toward the channel-noise limit of $$ 0.1 \mu m $$ (mature neurons) due to Spontaneous Action Potentials (SAPs).

#### Thickness of the cell membrane 

{% cite Elert2023Nov --file reference_statistics %} 7.5 ~ 10 nm

#### Depolarisation and Hyperpolarization Voltage

![student submitted image, transcription available below](https://media.cheggcdn.com/media/23d/23df78fc-a854-4027-a1f1-3ebff49ff7e0/phphko3eU)

|       Phase       | Voltage | Duration |
| :---------------: | :-----: | :------: |
|  Depolarization   |  110mv  |   1ms    |
|  Repolarization   |  110mv  |  2~3ms   |
| Hyperpolarization |   5mv   |   1ms    |
| Refractory Period |    /    |  2~3ms   |

#### Firing rate

<1Hz to 200Hz (min 5ms/spike)

#### Axonal Conduction Velocity 

{% cite DeMaegd2017Mar --file reference_statistics %} 0.1m/s (unmyelinated) to 200m/s (myelinated)

## EEG 

{% cite Louis2016 --file reference_statistics %}

### Differential amplification

![Differential amplification](https://www.ncbi.nlm.nih.gov/books/NBK390346/bin/f02.jpg)

### EEG Standard Sensitivity

7 µV/mm - 0.007 V/m

### 3nm Process

|                              | Samsung | TSMC                                    |
| :--------------------------- | :------ | :-------------------------------------- |
| Transistor type              | MBCFET  | FinFET                                  |
| Transistor density (MTr/mm2) | **150** | **197 (theoretical)** **183 (A17 Pro)** |
| SRAM bit-cell size (μm2)     | Unknown | 0.0199                                  |
| Transistor gate pitch (nm)   | 40      | 45                                      |

Transistor density: $$ 197\times 10^8 Tr/mm^2 = 197 \times 10^8 \div 1000^2 = 19700 Tr/{\mu m}^2$$ 

Cross-section area of neuron($$d=0.1 \mu m)$$:  $$ 3.14 \times 0.05^2 = 0.00785 {\mu m}^2 $$

Minimum transistor thickness: 0.34 nm ([reference](https://spectrum.ieee.org/smallest-transistor-one-carbon-atom))

Size of multi-walled carbon nanotube: $$ 10-40nm, 5-20 \mu m $$ {% cite Abdallah2020Jan --file reference_statistics %}

### Endocytosis Size Limit

/{% cite Rejman2004Jan --file reference_statistics %} max 500nm spheres in diameter - energy-dependent process

## Some Calculations

Time resolution needed to capture the diameter of a neuron

$$
\begin{align}
	& c \approx 3.0 \times 10^8 m/s \\
	& d = 0.1 \mu m = 1 \times 10^{-7} m \\
	&\Delta t = \frac{d}{c} = 3.3 \times 10^{-16} s \\
\end{align}
$$

Times to capture all singals

$$
\begin{align}
	& c \approx 3.0 \times 10^8 m/s \\
	& D = 3mm = 3 \times 10^{-3} m \\
	&\Delta T = \frac{D}{c} = 1 \times 10^{-10} s
\end{align}
$$





## Reference

{% bibliography --cited --file reference_statistics %}