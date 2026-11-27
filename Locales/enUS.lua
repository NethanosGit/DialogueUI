--Reserved space below so all localization files line up

local _, addon = ...;
local L = addon.L;

-- Blizzard's own global strings are used where they exist (FrameXML, not in wow-docs), so they follow the client
-- language. The English text is the fallback. Strings with values are format strings: "%d" number, "%s" text.


-- Footer buttons
L["Accept"] = ACCEPT or "Accept";
L["Restart Quest"] = "Restart";
L["Continue"] = CONTINUE or "Continue";
L["Complete Quest"] = COMPLETE or "Complete Quest";
L["Incomplete"] = INCOMPLETE or "Incomplete";
L["Decline"] = DECLINE or "Decline";
L["Cancel"] = CANCEL or "Cancel";
L["Goodbye"] = GOODBYE or "Goodbye";

-- Settings window
L["UI"] = "UI";
L["Control"] = "Control";
L["Gameplay"] = "Gameplay";
L["Audio"] = "Audio";
L["Minimap"] = "Minimap";
L["Other Addons"] = "Other Addons";
L["Experimental"] = "Experimental";

-- Settings: Audio tab
L["Enable Audio Fading"] = "Enable Audio Fading";
L["Enable Audio Fading Desc"] = "Lower the game's volumes while the dialogue window or a readable is open. When it closes, they fade back to the volumes set in the game's audio options.";
L["Sound Fade Volume"] = "Sound Fade Volume";
L["Sound Fade Volume Desc"] = "The sound effects volume to fade to while reading. A volume that is already lower is not raised.";
L["Sound Fade Duration"] = "Sound Fade Duration";
L["Sound Fade Duration Desc"] = "How long the sound effects take to fade down, and back up again.\n\nDefault: 0.5s";
L["Music Fade Volume"] = "Music Fade Volume";
L["Music Fade Volume Desc"] = "The music volume to fade to while reading. A volume that is already lower is not raised.";
L["Music Fade Duration"] = "Music Fade Duration";
L["Music Fade Duration Desc"] = "How long the music takes to fade down, and back up again.\n\nDefault: 0.5s";
L["Ambiance Fade Volume"] = "Ambiance Fade Volume";
L["Ambiance Fade Volume Desc"] = "The ambience volume to fade to while reading. A volume that is already lower is not raised.";
L["Ambiance Fade Duration"] = "Ambiance Fade Duration";
L["Ambiance Fade Duration Desc"] = "How long the ambience takes to fade down, and back up again.\n\nDefault: 0.5s";
L["Audio Fade Music Spoken"] = "|cffff8040Spoken plays its voices on the music channel, so the music volume is left unchanged.|r";

-- Settings: Other Addons tab
L["Tooltip"] = "Tooltip";
L["Auction House"] = "Auction House";
L["Auction House Desc"] = "Add auction house prices to the item tooltip, from another addon you have installed. Choose which one below.";
L["Auction House Auctionator Desc"] = "Auctionator: the auction price, the median price and the disenchant value of the item, as Auctionator shows them in its own tooltips. The lines follow Auctionator's own tooltip options.";
L["Auction House RetailAH Desc"] = "Retail Auction House (mod-retail-ah): what the server's AH bot buyer pays for the item (the stack total for a stack), and the average value of the materials one disenchant gives. The better of the two is green.\n\nNothing is shown for an item that is soulbound, and the disenchant line is grey when your Enchanting is too low. The server must run the mod-retail-ah module.";
L["Journal Gear Desc"] = "Add an \"On your gear list\" line to the tooltip of items that are an upgrade for your spec, from the Journal: Gear addon (JournalGearBIS).";
L["Addon Not Installed"] = "|cffff8040%s is not installed or not loaded, so this support will not work.|r Install it and reload the UI (/reload).";
L["Spoken Buttons"] = "Spoken Buttons";
L["Spoken Buttons Desc"] = "Adds Spoken's Play and Skip buttons to the quest and gossip window and to the book view, which would otherwise be left without them while DialogueUI hides the game's UI.\n\nThis needs a few files copied into the Spoken addons. See the Spoken entry under Supported addons in the README.md of the DialogueUI addon for what to do.";
L["Spoken Bridge Missing"] = "|cffff8040The bridge file is not in the Spoken folder yet.|r See the Spoken entry under Supported addons in the README.md of the DialogueUI addon for what to do.";
L["AH Bot Buys"] = "AH bot buys";
L["AH Bot Disenchant"] = "Disenchant (AH bot)";
L["AH Bot Disenchant Skill"] = "Disenchant |cff808080(Enchanting %d)|r";
L["AH Bot BiS Bonus"] = "BiS bonus";

-- Settings: Compatibility
L["Compatibility"] = "Compatibility";
L["Disable DUI In Instance"] = "Use WoW's Default UI In Instance";
L["Disable DUI In Instance Desc"] = "Disable Dialogue UI and use WoW's default one when you are in dungeon or raid.";

-- Settings: Loot UI tab
L["Use Loot UI"] = "Use Loot UI";
L["Use Loot UI Desc"] = "Replace the game's default looting window with Loot UI.\n\nLoot UI is a port of the Loot UI from the Plumber addon from retail.";
L["Loot UI Font Size Desc"] = "Set the font size for the Loot UI. It is separate from the font size of the UI tab.\n\nDefault: 12";
L["Fade Out Delay Per Item"] = "Fade Out Delay Per Item";
L["Fade Out Delay Per Item Desc"] = "How long the Loot UI window stays on screen for each item it shows, on top of a base time. A higher value keeps long lists readable for longer.\n\nDefault: 0.25s";
L["Items Per Page"] = "Items Per Page";
L["Items Per Page Desc"] = "Set how many items fit on one page of the Loot UI window when it shows what you received. More items are shown on following pages.\n\nThis does not affect the window while you loot manually.\n\nDefault: 6";
L["Opacity"] = "Opacity";
L["Loot UI Opacity Desc"] = "Set the opacity of the background of the Loot UI window when it shows what you received.\n\nThis does not affect the window while you loot manually.\n\nDefault: 50%";
L["Show Number Of Owned Items"] = "Show Number Of Owned Items";
L["Show Number Of Owned Items Desc"] = "Show how many of an item you own on its icon in the Loot UI window. The count includes the items in your bank (the bank is counted as of your last visit to it).\n\nDefault: On";
L["Grow Upwards"] = "Grow Upwards";
L["Grow Upwards On Desc"] = "When enabled: the bottom left of the window remains still, and new notifications will appear on top of the old ones.";
L["Grow Upwards Off Desc"] = "When disabled: the top left of the window remains still, and new notifications will appear on bottom of the old ones.";
L["Combine Similar Items"] = "Combine Similar Items";
L["Combine Similar Items Desc"] = "Display similar items on a single row.\n\nSupported categories:\n\n- Junk Items\n\nDefault: On";
L["Send to Back"] = "Send to Back";
L["Send to Back Desc"] = "While the Loot UI shows what you received, place its window behind other UI.\n\nThis does not affect the window while you loot manually.\n\nDefault: Off";
L["Loot Under Mouse"] = "Open Loot Window at Mouse";
L["Loot Under Mouse Desc"] = "While you loot manually, the loot window appears under the current mouse location.\n\nThis does not affect the window while it shows what you received.\n\nDefault: Off";
L["Press Key To Take All Items"] = "Press Key To Take All Items";
L["Press Key To Take All Items Desc"] = "While you loot manually, press the following key to take all items. While the loot window is open, this key does nothing else, even if it is also on your action bar.\n\nRight-click the key to go back to the default key.\n\nDefault: On";
L["Hide You Received Text"] = "Hide \"You Received\" Text";
L["Hide You Received Text Desc"] = "Hide the \"You Received\" text above the Loot UI window when it shows what you received.\n\nDefault: Off";
L["Show Reputation Changes"] = "Show Reputation Changes";
L["Show Reputation Changes Desc"] = "Display any reputation increases in the Loot UI window.\n\nDefault: Off";
L["Show Any Money Changes"] ="Show Any Money Changes";
L["Show Any Money Changes Desc"] = "Show the money you gain from all sources (selling, quests, mail ...), not just from loot.\n\nDefault: Off";
L["Show Any Currency Changes"] = "Show Any Currency Changes";
L["Show Any Currency Changes Desc"] = "Show the honor points, arena points and currencies you gain from all sources, not just from loot. Only gains are shown.\n\n|cffff4800Currencies that are items (such as Emblems) are shown while you loot as the items they are.|r\n\nDefault: Off";
L["You Received"] = "You Received";
L["Junk Items"] = "Junk Items";
L["Take All"] = "Take All";
L["Give To"] = "Give To";
L["Fast Loot"] = "Fast Loot";
L["Fast Loot Desc"] = "Take the loot as soon as the looting window opens, instead of waiting a moment first. Only applies when the game's Auto Loot is on, or Loot UI forces it.\n\nThe fast loot of the Plumber addon.";

-- Settings: Minimap tab and minimap button
L["Show Minimap Button"] = "Show Minimap Button";
L["Show Minimap Button Desc"] = "Show a button on the minimap that opens these settings. Drag it to move it around the minimap.";
L["Minimap Button Tooltip"] = "Click to open the settings.";
L["Minimap Button Drag"] = "Drag to move";

-- Settings: UI tab
L["Theme"] = "Theme";
L["Theme Desc"] = "Select a color theme for the UI.";
L["Loot Theme Desc"] = "Select a color theme for the Loot UI. It can differ from the theme of the rest of the UI.";
L["Theme Brown"] = "Brown";
L["Theme Dark"] = "Dark";
L["Frame Size"] = "Frame Size";
L["Frame Size Desc"] = "Set the size of the dialogue UI.\n\nDefault: Medium";
L["Size Extra Small"] = "Extra Small";
L["Size Small"] = "Small";
L["Size Medium"] = "Medium";
L["Size Large"] = "Large";
L["Size Very Large"] = "Very Large";
L["Size Extra Large"] = "Extra Large";
L["Open Animation"] = "Open Animation";
L["Open Animation Desc"] = "How long the dialogue frame takes to open. 0s shows it at once.\n\nDefault: 0.25s";
L["Font Size"] = "Font Size";
L["Font Size Desc"] = "Set the font size for the UI.\n\nDefault: 12";
L["Font"] = "Font";
L["Font Desc"] = "Select the font used by the UI.\n\nDefault Font: Friz Quadrata";
L["Default Font"] = "Default Font";
L["System Font"] = "System";
L["Font Missing"] = "The font you chose is not available, so the default font is used.";
L["Font No Shared Media"] = "Install SharedMedia, or any addon that adds fonts through LibSharedMedia-3.0, to get more fonts here.";
L["Frame Orientation"] = "Orientation";
L["Frame Orientation Desc"] = "Place the UI on the left or right side of the screen.\n\nCustom lets you drag the UI anywhere while this window is open.\n\nDefault: Right";
L["Orientation Left"] = "Left";
L["Orientation Right"] = "Right";
L["Orientation Custom"] = "Custom";
L["Move Position"] = "Move";
L["Reset Position"] = "Reset Position";
L["Move Position Desc"] = "Show the UI so you can drag it to a new position.";
L["Reset Position Desc"] = "Reset the UI's position.";
L["Readables Position"] = "Position";
L["Readables Position Desc"] = "Place readables (books, letters, plaques) on the left side of the screen.\n\nCustom lets you drag them anywhere while this window is open.\n\nDefault: Default";
L["Position Default"] = "Default";
L["Readables Move Position Desc"] = "Show a sample readable so you can drag it to a new position.";
L["Readables Reset Position Desc"] = "Reset the readable's position.";
L["Hide UI"] = "Hide UI";
L["Hide UI Desc"] = "Fade out the game UI when you interact with an NPC.";
L["Readables Hide UI Desc"] = "Fade out the game UI while you read a book, letter or plaque.";
L["Show NPC Name On Page"] = "Show NPC Name";
L["Show NPC Name On Page Desc"] = "Show the NPC name on the page.";
L["Show Quest Type"] = "Show Quest Type";
L["Show Quest Type Desc"] = "Show the quest type (Quest, Daily, Weekly, Dungeon, ...) above the quest title.";
L["Show Copy Text Button"] ="Show Copy Text Button";
L["Show Copy Text Button Desc"] = "Show a Copy Text button on the top right of the dialogue UI.\n\nIt also includes game data like NPC and item IDs (and quest IDs of quests already in your log).";
L["Copy Text"] = "Copy Text";
L["Drag To Move"] = "Left-click and drag to move the window.";
L["Edit Mode Title"] = "Dialogue UI";
L["Edit Mode Body"] = "Drag this window to where you want it. Close the settings window to hide it.";

-- Quest types and tags
L["Quest"] = "Quest";
L["Readables"] = "Readables";
L["BookUI Frame Size Desc"] = "Set the size of the Book UI.\n\nDefault: Small";
L["BookUI Keep UI Open"] = "Keep Window Open";
L["BookUI Keep UI Open Desc"] = "Keep the window open when you move away from the object.\n\nPress Escape or right-click on the UI to close it.";
L["BookUI Show Location"] = "Show Location";
L["BookUI Show Location Desc"] = "Show the object's location in the header.\n\nOnly works for game objects, not items in your bags.";
L["BookUI Show Item Description"] = "Show Item Description";
L["BookUI Show Item Description Desc"] = "If the item has any description on its tooltip, display it on the top of the UI.";
L["BookUI Darken Screen"] = "Darken Screen";
L["BookUI Darken Screen Desc"] = "Darken the area below the UI to help you concentrate on the content.";

-- Settings: Control tab (retail enUS where it exists)
L["Input Device"] = "Input Device";
L["Input Device Desc"] = "Affects hotkey icons and UI layout.";
L["Input Device KBM"] = "Keyboard & Mouse";
L["Use Custom Bindings"] = "Use Custom Bindings";
L["Use Custom Bindings Desc"] = "Enable this option to use your own bindings.";
L["Primary Control Key Desc"] = "Press this key to select the first available option like Accept Quest.";
L["Right Click To Close UI"] = "Right Click To Close UI";
L["Right Click To Close UI Desc"] = "Right click on the dialogue UI to close it.";
L["Press Button To Scroll Down"] = "Press Button To Scroll Down";
L["Press Button To Scroll Down Desc"] = "If the content is taller than the viewport, pressing the Confirm Button will scroll the page down instead of accepting quest.";
L["Press Escape To Decline Quest"] = "Press Escape To Decline Quest";
L["Press Escape To Decline Quest Desc"] = "When viewing a quest from an NPC that has other dialogues, pressing the Escape key leads you back to the previous page instead of closing the UI.";
L["Press Tab To Select Reward"] = "Press Tab To Select Reward";
L["Press Tab To Select Reward Desc"] = "Press Tab to cycle through choosable rewards when you turn in the quest. Shift-Tab goes back.";
L["Keybinding Hint"] = "Click, then press the key you want to use.\nRight click: back to the default key.\nEsc: cancel.";
L["Bound To"] = "Bound to: ";
L["Not Bound"] = NOT_BOUND or "Not Bound";
L["Action Confirm"] = "Confirm";
L["Action Settings"] = "Toggle Settings";
L["Action Option1"] = "Option 1";
L["Action Option2"] = "Option 2";
L["Action Option3"] = "Option 3";
L["Action Option4"] = "Option 4";
L["Action Option5"] = "Option 5";
L["Action Option6"] = "Option 6";
L["Action Option7"] = "Option 7";
L["Action Option8"] = "Option 8";
L["Action Option9"] = "Option 9";
L["Action Option Desc"] = "Press this key to select option %d of the list (quests and gossip options).";
L["Action Settings Desc"] = "Press this key to open or close the settings window while the dialogue is shown.";

L["Quest Frequency Daily"] = "Daily";
L["Quest Frequency Weekly"] = "Weekly";
L["Quest Type Repeatable"] = "Repeatable";
L["Quest Difficulty VeryHard"] = "Very Hard";
L["Quest Difficulty Hard"] = "Hard";
L["Quest Difficulty Easy"] = "Easy";
L["Quest Difficulty Trivial"] = "Low Level";
L["Quest Difficulty Option"] = "Quest Difficulty";
L["Instant Quest Text"] = "Instant Text";
L["Instant Quest Text Desc"] = "Show the text at once instead of fading it in on Quest pages and Readables. This uses the same game setting as Blizzard's quest text option.";
L["Mark Highest Sell Price"] = "Mark Highest Sell Price";
L["Mark Highest Sell Price Desc"] = "Show you which item has the highest sell price when you are choosing a reward.";
L["Show Replace Calculations"] = "Show Replace Calculations";
L["Show Replace Calculations Desc"] = "Show the stat differences under \"Replace\" in the item tooltip. When off, only the Replace line with the name of the equipped item is shown.";
L["Use Blizzard Tooltip"] ="Use Blizzard Tooltip";
L["Use Blizzard Tooltip Desc"] = "Use Blizzard tooltip for the quest reward button instead of our special tooltip.";
L["Show EXP Bar"] = "Experience Bar";
L["Show EXP Bar Desc"] = "Show an experience bar at the bottom of the screen while a conversation is open.";
L["Always Show EXP Bar"] = "Always Show Experience Bar";
L["Always Show EXP Bar Desc"] = "Keep the experience bar on screen when no conversation is open, so it can be used as your experience bar.";
L["Color Player Name"] = "Color Player Name (Dark Mode Only)";
L["Color Player Name Desc"] = "Show your character's name in the quest and gossip text in your class color. Dark theme only.";
L["Color Class Name"] = "Color Class Name (Dark Mode Only)";
L["Color Class Name Desc"] = "Show your class name in the quest and gossip text in your class color. Dark theme only.";
L["Format Unit Level"] = "Level %d";
L["Format Player XP"] = "XP: %d/%d (%d%%)";
L["Format Gained XP"] = "%d XP";
L["To Next Level Label"] = "To next level";
L["Use Separate Tooltip for Comparison"] = "Use Separate Tooltip for Comparison";
L["Use Separate Tooltip for Comparison Desc"] = "Show the equipped item you would replace in a tooltip of its own beside the reward tooltip, with the stat differences at the bottom. Rings, trinkets and weapons get one tooltip for each equipped item.";
L["Use Separate Tooltip Blizzard Active"] = "Not available while \"%s\" is on. Turn that option off to use this one.";
L["Show Transmog Status"] = "Show Uncollected Appearances";
L["Show Transmog Status Desc"] = "Mark reward items whose transmog appearance you have not collected yet, and add a line to their tooltip.\n\n|cffff8040The server must have the Transmog System module (mod-transmog) installed.|r Nothing is shown on a server without it.\n\nThe addon runs the .transmog sync command once and hides its output from the chat window.";
L["Use Transmog Plus"] = "Using Mod Transmog Plus";
L["Use Transmog Plus Desc"] = "Check this if the server runs mod-transmog-plus instead of the original mod-transmog. The server then answers for each item, and counts an appearance as collected when any item with the same model is.\n\nLeave it unchecked for the original mod-transmog.";
L["Transmog Not Collected"] = "Appearance not collected";
L["Transmog Module Missing"] = "|cffff8040The server's %s module was not detected, so this setting is disabled.|r";
L["Click To Copy To Clipboard"] = "Click to copy to clipboard";
L["Show Upgrade Arrow"] = "Show Upgrade Arrow (Pawn Required)";
L["Show Upgrade Arrow Desc"] = "Show a green arrow %s on a reward item if it is an upgrade for your character, according to the Pawn addon: the item scores higher than the one you have equipped in that slot in at least one of your Pawn scales.\n\nArmor of a different type than the one you have equipped (cloth over leather, for example) is never marked.";
L["Show Upgrade Arrow Pawn Missing"] = "Requires the Pawn addon (not found).\n\nDownload: |cff0000ee%s|r\n\nClick the copy icon, press Ctrl+C, then paste the link into your browser.";
L["Quest Difficulty Option Desc"] = "Choose how quest difficulty is displayed when the NPC offers you a list of quests.";
L["QuestDifficultyStyle Off"] = "OFF";
L["QuestDifficultyStyle Off Desc"] = "Quest level and difficulty are now hidden.";
L["QuestDifficultyStyle Level"] = "Level";
L["QuestDifficultyStyle Level Desc"] = "Display the quest level to the left of the quest title.";
L["QuestDifficultyStyle Name"] = "Name";
L["QuestDifficultyStyle Both"] = "Both";
L["QuestDifficultyStyle Both Desc"] = "Display the quest level to the left of the quest title, and the difficulty name on the right of the quest button if the quest level is outside the recommended range.";
L["QuestDifficultyStyle Name Desc"] = "Display the difficulty name on the right of the quest button if the quest level is outside the recommended range.\n(The quest level is +3 or -3 from your character level)";
L["Quest Type Trivial"] = "Trivial";
L["Quest Type Dungeon"] = "Dungeon";
L["Quest Type Raid"] = "Raid";
L["Quest Type Heroic"] = "Heroic";
L["Quest Type Elite"] = "Elite";
L["Quest Type Group"] = "Group";
L["Quest Type PvP"] = "PvP";

-- Quest text
L["Quest Objectives"] = "Objectives";
L["Format Suggested Players"] = QUEST_SUGGESTED_GROUP_NUM or "Suggested Players [%d]";
L["Quest Accepted Alert"] = ERR_QUEST_ACCEPTED_S or "Quest accepted: %s";

-- Rewards
L["Reward"] = "Reward";
L["Rewards"] = "Rewards";
L["Reward Choose"] = REWARD_CHOOSE or "Choose your reward:";
L["Reward Choices"] = REWARD_CHOICES or "You will be able to choose one of these rewards:";
L["Reward Items"] = REWARD_ITEMS or "You will also receive:";
L["Requirements"] = "Requirements";
L["Money"] = MONEY or "Money";
L["Honor Points"] = "Honor";
L["Arena Points"] = "Arena Points";
L["Talent Points"] = "Talent Points";
L["Experience"] = "Experience";
L["Title"] = "Title";
L["Format Talent Point Row"] = "+%d Talent Point";
L["Format Talent Points Row"] = "+%d Talent Points";

-- Reward tooltip
L["Show Comparison"] = "Show Comparison";
L["Hide Comparison"] = "Hide Comparison";
L["Sell Price"] = SELL_PRICE or "Sell Price";
L["Format Item Level"] = ITEM_LEVEL or "Item Level %d";
L["Format You Have"] = "- You have |cffffffff%d|r";
L["Format In Bank"] = " (|cffffffff%d|r in bank)";
L["Format Replace Item"] = "Replace %s";
L["Equipped Item"] = "equipped item";
L["Currently Equipped"] = "Currently Equipped";
L["Different Item Type"] = "Different item type than the equipped one.";
L["Identical Stats"] = "Identical Stats";
L["Format Reward Title"] = "You will be granted the title \"%s\".";
L["Format Reward Honor"] = "You will receive %d honor points.";
L["Format Reward Talent Point"] = "You will receive %d talent point.";
L["Format Reward Talent Points"] = "You will receive %d talent points.";
L["Format Reward Arena"] = "You will receive %d arena points.";
L["Format Reward Experience"] = "You will gain %d experience%s.";
L["Format Of Your Level"] = " (%d%% of your level)";

-- Quest Item Display
L["Quest Item Display"] = "Quest Item Display";
L["Quest Item Display Desc"] = "Auto display the quest item's description and allow you to use it without opening bags.";
L["Quest Item Display Hide Seen"] = "Ignore Seen Items";
L["Quest Item Display Hide Seen Desc"] = "Ignore items that have been discovered by any of your characters.";
L["Quest Item Display Await World Map"] = " Await World Map";
L["Quest Item Display Await World Map Desc"] = "When you open the World Map, temporarily hide the Quest Item Display and pause the auto close timer.";
L["Quest Item Display Reset Position Desc"] = "Reset the window's position.";
L["Valuable Reward Popup"] = "Valuable Reward Popup (Pawn Required)";
L["Valuable Reward Popup Sample"] = "Valuable Reward Popup";
L["Valuable Reward Popup Desc"] = "When a quest gives you an item that is an upgrade for your character, according to the Pawn addon, show a button that lets you equip it directly.\n\nThe button is off while you are in combat.";
L["Item Equipped"] = "Equipped";
L["Press Key To Use Item"] = "Press Button To Use";
L["Press Key To Use Item Desc Generic"] = "Press the Confirm Button (current: %s) to use the item when you are out of combat.";
L["Press Key To Use Item Desc PC"] = "Press Space to use the item when you are out of combat.";
L["Click To Read"] = "Left Click to Read";
L["Begins A Quest"] = "Begins a Quest";

-- Supported addons
L["Format Reward Title Row"] = "Title: %s";
L["On Your Gear List"] = "On your gear list";
L["Format Exchange It For"] = "Exchange it for: %s";
