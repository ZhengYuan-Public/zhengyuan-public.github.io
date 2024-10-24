---
comments: true
title: Lua Notes (World of Warcraft)
date: 2024-10-15 12:00:00
image:
    path: /assets/img/images_luawow/LuaPreview.png
math: true
categories: [Programming and Development, Lua]
tags: [programming, lua, world-of-warcraft]
---

## Coordinates

The bottom right corner is defined as $ (0, 0, 0) $ in a map.

### Self xyz
```python
x = 00ADF4E4
y = 00ADF4E8
z = 00ADF4EC
```

## API

### Action

GetActionInfo(slot) - Returns type, id, subtype.

### Activity

ConfirmSummon() - Accepts a summon request.

### Unit

FollowUnit("unit") - Follow an ally with the specified UnitID

GetUnitPitch("unit") - Returns the moving pitch of the unit. (added 3.0.2)
GetUnitSpeed("unit") - Returns the moving speed of the unit. (added 3.0.2)
InviteUnit("name" or "unit") - Invites the specified player to the group you are currently in (added 2.0)

UnitArmor("unit") - Returns the armor statistics relevant to the specified unit.
UnitAttackBothHands("unit") - Returns information about the unit's melee attacks.
UnitAttackPower("unit") - Returns the unit's melee attack power and modifiers.
UnitAttackSpeed("unit") - Returns the unit's melee attack speed for each hand.
UnitAura("unit", index [, filter]) - Returns info about buffs and debuffs of a unit.
UnitBuff("unit", index [,raidFilter]) - Retrieves info about a buff of a certain unit. (updated 2.0)
UnitCanAssist("unit", "otherUnit") - Indicates whether the first unit can assist the second unit.
UnitCanAttack("unit", "otherUnit") - Returns true if the first unit can attack the second, false otherwise.
UnitCanCooperate("unit", "otherUnit") - Returns true if the first unit can cooperate with the second, false otherwise.

UnitGUID("unit") - Returns the GUID as a string for the specified unit matching the GUIDs used by the new combat logs. (added 2.4)

UnitHealth("unit") - Returns the current health, in points, of the specified unit.
UnitHealthMax("unit") - Returns the maximum health, in points, of the specified unit.

UnitInRange("unit") - Returns true if the unit (party or raid only) is in range of a typical spell such as flash heal. (added 2.4)

UnitIsCharmed("unit") - Returns true if the specified unit is charmed, false otherwise.
UnitIsConnected("unit") - Returns 1 if the specified unit is connected or npc, nil if offline or not a valid unit.
UnitIsCorpse("unit") - Returns true if the specified unit is a corpse, false otherwise.
UnitIsDead("unit") - Returns true if the specified unit is dead, nil otherwise.
UnitIsDeadOrGhost("unit") - Returns true if the specified unit is dead or a ghost, nil otherwise.

UnitIsUnit("unit", "otherUnit") - Determine if two units are the same unit.
UnitIsVisible("unit") - 1 if visible, nil if not
UnitLevel("unit") - Returns the level of a unit.
UnitMana("unit") - Returns the current mana (or energy,rage,etc), in points, of the specified unit. (replaced by 'UnitPower' 3.0.2)
UnitManaMax("unit") - Returns the maximum mana (or energy,rage,etc), in points, of the specified unit. (replaced by 'UnitPowerMax' 3.0.2)
UnitName("unit") - Returns the name (and realm name) of a unit.

UnitRace("unit") - Returns the race name of the specified unit (e.g., "Human" or "Troll").
UnitRangedAttack("unit") - Returns the ranged attack number of the unit.
UnitRangedAttackPower("unit") - Returns the ranged attack power of the unit.
UnitRangedDamage("unit") - Returns the ranged attack speed and damage of the unit.
UnitReaction("unit", "otherUnit") - Returns a number corresponding to the reaction (aggressive, neutral or friendly) of the first unit towards the second unit.
UnitResistance("unit", "resistanceIndex") - Returns the resistance statistics relevant to the specified unit and resistance type.

UnitSex("unit") - Returns a code indicating the gender of the specified unit, if known. (1=unknown, 2=male, 3=female) (updated 1.11)
UnitStat("unit", statIndex) - Returns the statistics relevant to the specified unit and basic attribute (e.g., strength or intellect).

### Buff / Debuff

UnitAura("unit", index or "buffName" [,filter]) - Returns information about a buff/debuff of a certain unit.
UnitBuff("unit", index or "buffName" [,castable]) - Retrieves info about a buff of a certain unit.
UnitDebuff("unit", index or "buffName" [,removable]) - Retrieves info about a debuff of a certain unit.

