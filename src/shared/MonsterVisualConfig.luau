local MonsterVisualConfig = {}

MonsterVisualConfig.Benchmark = {
  Pyroxi = {
    Species = "Pyroxi",
    Core = "Ember",
    Rarity = "Common",
    TargetHeightCm = 35,
    BodyArchetype = "CompactQuadruped",
    Proportion = {
      HeadToBody = 0.78,
      LegLength = 0.34,
      EyeScale = 1.15,
    },
    Palette = {
      Primary = "#E15C26",
      Secondary = "#F1742C",
      Accent = "#FFB630",
      Dark = "#7A2D22",
      Cream = "#F6D8B5",
    },
    Signature = {
      "EmberTail",
      "ExpressiveEars",
      "WarmChestMark",
    },
    Personality = {"Brave", "Energetic", "Curious"},
    AnimationSet = {
      "Idle", "Walk", "Run", "Follow", "Attack", "Skill",
      "Hit", "Dodge", "Guard", "Victory", "Defeat",
      "Happy", "Sad", "Sleep",
    },
    VFX = {
      Primary = "EmberSparks",
      Attack = "ShortFlameBurst",
      Ultimate = "EmberBloom",
    },
  },

  Aquavi = {
    Species = "Aquavi",
    Core = "Tide",
    Rarity = "Common",
    TargetHeightCm = 40,
    BodyArchetype = "CompactAquatic",
    Proportion = {
      HeadToBody = 0.74,
      LegLength = 0.30,
      EyeScale = 1.10,
    },
    Palette = {
      Primary = "#2D8CFF",
      Secondary = "#49C8FF",
      Accent = "#9CE8FF",
      Dark = "#174B9A",
      Cream = "#E8F8FF",
    },
    Signature = {
      "WaterFinEars",
      "FlexibleTail",
      "PearlChestMark",
    },
    Personality = {"Playful", "Calm", "Observant"},
    AnimationSet = {
      "Idle", "Walk", "Run", "Follow", "Attack", "Skill",
      "Hit", "Dodge", "Guard", "Victory", "Defeat",
      "Happy", "Sad", "Sleep",
    },
    VFX = {
      Primary = "WaterDroplets",
      Attack = "TidalArc",
      Ultimate = "TideSpiral",
    },
  },

  Florune = {
    Species = "Florune",
    Core = "Bloom",
    Rarity = "Common",
    TargetHeightCm = 30,
    BodyArchetype = "SmallQuadruped",
    Proportion = {
      HeadToBody = 0.76,
      LegLength = 0.36,
      EyeScale = 1.08,
    },
    Palette = {
      Primary = "#72B84B",
      Secondary = "#A8D957",
      Accent = "#F28BA7",
      Dark = "#356A35",
      Cream = "#F1E7C8",
    },
    Signature = {
      "LeafEars",
      "FlowerCrown",
      "LivingLeafTail",
    },
    Personality = {"Friendly", "Intelligent", "Protective"},
    AnimationSet = {
      "Idle", "Walk", "Run", "Follow", "Attack", "Skill",
      "Hit", "Dodge", "Guard", "Victory", "Defeat",
      "Happy", "Sad", "Sleep",
    },
    VFX = {
      Primary = "LeafMotes",
      Attack = "VineSnap",
      Ultimate = "BloomField",
    },
  },
}

function MonsterVisualConfig:Get(species)
  local definition = self.Benchmark[species]
  return definition and table.clone(definition) or nil
end

function MonsterVisualConfig:IsBenchmark(species)
  return self.Benchmark[species] ~= nil
end

return MonsterVisualConfig
