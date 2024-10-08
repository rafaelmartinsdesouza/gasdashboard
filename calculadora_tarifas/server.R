library(plotly)
library(readxl)
library(openxlsx)

#=============================================================================
# Acesso da planilha com readxl.
path = "../calculadora_data/Calculadora_V4.xlsx"


#=============================================================================
# Função para busca de dados.
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
  # Carregando arquivo.
  wb <- loadWorkbook(path)
  
  # Colocando valores dos campos de input.
  writeData(wb, sheet = 2, x = valor_classe, startCol = 4, startRow = 1)
  writeData(wb, sheet = 2, x = valor_nivel, startCol = 6, startRow = 6)
  
  # Salvando alterações.
  saveWorkbook(wb, path, overwrite = TRUE)
  
  # Lendo retorno da calculadora.
  df <- read_excel(path,
                   sheet = 2,
                   range = "B9:E27",
                   col_names = c("Distribuidora", "Tarifa", "Estado", "Regiao"))
  print("df")
  print(df)
  
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
  df <- subset(df, select = -Estado) %>% 
    rename("Tarifa\n(em R$/m³)" = Tarifa)
  
  return(df)
}


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
        # text = ~ifelse(is.numeric(Tarifa), paste0(sprintf("%.2f", Tarifa)), "NA"),
        textposition = "outside") %>%
        layout(
          title = "Tarifa por distribuidora <br><sup>em R$/m³</sup>",
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