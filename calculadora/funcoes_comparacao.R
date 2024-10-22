# URL da planilha
sheet_url = "https://docs.google.com/spreadsheets/d/1f0IC0tKz4_0O0PTsqqv4_lLc-jDEiFT5Rpx-uALiReM/edit?usp=sharing"

# ==============================================================================
# Estilização das tabelas da visão de tarifas.
table_styling <- "display: flex;
                  flex-direction: column;
                  align-items: center;"

# Função que adquire os dados do Google Sheets.
get_dados_tarifas <- function(valor_classe, valor_nivel){
  message("Buscando dados das abas de tarifas")
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

# ==============================================================================
# Funções auxiliares do servidor.
# Filtra dados pra cada região.
filtra_dados_regiao <- function(dados_tarifas, regiao) {
  reactive({
    dados_tarifas() %>%
      filter(Regiao == regiao) %>%
      subset(select = -Regiao)
  })
}

# Cria tabela com dados para cada região
cria_tabela_div <- function(nome_regiao, id_tabela, ns) {
  column(2,
         tags$div(
           h4(nome_regiao),
           tableOutput(ns(id_tabela)),
           style = table_styling
         )
  )
}

# Cria o gráfico da aba de tarifas.
cria_grafico_tarifas <- function (df) {
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
  return(fig)
}

# ==============================================================================
# Código reutilizável para servidor das abas de comparação de tarifas.
comparacao_server <- function(id, segmento, consumo_medio) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- NS(id)
      
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
      
      output$tabela_norte <- renderTable({ filtra_dados_regiao("Norte")() })
      output$tabela_nordeste <- renderTable({ filtra_dados_regiao("Nordeste")() })
      output$tabela_sudeste <- renderTable({ filtra_dados_regiao("Sudeste")() })
      output$tabela_sul <- renderTable({ filtra_dados_regiao("Sul")() })
      output$tabela_centrooeste <- renderTable({ filtra_dados_regiao("Centro-oeste")() })
    }
  )
}

# ==============================================================================
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