library(shiny)
        
calculadora_tarifas_ui <- function(id) {
  ns <- NS(id)
  tagList(
    titlePanel(
      h1("Calculadora de tarifas* do mercado de gás natural no Brasil",
         align = "center")
    ),
    fluidRow(
      # Primeiro painel de inputs - tarifas por distribuidora.
      column(2,
             tags$div(
               h4("Tarifas de distribuidoras"),
               wellPanel(
                 selectInput(ns("classe_consumo_tarifas"),
                             "Classe de Consumo:",
                             choices = c("residencial", "industrial", "comercial")),
                 numericInput(ns("nivel_consumo_tarifas"),
                              "Nível de consumo(m³):",
                              value = 500),
                 actionButton(ns("update_tarifas"), "Atualizar")
               ),     
               style = 
                 "display: flex;
        flex-direction: column;
        align-items: center;"
             )
      ),
      column(10,
             # Gráfico de tarifas das distribuidoras.
             plotlyOutput(ns('grafico_tarifas'))
      )
    ),
    fluidRow(
      column(12,
             # Tabelas com tarifas por distruibora por região.
             uiOutput(ns('tabela_ui_tarifas'))
      ),
    ),
    fluidRow(
      column(12,
             h4("*: Tarifas com impostos.")
      ),
    )
  )
}