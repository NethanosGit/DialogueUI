-- Español (México). Strings come from the retail Dialogue UI locale where it has the same text, the rest are written for this port.
if not (GetLocale() == "esMX") then return end;

local _, addon = ...;
local L = addon.L;

-- Blizzard's own global strings are used where they exist (they follow the client language). The text below is the fallback.

-- Footer buttons
L["Accept"] = ACCEPT or "Aceptar";
L["Restart Quest"] = "Reiniciar";
L["Continue"] = CONTINUE or "Continar";
L["Complete Quest"] = COMPLETE or "Completar misión";
L["Incomplete"] = INCOMPLETE or "Incompleto";
L["Decline"] = DECLINE or "Rechazar";
L["Cancel"] = CANCEL or "Cancelar";
L["Goodbye"] = GOODBYE or "Adiós";

-- Settings window
L["UI"] = "UI";
L["Control"] = "Control";
L["Gameplay"] = "Juego";
L["Audio"] = "Audio";
L["Minimap"] = "Minimapa";
L["Other Addons"] = "Otros addons";

-- Settings: Audio tab
L["Enable Audio Fading"] = "Activar atenuación de audio";
L["Enable Audio Fading Desc"] = "Baja los volúmenes del juego mientras la ventana de diálogo o un texto legible está abierto. Al cerrarse, regresan gradualmente a los volúmenes elegidos en las opciones de sonido del juego.";
L["Sound Fade Volume"] = "Volumen de efectos al leer";
L["Sound Fade Volume Desc"] = "El volumen de los efectos de sonido al que se atenúa mientras lees. Un volumen que ya es más bajo no se sube.";
L["Sound Fade Duration"] = "Duración de atenuación de efectos";
L["Sound Fade Duration Desc"] = "Cuánto tardan los efectos de sonido en bajar y en volver a subir.\n\nPredeterminado: 0.5s";
L["Music Fade Volume"] = "Volumen de música al leer";
L["Music Fade Volume Desc"] = "El volumen de la música al que se atenúa mientras lees. Un volumen que ya es más bajo no se sube.";
L["Music Fade Duration"] = "Duración de atenuación de música";
L["Music Fade Duration Desc"] = "Cuánto tarda la música en bajar y en volver a subir.\n\nPredeterminado: 0.5s";
L["Ambiance Fade Volume"] = "Volumen ambiental al leer";
L["Ambiance Fade Volume Desc"] = "El volumen ambiental al que se atenúa mientras lees. Un volumen que ya es más bajo no se sube.";
L["Ambiance Fade Duration"] = "Duración de atenuación ambiental";
L["Ambiance Fade Duration Desc"] = "Cuánto tarda el sonido ambiental en bajar y en volver a subir.\n\nPredeterminado: 0.5s";
L["Audio Fade Music Spoken"] = "|cffff8040Spoken reproduce sus voces por el canal de música, así que el volumen de la música no se cambia.|r";

-- Settings: Other Addons tab
L["Tooltip"] = "Descripción emergente";
L["Auction House"] = "Casa de subastas";
L["Auction House Desc"] = "Añade a la descripción emergente del objeto los precios de la casa de subastas de otro addon instalado. Elige cuál abajo.";
L["Auction House Auctionator Desc"] = "Auctionator: el precio de subasta, el precio mediano y el valor de desencantado del objeto, tal como Auctionator los muestra en sus propias descripciones. Las líneas siguen las opciones de descripción de Auctionator.";
L["Auction House RetailAH Desc"] = "Retail Auction House (mod-retail-ah): lo que paga por el objeto el comprador bot de la casa de subastas del servidor (el total de la pila si es una pila) y el valor promedio de los materiales de un desencantado. Lo mejor de los dos se muestra en verde.\n\nNo se muestra nada para un objeto ligado, y la línea de desencantado es gris si tu Encantamiento es demasiado bajo. El servidor debe ejecutar el módulo mod-retail-ah.";
L["Journal Gear Desc"] = "Añade la línea «En tu lista de equipo» a la descripción de los objetos que son una mejora para tu especialización, del addon Journal: Gear (JournalGearBIS).";
L["Addon Not Installed"] = "|cffff8040%s no está instalado o no está cargado, por lo que esta compatibilidad no funcionará.|r Instálalo y recarga la interfaz (/reload).";
L["Spoken Buttons"] = "Botones de Spoken";
L["Spoken Buttons Desc"] = "Añade los botones Reproducir y Saltar de Spoken a la ventana de misiones y charlas y a la vista de libros, que de otro modo se quedarían sin ellos mientras DialogueUI oculta la interfaz del juego.\n\nRequiere copiar algunos archivos en los addons de Spoken. Consulta la entrada de Spoken en Supported addons del README.md del addon DialogueUI para saber qué hacer.";
L["Spoken Bridge Missing"] = "|cffff8040El archivo puente aún no está en la carpeta de Spoken.|r Consulta la entrada de Spoken en Supported addons del README.md del addon DialogueUI para saber qué hacer.";
L["AH Bot Buys"] = "El bot de la CS compra";
L["AH Bot Disenchant"] = "Desencantar (bot de la CS)";
L["AH Bot Disenchant Skill"] = "Desencantar |cff808080(Encantamiento %d)|r";
L["AH Bot BiS Bonus"] = "Bonificación BiS";

-- Settings: Compatibility
L["Compatibility"] = "Compatibilidad";
L["Disable DUI In Instance"] = "Usar IU predeterminada de WoW en instancias";
L["Disable DUI In Instance Desc"] = "Desactiva DialogueUI y usa la IU predeterminada de WoW en calabozos o bandas.";

-- Settings: Minimap tab and minimap button
L["Show Minimap Button"] = "Mostrar botón del minimapa";
L["Show Minimap Button Desc"] = "Muestra un botón en el minimapa que abre estos ajustes. Arrástralo para moverlo alrededor del minimapa.";
L["Minimap Button Tooltip"] = "Haz clic para abrir los ajustes.";
L["Minimap Button Drag"] = "Arrastra para mover";

-- Settings: UI tab
L["Theme"] = "Tema";
L["Theme Desc"] = "Selecciona un tema de color para la IU.";
L["Loot Theme Desc"] = "Selecciona un tema de color para la IU de botín. Puede ser distinto del tema del resto de la IU.";
L["Theme Brown"] = "Marrón";
L["Theme Dark"] = "Oscuro";
L["Frame Size"] = "Tamaño del marco";
L["Frame Size Desc"] = "Establece el tamaño de la IU de diálogo.\n\nPredeterminado: Mediano";
L["Size Extra Small"] = "Extra pequeño";
L["Size Small"] = "Pequeño";
L["Size Medium"] = "Mediano";
L["Size Large"] = "Grande";
L["Size Very Large"] = "Muy grande";
L["Size Extra Large"] = "Extra grande";
L["Open Animation"] = "Animación de apertura";
L["Open Animation Desc"] = "Cuánto tarda en abrirse la ventana de diálogo. 0s la muestra al instante.\n\nPor defecto: 0,25s";
L["Font Size"] = "Tamaño de fuente";
L["Font Size Desc"] = "Establece el tamaño de la fuente para la IU.\n\nPredeterminado: 12";
L["Font"] = "Fuente";
L["Font Desc"] = "Selecciona la fuente que usa la IU.\n\nFuente predeterminada: Friz Quadrata";
L["Default Font"] = "Fuente predeterminada";
L["System Font"] = "Sistema";
L["Font Missing"] = "La fuente elegida no está disponible, así que se usa la fuente predeterminada.";
L["Font No Shared Media"] = "Instala SharedMedia, o cualquier addon que agregue fuentes mediante LibSharedMedia-3.0, para tener más fuentes aquí.";
L["Frame Orientation"] = "Orientación";
L["Frame Orientation Desc"] = "Coloca la interfaz en el lado izquierdo o derecho de la pantalla.\n\nCon Personalizada puedes arrastrar la interfaz a donde quieras mientras esta ventana esté abierta.\n\nPor defecto: Derecha";
L["Orientation Left"] = "Izquierda";
L["Orientation Right"] = "Derecha";
L["Orientation Custom"] = "Personalizada";
L["Move Position"] = "Mover";
L["Reset Position"] = "Restablecer posición";
L["Move Position Desc"] = "Muestra la interfaz para que puedas arrastrarla a una nueva posición.";
L["Reset Position Desc"] = "Restablece la posición de la interfaz.";
L["Readables Position"] = "Posición";
L["Readables Position Desc"] = "Coloca los textos legibles (libros, cartas, placas) en el lado izquierdo de la pantalla.\n\nCon Personalizada puedes arrastrarlos a donde quieras mientras esta ventana esté abierta.\n\nPor defecto: Predeterminada";
L["Position Default"] = "Predeterminada";
L["Readables Move Position Desc"] = "Muestra un ejemplo para que lo arrastres a una nueva posición.";
L["Readables Reset Position Desc"] = "Restablece la posición del texto legible.";
L["Hide UI"] = "Ocultar IU";
L["Hide UI Desc"] = "Desvanece la IU del juego cuando interactúas con un NPC.";
L["Readables Hide UI Desc"] = "Desvanece la IU del juego mientras lees un libro, una carta o una placa.";
L["Show NPC Name On Page"] = "Mostrar nombre del NPC";
L["Show NPC Name On Page Desc"] = "Muestra el nombre del NPC en la página.";
L["Show Quest Type"] = "Mostrar tipo de misión";
L["Show Quest Type Desc"] = "Muestra el tipo de misión (misión, diaria, semanal, mazmorra, ...) encima del título de la misión.";
L["Show Copy Text Button"] = "Mostrar botón de Copiar texto";
L["Show Copy Text Button Desc"] = "Muestra un botón Copiar texto arriba a la derecha de la interfaz de diálogo.\n\nTambién incluye datos del juego como los ID de PNJ y de objetos (y los ID de las misiones que ya están en tu registro).";
L["Copy Text"] = "Copiar texto";
L["Drag To Move"] = "Haz clic izquierdo y arrastra para mover la ventana.";
L["Edit Mode Title"] = "Dialogue UI";
L["Edit Mode Body"] = "Arrastra esta ventana a donde quieras. Cierra la ventana de ajustes para ocultarla.";

-- Quest types and tags
L["Quest"] = "Misión";
L["Readables"] = "Textos legibles";
L["BookUI Frame Size Desc"] = "Establece el tamaño de la interfaz de libros.\n\nPor defecto: Pequeño";
L["BookUI Keep UI Open"] = "Mantener ventana abierta";
L["BookUI Keep UI Open Desc"] = "Mantiene la ventana abierta al alejarte del objeto.\n\nPulsa Escape o haz clic derecho en la IU para cerrarla.";
L["BookUI Show Location"] = "Mostrar ubicación";
L["BookUI Show Location Desc"] = "Muestra la ubicación del objeto en la cabecera.\n\nSolo funciona para objetos del mundo, no para objetos en bolsas.";
L["BookUI Show Item Description"] = "Mostrar descripción del objeto";
L["BookUI Show Item Description Desc"] = "Muestra la descripción del objeto en la parte superior de la IU.";
L["BookUI Darken Screen"] = "Oscurecer pantalla";
L["BookUI Darken Screen Desc"] = "Oscurece el área debajo de la interfaz para ayudarte a concentrarte en el contenido.";

-- Settings: Control tab (retail enUS where it exists)
L["Input Device"] = "Dispositivo de entrada";
L["Input Device Desc"] = "Afecta a los iconos de teclas de acceso rápido y el diseño de la IU.";
L["Input Device KBM"] = "Teclado y ratón";
L["Use Custom Bindings"] = "Usar asignaciones personalizadas";
L["Use Custom Bindings Desc"] = "Habilita para usar tus propias teclas.";
L["Primary Control Key Desc"] = "Presiona esta tecla para seleccionar la primera opción disponible, como Aceptar misión.";
L["Right Click To Close UI"] = "Clic Derecho para Cerrar la Interfaz";
L["Right Click To Close UI Desc"] = "Haz clic derecho en la interfaz de diálogo para cerrarla.";
L["Press Button To Scroll Down"] = "Desplazar hacia abajo";
L["Press Button To Scroll Down Desc"] = "Si el contenido es más alto que la ventana, presionar el Botón de confirmar desplazará la página hacia abajo en lugar de aceptar la misión.";
L["Press Escape To Decline Quest"] = "Pulsar Escape para rechazar misión";
L["Press Escape To Decline Quest Desc"] = "Al ver una misión, Escape vuelve a la página anterior en lugar de cerrar la IU.";
L["Press Tab To Select Reward"] = "Pulsar Tab para seleccionar recompensa";
L["Press Tab To Select Reward Desc"] = "Pulsa Tab para recorrer las recompensas elegibles al entregar la misión. Mayús+Tab retrocede.";
L["Keybinding Hint"] = "Haz clic y pulsa la tecla que quieras usar.\nClic derecho: volver a la tecla por defecto.\nEsc: cancelar.";
L["Bound To"] = "Asignado a: ";
L["Not Bound"] = NOT_BOUND or "Sin asignar";
L["Action Confirm"] = "Confirmar";
L["Action Settings"] = "Mostrar/Ocultar ajustes";
L["Action Option1"] = "Opción 1";
L["Action Option2"] = "Opción 2";
L["Action Option3"] = "Opción 3";
L["Action Option4"] = "Opción 4";
L["Action Option5"] = "Opción 5";
L["Action Option6"] = "Opción 6";
L["Action Option7"] = "Opción 7";
L["Action Option8"] = "Opción 8";
L["Action Option9"] = "Opción 9";
L["Action Option Desc"] = "Pulsa esta tecla para seleccionar la opción %d de la lista (misiones y opciones de diálogo).";
L["Action Settings Desc"] = "Pulsa esta tecla para abrir o cerrar la ventana de ajustes mientras se muestra el diálogo.";

L["Quest Frequency Daily"] = "Diaria";
L["Quest Frequency Weekly"] = "Semanal";
L["Quest Type Repeatable"] = "Repetible";
L["Quest Difficulty VeryHard"] = "Muy difícil";
L["Quest Difficulty Hard"] = "Difícil";
L["Quest Difficulty Easy"] = "Fácil";
L["Quest Difficulty Trivial"] = "Nivel bajo";
L["Quest Difficulty Option"] = "Dificultad de misión";
L["Instant Quest Text"] = "Texto instantáneo";
L["Instant Quest Text Desc"] = "Muestra el texto de golpe en las páginas de misión y en los textos legibles en lugar de hacerlo aparecer poco a poco. Usa el mismo ajuste del juego que la opción de texto de misión de Blizzard.";
L["Mark Highest Sell Price"] = "Marcar precio de venta más alto";
L["Mark Highest Sell Price Desc"] = "Muestra cuál es el objeto con el precio de venta más alto cuando estás eligiendo una recompensa.";
L["Show Replace Calculations"] = "Mostrar cálculos de reemplazo";
L["Show Replace Calculations Desc"] = "Muestra las diferencias de estadísticas bajo \"Reemplazar\" en el tooltip del objeto. Si está desactivado, solo se muestra la línea de reemplazo con el nombre del objeto equipado.";
L["Use Blizzard Tooltip"] = "Usar Tooltip de Blizzard";
L["Use Blizzard Tooltip Desc"] = "Usa el tooltip de Blizzard para el botón de recompensa de la misión en lugar de nuestro tooltip especial.";
L["Show EXP Bar"] = "Barra de experiencia";
L["Show EXP Bar Desc"] = "Muestra una barra de experiencia en la parte inferior de la pantalla mientras hay una conversación abierta.";
L["Always Show EXP Bar"] = "Mostrar siempre la barra de experiencia";
L["Always Show EXP Bar Desc"] = "Mantiene la barra de experiencia en pantalla cuando no hay ninguna conversación abierta, para poder usarla como tu barra de experiencia.";
L["Color Player Name"] = "Colorear nombre del jugador (solo modo oscuro)";
L["Color Player Name Desc"] = "Muestra el nombre de tu personaje en el texto de misiones y conversaciones con el color de tu clase. Solo en el tema oscuro.";
L["Color Class Name"] = "Colorear nombre de clase (solo modo oscuro)";
L["Color Class Name Desc"] = "Muestra el nombre de tu clase en el texto de misiones y conversaciones con el color de tu clase. Solo en el tema oscuro.";
L["Format Unit Level"] = "Nivel %d";
L["Format Player XP"] = "EXP: %d/%d (%d%%)";
L["Format Gained XP"] = "%d EXP";
L["To Next Level Label"] = "Para el siguiente nivel";
L["Use Separate Tooltip for Comparison"] = "Usar tooltip separado para la comparación";
L["Use Separate Tooltip for Comparison Desc"] = "Muestra el objeto equipado que reemplazarías en un tooltip propio junto al tooltip de la recompensa, con las diferencias de atributos al final. Los anillos, abalorios y armas muestran un tooltip por cada objeto equipado.";
L["Use Separate Tooltip Blizzard Active"] = "No disponible mientras \"%s\" esté activado. Desactiva esa opción para usar esta.";
L["Show Transmog Status"] = "Mostrar apariencias sin coleccionar";
L["Show Transmog Status Desc"] = "Marca los objetos de recompensa cuya apariencia de transfiguración aún no has coleccionado y añade una línea a su descripción emergente.\n\n|cffff8040El servidor debe tener instalado el módulo del sistema de transfiguración (mod-transmog).|r Sin él no se muestra nada.\n\nEl addon ejecuta una vez el comando .transmog sync y oculta su salida en la ventana de chat.";
L["Use Transmog Plus"] = "Usando Mod Transmog Plus";
L["Use Transmog Plus Desc"] = "Marca esta casilla si el servidor usa mod-transmog-plus en lugar del mod-transmog original. El servidor responde entonces por cada objeto y cuenta una apariencia como coleccionada cuando lo está cualquier objeto con el mismo modelo.\n\nDéjala sin marcar para el mod-transmog original.";
L["Transmog Not Collected"] = "Apariencia sin coleccionar";
L["Transmog Module Missing"] = "|cffff8040No se detectó el módulo %s del servidor, por lo que esta opción está desactivada.|r";
L["Click To Copy To Clipboard"] = "Haz clic para copiar al portapapeles";
L["Show Upgrade Arrow"] = "Mostrar flecha de mejora (requiere Pawn)";
L["Show Upgrade Arrow Desc"] = "Muestra una flecha verde %s en un objeto de recompensa si es una mejora para tu personaje según el addon Pawn: el objeto puntúa más que el que llevas equipado en esa ranura en al menos una de tus escalas de Pawn.\n\nLa armadura de un tipo distinto al que llevas equipado (tela en lugar de cuero, por ejemplo) nunca se marca.";
L["Show Upgrade Arrow Pawn Missing"] = "Requiere el addon Pawn (no encontrado).\n\nDescarga: |cff0000ee%s|r\n\nHaz clic en el icono de copiar, pulsa Ctrl+C y pega el enlace en tu navegador.";
L["Quest Difficulty Option Desc"] = "Elige cómo se muestra la dificultad de las misiones cuando el PNJ te ofrece una lista de misiones.";
L["QuestDifficultyStyle Off"] = "NO";
L["QuestDifficultyStyle Off Desc"] = "El nivel y la dificultad de las misiones están ahora ocultos.";
L["QuestDifficultyStyle Level"] = "Nivel";
L["QuestDifficultyStyle Level Desc"] = "Muestra el nivel de la misión a la izquierda de su título.";
L["QuestDifficultyStyle Name"] = "Nombre";
L["QuestDifficultyStyle Both"] = "Ambos";
L["QuestDifficultyStyle Both Desc"] = "Muestra el nivel de la misión a la izquierda de su título y el nombre de la dificultad a la derecha del botón de la misión si el nivel de la misión está fuera del rango recomendado.";
L["QuestDifficultyStyle Name Desc"] = "Muestra el nombre de la dificultad a la derecha del botón de la misión si el nivel de la misión está fuera del rango recomendado.\n(El nivel de la misión es 3 niveles superior o inferior al de tu personaje.)";
L["Quest Type Trivial"] = "Nivel bajo";
L["Quest Type Dungeon"] = "Calabozo";
L["Quest Type Raid"] = "Banda";
L["Quest Type Heroic"] = "Heroica";
L["Quest Type Elite"] = "Élite";
L["Quest Type Group"] = "Grupo";
L["Quest Type PvP"] = "JcJ";

-- Quest text
L["Quest Objectives"] = "Objetivos";
L["Format Suggested Players"] = QUEST_SUGGESTED_GROUP_NUM or "Jugadores sugeridos: [%d]";
L["Quest Accepted Alert"] = ERR_QUEST_ACCEPTED_S or "Misión aceptada: %s";

-- Rewards
L["Reward"] = "Recompensa";
L["Rewards"] = "Recompensas";
L["Reward Choose"] = REWARD_CHOOSE or "Elige tu recompensa:";
L["Reward Choices"] = REWARD_CHOICES or "Podrás elegir una de estas recompensas:";
L["Reward Items"] = REWARD_ITEMS or "También recibirás:";
L["Requirements"] = "Requisitos";
L["Money"] = MONEY or "Dinero";
L["Honor Points"] = "Honor";
L["Arena Points"] = "Puntos de arena";
L["Talent Points"] = "Puntos de talento";
L["Experience"] = "Experiencia";
L["Title"] = "Título";
L["Format Talent Point Row"] = "+%d punto de talento";
L["Format Talent Points Row"] = "+%d puntos de talento";

-- Reward tooltip
L["Show Comparison"] = "Mostrar comparación";
L["Hide Comparison"] = "Ocultar comparación";
L["Sell Price"] = SELL_PRICE or "Precio de venta";
L["Format Item Level"] = ITEM_LEVEL or "Nivel de objeto %d";
L["Format You Have"] = "- Tienes |cffffffff%d|r";
L["Format In Bank"] = " (|cffffffff%d|r en el banco)";
L["Format Replace Item"] = "Reemplazar %s";
L["Equipped Item"] = "objeto equipado";
L["Currently Equipped"] = "Actualmente equipado";
L["Different Item Type"] = "Tipo de objeto distinto al equipado.";
L["Identical Stats"] = "Estadísticas idénticas";
L["Format Reward Title"] = "Se te concederá el título «%s».";
L["Format Reward Honor"] = "Recibirás %d puntos de honor.";
L["Format Reward Talent Point"] = "Recibirás %d punto de talento.";
L["Format Reward Talent Points"] = "Recibirás %d puntos de talento.";
L["Format Reward Arena"] = "Recibirás %d puntos de arena.";
L["Format Reward Experience"] = "Ganarás %d puntos de experiencia%s.";
L["Format Of Your Level"] = " (%d%% de tu nivel)";

-- Quest Item Display
L["Quest Item Display"] = "Mostrar objeto de misión";
L["Quest Item Display Desc"] = "Muestra automáticamente la descripción del objeto de misión y te permite usarlo sin abrir las bolsas.";
L["Quest Item Display Hide Seen"] = "Ignorar objetos vistos";
L["Quest Item Display Hide Seen Desc"] = "Ignora los objetos que han sido descubiertos por alguno de tus personajes.";
L["Quest Item Display Await World Map"] = " Esperar al mapa del mundo";
L["Quest Item Display Await World Map Desc"] = "Al abrir el mapa, oculta temporalmente el visualizador de objetos de misión.";
L["Quest Item Display Reset Position Desc"] = "Restablece la posición de la ventana.";
L["Valuable Reward Popup"] = "Ventana de recompensa valiosa (requiere Pawn)";
L["Valuable Reward Popup Sample"] = "Ventana de recompensa valiosa";
L["Valuable Reward Popup Desc"] = "Cuando una misión te da un objeto que es una mejora para tu personaje según el addon Pawn, muestra un botón que te permite equiparlo directamente.\n\nEl botón está desactivado durante el combate.";
L["Item Equipped"] = "Equipado";
L["Press Key To Use Item"] = "Pulsar para usar";
L["Press Key To Use Item Desc Generic"] = "Pulsa el botón de confirmación (actual: %s) para usar el objeto cuando no estés en combate.";
L["Press Key To Use Item Desc PC"] = "Pulsa la barra espaciadora para usar el objeto fuera de combate.";
L["Click To Read"] = "Clic izquierdo para leer";
L["Begins A Quest"] = "Inicia una misión";

-- Supported addons
L["Format Reward Title Row"] = "Título: %s";
L["On Your Gear List"] = "En tu lista de equipo";
L["Format Exchange It For"] = "Cámbialo por: %s";

-- Settings: Loot UI tab (Experimental) and the Loot UI window
L["Experimental"] = "Experimental";
L["Use Loot UI"] = "Usar Loot UI";
L["Use Loot UI Desc"] = "Sustituye la ventana de botín predeterminada del juego por Loot UI.\n\nLoot UI es una adaptación del Loot UI del addon Plumber de retail.";
L["Loot UI Font Size Desc"] = "Establece el tamaño de la fuente de Loot UI. Es independiente del tamaño de fuente de la pestaña UI.\n\nPredeterminado: 12";
L["Fade Out Delay Per Item"] = "Retraso de desvanecimiento por objeto";
L["Fade Out Delay Per Item Desc"] = "Cuánto tiempo permanece en pantalla la ventana de Loot UI por cada objeto que muestra, además de un tiempo base. Un valor mayor mantiene legibles más tiempo las listas largas.\n\nPredeterminado: 0,25s";
L["Items Per Page"] = "Objetos por página";
L["Items Per Page Desc"] = "Establece cuántos objetos caben en una página de la ventana de Loot UI cuando muestra lo que has recibido. El resto de objetos se muestra en las páginas siguientes.\n\nEsto no afecta a la ventana cuando saqueas manualmente.\n\nPredeterminado: 6";
L["Opacity"] = "Opacidad";
L["Loot UI Opacity Desc"] = "Establece la opacidad del fondo de la ventana de Loot UI cuando muestra lo que has recibido.\n\nEsto no afecta a la ventana cuando saqueas manualmente.\n\nPredeterminado: 50%";
L["Show Number Of Owned Items"] = "Mostrar cantidad de objetos poseídos";
L["Show Number Of Owned Items Desc"] = "Muestra en el icono, dentro de la ventana de Loot UI, cuántas unidades de un objeto posees. El recuento incluye los objetos del banco (el banco cuenta según tu última visita).\n\nPredeterminado: Activado";
L["Fast Loot"] = "Saqueo rápido";
L["Fast Loot Desc"] = "Recoge el botín en cuanto se abre la ventana de saqueo, en lugar de esperar un momento. Solo se aplica si el botín automático del juego está activado o Loot UI lo fuerza.\n\nEl saqueo rápido del addon Plumber.";
L["Grow Upwards"] = "Crecer hacia arriba";
L["Grow Upwards On Desc"] = "Si está activado: la esquina inferior izquierda de la ventana permanece fija y las nuevas notificaciones aparecerán encima de las anteriores.";
L["Grow Upwards Off Desc"] = "Si está desactivado: la esquina superior izquierda de la ventana permanece fija y las nuevas notificaciones aparecerán debajo de las anteriores.";
L["Combine Similar Items"] = "Combinar objetos similares";
L["Combine Similar Items Desc"] = "Muestra objetos similares en una sola fila.\n\nCategorías admitidas:\n\n- Objetos basura\n\nPredeterminado: Activado";
L["Send to Back"] = "Enviar al fondo";
L["Send to Back Desc"] = "Mientras Loot UI muestra lo que has recibido, coloca su ventana detrás del resto de la interfaz.\n\nNo afecta a la ventana cuando saqueas manualmente.\n\nPredeterminado: Desactivado";
L["Loot Under Mouse"] = "Abrir la ventana de botín en el ratón";
L["Loot Under Mouse Desc"] = "Al saquear manualmente, la ventana de botín aparece bajo la posición actual del ratón.\n\nNo afecta a la ventana mientras muestra lo que has recibido.\n\nPredeterminado: Desactivado";
L["Press Key To Take All Items"] = "Presionar tecla para tomar todo";
L["Press Key To Take All Items Desc"] = "Al saquear manualmente, presiona la siguiente tecla para tomar todos los objetos. Mientras la ventana de botín esté abierta, esta tecla no hace nada más, aunque también esté en tu barra de acción.\n\nHaz clic derecho en la tecla para volver a la tecla predeterminada.\n\nPredeterminado: Activado";
L["Hide You Received Text"] = "Ocultar el texto \"Has recibido\"";
L["Hide You Received Text Desc"] = "Oculta el texto \"Has recibido\" sobre la ventana de Loot UI cuando muestra lo que has recibido.\n\nPredeterminado: Desactivado";
L["Show Reputation Changes"] = "Mostrar cambios de reputación";
L["Show Reputation Changes Desc"] = "Muestra cualquier aumento de reputación en la ventana de Loot UI.\n\nPredeterminado: Desactivado";
L["Show Any Money Changes"] = "Mostrar cualquier cambio de oro";
L["Show Any Money Changes Desc"] = "Muestra el dinero que ganas de todas las fuentes (ventas, misiones, correo ...), no solo del botín.\n\nPredeterminado: Desactivado";
L["Show Any Currency Changes"] = "Mostrar cualquier cambio de moneda";
L["Show Any Currency Changes Desc"] = "Muestra los puntos de honor, los puntos de arena y las monedas que obtienes de todas las fuentes, no solo del botín. Solo se muestran las ganancias.\n\n|cffff4800Las monedas que son objetos (como los emblemas) se muestran mientras saqueas como los objetos que son.|r\n\nPredeterminado: Desactivado";
L["You Received"] = "Has recibido";
L["Junk Items"] = "Objetos basura";
L["Take All"] = "Recoger todo";
L["Give To"] = "Dar a";
