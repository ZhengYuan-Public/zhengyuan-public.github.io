---
comments: true
title: Computer Vision Notes
math: true
image:
  path: https://images.ctfassets.net/3viuren4us1n/1Ghw96A2tcYRfRezOwtmjx/e646778f3f53e50ea3e857e9cdb23120/Computer_vision.jpg?fm=webp&w=1920
date: 2023-04-16 12:00:00
categories: [machine-learning, computer-vision]
tags: [machine-learning, computer-vision]
---

## Introduction

### Task description

Object detection is a computer technology related to computer vision and image processing that deals with detecting instances of semantic objects of a certain class

- The class of objects: unknown
- The number of objects: unknown

### Different types

One-stage method: faster, less accurate

Two-Stage method: slower, more accurate

### Intersection over Union

IoU a.k.a. Jaccard Index

$$
J(B_p, B_{gt}) = IoU = \frac{ B_p \cap B_{gt} }{B_p \cup B_{gt}}
$$

- $ B_p $: predicted bounding box
- $ B_{gt} $: ground-truth bounding box
- $ t $: threshold

$$
\begin{aligned}
	IoU &> t \rightarrow correct\\
	IoU &< t \rightarrow incorrect
\end{aligned}
$$

### Truth Table

- TP: A correct detection of ground-truth bounding box

- FP: In incorrect detection of ground-truth bounding box

- TN: **NOT APPLICABLE** because an infinite number of bounding boxes should not be detected

- The FN: An undetected ground truth bounding box

### Average Precision

Average Precision (AP) measures how well you can find true positives(TP) out of **all positive predictions** (TP+FP)

$$
AP_i = \frac{TP}{TP+FP}
$$

### Mean Average Precision

$$
mAP = \frac{1}{N} \sum_{i=1}^{N} AP_i
$$

### Recall Precision

Recall Precision measures how well you can find true positives (TP) out of **all predictions for ground truth** (TP+FN)

$$
Recall = \frac{TP}{TP+FN}
$$

### Invariance

[What is translation invariance in computer vision and convolutional neural networks?](https://stats.stackexchange.com/questions/208936/what-is-translation-invariance-in-computer-vision-and-convolutional-neural-netwo)

- Translation Invariance
- Rotation/Viewpoint Invariance
- Size Invariance
- Illumination Invariance

<img src="https://i.stack.imgur.com/iY5n5.png" alt="invariance" style="zoom:75%;" />

#### Invariance of CNN

- Translation Invariance :heavy_check_mark:
- Rotation/Scale Invariance :x:

### Receptive Field in CNN

<img src="/assets/img/images_cv/CNN_ReceptiveField.png" alt="RF" style="zoom: 30%;" />

The green area on layer 1 is the RF of the green pixel on layer 2

### 1x1 Convolution

It has some special properties that it can be used for:

- dimension reduction
- efficient low-dimensional embeddings
- applying non-linearity after convolutions

It maps an input pixel with all its channels to an output pixel which can be squeezed to a desired output depth $ \longrightarrow $ A Multi-Layer Perceptron (MLP) looks at a particular pixel

### Backbones, Neck, and Head

A typical workflow: Input image $ \longrightarrow $ Backbone $ \longrightarrow $ Neck $ \longrightarrow $ Head $ \longrightarrow $ Predictions

- Backbone: The backbone is a deep convolutional neural network that extracts features from the input image. It typically consists of several layers of convolutional and pooling operations, which progressively reduce the spatial resolution of the features while increasing their semantic complexity.
- Neck: The neck is an optional component that is used to fuse and refine the features extracted by the backbone. It typically consists of one or more layers that perform operations such as spatial pooling, convolution, and attention. The purpose of the neck is to enhance the features extracted by the backbone, making them more suitable for object detection tasks. Examples of popular neck architectures include FPN, PAN, and NAS-FPN.
- The head is responsible for predicting the bounding boxes and labels of objects in the image. It takes the features extracted by the backbone and refined by the neck, and uses them to make object detection predictions. The head typically consists of one or more fully connected layers that predict the class probabilities and bounding box coordinates of the objects in the image. Examples of popular head architectures include Faster R-CNN, YOLO, and SSD.

### Semantic Segmentation vs. Instance Segmentation

- Semantic Segmentation: classify each pixel into a fixed set of categories ***without*** differentiating object instances
- Instance Segmentation: ... ***with*** ...

### Entropy

#### Entropy

$$
S = k_B ln \Omega
$$

- Entropy is a measure of probability and the molecular **disorder** of a macroscopic system.
- $ k_B = 1.380649 \times 10^{-23} J \cdot K^{-1} $ is Boltzmann's constant

#### Shannon Entropy

$$
H(X) = - \sum_{i} p(x_i)log(p(x_i)) = E(-logP(X))
$$

- Measures the uncertainty of a probability distribution
- base 2: bits/Shannons
- base $ e $: nat (natural units)
- base 10: dits/bans/hartleys

#### KL Divergence (Relative Entropy)

- (Usually) $ P $ $ \longrightarrow $ the data, ground truth, ...
- (Usually) $ Q $ $ \longrightarrow $ a theory, a model, an approximation of $ P $, ...
- $ P $ and $ Q $ can be reversed where that is easier to compute
- The Kullback–Leibler divergence is then interpreted as the average difference of the number of bits required for encoding samples of $ P $ using a code optimized for $ Q $ rather than one optimized for $ P $.

For discrete ***r.v.***

$$
D_{KL}(P\ ||\ Q)=\sum_{i} P(i) log \frac{P(i)}{Q(i)}
$$


For continuous ***r.v.***

$$
D_{KL}(P\ ||\ Q)=\int P(x) log \frac{P(x)}{Q(x)}dx
$$

#### Cross Entropy

$$
H(P^*|P)= - \sum_{i} P^*(i)logP(i)
$$

- Ground Truth Distribution: $ P^* $, Model Distribution: $ P $
- Input $ \longrightarrow $ Model Distribution $ \longrightarrow $ Ground Truth Distribution
- $ x_i \longrightarrow P(y \| x_i; \Theta) \longrightarrow P^*(y \| x_i) $

#### From KL Divergence to Cross Entropy

$$
\begin{aligned}
D_{KL}(P^*(y|x_i)\ ||\ P(y|x_i; \Theta)) &= \sum_{y} P^*(y|x_i) log \frac{P^*(y|x_i)}{P(y|x_i; \Theta)} \\
			&= \sum_{y} P^*(y|x_i)[logP^*(y|x_i) - logP(y|x_i; \Theta)] \\
			&= \sum_{y} P^*(y|x_i)logP^*(y|x_i) - \underbrace{\sum_{y} P^*(y|x_i)logP(y|x_i; \Theta)}_{Cross \ Entropy}
\end{aligned}
$$

- The first term $ \sum_{y} P^*(y \| x_i)logP^*(y \| x_i) $ does not depend on $ \Theta $ 
- The second term $ - \sum_{y} P^*(y \| x_i)logP(y \| x_i; \Theta) $ is the cross entropy

## Two-Stage Algorithms

---

### R-CNN {% cite girshick2014rich --file papers_cv %}

#### Some Insights

- Localize and Segment object: apply high-capacity convolutional neural networks to bottom-up region proposals
- A paradigm for training large CNNs when ***labeled data is scare***
  - Pre-train the network for an auxiliary task with abundant data (with supervision)
  - Fine-tune the network for the target task where data is scare

#### Model Architecture

- Region proposal: selective search (about 2k)

- Feature extractor: 4096-dimensional feature vector from **AlexNet**

- Classifier: class-specific linear SVM

- Bounding box (bbox) regression

- IoU threshold has a great impact on mAP. (Use grid search)

#### Object Proposal Transformation

- Mean-subtracted $ 227 \times 227 $ RGB images
- **Context Padding** outperformed the alternatives by $ 3-5 $ mAP

---

### SPP-net {% cite he2015spatial --file papers_cv %}

#### Problems Addressed

- **Fixed-size inputs** are *artificial requirement*
- **Conv** layers do ***NOT*** require a fixed image size
- **FC** layer does require fixed-size/length input by definition
- **Cropping** may not contain the object
- **Warping** may cause unwanted geometric distortion

#### SPP Layer

<img src="/assets/img/images_cv/SPP_Layer.png" alt="SPP-layer" style="zoom:40%;" />

- Replace the last pooling layer with an SPP layer
- (Max) Pool the responses of each filter
- For each feature map, pool it into shape $ [4, 4], [2, 2], [1] $, flatten them into 1-d and concatenate them into a fixed-length vector
- For a feature map of size [a, a] and a desired output shape [n, n]: the size of sliding window $ L = \lceil \frac{a}{n} \rceil $ and the size of the stride $ S = \lfloor \frac{a}{n} \rfloor $

#### Mapping RoI to Feature Maps (RoI Projection)

Project the **corner point of a RoI** onto a **pixel in the feature maps** such that this corner point in the image domain is **closest to the center of the receptive field** of that feature map pixel

- Padding $\lfloor p/2 \rfloor$ pixel for a layer with a filter size of $p$ (for simplicity)
- For a response center {$ (x', y') $} on feature maps, its effective RF in the image domain is centered at {$ (x, y) = (Sx', Sy') $} where S is the product of all previous strides.

---

### Fast R-CNN {% cite girshick2015fast --file papers_cv %}

#### Model Architecture

<img src="/assets/img/images_cv/Fast_R-CNN_architecture.png" alt="Fast R-CNN" style="zoom:50%;" />

#### RoI Pooling

- Region of Interest Pooling (RoI Polling) layer is a special case of SPP layer (only one level in RoI Pooling)
- Transformations of Pre-trained networks
  - Last pooling layer $ \longrightarrow $ RoI polling layer
  - Last FC and $ softmax_K $ $ \rightarrow $ FC (for bbox regression) and $ softmax_{K+1} $ (+1 for catch-all "background" class)
  - Take two data inputs: a list of images and a list of RoIs in them
  

#### Multitask Loss

$$
\begin{aligned}
p &= (p_0, ..., p_K), t^k = (t_x^k, t_y^k, t_w^k, t_h^k,) \\
L(p, u, t^u, v) &= L_{cls}(p, u) + \lambda[u \geq 1]L_{loc}(t^u, v)
\end{aligned}
$$

#### Large FC layer acceleration with truncated SVD

[Beginners Guide To Truncated SVD For Dimensionality Reduction](https://analyticsindiamag.com/beginners-guide-to-truncated-svd-for-dimensionality-reduction/)

The number of parameters is reduced from $ uv $ to $ t(u+v) $ 

$$
W \approx U \sum_{t}V^T
$$


---

### Faster R-CNN {% cite ren2015faster --file papers_cv %}

#### Key Terms

- Problem: **Region Proposal** is a bottleneck for SSP-net and Fast R-CNN

- Cost-free Region Proposals: Region Proposal Network (**RPN**) is a Fully Convolutional Network (**FCN**) that simultaneously predicts bounding boxes and object class which **shares full-image convolutional features** with the detection network.

#### Model Architecture

<img src="/assets/img/images_cv/Faster-R-CNN-1.png" alt="ModelArchitecture" style="zoom:40%;" />

- Modules
  - RPN (a deep FCN) $ \longrightarrow $ Region Proposal (equivalent to "attention" mechanism)
  - Fast R-CNN detector

#### RPN

<img src="/assets/img/images_cv/Faster-R-CNN-2.png" alt="ModelArchitecture" style="zoom:30%;" />

Share Computation $ \Longleftrightarrow $ Sharing Conv Layers with Fast R-CNN 

- Take an image (**any size**) as input and output a set of **rectangular object proposals** with "objectness" score (belongs to an object class vs. background $ \longrightarrow $ binary label)
- Slide a window over feature maps of last conv layer. Each sliding window is mapped to a lower-dimensional feature (eg., 256-d). This feature is fed to 1) bbox regression layer and 2) bbox classification layer
- Anchors
  - Center coordinates, Scale, and Aspect Ratio
  - Translation Invariant


#### Training RPN

##### Binary Class Label

- Positive: anchor(s) with max $ IoU $ , or $ IoU > 0.7 $
- Negative: $ IoU < 0.3 $

##### Loss Function

$$
L({p_i}, {t_i}) = \frac{1}{N_{cls}}  \sum_{i} L_{cls}(p_i, p_i^*) + \lambda \frac{1}{N_{reg}} \sum_{i} p_i^* L_{reg}(t_i, t_i^*)
$$

- $ p_i $: predicted label,  $ p_i^* $: ground truth label
- $ t_i $: predicted bbox,  $ t_i^* $: ground-truth bbox

##### Share Computation $ \Longleftrightarrow $ Sharing Conv Layers with Fast R-CNN

- Alternating Training
  - Train RPN $ \longrightarrow $ PoI Proposals $ \longrightarrow $ Train Fast R-CNN $ \longrightarrow $ Initialize RPN
- Approximate Joint Training
  - Merge RPN and Fast R-CNN into one network
  - Close results & reduce traininng time by $ 25-50 \% $
- Non-approximate Training
  - Differentiable RoI layer $ w.r.t. $ the bbox coordinates
- 4-Step Alternating Training
  - Train RPN $ \longleftarrow $ Initialized with an ImageNet-pre-trained and finetuned end-to-end for the region proposal task
  - Train a separate detector network with Fast R-CNN using proposals from last step
  - Initialize RPN with the detector network from last step
  - Fix shared conv layers and only fine-tune layers unique to RPN

#### Recall-to-IoU

- Recall-to-IoU is *loosely* related to the ultimate detection accuracy
- More of a **diagnostic** than evaluative metric


---

### R-FCN  {% cite dai2016r --file papers_cv %}

[Understanding Region-based Fully Convolutional Networks (R-FCN) for object detection](https://jonathan-hui.medium.com/understanding-region-based-fully-convolutional-networks-r-fcn-for-object-detection-828316f07c99)

#### Key Ideas

- Intuition: The **location** of some feature might be **invariant** (eg. the location of the right eye can be used to locate the face)
- Common feature maps $ \longrightarrow $ Region-based feature maps
- (Zheng Yuan): Explicitly integrate a feature which is invariant (position in this case) into FCN

<img src="/assets/img/images_cv/R-FCN-1.png" alt="ModelArchitecture" style="zoom:40%;" />

<img src="/assets/img/images_cv/R-FCN-2.png" alt="ModelArchitecture" style="zoom:40%;" />

<img src="/assets/img/images_cv/R-FCN-3.png" alt="ModelArchitecture" style="zoom:40%;" />

---

### FPN {% cite lin2017feature --file papers_cv %}

---

### Deformable-CNN {% cite dai2017deformable --file papers_cv %}

---

### Mask R-CNN {% cite he2017mask --file papers_cv %}

---

### RoI Transformer {% cite ding2019learning --file papers_cv %}

---

### ReDet {% cite han2021redet --file papers_cv %}

---

### Point R-CNN {% cite zhou2022point --file papers_cv %}

---

### Vision Transformer {% cite dosovitskiy2020image --file papers_cv %}

---

### Swin Transformer {% cite liu2021swin --file papers_cv %}

---

### RST-CNN {% cite gao2021deformation --file papers_cv %} 

---

### ConvNeXt {% cite liu2022convnet --file papers_cv %} 

## One-Stage Algorithms

## Reference

---

{% bibliography --file papers_cv %}
