# Server da aba de calculadora de tarifas.

library(shiny)
library(googlesheets4)

# Importando função de busca de dados na planilha google.
source("calculadora/funcoes_comparacao.R")


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
          column(1),
          
          cria_tabela_div("Norte", "tabela_norte", ns),
          cria_tabela_div("Nordeste", "tabela_nordeste", ns),
          cria_tabela_div("Sudeste", "tabela_sudeste", ns),
          cria_tabela_div("Sul", "tabela_sul", ns),
          cria_tabela_div("Centro-oeste", "tabela_centrooeste", ns),
          
          column(1)
        )
      })
    })
    
    
    # Renderizando tabelas
    output$tabela_norte <- renderTable({ filtra_dados_regiao(dados_tarifas, "Norte")() })
    output$tabela_nordeste <- renderTable({ filtra_dados_regiao(dados_tarifas, "Nordeste")() })
    output$tabela_sudeste <- renderTable({ filtra_dados_regiao(dados_tarifas, "Sudeste")() })
    output$tabela_sul <- renderTable({ filtra_dados_regiao(dados_tarifas, "Sul")() })
    output$tabela_centrooeste <- renderTable({ filtra_dados_regiao(dados_tarifas, "Centro-oeste")() })   
  })
}