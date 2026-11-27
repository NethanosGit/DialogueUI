-- 简体中文. Strings come from the retail Dialogue UI locale where it has the same text, the rest are written for this port.
if not (GetLocale() == "zhCN") then return end;

local _, addon = ...;
local L = addon.L;

-- Blizzard's own global strings are used where they exist (they follow the client language). The text below is the fallback.

-- Footer buttons
L["Accept"] = ACCEPT or "接受";
L["Restart Quest"] = "重新开始";
L["Continue"] = CONTINUE or "继续";
L["Complete Quest"] = COMPLETE or "完成任务";
L["Incomplete"] = INCOMPLETE or "未完成";
L["Decline"] = DECLINE or "拒绝";
L["Cancel"] = CANCEL or "取消";
L["Goodbye"] = GOODBYE or "再见";

-- Settings window
L["UI"] = "界面";
L["Control"] = "控制";
L["Gameplay"] = "游戏功能";
L["Audio"] = "音频";
L["Minimap"] = "小地图";
L["Other Addons"] = "其他插件";

-- Settings: Audio tab
L["Enable Audio Fading"] = "启用音量淡化";
L["Enable Audio Fading Desc"] = "对话窗口或可阅读物品打开时降低游戏音量。关闭后，音量会逐渐恢复到游戏声音选项中设置的数值。";
L["Sound Fade Volume"] = "音效淡化音量";
L["Sound Fade Volume Desc"] = "阅读时音效逐渐降低到的音量。已经更低的音量不会被调高。";
L["Sound Fade Duration"] = "音效淡化时间";
L["Sound Fade Duration Desc"] = "音效降低以及恢复所需的时间。\n\n默认值：0.5s";
L["Music Fade Volume"] = "音乐淡化音量";
L["Music Fade Volume Desc"] = "阅读时音乐逐渐降低到的音量。已经更低的音量不会被调高。";
L["Music Fade Duration"] = "音乐淡化时间";
L["Music Fade Duration Desc"] = "音乐降低以及恢复所需的时间。\n\n默认值：0.5s";
L["Ambiance Fade Volume"] = "环境音淡化音量";
L["Ambiance Fade Volume Desc"] = "阅读时环境音逐渐降低到的音量。已经更低的音量不会被调高。";
L["Ambiance Fade Duration"] = "环境音淡化时间";
L["Ambiance Fade Duration Desc"] = "环境音降低以及恢复所需的时间。\n\n默认值：0.5s";
L["Audio Fade Music Spoken"] = "|cffff8040Spoken 通过音乐声道播放语音，因此音乐音量保持不变。|r";

-- Settings: Other Addons tab
L["Tooltip"] = "鼠标提示";
L["Auction House"] = "拍卖行";
L["Auction House Desc"] = "在物品的鼠标提示中加入来自另一个已安装插件的拍卖行价格。请在下方选择使用哪一个。";
L["Auction House Auctionator Desc"] = "Auctionator：显示物品的拍卖价格、中位价格和分解价值，与 Auctionator 自己的鼠标提示一致。显示的行遵循 Auctionator 自己的鼠标提示选项。";
L["Auction House RetailAH Desc"] = "Retail Auction House (mod-retail-ah)：显示服务器拍卖行机器人买家为该物品支付的价格（堆叠物品显示整堆总价），以及一次分解所得材料的平均价值，两者中较高的显示为绿色。\n\n已绑定的物品不显示任何内容，附魔技能不足时分解一行为灰色。服务器必须运行 mod-retail-ah 模块。";
L["Journal Gear Desc"] = "在对你的专精有提升的物品的鼠标提示中加入“在你的装备列表中”一行，来自 Journal: Gear Guide (JournalGearGuide) 插件。";
L["Addon Not Installed"] = "|cffff8040%s 未安装或未加载，因此此支持不会生效。|r 请安装后重新加载界面 (/reload)。";
L["Spoken Buttons"] = "Spoken 按钮";
L["Spoken Buttons Desc"] = "在任务与闲聊窗口和书籍视图中添加 Spoken 的播放和跳过按钮；DialogueUI 隐藏游戏界面时，这些窗口原本没有这些按钮。\n\n需要把几个文件复制到 Spoken 插件中。具体操作请见 DialogueUI 插件 README.md 中 Supported addons 下的 Spoken 条目。";
L["Spoken Bridge Missing"] = "|cffff8040桥接文件尚未放入 Spoken 文件夹。|r 具体操作请见 DialogueUI 插件 README.md 中 Supported addons 下的 Spoken 条目。";
L["AH Bot Buys"] = "拍卖行机器人收购";
L["AH Bot Disenchant"] = "分解（拍卖行机器人）";
L["AH Bot Disenchant Skill"] = "分解 |cff808080(附魔 %d)|r";
L["AH Bot BiS Bonus"] = "BiS 加成";

-- Settings: Compatibility
L["Compatibility"] = "兼容性";
L["Disable DUI In Instance"] = "在副本内使用游戏原始对话界面";
L["Disable DUI In Instance Desc"] = "当你进入地下城或团本时使用游戏原始对话界面。";

-- Settings: Minimap tab and minimap button
L["Show Minimap Button"] = "显示小地图按钮";
L["Show Minimap Button Desc"] = "在小地图旁显示一个按钮，点击可打开这些设置。拖动可沿小地图移动它。";
L["Minimap Button Tooltip"] = "点击打开设置。";
L["Minimap Button Drag"] = "拖动以移动";

-- Settings: UI tab
L["Theme"] = "主题";
L["Theme Desc"] = "选择一个主题色。";
L["Loot Theme Desc"] = "为拾取界面选择一个主题色。可以与其他界面的主题不同。";
L["Theme Brown"] = "棕色";
L["Theme Dark"] = "深色";
L["Frame Size"] = "界面大小";
L["Frame Size Desc"] = "设置对话界面的大小。\n\n默认：中";
L["Size Extra Small"] = "特小";
L["Size Small"] = "小";
L["Size Medium"] = "中";
L["Size Large"] = "大";
L["Size Very Large"] = "特大";
L["Size Extra Large"] = "超大";
L["Open Animation"] = "打开动画";
L["Open Animation Desc"] = "对话窗口打开所需的时间。0秒表示立即显示。\n\n默认：0.25秒";
L["Font Size"] = "字号";
L["Font Size Desc"] = "设置界面的字体大小。\n\n默认：12";
L["Font"] = "字体";
L["Font Desc"] = "选择界面使用的字体。\n\n默认字体：Friz Quadrata";
L["Default Font"] = "默认字体";
L["System Font"] = "系统";
L["Font Missing"] = "所选字体不可用，因此使用默认字体。";
L["Font No Shared Media"] = "安装 SharedMedia 或其他通过 LibSharedMedia-3.0 提供字体的插件，即可在此获得更多字体。";
L["Frame Orientation"] = "界面位置";
L["Frame Orientation Desc"] = "将界面放在屏幕左侧或右侧。\n\n选择“自定义”后，此窗口打开期间可将界面拖动到任意位置。\n\n默认：右侧";
L["Orientation Left"] = "左侧";
L["Orientation Right"] = "右侧";
L["Orientation Custom"] = "自定义";
L["Move Position"] = "移动";
L["Reset Position"] = "重置位置";
L["Move Position Desc"] = "显示界面，以便你将其拖动到新位置。";
L["Reset Position Desc"] = "重置界面位置。";
L["Readables Position"] = "位置";
L["Readables Position Desc"] = "将可阅读内容（书籍、信件、牌匾）放在屏幕左侧。\n\n选择“自定义”后，此窗口打开期间可将其拖动到任意位置。\n\n默认：默认";
L["Position Default"] = "默认";
L["Readables Move Position Desc"] = "显示一个示例，以便你将其拖动到新位置。";
L["Readables Reset Position Desc"] = "重置可阅读内容的位置。";
L["Hide UI"] = "隐藏界面";
L["Hide UI Desc"] = "与NPC交互时隐藏其他界面。";
L["Readables Hide UI Desc"] = "阅读书籍、信件或牌匾时隐藏其他界面。";
L["Show NPC Name On Page"] = "显示NPC名字";
L["Show NPC Name On Page Desc"] = "在页面上显示交互对象的名字。";
L["Show Quest Type"] = "显示任务类型";
L["Show Quest Type Desc"] = "在任务标题上方显示任务类型（任务、日常、每周、地下城等）。";
L["Show Copy Text Button"] = "显示复制文本按钮";
L["Show Copy Text Button Desc"] = "在对话界面右上角显示“复制文本”按钮。\n\n其中还包含游戏数据，如 NPC 和物品 ID（以及已在你任务日志中的任务 ID）。";
L["Copy Text"] = "复制文本";
L["Drag To Move"] = "左键点击并拖拽以移动该窗口。";
L["Edit Mode Title"] = "Dialogue UI";
L["Edit Mode Body"] = "将此窗口拖动到你想要的位置。关闭设置窗口即可将其隐藏。";

-- Quest types and tags
L["Quest"] = "任务";
L["Readables"] = "可阅读物品";
L["BookUI Frame Size Desc"] = "设置书籍界面的大小。\n\n默认：小";
L["BookUI Keep UI Open"] = "保持窗口打开";
L["BookUI Keep UI Open Desc"] = "离开该物体后保持窗口打开。\n\n按 Esc 或在界面上点击右键可将其关闭。";
L["BookUI Show Location"] = "显示地点";
L["BookUI Show Location Desc"] = "在标题中显示该物体的位置。\n\n仅适用于游戏对象，不适用于背包中的物品。";
L["BookUI Show Item Description"] = "显示物品描述";
L["BookUI Show Item Description Desc"] = "若物品有描述，则在书籍界面上方显示它。";
L["BookUI Darken Screen"] = "屏幕变暗";
L["BookUI Darken Screen Desc"] = "让界面后方区域变暗来帮助你将注意力集中在内容上。";

-- Settings: Control tab (retail enUS where it exists)
L["Input Device"] = "输入设备";
L["Input Device Desc"] = "此选项影响快捷键图标和界面布局。";
L["Input Device KBM"] = "键盘和鼠标";
L["Use Custom Bindings"] = "使用自定义按键";
L["Use Custom Bindings Desc"] = "勾选此选项以启用自定义按键。";
L["Primary Control Key Desc"] = "按下此按钮将自动选择第一个最佳选项，例如接受任务。";
L["Right Click To Close UI"] = "右键关闭界面";
L["Right Click To Close UI Desc"] = "在对话界面上按右键即可关闭窗口。";
L["Press Button To Scroll Down"] = "按确认键来向下滚屏";
L["Press Button To Scroll Down Desc"] = "如果当前页面盛不下所有任务文本，按下确认键会向下滚屏而不是接受任务。";
L["Press Escape To Decline Quest"] = "按Esc键拒绝任务";
L["Press Escape To Decline Quest Desc"] = "在你浏览任务详情时，如果该NPC还有其他对话选项，按Esc键会尝试返回上一级而不是直接关闭对话界面。";
L["Press Tab To Select Reward"] = "按Tab键选择任务奖励";
L["Press Tab To Select Reward Desc"] = "交付任务时，按 Tab 键在可选奖励之间循环切换。Shift+Tab 返回上一个。";
L["Keybinding Hint"] = "点击，然后按下你想使用的按键。\n右键点击：恢复默认按键。\nEsc：取消。";
L["Bound To"] = "绑定到：";
L["Not Bound"] = NOT_BOUND or "未绑定";
L["Action Confirm"] = "确认键";
L["Action Settings"] = "打开/关闭设置界面";
L["Action Option1"] = "对话选项 1";
L["Action Option2"] = "对话选项 2";
L["Action Option3"] = "对话选项 3";
L["Action Option4"] = "对话选项 4";
L["Action Option5"] = "对话选项 5";
L["Action Option6"] = "对话选项 6";
L["Action Option7"] = "对话选项 7";
L["Action Option8"] = "对话选项 8";
L["Action Option9"] = "对话选项 9";
L["Action Option Desc"] = "按下此键选择列表（任务和对话选项）中的第 %d 项。";
L["Action Settings Desc"] = "显示对话时，按下此键可打开或关闭设置窗口。";

L["Quest Frequency Daily"] = "日常";
L["Quest Frequency Weekly"] = "周常";
L["Quest Type Repeatable"] = "可重复";
L["Quest Difficulty VeryHard"] = "非常困难";
L["Quest Difficulty Hard"] = "困难";
L["Quest Difficulty Easy"] = "简单";
L["Quest Difficulty Trivial"] = "低等级";
L["Quest Difficulty Option"] = "任务难度";
L["Instant Quest Text"] = "即时显示文本";
L["Instant Quest Text Desc"] = "在任务页面和可阅读物品中直接显示文本，而不是渐显。使用与暴雪任务文本选项相同的游戏设置。";
L["Mark Highest Sell Price"] = "标记出最值钱的物品";
L["Mark Highest Sell Price Desc"] = "在你选择任务奖励时标记出卖店价格最高的物品。";
L["Show Replace Calculations"] = "显示替换计算";
L["Show Replace Calculations Desc"] = "在物品提示的“替换”下方显示属性差异。关闭后仅显示带有已装备物品名称的替换行。";
L["Use Blizzard Tooltip"] = "使用暴雪鼠标提示";
L["Use Blizzard Tooltip Desc"] = "使用暴雪自带的鼠标提示来显示任务奖励详情。";
L["Show EXP Bar"] = "经验条";
L["Show EXP Bar Desc"] = "对话打开时在屏幕底部显示经验条。";
L["Always Show EXP Bar"] = "始终显示经验条";
L["Always Show EXP Bar Desc"] = "没有打开对话时也在屏幕上保留经验条，以便将其用作你的经验条。";
L["Color Player Name"] = "玩家名字着色（仅深色模式）";
L["Color Player Name Desc"] = "在任务和对话文本中，以职业颜色显示你的角色名字。仅限深色主题。";
L["Color Class Name"] = "职业名称着色（仅深色模式）";
L["Color Class Name Desc"] = "在任务和对话文本中，以职业颜色显示你的职业名称。仅限深色主题。";
L["Format Unit Level"] = "等级 %d";
L["Format Player XP"] = "经验值：%d/%d (%d%%)";
L["Format Gained XP"] = "%d 经验值";
L["To Next Level Label"] = "距下一级";
L["Use Separate Tooltip for Comparison"] = "使用独立的对比鼠标提示";
L["Use Separate Tooltip for Comparison Desc"] = "在奖励提示旁的独立提示中显示将被替换的已装备物品，并在底部显示属性差异。戒指、饰品和武器会为每件已装备物品各显示一个提示。";
L["Use Separate Tooltip Blizzard Active"] = "开启“%s”时不可用。请先关闭该选项再使用本选项。";
L["Show Transmog Status"] = "显示未收集的外观";
L["Show Transmog Status Desc"] = "标记你尚未收集其幻化外观的奖励物品，并在其提示中添加一行。\n\n|cffff8040服务器必须安装幻化系统模块（mod-transmog）。|r 否则不会显示任何内容。\n\n插件会运行一次 .transmog sync 命令，并在聊天窗口中隐藏其输出。";
L["Use Transmog Plus"] = "使用 Mod Transmog Plus";
L["Use Transmog Plus Desc"] = "如果服务器运行的是 mod-transmog-plus 而不是原版 mod-transmog，请勾选此项。服务器将针对每件物品作答，只要有任何相同模型的物品已收集，就视为该外观已收集。\n\n使用原版 mod-transmog 时请不要勾选。";
L["Transmog Not Collected"] = "外观未收集";
L["Transmog Module Missing"] = "|cffff8040未检测到服务器的 %s 模块，因此此设置已禁用。|r";
L["Click To Copy To Clipboard"] = "点击复制到剪贴板";
L["Show Upgrade Arrow"] = "显示升级箭头（需要 Pawn 或 Journal: Gear Guide）";
L["Show Upgrade Arrow Desc"] = "根据 Pawn 插件，如果奖励物品对你的角色是升级，则在其上显示绿色箭头 %s：该物品在你至少一个 Pawn 评分方案中的得分高于该栏位已装备的物品。\n\n与你所装备的护甲类型不同的护甲（例如用布甲代替皮甲）永远不会被标记。\n\n安装了 Journal: Gear Guide 时，先由它的装备列表判断：列表中对你的专精有提升的物品会被标记。列表不认识的装备由 Pawn 判断。";
L["Show Upgrade Arrow Pawn Missing"] = "需要 Pawn 或 Journal: Gear Guide 插件（均未找到）。\n\n下载：|cff0000ee%s|r\n\n点击复制图标，按 Ctrl+C，然后将链接粘贴到浏览器中。";
L["Quest Difficulty Option Desc"] = "选择任务列表界面上任务难度的显示方式。";
L["QuestDifficultyStyle Off"] = "不显示";
L["QuestDifficultyStyle Off Desc"] = "任务等级和难度已被隐藏。";
L["QuestDifficultyStyle Level"] = "任务等级";
L["QuestDifficultyStyle Level Desc"] = "在任务名称的左侧显示任务等级。";
L["QuestDifficultyStyle Name"] = "难度名称";
L["QuestDifficultyStyle Both"] = "两者";
L["QuestDifficultyStyle Both Desc"] = "在任务标题左侧显示任务等级；如果任务等级超出推荐范围，则在任务按钮右侧显示难度名称。";
L["QuestDifficultyStyle Name Desc"] = "如果任务不在推荐等级范围内，在任务按钮的最右侧显示难度名称。\n（推荐范围为只比你角色高两级或只低两级）";
L["Quest Type Trivial"] = "低等级";
L["Quest Type Dungeon"] = "地下城任务";
L["Quest Type Raid"] = "团本任务";
L["Quest Type Heroic"] = "英雄";
L["Quest Type Elite"] = "精英";
L["Quest Type Group"] = "小队";
L["Quest Type PvP"] = "PvP";

-- Quest text
L["Quest Objectives"] = "任务目标";
L["Format Suggested Players"] = QUEST_SUGGESTED_GROUP_NUM or "建议玩家人数：[%d]";
L["Quest Accepted Alert"] = ERR_QUEST_ACCEPTED_S or "已接受任务：%s";

-- Rewards
L["Reward"] = "奖励";
L["Rewards"] = "奖励";
L["Reward Choose"] = REWARD_CHOOSE or "请选择你的奖励：";
L["Reward Choices"] = REWARD_CHOICES or "你可以从这些奖励中选择一件：";
L["Reward Items"] = REWARD_ITEMS or "你还将获得：";
L["Requirements"] = "所需条件";
L["Money"] = MONEY or "金钱";
L["Honor Points"] = "荣誉";
L["Arena Points"] = "竞技场点数";
L["Talent Points"] = "天赋点数";
L["Experience"] = "经验值";
L["Title"] = "头衔";
L["Format Talent Point Row"] = "+%d 点天赋点数";
L["Format Talent Points Row"] = "+%d 点天赋点数";

-- Reward tooltip
L["Show Comparison"] = "显示物品对比";
L["Hide Comparison"] = "隐藏物品对比";
L["Sell Price"] = SELL_PRICE or "出售价格";
L["Format Item Level"] = ITEM_LEVEL or "物品等级 %d";
L["Format You Have"] = "- 你拥有 |cffffffff%d|r";
L["Format In Bank"] = "（银行中有 |cffffffff%d|r）";
L["Format Replace Item"] = "替换 %s";
L["Equipped Item"] = "已装备的物品";
L["Currently Equipped"] = "当前装备";
L["Different Item Type"] = "与已装备的物品类型不同。";
L["Identical Stats"] = "属性相同";
L["Format Reward Title"] = "你将获得“%s”头衔。";
L["Format Reward Honor"] = "你将获得 %d 点荣誉点数。";
L["Format Reward Talent Point"] = "你将获得 %d 点天赋点数。";
L["Format Reward Talent Points"] = "你将获得 %d 点天赋点数。";
L["Format Reward Arena"] = "你将获得 %d 点竞技场点数。";
L["Format Reward Experience"] = "你将获得 %d 点经验值%s。";
L["Format Of Your Level"] = "（你当前等级的 %d%%）";

-- Quest Item Display
L["Quest Item Display"] = "任务物品说明";
L["Quest Item Display Desc"] = "自动显示任务物品上的说明，并且允许你在不打开背包的情况下就能使用它。";
L["Quest Item Display Hide Seen"] = "忽略见过的物品";
L["Quest Item Display Hide Seen Desc"] = "忽略你账号上角色见过的物品。";
L["Quest Item Display Await World Map"] = " 等待世界地图";
L["Quest Item Display Await World Map Desc"] = "当你打开世界地图时，将正在显示的任务物品说明隐藏并暂停自动关闭倒计时。";
L["Quest Item Display Reset Position Desc"] = "重置窗口位置。";
L["Valuable Reward Popup"] = "珍贵奖励弹窗（需要 Pawn 或 Journal: Gear Guide）";
L["Valuable Reward Popup Sample"] = "珍贵奖励弹窗";
L["Valuable Reward Popup Desc"] = "当任务奖励了根据 Pawn 插件对你的角色是升级的物品时，显示一个可直接装备它的按钮。\n\n战斗中该按钮不可用。\n\n安装了 Journal: Gear Guide 时，先由它的装备列表判断：列表中对你的专精有提升的物品会被标记。列表不认识的装备由 Pawn 判断。";
L["Item Equipped"] = "已装备";
L["Press Key To Use Item"] = "按键使用物品";
L["Press Key To Use Item Desc Generic"] = "非战斗时按确认键（当前为：%s）使用物品。";
L["Press Key To Use Item Desc PC"] = "非战斗状态下，按空格键即可使用该物品。";
L["Click To Read"] = "左键点击阅读";
L["Begins A Quest"] = "开始一个任务";

-- Supported addons
L["Format Reward Title Row"] = "头衔：%s";
L["On Your Gear List"] = "在你的装备清单中";
L["Format Exchange It For"] = "可换取：%s";

-- Settings: Loot UI tab (Experimental) and the Loot UI window
L["Experimental"] = "实验性";
L["Use Loot UI"] = "使用 Loot UI";
L["Use Loot UI Desc"] = "用 Loot UI 替换游戏默认的拾取窗口。\n\nLoot UI 移植自正式服 Plumber 插件中的 Loot UI。";
L["Loot UI Font Size Desc"] = "设置 Loot UI 的字体大小。它与“界面”标签页的字体大小相互独立。\n\n默认：12";
L["Fade Out Delay Per Item"] = "每件物品的淡出延迟";
L["Fade Out Delay Per Item Desc"] = "Loot UI 窗口在基础时间之外，每显示一件物品额外停留在屏幕上的时间。数值越大，较长的列表可读的时间越久。\n\n默认：0.25秒";
L["Items Per Page"] = "每页物品数";
L["Items Per Page Desc"] = "设置 Loot UI 窗口在显示你所获得的物品时，每页可容纳的物品数量。其余物品显示在后续页面。\n\n手动拾取时不受影响。\n\n默认：6";
L["Opacity"] = "不透明度";
L["Loot UI Opacity Desc"] = "设置 Loot UI 窗口在显示你所获得的物品时的背景不透明度。\n\n手动拾取时不受影响。\n\n默认：50%";
L["Show Number Of Owned Items"] = "显示拥有的物品数量";
L["Show Number Of Owned Items Desc"] = "在 Loot UI 窗口中的物品图标上显示你拥有该物品的数量。数量包含银行中的物品（银行按你上次访问时的状态计算）。\n\n默认：开启";
L["Fast Loot"] = "快速拾取";
L["Fast Loot Desc"] = "拾取窗口一打开就立即拾取，而不是先等待片刻。仅在游戏的自动拾取开启或被 Loot UI 强制开启时生效。\n\n来自 Plumber 插件的快速拾取。";
L["Grow Upwards"] = "向上生长";
L["Grow Upwards On Desc"] = "勾选时：窗口左下角位置保持不变，新提示出现在旧提示的上方。";
L["Grow Upwards Off Desc"] = "未勾选时：窗口左上角位置保持不变，新提示出现在旧提示的下方。";
L["Combine Similar Items"] = "合并相似物品";
L["Combine Similar Items Desc"] = "在同一行显示相似物品。\n\n支持的分类：\n\n- 垃圾物品\n\n默认：开启";
L["Send to Back"] = "置于底层";
L["Send to Back Desc"] = "在 Loot UI 显示你所获得物品期间，将其窗口置于其他界面的后方。\n\n此选项不影响手动拾取时的窗口。\n\n默认：关闭";
L["Loot Under Mouse"] = "在鼠标处打开拾取窗口";
L["Loot Under Mouse Desc"] = "手动拾取时，拾取窗口会出现在当前鼠标位置下方。\n\n此选项不影响窗口显示你所获得物品期间的位置。\n\n默认：关闭";
L["Press Key To Take All Items"] = "按键拾取全部物品";
L["Press Key To Take All Items Desc"] = "手动拾取时，按下以下按键即可拾取全部物品。拾取窗口打开期间，该按键不会执行其他功能，即使它同时设置在动作条上。\n\n右键点击按键可恢复为默认按键。\n\n默认：开启";
L["Hide You Received Text"] = "隐藏“你获得了”标题";
L["Hide You Received Text Desc"] = "在 Loot UI 窗口显示你所获得物品时，隐藏窗口上方的“你获得了”标题。\n\n默认：关闭";
L["Show Reputation Changes"] = "显示声望变化";
L["Show Reputation Changes Desc"] = "在 Loot UI 窗口内显示获得的声望。\n\n默认：关闭";
L["Show Any Money Changes"] = "显示任何金钱变动";
L["Show Any Money Changes Desc"] = "显示从所有来源（出售、任务、邮件等）获得的金钱，而不仅限于从战利品中拾取到的。\n\n默认：关闭";
L["Show Any Currency Changes"] = "显示任何货币变动";
L["Show Any Currency Changes Desc"] = "显示从所有来源获得的荣誉点数、竞技场点数和货币，而不仅限于从战利品中拾取到的。只显示获得的数量。\n\n|cffff4800属于物品的货币（如徽章）在拾取时会作为对应的物品显示。|r\n\n默认：关闭";
L["You Received"] = "你获得了";
L["Junk Items"] = "垃圾物品";
L["Take All"] = "全部拾取";
L["Give To"] = "交给";
