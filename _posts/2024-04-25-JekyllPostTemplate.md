---
comments: true
title: Jekyll Post Template
date: 2024-04-25 12:00:00
image:
    path: /assets/img/images_preview/JekyllPreview.png
math: true
categories: [Programming and Development, Jekyll]
tags: [programming, jekyll]
---

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

## Image

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

