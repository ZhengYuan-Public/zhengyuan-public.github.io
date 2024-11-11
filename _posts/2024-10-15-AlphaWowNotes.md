---
comments: true
title: AlphaWow Notes
date: 2024-10-15 12:00:00
image:
    path: /assets/img/images_preview/WotLKWeakAuraPreview.jpg
math: true
categories: [Machine Learning, Reinforcement Learning]
tags: [machine-learning, reinforcement-learning]
---

> Some techniques discussed here may break the **Terms of Use Agreement** of World of Warcraft. **DONOT** use this for commercial purposes!
{: .prompt-danger }

## Task description

There are mainly two types of gameplay involved in World of Warcraft, **Player vs Environment (PvE)** and **Player vs Player (PvP)**. PvP denotes combat between players of any kind, including **duels**, **battleground**, **world PvP** and **arena**. PvE refers to any type of play that does not include PvP, such as **raids**, **dungeons**, and **questing**.

This project focues on **dungeons** and **raids** in PvE and PvP since they share similar components. It's obvious **questing** in PvE involves **NLP**, which will be explored in the next step.

### PvE (Dungeons and Raids)

#### Agents

There should be four types of (abstract) agents in **PvE (D&R)**
- Tank(s)
- DPS(s)
- Healer(s)
- One **Group/Raid Leader**

#### 

There are mainly XXX types of roles in **PvE (D&R)** environment: 
- Player $$ (5, 10, 25, \dots) $$
- Hostile NPCs
    - Bosses
    - Normal mobs (Could be modeled as Bosses)
- Friendly NPCs
    - Non-combat NPCs
    - Combat NPCs
- Vehicles

As player gain experience about playing **PvE (D&R)**, they became aware of the role **Group/Raid Leader** and have "build models" of hostile NPCs by


The main goal for each role:

Tank: Group/Raid Function - Take damage from 
DPS: 
Healer: 

#### Subsystems

- Movement
- Combat
- 



### PvP (To Be Filled)



## Data Collection Design

### Game Environment Analysis

#### Coordinate System

The API only exposes the $$ (x, y) $$ coordinates in the zone map where the palyer is located. This bring chalenges to some movement control involving the $$ z $$-axis (such as flying during the ICC fight [Valithria Dreamwalker](https://wowpedia.fandom.com/wiki/Valithria_Dreamwalker)).

#### Movement Control

![img-description](/assets/img/images_alphawow/YawPitchRoll.png){: style="max-width: 400px; height: auto;"}

1. **Yaw**
    - Range: $$ [0, 2 \pi] $$ (counterclockwise)
    - $$ 0 $$: point to North
2. **Pitch**
    - Range: $$ [-1, 1] $$ (unit $$ \pi / 2 $$)
    - $$ 0 $$: horizontal
    - $$ [-1, 0) $$: looking downwards
    - $$ (0, 1] $$: looking upwards
3. **View Angle**
    - Range: $$ [0, 2 \pi] $$ (counterclockwise)
    - $$ 0 $$: point to North
4. **View Distance (System)**
    - Camera view distance
    - Maximum value: $$ 50 $$(when interface settings are set to max)
5. **View Distance (Current)**
    - Current camera view distance. Change based on character's **View Angle** and/or **Terrain**
    - The value is calculated and used as a destination. For example, when you stand right against a wall and your character is facing forwards, the value will be calculated and stored if the value is not the same as system view distance
6. **View Distance (Dynamic)**
    - This value is likely used to render frames, which smoothly transits between `view_distance_sys` and `view_distance_current`


## Environment Setup

> Based on **Ubuntu-24.04 Server**.
{: .prompt-tip }

### Install Desktop

```bash
sudo apt-get update
sudo apt-get install ubuntu-desktop-minimal

sudo reboot
```

### Siwtch between Server and Desktop

```bash
sudo systemctl isolate multi-user.target

# Enable persistence mode for NVIDIA driver
sudo nvidia-smi -pm 1
```

```bash
sudo systemctl isolate graphical.target
```

## Implementation

### Information Using WoW API

### Information Using AOB Injection

> This may break the Terms of Use Agreement. **DONOT** use this for commercial purposes!
{: .prompt-warning }

#### Offsets

> Offsets were retrived using CheatEngine.
{: .prompt-info }

```python
# Base address is wow.exe
direct_offsets = {
    # Coordinates
    'x': 0x6DF4E4,
    'y': 0x6DF4E8,
    'z': 0x6DF4EC,
    # Movement Control
    'yaw': 0x7EBA70,
    'pitch': 0x6DF610,
    # Camera
    'view_angle': 0x938B3C
    }

# Base address is a value hold in an esi register
oblique_offsets = {
    # View Distance
    'vd_system': 0x1E8,
    'vd_frame': 0x118
    }
```

- The bottom right corner is defined as (0, 0, 0) in a map.


