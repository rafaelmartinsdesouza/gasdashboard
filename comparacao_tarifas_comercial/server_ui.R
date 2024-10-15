library(shiny)
library(plotly)
library(googlesheets4)
library(tidyverse)
library(googledrive)

segmento <- "comercial"
consumo_medio <- 800

mod_app_UI <- function(id) {
  ns <- NS(id)
  tagList(
    titlePanel(paste("Tarifas para o consumo médio", segmento, "de gás natural no mes atual")),
    fluidRow(
      column(12,
             # Gráfico de tarifas das distribuidoras.
             plotlyOutput(ns('grafico_tarifas'))
      )
    ),
    fluidRow(
      column(12,
             # Tabelas com tarifas por distruibora por região.
             uiOutput(ns('tabela_ui_tarifas'))
      ),
    )
  )
}


#===============================================================================
# Autenticação para acesso da planilha.

gs4_auth(
  path = "credentials/secret-key.json"
)

# URL da planilha.
sheet_url = "https://docs.google.com/spreadsheets/d/1Lz4iTpRntvk_eJst-eWjX5TIOk2XkSZ1kGSj2puu6zo/edit?usp=sharing"


#===============================================================================
# Servidor
# Função que busca dados para tarifas das distribuidoras.
get_dados_tarifas <- function(valor_classe, valor_nivel){
  # Função que adquire os dados do Google Sheets.
  
  # Alterando string para respectivo valor de classe de consumo.
  # Vetor que funciona como dicionário.
  map_classes <- c(
    "residencial" = 1,
    "industrial" = 2,
    "comercial" = 3
  )
  # Convertendo classe recebida na função.
  valor_classe <- map_classes[valor_classe]
  
  # Atualizando células de input.
  # Input da classe de consumo.
  sheet_url %>% range_write(data = data.frame(valor_classe),
                            sheet = 2,
                            range = "D1",
                            col_names = FALSE)
  # Input da classe do nível de consumo mensal.
  sheet_url %>% range_write(data = data.frame(valor_nivel),
                            sheet = 2,
                            range = "E6",
                            col_names = FALSE)
  
  # Lendo retorno da calculadora.
  df <- read_sheet(sheet_url,
                   sheet = 2,
                   range = "B9:E27",
                   col_names = c("Distribuidora", "Tarifa", "Estado", "Regiao"))
  
  # Transformando nome das regiões de abreviação para o nome real.
  map_regioes <- c(
    "SE" = "Sudeste",
    "N" = "Norte",
    "NE" = "Nordeste",
    "S" = "Sul",
    "CO" = "Centro-oeste"
  )
  df <- df %>%
    mutate(Regiao = recode(Regiao, !!!map_regioes))
  
  # Retirando coluna de estado.
  df <- subset(df, select = -Estado)
  
  return(df)
}


# Servidor.
mod_app_Server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- NS(id)
      
      # Automatically fetch data based on the defined inputs
      dados_tarifas <- reactive({
        get_dados_tarifas(segmento, consumo_medio)
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
                     h5("(Todas as tarifas estão em m³)"),
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



#===============================================================================
# Execução do aplicativo
ui_tarifas_comercial <- fluidPage(
  mod_app_UI('Calculadora_tarifas')
)
server_tarifas_comercial <- function(input, output, session) {
  mod_app_Server('Calculadora_tarifas')
}

shinyApp(ui_tarifas_comercial, server_tarifas_comercial)