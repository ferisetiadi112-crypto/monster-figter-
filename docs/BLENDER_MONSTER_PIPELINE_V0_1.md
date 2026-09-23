# Monster Fighter — Blender Monster Production Pipeline v0.1

## Goal

Create original, Roblox-ready creature assets while preserving the Monster Design System and server/domain identity.

## Benchmark Asset Order

1. Pyroxi
2. Aquavi
3. Florune

Do not begin mass production of 20–30 species until these three pass the benchmark gate.

## Pyroxi Asset Brief

### Identity
- Species: Pyroxi
- Core: Ember
- Rarity: Common
- Target height: ~35 cm
- Body: compact quadruped
- Personality: brave, energetic, curious

### Shape Language
- Rounded compact torso
- Slightly oversized head
- Short but readable legs
- Expressive ears
- Distinctive ember/flame tail
- Clear chest marking
- Large expressive eyes

### Modeling Priority
1. Silhouette
2. Face
3. Ear shape
4. Tail shape
5. Paw/leg readability
6. Chest marking
7. Small surface details

## Technical Asset Rules

- Build an original mesh; do not trace or recreate protected character designs.
- Keep the primary silhouette recognizable without textures.
- Use a stable root bone.
- Separate cosmetic geometry from combat hitbox.
- Keep facial features readable at normal third-person camera distance.
- Avoid unnecessary tiny geometry.
- Use clean topology around joints and deformation areas.
- Apply transforms before export.
- Keep scale consistent with the game's target creature size.
- Name objects and bones consistently.

## Suggested Rig

Root
├── Body
├── Head
│   ├── Ear_L
│   └── Ear_R
├── Leg_FL
├── Leg_FR
├── Leg_BL
├── Leg_BR
└── Tail

Additional facial bones are optional for the first prototype.

## Required Animation Clips

- Idle
- Walk
- Run
- Follow
- Attack
- Skill
- Hit
- Dodge
- Guard
- Victory
- Defeat
- Happy
- Sad
- Sleep

## Export Gate

Before importing to Roblox:
- mesh faces/normals verified;
- transforms applied;
- skeleton named consistently;
- animation clips separated;
- texture/material assignments verified;
- origin/root orientation verified;
- polygon/material count reviewed;
- test export performed.

## Roblox Integration

After import:
- create AnimationController/Animator for non-Humanoid creature rigs where appropriate;
- keep combat hitboxes separate from visual mesh;
- attach VFX to named attachment points;
- map animation names to the Monster Fighter animation set;
- connect Species and MonsterID through server-authoritative systems.

## Quality Gate

The asset is ready for gameplay only when:
- it reads clearly at gameplay distance;
- idle/follow/attack animations look natural;
- collision and hitbox behavior are predictable;
- it does not create excessive client performance cost;
- the silhouette remains distinct from other species.
