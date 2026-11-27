-- Français. Les chaînes avec des valeurs sont des formats : "%d" = nombre, "%s" = texte.
if not (GetLocale() == "frFR") then return end;

local _, addon = ...;
local L = addon.L;

-- Les chaînes globales de Blizzard sont utilisées lorsqu'elles existent (FrameXML, pas wow-docs),
-- afin de suivre la langue du client. Le texte français sert de valeur de secours.
-- Les chaînes contenant des valeurs sont des formats : "%d" = nombre, "%s" = texte.


-- Boutons de pied de fenêtre
L["Accept"] = ACCEPT or "Accepter";
L["Restart Quest"] = "Recommencer";
L["Continue"] = CONTINUE or "Continuer";
L["Complete Quest"] = COMPLETE or "Terminer la quête";
L["Incomplete"] = INCOMPLETE or "Inachevée";
L["Decline"] = DECLINE or "Refuser";
L["Cancel"] = CANCEL or "Annuler";
L["Goodbye"] = GOODBYE or "Au revoir";

-- Fenêtre des paramètres
L["UI"] = "Interface";
L["Control"] = "Commandes";
L["Gameplay"] = "Jeu";
L["Audio"] = "Audio";
L["Minimap"] = "Mini-carte";
L["Other Addons"] = "Autres addons";

-- Settings: Audio tab
L["Enable Audio Fading"] = "Activer l'atténuation audio";
L["Enable Audio Fading Desc"] = "Baisse les volumes du jeu tant que la fenêtre de dialogue ou un texte à lire est ouvert. À la fermeture, ils reviennent progressivement aux volumes réglés dans les options audio du jeu.";
L["Sound Fade Volume"] = "Volume des effets en lecture";
L["Sound Fade Volume Desc"] = "Le volume des effets sonores vers lequel baisser pendant la lecture. Un volume déjà plus faible n'est pas augmenté.";
L["Sound Fade Duration"] = "Durée du fondu des effets";
L["Sound Fade Duration Desc"] = "Le temps que mettent les effets sonores à baisser, puis à remonter.\n\nPar défaut : 0,5s";
L["Music Fade Volume"] = "Volume de la musique en lecture";
L["Music Fade Volume Desc"] = "Le volume de la musique vers lequel baisser pendant la lecture. Un volume déjà plus faible n'est pas augmenté.";
L["Music Fade Duration"] = "Durée du fondu de la musique";
L["Music Fade Duration Desc"] = "Le temps que met la musique à baisser, puis à remonter.\n\nPar défaut : 0,5s";
L["Ambiance Fade Volume"] = "Volume d'ambiance en lecture";
L["Ambiance Fade Volume Desc"] = "Le volume d'ambiance vers lequel baisser pendant la lecture. Un volume déjà plus faible n'est pas augmenté.";
L["Ambiance Fade Duration"] = "Durée du fondu d'ambiance";
L["Ambiance Fade Duration Desc"] = "Le temps que met l'ambiance à baisser, puis à remonter.\n\nPar défaut : 0,5s";
L["Audio Fade Music Spoken"] = "|cffff8040Spoken joue ses voix sur le canal de la musique, le volume de la musique n'est donc pas modifié.|r";

-- Settings: Other Addons tab
L["Tooltip"] = "Infobulle";
L["Auction House"] = "Hôtel des ventes";
L["Auction House Desc"] = "Ajoute à l'infobulle des objets les prix de l'hôtel des ventes fournis par un autre addon installé. Choisissez lequel ci-dessous.";
L["Auction House Auctionator Desc"] = "Auctionator : le prix de vente, le prix médian et la valeur de désenchantement de l'objet, tels qu'Auctionator les affiche dans ses propres infobulles. Les lignes suivent les options d'infobulle d'Auctionator.";
L["Auction House RetailAH Desc"] = "Retail Auction House (mod-retail-ah) : ce que l'acheteur bot de l'HV du serveur paie pour l'objet (le total de la pile pour une pile) et la valeur moyenne des matériaux d'un désenchantement. Le meilleur des deux est en vert.\n\nRien n'est affiché pour un objet lié, et la ligne de désenchantement est grise si votre niveau d'Enchantement est trop bas. Le serveur doit exécuter le module mod-retail-ah.";
L["Journal Gear Desc"] = "Ajoute la ligne « Sur votre liste d'équipement » à l'infobulle des objets qui constituent une amélioration pour votre spécialisation, via l'addon Journal: Gear (JournalGearBIS).";
L["Addon Not Installed"] = "|cffff8040%s n'est pas installé ou n'est pas chargé, cette prise en charge ne fonctionnera donc pas.|r Installez-le et rechargez l'interface (/reload).";
L["Spoken Buttons"] = "Boutons Spoken";
L["Spoken Buttons Desc"] = "Ajoute les boutons Lecture et Passer de Spoken à la fenêtre de quêtes et de discussions et à la vue des livres, qui en seraient sinon privées tant que DialogueUI masque l'interface du jeu.\n\nIl faut copier quelques fichiers dans les addons Spoken. Consultez l'entrée Spoken sous Supported addons dans le README.md de l'addon DialogueUI pour savoir quoi faire.";
L["Spoken Bridge Missing"] = "|cffff8040Le fichier passerelle n'est pas encore dans le dossier de Spoken.|r Consultez l'entrée Spoken sous Supported addons dans le README.md de l'addon DialogueUI pour savoir quoi faire.";
L["AH Bot Buys"] = "Le bot de l'HV achète";
L["AH Bot Disenchant"] = "Désenchanter (bot de l'HV)";
L["AH Bot Disenchant Skill"] = "Désenchanter |cff808080(Enchantement %d)|r";
L["AH Bot BiS Bonus"] = "Bonus BiS";

-- Paramètres : compatibilité
L["Compatibility"] = "Compatibilité";
L["Disable DUI In Instance"] = "Utiliser l'interface par défaut de WoW en instance";
L["Disable DUI In Instance Desc"] = "Désactive Dialogue UI et utilise l'interface par défaut de WoW lorsque vous êtes dans un donjon ou un raid.";

-- Paramètres : onglet Mini-carte et bouton de la mini-carte
L["Show Minimap Button"] = "Afficher le bouton de la mini-carte";
L["Show Minimap Button Desc"] = "Affiche un bouton sur la mini-carte pour ouvrir ces paramètres. Faites-le glisser pour le déplacer autour de la mini-carte.";
L["Minimap Button Tooltip"] = "Cliquez pour ouvrir les paramètres.";
L["Minimap Button Drag"] = "Faites glisser pour déplacer";

-- Paramètres : onglet Interface
L["Theme"] = "Thème";
L["Theme Desc"] = "Choisissez un thème de couleur pour l'interface.";
L["Loot Theme Desc"] = "Choisissez un thème de couleur pour l'interface de butin. Il peut différer du thème du reste de l'interface.";
L["Theme Brown"] = "Marron";
L["Theme Dark"] = "Sombre";
L["Frame Size"] = "Taille de la fenêtre";
L["Frame Size Desc"] = "Définissez la taille de l'interface de dialogue.\n\nPar défaut : moyenne";
L["Size Extra Small"] = "Très petite";
L["Size Small"] = "Petite";
L["Size Medium"] = "Moyenne";
L["Size Large"] = "Grande";
L["Size Very Large"] = "Très grande";
L["Size Extra Large"] = "Extra grande";
L["Open Animation"] = "Animation d'ouverture";
L["Open Animation Desc"] = "Durée d'ouverture de la fenêtre de dialogue. 0 s l'affiche immédiatement.\n\nPar défaut : 0,25 s";
L["Font Size"] = "Taille de la police";
L["Font Size Desc"] = "Définissez la taille de la police de l'interface.\n\nPar défaut : 12";
L["Font"] = "Police";
L["Font Desc"] = "Choisissez la police utilisée par l'interface.\n\nPolice par défaut : Friz Quadrata";
L["Default Font"] = "Police par défaut";
L["System Font"] = "Système";
L["Font Missing"] = "La police choisie n'est pas disponible, la police par défaut est donc utilisée.";
L["Font No Shared Media"] = "Installez SharedMedia, ou tout addon qui ajoute des polices via LibSharedMedia-3.0, pour avoir plus de polices ici.";
L["Frame Orientation"] = "Position";
L["Frame Orientation Desc"] = "Placez l'interface à gauche ou à droite de l'écran.\n\nL'option Personnalisée vous permet de déplacer l'interface où vous le souhaitez tant que cette fenêtre est ouverte.\n\nPar défaut : droite";
L["Orientation Left"] = "Gauche";
L["Orientation Right"] = "Droite";
L["Orientation Custom"] = "Personnalisée";
L["Move Position"] = "Déplacer";
L["Reset Position"] = "Réinitialiser la position";
L["Move Position Desc"] = "Affiche l'interface pour vous permettre de la déplacer.";
L["Reset Position Desc"] = "Réinitialise la position de l'interface.";
L["Readables Position"] = "Position";
L["Readables Position Desc"] = "Placez les textes à lire (livres, lettres, plaques) sur le côté gauche de l'écran.\n\nL'option Personnalisée vous permet de les déplacer où vous le souhaitez tant que cette fenêtre est ouverte.\n\nPar défaut : Par défaut";
L["Position Default"] = "Par défaut";
L["Readables Move Position Desc"] = "Affiche un exemple que vous pouvez déplacer vers une nouvelle position.";
L["Readables Reset Position Desc"] = "Réinitialise la position du texte à lire.";
L["Hide UI"] = "Masquer l'interface";
L["Hide UI Desc"] = "Estompe l'interface du jeu lorsque vous interagissez avec un PNJ.";
L["Readables Hide UI Desc"] = "Estompe l'interface du jeu pendant que vous lisez un livre, une lettre ou une plaque.";
L["Show NPC Name On Page"] = "Afficher le nom du PNJ";
L["Show NPC Name On Page Desc"] = "Affiche le nom du PNJ sur la page.";
L["Show Quest Type"] = "Afficher le type de quête";
L["Show Quest Type Desc"] = "Affiche le type de quête (quête, journalière, hebdomadaire, donjon, etc.) au-dessus du titre.";
L["Show Copy Text Button"] = "Afficher le bouton de copie du texte";
L["Show Copy Text Button Desc"] = "Affiche un bouton Copier le texte en haut à droite de l'interface de dialogue.\n\nLes données du jeu sont également incluses, comme les identifiants des PNJ et des objets (ainsi que les identifiants des quêtes déjà dans votre journal).";
L["Copy Text"] = "Copier le texte";
L["Drag To Move"] = "Clic gauche maintenu pour déplacer la fenêtre.";
L["Edit Mode Title"] = "Interface de dialogue";
L["Edit Mode Body"] = "Déplacez cette fenêtre à l'endroit souhaité. Fermez la fenêtre des paramètres pour la masquer.";

-- Types et catégories de quêtes
L["Quest"] = "Quête";
L["Readables"] = "Documents";
L["BookUI Frame Size Desc"] = "Définissez la taille de l'interface des livres.\n\nPar défaut : petite";
L["BookUI Keep UI Open"] = "Garder la fenêtre ouverte";
L["BookUI Keep UI Open Desc"] = "Garde la fenêtre ouverte lorsque vous vous éloignez de l'objet.\n\nAppuyez sur Échap ou faites un clic droit sur l'interface pour la fermer.";
L["BookUI Show Location"] = "Afficher l'emplacement";
L["BookUI Show Location Desc"] = "Affiche l'emplacement de l'objet dans l'en-tête.\n\nFonctionne uniquement avec les objets du monde, pas avec ceux présents dans vos sacs.";
L["BookUI Show Item Description"] = "Afficher la description de l'objet";
L["BookUI Show Item Description Desc"] = "Si l'infobulle de l'objet contient une description, celle-ci sera affichée en haut de l'interface.";
L["BookUI Darken Screen"] = "Assombrir l'écran";
L["BookUI Darken Screen Desc"] = "Assombrit la zone située sous l'interface pour vous aider à vous concentrer sur le contenu.";

-- Paramètres : onglet Commandes (chaînes également présentes dans la version actuelle)
L["Input Device"] = "Périphérique d'entrée";
L["Input Device Desc"] = "Affecte les icônes des raccourcis et la disposition de l'interface.";
L["Input Device KBM"] = "Clavier et souris";
L["Use Custom Bindings"] = "Utiliser des raccourcis personnalisés";
L["Use Custom Bindings Desc"] = "Activez cette option pour utiliser vos propres raccourcis.";
L["Primary Control Key Desc"] = "Appuyez sur cette touche pour sélectionner la première option disponible, comme Accepter la quête.";
L["Right Click To Close UI"] = "Clic droit pour fermer l'interface";
L["Right Click To Close UI Desc"] = "Faites un clic droit sur l'interface de dialogue pour la fermer.";
L["Press Button To Scroll Down"] = "Appuyer sur le bouton pour faire défiler";
L["Press Button To Scroll Down Desc"] = "Si le contenu dépasse la zone visible, appuyer sur le bouton de confirmation fera défiler la page vers le bas au lieu d'accepter la quête.";
L["Press Escape To Decline Quest"] = "Échap pour refuser la quête";
L["Press Escape To Decline Quest Desc"] = "Lorsque vous consultez une quête auprès d'un PNJ proposant d'autres dialogues, appuyer sur Échap vous ramène à la page précédente au lieu de fermer l'interface.";
L["Press Tab To Select Reward"] = "Tabulation pour choisir une récompense";
L["Press Tab To Select Reward Desc"] = "Appuyez sur Tabulation pour parcourir les récompenses disponibles lorsque vous rendez une quête. Majuscule + Tabulation permet de revenir en arrière.";
L["Keybinding Hint"] = "Cliquez, puis appuyez sur la touche à associer.\nClic droit : rétablir la touche par défaut.\nÉchap : annuler.";
L["Bound To"] = "Associé à : ";
L["Not Bound"] = NOT_BOUND or "Non assigné";
L["Action Confirm"] = "Confirmer";
L["Action Settings"] = "Afficher/masquer les paramètres";
L["Action Option1"] = "Option 1";
L["Action Option2"] = "Option 2";
L["Action Option3"] = "Option 3";
L["Action Option4"] = "Option 4";
L["Action Option5"] = "Option 5";
L["Action Option6"] = "Option 6";
L["Action Option7"] = "Option 7";
L["Action Option8"] = "Option 8";
L["Action Option9"] = "Option 9";
L["Action Option Desc"] = "Appuyez sur cette touche pour sélectionner l'option %d de la liste (options de dialogue et quêtes).";
L["Action Settings Desc"] = "Appuyez sur cette touche pour ouvrir ou fermer la fenêtre des paramètres lorsque l'interface de dialogue est affichée.";

L["Quest Frequency Daily"] = "Journalière";
L["Quest Frequency Weekly"] = "Hebdomadaire";
L["Quest Type Repeatable"] = "Répétable";
L["Quest Difficulty VeryHard"] = "Très difficile";
L["Quest Difficulty Hard"] = "Difficile";
L["Quest Difficulty Easy"] = "Facile";
L["Quest Difficulty Trivial"] = "Bas niveau";
L["Quest Difficulty Option"] = "Difficulté des quêtes";
L["Instant Quest Text"] = "Texte instantané";
L["Instant Quest Text Desc"] = "Affiche immédiatement le texte sur les pages de quête et dans les documents au lieu de le faire apparaître progressivement. Cette option utilise le même paramètre du jeu que celui de Blizzard pour le texte des quêtes.";
L["Mark Highest Sell Price"] = "Indiquer le prix de vente le plus élevé";
L["Mark Highest Sell Price Desc"] = "Indique quel objet possède le prix de vente le plus élevé lorsque vous choisissez une récompense.";
L["Show Replace Calculations"] = "Afficher les calculs de remplacement";
L["Show Replace Calculations Desc"] = "Affiche les différences de statistiques sous « Remplace » dans l'infobulle de l'objet. Désactivé, seule la ligne de remplacement avec le nom de l'objet équipé est affichée.";
L["Use Blizzard Tooltip"] = "Utiliser l'infobulle de Blizzard";
L["Use Blizzard Tooltip Desc"] = "Utilise l'infobulle de Blizzard pour le bouton de récompense de quête à la place de notre infobulle personnalisée.";
L["Show EXP Bar"] = "Barre d'expérience";
L["Show EXP Bar Desc"] = "Affiche une barre d'expérience en bas de l'écran pendant qu'une conversation est ouverte.";
L["Always Show EXP Bar"] = "Toujours afficher la barre d'expérience";
L["Always Show EXP Bar Desc"] = "Garde la barre d'expérience à l'écran quand aucune conversation n'est ouverte, pour qu'elle serve de barre d'expérience.";
L["Color Player Name"] = "Colorer le nom du joueur (mode sombre uniquement)";
L["Color Player Name Desc"] = "Affiche le nom de votre personnage dans le texte des quêtes et des dialogues avec la couleur de votre classe. Thème sombre uniquement.";
L["Color Class Name"] = "Colorer le nom de la classe (mode sombre uniquement)";
L["Color Class Name Desc"] = "Affiche le nom de votre classe dans le texte des quêtes et des dialogues avec la couleur de votre classe. Thème sombre uniquement.";
L["Format Unit Level"] = "Niveau %d";
L["Format Player XP"] = "XP : %d/%d (%d%%)";
L["Format Gained XP"] = "%d XP";
L["To Next Level Label"] = "Avant le prochain niveau";
L["Use Separate Tooltip for Comparison"] = "Utiliser une infobulle séparée pour la comparaison";
L["Use Separate Tooltip for Comparison Desc"] = "Affiche l'objet équipé que vous remplaceriez dans une infobulle distincte à côté de l'infobulle de la récompense, avec les différences de caractéristiques en bas. Les anneaux, bijoux et armes affichent une infobulle par objet équipé.";
L["Use Separate Tooltip Blizzard Active"] = "Indisponible tant que « %s » est activé. Désactivez cette option pour utiliser celle-ci.";
L["Show Transmog Status"] = "Afficher les apparences non collectées";
L["Show Transmog Status Desc"] = "Marque les objets de récompense dont l'apparence de transmogrification n'a pas encore été collectée et ajoute une ligne à leur infobulle.\n\n|cffff8040Le serveur doit avoir le module du système de transmogrification (mod-transmog) installé.|r Rien n'est affiché sur un serveur qui ne l'a pas.\n\nL'addon exécute une fois la commande .transmog sync et masque son résultat dans la fenêtre de discussion.";
L["Use Transmog Plus"] = "Utilisation de Mod Transmog Plus";
L["Use Transmog Plus Desc"] = "Cochez cette option si le serveur utilise mod-transmog-plus au lieu du mod-transmog d'origine. Le serveur répond alors pour chaque objet et considère une apparence comme collectée dès qu'un objet ayant le même modèle l'est.\n\nLaissez-la décochée pour le mod-transmog d'origine.";
L["Transmog Not Collected"] = "Apparence non collectée";
L["Transmog Module Missing"] = "|cffff8040Le module serveur %s n'a pas été détecté, ce paramètre est donc désactivé.|r";
L["Click To Copy To Clipboard"] = "Cliquer pour copier dans le presse-papiers";
L["Show Upgrade Arrow"] = "Afficher la flèche d'amélioration (Pawn requis)";
L["Show Upgrade Arrow Desc"] = "Affiche une flèche verte %s sur un objet de récompense s'il constitue une amélioration pour votre personnage selon l'addon Pawn : l'objet obtient un meilleur score que celui que vous portez dans cet emplacement avec au moins l'une de vos échelles Pawn.\n\nLes armures d'un type différent de celui que vous portez (du tissu à la place du cuir, par exemple) ne sont jamais signalées.";
L["Show Upgrade Arrow Pawn Missing"] = "L'addon Pawn est requis (introuvable).\n\nTéléchargement : |cff0000ee%s|r\n\nCliquez sur l'icône de copie, appuyez sur Ctrl+C, puis collez le lien dans votre navigateur.";
L["Quest Difficulty Option Desc"] = "Choisissez comment afficher la difficulté des quêtes lorsque le PNJ vous propose une liste de quêtes.";
L["QuestDifficultyStyle Off"] = "DÉSACTIVÉ";
L["QuestDifficultyStyle Off Desc"] = "Le niveau et la difficulté des quêtes sont maintenant masqués.";
L["QuestDifficultyStyle Level"] = "Niveau";
L["QuestDifficultyStyle Level Desc"] = "Affiche le niveau de la quête à gauche de son titre.";
L["QuestDifficultyStyle Name"] = "Nom";
L["QuestDifficultyStyle Both"] = "Les deux";
L["QuestDifficultyStyle Both Desc"] = "Affiche le niveau de la quête à gauche de son titre et le nom de la difficulté à droite du bouton de quête si le niveau de la quête est en dehors de la plage recommandée.";
L["QuestDifficultyStyle Name Desc"] = "Affiche le nom de la difficulté à droite du bouton de quête si le niveau de la quête est en dehors de la plage recommandée.\n(Le niveau de la quête est supérieur ou inférieur de 3 niveaux à celui de votre personnage.)";
L["Quest Type Trivial"] = "Bas niveau";
L["Quest Type Dungeon"] = "Donjon";
L["Quest Type Raid"] = "Raid";
L["Quest Type Heroic"] = "Héroïque";
L["Quest Type Elite"] = "Élite";
L["Quest Type Group"] = "Groupe";
L["Quest Type PvP"] = "Joueur contre joueur";

-- Texte des quêtes
L["Quest Objectives"] = "Objectifs";
L["Format Suggested Players"] = QUEST_SUGGESTED_GROUP_NUM or "Joueurs conseillés [%d]";
L["Quest Accepted Alert"] = ERR_QUEST_ACCEPTED_S or "Quête acceptée : %s";

-- Récompenses
L["Reward"] = "Récompense";
L["Rewards"] = "Récompenses";
L["Reward Choose"] = REWARD_CHOOSE or "Choisissez votre récompense :";
L["Reward Choices"] = REWARD_CHOICES or "Vous pourrez choisir l'une de ces récompenses :";
L["Reward Items"] = REWARD_ITEMS or "Vous recevrez également :";
L["Requirements"] = "Conditions requises";
L["Money"] = MONEY or "Argent";
L["Honor Points"] = "Points d'honneur";
L["Arena Points"] = "Points d'arène";
L["Talent Points"] = "Points de talent";
L["Experience"] = "Expérience";
L["Title"] = "Titre";
L["Format Talent Point Row"] = "+%d point de talent";
L["Format Talent Points Row"] = "+%d points de talent";

-- Infobulle des récompenses
L["Show Comparison"] = "Afficher la comparaison";
L["Hide Comparison"] = "Masquer la comparaison";
L["Sell Price"] = SELL_PRICE or "Prix de vente";
L["Format Item Level"] = ITEM_LEVEL or "Niveau d'objet %d";
L["Format You Have"] = "- Vous en possédez |cffffffff%d|r";
L["Format In Bank"] = " (|cffffffff%d|r en banque)";
L["Format Replace Item"] = "Remplace : %s";
L["Equipped Item"] = "objet équipé";
L["Currently Equipped"] = "Actuellement équipé";
L["Different Item Type"] = "Type d'objet différent de celui actuellement équipé.";
L["Identical Stats"] = "Caractéristiques identiques";
L["Format Reward Title"] = "Vous recevrez le titre « %s ».";
L["Format Reward Honor"] = "Vous recevrez %d points d'honneur.";
L["Format Reward Talent Point"] = "Vous recevrez %d point de talent.";
L["Format Reward Talent Points"] = "Vous recevrez %d points de talent.";
L["Format Reward Arena"] = "Vous recevrez %d points d'arène.";
L["Format Reward Experience"] = "Vous gagnerez %d points d'expérience%s.";
L["Format Of Your Level"] = " (%d%% de votre niveau)";

-- Affichage des objets de quête
L["Quest Item Display"] = "Affichage des objets de quête";
L["Quest Item Display Desc"] = "Affiche automatiquement la description de l'objet de quête et vous permet de l'utiliser sans ouvrir vos sacs.";
L["Quest Item Display Hide Seen"] = "Ignorer les objets déjà découverts";
L["Quest Item Display Hide Seen Desc"] = "Ignore les objets qui ont déjà été découverts par l'un de vos personnages.";
L["Quest Item Display Await World Map"] = " Attendre la carte du monde";
L["Quest Item Display Await World Map Desc"] = "Lorsque vous ouvrez la carte du monde, masque temporairement l'affichage des objets de quête et met en pause le délai de fermeture automatique.";
L["Quest Item Display Reset Position Desc"] = "Réinitialise la position de la fenêtre.";
L["Valuable Reward Popup"] = "Fenêtre des récompenses intéressantes (Pawn requis)";
L["Valuable Reward Popup Sample"] = "Fenêtre des récompenses intéressantes";
L["Valuable Reward Popup Desc"] = "Lorsqu'une quête vous donne un objet qui constitue une amélioration pour votre personnage selon l'addon Pawn, affiche un bouton permettant de l'équiper directement.\n\nCe bouton est désactivé pendant les combats.";
L["Item Equipped"] = "Équipé";
L["Press Key To Use Item"] = "Appuyer sur le bouton pour utiliser";
L["Press Key To Use Item Desc Generic"] = "Appuyez sur le bouton de confirmation (actuellement : %s) pour utiliser l'objet hors combat.";
L["Press Key To Use Item Desc PC"] = "Appuyez sur Espace pour utiliser l'objet hors combat.";
L["Click To Read"] = "Clic gauche pour lire";
L["Begins A Quest"] = "Commence une quête";

-- Addons pris en charge
L["Format Reward Title Row"] = "Titre : %s";
L["On Your Gear List"] = "Dans votre liste d'équipement";
L["Format Exchange It For"] = "À échanger contre : %s";

-- Settings: Loot UI tab (Experimental) and the Loot UI window
L["Experimental"] = "Expérimental";
L["Use Loot UI"] = "Utiliser Loot UI";
L["Use Loot UI Desc"] = "Remplace la fenêtre de butin par défaut du jeu par Loot UI.\n\nLoot UI est un portage du Loot UI de l'addon Plumber de retail.";
L["Loot UI Font Size Desc"] = "Définit la taille de la police de Loot UI. Elle est indépendante de la taille de police de l'onglet Interface.\n\nPar défaut : 12";
L["Fade Out Delay Per Item"] = "Délai d'estompage par objet";
L["Fade Out Delay Per Item Desc"] = "Durée pendant laquelle la fenêtre Loot UI reste à l'écran pour chaque objet affiché, en plus d'une durée de base. Une valeur plus élevée garde les longues listes lisibles plus longtemps.\n\nPar défaut : 0,25s";
L["Items Per Page"] = "Objets par page";
L["Items Per Page Desc"] = "Définit combien d'objets tiennent sur une page de la fenêtre Loot UI lorsqu'elle affiche ce que vous avez reçu. Les autres objets sont affichés sur les pages suivantes.\n\nCela n'affecte pas la fenêtre lorsque vous pillez manuellement.\n\nPar défaut : 6";
L["Opacity"] = "Opacité";
L["Loot UI Opacity Desc"] = "Définit l'opacité de l'arrière-plan de la fenêtre Loot UI lorsqu'elle affiche ce que vous avez reçu.\n\nCela n'affecte pas la fenêtre lorsque vous pillez manuellement.\n\nPar défaut : 50%";
L["Show Number Of Owned Items"] = "Afficher le nombre d'objets possédés";
L["Show Number Of Owned Items Desc"] = "Affiche sur l'icône, dans la fenêtre Loot UI, combien d'exemplaires d'un objet vous possédez. Le total inclut les objets de votre banque (la banque est comptée telle qu'elle était lors de votre dernière visite).\n\nPar défaut : Activé";
L["Fast Loot"] = "Butin rapide";
L["Fast Loot Desc"] = "Récupère le butin dès que la fenêtre de butin s'ouvre, au lieu d'attendre un instant. S'applique uniquement si le butin automatique du jeu est activé ou si Loot UI le force.\n\nLe butin rapide de l'addon Plumber.";
L["Grow Upwards"] = "Grandir vers le haut";
L["Grow Upwards On Desc"] = "Option activée : le coin inférieur gauche de la fenêtre reste immobile et les nouvelles notifications apparaîtront au-dessus des anciennes.";
L["Grow Upwards Off Desc"] = "Option désactivée : le coin supérieur gauche de la fenêtre reste immobile et les nouvelles notifications apparaîtront en dessous des anciennes.";
L["Combine Similar Items"] = "Combiner les objets similaires";
L["Combine Similar Items Desc"] = "Afficher les objets similaires sur une seule ligne.\n\nCatégories prises en charge :\n\n- Objets sans valeur\n\nPar défaut : Activé";
L["Send to Back"] = "Placer à l'arrière-plan";
L["Send to Back Desc"] = "Pendant que Loot UI affiche ce que vous avez reçu, place sa fenêtre derrière les autres éléments de l'interface.\n\nCela n'affecte pas la fenêtre lors d'un butin manuel.\n\nPar défaut : Désactivé";
L["Loot Under Mouse"] = "Ouvrir la fenêtre de butin sur la souris";
L["Loot Under Mouse Desc"] = "Lors d'un butin manuel, la fenêtre de butin apparaît sous la position actuelle de la souris.\n\nCela n'affecte pas la fenêtre pendant qu'elle affiche ce que vous avez reçu.\n\nPar défaut : Désactivé";
L["Press Key To Take All Items"] = "Touche pour tout prendre";
L["Press Key To Take All Items Desc"] = "Lors d'un butin manuel, appuyez sur la touche suivante pour prendre tous les objets. Tant que la fenêtre de butin est ouverte, cette touche ne fait rien d'autre, même si elle est aussi sur votre barre d'action.\n\nFaites un clic droit sur la touche pour revenir à la touche par défaut.\n\nPar défaut : Activé";
L["Hide You Received Text"] = "Masquer le texte « Vous avez reçu »";
L["Hide You Received Text Desc"] = "Masque le texte « Vous avez reçu » au-dessus de la fenêtre Loot UI lorsqu'elle affiche ce que vous avez reçu.\n\nPar défaut : Désactivé";
L["Show Reputation Changes"] = "Afficher les changements de réputation";
L["Show Reputation Changes Desc"] = "Affiche tous les gains de réputation dans la fenêtre Loot UI.\n\nPar défaut : Désactivé";
L["Show Any Money Changes"] = "Afficher tous les changements d'argent";
L["Show Any Money Changes Desc"] = "Affiche l'argent que vous gagnez depuis toutes les sources (ventes, quêtes, courrier ...), pas seulement le butin.\n\nPar défaut : Désactivé";
L["Show Any Currency Changes"] = "Afficher tous les changements de monnaie";
L["Show Any Currency Changes Desc"] = "Affiche les points d'honneur, les points d'arène et les monnaies que vous gagnez depuis toutes les sources, pas seulement le butin. Seuls les gains sont affichés.\n\n|cffff4800Les monnaies qui sont des objets (comme les emblèmes) sont affichées pendant le butin comme les objets qu'elles sont.|r\n\nPar défaut : Désactivé";
L["You Received"] = "Vous avez reçu";
L["Junk Items"] = "Objets sans valeur";
L["Take All"] = "Tout prendre";
L["Give To"] = "Donner à";
