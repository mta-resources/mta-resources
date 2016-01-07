-------------------------------------------------------
-- "Class" name
-------------------------------------------------------
ShopInteriors = {

  interiors = {

    supermarketOne = {
      id = 6,
      spawn = {-27, -57, 1005, 0, 0, 360},
      vendor = {-23, -57, 1005, 0, 0, 360, 174}
    },

  },
}

-------------------------------------------------------
-- Sometimes, self isn't available
-------------------------------------------------------
local obj = ShopInteriors

-------------------------------------------------------
-- Gets an interior by its id
-------------------------------------------------------
function ShopInteriors:getInteriorById(int)
  for i, interior in pairs(self.interiors) do
    if int == interior.id then return interior end
  end
end