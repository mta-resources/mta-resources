------------------------------------------------------------------
-- Global object
------------------------------------------------------------------
ExternalPanelGUI = {
  window = {}
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
  local windHeight   = 240
  local screenWidth, screenHeight = guiGetScreenSize()
  local windX       = (screenWidth/2) - (windWidth/2)
  local windY       = (screenHeight/2) - (windHeight/2) 
  obj.window.window = guiCreateWindow(windX, windY, windWidth, windHeight, "NGC - House System Panel", false)
  local window = obj.window.window

  -- Creates house basic information
  obj.window.lblOwner         = guiCreateLabel(15, 30, windWidth-30, 15, "Owner: unknown", false, window)
  obj.window.lblOwnerStatus   = guiCreateLabel(15, 50, windWidth-30, 15, "Owner status: online", false, window)
  obj.window.lblPrice         = guiCreateLabel(15, 70, windWidth-30, 15, "Price: $", false, window)
  obj.window.lblIsOnSale      = guiCreateLabel(15, 90, windWidth-30, 15, "For sale: no", false, window)
  obj.window.lblIsOpen        = guiCreateLabel(15, 110, windWidth-30, 15, "House open: yes", false, window)

  -- Creates buttons
  obj.window.btnSeeInterior = guiCreateButton(300, 70, 185, 25, "See Interior", false, window)
  obj.window.btnEnterHouse  = guiCreateButton(300, 100, 185, 25, "Enter House", false, window)

  -- Creates divider
  obj.window.lblDivider = UtilitiesClient:createBoldLabel(15, 130, windWidth-30, 15, "-------------------------------------------------------------------------------------------------", false, window)

  -- Creates options
  obj.window.lblSetPrice      = guiCreateLabel(15, 150, windWidth-30, 15, "Set house price: ", false, window)
  obj.window.edtSetPrice      = guiCreateEdit(15, 170, windWidth-215, 25, "", false, window)
  obj.window.btnSetPrice      = guiCreateButton(windWidth-195, 170, 180, 25, "Set price", false, window)
  obj.window.btnToggleSale    = guiCreateButton(15, 200, 150, 25, "Toggle House Sale", false, window) 
  obj.window.btnToggleSale    = guiCreateButton(170, 200, 160, 25, "Open/Close House", false, window) 
  obj.window.btnToggleSale    = guiCreateButton(335, 200, 150, 25, "Buy house", false, window)

  guiSetVisible(obj.window.window, false)
end

------------------------------------------------------------------
-- Hides or shows external panel
------------------------------------------------------------------
function hideShowExternalPanel()
  if not getElementData(localPlayer, "is_player_on_house_icon") then return false end
  guiSetVisible(obj.window.window, not guiGetVisible(obj.window.window))
  showCursor(guiGetVisible(obj.window.window))
end

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