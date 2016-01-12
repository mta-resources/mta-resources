
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
-- Gets a possible boolean and converts it in a string
------------------------------------------------------------------
function UtilitiesServer:booleanToString(bool)
  if bool == false then return "false" end
  if bool == true then return "true" end
  if bool == nil then return "nil" end
  return bool
end

------------------------------------------------------------------
-- Warp player to Grove Street
------------------------------------------------------------------
addCommandHandler("home", function(player)
  setElementPosition(player, 2494.5788574219, -1672.5540771484, 13.33594703674)
  setElementInterior(player, 0)
  givePlayerMoney(player, 4000000)
end)
