-- Português (Brasil). Strings come from the retail Dialogue UI locale where it has the same text, the rest are written for this port.
if not (GetLocale() == "ptBR") then return end;

local _, addon = ...;
local L = addon.L;

-- Blizzard's own global strings are used where they exist (they follow the client language). The text below is the fallback.

-- Footer buttons
L["Accept"] = ACCEPT or "Aceitar";
L["Restart Quest"] = "Reiniciar";
L["Continue"] = CONTINUE or "Continuar";
L["Complete Quest"] = COMPLETE or "Missão completa";
L["Incomplete"] = INCOMPLETE or "Incompleta";
L["Decline"] = DECLINE or "Recusar";
L["Cancel"] = CANCEL or "Cancelar";
L["Goodbye"] = GOODBYE or "Até logo";

-- Settings window
L["UI"] = "Interface";
L["Control"] = "Controle";
L["Gameplay"] = "Jogabilidade";
L["Audio"] = "Áudio";
L["Minimap"] = "Minimapa";
L["Other Addons"] = "Outros addons";

-- Settings: Audio tab
L["Enable Audio Fading"] = "Ativar atenuação de áudio";
L["Enable Audio Fading Desc"] = "Reduz os volumes do jogo enquanto a janela de diálogo ou um texto legível está aberto. Ao fechar, eles voltam gradualmente aos volumes definidos nas opções de áudio do jogo.";
L["Sound Fade Volume"] = "Volume dos efeitos na leitura";
L["Sound Fade Volume Desc"] = "O volume dos efeitos sonoros para o qual atenuar durante a leitura. Um volume que já está mais baixo não é aumentado.";
L["Sound Fade Duration"] = "Duração da atenuação dos efeitos";
L["Sound Fade Duration Desc"] = "Quanto tempo os efeitos sonoros levam para baixar e voltar a subir.\n\nPadrão: 0,5s";
L["Music Fade Volume"] = "Volume da música na leitura";
L["Music Fade Volume Desc"] = "O volume da música para o qual atenuar durante a leitura. Um volume que já está mais baixo não é aumentado.";
L["Music Fade Duration"] = "Duração da atenuação da música";
L["Music Fade Duration Desc"] = "Quanto tempo a música leva para baixar e voltar a subir.\n\nPadrão: 0,5s";
L["Ambiance Fade Volume"] = "Volume do ambiente na leitura";
L["Ambiance Fade Volume Desc"] = "O volume do ambiente para o qual atenuar durante a leitura. Um volume que já está mais baixo não é aumentado.";
L["Ambiance Fade Duration"] = "Duração da atenuação do ambiente";
L["Ambiance Fade Duration Desc"] = "Quanto tempo o som ambiente leva para baixar e voltar a subir.\n\nPadrão: 0,5s";
L["Audio Fade Music Spoken"] = "|cffff8040O Spoken reproduz suas vozes no canal de música, por isso o volume da música não é alterado.|r";

-- Settings: Other Addons tab
L["Tooltip"] = "Dica de item";
L["Auction House"] = "Casa de Leilões";
L["Auction House Desc"] = "Adiciona à dica do item os preços da casa de leilões de outro addon instalado. Escolha qual abaixo.";
L["Auction House Auctionator Desc"] = "Auctionator: o preço de leilão, o preço mediano e o valor de desencantamento do item, como o Auctionator os mostra nas próprias dicas. As linhas seguem as opções de dica do Auctionator.";
L["Auction House RetailAH Desc"] = "Retail Auction House (mod-retail-ah): quanto o comprador bot da casa de leilões do servidor paga pelo item (o total da pilha, no caso de uma pilha) e o valor médio dos materiais de um desencantamento. O melhor dos dois fica em verde.\n\nNada é mostrado para um item vinculado, e a linha de desencantamento fica cinza se o seu Encantamento for baixo demais. O servidor precisa executar o módulo mod-retail-ah.";
L["Journal Gear Desc"] = "Adiciona a linha \"Na sua lista de equipamentos\" à dica dos itens que são uma melhoria para a sua especialização, do addon Journal: Gear (JournalGearBIS).";
L["Addon Not Installed"] = "|cffff8040%s não está instalado ou carregado, então este suporte não vai funcionar.|r Instale-o e recarregue a interface (/reload).";
L["Spoken Buttons"] = "Botões do Spoken";
L["Spoken Buttons Desc"] = "Adiciona os botões Reproduzir e Pular do Spoken à janela de missões e conversas e à visualização de livros, que ficariam sem eles enquanto o DialogueUI oculta a interface do jogo.\n\nÉ preciso copiar alguns arquivos para os addons do Spoken. Veja a entrada do Spoken em Supported addons no README.md do addon DialogueUI para saber o que fazer.";
L["Spoken Bridge Missing"] = "|cffff8040O arquivo de ligação ainda não está na pasta do Spoken.|r Veja a entrada do Spoken em Supported addons no README.md do addon DialogueUI para saber o que fazer.";
L["AH Bot Buys"] = "Bot da CL compra";
L["AH Bot Disenchant"] = "Desencantar (bot da CL)";
L["AH Bot Disenchant Skill"] = "Desencantar |cff808080(Encantamento %d)|r";
L["AH Bot BiS Bonus"] = "Bônus BiS";

-- Settings: Compatibility
L["Compatibility"] = "Compatibilidade";
L["Disable DUI In Instance"] = "Usa a interface padrão do WoW em instâncias";
L["Disable DUI In Instance Desc"] = "Desabilita o Dialogue UI e usa a interface padrão do WoW quando você estiver em uma masmorra ou raide.";

-- Settings: Minimap tab and minimap button
L["Show Minimap Button"] = "Mostrar botão do minimapa";
L["Show Minimap Button Desc"] = "Mostra um botão no minimapa que abre estas configurações. Arraste-o para movê-lo ao redor do minimapa.";
L["Minimap Button Tooltip"] = "Clique para abrir as configurações.";
L["Minimap Button Drag"] = "Arraste para mover";

-- Settings: UI tab
L["Theme"] = "Tema";
L["Theme Desc"] = "Selecione a cor do tema para a interface.";
L["Loot Theme Desc"] = "Selecione a cor do tema para a interface de saque. Ela pode ser diferente do tema do resto da interface.";
L["Theme Brown"] = "Marrom";
L["Theme Dark"] = "Escuro";
L["Frame Size"] = "Tamanho da janela";
L["Frame Size Desc"] = "Define o tamanho da interface de diálogo.\n\nPadrão: Médio.";
L["Size Extra Small"] = "Extra Pequeno";
L["Size Small"] = "Pequeno";
L["Size Medium"] = "Médio";
L["Size Large"] = "Grande";
L["Size Very Large"] = "Muito Grande";
L["Size Extra Large"] = "Extra Grande";
L["Open Animation"] = "Animação de abertura";
L["Open Animation Desc"] = "Quanto tempo a janela de diálogo leva para abrir. 0s a mostra de uma vez.\n\nPadrão: 0,25s";
L["Font Size"] = "Tamanho da fonte";
L["Font Size Desc"] = "Define o tamanho da fonte para a interface.\n\nPadrão: 12.";
L["Font"] = "Fonte";
L["Font Desc"] = "Seleciona a fonte usada pela interface.\n\nFonte padrão: Friz Quadrata";
L["Default Font"] = "Fonte padrão";
L["System Font"] = "Sistema";
L["Font Missing"] = "A fonte escolhida não está disponível, então a fonte padrão é usada.";
L["Font No Shared Media"] = "Instale o SharedMedia, ou qualquer addon que adicione fontes pelo LibSharedMedia-3.0, para ter mais fontes aqui.";
L["Frame Orientation"] = "Orientação";
L["Frame Orientation Desc"] = "Coloque a interface no lado esquerdo ou direito da tela.\n\nPersonalizada permite arrastar a interface para qualquer lugar enquanto esta janela estiver aberta.\n\nPadrão: Direita";
L["Orientation Left"] = "Esquerda";
L["Orientation Right"] = "Direita";
L["Orientation Custom"] = "Personalizada";
L["Move Position"] = "Mover";
L["Reset Position"] = "Redefinir posição";
L["Move Position Desc"] = "Mostra a interface para que você possa arrastá-la para uma nova posição.";
L["Reset Position Desc"] = "Redefine a posição da interface.";
L["Readables Position"] = "Posição";
L["Readables Position Desc"] = "Coloque os textos legíveis (livros, cartas, placas) no lado esquerdo da tela.\n\nPersonalizada permite arrastá-los para qualquer lugar enquanto esta janela estiver aberta.\n\nPadrão: Padrão";
L["Position Default"] = "Padrão";
L["Readables Move Position Desc"] = "Mostra um exemplo para você arrastar para uma nova posição.";
L["Readables Reset Position Desc"] = "Redefine a posição do texto legível.";
L["Hide UI"] = "Esconder interface";
L["Hide UI Desc"] = "Esconde a interface do jogo quando você interagir com um NPC.";
L["Readables Hide UI Desc"] = "Esconde a interface do jogo enquanto você lê um livro, uma carta ou uma placa.";
L["Show NPC Name On Page"] = "Mostrar nome do NPC";
L["Show NPC Name On Page Desc"] = "Mostra o nome do NPC na página.";
L["Show Quest Type"] = "Mostrar tipo de missão";
L["Show Quest Type Desc"] = "Mostra o tipo de missão (missão, diária, semanal, masmorra, ...) acima do título da missão.";
L["Show Copy Text Button"] = "Mostrar botão de copiar texto";
L["Show Copy Text Button Desc"] = "Mostra um botão Copiar texto no canto superior direito da interface de diálogo.\n\nTambém inclui dados do jogo, como IDs de NPCs e de itens (e IDs de missões que já estão no seu diário).";
L["Copy Text"] = "Copiar texto";
L["Drag To Move"] = "Cliq. esquerdo e arraste para mover a janela.";
L["Edit Mode Title"] = "Dialogue UI";
L["Edit Mode Body"] = "Arraste esta janela para onde quiser. Feche a janela de configurações para ocultá-la.";

-- Quest types and tags
L["Quest"] = "Missão";
L["Readables"] = "Legíveis";
L["BookUI Frame Size Desc"] = "Define o tamanho da interface de livros.\n\nPadrão: Pequeno";
L["BookUI Keep UI Open"] = "Manter janela aberta";
L["BookUI Keep UI Open Desc"] = "Mantém a janela aberta quando você se mover para longe de um objeto legível.\n\nPressione ESC ou clique com o botão direito do mouse na interface para fechá-la.";
L["BookUI Show Location"] = "Mostrar localização";
L["BookUI Show Location Desc"] = "Mostra a localização do objeto no cabeçalho.\n\nFunciona apenas para objetos no mundo, e não itens em suas bolsas.";
L["BookUI Show Item Description"] = "Mostrar descrição de itens";
L["BookUI Show Item Description Desc"] = "Exibe a descrição do item no topo da interface, caso haja alguma descrição.";
L["BookUI Darken Screen"] = "Escurecer tela";
L["BookUI Darken Screen Desc"] = "Escurece a tela abaixo da interface para ajudar você a se concentrar no conteúdo.";

-- Settings: Control tab (retail enUS where it exists)
L["Input Device"] = "Dispositivo de entrada";
L["Input Device Desc"] = "Afeta ícones de teclas de atalho e layout da interface.";
L["Input Device KBM"] = "Teclado e mouse";
L["Use Custom Bindings"] = "Use atalhos personalizados";
L["Use Custom Bindings Desc"] = "Habilite esta opção para usar seus próprios atalhos.";
L["Primary Control Key Desc"] = "Pressione esta tecla para selecionar a primeira opção disponível, como Aceitar Missão.";
L["Right Click To Close UI"] = "Cliq. direito para fechar a interface";
L["Right Click To Close UI Desc"] = "Clique com o direito do mouse na interface de diálogo para fechá-la.";
L["Press Button To Scroll Down"] = "Use um botão para rolar pra baixo";
L["Press Button To Scroll Down Desc"] = "Se o conteúdo for maior que a área de visualização, pressionar o Botão de Confirmar fará a página rolar para baixo em vez de aceitar a missão.";
L["Press Escape To Decline Quest"] = "Aperte ESC para recusar missão";
L["Press Escape To Decline Quest Desc"] = "Quando estiver vendo uma missão de um NPC que possui outros diálogos, pressionar a tecla ESC voltará a página em vez de fechar a interface de missão.";
L["Press Tab To Select Reward"] = "Aperte Tab para selecionar uma recompensa";
L["Press Tab To Select Reward Desc"] = "Pressione Tab para alternar entre as recompensas escolhíveis ao entregar a missão. Shift+Tab volta.";
L["Keybinding Hint"] = "Clique e pressione a tecla que deseja usar.\nClique direito: voltar à tecla padrão.\nEsc: cancelar.";
L["Bound To"] = "Vinculado a: ";
L["Not Bound"] = NOT_BOUND or "Não vinculado";
L["Action Confirm"] = "Confirmar";
L["Action Settings"] = "Abrir configurações";
L["Action Option1"] = "Opção 1";
L["Action Option2"] = "Opção 2";
L["Action Option3"] = "Opção 3";
L["Action Option4"] = "Opção 4";
L["Action Option5"] = "Opção 5";
L["Action Option6"] = "Opção 6";
L["Action Option7"] = "Opção 7";
L["Action Option8"] = "Opção 8";
L["Action Option9"] = "Opção 9";
L["Action Option Desc"] = "Pressione esta tecla para selecionar a opção %d da lista (missões e opções de diálogo).";
L["Action Settings Desc"] = "Pressione esta tecla para abrir ou fechar a janela de configurações enquanto o diálogo é exibido.";

L["Quest Frequency Daily"] = "Diária";
L["Quest Frequency Weekly"] = "Semanal";
L["Quest Type Repeatable"] = "Repetível";
L["Quest Difficulty VeryHard"] = "Muito difícil";
L["Quest Difficulty Hard"] = "Difícil";
L["Quest Difficulty Easy"] = "Fácil";
L["Quest Difficulty Trivial"] = "Nível baixo";
L["Quest Difficulty Option"] = "Dificuldade da missão";
L["Instant Quest Text"] = "Texto instantâneo";
L["Instant Quest Text Desc"] = "Mostra o texto de uma vez nas páginas de missão e nos legíveis em vez de exibi-lo aos poucos. Usa a mesma configuração do jogo que a opção de texto de missão da Blizzard.";
L["Mark Highest Sell Price"] = "Marcar maior preço de venda";
L["Mark Highest Sell Price Desc"] = "Mostra qual item tem o maior preço de venda ao escolher uma recompensa.";
L["Show Replace Calculations"] = "Mostrar cálculos de substituição";
L["Show Replace Calculations Desc"] = "Mostra as diferenças de atributos sob \"Substituir\" na dica do item. Desativado, mostra apenas a linha de substituição com o nome do item equipado.";
L["Use Blizzard Tooltip"] = "Usar dica de ferramenta da Blizzard";
L["Use Blizzard Tooltip Desc"] = "Usa a dica de ferramenta da Blizzard para o botão de recompensa de missão em vez da nossa dica de ferramenta especial.";
L["Show EXP Bar"] = "Barra de experiência";
L["Show EXP Bar Desc"] = "Mostra uma barra de experiência na parte inferior da tela enquanto uma conversa está aberta.";
L["Always Show EXP Bar"] = "Sempre mostrar a barra de experiência";
L["Always Show EXP Bar Desc"] = "Mantém a barra de experiência na tela quando nenhuma conversa está aberta, para que possa ser usada como sua barra de experiência.";
L["Color Player Name"] = "Colorir nome do jogador (somente modo escuro)";
L["Color Player Name Desc"] = "Mostra o nome do seu personagem no texto de missões e conversas com a cor da sua classe. Somente no tema escuro.";
L["Color Class Name"] = "Colorir nome da classe (somente modo escuro)";
L["Color Class Name Desc"] = "Mostra o nome da sua classe no texto de missões e conversas com a cor da sua classe. Somente no tema escuro.";
L["Format Unit Level"] = "Nível %d";
L["Format Player XP"] = "XP: %d/%d (%d%%)";
L["Format Gained XP"] = "%d XP";
L["To Next Level Label"] = "Para o próximo nível";
L["Use Separate Tooltip for Comparison"] = "Usar dica separada para comparação";
L["Use Separate Tooltip for Comparison Desc"] = "Mostra o item equipado que você substituiria em uma dica própria ao lado da dica da recompensa, com as diferenças de atributos no final. Anéis, berloques e armas mostram uma dica para cada item equipado.";
L["Use Separate Tooltip Blizzard Active"] = "Indisponível enquanto \"%s\" estiver ativado. Desative essa opção para usar esta.";
L["Show Transmog Status"] = "Mostrar aparências não coletadas";
L["Show Transmog Status Desc"] = "Marca os itens de recompensa cuja aparência de transmogrificação você ainda não coletou e adiciona uma linha à dica deles.\n\n|cffff8040O servidor precisa ter o módulo do sistema de transmogrificação (mod-transmog) instalado.|r Sem ele, nada é exibido.\n\nO addon executa o comando .transmog sync uma vez e oculta a saída dele na janela de bate-papo.";
L["Use Transmog Plus"] = "Usando Mod Transmog Plus";
L["Use Transmog Plus Desc"] = "Marque esta opção se o servidor usa o mod-transmog-plus em vez do mod-transmog original. O servidor então responde para cada item e conta uma aparência como coletada quando qualquer item com o mesmo modelo foi coletado.\n\nDeixe desmarcada para o mod-transmog original.";
L["Transmog Not Collected"] = "Aparência não coletada";
L["Transmog Module Missing"] = "|cffff8040O módulo %s do servidor não foi detectado, então esta opção está desativada.|r";
L["Click To Copy To Clipboard"] = "Clique para copiar para a área de transferência";
L["Show Upgrade Arrow"] = "Mostrar seta de melhoria (requer Pawn)";
L["Show Upgrade Arrow Desc"] = "Mostra uma seta verde %s em um item de recompensa se ele for uma melhoria para o seu personagem, de acordo com o addon Pawn: o item tem pontuação maior que o equipado nesse espaço em pelo menos uma das suas escalas do Pawn.\n\nArmaduras de um tipo diferente do equipado (tecido em vez de couro, por exemplo) nunca são marcadas.";
L["Show Upgrade Arrow Pawn Missing"] = "Requer o addon Pawn (não encontrado).\n\nDownload: |cff0000ee%s|r\n\nClique no ícone de copiar, pressione Ctrl+C e cole o link no seu navegador.";
L["Quest Difficulty Option Desc"] = "Escolha como a dificuldade das missões é exibida quando o NPC oferece uma lista de missões.";
L["QuestDifficultyStyle Off"] = "DESLIGADO";
L["QuestDifficultyStyle Off Desc"] = "O nível e a dificuldade das missões agora estão ocultos.";
L["QuestDifficultyStyle Level"] = "Nível";
L["QuestDifficultyStyle Level Desc"] = "Mostra o nível da missão à esquerda do título dela.";
L["QuestDifficultyStyle Name"] = "Nome";
L["QuestDifficultyStyle Both"] = "Ambos";
L["QuestDifficultyStyle Both Desc"] = "Mostra o nível da missão à esquerda do título e o nome da dificuldade à direita do botão da missão se o nível da missão estiver fora da faixa recomendada.";
L["QuestDifficultyStyle Name Desc"] = "Mostra o nome da dificuldade à direita do botão da missão se o nível da missão estiver fora da faixa recomendada.\n(O nível da missão é 3 níveis acima ou abaixo do nível do seu personagem.)";
L["Quest Type Trivial"] = "Trivial";
L["Quest Type Dungeon"] = "Masmorra";
L["Quest Type Raid"] = "Raide";
L["Quest Type Heroic"] = "Heroica";
L["Quest Type Elite"] = "Elite";
L["Quest Type Group"] = "Grupo";
L["Quest Type PvP"] = "JxJ";

-- Quest text
L["Quest Objectives"] = "Objetivos";
L["Format Suggested Players"] = QUEST_SUGGESTED_GROUP_NUM or "Jogadores sugeridos [%d]";
L["Quest Accepted Alert"] = ERR_QUEST_ACCEPTED_S or "Missão aceita: %s";

-- Rewards
L["Reward"] = "Recompensa";
L["Rewards"] = "Recompensas";
L["Reward Choose"] = REWARD_CHOOSE or "Escolha sua recompensa:";
L["Reward Choices"] = REWARD_CHOICES or "Você poderá escolher uma destas recompensas:";
L["Reward Items"] = REWARD_ITEMS or "Você também receberá:";
L["Requirements"] = "Requisitos";
L["Money"] = MONEY or "Dinheiro";
L["Honor Points"] = "Honra";
L["Arena Points"] = "Pontos de arena";
L["Talent Points"] = "Pontos de talento";
L["Experience"] = "Experiência";
L["Title"] = "Título";
L["Format Talent Point Row"] = "+%d ponto de talento";
L["Format Talent Points Row"] = "+%d pontos de talento";

-- Reward tooltip
L["Show Comparison"] = "Mostrar comparação";
L["Hide Comparison"] = "Esconder comparação";
L["Sell Price"] = SELL_PRICE or "Preço de venda";
L["Format Item Level"] = ITEM_LEVEL or "Nível de item %d";
L["Format You Have"] = "- Você tem |cffffffff%d|r";
L["Format In Bank"] = " (|cffffffff%d|r no banco)";
L["Format Replace Item"] = "Substituir %s";
L["Equipped Item"] = "item equipado";
L["Currently Equipped"] = "Atualmente equipado";
L["Different Item Type"] = "Tipo de item diferente do equipado.";
L["Identical Stats"] = "Atributos idênticos";
L["Format Reward Title"] = "Você receberá o título «%s».";
L["Format Reward Honor"] = "Você receberá %d pontos de honra.";
L["Format Reward Talent Point"] = "Você receberá %d ponto de talento.";
L["Format Reward Talent Points"] = "Você receberá %d pontos de talento.";
L["Format Reward Arena"] = "Você receberá %d pontos de arena.";
L["Format Reward Experience"] = "Você ganhará %d pontos de experiência%s.";
L["Format Of Your Level"] = " (%d%% do seu nível)";

-- Quest Item Display
L["Quest Item Display"] = "Exibição de Itens de Missão";
L["Quest Item Display Desc"] = "Exibe automaticamente a descrição do item de missão e permite que você o use sem abrir as bolsas.";
L["Quest Item Display Hide Seen"] = "Ignorar itens vistos";
L["Quest Item Display Hide Seen Desc"] = "Ignora itens que já foram descobertos por qualquer um de seus personagens.";
L["Quest Item Display Await World Map"] = "Esperar mapa mundial";
L["Quest Item Display Await World Map Desc"] = "Quando você abrir o mapa mundial, oculte temporariamente a exibição de Itens de Missão e pause o temporizador de fechamento automático.";
L["Quest Item Display Reset Position Desc"] = "Redefine a posição da janela.";
L["Valuable Reward Popup"] = "Janela de recompensa valiosa (requer Pawn)";
L["Valuable Reward Popup Sample"] = "Janela de recompensa valiosa";
L["Valuable Reward Popup Desc"] = "Quando uma missão dá um item que é uma melhoria para o seu personagem, de acordo com o addon Pawn, mostra um botão que permite equipá-lo diretamente.\n\nO botão fica desativado durante o combate.";
L["Item Equipped"] = "Equipado";
L["Press Key To Use Item"] = "Pressione para usar";
L["Press Key To Use Item Desc Generic"] = "Pressione o botão de confirmação (atual: %s) para usar o item quando estiver fora de combate.";
L["Press Key To Use Item Desc PC"] = "Pressione Espaço para usar o item fora de combate.";
L["Click To Read"] = "Cliq. esquerdo para ler";
L["Begins A Quest"] = "Inicia uma missão";

-- Supported addons
L["Format Reward Title Row"] = "Título: %s";
L["On Your Gear List"] = "Na sua lista de equipamento";
L["Format Exchange It For"] = "Troque por: %s";

-- Settings: Loot UI tab (Experimental) and the Loot UI window
L["Experimental"] = "Experimental";
L["Use Loot UI"] = "Usar Loot UI";
L["Use Loot UI Desc"] = "Substitui a janela de saque padrão do jogo pelo Loot UI.\n\nO Loot UI é uma adaptação do Loot UI do addon Plumber do retail.";
L["Loot UI Font Size Desc"] = "Define o tamanho da fonte do Loot UI. Ele é independente do tamanho da fonte da aba Interface.\n\nPadrão: 12";
L["Fade Out Delay Per Item"] = "Atraso de desaparecimento por item";
L["Fade Out Delay Per Item Desc"] = "Por quanto tempo a janela do Loot UI permanece na tela para cada item exibido, além de um tempo base. Um valor maior mantém listas longas legíveis por mais tempo.\n\nPadrão: 0,25s";
L["Items Per Page"] = "Itens por página";
L["Items Per Page Desc"] = "Define quantos itens cabem em uma página da janela do Loot UI quando ela mostra o que você recebeu. Os demais itens aparecem nas páginas seguintes.\n\nIsso não afeta a janela quando você saqueia manualmente.\n\nPadrão: 6";
L["Opacity"] = "Opacidade";
L["Loot UI Opacity Desc"] = "Define a opacidade do fundo da janela do Loot UI quando ela mostra o que você recebeu.\n\nIsso não afeta a janela quando você saqueia manualmente.\n\nPadrão: 50%";
L["Show Number Of Owned Items"] = "Mostrar quantidade de itens possuídos";
L["Show Number Of Owned Items Desc"] = "Mostra no ícone, na janela do Loot UI, quantas unidades de um item você possui. A contagem inclui os itens do seu banco (o banco é contado como estava na sua última visita).\n\nPadrão: Ativado";
L["Fast Loot"] = "Saque rápido";
L["Fast Loot Desc"] = "Pega o saque assim que a janela de saque abre, em vez de esperar um instante. Só vale quando o saque automático do jogo está ativado ou o Loot UI o força.\n\nO saque rápido do addon Plumber.";
L["Grow Upwards"] = "Crescer para cima";
L["Grow Upwards On Desc"] = "Quando habilitado: a parte inferior esquerda da janela fica fixada, e novas notificações aparecerão no topo das antigas.";
L["Grow Upwards Off Desc"] = "Quando desabilitado: a parte superior esquerda da janela fica fixada, e novas notificações aparecerão na parte inferior das antigas.";
L["Combine Similar Items"] = "Combinar itens similares";
L["Combine Similar Items Desc"] = "Exibe itens similares em uma única linha.\n\nCategorias suportadas:\n\n- Itens inúteis\n\nPadrão: Ativado";
L["Send to Back"] = "Colocar no fundo";
L["Send to Back Desc"] = "Enquanto o Loot UI mostra o que você recebeu, coloca a janela dele atrás de outras interfaces.\n\nIsso não afeta a janela durante o saque manual.\n\nPadrão: Desativado";
L["Loot Under Mouse"] = "Abrir a janela de saque no mouse";
L["Loot Under Mouse Desc"] = "Durante o saque manual, a janela de saque aparece sob a posição atual do mouse.\n\nIsso não afeta a janela enquanto ela mostra o que você recebeu.\n\nPadrão: Desativado";
L["Press Key To Take All Items"] = "Pressionar tecla para pegar tudo";
L["Press Key To Take All Items Desc"] = "Durante o saque manual, pressione a tecla a seguir para pegar todos os itens. Enquanto a janela de saque estiver aberta, essa tecla não faz mais nada, mesmo que também esteja na sua barra de ação.\n\nClique com o botão direito na tecla para voltar à tecla padrão.\n\nPadrão: Ativado";
L["Hide You Received Text"] = "Ocultar o texto \"Você recebeu\"";
L["Hide You Received Text Desc"] = "Oculta o texto \"Você recebeu\" acima da janela do Loot UI quando ela mostra o que você recebeu.\n\nPadrão: Desativado";
L["Show Reputation Changes"] = "Exibir mudanças de reputação";
L["Show Reputation Changes Desc"] = "Exibe qualquer aumento de reputação na janela do Loot UI.\n\nPadrão: Desativado";
L["Show Any Money Changes"] = "Exibir mudanças de dinheiro";
L["Show Any Money Changes Desc"] = "Exibe o dinheiro que você ganha de todas as fontes (vendas, missões, correio ...), não apenas de saque.\n\nPadrão: Desativado";
L["Show Any Currency Changes"] = "Exibir mudanças de moedas";
L["Show Any Currency Changes Desc"] = "Exibe os pontos de honra, os pontos de arena e as moedas que você ganha de todas as fontes, não apenas de saque. Apenas ganhos são exibidos.\n\n|cffff4800Moedas que são itens (como Emblemas) são exibidas durante o saque como os itens que são.|r\n\nPadrão: Desativado";
L["You Received"] = "Você recebeu";
L["Junk Items"] = "Itens inúteis";
L["Take All"] = "Pegar tudo";
L["Give To"] = "Dar para";
