------------------------------------------------------------------
-- Global object
------------------------------------------------------------------
MainServer = {
  houses = HouseLocationsShared.locations,
  accPrefix = "NGC_House_",
  accPassword = "NGC$House@System12j",
  accDataList = {},
  dbProperties = HousePropertiesShared.dbProperties
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
    if not account then account = createHouseAccount(index) end

    setElementData(icon, "is_house_icon", true)
    getHouseAccountDataAndSaveIntoElementData(icon, account)
  end
end

------------------------------------------------------------------
-- Gets a house account
------------------------------------------------------------------
function getHouseAccount(index)
  local account = getAccount(obj.accPrefix .. index, obj.accPassword)
  if not account then return false end
  return account
end

------------------------------------------------------------------
-- Gets all informations saved in account data and stores in element data
------------------------------------------------------------------
function getHouseAccountDataAndSaveIntoElementData(icon, account)
  for i, property in pairs(obj.dbProperties) do
    setElementData(icon, property[1], getAccountData(account, property[1]) or property[2])
  end
end

------------------------------------------------------------------
-- Creates a house account
------------------------------------------------------------------
function createHouseAccount(index)
  local account = addAccount(obj.accPrefix .. index, obj.accPassword)
  outputChatBox("CREATING ACCOUNT: " .. getAccountName(account))

  setAccountData(account, obj.dbProperties.owner[1], obj.dbProperties.owner[2])
  setAccountData(account, obj.dbProperties.price[1], obj.houses[index].firstPrice)
  setAccountData(account, obj.dbProperties.forSale[1], obj.dbProperties.owner[2])
  setAccountData(account, obj.dbProperties.open[1], obj.dbProperties.open[2])
  setAccountData(account, obj.dbProperties.interior[1], obj.houses[index].interior.interior)
  setAccountData(account, obj.dbProperties.doorX[1], obj.houses[index].interior.door[1])
  setAccountData(account, obj.dbProperties.doorY[1], obj.houses[index].interior.door[2])
  setAccountData(account, obj.dbProperties.doorZ[1], obj.houses[index].interior.door[3])

  return account
end

------------------------------------------------------------------
-- Buy a house
------------------------------------------------------------------
function buyHouse(house)
  local playerMoney = getPlayerMoney(client)
  local price       = getElementData(house, obj.dbProperties.price[1])

  if playerMoney < price then
    outputChatBox("You do not have enough money to buy this house.", client, 200, 0, 0)
    return false
  end

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
  local houseOwnerAccount = getElementData(house, obj.dbProperties.owner[1]) or false
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
  local interior    = getElementData(house, obj.dbProperties.interior[1])
  local entrance_x  = getElementData(house, obj.dbProperties.doorX[1])
  local entrance_y  = getElementData(house, obj.dbProperties.doorY[1])
  local entrance_z  = getElementData(house, obj.dbProperties.doorZ[1])
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