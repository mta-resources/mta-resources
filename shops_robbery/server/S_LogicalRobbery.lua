-------------------------------------------------------
-- "Class" name
-------------------------------------------------------
LogicalRobbery = {
  robDuration = 10000,
  minValue = 2000,
  maxValue = 5000,
  intervalBetweenRobbery = 60000 * 6
}

-------------------------------------------------------
-- Global reference to object
-------------------------------------------------------
local obj = LogicalRobbery

-------------------------------------------------------
-- Makes vendor hands up
-------------------------------------------------------
function vendorHandsUp(player, targetted)
  if not targetted or not getElementType(targetted) == "ped" then return false end
  if not getElementData(targetted, "is_vendor") then return false end
  if getElementData(targetted, "is_being_robbed") then return false end

  setPedAnimation(targetted, "SHOP", "SHP_Rob_React", -1, false, false)
  setElementData(targetted, "is_being_robbed", true)

  return true
end

-------------------------------------------------------
-- Starts robbery
-------------------------------------------------------
function startRobbery(player, targetted)
  local isVendorBeingRobbed = vendorHandsUp(player, targetted)
  if not isVendorBeingRobbed then return false end

  outputChatBox("You are robbing this shop. Wait " .. obj.robDuration/1000 .. " seconds to finish the robbery.", player, 255, 0, 0)

  setTimer(stopRobbery, obj.robDuration, 1, player, targetted)
end

-------------------------------------------------------
-- Stops robbery
-------------------------------------------------------
function stopRobbery(player, targetted)
  local money = math.random(obj.minValue, obj.maxValue)
  vendorHandsDown(targetted)
  outputChatBox("You robbery was a success! You got $" .. money .. ". Get out before the cops find you.", player, 255, 0, 0)
  givePlayerMoney(player, money)
end

-------------------------------------------------------
-- Makes vendor hands down
-------------------------------------------------------
function vendorHandsDown(vendor)
  setPedAnimation(vendor, false)
  setTimer(function()
    setElementData(vendor, "is_being_robbed", false)
  end, obj.intervalBetweenRobbery, 1)
end

-------------------------------------------------------
-- Event handlers
-------------------------------------------------------
addEventHandler("onPlayerTarget", getRootElement(), function(targetted)
  startRobbery(source, targetted)
end)
