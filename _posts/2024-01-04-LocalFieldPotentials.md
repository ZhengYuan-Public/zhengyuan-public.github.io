---
comments: true
title: Local Field Potentials (LFPs)
date: 2024-01-04 12:00:00
image:
    path: /assets/img/images_neuroscience/electrical_measurements_of_brain_activity.png
math: true
categories: [Neuroscience, Local Field Potentials]
tags: [neuroscience, local-field-potentials, lfps]
---

## Electrical Measurements of Brain Activity

![utah_array](https://blackrockneurotech.com/wp-content/uploads/2023/04/Utah-Array-NeuroPort-2.jpg){: style="max-width: 600px; height: auto;"}
_[Utah Array Preview Image](https://blackrockneurotech.com/products/utah-array/)_

Low-frequency band (<300Hz): **Local Filed Potential (LFP)**

- Represents summed synaptic <u>inputs</u> from a local neuronal <u>population</u> (within a radius of at least a few hundred micrometers {% cite Katzner2009Jan Xing2009Sep --file papers_aio %}  to over one centimeter {% cite kajikawa2011local --file papers_aio %})

High-frequency band (>500Hz): **Spikes**

- Represents spiking of local neurons

- Based on subsequent processing

  1. **Single-Unit Activity (SUA)**
     - SUA represents the timing of spikes (i.e. action potential) fired by individual neurons.
     - Extraction: Threshold crossing + Unit classification (spike sorting).

  2. **Multi-Unit Activity (MUA)/Multi-Unit Spike (MSP)**
     - MSP represents all detected spikes (without spike sorting) which represent the aggregate spikes from an ensemble of neurons within a radius of **140–300 μm** in the vicinity of the electrode tip.
     
  3. **Entire Spiking Activity (ESA)**
       - ESA is represented by a continuous signal and reflects an instantaneous measure of the number and size of spikes from a population of neurons around the recording electrode.
       - Extraction: Full-wave rectification (taking the absolute value + low-pass filtering).

## Forward-modeling

> The word "forward" denotes that the extracellular potentials are modeled from known neural sources. 

The "measurement physics", i.e., the link between neural activity and what is measured, is **well-understood**. The last decade has seen the reﬁnement of a well-founded biophysical forward-modeling scheme based on **volume conduction theory** {% cite rall1968theoretical holt1999electrical --file papers_aio %} to incorporate detailed reconstructed neuronal morphologies in precise calculations of extracellular potentials both **spikes** {% cite holt1999electrical gold2006origin gold2007using pettersen2008amplitude pettersen2008estimation schomburg2012spiking reimann2013biophysically --file papers_aio %} and **LFPs** {% cite einevoll2007laminar pettersen2008estimation linden2010intrinsic linden2011modeling gratiy2011estimation schomburg2012spiking lkeski2013frequency reimann2013biophysically --file papers_aio %}.

### Simulation Software

- NEURON  {% cite Carnevale2006Jan --file papers_aio %}

- LFPy {% cite linden2014lfpy --file papers_aio %} 

    > Existing multicompartmental neuron models, available from databases like [ModelDB](https://modeldb.science/) {% cite hines2004modeldb --file papers_aio %}, can readily be adapted for use with the LFPy-package.


## Inverse-modeling

> The "inverse" problem of estimating the underlying sources from recorded potentials is relatively ill-posed.

### Inferring SUA from LFP

{% cite Hall2014Nov --file papers_aio %} 

- [Methods](https://www.nature.com/articles/ncomms6462#Sec10)
   - Wrist torque-controlled task
   - Low-frequency LFP (**lf-LFP**) (<5Hz)
   - Multiple-input, multiple-output (MIMO) module 

{% cite Rule2015Jun --file papers_aio %}

- [Methods](https://sci-hub.se/10.3389/fnsys.2015.00089)
  - Free-Reach and Grasp (FRG)
  - Multiple frequency bands
  - Generalized linear point process model, Negative log-likelihood under L2 regularization (using gradient descent)

{% cite Manning2009Oct --file papers_aio %}

- [Methods](https://www.jneurosci.org/content/29/43/13613#sec-2)
  - Recordings were obtained in widespread brain regions including the frontal cortex, posterior cortex (occipital and parietal cortices), amygdala, hippocampus, and parahippocampal region
  - The primary objective was to examine how the firing rates of individual neurons related to narrowband changes (i.e., oscillations) and broadband changes in the LFP.
  - Wavelets Transform (Morlet wavelets)

### Inferring MUA/MSP from LFP

{% cite Bansal2011Apr --file papers_aio %}

- [Methods](https://sci-hub.se/10.1152/jn.00532.2010)
  - Continuous grasping task
  - Low-frequency LFP (**lf-LFP**)
  - Savitzy Golay filter (2nd order, 0.5 s)

{% cite Rasch2008Mar --file papers_aio %}

- [Methods](https://sci-hub.se/10.1152/jn.00919.2007)
  - The primary visual cortex (V1)
  - Multiple frequency bands
  - Support Vector Machine (SVM) and  standard linear regression



### Inferring ESA from LFP

{% cite Ahmadi2021Sep --file papers_aio %}

- [Methods](https://www.nature.com/articles/s41598-021-98021-9#Sec8)
  - Point-to-point task and Reach-to-grasp task
  - Multiple frequency bands
  - Multivariate multiple linear regression (MLR)



### Inferring Morphology (Single Neuron) from LFP

{% cite Chen2021 --file papers_aio %}

- [Methods](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9040040/#:~:text=Go%20to%3A-,II.%E2%80%83Method,-A.%20In%20vivo)
  - Sequential Neural Posterior Estimation (Bayesian-based)
  - Better performance when extending the parameter set $$ (x, y, z, \phi,\lambda) \longrightarrow (x, y, z, \phi,\lambda, R_s, L_t, R_t) $$ 
    - Location $$ (x, y, z) $$
    - Orientation $$ (\phi, \lambda) $$
    - Soma radius $$ R_s $$; Trunk length $$ L_t $$; Trunk radius $$ R_t $$;
  - CNN for further improvement

### Inferring Spatial Information from LFP

#### Cortical Column/Hypercolumn

The term "cortical column" is a complex and evolving concept, reflecting the ever-increasing understanding of the brain's intricate structure and function. While one of the definitions, encompassing "interconnected neurons with common input, common output, and common response properties extending through the thickness of the cortex," serves as a useful starting point for inferencing spatial locations from LFP. {% cite Molnar2020Jan --file papers_aio %}

#### The Size of Hypercolumn and Minicolumn

A cortical column is a group of neurons forming a cylindrical structure through the cerebral cortex of the brain perpendicular to the cortical surface. The columnar functional organization, as originally framed by {% cite Mountcastle1957Jul --file papers_aio %}, suggests that neurons that are horizontally more than **0.5 mm (500 µm)** from each other do not have overlapping sensory receptive fields, and other experiments give similar results: **200–800 µm** {% cite Buxhoeveden2002May Hubel1977Sep Leise1990Jan --file papers_aio %}.

A cortical minicolumn (also called cortical microcolumn) is a vertical column through the cortical layers of the brain. Minicolumns comprise perhaps **80–120 neurons**, except in the Primate Primary Visual Cortex (V1), where there are typically more than twice the number. There are about $$ 2 \times 10^8 $$ minicolumns in humans {% cite Johansson2007 --file papers_aio %}. The diameter of a minicolumn is about **28–40 μm** {% cite Mountcastle1957Jul --file papers_aio %}.

Neurons within a minicolumn (microcolumn) encode similar features, whereas a hypercolumn "denotes a unit containing a full set of values for any given set of receptive field parameters" {% cite Horton2005Apr --file papers_aio %}.

Assume the LFP reach is a circle of radius $$ R $$; hypercolumn is a point, located at the center of a hexagon of edge width $$ W $$, then the spacing between two hypercolumns are $$ \sqrt{3}W $$;

$$
N_{hypercolumn} = \frac{\pi R^2}{ \frac{3\sqrt{3}}{2}W^2 } \approx 1.21 \times (\frac{R}{W})^2
$$

| LFP Reach ($$ R (\mu m) $$) | Cortical Column Spacing ($$ \sqrt{3}W (\mu m) $$) | $$ N_{hypercolumn} $$ |
| :-------------------------: | :-----------------------------------------------: | :-------------------: |
|            1000             |                        200                        |         90.74         |
|            1000             |                        300                        |         40.33         |
|             500             |                        200                        |         22.69         |
|             500             |                        300                        |         10.08         |

## Reference

{% bibliography --cited --file papers_aio %}