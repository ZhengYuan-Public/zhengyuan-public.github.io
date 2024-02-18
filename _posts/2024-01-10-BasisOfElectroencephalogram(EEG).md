---
comments: true
title: Basis of Electroencephalogram (EEG)
date: 2024-1-10 12:00:00
image:
    path: /assets/img/images_neuroscience/cortical_pyramidal_cell-EPSP-IPSP.png
math: true
categories: [Neuroscience, Electrical Measurements, Electroencephalogram]
tags: [neuroscience, electroencephalogram, eeg]
---
## Introduction

Reference: [Introduction to EEG](https://www.ebme.co.uk/articles/clinical-engineering/introduction-to-eeg)

Standard Sensitivity: 7 µV/mm - 0.007 V/m

## EEG - Origin and Measurement

:notebook:EEG-fMRI: Physiological Basis, Technique, and Applications {% cite mulert2023eeg --file basis_eeg %}

The EEG consists of the **summed** electrical activities of **populations of neurons**, with a **modest contribution** from glial cells. The neurons are **excitable** cells with **characteristic intrinsic electrical properties**, and their activity produces **electrical and magnetic fields**.

### Two Types of Neuronal Activations

1. Action Potential
2. Synaptic Activation
   - EPSP
     - Positive ions inwards (e.g., $$ Na^+ $$)
   - IPSP
     - Negative ions inwards (e.g., $$ Cl^- $$)
     - Positive ions outwards (e.g., $$ K^+ $$)

### Sink-Source Configuration

![electrical_measurements_of_brain_activity](/assets/img/images_neuroscience/cortical_pyramidal_cell-EPSP-IPSP.png){: style="max-width: 600px; height: auto;"}

> There is **no accumulation of charge** anywhere in the medium, the transmembrane currents that flow in or out of the neuron at the active synaptic sites are **compensated** by currents that flow in the opposite direction elsewhere along the neuronal membrane.
{: .prompt-tip }

- Active **sink** is generated in the extracellular medium at the level of an **excitatory** synapse. **Distributed passive sources** along the soma-dendritic membrane.

- Active **source** is generated in the extracellular medium at the level of an **inhibitory** synapse. **Distributed passive sinks** along the soma-dendritic membrane.

- The flows of these compensating extracellularly currents depend on the **electrical properties** of the local tissue. Glial cells occupy an important part of the space between neurons and are coupled to one another by **<u>gap junctions</u>** (the conductivity is sensitive to changes in $$ pH $$, extracellular $$ K^+ $$ and $$ Ca^{2+} $$, and physiological/pathological conditions).

## Reference

{% bibliography --cited --file basis_eeg %}