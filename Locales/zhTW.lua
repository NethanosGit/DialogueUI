-- 繁體中文. Strings come from the retail Dialogue UI locale where it has the same text, the rest are written for this port.
if not (GetLocale() == "zhTW") then return end;

local _, addon = ...;
local L = addon.L;

-- Blizzard's own global strings are used where they exist (they follow the client language). The text below is the fallback.

-- Footer buttons
L["Accept"] = ACCEPT or "接受";
L["Restart Quest"] = "重新開始";
L["Continue"] = CONTINUE or "繼續";
L["Complete Quest"] = COMPLETE or "完成任務";
L["Incomplete"] = INCOMPLETE or "未完成";
L["Decline"] = DECLINE or "拒絕";
L["Cancel"] = CANCEL or "取消";
L["Goodbye"] = GOODBYE or "再見";

-- Settings window
L["UI"] = "介面";
L["Control"] = "控制";
L["Gameplay"] = "遊戲功能";
L["Audio"] = "音訊";
L["Minimap"] = "小地圖";
L["Other Addons"] = "其他插件";

-- Settings: Audio tab
L["Enable Audio Fading"] = "啟用音量淡化";
L["Enable Audio Fading Desc"] = "對話視窗或可閱讀物品開啟時降低遊戲音量。關閉後，音量會逐漸恢復到遊戲聲音選項中設定的數值。";
L["Sound Fade Volume"] = "音效淡化音量";
L["Sound Fade Volume Desc"] = "閱讀時音效逐漸降低到的音量。已經更低的音量不會被調高。";
L["Sound Fade Duration"] = "音效淡化時間";
L["Sound Fade Duration Desc"] = "音效降低以及恢復所需的時間。\n\n預設值：0.5s";
L["Music Fade Volume"] = "音樂淡化音量";
L["Music Fade Volume Desc"] = "閱讀時音樂逐漸降低到的音量。已經更低的音量不會被調高。";
L["Music Fade Duration"] = "音樂淡化時間";
L["Music Fade Duration Desc"] = "音樂降低以及恢復所需的時間。\n\n預設值：0.5s";
L["Ambiance Fade Volume"] = "環境音淡化音量";
L["Ambiance Fade Volume Desc"] = "閱讀時環境音逐漸降低到的音量。已經更低的音量不會被調高。";
L["Ambiance Fade Duration"] = "環境音淡化時間";
L["Ambiance Fade Duration Desc"] = "環境音降低以及恢復所需的時間。\n\n預設值：0.5s";
L["Audio Fade Music Spoken"] = "|cffff8040Spoken 透過音樂聲道播放語音，因此音樂音量保持不變。|r";

-- Settings: Other Addons tab
L["Tooltip"] = "滑鼠提示";
L["Auction House"] = "拍賣場";
L["Auction House Desc"] = "在物品的滑鼠提示中加入來自另一個已安裝插件的拍賣場價格。請在下方選擇使用哪一個。";
L["Auction House Auctionator Desc"] = "Auctionator：顯示物品的拍賣價格、中位價格與分解價值，與 Auctionator 自己的滑鼠提示一致。顯示的行遵循 Auctionator 自己的滑鼠提示選項。";
L["Auction House RetailAH Desc"] = "Retail Auction House (mod-retail-ah)：顯示伺服器拍賣場機器人買家為該物品支付的價格（堆疊物品顯示整堆總價），以及一次分解所得材料的平均價值，兩者中較高的顯示為綠色。\n\n已綁定的物品不顯示任何內容，附魔技能不足時分解一行為灰色。伺服器必須執行 mod-retail-ah 模組。";
L["Journal Gear Desc"] = "在對你的專精有提升的物品的滑鼠提示中加入「在你的裝備清單中」一行，來自 Journal: Gear (JournalGearBIS) 插件。";
L["Addon Not Installed"] = "|cffff8040%s 未安裝或未載入，因此此支援不會生效。|r 請安裝後重新載入介面 (/reload)。";
L["Spoken Buttons"] = "Spoken 按鈕";
L["Spoken Buttons Desc"] = "在任務與閒聊視窗和書籍檢視中加入 Spoken 的播放與跳過按鈕；DialogueUI 隱藏遊戲介面時，這些視窗原本沒有這些按鈕。\n\n需要把幾個檔案複製到 Spoken 插件中。具體操作請見 DialogueUI 插件 README.md 中 Supported addons 下的 Spoken 項目。";
L["Spoken Bridge Missing"] = "|cffff8040橋接檔案尚未放入 Spoken 資料夾。|r 具體操作請見 DialogueUI 插件 README.md 中 Supported addons 下的 Spoken 項目。";
L["AH Bot Buys"] = "拍賣場機器人收購";
L["AH Bot Disenchant"] = "分解（拍賣場機器人）";
L["AH Bot Disenchant Skill"] = "分解 |cff808080(附魔 %d)|r";
L["AH Bot BiS Bonus"] = "BiS 加成";

-- Settings: Compatibility
L["Compatibility"] = "相容性";
L["Disable DUI In Instance"] = "副本內使用原始對話介面";
L["Disable DUI In Instance Desc"] = "進入地城或團隊副本時自動停用 Dialogue UI 並切換為預設對話介面。";

-- Settings: Minimap tab and minimap button
L["Show Minimap Button"] = "顯示小地圖按鈕";
L["Show Minimap Button Desc"] = "在小地圖旁顯示一個按鈕，點擊可開啟這些設定。拖曳可沿小地圖移動它。";
L["Minimap Button Tooltip"] = "點擊開啟設定。";
L["Minimap Button Drag"] = "拖曳以移動";

-- Settings: UI tab
L["Theme"] = "主題";
L["Theme Desc"] = "選擇介面外觀主題。";
L["Loot Theme Desc"] = "選擇拾取介面的外觀主題。可以與其他介面的主題不同。";
L["Theme Brown"] = "棕色";
L["Theme Dark"] = "深色";
L["Frame Size"] = "視窗大小";
L["Frame Size Desc"] = "設定對話介面的大小。\n\n預設：中";
L["Size Extra Small"] = "極小";
L["Size Small"] = "小";
L["Size Medium"] = "中";
L["Size Large"] = "大";
L["Size Very Large"] = "極大";
L["Size Extra Large"] = "超大";
L["Open Animation"] = "開啟動畫";
L["Open Animation Desc"] = "對話視窗開啟所需的時間。0 秒表示立即顯示。\n\n預設：0.25 秒";
L["Font Size"] = "字型大小";
L["Font Size Desc"] = "設定介面的字體大小。\n\n預設：12";
L["Font"] = "字型";
L["Font Desc"] = "選擇介面使用的字型。\n\n預設字型：Friz Quadrata";
L["Default Font"] = "預設字型";
L["System Font"] = "系統";
L["Font Missing"] = "所選字型無法使用，因此使用預設字型。";
L["Font No Shared Media"] = "安裝 SharedMedia 或其他透過 LibSharedMedia-3.0 提供字型的插件，即可在此取得更多字型。";
L["Frame Orientation"] = "介面位置";
L["Frame Orientation Desc"] = "將介面放在螢幕左側或右側。\n\n選擇「自訂」後，此視窗開啟期間可將介面拖曳到任意位置。\n\n預設：右側";
L["Orientation Left"] = "左側";
L["Orientation Right"] = "右側";
L["Orientation Custom"] = "自訂";
L["Move Position"] = "移動位置";
L["Reset Position"] = "重置位置";
L["Move Position Desc"] = "顯示介面，以便你將其拖曳到新位置。";
L["Reset Position Desc"] = "重置介面位置。";
L["Readables Position"] = "位置";
L["Readables Position Desc"] = "將可閱讀內容（書籍、信件、牌匾）放在螢幕左側。\n\n選擇「自訂」後，此視窗開啟期間可將其拖曳到任意位置。\n\n預設：預設";
L["Position Default"] = "預設";
L["Readables Move Position Desc"] = "顯示一個範例，以便你將其拖曳到新位置。";
L["Readables Reset Position Desc"] = "重置可閱讀內容的位置。";
L["Hide UI"] = "隱藏介面";
L["Hide UI Desc"] = "與 NPC 對話互動時隱藏其他遊戲介面。";
L["Readables Hide UI Desc"] = "閱讀書籍、信件或牌匾時隱藏其他遊戲介面。";
L["Show NPC Name On Page"] = "在頁面顯示 NPC 名字";
L["Show NPC Name On Page Desc"] = "在頁面上方顯示當前互動 NPC 的名稱。";
L["Show Quest Type"] = "顯示任務類型";
L["Show Quest Type Desc"] = "在任務標題上方顯示任務類型（任務、每日、每週、地城等）。";
L["Show Copy Text Button"] = "顯示複製文字按鈕";
L["Show Copy Text Button Desc"] = "在對話介面右上角顯示「複製文字」按鈕。\n\n其中還包含遊戲資料，如 NPC 和物品 ID（以及已在你任務日誌中的任務 ID）。";
L["Copy Text"] = "複製文字";
L["Drag To Move"] = "按住左鍵並拖曳以移動此視窗。";
L["Edit Mode Title"] = "Dialogue UI";
L["Edit Mode Body"] = "將此視窗拖曳到你想要的位置。關閉設定視窗即可將其隱藏。";

-- Quest types and tags
L["Quest"] = "任務";
L["Readables"] = "可閱讀書籍與物品";
L["BookUI Frame Size Desc"] = "設定書籍介面的大小。\n\n預設：小";
L["BookUI Keep UI Open"] = "維持介面開啟";
L["BookUI Keep UI Open Desc"] = "離開該物件後保持視窗開啟。\n\n按 Esc 或在介面上點擊右鍵可將其關閉。";
L["BookUI Show Location"] = "顯示所在位置";
L["BookUI Show Location Desc"] = "在標題中顯示該物件的位置。\n\n僅適用於遊戲物件，不適用於背包中的物品。";
L["BookUI Show Item Description"] = "顯示物品描述";
L["BookUI Show Item Description Desc"] = "若物品本身帶有描述文字，在書籍上方一併顯示。";
L["BookUI Darken Screen"] = "背景暗化效果";
L["BookUI Darken Screen Desc"] = "使介面背後的遊戲畫面變暗，專注於閱讀內容。";

-- Settings: Control tab (retail enUS where it exists)
L["Input Device"] = "輸入裝置";
L["Input Device Desc"] = "此選項會影響按鍵提示圖示與按鈕排列方式。";
L["Input Device KBM"] = "鍵盤和滑鼠";
L["Use Custom Bindings"] = "使用自訂快捷鍵";
L["Use Custom Bindings Desc"] = "勾選此選項以啟用自訂按鍵綁定。";
L["Primary Control Key Desc"] = "按下此按鍵會自動選擇最佳的對話選項，例如接受或完成任務。";
L["Right Click To Close UI"] = "點擊右鍵關閉介面";
L["Right Click To Close UI Desc"] = "在對話介面上點擊右鍵即可快速關閉視窗。";
L["Press Button To Scroll Down"] = "按確認鍵向下捲動";
L["Press Button To Scroll Down Desc"] = "若頁面無法完全顯示任務內容，按下確認鍵會向下捲動頁面而不是立即接受任務。";
L["Press Escape To Decline Quest"] = "按 Esc 鍵拒絕任務";
L["Press Escape To Decline Quest Desc"] = "在檢視任務內容時，若 NPC 還有其他對話選項，按 Esc 會返回上一層而非直接關閉對話。";
L["Press Tab To Select Reward"] = "按 Tab 鍵選擇任務獎勵";
L["Press Tab To Select Reward Desc"] = "交付任務時，按 Tab 鍵在可選獎勵之間循環切換。Shift+Tab 返回上一個。";
L["Keybinding Hint"] = "點擊，然後按下你想使用的按鍵。\n右鍵點擊：恢復預設按鍵。\nEsc：取消。";
L["Bound To"] = "綁定至：";
L["Not Bound"] = NOT_BOUND or "未綁定";
L["Action Confirm"] = "確認鍵";
L["Action Settings"] = "開啟/關閉設定視窗";
L["Action Option1"] = "對話選項 1";
L["Action Option2"] = "對話選項 2";
L["Action Option3"] = "對話選項 3";
L["Action Option4"] = "對話選項 4";
L["Action Option5"] = "對話選項 5";
L["Action Option6"] = "對話選項 6";
L["Action Option7"] = "對話選項 7";
L["Action Option8"] = "對話選項 8";
L["Action Option9"] = "對話選項 9";
L["Action Option Desc"] = "按下此鍵選擇清單（任務和對話選項）中的第 %d 項。";
L["Action Settings Desc"] = "顯示對話時，按下此鍵可開啟或關閉設定視窗。";

L["Quest Frequency Daily"] = "每日";
L["Quest Frequency Weekly"] = "每週";
L["Quest Type Repeatable"] = "可重複";
L["Quest Difficulty VeryHard"] = "極度困難";
L["Quest Difficulty Hard"] = "困難";
L["Quest Difficulty Easy"] = "簡單";
L["Quest Difficulty Trivial"] = "低等級";
L["Quest Difficulty Option"] = "任務難度";
L["Instant Quest Text"] = "即時顯示文字";
L["Instant Quest Text Desc"] = "在任務頁面和可閱讀書籍與物品中直接顯示文字，而不是漸顯。使用與暴雪任務文字選項相同的遊戲設定。";
L["Mark Highest Sell Price"] = "標記最高售價物品";
L["Mark Highest Sell Price Desc"] = "在選擇任務獎勵時，自動標記賣給商人售價最高的物品。";
L["Show Replace Calculations"] = "顯示替換計算";
L["Show Replace Calculations Desc"] = "在物品提示的「替換」下方顯示屬性差異。關閉後僅顯示帶有已裝備物品名稱的替換行。";
L["Use Blizzard Tooltip"] = "使用暴雪浮動提示";
L["Use Blizzard Tooltip Desc"] = "使用遊戲預設的浮動提示來顯示任務獎勵詳細資訊。";
L["Show EXP Bar"] = "經驗條";
L["Show EXP Bar Desc"] = "對話開啟時在畫面底部顯示經驗條。";
L["Always Show EXP Bar"] = "一律顯示經驗條";
L["Always Show EXP Bar Desc"] = "沒有開啟對話時也在畫面上保留經驗條，以便將其用作你的經驗條。";
L["Color Player Name"] = "玩家名字著色（僅限深色模式）";
L["Color Player Name Desc"] = "在任務與對話文字中，以職業顏色顯示你的角色名字。僅限深色主題。";
L["Color Class Name"] = "職業名稱著色（僅限深色模式）";
L["Color Class Name Desc"] = "在任務與對話文字中，以職業顏色顯示你的職業名稱。僅限深色主題。";
L["Format Unit Level"] = "等級 %d";
L["Format Player XP"] = "經驗值：%d/%d (%d%%)";
L["Format Gained XP"] = "%d 經驗值";
L["To Next Level Label"] = "距下一級";
L["Use Separate Tooltip for Comparison"] = "使用獨立的比較浮動提示";
L["Use Separate Tooltip for Comparison Desc"] = "在獎勵提示旁的獨立提示中顯示將被替換的已裝備物品，並在底部顯示屬性差異。戒指、飾品和武器會為每件已裝備物品各顯示一個提示。";
L["Use Separate Tooltip Blizzard Active"] = "開啟「%s」時無法使用。請先關閉該選項再使用本選項。";
L["Show Transmog Status"] = "顯示未收集的外觀";
L["Show Transmog Status Desc"] = "標記你尚未收集其塑形外觀的獎勵物品，並在其提示中加入一行。\n\n|cffff8040伺服器必須安裝塑形系統模組（mod-transmog）。|r 否則不會顯示任何內容。\n\n插件會執行一次 .transmog sync 指令，並在聊天視窗中隱藏其輸出。";
L["Use Transmog Plus"] = "使用 Mod Transmog Plus";
L["Use Transmog Plus Desc"] = "如果伺服器執行的是 mod-transmog-plus 而不是原版 mod-transmog，請勾選此項。伺服器將針對每件物品回覆，只要有任何相同模型的物品已收集，就視為該外觀已收集。\n\n使用原版 mod-transmog 時請不要勾選。";
L["Transmog Not Collected"] = "外觀未收集";
L["Transmog Module Missing"] = "|cffff8040未偵測到伺服器的 %s 模組，因此此設定已停用。|r";
L["Click To Copy To Clipboard"] = "點擊複製到剪貼簿";
L["Show Upgrade Arrow"] = "顯示升級箭頭（需要 Pawn）";
L["Show Upgrade Arrow Desc"] = "根據 Pawn 插件，如果獎勵物品對你的角色是升級，則在其上顯示綠色箭頭 %s：該物品在你至少一個 Pawn 評分方案中的得分高於該欄位已裝備的物品。\n\n與你所裝備的護甲類型不同的護甲（例如用布甲代替皮甲）永遠不會被標記。";
L["Show Upgrade Arrow Pawn Missing"] = "需要 Pawn 插件（未找到）。\n\n下載：|cff0000ee%s|r\n\n點擊複製圖示，按 Ctrl+C，然後將連結貼到瀏覽器中。";
L["Quest Difficulty Option Desc"] = "選擇在任務列表中顯示任務難度的方式。";
L["QuestDifficultyStyle Off"] = "關閉";
L["QuestDifficultyStyle Off Desc"] = "任務等級和難度現已隱藏。";
L["QuestDifficultyStyle Level"] = "任務等級";
L["QuestDifficultyStyle Level Desc"] = "在任務名稱左側顯示任務等級。";
L["QuestDifficultyStyle Name"] = "難度名稱";
L["QuestDifficultyStyle Both"] = "兩者";
L["QuestDifficultyStyle Both Desc"] = "在任務標題左側顯示任務等級；如果任務等級超出建議範圍，則在任務按鈕右側顯示難度名稱。";
L["QuestDifficultyStyle Name Desc"] = "若任務不在推薦等級範圍內，在任務按鈕最右側顯示難度名稱。\n（推薦範圍為比角色高兩級至低兩級以內）";
L["Quest Type Trivial"] = "低等級";
L["Quest Type Dungeon"] = "地城任務";
L["Quest Type Raid"] = "團隊任務";
L["Quest Type Heroic"] = "英雄";
L["Quest Type Elite"] = "精英";
L["Quest Type Group"] = "隊伍";
L["Quest Type PvP"] = "PvP";

-- Quest text
L["Quest Objectives"] = "任務目標";
L["Format Suggested Players"] = QUEST_SUGGESTED_GROUP_NUM or "建議玩家人數 [%d]";
L["Quest Accepted Alert"] = ERR_QUEST_ACCEPTED_S or "已接受任務：%s";

-- Rewards
L["Reward"] = "獎勵";
L["Rewards"] = "獎勵";
L["Reward Choose"] = REWARD_CHOOSE or "請選擇你的獎勵：";
L["Reward Choices"] = REWARD_CHOICES or "你可以從這些獎勵中選擇一件：";
L["Reward Items"] = REWARD_ITEMS or "你還將獲得：";
L["Requirements"] = "需求條件";
L["Money"] = MONEY or "金錢";
L["Honor Points"] = "榮譽";
L["Arena Points"] = "競技場點數";
L["Talent Points"] = "天賦點數";
L["Experience"] = "經驗值";
L["Title"] = "頭銜";
L["Format Talent Point Row"] = "+%d 點天賦點數";
L["Format Talent Points Row"] = "+%d 點天賦點數";

-- Reward tooltip
L["Show Comparison"] = "顯示裝備比較";
L["Hide Comparison"] = "隱藏裝備比較";
L["Sell Price"] = SELL_PRICE or "售價";
L["Format Item Level"] = ITEM_LEVEL or "物品等級 %d";
L["Format You Have"] = "- 你擁有 |cffffffff%d|r";
L["Format In Bank"] = "（銀行中有 |cffffffff%d|r）";
L["Format Replace Item"] = "替換 %s";
L["Equipped Item"] = "已裝備的物品";
L["Currently Equipped"] = "目前裝備";
L["Different Item Type"] = "與已裝備的物品類型不同。";
L["Identical Stats"] = "屬性相同";
L["Format Reward Title"] = "你將獲得「%s」頭銜。";
L["Format Reward Honor"] = "你將獲得 %d 點榮譽點數。";
L["Format Reward Talent Point"] = "你將獲得 %d 點天賦點數。";
L["Format Reward Talent Points"] = "你將獲得 %d 點天賦點數。";
L["Format Reward Arena"] = "你將獲得 %d 點競技場點數。";
L["Format Reward Experience"] = "你將獲得 %d 點經驗值%s。";
L["Format Of Your Level"] = "（你目前等級的 %d%%）";

-- Quest Item Display
L["Quest Item Display"] = "任務物品提示";
L["Quest Item Display Desc"] = "自動顯示任務物品的描述，並允許你在不打開背包的情況下直接使用它。";
L["Quest Item Display Hide Seen"] = "忽略已知物品";
L["Quest Item Display Hide Seen Desc"] = "忽略帳號內其他角色已經見過的物品。";
L["Quest Item Display Await World Map"] = "等待世界地圖";
L["Quest Item Display Await World Map Desc"] = "開啟世界地圖時，暫時隱藏正在顯示的任務物品說明並暫停自動關閉倒數計時。";
L["Quest Item Display Reset Position Desc"] = "重置視窗位置。";
L["Valuable Reward Popup"] = "珍貴獎勵彈窗（需要 Pawn）";
L["Valuable Reward Popup Sample"] = "珍貴獎勵彈窗";
L["Valuable Reward Popup Desc"] = "當任務獎勵了根據 Pawn 插件對你的角色是升級的物品時，顯示一個可直接裝備它的按鈕。\n\n戰鬥中該按鈕不可用。";
L["Item Equipped"] = "已裝備";
L["Press Key To Use Item"] = "按鍵使用物品";
L["Press Key To Use Item Desc Generic"] = "非戰鬥狀態下按下確認鍵（目前為：%s）使用物品。";
L["Press Key To Use Item Desc PC"] = "非戰鬥狀態下，按空白鍵即可使用該物品。";
L["Click To Read"] = "點擊以閱讀";
L["Begins A Quest"] = "開始一個任務";

-- Supported addons
L["Format Reward Title Row"] = "頭銜：%s";
L["On Your Gear List"] = "在你的裝備清單中";
L["Format Exchange It For"] = "可換取：%s";

-- Settings: Loot UI tab (Experimental) and the Loot UI window
L["Experimental"] = "實驗性";
L["Use Loot UI"] = "使用 Loot UI";
L["Use Loot UI Desc"] = "以 Loot UI 取代遊戲預設的拾取視窗。\n\nLoot UI 移植自正式服 Plumber 外掛中的 Loot UI。";
L["Loot UI Font Size Desc"] = "設定 Loot UI 的字體大小。它與「介面」分頁的字體大小互相獨立。\n\n預設：12";
L["Fade Out Delay Per Item"] = "每件物品的淡出延遲";
L["Fade Out Delay Per Item Desc"] = "Loot UI 視窗在基本時間之外，每顯示一件物品額外停留在畫面上的時間。數值越大，較長的清單可讀的時間越久。\n\n預設：0.25秒";
L["Items Per Page"] = "每頁物品數";
L["Items Per Page Desc"] = "設定 Loot UI 視窗在顯示你所獲得的物品時，每頁可容納的物品數量。其餘物品顯示在後續頁面。\n\n手動拾取時不受影響。\n\n預設：6";
L["Opacity"] = "不透明度";
L["Loot UI Opacity Desc"] = "設定 Loot UI 視窗在顯示你所獲得的物品時的背景不透明度。\n\n手動拾取時不受影響。\n\n預設：50%";
L["Show Number Of Owned Items"] = "顯示擁有的物品數量";
L["Show Number Of Owned Items Desc"] = "在 Loot UI 視窗中的物品圖示上顯示你擁有該物品的數量。數量包含銀行中的物品（銀行依你上次造訪時的狀態計算）。\n\n預設：開啟";
L["Fast Loot"] = "快速拾取";
L["Fast Loot Desc"] = "拾取視窗一開啟就立即拾取，而不是先等待片刻。僅在遊戲的自動拾取開啟或被 Loot UI 強制開啟時生效。\n\n來自 Plumber 外掛的快速拾取。";
L["Grow Upwards"] = "向上生長";
L["Grow Upwards On Desc"] = "勾選時：視窗左下角位置保持不變，新提示出現在舊提示的上方。";
L["Grow Upwards Off Desc"] = "未勾選時：視窗左上角位置保持不變，新提示出現在舊提示的下方。";
L["Combine Similar Items"] = "合併相似物品";
L["Combine Similar Items Desc"] = "在同一行顯示相似物品。\n\n支援的分類：\n\n- 垃圾物品\n\n預設：開啟";
L["Send to Back"] = "置於底層";
L["Send to Back Desc"] = "在 Loot UI 顯示你所獲得物品期間，將其視窗置於其他介面的後方。\n\n此選項不影響手動拾取時的視窗。\n\n預設：關閉";
L["Loot Under Mouse"] = "在滑鼠處開啟拾取視窗";
L["Loot Under Mouse Desc"] = "手動拾取時，拾取視窗會出現在目前滑鼠位置下方。\n\n此選項不影響視窗顯示你所獲得物品期間的位置。\n\n預設：關閉";
L["Press Key To Take All Items"] = "按鍵拾取全部物品";
L["Press Key To Take All Items Desc"] = "手動拾取時，按下以下按鍵即可拾取全部物品。拾取視窗開啟期間，該按鍵不會執行其他功能，即使它同時設定在動作列上。\n\n右鍵點擊按鍵可恢復為預設按鍵。\n\n預設：開啟";
L["Hide You Received Text"] = "隱藏「你獲得了」標題";
L["Hide You Received Text Desc"] = "在 Loot UI 視窗顯示你所獲得物品時，隱藏視窗上方的「你獲得了」標題。\n\n預設：關閉";
L["Show Reputation Changes"] = "顯示聲望變化";
L["Show Reputation Changes Desc"] = "在 Loot UI 視窗內顯示獲得的聲望。\n\n預設：關閉";
L["Show Any Money Changes"] = "顯示任何金錢變動";
L["Show Any Money Changes Desc"] = "顯示從所有來源（出售、任務、郵件等）獲得的金錢，而不僅限於從戰利品中拾取到的。\n\n預設：關閉";
L["Show Any Currency Changes"] = "顯示任何貨幣變動";
L["Show Any Currency Changes Desc"] = "顯示從所有來源獲得的榮譽點數、競技場點數和貨幣，而不僅限於從戰利品中拾取到的。只顯示獲得的數量。\n\n|cffff4800屬於物品的貨幣（如徽章）在拾取時會作為對應的物品顯示。|r\n\n預設：關閉";
L["You Received"] = "你獲得了";
L["Junk Items"] = "垃圾物品";
L["Take All"] = "全部拾取";
L["Give To"] = "交給";
