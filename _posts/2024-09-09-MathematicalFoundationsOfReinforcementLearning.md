---
comments: true
title: Mathematical Foundations of Reinforcement Learning
date: 2024-09-08 12:00:00
image:
    path: /assets/img/images_preview/ReinforcementLearning.webp
math: true
categories: [Machine Learning, Reinforcement Learning]
tags: [machine-learning, reinforcement-learning, mathematics]
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
    v_2 = r_2 + \gamma v_3\\
    v_3 = r_3 + \gamma v_4\\
    v_4 = r_4 + \gamma \textcolor{red}{v_1}
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
&= \underbrace{\mathbb{E}[R_{t+1} \vert S_t = s]}_{\text{Term I}} + \underbrace{\gamma \mathbb{E} [G_{t+1} \vert S_t = s]}_{\text{Term II}} \nonumber
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
    &= \textcolor{red}{\max_{\pi}} \sum_{a} \textcolor{red}{\pi (a \vert s)} (\sum_{r} p(r|s, a) r + \gamma \sum_{s'} p(s' \vert s, a) v_{\pi}(s')) \nonumber\\
    & = \textcolor{red}{\max_{\pi}} \sum_{a} \textcolor{red}{\pi (a \vert s)} q(s, a) \nonumber
\end{align}
$$

Considering $$ \displaystyle \sum_{a} \pi (a \vert s) = 1 $$, we have

$$
    \max_{\pi} \sum_{a} \pi (a \vert s) q(s, a) = \max_{a \in \mathcal{A(s)}} q(s, a) 
$$

where the optiamality is achieved when

$$
\pi (a \vert s) = 
\begin{cases}
    1, a = a^{*} \\
    0, a \neq a^{*} \\
\end{cases}
$$

where $$ \displaystyle a^{*} = \arg \underset{a}{\max} \ q(s, a) $$

### Matrix-vector Form

$$
v= \max_{\pi}(r_{\pi} + \gamma P_{\pi}v)
$$

### Banach Fixed-point Theorem

$$
\begin{align}
    v_{\pi}(s)
    &= \textcolor{red}{\max_{\pi}} \sum_{a} \textcolor{red}{\pi (a \vert s)} (\sum_{r} p(r|s, a) r + \gamma \sum_{s'} p(s' \vert s, a) v_{\pi}(s')) \nonumber\\
    &= \textcolor{red}{\max_{\pi}} (r_{\pi} + \gamma P_{\pi} v) \nonumber
\end{align}
$$

$$
\Longrightarrow v = f(v), \text{where } [f(v)]_s = \max_{\pi} \sum_{a} \pi (a \vert s) q(s, a) \nonumber
$$

> Also known as **Contraction/Contractive Mapping Theorem** or Banach–Caccioppoli theorem.
[(Wikipedia)](https://en.wikipedia.org/wiki/Banach_fixed-point_theorem)
{: .prompt-info }

#### Contraction Mapping

Let $$ (X, d) $$ be a metric space. Then a map $$ T: X \rightarrow X $$ is called a contraction mapping on $$ X $$ if $$ \exists q \in [0, 1) $$ such that

$$
    d(T(x), T(y)) \leq q d(x, y),\forall x, y \in X.
$$

#### Banach Fixed-point theorem

Let $$ (X, d) $$ be a non-empty complete metric space with a contraction mapping $$ T: X \rightarrow X $$. Then $$ T $$ admits a **unique** fixed-point $$ x^{*} \in X $$ (i.e. $$ T(x^{*}) = x^{*} $$ ). 

Further more, $$ x^{*} $$ can be found as follows: start with an arbitary element $$ x_0 \in X $$ and define a sequence $$ (x_n)_{n \in \mathbb{N}} $$ for $$ n \geq 1 $$. Then $$ \displaystyle \lim_{n \rightarrow \infty} x_n = x^{*} $$.

- Exponential convergence speed. (Lipschitz constant)
- $$ q $$ must be strictly less than 1.

### Greedy Optimal Policy

For any $$ s \in S $$, the deterministic greedy policy 

$$
\pi^{*} (a \vert s) = 
\begin{cases}
    1, a = a^{*} \\
    0, a \neq a^{*} \\
\end{cases}
$$

is an optimal policy solving the BOE. 

Here $$ \displaystyle a^{*} = \arg \underset{a}{\max} \ q^{*}(s, a) $$ where $$ q^{*}(s, a) := \sum_r p(r \vert s, a) r + \gamma \sum_{s'} p(s' \vert s, a) v^{*}(s')  $$

### Some Analysis

$$
\begin{align}
    \textcolor{red}{v(s)}
    &= \max_{\pi} \sum_{a} \textcolor{red}{\pi (a \vert s)} (\sum_{r} \textcolor{green}{p(r|s, a) r} + \textcolor{green}{\gamma} \sum_{s'} \textcolor{green}{p(s' \vert s, a)} \textcolor{red}{v(s')}) \nonumber
\end{align}
$$

Known factors
- Reward design: $$ r $$
- System model: $$ p(r \vert s, a) r,  p(s' \vert s, a) $$ 
- Discount rate: $$ \gamma $$

Unknow factors
- $$ v(s), v(s') $$ and $$ \pi(a \vert s) $$

## Value & Policy Iteration

> **Model-based**
{: .prompt-tip }

> **Matrix-vector** form is useful for theoretical analysis and **Elementwise form** is useful for implementation.
{: .prompt-tip }

### Value Iteration

$$
\begin{align}
v_{k+1} &= f(v_{k}) \nonumber\\
        &= \max_{\pi} (r_{\pi} + \gamma P_{\pi} v_{k}), k = 1, 2, 3 \dots \nonumber\\
        &= \max_{\pi} \sum_{a} \pi (a \vert s) (\sum_{r} p(r|s, a) r + \gamma \sum_{s'} p(s' \vert s, a) v_{\pi}(s')) \nonumber
\end{align}
$$

Step 1: Policy Update

$$
\begin{align}
    \pi_{k+1} &= \arg \underset{\pi}{\max} (r_{\pi} + \gamma P_{\pi} v_{k}), (v_{k} \text{ is given.}) \nonumber\\
    \pi_{k+1}(s) &= \arg \underset{\pi}{\max} \sum_{a} \pi(a \vert s) (\sum_{r}p(r \vert s, a) r + \gamma \sum_{s'} p(s' \vert s, a) v_k(s')), s \in S \nonumber
\end{align}
$$

Step 2: Value Update

$$
\begin{align}
    v_{k+1} &= r_{\pi_{k+1}} + \gamma P_{\pi_{k+1}} v_{k} \nonumber\\
    v_{k+1}(s) &= \sum_{a} \pi_{k+1} (a \vert s) \underbrace{(\sum_{r} p(r \vert s, a)r + \gamma \sum_{s'} p(s' \vert s, a) v_k(s'))}_{q_k (s,a)}, s \in S \nonumber\\
               &= \max_{a} q_k(s, a) \nonumber
\end{align}
$$

- $$ v_k $$ is **not** a state value. It's merely an intermediate value generated by the algorithm. Therefore, $$ q_k $$ is **not** an action value either.

### Policy Iteration

Step 1: Policy Evaluation

$$
\begin{align}
    v_{\pi_k} &= r_{\pi_k} + \gamma P_{\pi_k} v_{\pi_k} \nonumber\\
    v_{\pi_k}^{j+1}(s) &= \sum_{a} \pi_k (a \vert s) (\sum_{r} p (r \vert s, a) r + \gamma \sum_{s'} p(s' \vert s, a) v_{\pi_k}^{j} (s')), s \in S, j = 1, 2, \dots \nonumber
\end{align}
$$

Step 2: Policy Improvement

$$
\begin{align}
    \pi_{k+1} &= \arg \max_{\pi} (r_{pi} + \gamma P_{\pi} v_{\pi_k}) \nonumber\\
    \pi_{k+1}(s) &= \arg \max_{\pi} \sum_{a} \pi(a \vert s) (\sum_{r} p(r \vert s, a)r + \gamma \sum_{s'} p(s' \vert s, a) v_k(s')), s \in S \nonumber
\end{align}
$$

### Truncated policy iteration

> **Value Iteration** and **Policy Iteration** algorithms are two special cases of the truncated policy iteration algorithm.
{: .prompt-tip }

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

## Monte Carlo Methods

> **Model-free**
{: .prompt-tip }

> Convert the **Policy Iteration** algorithm to be **model-free**.
{: .prompt-tip }

### Monte Carlo Basic

$$
\begin{align}
q(\pi, s, a) \rightarrow q_{\pi}(s, a) 
&= \mathbb{E}[G_t \vert S_t = s, A_t = a] \longrightarrow \text{Model-free} \nonumber\\
&= \sum_{r} p(r|s, a) r + \gamma \sum_{s'} p(s' \vert s, a) v_{\pi}(s') \longrightarrow \text{Model-based} \nonumber
\end{align}
$$

Step 1: Policy Evaluation
- Estimate $$ q_{\pi_k}(s, a) $$ directly, instead of sovling $$ v_{\pi_k}(s) $$

Step 2: Policy Improvement
- Same as Policy Iteration

### Monte Carlo Exploring Starts

**Visit**: Every time a state-action pair appears in one episode is a visit of that state-action pair.

#### Data-efficient Methods

1. First-visit method: Use the return of the **first** visit of a state-value pair to estimate $$ q_{\pi_k}(s, a) $$

2. Every-visit method: $$ \dots $$ **every** visit of a state-value pair $$ \dots $$

3. Dynamic Programming in implementation.

#### Generalized Policy Iteration

Switch between the policy-evaluation and policy-improvement processes.

#### Monte Carlo Exploring Starts

- Exploring (all state-action pairs)
    1. as Start
    2. via Visit (can't be guaranteed yet)

### Monte Carlo $$ \epsilon $$-Greedy

**Soft Policy**: The probability to take any action is positive. Hence, the requirement of **Exploring Starts** can be removed.

#### $$ \epsilon $$-Greedy Policy

$$
\pi (a \vert s) =
\begin{cases}
    \displaystyle 1 - \frac{\epsilon}{ \vert \mathcal{A}(s) \vert} (\vert \mathcal{A}(s) \vert - 1) \nonumber\\
    \displaystyle \frac{\epsilon}{ \vert \mathcal{A}(s) \vert} \nonumber
\end{cases}
$$

where $$ \epsilon \in [0, 1] $$ and $$ \vert \mathcal{A}(s) \vert $$ is the number of actions for $$ s $$.

#### Exploitation versus Exploration

$$ 0 \xleftarrow[]{Exploitation!} \epsilon \xrightarrow[]{Exploration!} 1 $$

#### Monte Carlo $$ \epsilon $$-Greedy

- Use every-visit method.

## Stochastic Approxmimation 🐾

> **Stochastic Approxmimation** refers to a broad class of **stochastic** and **iterative** algorithms solving root-finding or optimization problems. (From non-incremental to incremental methods.)
- No expression of the objective function required.
- No derivative required.
{: .prompt-tip }

### Mean Estimation

$$
\begin{align}
w_{k+1} &= \frac{1}{k} \sum_{i=1}^{k} x_i, i = 1, 2, \dots \nonumber\\
        &= w_k - \frac{1}{k} (w_k - x_k) \nonumber
\end{align}
$$

- Obtain an estimation when a sample is received.
- The estimate is not accurate at the beginning due to small number of samples. But it's better than nothing and it can imporve gradually.

### Robbins-Monro Algorithm

Suppose $$ J(w) $$ is a unknown objective function to be optimized. And the problem we want to solve is:

$$
g(w) := \nabla_w J(w) = 0
$$

The Robbins-Monro Algorithm

$$
w_{k+1} = w_{k} - a_k \tilde{g} (w_k, \eta_k)
$$

can solve the problem where
- $$ w_k $$ is the $$ k $$-th estimation of the root.
- $$ a_k $$ is a possitive coefficient.
- $$ \tilde{g} (w_k, \eta_k) = g(w_k) + \eta_k $$ is the $$ k $$-th **noisy observation**.

#### Robbins-Monro Theorem

$$ w_k $$ **converges with probability 1 (w.p.1)** (almost sure convergence) to the root $$ w^{*} $$ satisfying $$ g(w^{*}) = 0 $$ if

1. $$ 0 < c_1 \leq \nabla_w g(w) \leq c_2 $$ for all $$ w $$
    - $$ g(w) $$ is monotonically increasing $$ \Longrightarrow g(w) = 0 $$ exists and is unique ($$ \Longrightarrow $$ Convexity of objective function $$ H(x) = \nabla_w^2 J(w) $$)
    - $$ \nabla_w g(w) $$ has an upperbound
2. $$ \displaystyle \sum_{k=1}^{\infty} a_k = \infty $$ and $$ \displaystyle \sum_{k=1}^{\infty} a_k^2 < \infty $$
    - $$ \displaystyle \sum_{k=1}^{\infty} a_k = \infty $$ ensures $$ a_k $$ do not converge to zero too fast
    - $$ \displaystyle \sum_{k=1}^{\infty} a_k^2 < \infty $$ ensures $$ a_k $$ converges to zero as $$ k \rightarrow \infty $$
3. $$ \mathbb{E} [\eta_k \vert \mathcal{H_k}] = 0 $$ and $$ \mathbb{E} [\eta_k^2 \vert \mathcal{H_k}] = 0 $$, where $$ \mathcal{H_k} = \{w_k, w_{k-1}, \dots\} $$
    - $$ \eta_k $$ has a mean of zero and bounded variance, such as Independent and identically distributed (iid)

#### Example
In the mean estimation problem, $$ a_k = \frac{1}{k} $$
- $$ \displaystyle \lim_{n \to \infty } (\sum_{k=1}^{n} \frac{1}{k} - \ln n) = \kappa \approx 0.577 $$, the Euler-Mascheroni constant
- $$ \displaystyle \sum_{k=1}^{\infty} \frac{1}{k^2} = \frac{\pi^2}{6} < \infty $$, the Basel Problem in number theory

> Dvoretzky's Theorem ([Wikipedia](https://en.wikipedia.org/wiki/Dvoretzky%27s_theorem))
{: .prompt-info }

### Stochastic Gradient Descent

For the following optimization problem:

$$
\min_{w} J(w) = \mathbb{E} [f(w, X)]
$$

- $$ w $$ is the parameter to be optimized
- $$ X $$ is a random variable
- $$ w $$ and $$ X $$ can be scalars or vectors, $$ f(\cdot) $$ is a scalar

#### Gradient Descent

$$
\begin{align}
w_{k+1} &= w_k - \alpha_k \nabla_w \mathbb{E} [f(w_k, X)] \nonumber\\
        &= w_k - \alpha_k \mathbb{E} [\nabla_w f(w_k, \textcolor{red}{X})]\nonumber
\end{align}
$$

#### Batch Gradient Descent

$$
\begin{align}
\mathbb{E} [\nabla_w f(w_k, \textcolor{red}{X})] &\approx \frac{1}{n} \sum_{i=1}^{n} [\nabla_w f(w_k, \textcolor{red}{x_i})] \nonumber\\
w_{k+1} &\approx  w_k - \alpha_k \frac{1}{n} \sum_{i=1}^{n} [\nabla_w f(w_k, \textcolor{red}{x_i})] \nonumber
\end{align}
$$

#### Mini Batch Gradient Descent

$$
\begin{align}
\mathbb{E} [\nabla_w f(w_k, \textcolor{red}{X})] &\approx \frac{1}{m} \sum_{x_j \in X} [\nabla_w f(w_k, \textcolor{red}{x_j})] \nonumber\\
w_{k+1} &\approx  w_k - \alpha_k \frac{1}{m} \sum_{x_j \in X} [\nabla_w f(w_k, \textcolor{red}{x_j})] \nonumber
\end{align}
$$

#### Stochastic Gradient Descent

$$
w_{k+1} = w_k - \alpha_k \mathbb{E} [\nabla_w f(w_k, \textcolor{red}{x_k})]
$$

- Replace ture gradient $$ \nabla_w f(w_k, \textcolor{red}{X}) $$ with the stochastic gradient $$ \nabla_w f(w_k, \textcolor{red}{x_k}) $$
- BGD $$ (n=1) \Longrightarrow $$ SGD 

> A special case of the Robbins-Monro Algorithm.
{: .prompt-tip }

$$
\begin{align}
\tilde{g} (w, \eta) &= \nabla_w f(w, x) \nonumber\\
                    & = \underbrace{\mathbb{E} [\nabla_w f(w_k, \textcolor{red}{X})]}_{g(w)} + \underbrace{\nabla_w f(w, x) - \mathbb{E} [\nabla_w f(w_k, \textcolor{red}{X})]}_{\eta} \nonumber
\end{align}
$$

##### Convergence Pattern

Relative error

$$
\begin{align}
\delta_k &= \frac{\vert \nabla_w f(w_k, x_k) - \mathbb{E} [\nabla_w f(w_k, X)] \vert}{\vert \mathbb{E} [\nabla_w f(w_k, X)] \vert} \nonumber\\
        &= \frac{\vert \nabla_w f(w_k, x_k) - \mathbb{E} [\nabla_w f(w_k, X)] \vert}{\vert \mathbb{E} [\nabla_w f(w_k, X)] - \{\mathbb{E}[\nabla_w f(w^{*}, X)] = 0\}  \vert} \nonumber\\
        &= \frac{\vert \nabla_w f(w_k, x_k) - \mathbb{E} [\nabla_w f(w_k, X)] \vert}{\vert \mathbb{E} [\nabla_w^2 f(w_k, X)(w_k - w^{*})]  \vert} \Longleftarrow \nonumber\\ 
        &\leq \frac{\vert \overbrace{\nabla_w f(w_k, x_k)}^{\text{SG}} - \overbrace{\mathbb{E} [\nabla_w f(w_k, X)]}^{TG} \vert}{\underbrace{c \vert w_k - w^{*} \vert}_{\text{Distance to } w^{*}}} \nonumber\\ 
\end{align}
$$

- $$ \Longleftarrow $$ Apply mean value theorem ($$ f(x_1) - f(x_2) = f'(x_3)(x_1 - x_2) $$)
- $$ \delta_k $$ is inversely proportional to $$ \vert w_k - w^{*} \vert $$
- When $$ w_k $$ is far away from $$ w^{*} $$, $$ \delta_k $$ is small and SGD behaves like GD
- When $$ w_k $$ is close to $$ w^{*} $$, $$ \delta_k $$ is large and SGD exhibits more randomness

## Temporal Difference Learning

> Temporal Difference Learning often refers to a broad class of RL algorithms and/or a specific algorithm for estimationg state value.
{: .prompt-tip }

### TD Learning

> TD Learning for **State Value**.
{: .prompt-info }

The goal is to estimate $$ v_{\pi}(s), \forall s \in \mathcal{S} $$ given policy $$ \pi $$. The TD algorithm for $$ {(s_t, r_{t+1}, s_{t+1})}_t $$ is

$$
\underbrace{v_{t+1}(s_t)}_{\text{New Estimation}} 
    = \underbrace{v_t(s_t)}_{\text{Current Estimation}} 
        - \alpha_t(s_t) \overbrace{[v_t(s_t) - \underbrace{(r_{t+1} + \gamma v_t(s_{t+1}))}_{\text{TD Target }\bar{v}_t}]}^{\text{TD Error } \delta_t}
$$

- $$ v_t(s_t) $$ is the estimated State Value of $$ v_{\pi}(s_t) $$ at time step $$ t $$
- $$ \alpha_t(s_t) $$ is the learning rate at time step $$ t $$
- $$ v_{t+1}(s) = v_t(s), \forall s \neq s_t $$ is usually omitted for unvisited states
- A special sotchatic approximation algorithm for solving the Bellman equation
- Does **NOT** estimate action value
- Does **NOT** search for the optimal policy

#### TD Target

$$ v(s_t) $$ is driven towards $$ \bar{v}_t:= r_{t+1} + \gamma v_t(s_{t+1}) $$

$$
\begin{align}
v_{t+1}(s_t) &= v_t(s_t) - \alpha_t(s_t)[v_t(s_t) - \bar{v}_t] \nonumber\\
v_{t+1}(s_t) - \bar{v}_t &= (v_t(s_t) - \bar{v}_t) - \alpha_t(s_t)[v_t(s_t) - \bar{v}_t]\nonumber\\
\vert v_{t+1}(s_t) - \bar{v}_t \vert &= \underbrace{\vert 1 - \alpha_t(s_t) \vert}_{\in (0, 1)} \vert v_t(s_t) - \bar{v}_t \vert \nonumber\\
\vert v_{t+1}(s_t) - \bar{v}_t \vert &< \vert v_t(s_t) - \bar{v}_t \vert \nonumber
\end{align}
$$

#### TD Error

- The discrepancy between two consequent time steps $$ \Longrightarrow $$ TD
- Reflects the deficiency between $$ v_t $$ and $$ v_{\pi} $$
- New information (Innovation) obtained from the experience $$ {(s_t, r_{t+1}, s_{t+1})}_t $$

#### Convergence

$$ v_t(s) $$ converges ***w.p.1*** to $$ v_{\pi}(s), \forall s \in \mathcal{S} $$ as $$ t \to \infty $$, if $$ \displaystyle \sum_t \alpha_t (s) = \infty $$ and $$ \displaystyle \sum_t \alpha_t^2 (s) < \infty, \forall s \in \mathcal{S} $$

- State value can be found for a given policy $$ \pi $$
- Every state must be visited an infinite(sufficiently large) number of times
- $$ \alpha $$ is typically set as a small constant (not zero) because later experience is expected to influence the state value (TD algorithm can still converge in the sense of expectation)

### Sarsa

> TD Learning for **Action Value**. State-Action-Reward-State-Action $$ (s_t, a_t, r_{t+1}, s_{t+1}, a_{t+1}) $$
{: .prompt-info }

$$
\begin{align}
q_{t+1}(s_t, a_t) &= q_t(s_t, a_t) - \alpha_t(s_t, a_t) [q_t(s_t, a_t) - [r_{t+1} + \gamma q_t(s_{t+1}, a_{t+1})]] \nonumber\\
q_{t+1}(s, a) &= q_t(s, a), \forall (s, a) \neq (s_t, a_t) \nonumber
\end{align}
$$

Mathematically, the expression suggests it's a stochastic approximation algorithm solving the following Bellman equation

$$
q_{\pi}(s, a) = \mathbb{E} [R + \gamma q_{\pi}(S', A') \vert (s, a)], \forall (s, a)
$$

#### Convergence

$$ q_t(s, a) $$ converges ***w.p.1*** to $$ q_{\pi}(s, a), \forall (s, a) $$ as $$ t \to \infty $$, if $$ \displaystyle \sum_t \alpha_t (s, a) = \infty $$ and $$ \displaystyle \sum_t \alpha_t^2 (s, a) < \infty, \forall (s, a) \in \mathcal{S} $$

- Policy Evaluation
- Action value can be found for a given policy $$ \pi $$

#### Add Policy Improvement

$$
\pi_{t+1}(a \vert s_t) = 
\begin{cases}
    1 - \frac{\epsilon}{\vert \mathcal{A} \vert} (\vert \mathcal{A} \vert - 1), a = \arg \max_a q_{t+1}(s_t, a) \\
    \frac{\epsilon}{\vert \mathcal{A} \vert}, \text{otherwise}
\end{cases}
$$

- Often also called Sarsa after adding policy improvement
- **Not all states have the optimal policy**

### Expected Sarsa

$$
\begin{align}
q_{t+1}(s_t, a_t) &= q_t(s_t, a_t) - \alpha_t(s_t, a_t) [q_t(s_t, a_t) - r_{t+1} + \gamma \mathbb{E} [q_t(s_{t+1}, A)]] \nonumber\\
q_{t+1}(s, a) &= q_t(s, a), \forall (s, a) \neq (s_t, a_t) \nonumber
\end{align}
$$

- $$ \displaystyle \mathbb{E} [q_t(s_{t+1}, A)] = \sum_a \pi_t(a \vert s_{t+1}) q_t(s_{t+1}, a) := v_t(s_{t+1}) $$, which is the state value of $$ s_{t+1} $$
- Reduced estimation variance becuase the number of *r.v.* is reduced ($$ (s_t, a_t, r_{t+1}, s_{t+1}, a_{t+1}) \Longrightarrow (s_t, a_t, r_{t+1}, s_{t+1}) $$)

Mathematically

$$
q_{\pi}(s, a) = \mathbb{E} [R_{t+1} + \gamma v_{\pi}(S_{t+1}) \vert (S_t = s, A_t = a)]
$$

### $$ n $$-step Sarsa

> Can unify Sarsa and Monte Carlo learning.
{: .prompt-info }

The discounted return $$ G_t $$ can be written as

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

### Q-Learning

> TD Learning for **Optimal Action Value**. State-Action-Reward-State-Action $$ (s_t, a_t, r_{t+1}, s_{t+1}, a_{t+1}) $$
{: .prompt-info }

$$
\begin{align}
q_{t+1}(s_t, a_t) &= q_t(s_t, a_t) - \alpha_t(s_t, a_t) [q_t(s_t, a_t) - [r_{t+1} + \gamma \max_{a \in \mathcal{A}}(s_{t+1}, a)]] \nonumber\\
q_{t+1}(s, a) &= q_t(s, a), \forall (s, a) \neq (s_t, a_t) \nonumber
\end{align}
$$

Mathematically

$$
q(s, a) = \mathbb{E} [R_{t+1} + \gamma \max_{a} q(S_{t+1}, a) \vert (S_t = s, A_t = a)], \forall s, a
$$

- The Bellman optimality equation expressed in terms of action value

#### On/Off-Policy

> **Behavior Policy** is the policy that the agent follows while interacting with the environment and collecting data. **Target Policy** is the policy that the agent is trying to learn and improve.
{: .prompt-tip }

On-policy: **Behavior Policy** = **Target Policy**. For example, in Sarsa, the agent updates q value based on actions it actually took (according to its current policy).

Off-policy: **Behavior Policy** ≠ **Target Policy**. For example, in Q-Learning, the behavior policy **CAN** be different from the target policy. The target policy is the one learning to optimize, while the behavior policy is the one used for exploration and interaction.

## Value Function Approximation

### Value Representation

$$ (s_i, a_i)_{i=1}^{n} \Longrightarrow \hat{v}(s, w) = \phi^T(s) w $$

- $$ \phi^T(s) $$ is the **Feature Vector**
- $$ w $$ is the **Parameter Vector**
- More storage efficiency by sacrificing accuracy
- More generalization ability

### Objective Function

> The objective is to find optimal $$ w $$ such that $$ \hat{v}(s, w) \approx v_{\pi}(s) $$, which makes it a **Policy Evaluation** problem.
{: .prompt-tip }

$$
J(w) = \mathbb{E}[(v_{\pi}(S) - \hat{v}(S, w))^2]
$$

- Find the best $$ w $$ that minimize $$ J(w) $$
- $$ \mathbb{E} $$ is with respect to the r.v. $$ S \in \mathcal{S} $$. So the distribution of $$ S $$ matters.

#### Uniform Distribution of $$ S \in \mathcal{S} $$

$$
\begin{align}
J(w) &= \mathbb{E}[(v_{\pi}(S) - \hat{v}(S, w))^2] \nonumber\\
     &= \frac{1}{\vert \mathcal{S} \vert} \sum_{s \in \mathcal{S}}(v_{\pi}(s) - \hat{v}(s, w)^2) \nonumber
\end{align}
$$

- Not representing the real dynamics of the Markov process under the given policy (not all states are equally important)

#### Stationary Distribution of $$ S \in \mathcal{S} $$

> Stationary Distribution [(Wikipedia)](https://en.wikipedia.org/wiki/Stationary_distribution)
{: .prompt-info }

$$
\begin{align}
J(w) &= \mathbb{E}[(v_{\pi}(S) - \hat{v}(S, w))^2] \nonumber\\
     &= \sum_{s \in \mathcal{S}}d_{\pi}(s)(v_{\pi}(s) - \hat{v}(s, w)^2) \nonumber
\end{align}
$$

### Optimize $$ J(w) $$

$$
w_{k+1} = w_{k} - \alpha_k\nabla_wJ(w_k)
$$

#### True Gradient

$$
\begin{align}
\nabla_w J(w_k) &= \nabla_w \mathbb{E}[(v_{\pi}(S) - \hat{v}(S, w))^2] \nonumber\\
                &= 2\mathbb{E}[(v_{\pi}(S) - \hat{v}(S, w))(-\nabla_w\hat{v}(S, w))] \nonumber\\
                &= -2\textcolor{red}{\mathbb{E}}[(v_{\pi}(S) - \hat{v}(S, w))\nabla_w\hat{v}(S, w)] \nonumber
\end{align}
$$

#### Stochastic Gradient

$$
\begin{align}
w_{k+1} &= w_{k} - \alpha_k (-2\textcolor{red}{\mathbb{E}}[(v_{\pi}(S) - \hat{v}(S, w))\nabla_w\hat{v}(S, w)]) \nonumber\\
        &= w_{k} + \underbrace{\textcolor{green}{\alpha_k}}_{2\alpha_k}[\textcolor{red}{v_{\pi}(s_t)} - \hat{v}(s_t, w_t)]\nabla_w\hat{v}(S, w) \nonumber
\end{align}
$$

#### Approximate $$ v_{\pi}(s_t) $$

1. Monte Carlo: $$ w_{k+1} = w_{k} + \textcolor{green}{\alpha_k}[\textcolor{red}{g_t} - \hat{v}(s_t, w_t)]\nabla_w\hat{v}(S, w) $$

2. TD Learning: $$ w_{k+1} = w_{k} + \textcolor{green}{\alpha_k}[\textcolor{red}{r_{t+1} + \gamma \hat{v}(s_{t+1}, w_t) } - \hat{v}(s_t, w_t)]\nabla_w\hat{v}(S, w) $$

### Sarsa

$$
w_{k+1} = w_{k} + \alpha_k[r_{t+1 + \gamma \hat{q}(s_{t+1}, w_t) } - \hat{q}(s_t, w_t)]\nabla_w\hat{q}(S, w)
$$

### Q-Learning

$$
w_{k+1} = w_{k} + \alpha_k[r_{t+1} + \gamma \max_{a \in \mathcal{A}(s_{s+1})}\hat{q}(s_{t+1},a, w_t) - \hat{q}(s_t, a_t, w_t)]\nabla_w\hat{q}(s_t, a_t, w_t)
$$

### Deep Q-Learning

> Deep Q-Learning or Deep Q-Network (DQN).
{: .prompt-tip }

- Nueral Network is a nonlinear function approximator
- Different from Q-Learning because it requires low level calculation of $$ \nabla_w\hat{q}(s_t, a_t, w_t) $$

#### Objective Function

Mathematically, Q-Learning is solving the following Bellman Optimality Equation

$$
q(s, a) = \mathbb{E} [R_{t+1} + \gamma \max_{a} q(S_{t+1}, a) \vert (S_t = s, A_t = a)], \forall s, a
$$

So, the objective function is

$$
\begin{align}
J(w) &= \mathbb{E}[(R + \gamma \max_{a \in \mathcal{A}(S')}\textcolor{red}{\hat{q}(S', a, w)} - \textcolor{blue}{\hat{q}(S, A, w)})^2] \nonumber \\
J(w) &= \mathbb{E}[(R + \gamma \max_{a \in \mathcal{A}(S')}\textcolor{red}{\hat{q}(S', a, w_T)} - \textcolor{blue}{\hat{q}(S, A, w)})^2] \nonumber
\end{align}
$$

#### Optimize $$ J(w) $$

$$
\nabla_w J(w) = \mathbb{E} [(R + \gamma \max_{a \in \mathcal{A}(S')} \textcolor{red}{\hat{q}(S', a, w_T)} - \textcolor{blue}{\hat{q}(S, A, w)}) \nabla_w \textcolor{blue}{\hat{q}(S, A, w)}] \nonumber
$$

- DNQ use the target network $$ \textcolor{red}{\hat{q}(S', a, w_T)} $$ and the main network $$ \textcolor{blue}{\hat{q}(S, A, w)} $$
- $$ w $$ updates constantly while $$ w_T $$ updates periodically

#### Experience Replay

1. Collect experience samples $$ (s, a, r, s') $$
2. Store experience samples in a set, **replay buffer**, $$ \mathcal{B} := {(s, a, r, s')} $$
3. Draw (called **Experience Replay**) a mini-batch from $$ \mathcal{B} $$ following a **Uniform Distribution**

Advantages
- Break the correlation between consequent samples
- Sample efficient

## Policy Function Approximation

> Value-based to **Policy-based** (**Policy Gradient**). PG algorithms are naturally On-Policy, but can be converted to Off-Policy.
{: .prompt-tip }

$$
\pi(a \vert s, \theta), \theta \in \mathbb{R}^{m}
$$

- Also written as $$ \pi_{\theta}(a \vert s) $$ or $$ \pi_{\theta}(a, s) $$

### Metrics of Optimal Policy

#### Average (State) Value

$$
\bar{v}_{\pi} = \sum_{s \in S} d(s) v_{\pi}(s)
$$

- $$ \displaystyle \sum_{s \in S} d(s) = 1 \Longrightarrow \bar{v}_{\pi} = \mathbb{E}[v_{\pi}(S)] $$, where $$ S \sim d $$
- $$ \bar{v}_{\pi} = \mathbb{E}[v_{\pi}(S)] = d^T v_{\pi} $$, where $$ v_{\pi} = [\cdots, v_{\pi}(s), \cdots]^T \in \mathbb{R}^{\vert \mathcal{S} \vert} $$ and $$ d = [\cdots, d(s), \cdots]^T \in \mathbb{R}^{\vert \mathcal{S} \vert} $$
- $$ d(s) $$ can be either policy-dependent, such as when using the stationary distribution ($$ d_{\pi}^T P_{\pi} = d_{\pi}^T $$), or policy-independent, such as when utilizing a uniform distribution.

#### Average (One-Step) Reward

$$
\begin{align}
\bar{r}_{\pi} = \sum_{s \in \mathcal{S}} d_{\pi}(s) \textcolor{red}{r_{\pi}(s)} &= \mathbb{E} [r_{\pi}(S)], S \sim d_{\pi} \nonumber\\
r_{\pi}(s) &= \sum_{a \in \mathcal{A}} \pi(a \vert s) \textcolor{red}{r(s, a)} \nonumber\\
r(s, a) &= \mathbb{E}[R \vert s, a] = \sum_{r} r p(r \vert s, a) \nonumber
\end{align}
$$

- $$ d_{\pi}(s) $$ is the stationary distribution
- \$$ \bar{v}_{\pi} = (1 - \gamma)\bar{r}_{\pi} $$

#### Equivalent Expressions

| Metric | Expression 1 | Expression 2 | Expression 3 |
| :----: | :----------: | :----------: | :----------: |
| $$ \bar{v}_{\pi} $$ | $$ \displaystyle \sum_{s \in S} d(s) v_{\pi}(s) $$ | $$ \mathbb{E}[v_{\pi}(S)] $$ | $$ \displaystyle \lim_{n\to\infty} \mathbb{E}[\sum_{t=0}^{n}\gamma^t R_{t+1}] $$ |
| $$ \bar{r}_{\pi} $$ | $$ \displaystyle \sum_{s \in S} d_{\pi}(s) r_{\pi}(s) $$ | $$ \mathbb{E}[r_{\pi}(S)] $$ | $$ \displaystyle \textcolor{red}{\lim_{n\to\infty} \frac{1}{n}\mathbb{E}[\sum_{t=0}^{n-1} R_{t+1}]} $$ |
| :feet: | :feet: | :feet: | :feet: |

### Gradient of Metrics

$$
\nabla_{\theta} J(\theta) \textcolor{red}{=} \sum_{s \in \mathcal{S}} \eta(s) \sum_{a \in \mathcal{A}} \nabla_{\theta} \pi (a \vert s, \theta) q_{\pi} (s, a)
$$

- $$ J(\theta) $$ can be $$ \bar{v}_{\pi}, \bar{v}_{\pi}^{0} $$, or $$\bar{r}_{\pi} $$
- $$ \textcolor{red}{=} $$ can be $$ =, \approx, \propto $$
- $$ \eta $$ is a distribution or weight of the states

$$
\begin{align}
\nabla_{\theta} J(\theta) &\textcolor{red}{=} \sum_{s \in \mathcal{S}} \eta(s) \sum_{a \in \mathcal{A}} \nabla_{\theta} \pi (a \vert s, \theta) q_{\pi} (s, a) \nonumber\\
&\textcolor{red}{=} \sum_{s \in \mathcal{S}}d(s) \sum_{a \in \mathcal{A}} \pi(a \vert s, \theta) \nabla_{\theta} \ln \pi(a \vert s, \theta)q_{\pi}(s, a) \Longleftarrow \nonumber\\
&\textcolor{red}{=} \mathbb{E}_{S \sim d} [\sum_{a \in \mathcal{A}} \pi(a \vert s, \theta) \nabla_{\theta} \ln \pi(a \vert S, \theta) q_{\pi}(S, a)] \nonumber\\
&\textcolor{red}{=} \mathbb{E}_{S \sim d, A \sim \pi} [\nabla_{\theta} \ln \pi(A \vert S, \theta) q_{\pi}(S, A)] \nonumber\\
&\approx \nabla_{\theta} \ln \pi(a \vert s, \theta) q_{\pi}(s, a) \nonumber
\end{align}
$$

- $$ \Longleftarrow $$ used $$\displaystyle \nabla \ln f(x) = \frac{\nabla f(x)}{f(x)}$$ 
- In order to calculate $$ \ln \pi(a \vert s, \theta) $$, use softmax function $$ \displaystyle z_i = \frac{e^{x_i}}{\sum_{j=1}^n e^{x_j}} $$ to normalize the entries from $$ (-\infty, +\infty) $$ to $$ (0, 1) $$
- The policy function takes the form $$ \displaystyle \pi(a \vert s, \theta) = \frac{e^{h(s, a, \theta)}}{\sum_{a' \in \mathcal{A}}e^{h(s, a', \theta)}}  $$
- $$ \pi(a \vert s, \theta) > 0, \forall a $$, the parameterized policy is **stochastic** and hence **exploreatory**

### Gradient Ascent

$$  
\begin{align}
\theta_{t+1}
    &= \theta_t + \alpha \nabla_{\theta}J(\theta) \nonumber\\
    &= \theta_t + \alpha \textcolor{red}{\mathbb{E}}[\nabla_{\theta}\ln \pi(A \vert S, \theta_t)q_{\pi}(S, A)] \nonumber\\
    &\approx \theta_t + \alpha \nabla_{\theta} \ln \pi(a_t \vert s_t, \theta) \textcolor{red}{q_{\pi}(s_t, a_t)} \nonumber\\
    &\approx \theta_t + \alpha \nabla_{\theta} \ln \pi(a_t \vert s_t, \theta) \textcolor{green}{q_t(s_t, a_t)} \nonumber
\end{align}
$$

Use SG to approximate $$ q_{\pi}(s_t, a_t) $$
- Sample $$ S \sim d $$, where $$ d $$ is a long-run behavior under $$ \pi $$ (typically trivial because it's impossible in reality)
- Sample $$ A \sim \pi(A \vert S, \theta) $$, hence $ a_t $ should be sampled following $$ \pi(\theta_t) $$ at $$ s_t \Longrightarrow $$ (**On-Policy**)

### Actor-Critic Methods

> Acotr refers to Policy Update and Critic refers to Policy Evaluation or Value Estimation.
{: .prompt-tip }

$$  
\theta_{t+1} = \theta_t + \alpha \nabla_{\theta} \ln \pi(a_t \vert s_t, \theta) \textcolor{green}{q_t(s_t, a_t)}\nonumber
$$

- The algorithm updates $$ \theta $$, thus corresponds to **Actor**
- Evaluation of $$ q_t(s_t, a_t) $$ corresponds to **Critic**
    - With Monte Carlo method $$ \Longrightarrow $$ **REINFORCE**
    - With TD Learning $$ \Longrightarrow $$ **Actor-Critic**

#### Q Actor-Critic (QAC)
<!-- 
$$
\begin{align}
&\to (s_t, a_t, r_{t+1}, s_{t+1}, a_{t+1}) \nonumber\\
w_{t+1} &= w_t + \alpha_w [r_{t+1} + \gamma q(s_{t+1}, a_{t+1}, w_t) - q(s_t, a_t, w_t)] \nabla_w q(s_t, a_t, w_t) \nonumber\\
\theta_{t+1} &= \theta_{t} + \alpha_{\theta} \nabla_{\theta} \ln \pi(a_t \vert s_t, \theta_t) q(s_t, a_t, w_{t+1}) \nonumber
\end{align}
$$ -->

- Sarsa + Value Function Approximation

#### Advantage Actor-Critic (A2C)

> Introduce a baseline to **reduce variance**.
{: .prompt-tip }

$$
\begin{align}
\nabla_{\theta} J(\theta) 
    &\textcolor{red}{=} \mathbb{E}_{S \sim d, A \sim \pi} [\nabla_{\theta} \ln \pi(A \vert S, \theta) q_{\pi}(S, A)] \nonumber\\
    &\textcolor{red}{=} \mathbb{E}_{S \sim d, A \sim \pi} [\nabla_{\theta} \ln \pi(A \vert S, \theta) (q_{\pi}(S, A) - \textcolor{green}{b(S)})] \nonumber\\
    &\textcolor{red}{=} \mathbb{E}_{S \sim d, A \sim \pi} [\nabla_{\theta} \ln \pi(A \vert S, \theta) \delta_{\pi}(S, A)] \nonumber\\
\theta_{t+1}
    &\textcolor{red}{=} \theta_t + \alpha \nabla_{\pi} \ln \pi(a_t \vert s_t, \theta_t) \delta_t(s_t, a_t) \nonumber
\end{align}
$$

- The optimal baseline $$ \displaystyle b^*(s) = \frac{\mathbb{E}_{A \sim \pi}[ \vert \vert \nabla_{\theta} \ln \pi(A \vert s, \theta) \vert \vert^2 q(s, A)]}{\mathbb{E}_{A \sim \pi}[ \vert \vert \nabla_{\theta} \ln \pi(A \vert s, \theta) \vert \vert^2]} $$ is too complex, so it's more often to use $$ \displaystyle b^*(s) = \mathbb{E}_{A \sim \pi} [q(s, A)] = \textcolor{red}{v_{\pi}(s)} $$
- Advantage function: $$ \delta_{\pi}(S, A) := q_{\pi}(S, A) - v_{\pi}(S) $$
- Use TD error to approximate $$ \delta_{\pi}(s_t, a_t) := q_{\pi}(s_t, a_t) - v_{\pi}(s_t) = r_{t+1} + \gamma v_t(s_{t+1}) - v_t(s_t) $$ so we can use only one network to approximate v_{\pi}(s)

#### Off-Policy AC

> **Importance Sampling**\\
$$
\begin{align}
\mathbb{E}_{X \sim p_0}[X] 
    &= \sum_{x} p_0(x) x = \sum_{x} p_1(x) \underbrace{\frac{p_0(x)}{p_1(x)}}_{f(x)} = \mathbb{E}_{X \sim p_1}[f(X)] \nonumber\\
    &\approx \bar{f} = \frac{1}{n}\sum_{i=1}^{n}f(x_i) = \frac{1}{n}\sum_{i=1}^{n}\frac{p_0(x_i)}{p_1(x_i)} x_i \nonumber
\end{align}
$$
- Importance weight: $$ \displaystyle \frac{p_0(x_i)}{p_1(x_i)} $$
- Importance Sampling is not limited to AC algorithms
{: .prompt-tip }

$$
\begin{align}
\nabla_{\theta} J(\theta) 
    &= \mathbb{E}_{S \sim d, \textcolor{red}{A \sim \beta}} [\textcolor{red}{\frac{\pi(A \vert S, \theta)}{\beta(A \vert S)}} \nabla_{\theta} \ln \pi(A \vert S, \theta) q_{\pi}(S, A)] \nonumber\\
\end{align}
$$

#### Deterministic AC (DPG)

> Stochastic policies cannot handle continuous (infinity) actions at time $$ t $$.
{: .prompt-tip }

Deterministic Policy is denoted as $$ a = \mu (s, \theta) := \mu(s) $$
- $$ \mu: \mathcal{S} \sim \mathcal{A} $$ is a mapping from states to actions

$$
\begin{align}
J(\theta) 
        &= \mathbb{E}[v_{\mu}(s)] = \sum_{s \in \mathcal{S}}d_0(s)v_{\mu}(s) \nonumber\\
        &= \sum_{s \in \mathcal{S}} \rho_{\mu}(s) \nabla_{\theta}\mu(s)(\nabla_a q_{\mu}(s, a)) \vert_{a=\mu(s)} \nonumber\\
        &= \mathbb{E}_{\mathcal{S} \sim \rho_{\mu}}[\nabla_{\theta}\mu(s)(\nabla_a q_{\mu}(S, a)) \vert_{a=\mu(S)}] \nonumber\\
\theta_{t+1}
        &= \theta_t + \alpha_{\theta} \nabla_{\theta} \mu(s_t) (\nabla_a q_{\mu}(s_t, a)) \vert_{a=\mu(s_t)} \nonumber
\end{align}
$$

- Off-Policy. The behavior policy $$ \beta $$ can be different from $$ \mu $$
- $$ \beta $$ can be replaced by $$ \mu $$ + noise so the algorithm can explore
- $$ q(s, a, w) $$ can be a Linuear Function (DPG) or Neural Networks (DDPG)

## Miscellaneous

### Mathematical Notation

- Approximately equal to: $$ \doteq $$ or $$ \approx $$.
- Defined as: $$ := $$