---
comments: true
title: Programming Principles
date: 2019-06-03 12:00:00
image:
    path: /assets/img/images_preview/ProgrammingPreview.png
math: true
categories: [Programming and Development, Programming Principles]
tags: [programming, principle]
---

## Variables Naming Conventions

### Most popular naming conventions

For example, naming two variables first name and last name

* Camel Case :point_right: `firstName`, `lastName`
* Snake Case :point_right: `first_name`, `last_name`	
* Kebab Case :point_right: `first-name`, `last-name`
* Pascal Case :point_right: `FirstName`, `LastName`

### Style guides
- Python - [PEP 8 – Style Guide for Python Code](https://peps.python.org/pep-0008/) :link: 
- JavaScript - [Airbnb JavaScript Style Guide ](https://github.com/airbnb/javascript):link: 
- Java - [Java style guide ](https://www.cs.cornell.edu/courses/JavaAndDS/JavaStyle.html):link: 
- C# - [C# Coding Convention](https://docs.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/coding-conventions) :link: 
- Go - [Uber Go Style Guide ](https://github.com/uber-go/guide/blob/master/style.md):link: 
- C++ - [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines) :link: 
- PHP - [PSR-12: Extended Coding Style](https://www.php-fig.org/psr/psr-12/) :link: 

## Floating-point Numbers

### FP32

$$
12345 = \underbrace{1.2345}_{significand} \times {\underbrace{10}_{base}}\!\!\!\!\!\!\!^{\overbrace{4}^{exponent}}
$$

- IEEE754 Single-Precision Format 
- Sign bit: 1 bit $$ \{ 0: +; 1: - \} $$
- Exponent: 8 bits $$ [-126, +127] $$ (with an offset of 127, -127 (all zeros), and +128 (all ones) are reserved for special numbers)
- Significand: 24 bits (the 1st bit is always 1, and the rest 23 bits are explicitly stored)

This gives from 6 to 9 significant decimal digits precision.

### FP32 to Decimal

![FP32](https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Float_example.svg/1180px-Float_example.svg.png)

$$
value = (-1)^{b_{31}} \times 2^{(b_{30}b_{29} \dots b_{23})_2 - 127} \times (1.b_{22}b_{21} \dots b_{0})_2
$$

1. \$$ sign = b_{31} = 0 $$
2. \$$ (-1)^{sign} = (-1)^0 = +1 \in \{ -1, +1 \} $$
3. \$$ E = (b_{30}b_{29}...b_{23})_2 = (01111100)_2 = (124)_{10} \in \{1, ..., (2^8-1) - 1 \} = \{1, ..., 254\} $$
4. \$$ 2^{E-127} = 2^{-3} \in \{ 2^{-126}, \dots, 2^{127} \} $$
5. \$$ (1.b_{22}b_{21} \dots b_{0})_2 = 1 + \sum_{i=1}^{23} b_{23 - i}2^{-i} = 1.25 $$
6. \$$ value = (+1) \times 2^{-3} \times 1.25 = + 0.15625 $$

### Decimal to FP32

$$
- 10.75 = - (1.01011)_{2} \times 2^3
$$

1. \$$ sign = b_{31} = 1 $$
2. \$$ (3 + 127)_{10} = (10000010)_2 = (b_{30}b_{29} \dots b_{23})_2 $$
3. \$$ (1.b_{22}b_{21} \dots b_{0})_2 = (1.01011 \underbrace{0 \dots 0}_{18})_2 $$
4. \$$ value = 1\ 10000010\ 01011 \underbrace{0 \dots 0}_{18} $$

#### Reference

- [FP64, FP32, FP16, BFLOAT16, TF32, and other members of the ZOO](https://moocaholic.medium.com/fp64-fp32-fp16-bfloat16-tf32-and-other-members-of-the-zoo-a1ca7897d407)
- [Single-precision floating-point format](https://en.wikipedia.org/wiki/Single-precision_floating-point_format)
