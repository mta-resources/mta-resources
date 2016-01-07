-------------------------------------------------------
-- "Class" name
-------------------------------------------------------
LogicalRobbery = {}

-------------------------------------------------------
-- Global reference to object
-------------------------------------------------------
local obj = LogicalRobbery

function vendorHandsUp(targetted)
  outputChatBox("vendorHandsUp")
  if not getElementType(targetted) == "player" then return end
  if not getElementData(targetted, "is_vendor") then return end
  setPedAnimation(targetted, "ped", "handsup", -1, false, false)
end

addEventHandler("onPlayerTarget", root, function(targetted)
  outputChatBox("dafuq")
  vendorHandsUp(targetted)
end)