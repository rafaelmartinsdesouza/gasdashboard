library(shiny)
#library(shinythemes)
library(plotly)
library(readxl)
library(tidyverse)
#library(shinydashboard)
library(mapview)
library(leaflet)
library(bslib)
library(RColorBrewer)
library(googlesheets4)
library(tidyverse)


#=============================================================================
# Imports das abas da calculadora.
# Importando aba da calculadora de tarifas.
source("calculadora_tarifas/ui.R")
source("calculadora_tarifas/server.R")

# Importando aba de estrutura tarifária.
source("calculadora_faixas/ui.R")
source("calculadora_faixas/server.R")

# Importando aba de comparação de tarifas.
# Comercial
source("comparacao_tarifas_comercial/ui.R")
source("comparacao_tarifas_comercial/server.R")
# Industrial
source("comparacao_tarifas_industrial/ui.R")
source("comparacao_tarifas_industrial/server.R")
# Residencial
source("comparacao_tarifas_residencial/ui.R")
source("comparacao_tarifas_residencial/server.R")


#=============================================================================
# Importando gráficos.
source("graficos.R")


#=============================================================================
# Defina a interface do usuário (UI)
ui <- navbarPage(
  #theme = shinytheme("cerulean"),  # Escolha um tema base
  includeCSS("custom.css"),    # Inclua o CSS customizado
  
  title = "Dashboard do Gás",
  
  # Abertura
  tabPanel("Abertura",
           fluidPage(
             #h2("Contratos Vigentes"),
             tabsetPanel(
               tabPanel("Contratos Vigentes", h3(class = "text-blue", "Número total de contratos vigentes por ano"),
                        plotlyOutput('grafico_vig')  # Onde o gráfico será exibido
               ),
               tabPanel("Vigências por tipo de Comprador", h3(class = "text-blue", "Vigências por tipo de comprador"),
                        plotlyOutput("fig_vigc")  # Onde o gráfico será exibido
               ),   
               tabPanel("Assinaturas", h3(class = "text-blue", "Quantidade de contratos assinados por tipo de comprador"),
                        plotlyOutput("fig_ass")  # Onde o gráfico será exibido
               )
             ))),
  
  # Regulação
  tabPanel("Regulação",
           fluidPage(
             #h2("Conteúdo da Página 2"),
             tabsetPanel(
               tabPanel("Assinaturas", h3(class = "text-blue", "Limite para enquadramento como consumidor livre"),
                        plotlyOutput("fig_cl")  # Onde o gráfico será exibido
               )
             )
           )),
  
  # Oferta e Demanda
  tabPanel("Oferta e Demanda",
           fluidPage(
             #h2("Conteúdo da Página 3"),
             tabsetPanel(
               tabPanel("Oferta Nacional", h3(class = "text-blue", "Oferta nacional"),
                        plotlyOutput("fig_ofertanac")  # Onde o gráfico será exibido
               ),
               tabPanel("Oferta Internacional", h3(class = "text-blue", " Oferta importada"),
                        plotlyOutput("fig_ofertaimp")  # Onde o gráfico será exibido
               ),
               tabPanel("Reservas", h3(class = "text-blue", "Reservas relativas"),
                        plotlyOutput("fig_res_prod")  # Onde o gráfico será exibido
               ),
               tabPanel("Produção", h3(class = "text-blue", "Produção de petróleo e gás natural (2022)"),
                        fluidRow(
                          column(6, plotlyOutput("fig_teste")),   # Coloca o primeiro gráfico na metade esquerda
                          column(6, plotlyOutput("fig_teste1"))   # Coloca o segundo gráfico na metade direita
                        )),
               tabPanel("Oferta Interna", h3(class = "text-blue", "Oferta interna de gás natural"),
                        plotlyOutput("fig_ofertaint")  # Onde o gráfico será exibido
               ),
               tabPanel("Demanda por segmento", h3(class = "text-blue", "Demanda por segmento de consumo"),
                        plotlyOutput("fig_demandaseg")  # Onde o gráfico será exibido
               ),
               tabPanel("Demanda por distribuidora", h3(class = "text-blue", "Demanda por distribuidora (com termelétricas)"),
                        plotlyOutput("fig_demandist")  # Onde o gráfico será exibido
               ),
               tabPanel("Consumo não termelétrico", h3(class = "text-blue", "Consumo por fonte"),
                        plotlyOutput("fig_consumo70")  # Onde o gráfico será exibido
               ),
               tabPanel("Balanço Mensal", h3(class = "text-blue", "Balanço de gás nacional mensal"),
                        plotlyOutput("fig_balanco")  # Onde o gráfico será exibido
               ),
               tabPanel("Balanço Anual", h3(class = "text-blue", "Balanço de gás nacional anual"),
                        plotlyOutput("fig_balanco_anual")  # Onde o gráfico será exibido
               )
             )
           )),
  
  # Comercialização
  tabPanel("Comercialização",
           fluidPage(
             #h2("Conteúdo da Página 4"),
             tabsetPanel(
               tabPanel("Quantidade Contratada por Região", h3(class = "text-blue", "Quantidade contratada diarimente por região"),
                        plotlyOutput("fig_qdcreg")  # Onde o gráfico será exibido
               ),
               tabPanel("Quantidade Contratada por UF", h3(class = "text-blue", "Quantidade contratada diarimente por UF"),
                        plotlyOutput("fig_qdcuf")  # Onde o gráfico será exibido
               ),
               tabPanel("Comercialização entre Produtores", h3(class = "text-blue", "Quantidade diária contratada por fornecedor"),
                        plotlyOutput("fig_qdcfor")  # Onde o gráfico será exibido
               ),
               tabPanel("Contratação das Distribuidoras", h3(class = "text-blue", "Quantidade média diariamente contratada por modalidade de contratação"),
                        plotlyOutput("fig_qdcdist")  # Onde o gráfico será exibido
               ),
               tabPanel("Modalidades de Contratação", h3(class = "text-blue", "Quantidade média diariamente contratada por modalidade de contratação"),
                        plotlyOutput("fig_qdcmod")  # Onde o gráfico será exibido
               ),
             )
           )),
  
  # Distribuição
  tabPanel("Distribuição",
           fluidPage(
             #h2("Conteúdo da Página 4"), htmlOutput("map")
             tabsetPanel(
               tabPanel("Áreas de Concessão", h3(class = "text-blue", "Áreas de concessão"),
                        leafletOutput("map")
               ),
               tabPanel("Extensão das Redes", h3(class = "text-blue", "Extensões das redes de transporte e distribuição"),
                        plotlyOutput("fig_ext")  # Onde o gráfico será exibido
               ),
             )
           )),
  
  # Página 5
  tabPanel("Sobre",
           fluidPage(
             h3(class = "text-blue", "Sobre este dashboard"),
             
             p(class = "text-blue", "Este dashboard foi criado com o objetivo de apresentar dados sobre o mercado de gás no Brasil. Ele foi desenvolvido com o objetivo de promover a abertura do mercado de gás no Brasil e conta com uma série de patrocinadores."),
             
             p(class = "text-blue","Informações sobre os autores podem ser encontradas em:"),
             
             tags$ul(
               tags$li(
                 p(class = "text-blue", 
                   "Joisa Dutra (", 
                   tags$a(href = "https://ceri.fgv.br/equipe/joisa-dutra", "FGV CERI", target = "_blank"), ", ", 
                   tags$a(href = "https://www.linkedin.com/in/joisa-dutra-saraiva-429b735b/", "LinkedIn", target = "_blank"),");"
                 )
               ),
               
               tags$li(
                 p(class = "text-blue", 
                   "Diogo Romeiro (",
                   tags$a(href = "https://ceri.fgv.br/equipe/diogo-lisbona-romeiro", "FGV CERI", target = "_blank"), ", ", 
                   tags$a(href = "https://www.linkedin.com/in/diogo-lisbona-romeiro-913819252/", "LinkedIn", target = "_blank"),");"
                 )
               ),
               
               tags$li(
                 p(class = "text-blue", 
                   "Rafael Martins de Souza (",
                   tags$a(href = "https://ceri.fgv.br/equipe/rafael-martins-de-souza", "FGV CERI", target = "_blank"), ", ", 
                   tags$a(href = "https://www.linkedin.com/in/rafaelmartinsdesouza/", "LinkedIn", target = "_blank"),")."
                 )
               )
             ),
             
             p(class = "text-blue", 
               "Ele também contou com a participação dos seguintes bolsistas de pesquisa."
             ),
             
             tags$ul(
               tags$li(
                 p(class = "text-blue", 
                   "Ícaro Hernandes (",
                   tags$a(href = "https://ceri.fgv.br/equipe/icaro-franco-hernandes", "FGV CERI", target = "_blank"), ", ", 
                   tags$a(href = "https://www.linkedin.com/in/icaro-franco-hernandes/", "LinkedIn", target = "_blank"),");"
                 )
               ),
               
               tags$li(
                 p(class = "text-blue", 
                   "Daniel Almeida (",
                   tags$a(href = "https://ceri.fgv.br/equipe/daniel-de-miranda-almeida", "FGV CERI", target = "_blank"), ", ", 
                   tags$a(href = "https://www.linkedin.com/in/daniel-de-miranda-almeida/", "LinkedIn", target = "_blank"),");"
                 )
               ),
               
               tags$li(
                 p(class = "text-blue", 
                   "Rachel Granville (",
                   tags$a(href = "https://ceri.fgv.br/equipe/rachel-granville-garcia-leal", "FGV CERI", target = "_blank"), ", ", 
                   tags$a(href = "https://www.linkedin.com/in/rachelgranville/", "LinkedIn", target = "_blank"),")."
                 )
               )
             ),
             
             h3(class = "text-blue", "Sobre o FGV CERI"),
             
             p(class = "text-blue", "FGV CERI colabora com o desenvolvimento da regulação econômica no Brasil se valendo de sólidos fundamentos econômicos."),
             
             p(class = "text-blue", "O Centro de Estudos em Regulação e Infraestrutura é a unidade da Fundação Getulio Vargas destinada a pensar, de forma estruturada e com sólidos fundamentos econômicos, a regulação dos setores de infraestrutura no Brasil."),
             
             p(class = "text-blue", "O caráter multidisciplinar da regulação coloca essa instituição em condição privilegiada para contribuir para o desenvolvimento e o fortalecimento da regulação no País."),
             
             p(class = "text-blue", "A regulação tem um papel central na atração de investimentos. Além disso, é protagonista na criação de um ambiente propício para que esses investimentos sejam convertidos em serviços de qualidade a preços competitivos, mas também capazes de garantir a sustentabilidade econômico-financeira de seus prestadores e refletir a alocação de riscos na cadeia de fornecimento."),
             
             p(class = "text-blue", "O FGV CERI compreende os desafios e as oportunidades inerentes ao desenvolvimento dos setores de infraestrutura no Brasil. Por meio de seminários, palestras e encontros realizados por todo o país, do contato com especialistas e imprensa, e da publicação de estudos e resultados de pesquisas aplicadas, apresenta alternativas para problemas-chave e fomenta o debate com as diversas vozes da opinião pública, contribuindo, assim, para o desenvolvimento nacional."),
             
             p(class = "text-blue", 
               "Mais informações podem ser encontradas em ", 
               tags$a(href = "https://ceri.fgv.br/sobre", "https://ceri.fgv.br/sobre", target = "_blank")
             )
           )
  ),
  
  #=============================================================================
  # Abas da calculadora.
  tabPanel("Calculadora de tarifas",
           fluidPage(
             calculadora_tarifas_ui("tarifas_module"),
           )
  ),
  tabPanel("Estrutura tarifária",
           fluidPage(
             calculadora_faixas_ui("faixas_module")
           )
  ),
  tabPanel("Comparação de tarifas",
           fluidPage(
             tabsetPanel(
               tabPanel("Residencial",
                comp_residencial_ui("comp_residencial_module")
               ),
               tabPanel("Industrial",
                comp_industrial_ui("comp_industrial_module")
               ),
               tabPanel("Comercial",
                comp_comercial_ui("comp_comercial_module")
               )
             )
           )
  )
)

#=============================================================================
# Servidor.
server <- function(input, output, session) {
  # Renderize o gráfico na primeira página, opção 1
  output$grafico_vig <- plotly::renderPlotly({
    fig_vig
  })
  
  # Renderize o gráfico na primeira página, opção 1
  output$fig_vigc <- plotly::renderPlotly({
    fig_vigc
  })
  
  # Renderize o gráfico na primeira página, opção 1
  output$fig_ass <- plotly::renderPlotly({
    fig_ass
  })
  
  # Renderize o gráfico na primeira página, opção 1
  output$fig_cl <- plotly::renderPlotly({
    fig_cl
  })
  
  # Renderize o gráfico na primeira página, opção 1
  output$fig_ofertanac <- plotly::renderPlotly({
    fig_ofertanac
  })
  
  # Renderize o gráfico na primeira página, opção 1
  output$fig_ofertaimp <- plotly::renderPlotly({
    fig_ofertaimp
  })
  
  # Renderize o gráfico na primeira página, opção 1
  output$fig_res_prod <- plotly::renderPlotly({
    fig_res_prod
  })
  
  # Renderize o gráfico na primeira página, opção 1
  output$fig_teste <- plotly::renderPlotly({
    fig_teste
  })
  
  # Renderize o gráfico na primeira página, opção 1
  output$fig_teste1 <- plotly::renderPlotly({
    fig_teste1
  })
  
  # Renderize o gráfico na primeira página, opção 1
  output$fig_ofertaint <- plotly::renderPlotly({
    fig_ofertaint
  })
  
  # Renderize o gráfico na primeira página, opção 1
  output$fig_demandaseg <- plotly::renderPlotly({
    fig_demandaseg
  })
  
  # Renderize o gráfico na primeira página, opção 1
  output$fig_demandist <- plotly::renderPlotly({
    fig_demandist
  })
  
  # Renderize o gráfico na primeira página, opção 1
  output$fig_demandist_st <- plotly::renderPlotly({
    fig_demandist_st
  })
  
  # Renderize o gráfico na primeira página, opção 1
  output$fig_consumo70 <- plotly::renderPlotly({
    fig_consumo70
  })
  
  # Renderize o gráfico na primeira página, opção 1
  output$fig_balanco <- plotly::renderPlotly({
    fig_balanco
  })
  
  # Renderize o gráfico na primeira página, opção 1
  output$fig_balanco_anual <- plotly::renderPlotly({
    fig_balanco_anual
  })
  
  # Renderize o gráfico na primeira página, opção 1
  output$fig_qdcreg <- plotly::renderPlotly({
    fig_qdcreg
  })
  
  # Renderize o gráfico na primeira página, opção 1
  output$fig_qdcuf <- plotly::renderPlotly({
    fig_qdcuf
  })
  
  # Renderize o gráfico na primeira página, opção 1
  output$fig_qdcfor <- plotly::renderPlotly({
    fig_qdcfor
  })
  
  # Renderize o gráfico na primeira página, opção 1
  output$fig_qdcdist <- plotly::renderPlotly({
    fig_qdcdist
  })
  
  # Renderize o gráfico na primeira página, opção 1
  output$fig_qdcmod <- plotly::renderPlotly({
    fig_qdcmod
  })
  
  
  # Distribuição
  areas_concedidas <- sf::read_sf('areas_concedidas/areas_concedidas.shp')
  rename(areas_concedidas, Distribuidora = dstrbdr) -> areas_concedidas
  ##tinha esquecido da distribuidora do RN##
  areas_concedidas[14,1] <- "Potigás"
  m <- mapview::mapview(areas_concedidas, zcol = "Distribuidora", layer.name = "Distribuidora")
  output$map <- renderLeaflet({
    m@map
  })
  
  # Renderize o gráfico na primeira página, opção 1
  output$fig_ext <- plotly::renderPlotly({
    fig_ext
  })
  
  #=============================================================================
  # Calculadora de tarifas.
  calculadora_tarifas_server("tarifas_module")
  
  #=============================================================================
  # Estrutura tarifária.
  calculadora_faixas_server("faixas_module")
  
  #=============================================================================
  # Comparação de tarifas.
  
  # Aba de residencial
  comp_residencial_server("comp_residencial_module")
  # Aba de industrial
  comp_industrial_server("comp_industrial_module")
  # Aba de comercial
  comp_comercial_server("comp_comercial_module")
}


#=============================================================================
# Execute o aplicativo
shinyApp(ui, server)