------------------------------------------------------------
-- GUI elements
------------------------------------------------------------
local elements = {}

------------------------------------------------------------
-- Global variables avoiding to use guiGetVisible() everytime
------------------------------------------------------------
local isAppOpen = false
local isConversationOpen = false

------------------------------------------------------------
-- Mockup data (fake values)
------------------------------------------------------------
local fakeLoggedPlayers = {"Janet", "Painball", "Sathler", "Darksoul", "Jhonnie", "Lopez"}
local fakeConversations = {"Darksoul", "Jhonnie", "Janet"}

------------------------------------------------------------
-- Creates the main app's window
------------------------------------------------------------
function createMainWindow()
  -- Creates main app window
  local screenWidth, screenHeight = guiGetScreenSize()
  local windWidth     = 300
  local windHeight    = 500
  local windPosX      = screenWidth - windWidth - 30
  local windPosY      = screenHeight - windHeight - 30
  elements.mainWindow = guiCreateWindow(windPosX, windPosY, windWidth, windHeight, "App title", false)

  --buildMainScreen()
  buildConversationScreen()
  isAppOpen = true
end

------------------------------------------------------------
-- Destroy main window
------------------------------------------------------------
function destroyMainWindow()
  destroyElement(elements.mainWindow)
end

------------------------------------------------------------
-- Hides app's main screen, with tabbed options
------------------------------------------------------------
function hideMainScreen()
  guiSetVisible(elements.mainTabPanel, false)
end

------------------------------------------------------------
-- Shows app's main screen, with tabbed options
------------------------------------------------------------
function showMainScreen()
  guiSetVisible(elements.mainTabPanel, true)
end

------------------------------------------------------------
-- Hides conversation screen elements
------------------------------------------------------------
function hideConversationScreen()
  guiSetVisible(elements.conversationMemo, false)
  guiSetVisible(elements.conversationMessage, false)
  guiSetVisible(elements.conversationSendMessage, false)
end

------------------------------------------------------------
-- Shows conversation screen elements
------------------------------------------------------------
function showConversationScreen()
  guiSetVisible(elements.conversationMemo, true)
  guiSetVisible(elements.conversationMessage, true)
  guiSetVisible(elements.conversationSendMessage, true)
end

------------------------------------------------------------
-- Creates the main app's screen, with tabbed options
------------------------------------------------------------
function buildMainScreen()
  -- Creates main tab panel and its tabs
  elements.mainTabPanel     = guiCreateTabPanel(0, 0.05, 1, 1, true, elements.mainWindow)
  elements.conversationsTab = guiCreateTab("Conversations", elements.mainTabPanel)
  elements.peopleTab        = guiCreateTab("People", elements.mainTabPanel)

  -- Creates conversation tab elements
  elements.conversationsList      = guiCreateGridList(0, 0, 1, 0.90, true, elements.conversationsTab)
  elements.conversationListColumn = guiGridListAddColumn(elements.conversationsList, "Conversations", 0.9)
  loadAllConversations(elements.conversationsList, elements.conversationListColumn)
  elements.btnSeeConversation     = guiCreateButton(0, 0.90, 1, 0.10, "View conversation", true, elements.conversationsTab)

  -- Creates contacts list
  elements.peopleList       = guiCreateGridList(0, 0, 1, 1, true, elements.peopleTab)
  elements.peopleListColumn = guiGridListAddColumn(elements.peopleList, "Players online", 0.9)
  loadAllPeople(elements.peopleList, elements.peopleListColumn)
end

------------------------------------------------------------
-- Creates the app's conversation screen
------------------------------------------------------------
function buildConversationScreen()
  elements.conversationMemo         = guiCreateMemo(0, 0.05, 1, 0.83, "", true, elements.mainWindow)
  elements.conversationMessage      = guiCreateEdit(0, 0.90, 0.70, 0.07, "", true, elements.mainWindow)
  elements.conversationSendMessage  = guiCreateButton(0.75, 0.90, 0.25, 0.07, "OK", true, elements.mainWindow)
  addEventHandler("onClientGUIClick", elements.conversationSendMessage, whenClickOnSendButton, false)
end

------------------------------------------------------------
-- Called when user clicks on 
------------------------------------------------------------
function whenClickOnSendButton(button, state, absX, absY)
  if button == "left" then
    sendMessage()
  end
end

------------------------------------------------------------
-- Sends the message
------------------------------------------------------------
function sendMessage()
  local message       = guiGetText(elements.conversationMessage)
  if not message or message == "" then return end
  local currentText   = guiGetText(elements.conversationMemo)
  local separator     = "\n--------------------------------------"
  local senderName    = getPlayerName(getLocalPlayer())
  local finalMessage  = senderName .. ": " .. message .. separator
   
  guiSetText(elements.conversationMemo, currentText .. finalMessage)
  guiSetText(elements.conversationMessage, "")
end

------------------------------------------------------------
-- Loads all player's conversations
------------------------------------------------------------
function loadAllConversations(grid, column)
  if column then
    for i, name in pairs(fakeConversations) do
      local row = guiGridListAddRow(grid)
      guiGridListSetItemText(grid, row, column, name, false, false)
    end
  end
end

------------------------------------------------------------
-- Loads all logged players
------------------------------------------------------------
function loadAllPeople(grid, column)
  if column then
    for i, name in ipairs(fakeLoggedPlayers) do
      local row = guiGridListAddRow(grid)
      guiGridListSetItemText(grid, row, column, name, false, false)
    end
  end
end

------------------------------------------------------------
-- Checks which key was pressed
------------------------------------------------------------
function checkWhatKeyWasPressed(button)
  if button == "enter" then
    sendMessage()
  end
end

------------------------------------------------------------
-- Event handlers and key binders
------------------------------------------------------------
bindKey("n", "down", function()
  local isVisible = guiGetVisible(elements.mainWindow) or false
  if isVisible then
    destroyMainWindow()
  else
    createMainWindow()
  end
end)

addEventHandler("onClientKey", root, function(button)
  checkWhatKeyWasPressed(button)
end)