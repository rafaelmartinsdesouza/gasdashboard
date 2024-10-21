library(shiny)
library(googlesheets4)

# Importando função de busca de dados na planilha google.
source("calculadora/utils.R")

message("Rodando aba de tarifas")

# URL da planilha
sheet_url = "https://docs.google.com/spreadsheets/d/1f0IC0tKz4_0O0PTsqqv4_lLc-jDEiFT5Rpx-uALiReM/edit?usp=sharing"


#=============================================================================
# Server
calculadora_tarifas_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- NS(id)
    
    # Criando valores que são atualizados pelas funções de busca de dados.
    dados_tarifas <- eventReactive(input$update_tarifas, {
      get_dados_tarifas(input$classe_consumo_tarifas, input$nivel_consumo_tarifas)
    })
    
    # Criando gráfico das tarifas.
    output$grafico_tarifas <- renderPlotly({
      df <- dados_tarifas()
      
      
      df <- df %>% 
        rename(Tarifa = "Tarifa\n(em R$/m³)")
      
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
            title = "Tarifa média (em R$/m³)"
          )
        )
      fig
    })
    
    # Criação das tabelas de tarifas das distribuidoras por região.
    observeEvent(input$update_tarifas, {
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
    
    # Filtrando dataframe para cada região.
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
    
    output$tabela_norte <- renderTable({
      # Selecionando as distribuidoras daquela região e retirando coluna de
      # região para criar as tabelas.
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
  })
}