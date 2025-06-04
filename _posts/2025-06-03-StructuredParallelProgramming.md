---
comments: true
title: Structured Parallel Programming (Patterns for Efficient Computation)
date: 2025-06-03 12:00:00
image:
    path: /assets/img/images_preview/StructuredParallelProgramming.png
math: true
categories: [Programming and Development, Parallel Programming]
tags: [programming, parallel-programming]
---

## All-in-One Summary

### Serial Traps

> Serial traps are constructs that make, often unnecessary, serial assumptions.
{: .prompt-tip }

1. 
2. 
3. 

### Parallel Patterns

1. **Nesting**
   - patterns can be hierarchically composed (important for **modular programming**)
   - extensively used in serial programming for **composability** and **information hiding**
   - challenging in parallel programming

    > The key to implementing nested parallelism is to specify **optional**, not mandatory, parallelism.
    {: .prompt-info }

2. **Map**
  - divides a problem into a number of uniform parts and represents a regular parallelization (a.k.a. **embarrassing parallelism**)
  - worth using whenever possible

3. **Fork-Join**
   - recursively subdivides a problem into subparts (**divide-and-conquer**)

> These three patterns also emphasize that in order to achieve scalable parallelization we should focus on **data parallelism**: the subdivision of the problem into subproblems, with the number of subproblems able to grow with the overall problem size.
{: .prompt-tip }


---
## Chapter 1. Introduction

### Think Parallel
1. Recognize **Serial Traps**
2. Programming in terms of **Parallel Patterns** that capture best practices and **using efﬁcient implementations** of these patterns

### Design a Parallel Algorithm
When designing a parallel algorithm, it's important to pay attention to three thinkgs:
1. The total amount of computational work.
2. The span (i.e., cirtical path).
    - The **Span** of an algorithm is the time it takes to perform the longest chain of tasks that must be performed sequentially. Frequently, imporved performance requires finding an alternative way to solve a problem that *shortens the span*.
3. The total amount of communication (including that implicit in sharing memory).
    - **Communication** is **NOT** free, nor is its cost uniform. **Locallity** is a relatively simple abstraction which asserts that memory accesses close together in time and space (and communication between processing units that are close to each other in space) are cheaper than those that are far apart. 

### Motivation

#### Three Walls
1. **Power wall**: Unacceptable growth in power usage with clock rate. Power consumption (and heat generation) increases non-linearly as the clock rate increases.
2. **Instruction-level parallelism (ILP) wall**: Limits to available low-level parallelism. 
    - Superscalar instruction issue (if two nearby instructions do not depend on each other, modern processors can often start them both at the same time)
    - Very Large Instruction Word (VLIW) processing (the analysis of which instructions to execute in parallel is done in advance by the compiler)
    - Pipelining (many operations are broken into a sequence of stages so that many instructions can be processed at once in an assembly-line fashion)
3. **Memory wall**: A growing discrepancy of processor speeds relative to memory speeds.
    - off-chip memory rates have not grown as fast as on-chip computation rates
    - there are two problems with memory (and communication): 
        - latency: subject to fundamental limits, but can be hidden given sufﬁcient additional parallelism
        - bandwidth

    > Algorithms need to be structured to **avoid memory access and communication as much as possible**, and fundamental limits on latency create even more requirements for parallelism.
    {: .prompt-tip }

### Structured Pattern-based Programming

| Design Pattern | Algorithm Strategy Patterns | Implementation Patterns |
| :------------: | :-------------------------: | :---------------------: |
| Very abstract  |          Moderate           |      Very specific      |

### Desired Properties

#### Performance
Achievable, scalable, predictable, and tunable.

- **Data Parallelism** is the key to achieving scalability.

#### Productivity
Expressive, composable, debuggable, and maintainable.

- Composability is the ability to use a feature without regard to other features being used elsewhere in your program.

#### Portability
Functionality and performance, across operating systems and compilers.
- Focus on the **decomposition of the problem** and the **design of the algorithm**
- Avoid directly using hardware mechanisms. Instead, you should use abstractions that map onto those mechanisms.
    - eg: avoid vector intrinsics that map directly onto vector instructions and instead use array operations;
    - eg: avoid using threads directly and program in terms of a task abstraction;

    > Three big reasons to avoid programming directly to speciﬁc parallel hardware mechanisms:
    > 1. Portability is impaired severely when programming “close to the hardware.”
    > 2. Nested parallelism is important and nearly impossible to manage well using the mandatory parallelism implied by speciﬁc mechanisms such as threads.
    > 3. Other mechanisms for parallelism, such as vectorization, exist and need to be considered. In fact, some implementations of a parallel algorithm might use threads on one machine and vectors on another, or some combination of different mechanisms.
    {: .prompt-info }

## Chapter 2. Background

