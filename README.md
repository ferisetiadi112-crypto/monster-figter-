# 🐲 Monster Fighter

> Build. Train. Evolve. Fight. Become a Legend.

## Game Identity
Monster Fighter is an original Roblox 3D action-adventure game about discovering, capturing, raising, breeding, training and fighting small original monsters in a living, controlled ecosystem.

Core fantasy: **the monster is a living companion, not an item.** Monsters physically follow the player. When stored, they remain alive in a private home habitat. There is no capture-ball mechanic.

Monster Fighter must NOT become a Pokémon clone. Do not copy Pokémon names, species, silhouettes, artwork, lore, or protected presentation.

## Visual Direction
- Stylized colorful 3D Roblox-compatible world.
- Large world + small expressive creatures.
- Custom monster anatomy and silhouettes.
- Monsters do NOT use standard blocky Roblox avatar bodies.
- Custom rigs support different body shapes: four-legged, two-legged, flying, floating, tails, wings, horns, etc.
- Friendly, adventurous, cinematic presentation.

## Gameplay Loop
Explore → Find → Capture → Care → Train → Breed → Hatch → Battle → Arena → Earn → Collect → Reincarnate.

Player roles can naturally include Collector, Trainer, Fighter, Breeder and Trader.

## Monster Identity
Every individual monster receives a permanent server-generated MonsterID. Players cannot fabricate MonsterID, species, level, rarity, skills or other authoritative data.

Monster profile can contain: MonsterID, Species, Gender, Core, Rarity, BirthType, BirthDate, Age, Level, XP, Bond, Traits, Skills, Parents, Generation, BreedingCount, BattleHistory, ArenaWins, Owner, CurrentState, LifeNumber and ReincarnationCount.

MonsterID survives reincarnation.

## Initial Monster Scope
Initial target: 20–30 original species. Suggested first set: 20 Common, 5 Rare, 3 Epic, 1 Legendary and 1 Mythic. This is a target, not a requirement to implement everything at once.

Initial monster size target is approximately 20–60 cm. Growth/evolution may change size but should not automatically create giant monsters.

## Core Types
1. Ember — heat/fire
2. Tide — water
3. Bloom — nature
4. Pulse — electricity/energy
5. Terra — earth/rock
6. Gale — wind
7. Frost — ice
8. Void — void/dark energy
9. Radiant — light/bright energy

Core is the primary power family and is different from skills.

## Skills and Genetics
Target combat loadout: Basic Attack, Skill 1, Skill 2, Skill 3 and Ultimate.

Breeding can combine genetic characteristics such as Core gene, hidden trait, attack gene, speed gene, defense gene, skill gene and mutation. The server-side Monster Genetics Engine decides valid inheritance. Not every combination must create a hybrid.

## Age and Lifecycle
Age starts at hatching/birth, not when an egg is created.

- 0–4 days: Baby; care/bond only.
- 5 days: Training unlocked.
- 10 days: Battle unlocked.
- 30 days: Breeding unlocked.

Age is identity/history. Age should not automatically kill a monster.

## Breeding
- Male: maximum 3 breeding events per lifetime.
- Female: maximum 3 egg/breeding cycles per lifetime.

After the breeding limit, the monster remains usable for training, battle and collection.

## Eggs and Incubation
Eggs may come from breeding or approved game systems. Eggs can be placed in an Incubator.

Incubation progress can reach READY, but a ready egg does not hatch without a population slot. Ready eggs wait in a server-controlled queue. There is no forced absolute hatch deadline.

## Population Engine
Each new account contributes +5 Population Capacity. This is population capacity, NOT five free monsters for the player.

Examples: 10 accounts = 50 capacity; 11 accounts = 55; 12 accounts = 60.

One player may own 30 monsters while another owns only 1, as long as total population remains within capacity.

Population pools:
- OWNED — monsters owned by players.
- WILD — free monsters currently living in the world.
- RESERVE — population capacity not yet materialized as a monster.
- STARTER HOLD — protected capacity reserved for a new player's first-monster mission.

Reincarnation does not increase total population.

## Wild Population
Initial world has 5 search locations. Each location has 3 active wild slots. Therefore the initial maximum active wild population is 15.

Initial locations:
- Evergreen Forest
- Ember Valley
- Stone Mountain
- Frost Hollow
- Tide Coast

If a wild monster is captured, its location can receive another valid wild/reincarnated monster when the Population Engine allows it.

If wild slots are full and there are no ready eggs, unused capacity remains RESERVE rather than forcing creation of more wild monsters.

## New Player Starter Hold
Every new account must have a protected path to obtain its first monster.

Flow: New Account → Starter Hold → First Mission → Explore → Find → Capture → First Monster.

The monster is not simply handed to the player. Starter Hold reserves the population slot so another player cannot take the intended starter opportunity.

## Reincarnation
A monster that becomes FALLEN in Arena is not permanently deleted.

Flow: Fallen → Reincarnation Engine → Egg/life path when applicable, or Wild Rebirth when there is no egg path.

MonsterID remains identical across lives. Current life data can reset, while legacy data remains.

Example: MonsterID MNF-000184 may have Life 1 owned by Player A, age 47, 18 Arena wins, then become Fallen; later the same ID can appear as a 2-day-old wild monster and be captured by Player B.

## Legacy
Preserve previous-life history: previous owners, age at Fallen, Arena wins, battles, breeding, life number, Fallen event and reincarnation count.

A wild monster can therefore be discovered with a hidden legendary past.

## Monster Companion and Home
When carried, a monster physically follows the player like a pet/companion. It does not enter a ball.

Every player has a private home. Only the owner can enter. Other players cannot enter another player's home. Do not build visitor permissions for the initial version.

When stored, monsters remain visible and alive in the owner's Habitat/Aviary. They can walk, idle, eat, drink, sleep and interact according to their state.

Possible home facilities: Habitat/Aviary, Incubator, Breeding Area, Training Equipment, Storage, Laboratory, Trophy Room and Legacy Hall.

## Food and Water
Maintenance must be simple and not tedious. Use resource bars rather than manually feeding every monster.

Food and water consumption is calculated from living owned monsters.

Low food/water may reduce training/battle performance, stop breeding and stop bond growth. Hunger/thirst must NOT permanently kill monsters.

## Real-Time 3D Combat
Combat is real-time, third-person and directly controlled by the player. It is NOT turn-based and NOT auto-battle.

Mobile: virtual joystick for movement, touch camera, Attack, Dodge, Parry/Guard, Skill 1, Skill 2, Skill 3 and Ultimate.

PC target: WASD movement, mouse camera, Mouse1 Attack, Q Dodge, F Parry, 1/2/3 Skills, 4 Ultimate.

Required combat mechanics:
- Basic attack and combo.
- Dodge.
- Guard/Parry.
- Perfect Parry with timing window.
- Counter Attack.
- Stagger.
- Skill cooldowns.
- Energy/stamina.
- Damage and critical hits.

Combat must reward timing, positioning and player skill, not only monster level or rarity.

## Damage and Server Authority
Damage is calculated on the server. The client sends action intent; the server validates timing, cooldown, state, hit detection and damage.

Conceptual damage factors may include Power, Skill Modifier, Core Interaction, Critical, Defense and Position. Exact balancing is not locked yet.

Client must never be trusted for damage, HP, Coin, Diamond, ownership, Arena result, monster creation or population.

## Non-Arena Battles
Wild/NPC/quest battles are real-time and player-controlled. Victory gives smaller XP, Coin and skill/attribute progress. Defeat causes recovery/healing, not permanent death.

## Arena
Arena is continuously available. There are no scheduled tournaments, semifinals or finals.

Exactly five tiers:
1. Bronze
2. Silver
3. Gold
4. Titanium
5. Platinum

Players enter, find an opponent and fight in real time.

## Arena Coin Stake
Both players stake Coin. The winner receives the match pot.

Initial balancing proposal:
- Bronze: 100 per player → 200 pot.
- Silver: 500 per player → 1,000 pot.
- Gold: 2,500 per player → 5,000 pot.
- Titanium: 10,000 per player → 20,000 pot.
- Platinum: 50,000 per player → 100,000 pot.

These values are balancing defaults, not permanent economic values.

Arena victories also give larger progression/reward gains than ordinary battles.

## Championship Belts
Each tier has exactly 3 active belts:
- Belt #1
- Belt #2
- Belt #3

Belts are continuously contested, similar to boxing championship belts. There is no tournament final.

Ranking is based on the relevant Arena win record. If a player with the belt stops fighting while another player surpasses their relevant win record, the belt position automatically changes.

Belts belong to the PLAYER status, not permanently to one monster.

## Arena Fallen
A high-risk Arena loss can make the monster FALLEN. The monster's identity is preserved and enters the Reincarnation Engine. Its legacy remains.

## Economy
Coin is the normal in-game currency for home facilities, maintenance, marketplace and Arena stakes.

Diamond is the premium in-game currency. Initial concept: 1 Diamond = 1,000 Coin.

Core Diamond uses: Skills, Premium Monsters and Coin.

Do not create a fake in-game Robux wallet. Robux remains Roblox's platform currency.

## Player Marketplace
Normal player-to-player monster transactions use Coin.

Two sale methods:
- NETT: fixed-price sale.
- BID: auction with seller-defined minimum bid.

Listing details should include species, Core, gender, age, level, rarity, breeding remaining, traits, skills, genetics, lineage, battle history, price, sale type and remaining time.

Monsters cannot be listed while locked by incompatible states such as battle, Arena, breeding or recovery.

## Security
SERVER IS THE SOURCE OF TRUTH.

Never trust client-provided Coin, Diamond, MonsterID, species, rarity, level, XP, skills, damage, Arena results, ownership, marketplace settlement, population or breeding results.

Important transfers must be atomic. Use unique transaction IDs where appropriate to prevent replay/double-spending.

## Valid Monster Creation Paths
Only server-controlled systems may create a new individual:
- Wild spawn
- Starter Hold
- Egg hatch
- Breeding
- Reincarnation
- Approved official event

## Development Milestones
1. Combat Prototype — custom monster rig, camera, movement, attack, HP, damage, mobile controls.
2. Action Combat — combo, dodge, stamina, parry, perfect parry, counter, stagger.
3. Skills — Skill 1/2/3, Ultimate, cooldown and energy.
4. Monster Engine — MonsterID, species, Core, level, XP, age, state.
5. World — Montera and 5 search locations.
6. Home — private home, habitat, companion, incubator.
7. Breeding — eggs, incubation, genetics, breeding limits.
8. Arena — five tiers, stake, PvP, Fallen and belts.
9. Reincarnation — legacy, rebirth and population balancing.
10. Economy — marketplace, NETT, BID, Diamond and premium content.

## AI / Developer Rules
DO preserve MonsterID across reincarnation; preserve server authority; preserve custom monster rigs; preserve real-time player combat; preserve five Arena tiers and three belts per tier; preserve Coin stake; preserve population limits; preserve five wild locations × three slots; preserve Starter Hold; preserve private homes; preserve habitat-based monster storage; preserve legacy.

DO NOT turn combat into turn-based or primary auto-battle; do not put monsters into capture balls; do not use standard blocky Roblox avatars as monster bodies; do not create unlimited wild monsters; do not delete MonsterID after Arena defeat; do not kill monsters from hunger/thirst; do not add scheduled tournament finals unless design is explicitly changed; do not let clients decide damage, Coin, ownership or monster creation; do not copy Pokémon identity.

## Current Repository State
This repository is a Rojo-friendly Roblox/Luau foundation. The current pre-Studio foundation includes:
- default.project.json
- Shared constants, world configuration and species catalog
- Monster identity schema with lifecycle, generation and legacy fields
- Restart-safe server-generated MonsterID
- Population accounting and per-location wild-slot limits
- Player account registration and Starter Hold reservation
- Server-side MonsterService with species validation, age tracking and Wild → Owned capture
- WorldService for authoritative wild lookup
- Server-side Genetics Engine for breeding inheritance rules
- CombatConfig, CombatService and server-side combat action validation
- PC combat input foundation and mobile-ready combat HUD

### Current development status
**Milestone 1 foundation:** implemented as code foundation, not yet assembled into Roblox Studio.

**Milestone 2 action-combat foundation:** server validation, cooldowns, energy-cost definitions and input mapping exist; actual 3D hitboxes, animations, monster rigs, parry timing, stagger and damage application still require Studio implementation.

**Milestone 4 Monster Engine:** identity, species, age, status, ownership, population limits, capture rules, genetics, breeding, eggs, hatch and reincarnation foundations are implemented.

**Not implemented yet:** full runtime hydration of saved monsters/eggs into the in-memory domain registry, transactional DataStore writes for every economy/lifecycle mutation, global cross-server population coordination, cross-server population reconciliation, 3D monster models, world spawning visuals, home/habitat, Arena matchmaking, belts, marketplace and monetization.

The next pre-Studio objective is to finish the server domain layer and persistence interfaces so Roblox Studio becomes an integration/build step rather than the place where core rules are invented.
Platform: Roblox.
Engine: Roblox Studio / Luau.
Project sync: Rojo-compatible.

## Core Design Principle
**Monster Fighter is a living monster ecosystem combined with skill-based real-time action combat.**

Every monster should feel like it has a life:
Born → Grow → Bond → Train → Fight → Breed → Champion → Fallen → Reincarnate → Become Wild → Be Discovered Again.

That lifecycle is a core identity of the game.

## Repository
https://github.com/ferisetiadi112-crypto/monster-figter-
## Persistence Architecture
Persistence is server-authoritative and separated from gameplay domain services.

Flow:
PlayerAdded → Session Lock → Load Snapshot → Runtime Domain → Mutations → Snapshot → DataStore Save → Session Release.

The current implementation includes:
- versioned player data (`MonsterFighter_Player_v2`)
- session lock with expiring token
- load/save service
- snapshot builder
- basic schema validation/default recovery

The next persistence hardening step is runtime hydration and atomic transaction handling for every important mutation.