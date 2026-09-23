local SnapshotService = {}

function SnapshotService:Build(player, monsterService, eggService)
  local monsters = {}
  for _, monster in ipairs(monsterService:GetAll()) do
    if monster.OwnerUserId == player.UserId then
      table.insert(monsters, monster)
    end
  end

  local eggs = {}
  for _, egg in ipairs(eggService:GetAll()) do
    if egg.OwnerUserId == player.UserId then
      table.insert(eggs, egg)
    end
  end

  return {
    Version = 2,
    UserId = player.UserId,
    UpdatedAt = os.time(),
    Coins = 0,
    Diamonds = 0,
    Monsters = monsters,
    Eggs = eggs,
    Home = {},
  }
end

return SnapshotService
