# Server da aba de calculadora de tarifas.

library(shiny)
library(googlesheets4)

# Importando função de busca de dados na planilha google.
source("calculadora/modulo_tarifas.R")


#=============================================================================
# Server
calculadora_tarifas_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- NS(id)
    
    message("===================================================================")
    message("Servidor da aba de calculadora de tarifas \n")
    
    # Criando valores que são atualizados pelas funções de busca de dados.
    dados_tarifas <- eventReactive(input$update_tarifas, {
      message("Buscando dados")
      get_dados_tarifas(input$classe_consumo_tarifas, input$nivel_consumo_tarifas)
    })
    
    # Criando gráfico das tarifas.
    output$grafico_tarifas <- renderPlotly({
      message("Renderizando gráfico")
      df <- dados_tarifas()
      fig <- cria_grafico_tarifas(df)
      fig
    })
   
     
    # Criação das tabelas de tarifas das distribuidoras por região
    observeEvent(input$update_tarifas, {
      output$tabela_ui_tarifas <- renderUI({
        message("Criando tabelas")
        tagList(
          tags$div(
            cria_tabela_div("Norte", "tabela_norte", ns),
            cria_tabela_div("Nordeste", "tabela_nordeste", ns),
            cria_tabela_div("Sudeste", "tabela_sudeste", ns),
            cria_tabela_div("Sul", "tabela_sul", ns),
            cria_tabela_div("Centro-oeste", "tabela_centrooeste", ns),
            class = "tables-div"
          )
        )
      })
    })
    
    cria_tabelas(ns, dados_tarifas, output) 
  })
}