------------------------------------------------------------------
-- Global object
------------------------------------------------------------------
MainServer = {
  houses = HouseLocationsShared.locations,
  accPrefix = "NGC_House_",
  accPassword = "NGC$House@System12j",
  accDataList = {},
}

------------------------------------------------------------------
-- 
------------------------------------------------------------------
local obj = MainServer

------------------------------------------------------------------
-- Creates all house icons in each house
------------------------------------------------------------------
function createHouseIcons()
  for index, location in ipairs(obj.houses) do
    local x   = location.entrance[1]
    local y   = location.entrance[2]
    local z   = location.entrance[3]
    local icon = createPickup(x, y, z, 3, 1273)
    
    local account = getHouseAccount(index)
    setElementData(icon, "is_house_icon", true)
    setElementData(icon, "owner", getAccountData(account, "owner") or nil)
    setElementData(icon, "price", getAccountData(account, "price") or 0)
    setElementData(icon, "for_sale", getAccountData(account, "for_sale") or true)
    setElementData(icon, "open", getAccountData(account, "open") or true)
    setElementData(icon, "interior", getAccountData(account, "interior"))
    setElementData(icon, "entrance_x", getAccountData(account, "entrance_x"))
    setElementData(icon, "entrance_y", getAccountData(account, "entrance_y"))
    setElementData(icon, "entrance_z", getAccountData(account, "entrance_z"))

    outputChatBox(getAccountName(account) .. " ::::: " .. getAccountData(account, "price"))
  end
end

------------------------------------------------------------------
-- Get a house account
------------------------------------------------------------------
function getHouseAccount(index)
  local account = getAccount(obj.accPrefix .. index, obj.accPassword)
  if account then return account end
  return createHouseAccount(index)
end

------------------------------------------------------------------
-- Creates a house account
------------------------------------------------------------------
function createHouseAccount(index)
  local account = addAccount(obj.accPrefix .. index, obj.accPassword)
  outputChatBox("CREATING ACCOUNT: " .. getAccountName(account))

  setAccountData(account, "owner", nil)
  setAccountData(account, "price", obj.houses[index].firstPrice)
  setAccountData(account, "for_sale", true)
  setAccountData(account, "open", true)
  setAccountData(account, "interior", obj.houses[index].interior.interior)
  setAccountData(account, "entrance_x", obj.houses[index].interior.door[1])
  setAccountData(account, "entrance_y", obj.houses[index].interior.door[2])
  setAccountData(account, "entrance_z", obj.houses[index].interior.door[3])

  return account
end

function buyHouse(house)
  local playerMoney = getPlayerMoney(client)
  local price       = getElementData(house, "price")
  if playerMoney < price then return false end -- insert message later
  takePlayerMoney(client, price)
end
addEvent("buyHouseEvent", true)
addEventHandler("buyHouseEvent", resourceRoot, buyHouse)

------------------------------------------------------------------
-- Removes all house accounts
-- DANGEROUS, so this function probably won't stay
------------------------------------------------------------------
function removeAllHouseAccount()
  local accounts = getAccounts()
  for i, acc in ipairs(accounts) do
    local accountName = getAccountName(acc)
    local prefix = string.sub(accountName, 1, -2)
    if prefix == obj.accPrefix then
      outputChatBox("REMOVING ACCOUNT: " .. accountName)
      removeAccount(acc)
    end
  end
end
addCommandHandler("removeHouseAccounts", removeAllHouseAccount)

------------------------------------------------------------------
-- Check if player is the house owner
------------------------------------------------------------------
function isPlayerHouseOwner(house)
  local houseOwnerAccount = getElementData(house, "owner") or false
  local playerAccount     = getPlayerAccount(client)
  local result            = false
  if houseOwnerAccount == playerAccount then result = true end
  triggerClientEvent(client, "isPlayerHouseOwner", client, result)
end
addEvent("isPlayerHouseOwner", true)
addEventHandler("isPlayerHouseOwner", resourceRoot, isPlayerHouseOwner)

------------------------------------------------------------------
-- 
------------------------------------------------------------------
function takePlayerToHouse(house)
  local interior    = getElementData(house, "interior")
  local entrance_x  = getElementData(house, "entrance_x")
  local entrance_y  = getElementData(house, "entrance_y")
  local entrance_z  = getElementData(house, "entrance_z")
  setElementInterior(client, interior)
  setElementPosition(client, entrance_x, entrance_y, entrance_z)
end
addEvent("takePlayerToHouse", true)
addEventHandler("takePlayerToHouse", resourceRoot, takePlayerToHouse)

------------------------------------------------------------------
-- Event handlers
------------------------------------------------------------------
addEventHandler("onResourceStart", resourceRoot, function()
  createHouseIcons()
end)
addEventHandler("onPickupHit", resourceRoot, function()
  if getElementData(source, "is_house_icon") then cancelEvent() end
end)