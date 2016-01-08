------------------------------------------------------------------
-- Global object
------------------------------------------------------------------
ExternalPanelGUI = {
  window = {},
  isPlayerHouseOwner = false
}

------------------------------------------------------------------
-- 
------------------------------------------------------------------
local obj = ExternalPanelGUI

------------------------------------------------------------------
-- Creates the main window
------------------------------------------------------------------
function createExternalPanel()

  -- Creates main window
  local windWidth   = 500
  local windHeight  = 240
  local screenWidth, screenHeight = guiGetScreenSize()
  local windX       = (screenWidth/2) - (windWidth/2)
  local windY       = (screenHeight/2) - (windHeight/2) 
  obj.window.window = guiCreateWindow(windX, windY, windWidth, windHeight, "NGC - House System Panel", false)
  local window      = obj.window.window

  -- Creates house basic information
  obj.window.lblOwner         = guiCreateLabel(15, 30, windWidth-30, 15, "Owner: unknown", false, window)
  obj.window.lblOwnerStatus   = guiCreateLabel(15, 50, windWidth-30, 15, "Owner status: online", false, window)
  obj.window.lblPrice         = guiCreateLabel(15, 70, windWidth-30, 15, "Price: $", false, window)
  obj.window.lblIsOnSale      = guiCreateLabel(15, 90, windWidth-30, 15, "For sale: no", false, window)
  obj.window.lblIsOpen        = guiCreateLabel(15, 110, windWidth-30, 15, "House open: yes", false, window)

  -- Creates buttons
  obj.window.btnCloseWindow = guiCreateButton(300, 40, 185, 25, "Close window", false, window)
  obj.window.btnSeeInterior = guiCreateButton(300, 70, 185, 25, "See Interior", false, window)
  obj.window.btnEnterHouse  = guiCreateButton(300, 100, 185, 25, "Enter House", false, window)

  -- Creates divider
  obj.window.lblDivider = UtilitiesClient:createBoldLabel(15, 130, windWidth-30, 15, "-------------------------------------------------------------------------------------------------", false, window)

  -- Creates options
  obj.window.lblSetPrice      = guiCreateLabel(15, 150, windWidth-30, 15, "Set house price: ", false, window)
  obj.window.edtSetPrice      = guiCreateEdit(15, 170, windWidth-215, 25, "", false, window)
  obj.window.btnSetPrice      = guiCreateButton(windWidth-195, 170, 180, 25, "Set price", false, window)
  obj.window.btnToggleSale    = guiCreateButton(15, 200, 150, 25, "Toggle House Sale", false, window) 
  obj.window.btnOpenClose     = guiCreateButton(170, 200, 160, 25, "Open/Close House", false, window) 
  obj.window.btnBuyHouse      = guiCreateButton(335, 200, 150, 25, "Buy house", false, window)

  addEventHandler("onClientGUIClick", obj.window.btnEnterHouse, function()
    outputChatBox("MOHTFUCKAKA")
    enterHouse(localPlayer, getElementData(localPlayer, "current_house_icon"))
  end)

  addEventHandler("onClientGUIClick", obj.window.btnCloseWindow, function()
    hideExternalPanel()
  end)

  guiSetVisible(obj.window.window, false)
end

------------------------------------------------------------------
-- Hides or shows external panel
------------------------------------------------------------------
function hideShowExternalPanel()
  if not getElementData(localPlayer, "is_player_on_house_icon") then return false end
  local icon = getElementData(localPlayer, "current_house_icon")
  if not icon then return false end

  enableOrDisableButtons(icon)
  updateLabelValues(icon)
  guiSetVisible(obj.window.window, not guiGetVisible(obj.window.window))
  showCursor(guiGetVisible(obj.window.window))
end

------------------------------------------------------------------
-- Updates label values
------------------------------------------------------------------
function updateLabelValues(icon)  
  updatePriceLabel(icon)
  updateIsOnSaleLabel(icon)
  updateOwnerLabel(icon)
  updateIsOpenLabel(icon)
  updateOwnerStatusLabel(icon)
end

------------------------------------------------------------------
-- Updates house's price label
------------------------------------------------------------------
function updatePriceLabel(icon)
  guiSetText(obj.window.lblPrice, "Price: $" .. UtilitiesClient:toMoneyFormat(getElementData(icon, "price")))
end

------------------------------------------------------------------
-- Updates house's for sale status
------------------------------------------------------------------
function updateIsOnSaleLabel(icon)
  local isOnSale = getElementData(icon, "for_sale")
  local text = ""
  if isOnSale then text = "Yes"
  else text = "No" end
  guiSetText(obj.window.lblIsOnSale, "For sale: " .. text)
end

------------------------------------------------------------------
-- Updates house's owner label
------------------------------------------------------------------
function updateOwnerLabel(icon)
  local owner = getElementData(icon, "owner")
  if not owner or owner == "nil" then owner = "No owner yet" end
  guiSetText(obj.window.lblOwner, "Owner: " .. owner)
end

------------------------------------------------------------------
-- Updates house's open status 
------------------------------------------------------------------
function updateIsOpenLabel(icon)
  local isOpen = getElementData(icon, "open")
  if not isOpen then isOpen = "No"
  else isOpen = "Yes" end
  guiSetText(obj.window.lblIsOpen, "House open: " .. isOpen)
end

------------------------------------------------------------------
-- 
------------------------------------------------------------------
function updateOwnerStatusLabel(icon)
  local owner = getElementData(icon, "owner")
  local text = ""
  if not owner or owner == "nil" then text = "Offline" end
  guiSetText(obj.window.lblOwnerStatus, "Owner status: " .. text)
end

------------------------------------------------------------------
-- Enables or disables buttons
------------------------------------------------------------------
function enableOrDisableButtons(icon)

  triggerServerEvent("isPlayerHouseOwner", resourceRoot, icon)
  local isOwner   = obj.isPlayerHouseOwner
  local isForSale = getElementData(icon, "for_sale") 
  local isOpen    = getElementData(icon, "open")

  if not isOwner then
    guiSetEnabled(obj.window.btnSetPrice, false)
    guiSetEnabled(obj.window.btnToggleSale, false)
    guiSetEnabled(obj.window.btnOpenClose, false)
  end

  if not isForSale then
    guiSetEnabled(obj.window.btnBuyHouse, false)
  end

  if not isOpen then
    guiSetEnabled(obj.window.btnEnterHouse, false)
  else
    guiSetEnabled(obj.window.btnEnterHouse, true)
  end

end

------------------------------------------------------------------
-- 
------------------------------------------------------------------
function isPlayerHouseOwner(isOwner)
  obj.isPlayerHouseOwner = isOwner
end
addEvent("isPlayerHouseOwner", true)
addEventHandler("isPlayerHouseOwner", resourceRoot, isPlayerHouseOwner)

------------------------------------------------------------------
-- 
------------------------------------------------------------------
function enterHouse(player, icon)
  triggerServerEvent("takePlayerToHouse", resourceRoot, icon)
end

------------------------------------------------------------------
-- 
------------------------------------------------------------------
function hideExternalPanel()
  outputChatBox("AHSAHS HIDING")
  guiSetVisible(obj.window.window, false)
  showCursor(false)
end
addEvent("hideExternalPanel", true)
addEventHandler("hideExternalPanel", resourceRoot, hideExternalPanel)

------------------------------------------------------------------
-- Event handlers
------------------------------------------------------------------
addEventHandler("onClientResourceStart", resourceRoot, function()
  createExternalPanel()
  bindKey("z", "down", hideShowExternalPanel)
end)
addEventHandler("onClientResourceStop", resourceRoot, function()
  unbindKey("z", "down", createExternalPanel)
end)