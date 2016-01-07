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
    setElementData(icon, "is_house_icon", true)

    local account = getHouseAccount(icon, index)
    outputChatBox(getAccountName(account) .. " ::::: " .. getAccountData(account, "price"))
  end
end

------------------------------------------------------------------
-- Get a house account
------------------------------------------------------------------
function getHouseAccount(icon, index)
  local account = getAccount(obj.accPrefix .. index, obj.accPassword)
  if account then return account end
  return createHouseAccount(icon, index)
end

------------------------------------------------------------------
-- Creates a house account
------------------------------------------------------------------
function createHouseAccount(index)
  local account = addAccount(obj.accPrefix .. index, obj.accPassword)
  outputChatBox("CREATING ACCOUNT: " .. getAccountName(account))

  setAccountData(account, "owner", nil)
  setAccountData(account, "price", obj.houses[index].firstPrice)

  return account
end

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
-- Event handlers
------------------------------------------------------------------
addEventHandler("onResourceStart", resourceRoot, function()
  createHouseIcons()
end)
addEventHandler("onPickupHit", resourceRoot, function()
  if getElementData(source, "is_house_icon") then cancelEvent() end
end)