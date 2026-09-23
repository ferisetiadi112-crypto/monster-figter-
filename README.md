# Monster Fighter

Original Roblox monster action game.

## Core design
- Real-time 3D player-controlled combat
- Mobile joystick + action buttons
- Custom monster rigs (not Roblox block avatars)
- Private player homes with habitats
- Capture, training, breeding and incubation
- 5 Arena tiers: Bronze, Silver, Gold, Titanium, Platinum
- 3 championship belts per tier
- Coin stake: winner receives the match pot
- Fallen monsters reincarnate instead of permanent deletion
- MonsterID persists across reincarnations
- Population Engine controls global monster population
- Five initial wild-search locations, 3 wild slots each
- New accounts receive one protected Starter Hold through the first mission
- Server-authoritative economy, combat and monster identity

## Development
This repository is Rojo-friendly. Open the project with Roblox Studio + Rojo.

Never trust client-provided:
- Coin/Diamond balances
- MonsterID
- level/XP
- rarity
- skill ownership
- damage
- arena result
- marketplace ownership
- population state

The server is the source of truth.
