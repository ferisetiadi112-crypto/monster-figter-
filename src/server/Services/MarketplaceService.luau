local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local MonsterSchema = require(ReplicatedStorage.Shared.MonsterSchema)
local TransactionService = require(script.Parent.TransactionService)
local EconomyService = require(script.Parent.EconomyService)

local MarketplaceService = {}
local listings = {}

local function newListingId()
  return "LST-" .. string.upper(string.gsub(HttpService:GenerateGUID(false), "-", ""))
end

function MarketplaceService:CreateListing(seller, monster, saleType, price, minimumBid)
  if not seller or not monster or monster.OwnerUserId ~= seller.UserId then
    return false, "NotOwner"
  end
  if monster.Status ~= MonsterSchema.Status.OWNED then
    return false, "MonsterUnavailable"
  end
  if saleType ~= "NETT" and saleType ~= "BID" then
    return false, "InvalidSaleType"
  end

  local asking = math.floor(tonumber(price) or 0)
  local minimum = math.floor(tonumber(minimumBid) or asking)
  if asking <= 0 or minimum <= 0 then
    return false, "InvalidPrice"
  end

  local id = newListingId()
  listings[id] = {
    ListingId = id,
    SellerUserId = seller.UserId,
    MonsterId = monster.MonsterID,
    Species = monster.Species,
    Core = monster.Core,
    Gender = monster.Gender,
    AgeDays = monster.AgeDays,
    Level = monster.Level,
    Rarity = monster.Rarity,
    BreedingRemaining = math.max(0, 3 - monster.BreedingCount),
    Traits = table.clone(monster.Traits or {}),
    Skills = table.clone(monster.Skills or {}),
    Parents = table.clone(monster.Parents or {}),
    BattleHistory = table.clone(monster.BattleHistory or {}),
    SaleType = saleType,
    Price = asking,
    MinimumBid = minimum,
    HighestBid = nil,
    HighestBidderUserId = nil,
    CreatedAt = os.time(),
    ExpiresAt = os.time() + 86400,
    Status = "Active",
  }

  return true, table.clone(listings[id])
end

function MarketplaceService:Get(listingId)
  return listings[listingId] and table.clone(listings[listingId]) or nil
end

function MarketplaceService:GetActive()
  local result = {}
  for _, listing in pairs(listings) do
    if listing.Status == "Active" then
      table.insert(result, table.clone(listing))
    end
  end
  return result
end

function MarketplaceService:CancelListing(seller, listingId)
  local listing = listings[listingId]
  if not listing then return false, "NotFound" end
  if listing.SellerUserId ~= seller.UserId then return false, "NotOwner" end
  if listing.Status ~= "Active" then return false, "NotActive" end
  listing.Status = "Cancelled"
  return true, table.clone(listing)
end

function MarketplaceService:BuyNett(buyer, listingId)
  local listing = listings[listingId]
  if not listing or listing.Status ~= "Active" then return false, "NotActive" end
  if listing.SaleType ~= "NETT" then return false, "NotNettSale" end
  if listing.SellerUserId == buyer.UserId then return false, "SelfPurchase" end

  local tx = TransactionService:NewId("MKT")
  local debited, reason = EconomyService:DebitCoins(buyer.UserId, listing.Price, tx)
  if not debited then return false, reason end

  listing.Status = "Sold"
  listing.BuyerUserId = buyer.UserId
  listing.SoldAt = os.time()
  listing.TransactionId = tx

  return true, table.clone(listing)
end

return MarketplaceService
