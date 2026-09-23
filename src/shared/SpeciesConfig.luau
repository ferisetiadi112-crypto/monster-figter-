local SpeciesConfig = {}

SpeciesConfig.Prototype = {
  Pyroxi = {Rarity="Common", Core="Ember"},
  Aquavi = {Rarity="Common", Core="Tide"},
  Florune = {Rarity="Common", Core="Bloom"},
  Voltari = {Rarity="Common", Core="Pulse"},
  Terruk = {Rarity="Common", Core="Terra"},
  Galevi = {Rarity="Common", Core="Gale"},
  Frostel = {Rarity="Rare", Core="Frost"},
  Veyra = {Rarity="Epic", Core="Void"},
  Luminox = {Rarity="Legendary", Core="Radiant"},
}

function SpeciesConfig:IsValid(species)
  return self.Prototype[species] ~= nil
end

function SpeciesConfig:Get(species)
  local definition = self.Prototype[species]
  return definition and table.clone(definition) or nil
end

return SpeciesConfig
