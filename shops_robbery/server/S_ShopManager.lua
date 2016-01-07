-------------------------------------------------------
-- "Class" name
-------------------------------------------------------
ShopManager = {}

-------------------------------------------------------
-- Global reference to object
-------------------------------------------------------
local obj = ShopManager

-------------------------------------------------------
-- Creates all arrows indicating the entrances
-------------------------------------------------------
function createShopsEntrances()
  local locations = ShopLocations
  for i, location in pairs(locations) do
    local x       = location.entrance[1]
    local y       = location.entrance[2]
    local z       = location.entrance[3]
    local marker  = createMarker(x, y, z, "arrow", 2, 230, 200, 30, 230)

    setElementData(marker, "interior", location.interior.id)
    setElementData(marker, "spawn_x", location.interior.spawn[1])
    setElementData(marker, "spawn_y", location.interior.spawn[2])
    setElementData(marker, "spawn_z", location.interior.spawn[3])
    setElementData(marker, "spawn_rotx", location.interior.spawn[4])
    setElementData(marker, "spawn_roty", location.interior.spawn[5])
    setElementData(marker, "spawn_rotz", location.interior.spawn[6])
    setElementData(marker, "dimension", location.dimension)

    createVendorInShop(location.interior, location.dimension)

    addEventHandler("onMarkerHit", marker, function(hitElement, isSameDimension)
      if not isSameDimension then return end
      if not hitElement or getElementType(hitElement) ~= "player" then return end
      whenMarkerHit(hitElement, source, location.interior)
    end)
  end
end

-------------------------------------------------------
-- Creates all arrows indicating the exits
-------------------------------------------------------
function createShopsExits()
  
end

-------------------------------------------------------
-- Called when user hits on an entrance marker
-------------------------------------------------------
function whenMarkerHit(player, marker, interior, dimension)
  spawnPlayerInShop(player, marker, dimension)
end

-------------------------------------------------------
-- Spawns the player in the shop
-------------------------------------------------------
function spawnPlayerInShop(player, marker, dimension)
  local x   = getElementData(marker, "spawn_x")
  local y   = getElementData(marker, "spawn_y")
  local z   = getElementData(marker, "spawn_z")
  local rx  = getElementData(marker, "spawn_rotx")
  local ry  = getElementData(marker, "spawn_roty")
  local rz  = getElementData(marker, "spawn_rotz")
  local int = getElementData(marker, "interior")
  local dim = getElementData(marker, "dimension")
  setElementInterior(player, int)
  setElementPosition(player, x, y, z)
  setElementRotation(player, rx, ry, rz)
  setElementDimension(player, dim)
end

-------------------------------------------------------
-- Spawns the vendor in the shop
-------------------------------------------------------
function createVendorInShop(interior, dimension)
  local x     = interior.vendor[1]
  local y     = interior.vendor[2]
  local z     = interior.vendor[3]
  local rx    = interior.vendor[4]
  local ry    = interior.vendor[5]
  local rz    = interior.vendor[6]
  local skin  = interior.vendor[7]
  local ped   = createPed(skin, x, y, z, rx, false)
  setElementInterior(ped, interior.id)
  setElementDimension(ped, dimension)
  setElementData(ped, "is_vendor", true)
end

-------------------------------------------------------
-- Event handlers, key binders and command handlers
-------------------------------------------------------
addEventHandler("onResourceStart", resourceRoot, function()
  createShopsEntrances()
end)

addCommandHandler("rotation", function(player)
  local x, y, z = getElementRotation(player)
  outputChatBox(x .. " | " .. y .. " | " .. z)
end)