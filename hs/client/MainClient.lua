------------------------------------------------------------------
-- Global object
------------------------------------------------------------------
MainClient = {}

------------------------------------------------------------------
-- 
------------------------------------------------------------------
local obj = MainClient

------------------------------------------------------------------
-- 
------------------------------------------------------------------
function onHouseIconHit(player, sameDimension, icon)
  if not sameDimension then return false end
  if not getElementData(icon, "is_house_icon") then return false end
  if not player or getElementType(player) ~= "player" then return false end

  outputChatBox("Press Z to open House Panel.", 255, 0, 0)
  setIsPlayerOnHouseIcon(player, true)
end

------------------------------------------------------------------
-- 
------------------------------------------------------------------
function setIsPlayerOnHouseIcon(player, value)
  setElementData(player, "is_player_on_house_icon", value)
end

------------------------------------------------------------------
-- 
------------------------------------------------------------------
addEventHandler("onClientPickupHit", getRootElement(), function(player, sameDimension)
  onHouseIconHit(player, sameDimension, source)
end)
addEventHandler("onClientPickupLeave", getRootElement(), function(player, sameDimension)
  if not getElementData(source, "is_house_icon") then return false end
  setIsPlayerOnHouseIcon(player, false)
end)
