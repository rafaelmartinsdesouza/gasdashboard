library(plotly)
library(googlesheets4)
library(tidyverse)
library(googledrive)

# Importanto função que busca dados na google sheet.
source("calculadora/utils.R")

message("Rodando aba de comparação tarifária para o segmento comercial")

SEGMENTO_COMERCIAL <- "comercial"

# Por enquanto o valor específico de consumo fica salvo em uma variável.
consumo_medio_comercial <- 800

# URL da planilha
sheet_url = "https://docs.google.com/spreadsheets/d/1f0IC0tKz4_0O0PTsqqv4_lLc-jDEiFT5Rpx-uALiReM/edit?usp=sharing"


#===============================================================================
# Servidor.
comp_comercial_server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- NS(id)
      
      # Automatically fetch data based on the defined inputs
      dados_tarifas <- reactive({
        get_dados_tarifas_comercial(SEGMENTO_COMERCIAL, consumo_medio_comercial)
      })
      
      # Render plot automatically
      output$grafico_tarifas <- renderPlotly({
        df <- dados_tarifas()
        
        fig <- plot_ly(
          df,
          x = ~Distribuidora,
          y = ~Tarifa,
          color = ~Regiao,
          type = "bar",
          text = ~paste0(sprintf("%.2f", Tarifa)),
          textposition = "outside") %>%
          layout(
            title = paste("Tarifa por distribuidora <br><sup>em R$/m³</sup>", sep = ""),
            xaxis = list(
              title = list(
                text = "Distribuidora",
                standoff = 25
              ),
              categoryorder = "total descending"
            ),
            yaxis = list(
              title = "Tarifa média (R$/m³)"
            )
          )
        fig
      })
      
      # Render tables automatically
      observe({
        output$tabela_ui_tarifas <- renderUI({
          tagList(
            column(1),
            column(2,
                   tags$div(
                     h4("Norte"),
                     tableOutput(ns('tabela_norte')),
                     style = 
                       "display: flex;
                   flex-direction: column;
                   align-items: center;"
                   ),
            ),
            column(2,
                   tags$div(
                     h4("Nordeste"),
                     tableOutput(ns('tabela_nordeste')),
                     style = 
                       "display: flex;
                   flex-direction: column;
                   align-items: center;"
                   )
            ),
            column(2,
                   tags$div(
                     h4("Sudeste"),
                     tableOutput(ns('tabela_sudeste')),
                     h5("(Todas as tarifas estão em R$/m³)"),
                     style = 
                       "display: flex;
                   flex-direction: column;
                   align-items: center;"
                   )
            ),
            column(2,
                   tags$div(
                     h4("Sul"),
                     tableOutput(ns('tabela_sul')),
                     style = 
                       "display: flex;
                   flex-direction: column;
                   align-items: center;"
                   )
            ),
            column(2,
                   tags$div(
                     h4("Centro-oeste"),
                     tableOutput(ns('tabela_centrooeste')),
                     style = 
                       "display: flex;
                   flex-direction: column;
                   align-items: center;"
                   )
            ),
            column(1)
          )
        })
      })
      
      # Filtered data for each region
      dadosNorte <- reactive({
        dados_tarifas() %>% 
          filter(Regiao == "Norte") %>% 
          subset(select = -Regiao)
      })
      dadosNordeste <- reactive({
        dados_tarifas() %>% 
          filter(Regiao == "Nordeste") %>% 
          subset(select = -Regiao)
      })
      dadosSudeste <- reactive({
        dados_tarifas() %>% 
          filter(Regiao == "Sudeste") %>% 
          subset(select = -Regiao)
      })
      dadosSul <- reactive({
        dados_tarifas() %>% 
          filter(Regiao == "Sul") %>% 
          subset(select = -Regiao)
      })
      dadosCentroOeste <- reactive({
        dados_tarifas() %>% 
          filter(Regiao == "Centro-oeste") %>% 
          subset(select = -Regiao)
      })
      
      # Render tables for each region
      output$tabela_norte <- renderTable({
        dadosNorte()
      })
      output$tabela_nordeste <- renderTable({
        dadosNordeste()
      })
      output$tabela_sudeste <- renderTable({
        dadosSudeste()
      })
      output$tabela_sul <- renderTable({
        dadosSul()
      })
      output$tabela_centrooeste <- renderTable({
        dadosCentroOeste()
      })
    }
  )
}