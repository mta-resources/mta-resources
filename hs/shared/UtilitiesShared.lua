------------------------------------------------------------------
-- Global object
------------------------------------------------------------------
UtilitiesShared = {}

------------------------------------------------------------------
--
------------------------------------------------------------------
local obj = UtilitiesShared

function UtilitiesShared:outputChatDebug(fileName, method, message)
  return "File: " .. fileName .. " | Method: " .. method .. " | Message: " .. message
end