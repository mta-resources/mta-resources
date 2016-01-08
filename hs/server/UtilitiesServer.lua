 
------------------------------------------------------------------
-- Global object
------------------------------------------------------------------
UtilitiesServer = {}

------------------------------------------------------------------
-- 
------------------------------------------------------------------
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