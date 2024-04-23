---
comments: true
title: Hopfield Networks
date: 2024-04-23 12:00:00
image:
    path: /assets/img/images_preview/HopfieldNetworks.png
math: true
categories: [Machine Learning, Recurrent Neural Network]
tags: [machine-learning, recurrent-neural-network, rnn, hopfield-network]
---

## The Hopfield Network

### Neurons

Binary threshold neurons: $$ V_i \in \{ 0, 1 \} \text{ or } \{-1, 1 \}$$

$$
V_i =
\begin{cases}
	-1, \text{ Not firing} \\
	+1, \text{ Firing at maximum rate} \\
\end{cases}
$$

$$
V_i =
\begin{cases}
	0, \text{ Not firing} \\
	1, \text{ Firing at maximum rate} \\
\end{cases}
$$

### Connections

Neurons in a Hopfield network are **fully connected** to each other. This means every neuron is connected to every other neuron, including itself.

### Update Rules

$$
V_i \leftarrow
\begin{cases}
	-1, \text{ if } \sum_{j \neq i} w_{ij}V_j < U_i \\
	+1, \text{ if } \sum_{j \neq i} w_{ij}V_j > U_i \\
\end{cases}, V_i \in \{ -1, +1 \}
$$

$$
V_i \leftarrow
\begin{cases}
	0, \text{ if } \sum_{j \neq i} w_{ij}V_j < U_i \\
	1, \text{ if } \sum_{j \neq i} w_{ij}V_j > U_i \\
\end{cases}, V_i \in \{ 0, 1 \}
$$

- **Asynchronous**: Only one unit is updated at a time. This unit can be picked at random, or a pre-defined order can be imposed from the very beginning.
- **Synchronous**: All units are updated at the same time. This requires a central clock to the system in order to maintain synchronization. This method is viewed by some as less realistic, based on an absence of observed global clock influencing analogous biological or physical systems of interest.

### Learning Rules

For $$ N $$ neurons $$ 1, 2, 3, \dots, N $$

- $$ \textbf{V} $$ records the state of the network of $$ N $$ bits at a discrete time $$ \textbf{V} = \{V_1, V_2, \dots, V_N \} $$
- $$ \textbf{V}^{(s)} $$ records the states of the network at $$ n $$ discrete times $$ s=1, 2, 3, \dots, n $$

The Hebbian Learning rule: "Cells that fire together, wire together."

$$
w_{ij} = 
\begin{cases}
	\sum\limits_s \textbf{V}_i^{(s)} \textbf{V}_j^{(s)}, \text{} (w_{ii}=0, V_i \in \{-1, +1 \}) \\
	\sum\limits_s (2\textbf{V}_i^{(s)} - 1) (2\textbf{V}_j^{(s)} - 1), \text{} (w_{ii}=0, V_i \in \{0, 1 \})
\end{cases}
$$

$$
\textbf{W} = \sum_s \textbf{V}^{(s)}(\textbf{V}^{(s)})^T = \sum_s
	\begin{bmatrix}
        0 & w_{12} & w_{13} & \dots & w_{1N} \\
        w_{21} & 0 & w_{23} & w_{24} & w_{2N} \\
        w_{31} & w_{32} & 0 & w_{34} & w_{3N} \\
        \vdots & \vdots & \vdots & \ddots & \vdots \\
        w_{N1} & w_{N2} & w_{N3} & \dots & 0 \\
    \end{bmatrix}_{s=1, 2, 3, \dots, n}
$$

### Energy Function

> This energy function belongs to a general class of models in physics under the name of [Ising models](https://en.wikipedia.org/wiki/Ising_model); these in turn are a special case of [Markov networks](https://en.wikipedia.org/wiki/Markov_networks), since the associated [probability measure](https://en.wikipedia.org/wiki/Probability_measure), the [Gibbs measure](https://en.wikipedia.org/wiki/Gibbs_measure), has the [Markov property](https://en.wikipedia.org/wiki/Markov_property).
{: .prompt-tip }

$$
E = - \frac{1}{2} \mathop{\sum\sum}\limits_{j \neq i} w_{ij} V_i V_j
$$

$$
\Delta E = - \Delta V_i \sum\limits_{j \neq i} w_{ij} V_j
$$

### Emergent Collective Properties

1. For small $$ N=30 $$, the system never displayed an ergodic wandering through state space.
2. Simple cycle also occurred ocassionally. ($$ \dots \rightarrow A \rightarrow B \rightarrow A \rightarrow B \rightarrow \dots $$).
3. Chaotic wandering in a small region of state space.

> 1. Theflow in phase space produced by this model algorithm has the properties necessary for a physical content-addressable memory **whether or not $$ w_{ij} $$​ is symmetric**.
> 2. About **0.15 N** states can be simultaneously remembered before error in recall is severe.
> 3. The phase space flow is apparently dominated by **attractors**, which are the nominally assigned memories, each of which dominates a substantial region around it. The flow is not entirely deterministic, and the system responds to anmbiguous starting state by a statistical choice between the memory states it most resembles.
{: .prompt-info}

## Miscellaneous

### Content-addressable Memory

The **physical meaning** of content-addressable memory is described by **an appropriate phase space flow of the state of a system**. Emergent Collective Properties of such systems:

- Can correctly yield an entire memory from any subpart of sufficient size;
- Asynchronous parallel processing;
- Generalization;
- Familiarity recognition;
- Categorization;
- Error correction;
- Time sequence retention.
- Weakly sensitive to detailes of the modeling and/or failure of individual devices.

> In many physical systems, the nature of the emergent collective properties is insensitive to the details inserted in the model (e.g., collisions are essential to generate sound waves, but any reasonable interatomic force law will yield appropriate collisions).
> {: .prompt-tip }

### Monte Carlo Calculations

Monte Carlo methods vary, but tend to follow a particular pattern:

1. Define a domain of possible inputs;
2. Generate inputs randomly from a probability distribution over the domain;
3. Perform a **deterministic** computation of the outputs;
4. Aggregate the results.

![](https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Pi_monte_carlo_all.gif/435px-Pi_monte_carlo_all.gif){: style="max-width: 435px; height: auto;"}

### Hanmming Distance

The number of places in which the digits are different. 

- [Hamming Code](https://en.wikipedia.org/wiki/Hamming_code)
- [Hamming Distance](https://en.wikipedia.org/wiki/Hamming_distance)
