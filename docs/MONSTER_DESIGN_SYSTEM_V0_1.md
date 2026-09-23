# Monster Fighter — Monster Design System v0.1

## Purpose

This document is the visual production standard for Monster Fighter monsters. It is designed to keep all species visually original, collectible, readable in third-person gameplay, and consistent as one game world.

## Visual Pillars

1. **Readable silhouette** — each species must be identifiable at thumbnail and gameplay distance.
2. **Expressive face** — eyes and mouth communicate personality without relying on text.
3. **Compact creature scale** — initial species target is approximately 20–60 cm.
4. **Original anatomy** — avoid recognizable copies of existing franchise creatures.
5. **Core identity** — Ember, Tide, Bloom, Pulse, Terra, Gale, Frost, Void, and Radiant influence shape, material, markings, and VFX.
6. **Rarity is design, not recolor** — Rare/Epic/Legendary/Mythic variants should gain meaningful visual distinction, not merely a palette swap.
7. **Animation-first design** — proportions must support idle, walk, run, attack, hit, dodge, victory, defeat, and expressive companion animations.

## Production Pipeline

Concept → Base Mesh → Sculpt/Shape → Retopology → UV → Texture → Rig → Animation → Roblox Import → LOD/Optimization → VFX/SFX integration.

## Species Benchmark

### Pyroxi
- Core: Ember
- Rarity: Common
- Target size: 35 cm
- Silhouette: compact rounded body, oversized head, short legs, expressive ears, distinctive flame-tail.
- Personality: brave, energetic, curious.
- Palette direction: warm ember/orange family with darker charcoal accents.
- Signature feature: tail tip behaves visually like a contained ember.
- Animation personality: quick head turns, energetic idle, small hops when excited.
- Combat identity: fast close-range strikes and ember bursts.

### Aquavi
- Core: Tide
- Rarity: Common
- Target size: 40 cm
- Silhouette: smooth rounded aquatic body, fin-like ears, flexible tail, slightly oversized eyes.
- Personality: playful, calm, observant.
- Palette direction: blue/cyan family with soft pearl accents.
- Signature feature: translucent water-like fin/tail elements.
- Animation personality: gentle swaying, playful spins, curious leaning.
- Combat identity: fluid ranged/area attacks and evasive movement.

### Florune
- Core: Bloom
- Rarity: Common
- Target size: 30 cm
- Silhouette: small quadruped, leaf-like ears, rounded body, flower/leaf growths integrated into anatomy.
- Personality: friendly, intelligent, protective.
- Palette direction: green family with natural floral accents.
- Signature feature: living leaf/flower growth that reacts to emotion.
- Animation personality: gentle breathing, ear movement, small plant growth reactions.
- Combat identity: support, regeneration, roots/vines, controlled area effects.

## Rarity Visual Language

### Common
Strong simple silhouette, limited surface complexity, restrained VFX.

### Rare
One additional signature anatomical feature, richer material detail, subtle aura/VFX.

### Epic
More complex silhouette, distinctive markings/materials, visible combat VFX identity.

### Legendary
Highly recognizable silhouette, multiple signature features, premium animation/VFX language.

### Mythic
Exceptionally distinctive anatomy and presentation. Mythic must remain readable and playable rather than becoming visually noisy.

## Modeling Rules

- Prefer smooth stylized forms over excessive micro-detail.
- Eyes must remain readable from normal third-person distance.
- Avoid excessive tiny parts that create Roblox performance cost.
- Important silhouette features should use geometry, not only textures.
- Feet/limbs must have enough clearance for animation.
- Tail/ears/wings must have deliberate rig attachment points.
- Every monster requires a stable root and animation-ready rig.
- Keep combat hitbox separate from cosmetic geometry.

## Animation Minimum

Every production monster should eventually have:
- Idle
- Walk
- Run
- Follow
- Attack
- Skill
- Hit
- Dodge
- Guard/Parry
- Victory
- Defeat
- Happy
- Sad
- Sleep

## Collectibility Rules

A monster should be collectible because of a combination of:
- species identity;
- core;
- rarity;
- gender;
- traits;
- genetics;
- mutation;
- lineage;
- battle history;
- bond;
- generation;
- legacy.

Do not make collection value depend only on rarity color.

## Benchmark Gate

Before producing 20–30 species, the first three benchmark monsters must pass:
- visual distinctiveness;
- same-world visual consistency;
- readable silhouette;
- Roblox performance suitability;
- animation suitability;
- combat readability;
- screenshot/thumbnail appeal.

Only after the benchmark gate passes should the production library expand.
