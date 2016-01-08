UtilitiesClient = {}
obj = UtilitiesClient

function UtilitiesClient:createBoldLabel(x, y, width, height, label, isRelative, parent)
  label       = label or ""
  isRelative  = isRelative or false
  parent      = parent or nil
  local label = guiCreateLabel(x, y, width, height, label, isRelative, parent)
  guiSetFont(label, "default-bold-small")
end

------------------------------------------------------------------
-- Gets current player position
------------------------------------------------------------------
addCommandHandler("position", function()
  local x, y, z = getElementPosition(getLocalPlayer())
  outputChatBox("{" .. x .. ", " .. y .. ", " .. z .. "}")
end)

------------------------------------------------------------------
-- Gets player dimension
------------------------------------------------------------------
addCommandHandler("dimension", function()
  outputChatBox("Dimension: " .. getElementDimension(localPlayer))
end)

------------------------------------------------------------------
-- Gets player interior
------------------------------------------------------------------
addCommandHandler("interior", function()
  outputChatBox("Interior: " .. getElementInterior(localPlayer))
end)

------------------------------------------------------------------
-- Gets player rotation
------------------------------------------------------------------
addCommandHandler("rotation", function()
  local x, y, z = getElementRotation(localPlayer)
  outputChatBox("Rotation: " .. x .. " | " .. y .. " | " .. z)
end)

------------------------------------------------------------------
-- Changes text to money format
------------------------------------------------------------------
function UtilitiesClient:toMoneyFormat(text)
  if not text then return "" end
  local length = string.len(text)
  if length < 4 then return text end

  if length == 7 then
    return string.sub(text, 1, 1) .. "," .. string.sub(text, 2, 4) .. "," .. string.sub(text, 5)
  elseif length == 6 then
    return string.sub(text, 1, 3) .. "," .. string.sub(text, 4)
  elseif length == 5 then
    return string.sub(text, 1, 2) .. "," .. string.sub(text, 3)
  elseif length == 4 then
    return string.sub(text, 1, 1) .. "," .. string.sub(text, 2)
  end

  return text
end
