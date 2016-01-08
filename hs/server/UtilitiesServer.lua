
------------------------------------------------------------------
-- Global object
------------------------------------------------------------------
UtilitiesServer = {}

------------------------------------------------------------------
--------------------------------------------------------------------
local obj = UtilitiesServer

------------------------------------------------------------------
-- Gets a player from account
------------------------------------------------------------------
function getPlayerFromAccount(account)
  local players = getElementsByType("player")
  for i, player in ipairs(players) do
    if getAccount(player) == account then return player end
  end
  return false
end

------------------------------------------------------------------
-- Warp player to Grove Street
------------------------------------------------------------------
addCommandHandler("home", function(player)
  setElementPosition(player, 2494.5788574219, -1672.5540771484, 13.33594703674)
  setElementInterior(player, 0)
end)
