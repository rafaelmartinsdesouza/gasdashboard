# URL da planilha
sheet_url = "https://docs.google.com/spreadsheets/d/1f0IC0tKz4_0O0PTsqqv4_lLc-jDEiFT5Rpx-uALiReM/edit?usp=sharing"


# Estilização das tabelas da visão de tarifas.
table_styling <- "display: flex;
                  flex-direction: column;
                  align-items: center;"


# Código reutilizável para servidor das abas de comparação de tarifas.
comparacao_server <- function(id, segmento, consumo_medio) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- NS(id)
      
      # Automatically fetch data based on the defined inputs
      dados_tarifas <- reactive({
        get_dados_tarifas_comercial(segmento, consumo_medio)
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
            column(2,tags$div(h4("Norte"), tableOutput(ns('tabela_norte')), style = table_styling)),
            column(2, tags$div(h4("Nordeste"), tableOutput(ns('tabela_nordeste')), style = table_styling)),
            column(2, tags$div(h4("Sudeste"), tableOutput(ns('tabela_sudeste')), 
                               h5("(Todas as tarifas estão em R$/m³)"), style = table_styling)),
            column(2, tags$div(h4("Sul"), tableOutput(ns('tabela_sul')), style = table_styling)),
            column(2, tags$div(h4("Centro-oeste"), tableOutput(ns('tabela_centrooeste')), style = table_styling)),
            column(1)
          )
        })
      })
      
      # Filtered data for each region
      dados_regiao <- function(regiao) {
        reactive({
          dados_tarifas() %>%
            filter(Regiao == regiao) %>%
            subset(select = -Regiao)
        })
      }
      
      output$tabela_norte <- renderTable({ dados_regiao("Norte")() })
      output$tabela_nordeste <- renderTable({ dados_regiao("Nordeste")() })
      output$tabela_sudeste <- renderTable({ dados_regiao("Sudeste")() })
      output$tabela_sul <- renderTable({ dados_regiao("Sul")() })
      output$tabela_centrooeste <- renderTable({ dados_regiao("Centro-oeste")() })
    }
  )
}


# Função que adquire os dados do Google Sheets.
get_dados_tarifas <- function(valor_classe, valor_nivel){
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
    # Utilizando dicionário para mudar os nomes das regiões na coluna.
    mutate(Regiao = recode(Regiao, !!!map_regioes)) %>% 
    # Retirando coluna de estado.
    subset(select = -Estado) %>% 
    # Renomeando coluna de tarifa.
    rename("Tarifa\n(em R$/m³)" = Tarifa)
  
  return(df)
}

# Código reutilizável para UI's das abas de comparação de tarifas.
comparacao_ui <- function(id, segmento) {
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