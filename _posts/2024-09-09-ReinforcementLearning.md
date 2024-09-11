---
comments: true
title: Reinforcement Learning
date: 2024-09-08 12:00:00
image:
    path: /assets/img/images_preview/ReinforcementLearning.webp
math: true
categories: [Machine Learning, Reinforcement Learning]
tags: [machine-learning, reinforcement-learning]
---

## Basic Concepts

1. **State**: The status of the agent with respect to the environment.
    - State Space: The set of all states.
    - \$$ \mathcal{S} = \{s_i\}_{i=1}^{n} $$
2. **Action**: All posible actions for each state.
    - Action Space: The set of all possible actions of a state.
    - \$$ \mathcal{A}(s_i) = \{a_i\}_{i=1}^{n} $$
3. **State Transition**: When taking an action, the agent may move from one state to another.
    - \$$ s_1 \xrightarrow{a_1} s_2 $$
    - Defines the interaction with the environment.
4. **Policy**: Tells the agent what actions to take at a state.
    - Mathematical representation: conditional probability
5. **Reward**: A real number the agent get after taking an action.
    - Depends on the **current** state and action, not the ~~**next**~~ one.
6. **Trajectory**: A state-action-reward chain.
    - \$$ s_1 \xrightarrow[r=0]{a_1} s_2 \xrightarrow[r=0]{a_2} s_3 \xrightarrow[r=0]{a_3} s_4 $$
7. **Return**: The sum of all the rewards collected along a trajectory.
8. **Discount rate**: \$$ \gamma \in [0, 1] $$
    - \$$ R_{discounted} = \gamma^0 r_1 + \gamma^1 r_2 + \dots $$
    - Balance the far $$ (\gamma \rightarrow 1) $$ and near $$ (\gamma \rightarrow 0) $$ future rewards.
9. **Episode/Trial**: The resulting trajectory when an agent stop at some terminal state.
    - Episodic v.s. Continuing Tasks.
    - Episodic tasks can be converted to Continuing Tasks.

### Example: Markov Decision Process (MDP)

1. Sets
    - State: $$ \mathcal{S} $$
    - Action: $$ \mathcal{A}(s_i) $$
    - Reward: $$ \mathcal{R(s, a)} $$
2. Probability Distributions
    - State Transition Probability: $$ p(s' \vert s, a) $$
    - Reward Probability: $$ p(r \vert s, a) $$
3. Policy: At state $$ s $$, the probability to choose the action $$ a $$ is $$ \pi (a \vert s) $$
4. Markov Property: memoryless
    - \$$ p(s_{t+1} \vert a_{t+1}, s_t, \dots, a_1, s_0) = p(s_{t+1} \vert a_{t+1}, s_t) $$
    - \$$ p(r_{t+1} \vert a_{t+1}, s_t, \dots, a_1, s_0) = p(r_{t+1} \vert a_{t+1}, s_t) $$

## Bellman Equation

### Return

#### Bootstraping of Returns

$$
\displaylines{
    \textcolor{red}{v_1} = r_1 + \gamma v_2\\
    v_2 = r_1 + \gamma v_3\\
    v_3 = r_1 + \gamma v_4\\
    v_4 = r_1 + \gamma \textcolor{red}{v_1}
}
$$

#### Matrix-vector Form

$$
\underbrace{\begin{bmatrix} v_1 \\ v_2 \\ v_3 \\ v_4 \\ \end{bmatrix}}_{v}
    = \underbrace{\begin{bmatrix} r_1 \\ r_2 \\ r_3 \\ r_4 \\ \end{bmatrix}}_{r} + \gamma \underbrace{\begin{bmatrix} 0 & 1 & 0 & 0 \\ 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 1 \\ 1 & 0 & 0 & 0 \\ \end{bmatrix}}_{P} \underbrace{\begin{bmatrix} v_1 \\ v_2 \\ v_3 \\ v_4 \\ \end{bmatrix}}_{v}
$$

$$
\begin{align}
    v &= r + \gamma P v \nonumber\\
    (I - \gamma P) v &= r \nonumber
\end{align}
$$

### State Value

Consider the following multi-step trajectory:

$$
S_t \xrightarrow[]{A_t} R_{t+1}, S_{t+1} \xrightarrow[]{A_{t+1}} R_{t+2}, S_{t+2} \xrightarrow[]{A_{t+2}} R_{t+3}, S_{t+3} \xrightarrow[]{} \dots
$$

where:

- $$ S_t \rightarrow A_t $$ is governed by $$ \pi (A_t = a \vert S_t = s) $$
- $$ S_t, A_t \rightarrow R_{t+1} $$ is governed by $$ p(R_{t+1} = r \vert S_t = s, A_t = a) $$
- $$ S_t, A_t \rightarrow S_{t+1} $$ is governed by $$ p(S_{t+1} = s' \vert S_t = s, A_t = a) $$

whose discounted return is:

$$
\begin{align}
G_t &= R_{t+1} + \gamma R_{t+2} + \gamma ^2 R_{t+3} + \dots \nonumber\\
    &= R_{t+1} + \gamma (R_{t+2} + \gamma R_{t+3} + \dots) \nonumber\\
    & = R_{t+1} + \gamma G_{t+1} \nonumber
\end{align}
$$

**State value** (or **state-value function**) is defined as the expectation of the discounted return

$$
\begin{align}
v(\pi, s) \rightarrow v_{\pi}(s) &= \mathbb{E}[G_t \vert S_t = s] \nonumber\\
&= \mathbb{E}[R_{t+1} + \gamma G_{t+1} \vert S_t = s] \nonumber\\
&= \underbrace{\mathbb{E}[R_{t+1} \vert S_t = s]}_{\text{Term I}} + \underbrace{\gamma \mathbb{E} [G_{t+1} \vert S_t = s]}_{\text{Term I}} \nonumber
\end{align}
$$

- State value describe *how valuable a state is*.
- The mean of all possible returns.

### Bellman Equation

#### Term I

$$
\begin{align}
\mathbb{E}[G_t \vert S_t = s] &= \sum_{a} \pi (a \vert s) \mathbb{E} [R_{t+1} \vert S_t = s, A_t = a] \nonumber\\
    &= \sum_{a} \pi (a \vert s) \sum_{r} p(r|s, a) r \nonumber
\end{align}
$$

- At state $$ s $$ there are actions $$ {a_i} $$ and the probability to take an action $$ a $$ is $$ \pi (a \vert s) $$
- After taking action $$ a $$, the return is $$ \mathbb{E} [R_{t+1} \vert S_t = s, A_t = a] $$
- The mean of **immediate reward**.

#### Term II

$$
\begin{align}
\mathbb{E}[G_{t+1} \vert S_t = s] 
    &= \sum_{s'} p(s' \vert s) \mathbb{E}[G_{t+1} \vert \textcolor{red}{S_t = s}, S_{t+1} = s'] \nonumber\\
    &= \sum_{s'} p(s' \vert s) \mathbb{E}[G_{t+1} \vert S_{t+1} = s'] \nonumber\\
    &= \sum_{s'} p(s' \vert s) v_{\pi}(s') \nonumber\\
    &= \sum_{s'} v_{\pi}(s') \sum_{a} p(s' \vert s, a) \pi(a \vert s)  \nonumber
\end{align}
$$

- $$ \mathbb{E}[G_{t+1} \vert \textcolor{red}{S_t = s}, S_{t+1} = s'] = \mathbb{E}[G_{t+1} \vert S_{t+1} = s'] $$ since the return is not dependent on previous steps.
- $$ p(s' \vert s) = \sum_{a} p(s' \vert s, a) \pi(a \vert s) \longleftarrow $$ Law of total probability
- The mean of **future reward**.

#### Final form

$$
\begin{align}
    \textcolor{red}{v_{\pi}(s)}
    &= \mathbb{E}[R_{t+1} \vert S_t = s] + \gamma \mathbb{E} [G_{t+1} \vert S_t = s] \nonumber\\
    &= \sum_{a} \pi (a \vert s) \sum_{r} p(r|s, a) r + \gamma \sum_{s'} v_{\pi}(s') \sum_{a} p(s' \vert s, a) \pi(a \vert s) \nonumber\\
    &= \sum_{a} \pi (a \vert s) [\sum_{r} p(r|s, a) r + \gamma \sum_{s'} \textcolor{red}{v_{\pi}(s')} p(s' \vert s, a) ], \textcolor{green}{\forall s \in S}. \nonumber\\
    &= \sum_{a} \underbrace{\pi (a \vert s)}_{\text{A given policy}} [\sum_{r} \underbrace{p(r|s, a) r}_{\text{Dynamic model}} + \gamma \sum_{s'} \underbrace{p(s' \vert s, a)}_{\text{Dynamic model}} \textcolor{red}{v_{\pi}(s')} ], \textcolor{green}{\forall s \in S}. \nonumber
\end{align}
$$

- Solving the Bellman equation is called **Policy Evaluation**.

### Matrix-vector Form

$$
\begin{align}
    \textcolor{red}{v_{\pi}(s)}
    &= \sum_{a} \pi (a \vert s) (\sum_{r} p(r|s, a) r + \gamma \sum_{s'} p(s' \vert s) v_{\pi}(s')) \nonumber\\
    &= r_{\pi}(s) + \gamma \sum_{s'} p(s' \vert s) v_{\pi}(s'), \textcolor{green}{\forall s \in S} \nonumber\\

    \textcolor{red}{v_{\pi}(s_i)}
    &= r_{\pi}(s_i) + \gamma \sum_{s_j} p(s_j \vert s_i) v_{\pi}(s_j), \textcolor{green}{\forall s_i \in S} \nonumber\\
    &= r_{\pi} + \gamma P v_{\pi} \nonumber
\end{align}
$$

where

- $$ P \in \mathbb{R}^{n \times n}, P_{ij} = p(s_j \vert s_i) $$ is the **State Transition Matrix**.

### Solve Bellman Equation

#### Closed-form solution

$$
v_{\pi} = (I - \gamma P)^{-1} r_{\pi}
$$

#### Iterative solution

$$
v_{k+1} = r_{\pi} + v_{k}
$$

- It can be proved: $$ v_k \rightarrow v_{\pi} = (I - \gamma P)^{-1} r_{\pi}, k \rightarrow \infty $$.

### Action Value

$$
\begin{align}
q(\pi, s, a) \rightarrow q_{\pi}(s, a) 
&= \mathbb{E}[G_t \vert S_t = s, A_t = a] \nonumber\\
&= \underbrace{\mathbb{E}[G_{t} \vert S_t = s]}_{v_{\pi}(s)} \nonumber\\
&= \sum_{a} \pi(a \vert s) \underbrace{\mathbb{E}[G_t \vert S_t=s, A_t = a]}_{q_{\pi}(s, a)} \nonumber\\
v_{\pi}(s) &= \sum_{a} \pi (a \vert s) \underbrace{[\sum_{r} p(r|s, a) r + \gamma \sum_{s'} p(s' \vert s, a) v_{\pi}(s') ]}_{q_{\pi}(s, a)} \nonumber\\
\end{align}
$$

Therefore:

$$
q_{\pi}(s, a) = \sum_{r} p(r|s, a) r + \gamma \sum_{s'} p(s' \vert s, a) v_{\pi}(s') \nonumber
$$

## Bellman Optimality Equation

### Optimal Policy

$$
\text{A policy } \pi^{*} \text{ is optimal if } v_{\pi^{*}}(s) \geq v_{\pi}(s), \forall s \in S
$$

- Does the optimal polcy exist?
- Is the optimal polcy unique?
- Is the optimal polcy stochastic or deterministic?
- How to obtain optimal polcy?

### Bellman Optimality Equation

$$
\begin{align}
    v_{\pi}(s)
    &= \textcolor{red}{\max_{\pi}} \sum_{a} \textcolor{red}{\pi (a \vert s)} (\sum_{r} p(r|s, a) r + \gamma \sum_{s'} p(s' \vert s) v_{\pi}(s')) \nonumber\\
    & = \textcolor{red}{\max_{\pi}} \sum_{a} \textcolor{red}{\pi (a \vert s)} q(s, a) \nonumber\\
    &= \textcolor{red}{\max_{\pi}} (r_{\pi} + \gamma P_{\pi} v) \nonumber
\end{align}
$$
