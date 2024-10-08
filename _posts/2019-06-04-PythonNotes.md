---
comments: true
title: Python Notes
date: 2019-06-04 12:00:00
image:
    path: /assets/img/images_preview/PythonNotesPreview.png
mermaid: true
categories: [Programming and Development, Python]
tags: [programming, python]
---

## Quick Introduction

Python is an ***interpreted*** programming language where codes go through a program called *interpreter*, which reads and executes the code line by line. 

- Flexible
- Platform independent

Python is popular for 

- Machine Learning (PyTorch, TensorFlow)
- Data Science (numpy, pandas, matplotlib, scikit-learn) 
- Large-scale web application (Django).

## Install Python

- From [official release](https://www.python.org/downloads/)

- From [anaconda](https://www.anaconda.com/download) or [miniconda](https://docs.conda.io/en/latest/miniconda.html#latest-miniconda-installer-links) (recommended)

## Virtual Environment 

It's recommended to create a virtual environment for each of your project.

### Python Venv

```shell
$ python -m venv /path/to/new/virtual/environment

# Example
$ pwd
/Users/zheng/Documents/demo
$ python -m venv project_venv
# Activate venv
$ source project_venv/bin/activate
# Verify
$ which python
/Users/zheng/Documents/demo/project_venv/bin/python
```

### Anaconda/Miniconda Venv

```shell
# Create venv
# https://docs.conda.io/projects/conda/en/latest/commands/create.html
$ conda create -n project_venv python=3.11
# List conda venvs
$ conda env list
base                  *  /Users/zheng/miniconda3
CV                       /Users/zheng/miniconda3/envs/CV
Django                   /Users/zheng/miniconda3/envs/Django
# Activate venv
$ conda activate CV
```

### Install Python Libraries

```shell 
pip install <lib_name>
```

*With the flag `-i`, you can specify *PyPi* (The Python Package Index)

```bash
# A collection of PyPi for users in China
# -----------------------------------------------------#
https://pypi.tuna.tsinghua.edu.cn/simple/
https://mirrors.aliyun.com/pypi/simple/
https://repo.huaweicloud.com/repository/pypi/simple/
# -----------------------------------------------------#

# Example
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple/ numpy
```

## Variables

### Python Variable Names

[Naming Conventions](https://zhengyuan-public.github.io/posts/ProgrammingNotes/#style-guides):link:

- Must start with a letter `[A-z]` or `_`
- Can NOT start with a number`[0-9]`
- Contain ONLY  `[A-z]`, `[0-9]` and `_`
- Are case-sensitive `Name` ≠ `name`

### Numerical Variables

```python
# Define variables
>>> a = 2
>>> b = 10
>>> c = 3

# 1. Numerical Operations: 
#	 +-*/
# 2. Power
>>> a ** b
1024
# 3. Mod
>>> b % c
1
# 4. To string variables
>>> str(a)
'2'
```

*You can get get the type of any variable with `type(<var_name>)`

### String Variables

```python
# Define variables
>>> a = "TeSt"
>>> b = "2"

# 1. title(), lower() and upper() methods
>>> a.title()
'Test'
>>> a.lower()
'test'
>>> a.upper()
'TEST'

# 2. strip(), lstrip() and rstrip() methods
>>> c = ",.+-* TeSt *-+.,"
>>> c.strip(",.+-* ")
'TeSt'
>>> c.lstrip(",.+-* ")
'TeSt *-+.,'
>>> c.rstrip(",.+-* ")
',.+-* TeSt'

# 3. Combine strings together
>>> a + " " + b
'TeSt 2'

# 4. To other types
>>> int(b)
2
>>> float(b)
2.0
```

## Loops

### Loop with if

```python
if condition_1:
    function_1
    return return_value
elif condition_2:
    function_2
    return return_value
else condition_3:
    function_3
    return return_value
```

### Loop with while

```python
while condition:
    function
    if break_condition:
        break
    if continue_condition:
        continue
    if pass_condition:
        pass
```

- ***Break*** will terminate the loop
- ***Continue*** will only terminate/skip the current iteration
- ***Pass*** is typically used as a placeholder for future code

## Normal Function Arguments

> **Parameters** are **placeholders** in a function definition, while **Arguments** are **actual values** passed during function invocation
>
> > [Defining Your Own Python Function](https://realpython.com/defining-your-own-python-function/) :link:

### Positional Arguments

- Internally, values in `*args` as represented as in a `tuple`
- The name `args` can be named arbitrarily

```python
def cal_average(*int_nums):
    sum = 0
    for item in int_nums:
        sum += item
    return sum / len(int_nums)

>>> cal_average(1, 2)
1.5
>>> cal_average(*[i for i in range(10)])
4.5
```

### Keyword Arguments

- Internally, values in `**kwargs` as represented as in a `dict`
- The name `kwargs` can be named arbitrarily

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

### All-in-One

```python
def aio_func(a, b, *args, **kwargs):
    print(a)
    print(b)
    print(args)
    print(kwargs)


>>> aio_func(1, 2, 3, 4, 5, first_name='Zheng', last_name='Yuan')
1
2
(3, 4, 5)
{'first_name': 'Zheng', 'last_name': 'Yuan'}

# a, b are positional arguments
# 3, 4, 5 are also positional arguments
# first_name, last_name are keyword arguments
```

## X-Only Function Arguments

### Why do we need them? 

```python
# Q: In the following function, how to give the prefix a default value?
def concat(prefix, *args):
    print(f'{prefix}{".".join(args)}')

>>> concat('//', 'a', 'b', 'c')
//a.b.c


# 1. Try-1
def concat(prefix='-> ', *args):
    print(f'{prefix}{".".join(args)}')

>>> concat('a', 'b', 'c')
ab.c
# This won't work because prefix is a positional argument, so when invoking
# the function call, 'a' will replace the default value '-> '. 
# Actually, the default value can never be reached.

# 2. Try-2
>>> concat(prefix='//', 'a', 'b', 'c')
	 File "<stdin>", line 1
    concat(prefix='//', 'a', 'b', 'c')
                                     ^
SyntaxError: positional argument follows keyword argument
# This also won't work, because python requires keyword arguments after 
# positional arguments

# 3. Try-3
>>> concat('a', 'b', 'c', prefix='... ')
	File "<stdin>", line 1, in <module>
TypeError: concat() got multiple values for argument 'prefix'
# As Try-1, 'a' is thought to be the positional argument prefix, but it's given again.

# This only works for python3
def concat(*args, prefix='-> '):
	print(f'{prefix}{".".join(args)}')
    
>>> concat('a', 'b', 'c')
-> a.b.c


def concat(*args, prefix='-> ', sep='.'):
    print(f'{prefix}{sep.join(args)}')
    
>>> concat('a', 'b', 'c', prefix='//', sep='-')
//a-b-c

# In examples above, prefix and sep are both keyword-only arguments
```

### Keyword-Only Arguments

The bare variable argument parameter `*` indicates that there aren’t any more positional parameters.

```python
def oper(x, y, *, op='+'):
    if op == '+':
        return x + y
    elif op == '-':
        return x - y
    elif op == '/':
        return x / y
    else:
        return None
 
>>> oper(3, 4, '+')
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: oper() takes 2 positional arguments but 3 were given

>>> oper(3, 4, "I don't belong here")
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: oper() takes 2 positional arguments but 3 were given
```

```python
# https://peps.python.org/pep-3102/
# Old syntax and fix
def compare(a, b, *ignore, key=None):
    # The ‘ignore’ argument will also suck up any erroneous positional arguments
    if ignore:
        raise TypeError
    do_smth

# New syntax
def compare(a, b, *, key=None):
    do_smth
```

### Positional-Only Arguments

[Python 3.8: Cool New Features for You to Try](https://realpython.com/python38-new-features/#positional-only-arguments) :link:

The bare variable argument parameter `/` indicates that parameters ***before*** it are positional-only (cannot be passed by keyword) and parameters ***after*** it are regular arguments that can be passed either by position or keyword.

```python
# Python 3.8
def f(x, /, y):
    print(x)
    print(y)

>>> f(x=1, y=2)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: f() got some positional-only arguments passed as keyword arguments: 'x'

>>> f(1, y=2)
1
2

>>> f(1, 2)
1
2
```

### All-in-One

```python
def f(a, b, c, /, d, e, */, f, g):
    do_smth

# a, b, c are postitional-only arguments
# d, e are normal arguments
# f, g are keyword-only arguments
```

## Metaprogramming

> Metaprogramming is about creating functions and classes whose main goal is to **manipulate code**.
{: .prompt-info }

### Decorators

[Primer on Python Decorators](https://realpython.com/primer-on-python-decorators/) :link:

[PEP 318 – Decorators for Functions and Methods](https://peps.python.org/pep-0318/) :link:

> Decorators wrap a function, modifying its behavior.
{: .prompt-tip }

```python
def my_decorator(func):
    def wrapper_func(*args, **kwargs):
        do_smth
        result = func(*args, **kwargs)
        do_smth
        return result
    return wrapper_func
    
def foo_func():
    do_smth
    
# 1. The complicated way
result = my_decorator(foo_func(my_args, my_kwargs))

# 2. The easy way
@my_decorator
def foo_func():
    do_smth
    
results = foo_func(my_args, my_kwargs)
```

Problem: Important metadata such as the name, doc string, annotations, and calling signatures are lost. Workarounds $$ \longrightarrow $$

```python
from functools import wraps

def my_decorator(func):
    @wraps
    def wrapper_func(*args, **kwargs):
        do_smth
        result = func(*args, **kwargs)
        do_smth
        return result
    return wrapper_func
```

### Class Decorators

### Meta Classes

## Lambda Function

[Lambda expressions in Python](https://note.nkmk.me/en/python-lambda-usage/) :link:

```python
# Converting a simple function
def function_name(param_1, param_2, ...):
    return do_smth

lambda param_1, param_2, ...: do_smth

# Converting a simple function with if
def function_name(param_1, param_2, ...):
    if condition:
        do_smth_1
    else:
        do_smth_2

lambda param_1, param_2: do_smth_1 if condition else do_smth_2
```

## Function Annotations			

[PEP 3107 – Function Annotations](https://peps.python.org/pep-3107/)

```python
# Some demo syntax
def demo_func(param_1: tuple = (1, 2, 3), 
              param_2: int = 1024,
              param_3: float = 1.0) -> bool:
    do_smth
```

## Data Structure

## File Operations

## Object-Oriented Programming
