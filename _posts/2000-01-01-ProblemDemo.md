---
comments: true
title: Problem Demo
date: 2000-01-01 12:00:00
math: true
---

## Equations in list

#### Equivalent Expressions

Not sure why a scroll bar appears here

| Metric | Expression 1 | Expression 2 | Expression 3 |
| :----: | :----------: | :----------: | :----------: |
| $$ \bar{v}_{\pi} $$ | $$ \displaystyle \sum_{s \in S} d(s) v_{\pi}(s) $$ | $$ \mathbb{E}[v_{\pi}(S)] $$ | $$ \displaystyle \lim_{n\to\infty} \mathbb{E}[\sum_{t=0}^{n}\gamma^t R_{t+1}] $$ |
| $$ \bar{r}_{\pi} $$ | $$ \displaystyle \sum_{s \in S} d_{\pi}(s) r_{\pi}(s) $$ | $$ \mathbb{E}[r_{\pi}(S)] $$ | $$ \displaystyle \textcolor{red}{\lim_{n\to\infty} \frac{1}{n}\mathbb{E}[\sum_{t=0}^{n-1} R_{t+1}]} $$ |

A temporary work-around is by adding a new (empty) line in the table

| Metric | Expression 1 | Expression 2 | Expression 3 |
| :----: | :----------: | :----------: | :----------: |
| $$ \bar{v}_{\pi} $$ | $$ \displaystyle \sum_{s \in S} d(s) v_{\pi}(s) $$ | $$ \mathbb{E}[v_{\pi}(S)] $$ | $$ \displaystyle \lim_{n\to\infty} \mathbb{E}[\sum_{t=0}^{n}\gamma^t R_{t+1}] $$ |
| $$ \bar{r}_{\pi} $$ | $$ \displaystyle \sum_{s \in S} d_{\pi}(s) r_{\pi}(s) $$ | $$ \mathbb{E}[r_{\pi}(S)] $$ | $$ \displaystyle \textcolor{red}{\lim_{n\to\infty} \frac{1}{n}\mathbb{E}[\sum_{t=0}^{n-1} R_{t+1}]} $$ |
| :feet: | :feet: | :feet: | :feet: |

#### Multiple Alignments

When aligning equations at multiple locations, the alignment location for the "Truncated Policy Iteration" is not correct. I'm not sure this should be a problem with MathJax. I'll report it in the MathJax repo if so.

$$
\begin{alignat}{2}
v_{\pi 1}^{(0)} &= v_0 \nonumber\\
v_{\pi 1}^{(1)} &= r_{\pi 1} + \gamma P_{\pi 1} v_{\pi 1}^{(0)} &\longrightarrow v_1 \longrightarrow \text{Value Iteration} \nonumber\\
v_{\pi 1}^{(2)} &= r_{\pi 1} + \gamma P_{\pi 1} v_{\pi 1}^{(1)} \nonumber\\
\vdots \nonumber\\
v_{\pi 1}^{(j)} &= r_{\pi 1} + \gamma P_{\pi 1} v_{\pi 1}^{(j-1)} &\longrightarrow \bar{v_1} \longrightarrow \text{Truncated Policy Iteration} \nonumber\\
\vdots \nonumber\\
v_{\pi 1}^{(\infty)} &= r_{\pi 1} + \gamma P_{\pi 1} v_{\pi 1}^{(\infty)} &\longrightarrow v_{\pi 1} \longrightarrow \text{Policy Iteration} \nonumber
\end{alignat}
$$

#### Code Block Grammar Check

I wonder where the grammar check for code block was enabled. Here are two examples:

The first one is from my [post](https://zhengyuan-public.github.io/posts/JekyllPostTemplate/#align-multiple-equations) for equation template/reminder. I have open a [topic](https://github.com/cotes2020/jekyll-theme-chirpy/discussions/1943) in discussion, but no one has replied yet.

The first one is particularly strange because some part of the eqation becase italic. So maybe it's a kramdown engine problem? I'll report it in the kramdown repo if so.

```markdown
<Mandatory Blank Line>
$$
\begin{align}
D_{KL}(P^*(y|x_i)\ ||\ P(y|x_i; \Theta)) 
    &= \sum_{y} P^*(y|x_i) log \frac{P^*(y|x_i)}{P(y|x_i; \Theta)} \\
    &= \sum_{y} P^*(y|x_i)[logP^*(y|x_i) - logP(y|x_i; \Theta)] \\
    &= \sum_{y} P^*(y|x_i)logP^*(y|x_i) - \sum_{y} P^*(y|x_i)logP(y|x_i; \Theta)
\end{align}
$$
<Mandatory Blank Line>
```

Another example came from a note about python, the problematic part was an output from Python console. Not sure why it was highlighted in red.

```python
def learn_kwargs(**kwargs):
    print(kwargs)
    print(type(kwargs))
    for key, val in kwargs.items():
        print(f"{key} -> {val}")

>>> learn_kwargs(first_name='Zheng', last_name='Yuan')
{'first_name': 'Zheng', 'last_name': 'Yuan'}
<class 'dict'>
first_name -> Zheng
last_name -> Yuan
```
