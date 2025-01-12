---
comments: true
title: Jekyll Post Template
date: 2024-04-25 12:00:00
image:
    path: /assets/img/images_preview/JekyllPreview.png
math: true
categories: [Programming and Development, Jekyll]
tags: [programming, jekyll]
pin: true
---

> Use `space` instead of `tab` for indentation for better compatability.
{: .prompt-tip }

## YAML Header

```markdown
---
comments: true
title: Jekyll Post Template
date: 2024-04-25 12:00:00
image:
    path: PATH_TO_IMAGE
math: true
mermaid: false
categories: [CAT_1, CAT_2]
tags: [tag_1, tag_2]
---
```

## Preview Image

Recommended preview image resolution is `1200 x 630`. If the image aspect ratio does not meet `1.91 : 1`, the image will be scaled and cropped.

```yaml
---
image:
  path: /path/to/image
  alt: image alternative text
---
```

## Blog Post Image

```markdown
![img-description](/path/to/image){: style="max-width: 700px; height: auto;"}
![img-description](/path/to/image){: width="700" height="400" }
![img-description](/path/to/image){: w="700" h="400"}
_Image Caption_
```

## Prompt

> Example line for tip prompt.
{: .prompt-tip }

> Example line for info prompt.
{: .prompt-info }

> Example line for warning prompt.
{: .prompt-warning }

> Example line for danger prompt.
{: .prompt-danger }

```markdown
> Example line for tip prompt.
{: .prompt-tip }

> Example line for info prompt.
{: .prompt-info }

> Example line for warning prompt.
{: .prompt-warning }

> Example line for danger prompt.
{: .prompt-danger }
```

## Mathematics

> - User `\vert` instead of `|` because it will start a table sometimes.
> - Use `$$ $$`, `\$$ $$`, and `\$\$ $$` to add in-line math eqations. [(Kramdown Doc)](https://kramdown.gettalong.org/syntax.html#math-blocks)
{: .prompt-tip }

### Block Math

> Block math need a **mandatory** blank line before and after the `$$` sign.
{: .prompt-tip }

#### Single Equation

$$
f(\lambda x_2 + (1 - \lambda) x_1) \leq \lambda f(x_2) + (1 - \lambda) f(x_1)
$$


```markdown
<Mandatory Blank Line>
$$
f(\lambda x_2 + (1 - \lambda) x_1) \leq \lambda f(x_2) + (1 - \lambda) f(x_1)
$$
<Mandatory Blank Line>
```

#### Mutiple Equations

$$
\displaylines{ x = a + b \\ y = b + c }
$$

```markdown
<Mandatory Blank Line>
$$
\displaylines{ x = a + b \\ y = b + c }
$$
<Mandatory Blank Line>
```

#### Align Multiple Equations

$$
\begin{align}
D_{KL}(P^{*}(y|x_i) \vert \vert P(y|x_i; \Theta)) 
    &= \sum_{y} P^*(y|x_i) log \frac{P^*(y|x_i)}{P(y|x_i; \Theta)} \\
    &= \sum_{y} P^*(y|x_i)[logP^*(y|x_i) - logP(y|x_i; \Theta)] \nonumber\\
    &= \sum_{y} P^*(y|x_i)logP^*(y|x_i) - \sum_{y} P^{*}(y|x_i)logP(y|x_i; \Theta)
\end{align}
$$

```markdown
<Mandatory Blank Line>
$$
\begin{align}
D_{KL}(P^{*}(y|x_i) \vert \vert P(y|x_i; \Theta)) 
    &= \sum_{y} P^*(y|x_i) log \frac{P^*(y|x_i)}{P(y|x_i; \Theta)} \\
    &= \sum_{y} P^*(y|x_i)[logP^*(y|x_i) - logP(y|x_i; \Theta)] \nonumber\\
    &= \sum_{y} P^*(y|x_i)logP^*(y|x_i) - \sum_{y} P^{*}(y|x_i)logP(y|x_i; \Theta)
\end{align}
$$
<Mandatory Blank Line>
```

> Use `\nonumber` to disable the number behind equations.
{: .prompt-tip }

#### System of Equations

$$
V_i =
\begin{cases}
    -1, \text{ Not firing} \\
    +1, \text{ Firing at maximum rate} \\
\end{cases}
$$

```markdown
<Mandatory Blank Line>
$$
V_i =
\begin{cases}
    -1, \text{ Not firing} \\
    +1, \text{ Firing at maximum rate} \\
\end{cases}
$$
<Mandatory Blank Line>
```

#### Matrix

$$
\textbf{W} = \sum_s
    \begin{bmatrix}
        0 & w_{12} & w_{13} & \dots & w_{1N} \\
        w_{21} & 0 & w_{23} & w_{24} & w_{2N} \\
        w_{31} & w_{32} & 0 & w_{34} & w_{3N} \\
        \vdots & \vdots & \vdots & \ddots & \vdots \\
        w_{N1} & w_{N2} & w_{N3} & \dots & 0 \\
    \end{bmatrix}_{s=1, 2, 3, \dots, n}
$$

```markdown
<Mandatory Blank Line>
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
<Mandatory Blank Line>
```

### Arrows

$$
\xleftarrow[\text{Text Below}]{\text{Text Above}}
$$

$$
\xrightarrow[\text{Text Below}]{\text{Text Above}}
$$

```markdown
<Mandatory Blank Line>
$$
\xleftarrow[\text{Text Below}]{\text{Text Above}}
$$
<Mandatory Blank Line>
$$
\xrightarrow[\text{Text Below}]{\text{Text Above}}
$$
<Mandatory Blank Line>
```

### Underbrace

$$
\underbrace{\begin{bmatrix} v_1 \\ v_2 \\ v_3 \\ v_4 \end{bmatrix}}_{v}
    =\underbrace{\begin{bmatrix} r_1 \\ r_2 \\ r_3 \\ r_4 \end{bmatrix}}_{r} 
    + \gamma \underbrace{
                \begin{bmatrix} 
                    0 & 1 & 0 & 0 \\ 
                    0 & 0 & 1 & 0 \\ 
                    0 & 0 & 0 & 1 \\ 
                    1 & 0 & 0 & 0 
                \end{bmatrix}}_{P}
    \underbrace{\begin{bmatrix} v_1 \\ v_2 \\ v_3 \\ v_4 \end{bmatrix}}_{v}
$$

```markdown
$$
\underbrace{\begin{bmatrix} v_1 \\ v_2 \\ v_3 \\ v_4 \end{bmatrix}}_{v}
    =\underbrace{\begin{bmatrix} r_1 \\ r_2 \\ r_3 \\ r_4 \end{bmatrix}}_{r} 
    + \gamma \underbrace{
                \begin{bmatrix} 
                    0 & 1 & 0 & 0 \\ 
                    0 & 0 & 1 & 0 \\ 
                    0 & 0 & 0 & 1 \\ 
                    1 & 0 & 0 & 0 
                \end{bmatrix}}_{P}
    \underbrace{\begin{bmatrix} v_1 \\ v_2 \\ v_3 \\ v_4 \end{bmatrix}}_{v}
$$
```

### Display Modes

Default display math mode

$$
    \sum_{a} \pi (a \vert s) = 1
$$

Force in-line math mode

$$
    \textstyle \sum_{a} \pi (a \vert s) = 1
$$

- Defualt in-line math mode: $$ \sum_{a} \pi (a \vert s) = 1 $$
- Force display math mode: $$ \displaystyle \sum_{a} \pi (a \vert s) = 1 $$

```markdown
Default display math mode
<Mandatory Blank Line>
$$
    \sum_{a} \pi (a \vert s) = 1
$$
<Mandatory Blank Line>
Force in-line math mode
<Mandatory Blank Line>
$$
    \textstyle \sum_{a} \pi (a \vert s) = 1
$$
<Mandatory Blank Line>
- Defualt in-line math mode: $$ \sum_{a} \pi (a \vert s) = 1 $$
- Force display math mode: $$ \displaystyle \sum_{a} \pi (a \vert s) = 1 $$
```

### Fonts

$$
\begin{align}
&\text{mathbb: } \mathbb{ABCDEFGHIJKLMNOPQRSTUVWXYZ}\\
&\text{mathcal: } \mathcal{ABCDEFGHIJKLMNOPQRSTUVWXYZ}\\
&\text{mathfrak: } \mathfrak{ABCDEFGHIJKLMNOPQRSTUVWXYZ}\\
&\text{mathrm: } \mathrm{ABCDEFGHIJKLMNOPQRSTUVWXYZ}\\
&\text{mathbf: } \mathbf{ABCDEFGHIJKLMNOPQRSTUVWXYZ}\\
&\text{mathsf: } \mathsf{ABCDEFGHIJKLMNOPQRSTUVWXYZ}\\
&\text{mathtt: } \mathtt{ABCDEFGHIJKLMNOPQRSTUVWXYZ}
\end{align}
$$

```markdown
$$
\begin{align}
&\text{mathbb: } \mathbb{ABCDEFGHIJKLMNOPQRSTUVWXYZ}\\
&\text{mathcal: } \mathcal{ABCDEFGHIJKLMNOPQRSTUVWXYZ}\\
&\text{mathfrak: } \mathfrak{ABCDEFGHIJKLMNOPQRSTUVWXYZ}\\
&\text{mathrm: } \mathrm{ABCDEFGHIJKLMNOPQRSTUVWXYZ}\\
&\text{mathbf: } \mathbf{ABCDEFGHIJKLMNOPQRSTUVWXYZ}\\
&\text{mathsf: } \mathsf{ABCDEFGHIJKLMNOPQRSTUVWXYZ}\\
&\text{mathtt: } \mathtt{ABCDEFGHIJKLMNOPQRSTUVWXYZ}
\end{align}
$$
```

### Dots

- **\ldots** for horizontal dots on the line
- **\cdots** for horizontal dots above the line
- **\vdots** for vertical dots
- **\ddots** for diagonal dots

$$
\Sigma=\left[
\begin{array}{ccc}
   \sigma_{11} & \cdots & \sigma_{1n} \\
   \vdots & \ddots & \vdots \\
   \sigma_{n1} & \cdots & \sigma_{nn}
\end{array}
\right]
$$

```markdown
$$
\Sigma=\left[
\begin{array}{ccc}
   \sigma_{11} & \cdots & \sigma_{1n} \\
   \vdots & \ddots & \vdots \\
   \sigma_{n1} & \cdots & \sigma_{nn}
\end{array}
\right]
$$
```
