-- Deutsch. Strings come from the retail Dialogue UI locale where it has the same text, the rest are written for this port.
if not (GetLocale() == "deDE") then return end;

local _, addon = ...;
local L = addon.L;

-- Blizzard's own global strings are used where they exist (they follow the client language). The text below is the fallback.

-- Footer buttons
L["Accept"] = ACCEPT or "Akzeptieren";
L["Restart Quest"] = "Neustart";
L["Continue"] = CONTINUE or "Weiter";
L["Complete Quest"] = COMPLETE or "Quest abschließen";
L["Incomplete"] = INCOMPLETE or "Unvollständig";
L["Decline"] = DECLINE or "Ablehnen";
L["Cancel"] = CANCEL or "Abbrechen";
L["Goodbye"] = GOODBYE or "Auf Wiedersehen";

-- Settings window
L["UI"] = "Benutzerinterface";
L["Control"] = "Steuerung";
L["Gameplay"] = "Gameplay";
L["Audio"] = "Audio";
L["Minimap"] = "Minikarte";
L["Other Addons"] = "Andere Addons";

-- Settings: Audio tab
L["Enable Audio Fading"] = "Audioabblendung aktivieren";
L["Enable Audio Fading Desc"] = "Senkt die Lautstärken des Spiels, solange das Dialogfenster oder ein lesbarer Text geöffnet ist. Beim Schließen werden sie wieder auf die in den Audiooptionen des Spiels eingestellten Lautstärken eingeblendet.";
L["Sound Fade Volume"] = "Effektlautstärke beim Lesen";
L["Sound Fade Volume Desc"] = "Die Lautstärke der Soundeffekte, auf die beim Lesen abgeblendet wird. Eine bereits niedrigere Lautstärke wird nicht angehoben.";
L["Sound Fade Duration"] = "Effekt-Überblenddauer";
L["Sound Fade Duration Desc"] = "Wie lange die Soundeffekte zum Abblenden und wieder Einblenden brauchen.\n\nStandard: 0,5s";
L["Music Fade Volume"] = "Musiklautstärke beim Lesen";
L["Music Fade Volume Desc"] = "Die Musiklautstärke, auf die beim Lesen abgeblendet wird. Eine bereits niedrigere Lautstärke wird nicht angehoben.";
L["Music Fade Duration"] = "Musik-Überblenddauer";
L["Music Fade Duration Desc"] = "Wie lange die Musik zum Abblenden und wieder Einblenden braucht.\n\nStandard: 0,5s";
L["Ambiance Fade Volume"] = "Umgebungslautstärke beim Lesen";
L["Ambiance Fade Volume Desc"] = "Die Lautstärke der Umgebungsgeräusche, auf die beim Lesen abgeblendet wird. Eine bereits niedrigere Lautstärke wird nicht angehoben.";
L["Ambiance Fade Duration"] = "Umgebungs-Überblenddauer";
L["Ambiance Fade Duration Desc"] = "Wie lange die Umgebungsgeräusche zum Abblenden und wieder Einblenden brauchen.\n\nStandard: 0,5s";
L["Audio Fade Music Spoken"] = "|cffff8040Spoken spielt seine Stimmen über den Musikkanal ab, daher bleibt die Musiklautstärke unverändert.|r";

-- Settings: Other Addons tab
L["Tooltip"] = "Tooltip";
L["Auction House"] = "Auktionshaus";
L["Auction House Desc"] = "Fügt dem Gegenstands-Tooltip Auktionshauspreise eines anderen installierten Addons hinzu. Wähle unten, welches.";
L["Auction House Auctionator Desc"] = "Auctionator: Auktionspreis, Medianpreis und Entzauberungswert des Gegenstands, wie Auctionator sie in seinen eigenen Tooltips zeigt. Die Zeilen folgen den Tooltip-Optionen von Auctionator.";
L["Auction House RetailAH Desc"] = "Retail Auction House (mod-retail-ah): Was der AH-Bot-Käufer des Servers für den Gegenstand zahlt (bei einem Stapel die Summe des Stapels) und der durchschnittliche Wert der Materialien einer Entzauberung. Das bessere von beiden ist grün.\n\nFür seelengebundene Gegenstände wird nichts angezeigt, und die Entzauberungszeile ist grau, wenn deine Verzauberkunst zu niedrig ist. Der Server muss das Modul mod-retail-ah ausführen.";
L["Journal Gear Desc"] = "Fügt dem Tooltip von Gegenständen, die für deine Spezialisierung eine Verbesserung sind, die Zeile „Auf deiner Ausrüstungsliste“ hinzu, vom Addon Journal: Gear (JournalGearBIS).";
L["Addon Not Installed"] = "|cffff8040%s ist nicht installiert oder nicht geladen, daher funktioniert diese Unterstützung nicht.|r Installiere es und lade die Oberfläche neu (/reload).";
L["Spoken Buttons"] = "Spoken-Schaltflächen";
L["Spoken Buttons Desc"] = "Fügt die Schaltflächen „Abspielen“ und „Überspringen“ von Spoken dem Quest- und Gesprächsfenster sowie der Buchansicht hinzu, die sonst keine hätten, solange DialogueUI die Spieloberfläche ausblendet.\n\nDafür müssen einige Dateien in die Spoken-Addons kopiert werden. Was zu tun ist, steht im Eintrag zu Spoken unter Supported addons in der README.md des DialogueUI-Addons.";
L["Spoken Bridge Missing"] = "|cffff8040Die Brückendatei ist noch nicht im Spoken-Ordner.|r Was zu tun ist, steht im Eintrag zu Spoken unter Supported addons in der README.md des DialogueUI-Addons.";
L["AH Bot Buys"] = "AH-Bot kauft";
L["AH Bot Disenchant"] = "Entzaubern (AH-Bot)";
L["AH Bot Disenchant Skill"] = "Entzaubern |cff808080(Verzauberkunst %d)|r";
L["AH Bot BiS Bonus"] = "BiS-Bonus";

-- Settings: Compatibility
L["Compatibility"] = "Kompatibilität";
L["Disable DUI In Instance"] = "Standardfenster in Instanzen";
L["Disable DUI In Instance Desc"] = "In Dungeons und Schlachtzügen wird das Standard-Dialogfenster anstatt das von Dialogue UI verwendet.";

-- Settings: Minimap tab and minimap button
L["Show Minimap Button"] = "Minikarten-Schaltfläche anzeigen";
L["Show Minimap Button Desc"] = "Zeigt eine Schaltfläche an der Minikarte, die diese Einstellungen öffnet. Ziehen, um sie um die Minikarte zu bewegen.";
L["Minimap Button Tooltip"] = "Klicken, um die Einstellungen zu öffnen.";
L["Minimap Button Drag"] = "Ziehen zum Verschieben";

-- Settings: UI tab
L["Theme"] = "Farbschema";
L["Theme Desc"] = "Ändert das Farbschema des Addons.";
L["Loot Theme Desc"] = "Ändert das Farbschema des Loot-Fensters. Es kann vom Farbschema der restlichen Oberfläche abweichen.";
L["Theme Brown"] = "Braun";
L["Theme Dark"] = "Schwarz";
L["Frame Size"] = "Fenstergröße";
L["Frame Size Desc"] = "Legt die Größe der Dialogoberfläche fest.\n\nStandard: Mittel";
L["Size Extra Small"] = "Sehr klein";
L["Size Small"] = "Klein";
L["Size Medium"] = "Mittelgroß";
L["Size Large"] = "Sehr groß";
L["Size Very Large"] = "Riesig";
L["Size Extra Large"] = "Gigantisch";
L["Open Animation"] = "Öffnungsanimation";
L["Open Animation Desc"] = "Wie lange das Dialogfenster zum Öffnen braucht. 0s zeigt es sofort an.\n\nStandard: 0,25s";
L["Font Size"] = "Schriftgröße";
L["Font Size Desc"] = "Ändert die Schriftgröße des Addons.\n\nStandard: 12";
L["Font"] = "Schriftart";
L["Font Desc"] = "Wähle die Schriftart der Oberfläche.\n\nStandardschrift: Friz Quadrata";
L["Default Font"] = "Standardschrift";
L["System Font"] = "System";
L["Font Missing"] = "Die gewählte Schriftart ist nicht verfügbar, daher wird die Standardschrift verwendet.";
L["Font No Shared Media"] = "Installiere SharedMedia oder ein anderes Addon, das Schriftarten über LibSharedMedia-3.0 bereitstellt, um hier weitere Schriftarten zu erhalten.";
L["Frame Orientation"] = "Positionierung";
L["Frame Orientation Desc"] = "Platziere die Oberfläche links oder rechts auf dem Bildschirm.\n\nMit „Benutzerdefiniert“ kannst du die Oberfläche beliebig ziehen, solange dieses Fenster geöffnet ist.\n\nStandard: Rechts";
L["Orientation Left"] = "Links";
L["Orientation Right"] = "Rechts";
L["Orientation Custom"] = "Benutzerdefiniert";
L["Move Position"] = "Verschieben";
L["Reset Position"] = "Zurücksetzen";
L["Move Position Desc"] = "Zeigt die Oberfläche an, damit du sie an eine neue Position ziehen kannst.";
L["Reset Position Desc"] = "Setzt die Position der Oberfläche zurück.";
L["Readables Position"] = "Position";
L["Readables Position Desc"] = "Platziere Lesbares (Bücher, Briefe, Tafeln) am linken Bildschirmrand.\n\nMit „Benutzerdefiniert“ kannst du es beliebig ziehen, solange dieses Fenster geöffnet ist.\n\nStandard: Standard";
L["Position Default"] = "Standard";
L["Readables Move Position Desc"] = "Zeigt ein Beispiel, das du an eine neue Position ziehen kannst.";
L["Readables Reset Position Desc"] = "Setzt die Position des Lesetexts zurück.";
L["Hide UI"] = "Benutzerinterface ausblenden";
L["Hide UI Desc"] = "Das komplette Benutzerinterface (außer dem Dialogfenster) wird ausgeblendet, wenn man einen NPC anspricht.";
L["Readables Hide UI Desc"] = "Das komplette Benutzerinterface (außer dem Lesefenster) wird ausgeblendet, solange du ein Buch, einen Brief oder eine Tafel liest.";
L["Show NPC Name On Page"] = "NPC-Namen anzeigen";
L["Show NPC Name On Page Desc"] = "Zeigt den Namen des NPCs im Dialogtext an.";
L["Show Quest Type"] = "Questtyp anzeigen";
L["Show Quest Type Desc"] = "Zeigt den Questtyp (Quest, Täglich, Wöchentlich, Dungeon, ...) über dem Questtitel an.";
L["Show Copy Text Button"] = "\"Text kopieren\" Symbol anzeigen";
L["Show Copy Text Button Desc"] = "Zeigt oben rechts in der Dialogoberfläche eine Schaltfläche „Text kopieren“ an.\n\nSie enthält auch Spieldaten wie NPC- und Gegenstands-IDs (und Quest-IDs von Quests, die sich bereits in deinem Questlog befinden).";
L["Copy Text"] = "Text kopieren";
L["Drag To Move"] = "Verschiebt das Fenster mit einem Linksklick.";
L["Edit Mode Title"] = "Dialogue UI";
L["Edit Mode Body"] = "Ziehe dieses Fenster an die gewünschte Stelle. Schließe das Einstellungsfenster, um es auszublenden.";

-- Quest types and tags
L["Quest"] = "Quest";
L["Readables"] = "Dokumente";
L["BookUI Frame Size Desc"] = "Legt die Größe der Buchoberfläche fest.\n\nStandard: Klein";
L["BookUI Keep UI Open"] = "Fenster nicht ausblenden";
L["BookUI Keep UI Open Desc"] = "Das Fenster wird nicht ausgeblendet, wenn man sich vom Dokument entfernt.\n\nDas Fenster kann über die ESC-Taste oder einem Rechtsklick ausgeblendet werden.";
L["BookUI Show Location"] = "Standort anzeigen";
L["BookUI Show Location Desc"] = "Der momentane Standort, sowie Koordinaten des angeklickten Dokuments, werden oberhalb des Titels angezeigt.\n\nDies gilt nicht für Dokumente in Eurem Inventar.";
L["BookUI Show Item Description"] = "Beschreibung anzeigen";
L["BookUI Show Item Description Desc"] = "Falls der Gegenstand eine zusätzliche Beschreibung in deren Tooltip vorweist, wird diese im Dialogfenster zusätzlich zum Haupttext oben angezeigt.";
L["BookUI Darken Screen"] = "Besserer Kontrast";
L["BookUI Darken Screen Desc"] = "Zeigt einen Halbschatten hinter dem Dialogfenster an, wenn Ihr euch Dokumente anschaut.";

-- Settings: Control tab (retail enUS where it exists)
L["Input Device"] = "Eingabegerät";
L["Input Device Desc"] = "Dies beeinflusst die Tastenkombinationen sowie das Benutzerinterface.";
L["Input Device KBM"] = "Tastatur & Maus";
L["Use Custom Bindings"] = "Benutzerdefinierte Tastenkürzel verwenden";
L["Use Custom Bindings Desc"] = "Aktiviert diese Funktion, um Eure eigenen Tastenkürzel zu verwenden.";
L["Primary Control Key Desc"] = "Verwendet dieses Tastenkürzel, um die erste Option wie z.B. \"Quest akzeptieren\" auszuwählen.";
L["Right Click To Close UI"] = "Rechtsklick, um das Menü auszublenden";
L["Right Click To Close UI Desc"] = "Ein Rechtsklick innerhalb des Dialogfensters wird dasselbige ausblenden.";
L["Press Button To Scroll Down"] = "Bestätigungstaste zum Herunterscrollen";
L["Press Button To Scroll Down Desc"] = "Wenn der Textinhalt zu groß für das Dialogfenster ist, wird durch das Drücken der Bestätigungstaste der Text nach unten gescrollt, anstatt die Quest zu akzeptieren.";
L["Press Escape To Decline Quest"] = "ESC-Taste, um eine Quest abzubrechen";
L["Press Escape To Decline Quest Desc"] = "Wenn man eine Dialogoption ausgewählt hat, bring Euch die ESC-Taste zurück zur Startseite anstatt das Dialogfenster zu schließen.";
L["Press Tab To Select Reward"] = "Tabulatortaste, um die Belohnung auszuwählen";
L["Press Tab To Select Reward Desc"] = "Drücke die Tabulatortaste, um beim Abgeben der Quest durch die wählbaren Belohnungen zu wechseln. Umschalt+Tab geht zurück.";
L["Keybinding Hint"] = "Klicken und dann die gewünschte Taste drücken.\nRechtsklick: zurück zur Standardtaste.\nEsc: abbrechen.";
L["Bound To"] = "Wird verwendet von: ";
L["Not Bound"] = NOT_BOUND or "Nicht belegt";
L["Action Confirm"] = "Bestätigen";
L["Action Settings"] = "Optionsmenü";
L["Action Option1"] = "Option 1";
L["Action Option2"] = "Option 2";
L["Action Option3"] = "Option 3";
L["Action Option4"] = "Option 4";
L["Action Option5"] = "Option 5";
L["Action Option6"] = "Option 6";
L["Action Option7"] = "Option 7";
L["Action Option8"] = "Option 8";
L["Action Option9"] = "Option 9";
L["Action Option Desc"] = "Drücke diese Taste, um Option %d der Liste (Quests und Gesprächsoptionen) auszuwählen.";
L["Action Settings Desc"] = "Drücke diese Taste, um das Einstellungsfenster zu öffnen oder zu schließen, solange der Dialog angezeigt wird.";

L["Quest Frequency Daily"] = "Täglich";
L["Quest Frequency Weekly"] = "Wöchentlich";
L["Quest Type Repeatable"] = "Wiederholbar";
L["Quest Difficulty VeryHard"] = "Sehr schwer";
L["Quest Difficulty Hard"] = "Schwer";
L["Quest Difficulty Easy"] = "Leicht";
L["Quest Difficulty Trivial"] = "Niedrige Stufe";
L["Quest Difficulty Option"] = "Questschwierigkeit";
L["Instant Quest Text"] = "Text sofort anzeigen";
L["Instant Quest Text Desc"] = "Zeigt den Text auf Quest-Seiten und in Dokumenten sofort an, statt ihn einzublenden. Dies nutzt dieselbe Spieleinstellung wie die Questtext-Option von Blizzard.";
L["Mark Highest Sell Price"] = "Höchsten Verkaufspreis anzeigen";
L["Mark Highest Sell Price Desc"] = "Bei der Auswahl einer Questbelohnung wird der Gegenstand mit dem höchsten Verkaufspreis hervorgehoben.";
L["Show Replace Calculations"] = "Berechnungen beim Ersetzen anzeigen";
L["Show Replace Calculations Desc"] = "Zeigt die Wertunterschiede unter \"Ersetze\" im Gegenstands-Tooltip. Wenn deaktiviert, wird nur die Zeile \"Ersetze\" mit dem Namen des angelegten Gegenstands angezeigt.";
L["Use Blizzard Tooltip"] = "Blizzard-Tooltips verwenden";
L["Use Blizzard Tooltip Desc"] = "Wenn man einen Gegenstand in Dialogfenster mit der Maus inspiziert, wird der Tooltip-Stil von Blizzard anstatt dem vom Dialogue UI verwendet.";
L["Show EXP Bar"] = "Erfahrungsleiste";
L["Show EXP Bar Desc"] = "Zeigt eine Erfahrungsleiste am unteren Bildschirmrand an, solange ein Gespräch geöffnet ist.";
L["Always Show EXP Bar"] = "Erfahrungsleiste immer anzeigen";
L["Always Show EXP Bar Desc"] = "Lässt die Erfahrungsleiste auch ohne geöffnetes Gespräch auf dem Bildschirm, damit sie als deine Erfahrungsleiste dienen kann.";
L["Color Player Name"] = "Spielernamen einfärben (nur Dunkelmodus)";
L["Color Player Name Desc"] = "Zeigt den Namen deines Charakters im Quest- und Gesprächstext in deiner Klassenfarbe an. Nur im dunklen Design.";
L["Color Class Name"] = "Klassennamen einfärben (nur Dunkelmodus)";
L["Color Class Name Desc"] = "Zeigt den Namen deiner Klasse im Quest- und Gesprächstext in deiner Klassenfarbe an. Nur im dunklen Design.";
L["Format Unit Level"] = "Stufe %d";
L["Format Player XP"] = "EP: %d/%d (%d%%)";
L["Format Gained XP"] = "%d EP";
L["To Next Level Label"] = "Bis zur nächsten Stufe";
L["Use Separate Tooltip for Comparison"] = "Separaten Tooltip für Vergleich verwenden";
L["Use Separate Tooltip for Comparison Desc"] = "Zeigt den angelegten Gegenstand, den du ersetzen würdest, in einem eigenen Tooltip neben dem Belohnungs-Tooltip an, mit den Unterschieden der Werte am Ende. Bei Ringen, Schmuckstücken und Waffen erscheint je ein Tooltip pro angelegtem Gegenstand.";
L["Use Separate Tooltip Blizzard Active"] = "Nicht verfügbar, solange \"%s\" aktiv ist. Deaktiviere diese Option, um sie zu verwenden.";
L["Show Transmog Status"] = "Nicht gesammelte Erscheinungsbilder anzeigen";
L["Show Transmog Status Desc"] = "Markiert Belohnungsgegenstände, deren Transmog-Erscheinungsbild du noch nicht gesammelt hast, und fügt ihrem Tooltip eine Zeile hinzu.\n\n|cffff8040Auf dem Server muss das Transmog-System-Modul (mod-transmog) installiert sein.|r Ohne dieses wird nichts angezeigt.\n\nDas Addon führt den Befehl .transmog sync einmal aus und blendet dessen Ausgabe im Chatfenster aus.";
L["Use Transmog Plus"] = "Mod Transmog Plus verwenden";
L["Use Transmog Plus Desc"] = "Aktiviere dies, wenn der Server mod-transmog-plus statt des originalen mod-transmog verwendet. Der Server antwortet dann für jeden Gegenstand und wertet ein Erscheinungsbild als gesammelt, wenn ein beliebiger Gegenstand mit demselben Modell gesammelt wurde.\n\nFür das originale mod-transmog deaktiviert lassen.";
L["Transmog Not Collected"] = "Erscheinungsbild nicht gesammelt";
L["Transmog Module Missing"] = "|cffff8040Das Servermodul %s wurde nicht erkannt, daher ist diese Einstellung deaktiviert.|r";
L["Click To Copy To Clipboard"] = "Klicken, um in die Zwischenablage zu kopieren";
L["Show Upgrade Arrow"] = "Verbesserungspfeil anzeigen (Pawn erforderlich)";
L["Show Upgrade Arrow Desc"] = "Zeigt einen grünen Pfeil %s bei einem Belohnungsgegenstand, wenn er laut dem Addon Pawn eine Verbesserung für deinen Charakter ist: Der Gegenstand erreicht in mindestens einer deiner Pawn-Skalen einen höheren Wert als der, den du in diesem Platz trägst.\n\nRüstung eines anderen Typs als der getragenen (zum Beispiel Stoff statt Leder) wird nie markiert.";
L["Show Upgrade Arrow Pawn Missing"] = "Erfordert das Addon Pawn (nicht gefunden).\n\nDownload: |cff0000ee%s|r\n\nKlicke auf das Kopiersymbol, drücke Strg+C und füge den Link in deinen Browser ein.";
L["Quest Difficulty Option Desc"] = "Wähle, wie die Questschwierigkeit angezeigt wird, wenn dir der NPC eine Liste von Quests anbietet.";
L["QuestDifficultyStyle Off"] = "AUS";
L["QuestDifficultyStyle Off Desc"] = "Queststufe und Schwierigkeit sind jetzt ausgeblendet.";
L["QuestDifficultyStyle Level"] = "Stufe";
L["QuestDifficultyStyle Level Desc"] = "Zeigt die Queststufe links vom Questtitel an.";
L["QuestDifficultyStyle Name"] = "Name";
L["QuestDifficultyStyle Both"] = "Beides";
L["QuestDifficultyStyle Both Desc"] = "Zeigt die Queststufe links vom Questtitel und den Namen der Schwierigkeit rechts der Quest-Schaltfläche an, wenn die Queststufe außerhalb des empfohlenen Bereichs liegt.";
L["QuestDifficultyStyle Name Desc"] = "Zeigt den Namen der Schwierigkeit rechts der Quest-Schaltfläche an, wenn die Queststufe außerhalb des empfohlenen Bereichs liegt.\n(Die Queststufe liegt 3 Stufen über oder unter deiner Charakterstufe.)";
L["Quest Type Trivial"] = "Trivial";
L["Quest Type Dungeon"] = "Dungeon";
L["Quest Type Raid"] = "Schlachtzug";
L["Quest Type Heroic"] = "Heroisch";
L["Quest Type Elite"] = "Elite";
L["Quest Type Group"] = "Gruppe";
L["Quest Type PvP"] = "PvP";

-- Quest text
L["Quest Objectives"] = "Ziele";
L["Format Suggested Players"] = QUEST_SUGGESTED_GROUP_NUM or "Empfohlene Spieler [%d]";
L["Quest Accepted Alert"] = ERR_QUEST_ACCEPTED_S or "Quest angenommen: %s";

-- Rewards
L["Reward"] = "Belohnung";
L["Rewards"] = "Belohnungen";
L["Reward Choose"] = REWARD_CHOOSE or "Wählt Eure Belohnung:";
L["Reward Choices"] = REWARD_CHOICES or "Ihr könnt eine dieser Belohnungen wählen:";
L["Reward Items"] = REWARD_ITEMS or "Ihr erhaltet außerdem:";
L["Requirements"] = "Anforderungen";
L["Money"] = MONEY or "Geld";
L["Honor Points"] = "Ehrenpunkte";
L["Arena Points"] = "Arenapunkte";
L["Talent Points"] = "Talentpunkte";
L["Experience"] = "Erfahrung";
L["Title"] = "Titel";
L["Format Talent Point Row"] = "+%d Talentpunkt";
L["Format Talent Points Row"] = "+%d Talentpunkte";

-- Reward tooltip
L["Show Comparison"] = "Vergleich anzeigen";
L["Hide Comparison"] = "Vergleich ausblenden";
L["Sell Price"] = SELL_PRICE or "Verkaufspreis";
L["Format Item Level"] = ITEM_LEVEL or "Gegenstandsstufe %d";
L["Format You Have"] = "- Du besitzt |cffffffff%d|r";
L["Format In Bank"] = " (|cffffffff%d|r in der Bank)";
L["Format Replace Item"] = "Ersetze %s";
L["Equipped Item"] = "angelegter Gegenstand";
L["Currently Equipped"] = "Derzeit angelegt";
L["Different Item Type"] = "Anderer Gegenstandstyp als der angelegte.";
L["Identical Stats"] = "Identische Werte";
L["Format Reward Title"] = "Dir wird der Titel „%s“ verliehen.";
L["Format Reward Honor"] = "Du erhältst %d Ehrenpunkte.";
L["Format Reward Talent Point"] = "Du erhältst %d Talentpunkt.";
L["Format Reward Talent Points"] = "Du erhältst %d Talentpunkte.";
L["Format Reward Arena"] = "Du erhältst %d Arenapunkte.";
L["Format Reward Experience"] = "Du erhältst %d Erfahrung%s.";
L["Format Of Your Level"] = " (%d%% deiner Stufe)";

-- Quest Item Display
L["Quest Item Display"] = "Questgegenstand anzeigen";
L["Quest Item Display Desc"] = "Zeigt die Beschreibung eines Quest-Gegenstandes an. Man kann außerdem den Gegenstand benutzen, ohne dafür das Inventarfenster zu öffnen.";
L["Quest Item Display Hide Seen"] = "Bekannte Gegenstände ignorieren";
L["Quest Item Display Hide Seen Desc"] = "Ignoriert Gegenstände, die bereits von einem Eurer anderen Charakteren entdeckt wurden.";
L["Quest Item Display Await World Map"] = "Bei Weltkarte ausblenden";
L["Quest Item Display Await World Map Desc"] = "Das Pop-up wird beim Öffnen der Weltkarte ausgeblendet. Der Timer, welcher das Pop-up nach kurzer Zeit ausblendet, wird dabei pausiert.";
L["Quest Item Display Reset Position Desc"] = "Pop-up Position zurücksetzen";
L["Valuable Reward Popup"] = "Wertvolles Belohnungs-Popup (Pawn erforderlich)";
L["Valuable Reward Popup Sample"] = "Wertvolles Belohnungs-Popup";
L["Valuable Reward Popup Desc"] = "Wenn dir eine Quest einen Gegenstand gibt, der laut dem Addon Pawn eine Verbesserung für deinen Charakter ist, wird eine Schaltfläche angezeigt, mit der du ihn direkt anlegen kannst.\n\nDie Schaltfläche ist im Kampf deaktiviert.";
L["Item Equipped"] = "Angelegt";
L["Press Key To Use Item"] = "Tastenkürzel";
L["Press Key To Use Item Desc Generic"] = "Drücke die Bestätigungstaste (aktuell: %s), um den Gegenstand außerhalb des Kampfes zu benutzen.";
L["Press Key To Use Item Desc PC"] = "Drücke die Leertaste, um den Gegenstand außerhalb des Kampfes zu benutzen.";
L["Click To Read"] = "Rechtsklick zum Lesen";
L["Begins A Quest"] = "Startet eine Quest";

-- Supported addons
L["Format Reward Title Row"] = "Titel: %s";
L["On Your Gear List"] = "Auf deiner Ausrüstungsliste";
L["Format Exchange It For"] = "Eintauschen gegen: %s";

-- Settings: Loot UI tab (Experimental) and the Loot UI window
L["Experimental"] = "Experimentell";
L["Use Loot UI"] = "Loot UI verwenden";
L["Use Loot UI Desc"] = "Ersetzt das Standard-Beutefenster des Spiels durch Loot UI.\n\nLoot UI ist eine Portierung des Loot UI aus dem Addon Plumber der Retail-Version.";
L["Loot UI Font Size Desc"] = "Legt die Schriftgröße von Loot UI fest. Sie ist unabhängig von der Schriftgröße im Tab Benutzerinterface.\n\nStandard: 12";
L["Fade Out Delay Per Item"] = "Ausblendverzögerung pro Gegenstand";
L["Fade Out Delay Per Item Desc"] = "Wie lange das Loot-UI-Fenster pro angezeigtem Gegenstand zusätzlich zu einer Grundzeit auf dem Bildschirm bleibt. Ein höherer Wert hält lange Listen länger lesbar.\n\nStandard: 0,25s";
L["Items Per Page"] = "Gegenstände pro Seite";
L["Items Per Page Desc"] = "Legt fest, wie viele Gegenstände auf eine Seite des Loot-UI-Fensters passen, wenn es anzeigt, was du erhalten hast. Weitere Gegenstände erscheinen auf den folgenden Seiten.\n\nDies betrifft das Fenster nicht, wenn du manuell plünderst.\n\nStandard: 6";
L["Opacity"] = "Deckkraft";
L["Loot UI Opacity Desc"] = "Legt die Deckkraft des Hintergrunds des Loot-UI-Fensters fest, wenn es anzeigt, was du erhalten hast.\n\nDies betrifft das Fenster nicht, wenn du manuell plünderst.\n\nStandard: 50%";
L["Show Number Of Owned Items"] = "Anzahl besitzter Gegenstände anzeigen";
L["Show Number Of Owned Items Desc"] = "Zeigt auf dem Symbol im Loot-UI-Fenster an, wie viele Exemplare eines Gegenstands du besitzt. Die Anzahl enthält die Gegenstände in deiner Bank (die Bank wird so gezählt, wie sie bei deinem letzten Besuch war).\n\nStandard: An";
L["Fast Loot"] = "Schnelles Plündern";
L["Fast Loot Desc"] = "Nimmt die Beute, sobald sich das Beutefenster öffnet, statt zuerst einen Moment zu warten. Gilt nur, wenn die automatische Plünderung des Spiels aktiv ist oder Loot UI sie erzwingt.\n\nDas schnelle Plündern des Addons Plumber.";
L["Grow Upwards"] = "Nach oben wachsen";
L["Grow Upwards On Desc"] = "Wenn aktiviert: Die untere linke Ecke des Fensters bleibt unverändert, und neue Benachrichtigungen erscheinen über den alten.";
L["Grow Upwards Off Desc"] = "Wenn deaktiviert: Die obere linke Ecke des Fensters bleibt unverändert, und neue Benachrichtigungen erscheinen unter den alten.";
L["Combine Similar Items"] = "Ähnliche Gegenstände kombinieren";
L["Combine Similar Items Desc"] = "Zeigt ähnliche Gegenstände in einer einzigen Zeile an.\n\nUnterstützte Kategorien:\n\n- Plunder\n\nStandard: An";
L["Send to Back"] = "Nach hinten schicken";
L["Send to Back Desc"] = "Solange Loot UI anzeigt, was du erhalten hast, wird sein Fenster hinter anderen Interface-Elementen angezeigt.\n\nDies betrifft nicht das Fenster beim manuellen Plündern.\n\nStandard: Aus";
L["Loot Under Mouse"] = "Beutefenster an der Maus öffnen";
L["Loot Under Mouse Desc"] = "Beim manuellen Plündern erscheint das Beutefenster unter der aktuellen Mausposition.\n\nDies betrifft nicht das Fenster, solange es anzeigt, was du erhalten hast.\n\nStandard: Aus";
L["Press Key To Take All Items"] = "Taste zum Nehmen aller Gegenstände";
L["Press Key To Take All Items Desc"] = "Beim manuellen Plündern nimmst du mit der folgenden Taste alle Gegenstände. Solange das Beutefenster offen ist, hat diese Taste keine andere Funktion, auch wenn sie auf deiner Aktionsleiste liegt.\n\nRechtsklick auf die Taste setzt sie auf die Standardtaste zurück.\n\nStandard: An";
L["Hide You Received Text"] = "„Du hast erhalten“-Text ausblenden";
L["Hide You Received Text Desc"] = "Blendet den Text „Du hast erhalten“ über dem Loot-UI-Fenster aus, wenn es anzeigt, was du erhalten hast.\n\nStandard: Aus";
L["Show Reputation Changes"] = "Rufänderungen anzeigen";
L["Show Reputation Changes Desc"] = "Zeigt jede Rufsteigerung im Loot-UI-Fenster an.\n\nStandard: Aus";
L["Show Any Money Changes"] = "Alle Geldänderungen anzeigen";
L["Show Any Money Changes Desc"] = "Zeigt das Geld an, das du aus allen Quellen erhältst (Verkauf, Quests, Post ...), nicht nur aus Beute.\n\nStandard: Aus";
L["Show Any Currency Changes"] = "Alle Währungsänderungen anzeigen";
L["Show Any Currency Changes Desc"] = "Zeigt Ehrenpunkte, Arenapunkte und Währungen an, die du aus allen Quellen erhältst, nicht nur aus Beute. Es werden nur Zugewinne angezeigt.\n\n|cffff4800Währungen, die Gegenstände sind (z. B. Wappen), werden beim Plündern als die Gegenstände angezeigt, die sie sind.|r\n\nStandard: Aus";
L["You Received"] = "Du hast erhalten";
L["Junk Items"] = "Plunder";
L["Take All"] = "Alles nehmen";
L["Give To"] = "Geben an";
