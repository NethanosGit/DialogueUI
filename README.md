# Dialogue UI (3.3.5a)

A port of the retail **Dialogue UI** addon to **World of Warcraft: Wrath of the Lich King 3.3.5a**. It replaces the default quest and gossip windows with a clean, readable dialogue screen, and adds a few quality-of-life features around quests and readable objects.

## Opening the settings

- Type **/dialogueui**, **/dialogui** or **/dui** in chat. If DragonUI is loaded, **/dui** belongs to DragonUI, so use **/dialogueui** or **/dialogui**.
- Press **F1** while a dialogue is open.
- Click the **minimap button**.

The settings have six tabs: **UI**, **Control** (including custom key bindings), **Gameplay**, **Audio**, **Other Addons** and **Experimental**.

**Quest UI - Light Theme**

![Quest UI - Light Theme](Preview/QuestUI-Light.jpg)

**Quest UI - Dark Theme**

![Quest UI - Dark Theme](Preview/QuestUI-Dark.jpg)

**Book UI - Parchment**

![Book UI - Parchment](Preview/BookUI-Parchment.jpg)

**Book UI - Metal**

![Book UI - Metal](Preview/BookUI-Metal.jpg)

## Features

- Select options and accept quests by pressing a keyboard key.
- Adjustable font size and frame size to increase readability.
- Copy dialogue text, with NPC and item IDs.
- Display the lore text when you pick up a quest item.
- Optional **Audio Fading** (off by default, **Audio** tab): lowers the sound, music and ambience volumes while the dialogue window or a readable is open, and fades them back afterwards.
- Readable objects (books, plaques, notes) in their own window.

## Details

### Two themes
Pick the **Brown** (parchment) or **Dark** theme. You can also change the frame size, font size and which side of the screen the window sits on (or drag it anywhere).

### Quest dialogue
- Quest text, objectives and rewards on one page, with a footer of Accept / Continue / Complete buttons.
- Number-key shortcuts for the options in a quest or gossip list, and a key to confirm.
- Optional **Instant Quest Text** (no fade-in), **Hide UI** while talking to an NPC, and a **Show NPC Name** toggle.

### Quest type label
Shows the type of quest (Daily, Weekly, Dungeon, Raid, Heroic, Elite, Group, PvP, Repeatable) above the title.

![Quest type](Preview/QuestTypeText.png)

### Quest difficulty in the list
When an NPC offers several quests, show the quest level, the difficulty name, or both next to each quest.

![Quest difficulty](Preview/QuestDifficultyStyle.png)

### Mark the highest sell price
When you must choose a reward, the item that sells for the most is marked.

![Highest sell price](Preview/MarkHighestSellPrice.png)

### Upgrade arrow and Valuable Reward Popup (needs Pawn or Journal: Gear Guide)
With the [Pawn](https://www.curseforge.com/wow/addons/pawn) addon or Journal: Gear Guide installed, reward items that are upgrades for your character get a green arrow. A popup lets you equip such an item directly after turning in the quest. With Journal: Gear Guide, its gear list decides for the gear it knows, and Pawn decides for the rest.

![Valuable reward popup](Preview/QuickSlotQuestReward.png)

### Uncollected transmog appearances
On servers with a transmog module (mod-transmog or mod-transmog-plus), reward items whose appearance you have not collected yet get a magenta corner mark and an "Appearance not collected" line in the tooltip. Turn it on with **Show Uncollected Appearances**; check **Using Mod Transmog Plus** if the server runs mod-transmog-plus.

![Uncollected appearance](Preview/Transmog.png)

### Quest Item Display
When a quest item is added to your bags, its description is shown and you can use it without opening your bags.

![Quest item display](Preview/QuestItemDisplay.png)

### Copy Text button
Copy the dialogue text, along with NPC and item IDs, to paste elsewhere.

![Copy text](Preview/CopyTextButton.png)

### Readables
Books, notes and other readable objects open in their own window. Choose its size, keep it open when you walk away, show the object's location and item description, and darken the screen behind it.

![Readables](Preview/BookUI.png)

### Experimental features
**Loot UI** (off by default): replaces the game's looting window with a "You Received" notification window, a port of the Loot UI from the Plumber addon. Options include Fast Loot, font size, items per page, fade out delay and a transmog status mark. Enable it in the **Loot UI** tab of the settings.

![Loot UI](Preview/LootUI.png)

### Supported addons

- **Auctionator**
- **Retail Auction House** (mod-retail-ah): AH bot prices in the item tooltip. Choose Auctionator or Retail Auction House under **Other Addons**.
- **Journal: Gear Guide (JournalGearGuide)**: "On your gear list" line in the item tooltip, and its upgrade arrow on reward items
- **[Spoken](https://github.com/PatchFoundry335/spoken-wow)** (the voice player, the 3.3.5 version is available there): Spoken's **Play** and **Skip** buttons on the quest and gossip window and on the book view. Spoken draws its buttons in the game's UI, which DialogueUI hides, so a few changed files have to be copied into the Spoken folders (steps below).

To switch on the Spoken support:

1. Install Spoken and Spoken Readables, both version **3.5.1**.
2. Close the game.
3. Open `Interface\AddOns\DialogueUI\SupportedAddons\`. Select the folders `Spoken` and `Spoken_Readables` and copy them into `Interface\AddOns\`. When asked, replace the existing files.
4. Start the game and check **Spoken Buttons** under **Other Addons**. It is off by default and greyed out until Spoken has the files.

The folders hold only the files that change, at the same paths as in `Interface\AddOns\`:

| File | What it does |
|---|---|
| `Spoken\SpokenDialogueUI.lua` | Adds Spoken's buttons to DialogueUI's windows |
| `Spoken\Spoken.toc` | Loads the file above |
| `Spoken_Readables\Audio.lua` | Finds the readables voice pack under either of its names |
| `Spoken_Readables\Events.lua` | Keeps the open page while DialogueUI's book view is up |
| `Spoken_Readables\UI\DialogueUIBook.lua` | Fixes the greyed out Play button on the book view |

Play on a quest or gossip page needs Spoken Quests, and Play on a book needs Spoken Readables. These files are made for version 3.5.1 of both: do not copy them over another version. A Spoken update replaces them.

## Installation

1. Download this repository (Code > Download ZIP) or clone it.
2. Put the folder in `World of Warcraft\Interface\AddOns\`.
   - If you downloaded the ZIP from GitHub, the folder is named `DialogueUI-main`. **Delete the `-main` from the folder name** so it is called `DialogueUI`. The game will not load the addon otherwise.
3. Start the game and enable **Dialogue UI** in the AddOns list on the character select screen.

## Notes

- Built for client **3.3.5a** (Interface 30300) only.
- This is a direct port of [Dialogue UI (YUI-Dialogue)](https://github.com/Peterodox/YUI-Dialogue) by Peterodox. All credit for the design and the original addon goes to them, and many thanks for making it. Some retail features (such as Auto Complete Quest and the Gossip options group) are not included because they do not apply to 3.3.5a.
- Pawn and Journal: Gear Guide are optional. The upgrade arrow and the Valuable Reward Popup need at least one of them.
