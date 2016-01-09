------------------------------------------------------------------
-- Global object
------------------------------------------------------------------
MainServer = {
  houses = HouseLocationsShared.locations,
  accPrefix = "NGC_House_",
  accPassword = "NGC$House@System12j",
  accDataList = {},
  houseManagerName = HousePropertiesShared.properties.owner[2],
  properties = HousePropertiesShared.properties
}

------------------------------------------------------------------
--
------------------------------------------------------------------
local obj = MainServer

------------------------------------------------------------------
-- Creates all houses around San Andreas
------------------------------------------------------------------
function createHouses()
  local managerAccount = getHouseManagerAccount()
  if not managerAccount then managerAccount = createHouseManagerAccount() end

  for index, location in ipairs(obj.houses) do
    local x     = location.entrance[1]
    local y     = location.entrance[2]
    local z     = location.entrance[3]
    local house = createPickup(x, y, z, 3, 1273)

    local account = getHouseAccountByIndex(index)
    if not account then account = createHouseAccount(index) end

    setElementData(house, "is_house_icon", true)
    houseAccountDataToElementData(house, account)
    createExitInHouses(house)
  end
end

------------------------------------------------------------------
-- Gets house manager's account
------------------------------------------------------------------
function getHouseManagerAccount()
  local accountName = obj.houseManagerName
  local account     = getAccount(accountName, obj.accPassword)
  if not account then return false end
  return account
end

------------------------------------------------------------------
-- Creates house manager's account
------------------------------------------------------------------
function createHouseManagerAccount()
  local accName     = obj.houseManagerName
  local accPassword = obj.accPassword
  local account = addAccount(accName, accPassword)
  if not account then return false end
  return account
end

------------------------------------------------------------------
-- Creates markers that allows user to quit their houses
------------------------------------------------------------------
function createExitInHouses(house)
  local x           = getElementData(house, obj.properties.insideX[1])
  local y           = getElementData(house, obj.properties.insideY[1])
  local z           = getElementData(house, obj.properties.insideZ[1])
  local exitMarker  = createMarker(x, y, z, "cylinder", 1, 255, 0, 0, 200) -- @toDo: change color and alpha
  setElementInterior(exitMarker, getElementData(house, obj.properties.interior[1]))
  exitMarker = copyElementDataFromHouseToMarker(house, exitMarker)

  addEventHandler("onMarkerHit", exitMarker, function(element, matchDimension)
    if not matchDimension then return false end
    if not getElementType(element) == "player" then return false end
    quitHouse(element, source)
  end, false)

end

------------------------------------------------------------------
--
------------------------------------------------------------------
function copyElementDataFromHouseToMarker(house, marker)
  for i, property in pairs(obj.properties) do
    local property = getElementData(house, property[1])
    setElementData(marker, property[1], property)
  end
  return marker
end

------------------------------------------------------------------
-- Takes player out from house
------------------------------------------------------------------
function quitHouse(player, marker)
  local x   = getElementData(marker, obj.properties.outsideX[1])
  local y   = getElementData(marker, obj.properties.outsideY[1])
  local z   = getElementData(marker, obj.properties.outsideZ[1])
  local rx  = getElementData(marker, obj.properties.outsideRX[1])
  local ry  = getElementData(marker, obj.properties.outsideRY[1])
  local rz  = getElementData(marker, obj.properties.outsideRZ[1])
  setElementPosition(player, x, y, z)
  setElementInterior(player, 0)
  setElementRotation(player, rx, ry, rz)
end

------------------------------------------------------------------
-- Gets a house account by its index on HouseLocationsShared
------------------------------------------------------------------
function getHouseAccountByIndex(index)
  local account = getAccount(obj.accPrefix .. index, obj.accPassword)
  if not account then return false end
  return account
end

------------------------------------------------------------------
-- Gets all informations saved in account data and stores in element data
------------------------------------------------------------------
function houseAccountDataToElementData(icon, account)
  for i, property in pairs(obj.properties) do
    setElementData(icon, property[1], getAccountData(account, property[1]) or property[2])
  end
end

------------------------------------------------------------------
-- Creates a house account and saves its informations
------------------------------------------------------------------
function createHouseAccount(index)
  local account       = addAccount(obj.accPrefix .. index, obj.accPassword)
  local currentHouse  = obj.houses[index]

  setAccountData(account, obj.properties.owner[1], obj.properties.owner[2])
  setAccountData(account, obj.properties.price[1], currentHouse.firstPrice)
  setAccountData(account, obj.properties.forSale[1], obj.properties.forSale[2])
  setAccountData(account, obj.properties.open[1], obj.properties.open[2])
  setAccountData(account, obj.properties.interior[1], currentHouse.interior.interior)
  setAccountData(account, obj.properties.insideX[1], currentHouse.interior.door[1])
  setAccountData(account, obj.properties.insideY[1], currentHouse.interior.door[2])
  setAccountData(account, obj.properties.insideZ[1], currentHouse.interior.door[3])
  setAccountData(account, obj.properties.insideRX[1], currentHouse.interior.door[4])
  setAccountData(account, obj.properties.insideRY[1], currentHouse.interior.door[5])
  setAccountData(account, obj.properties.insideRZ[1], currentHouse.interior.door[6])
  setAccountData(account, obj.properties.outsideX[1], currentHouse.entrance[1])
  setAccountData(account, obj.properties.outsideY[1], currentHouse.entrance[2])
  setAccountData(account, obj.properties.outsideZ[1], currentHouse.entrance[3])
  setAccountData(account, obj.properties.outsideRX[1], currentHouse.entrance[4])
  setAccountData(account, obj.properties.outsideRY[1], currentHouse.entrance[5])
  setAccountData(account, obj.properties.outsideRZ[1], currentHouse.entrance[6])

  return account
end

------------------------------------------------------------------
-- Buy a house
------------------------------------------------------------------
function buyHouse(house)
  local playerMoney = getPlayerMoney(client)
  local price       = getElementData(house, obj.properties.price[1])

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
  local houseOwnerAccount = getElementData(house, obj.properties.owner[1]) or false
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
function warpPlayerToHouse(house)
  local interior    = getElementData(house, obj.properties.interior[1])
  local entrance_x  = getElementData(house, obj.properties.insideX[1])
  local entrance_y  = getElementData(house, obj.properties.insideY[1])
  local entrance_z  = getElementData(house, obj.properties.insideZ[1])
  local entrance_rx = getElementData(house, obj.properties.insideRX[1])
  local entrance_ry = getElementData(house, obj.properties.insideRY[1])
  local entrance_rz = getElementData(house, obj.properties.insideRZ[1])
  setElementPosition(client, entrance_x, entrance_y, entrance_z)
  setElementInterior(client, interior)
  setElementRotation(client, entrance_rx, entrance_ry, entrance_rz)
end
addEvent("warpPlayerToHouse", true)
addEventHandler("warpPlayerToHouse", resourceRoot, warpPlayerToHouse)

------------------------------------------------------------------
-- Event handlers
------------------------------------------------------------------
addEventHandler("onResourceStart", resourceRoot, function()
  createHouses()
end)
addEventHandler("onPickupHit", resourceRoot, function()
  if getElementData(source, "is_house_icon") then cancelEvent() end
end)
