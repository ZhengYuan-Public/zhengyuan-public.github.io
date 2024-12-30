---
comments: true
title: Reinforcement Learning Notes
date: 2024-10-01 12:00:00
image:
    path: /assets/img/images_preview/ReinforcementLearningPreview2.png
math: true
categories: [Machine Learning, Reinforcement Learning]
tags: [machine-learning, reinforcement-learning]
---

---
## Recap of [RL Mathematics]({{ site.baseurl }}{% post_url 2024-09-09-MathematicalFoundationsOfReinforcementLearning %})

### Basics

> 🐾 Basics take the **Non-incremental Form**, **Tabular Representation**, and are **Value-based**.
{: .prompt-tip }

#### Bellman Equation

$$
G_t = R_{t+1} + \gamma G_{t+1}
$$

#### State Value and Action Value

$$
\begin{align}
\textcolor{red}{v_{\pi}(s)} 
    &= \mathbb{E}[G_t \vert S_t = s] \nonumber\\
    &= \mathbb{E}[R_{t+1} \vert S_t = s] + \gamma \mathbb{E} [G_{t+1} \vert S_t = s] \nonumber\\
    &= \sum_{a \in \mathcal{A}} \pi (a \vert s) [\sum_{r \in \mathcal{R}} p(r|s, a) r + \gamma \sum_{s' \in \mathcal{S}} p(s'   \vert s, a) v_{\pi}(s') ], \textcolor{green}{\forall s \in S}. \nonumber\\
    &= \sum_{a \in \mathcal{A}} \pi (a \vert s) \textcolor{red}{q_{\pi}(s, a)} \nonumber
\end{align}
$$

#### Bellman Optimality Equation

$$
\begin{align}
    v_{\pi}(s)
    &= \textcolor{red}{\max_{\pi}} \sum_{a} \textcolor{red}{\pi (a \vert s)} (\sum_{r} p(r|s, a) r + \gamma \sum_{s'} p(s' \vert s, a) v_{\pi}(s')) \nonumber\\
    & = \textcolor{red}{\max_{\pi}} \sum_{a} \textcolor{red}{\pi (a \vert s)} q(s, a) \nonumber
\end{align}
$$

#### Sovling Bellman Optimality Equation

##### Model-based

$$
\begin{alignat}{2}
v_{\pi 1}^{(0)} &= v_0 \nonumber\\
v_{\pi 1}^{(1)} &= r_{\pi 1} + \gamma P_{\pi 1} v_{\pi 1}^{(0)} &&\longrightarrow v_1 \longrightarrow \text{Value Iteration} \nonumber\\
v_{\pi 1}^{(2)} &= r_{\pi 1} + \gamma P_{\pi 1} v_{\pi 1}^{(1)} \nonumber\\
\vdots \nonumber\\
v_{\pi 1}^{(j)} &= r_{\pi 1} + \gamma P_{\pi 1} v_{\pi 1}^{(j-1)} &&\longrightarrow \bar{v}_1 \longrightarrow \text{Truncated Policy Iteration} \nonumber\\
\vdots \nonumber\\
v_{\pi 1}^{(\infty)} &= r_{\pi 1} + \gamma P_{\pi 1} v_{\pi 1}^{(\infty)} &&\longrightarrow v_{\pi 1} \longrightarrow \text{Policy Iteration} \nonumber
\end{alignat}
$$

##### Model-free

###### Monte Carlo

$$
\begin{alignat}{2}
q_{\pi}(s, a) 
&= \mathbb{E}[G_t \vert S_t = s, A_t = a] &&\longrightarrow \text{Model-free} \nonumber\\
&= \sum_{r} p(r|s, a) r + \gamma \sum_{s'} p(s' \vert s, a) v_{\pi}(s') &&\longrightarrow \text{Model-based} \nonumber
\end{alignat}
$$

1. Policy Evaluation: Estimate $$ q_{\pi_k}(s, a) $$ directly, instead of sovling $$ v_{\pi_k}(s) $$
2. Policy Improvement: Same as Policy Iteration

### Incrementral Form

> 🐾 Shifting from the **Non-incremental Form** to the **Incremental Form**.
{: .prompt-tip }

#### TD Learning

> **Stochatic Approximation**.
{: .prompt-info }

> A special Stochastic Approximation algorithm for estimating **State Value**.
{: .prompt-info }

$$
\underbrace{v_{t+1}(s_t)}_{\text{New Estimation}} 
    = \underbrace{v_t(s_t)}_{\text{Current Estimation}} 
        - \alpha_t(s_t) \overbrace{[v_t(s_t) - \underbrace{(r_{t+1} + \gamma v_t(s_{t+1}))}_{\text{TD Target }\bar{v}_t}]}^{\text{TD Error } \delta_t}
$$

#### Sarsa

> TD Learning for **Action Value**.
{: .prompt-info }

$$
\begin{align}
q_{t+1}(s_t, a_t) &= q_t(s_t, a_t) - \alpha_t(s_t, a_t) [q_t(s_t, a_t) - [r_{t+1} + \gamma q_t(s_{t+1}, a_{t+1})]] \nonumber\\
q_{t+1}(s, a) &= q_t(s, a), \forall (s, a) \neq (s_t, a_t) \nonumber
\end{align}
$$

$$
\begin{alignat}{2}
G_t &= \gamma^{0}R_{t+1} + \gamma^{1}q_{\pi}(S_{t+1}, A_{t+1}) &&\longrightarrow \text{Sarsa} \nonumber\\
G_t &= \gamma^{0}R_{t+1} + \gamma^{1}R_{t+2} + \gamma^{2} q_{\pi}(S_{t+2}, A_{t+2})\nonumber\\
    &\vdots \nonumber\\
G_t &= \gamma^{0}R_{t+1} + \gamma^{1}R_{t+2} + \cdots + \gamma^{n}q_{\pi}(S_{t+n}, A_{t+n}) &&\longrightarrow n\text{-Step Sarsa} \nonumber\\
    &\vdots \nonumber\\
G_t &= \gamma^{0}R_{t+1} + \gamma^{1}R_{t+2} + \gamma^{2}R_{t+3} + \cdots &&\longrightarrow \text{Monte Carlo} \nonumber
\end{alignat}
$$

#### Q-Learning

> TD Learning for **Optimal Action Value**.
{: .prompt-info }

$$
\begin{align}
q_{t+1}(s_t, a_t) &= q_t(s_t, a_t) - \alpha_t(s_t, a_t) [q_t(s_t, a_t) - [r_{t+1} + \gamma \max_{a \in \mathcal{A}}(s_{t+1}, a)]] \nonumber\\
q_{t+1}(s, a) &= q_t(s, a), \forall (s, a) \neq (s_t, a_t) \nonumber
\end{align}
$$

### Function Representation

> 🐾 Shifting from the **Tabular Representation** to the **Function Representation**.
{: .prompt-tip }

#### DQN

$$
\begin{align}
J(w) &= \mathbb{E}[(R + \gamma \max_{a \in \mathcal{A}(S')}\textcolor{red}{\hat{q}(S', a, w)} - \textcolor{blue}{\hat{q}(S, A, w)})^2] \nonumber \\
J(w) &= \mathbb{E}[(R + \gamma \max_{a \in \mathcal{A}(S')}\textcolor{red}{\hat{q}(S', a, w_T)} - \textcolor{blue}{\hat{q}(S, A, w)})^2] \nonumber
\end{align}
$$

$$
\nabla_w J(w) = \mathbb{E} [(R + \gamma \max_{a \in \mathcal{A}(S')} \textcolor{red}{\hat{q}(S', a, w_T)} - \textcolor{blue}{\hat{q}(S, A, w)}) \nabla_w \textcolor{blue}{\hat{q}(S, A, w)}] \nonumber
$$

- DQN use the target network $$ \textcolor{red}{\hat{q}(S', a, w_T)} $$ and the main network $$ \textcolor{blue}{\hat{q}(S, A, w)} $$
- $$ w $$ updates constantly while $$ w_T $$ updates periodically

### Policy-based

> 🐾 Shifting from the **Value-based** to the **Policy-based**.
{: .prompt-tip }

#### Actor-Critic Method
##### QAC
##### A2C

#### Off-Policy Actor-Critic
##### Deterministic Policy Gradient (DPG)

---
## Papers

### Q-Learning
### TD Learning
### TD($$\lambda$$)
### Actor-Critic

### DQN
### TRPO
### A3C
### PPO
