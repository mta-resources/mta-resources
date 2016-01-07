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