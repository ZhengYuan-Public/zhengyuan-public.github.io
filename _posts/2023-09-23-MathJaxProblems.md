---
comments: true
title: MathJax Problems with Jekyll [To be solved]
math: true
image:
  path: https://images.ctfassets.net/3viuren4us1n/1Ghw96A2tcYRfRezOwtmjx/e646778f3f53e50ea3e857e9cdb23120/Computer_vision.jpg?fm=webp&w=1920
date: 2023-09-20 12:00:00
categories: [debug]
tags: [debug]
---

## MathJax Problem with Jekyll

> The problem has been identified as being caused by the Jekyll markdown engine. I'm still looking for a solution. Discussion about this problem can be found on GitHub [here](https://github.com/mathjax/MathJax/issues/3103).
{: .prompt-info }


### No.1
### When two inline equations are in the same line

For each RoI (also for each class), PS RoI pooling is applied to obtain *normalized* offsets $ \Delta \hat{p}_{i, j} $ and then transformed to the real offsets $ \Delta p_{i, j} $

### When moving the 2nd to a new line

For each RoI (also for each class), PS RoI pooling is applied to obtain *normalized* offsets $ \Delta \hat{p}_{i, j} $ and then transformed to the real offsets 

$ \Delta p_{i, j} $

### No.2

$ E = (b\\_{30}b_{29}...b_{23})_2 = (01111100)_2 = (124)_{10} \in \{1, ..., (2^8-1) - 1 \} = \{1, ..., 254\} $

$ (1.b_{22}b_{21} \dots b_{0})_2 = 1 + \sum_{i=1}^{23} b_{23 - i}2^{-i} = 1.25 $

$ (3 + 127)_{10} = (10000010)_2 = (b_{30}b_{29} \dots b_{23})_2 $

$ (1.b_{22}b_{21} \dots b_{0})_2 = (1.01011 \underbrace{0 \dots 0}_{18})_2 $


### No.3

Problem with `|` `{` `}`

#### When not escaping `|` `{` `}`

$ x_i \longrightarrow P(y | x_i; \Theta) \longrightarrow P^*(y | x_i) $

$ {C_2, C_3, C_4, C_5 } $

#### When escaping  `|` `{` `}` with a single `\`

$ x_i \longrightarrow P(y \| x_i; \Theta) \longrightarrow P^*(y \| x_i) $

$ \{C_2, C_3, C_4, C_5 \} $

#### When escaping `{` `}` with `\\`

$ \\{C_2, C_3, C_4, C_5 \\} $
