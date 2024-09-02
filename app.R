library(shiny)
library(plotly)
library(readxl)
library(tidyverse)
#library(shinydashboard)
library(mapview)
library(leaflet)

source("graficos.R")

# Defina a interface do usuário (UI)
ui <- navbarPage(
  title = "Dashboard do Gás",
  
  # Abertura
  tabPanel("Abertura",
           fluidPage(
             #h2("Contratos Vigentes"),
             tabsetPanel(
               tabPanel("Contratos Vigentes",
                        plotlyOutput("grafico_vig")  # Onde o gráfico será exibido
               ),
               tabPanel("Vigências por tipo de Comprador",
                        plotlyOutput("fig_vigc")  # Onde o gráfico será exibido
               ),   
               tabPanel("Assinaturas",
                        plotlyOutput("fig_ass")  # Onde o gráfico será exibido
               )
           ))),
  
  # Regulação
  tabPanel("Regulação",
           fluidPage(
             #h2("Conteúdo da Página 2"),
             tabsetPanel(
             tabPanel("Assinaturas",
                      plotlyOutput("fig_cl")  # Onde o gráfico será exibido
             )
             )
           )),
  
  # Oferta e Demanda
  tabPanel("Oferta e Demanda",
           fluidPage(
             #h2("Conteúdo da Página 3"),
             tabsetPanel(
               tabPanel("Oferta Nacional",
                        plotlyOutput("fig_ofertanac")  # Onde o gráfico será exibido
               ),
               tabPanel("Oferta Internacional",
                        plotlyOutput("fig_ofertaimp")  # Onde o gráfico será exibido
               ),
               tabPanel("Reservas",
                        plotlyOutput("fig_res_prod")  # Onde o gráfico será exibido
               ),
               tabPanel("Produção", p("Produção de Petróleo e Gás Natural (2022)"),
                        fluidRow(
                          column(6, plotlyOutput("fig_teste")),   # Coloca o primeiro gráfico na metade esquerda
                          column(6, plotlyOutput("fig_teste1"))   # Coloca o segundo gráfico na metade direita
                        )),
               tabPanel("Oferta Interna", p("Oferta Interna de Gás Natural"),
                        plotlyOutput("fig_ofertaint")  # Onde o gráfico será exibido
               ),
               tabPanel("Demanda", p("Demanda por segmento de consumo"),
                        plotlyOutput("fig_demandaseg")  # Onde o gráfico será exibido
               ),
               tabPanel("Demanda por distribuidora", p("Demanda por distribuidora (com termelétricas)"),
                        plotlyOutput("fig_demandist")  # Onde o gráfico será exibido
               ),
               tabPanel("Consumo não termelétrico", p("Consumo por fonte"),
                        plotlyOutput("fig_consumo70")  # Onde o gráfico será exibido
               ),
               tabPanel("Balanço Mensal", p("Balanço de Gás Nacional Mensal"),
                        plotlyOutput("fig_balanco")  # Onde o gráfico será exibido
               ),
               tabPanel("Balanço Anual", p("Balanço de Gás Nacional Anual"),
                        plotlyOutput("fig_balanco_anual")  # Onde o gráfico será exibido
               )
             )
           )),
  
  # Comercialização
  tabPanel("Comercialização",
           fluidPage(
             #h2("Conteúdo da Página 4"),
             tabsetPanel(
               tabPanel("# Contratada por Região", p("Quantidade Contratada Diarimente por Região"),
                        plotlyOutput("fig_qdcreg")  # Onde o gráfico será exibido
               ),
               tabPanel("# Contratada por UF", p("Quantidade Contratada Diarimente por UF"),
                        plotlyOutput("fig_qdcuf")  # Onde o gráfico será exibido
               ),
               tabPanel("Comercialização entre Produtores", p("Quantidade Diária Contratada por Fornecedor"),
                        plotlyOutput("fig_qdcfor")  # Onde o gráfico será exibido
               ),
               tabPanel("Contratação das Distribuidoras", p("Quantidade Média Diariamente Contratada por Modalidade de Contratação"),
                        plotlyOutput("fig_qdcdist")  # Onde o gráfico será exibido
               ),
               tabPanel("Modalidades de Contratação", p("Quantidade Média Diariamente Contratada por Modalidade de Contratação"),
                        plotlyOutput("fig_qdcmod")  # Onde o gráfico será exibido
               ),
             )
           )),
  
  # Distribuição
  tabPanel("Distribuição",
           fluidPage(
             #h2("Conteúdo da Página 4"), htmlOutput("map")
             tabsetPanel(
               tabPanel("Áreas de Concessão", p("Áreas de concessão"),
                        leafletOutput("map")
               ),
            tabPanel("Extensão das Redes", p("Extensões das Redes de Transporte e Distribuição"),
                                 plotlyOutput("fig_ext")  # Onde o gráfico será exibido
                ),
             )
          )),
  
  # Página 5
  tabPanel("Sobre",
           fluidPage(
             h2("Sobre este Dashboard"),
             
             p("Este dashboard foi criado com o objetivo de apresentar dados sobre o mercado de gás no Brasil. Ele foi desenvolvido com o objetivo de promover a abertura do mercado de gás no Brasil e conta com uma série de patrocinadores."),
             
             p("Informações sobre os autores podem ser encontradas em:"),
               
              p(" - [Joisa Dutra](https://www.linkedin.com/in/joisa-dutra-saraiva-429b735b/);"),
             
             p("- [Diogo Romeiro](https://www.linkedin.com/in/diogo-lisbona-romeiro-913819252/);"),
             
             p("- [Rafael Martins de Souza](https://www.linkedin.com/in/rafaelmartinsdesouza/)."),
             
             p("Ele também contou com a participação dos seguintes bolsistas de pesquisa."),
             
             p("Ícaro Hernandes(https://www.linkedin.com/in/icaro-franco-hernandes/);"),
             
             p("Daniel Almeida(https://www.linkedin.com/in/daniel-de-miranda-almeida/);"),
             
             p("Rachel Granville(https://www.linkedin.com/in/rachelgranville/)."),
             
             
             h2("Sobre o FGV CERI"),
             
             p("FGV CERI colabora com o desenvolvimento da regulação econômica no Brasil se valendo de sólidos fundamentos econômicos."),
             
             p("O Centro de Estudos em Regulação e Infraestrutura é a unidade da Fundação Getulio Vargas destinada a pensar, de forma estruturada e com sólidos fundamentos econômicos, a regulação dos setores de infraestrutura no Brasil."),

            p("O caráter multidisciplinar da regulação coloca essa instituição em condição privilegiada para contribuir para o desenvolvimento e o fortalecimento da regulação no País."),
            
            p("A regulação tem um papel central na atração de investimentos. Além disso, é protagonista na criação de um ambiente propício para que esses investimentos sejam convertidos em serviços de qualidade a preços competitivos, mas também capazes de garantir a sustentabilidade econômico-financeira de seus prestadores e refletir a alocação de riscos na cadeia de fornecimento."),
            
            p("O FGV CERI compreende os desafios e as oportunidades inerentes ao desenvolvimento dos setores de infraestrutura no Brasil. Por meio de seminários, palestras e encontros realizados por todo o país, do contato com especialistas e imprensa, e da publicação de estudos e resultados de pesquisas aplicadas, apresenta alternativas para problemas-chave e fomenta o debate com as diversas vozes da opinião pública, contribuindo, assim, para o desenvolvimento nacional."),
            
            p("Mais informações pode ser encontradas em https://ceri.fgv.br/sobre.")
)))

server <- function(input, output) {
  
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
}

# Execute o aplicativo
shinyApp(ui = ui, server = server)