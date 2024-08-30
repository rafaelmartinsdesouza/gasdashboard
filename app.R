library(shiny)
library(plotly)
library(readxl) 


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
               tabPanel("Opção 2", p("Conteúdo da Opção 2")),
               tabPanel("Opção 3", p("Conteúdo da Opção 3")),
               tabPanel("Opção 4", p("Conteúdo da Opção 4")),
               tabPanel("Opção 5", p("Conteúdo da Opção 5"))
             )
           )),
  
  # Página 2
  tabPanel("Página 2",
           fluidPage(
             h2("Conteúdo da Página 2"),
             tabsetPanel(
               tabPanel("Opção 1", p("Conteúdo da Opção 1")),
               tabPanel("Opção 2", p("Conteúdo da Opção 2")),
               tabPanel("Opção 3", p("Conteúdo da Opção 3")),
               tabPanel("Opção 4", p("Conteúdo da Opção 4")),
               tabPanel("Opção 5", p("Conteúdo da Opção 5"))
             )
           )),
  
  # Página 3
  tabPanel("Página 3",
           fluidPage(
             h2("Conteúdo da Página 3"),
             tabsetPanel(
               tabPanel("Opção 1", p("Conteúdo da Opção 1")),
               tabPanel("Opção 2", p("Conteúdo da Opção 2")),
               tabPanel("Opção 3", p("Conteúdo da Opção 3")),
               tabPanel("Opção 4", p("Conteúdo da Opção 4")),
               tabPanel("Opção 5", p("Conteúdo da Opção 5"))
             )
           )),
  
  # Página 4
  tabPanel("Página 4",
           fluidPage(
             h2("Conteúdo da Página 4"),
             tabsetPanel(
               tabPanel("Opção 1", p("Conteúdo da Opção 1")),
               tabPanel("Opção 2", p("Conteúdo da Opção 2")),
               tabPanel("Opção 3", p("Conteúdo da Opção 3")),
               tabPanel("Opção 4", p("Conteúdo da Opção 4")),
               tabPanel("Opção 5", p("Conteúdo da Opção 5"))
             )
           )),
  
  # Página 5
  tabPanel("Página 5",
           fluidPage(
             h2("Conteúdo da Página 5"),
             tabsetPanel(
               tabPanel("Opção 1", p("Conteúdo da Opção 1")),
               tabPanel("Opção 2", p("Conteúdo da Opção 2")),
               tabPanel("Opção 3", p("Conteúdo da Opção 3")),
               tabPanel("Opção 4", p("Conteúdo da Opção 4")),
               tabPanel("Opção 5", p("Conteúdo da Opção 5"))
             )
           ))
)

server <- function(input, output) {
  
  # Renderize o gráfico na primeira página, opção 1
  output$grafico_vig <- plotly::renderPlotly({
    fig_vig
  })
  
  # Renderize o gráfico na primeira página, opção 1
  output$fig_vigc <- plotly::renderPlotly({
    fig_vigc
  })
}

# Execute o aplicativo
shinyApp(ui = ui, server = server)