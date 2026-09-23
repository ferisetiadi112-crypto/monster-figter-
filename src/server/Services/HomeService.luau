local HomeService = {}

local homes = {}

local function defaultHome(userId)
  return {
    HomeId = "HOME-" .. tostring(userId),
    OwnerUserId = userId,
    Facilities = {
      Habitat = true,
      Incubator = true,
      BreedingArea = true,
      Training = true,
      Storage = true,
      Laboratory = false,
      TrophyRoom = false,
      LegacyHall = false,
    },
    HabitatSlots = 6,
  }
end

function HomeService:Get(player)
  if not player then
    return nil
  end

  if not homes[player.UserId] then
    homes[player.UserId] = defaultHome(player.UserId)
  end

  return table.clone(homes[player.UserId])
end

function HomeService:Hydrate(player, savedHome)
  if not player then
    return
  end

  local home = defaultHome(player.UserId)
  if type(savedHome) == "table" then
    for key, value in pairs(savedHome) do
      home[key] = value
    end
  end
  homes[player.UserId] = home
end

function HomeService:Cleanup(player)
  if player then
    homes[player.UserId] = nil
  end
end

return HomeService
