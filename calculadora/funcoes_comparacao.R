# URL da planilha
sheet_url = "https://docs.google.com/spreadsheets/d/1f0IC0tKz4_0O0PTsqqv4_lLc-jDEiFT5Rpx-uALiReM/edit?usp=sharing"

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

# Cria tabela com dados para cada região e estilização
cria_tabela_div <- function(nome_regiao, id_tabela, ns) {
  tags$div(
    h4(nome_regiao),
    tableOutput(ns(id_tabela)),
    class = "table-div"
  )
}

# Configura para que as tabelas sejam criadas com a estilização e com os dados corretamente.
configura_output_tabela <- function(regiao, ns, dados_tarifas, output) {
  # Renderiza UI da tabela
  output[[paste0("tabela_", tolower(regiao))]] <- renderUI({
    tableOutput(ns(paste0("tabela_", tolower(regiao))))
  })
  
  # Renderiza tabelas com dados filtrados por região
  output[[paste0("tabela_", tolower(regiao))]] <- renderTable({
    filtra_dados_regiao(dados_tarifas, regiao)()
  }, bordered = TRUE, striped = TRUE, hover = TRUE)
}

# Configura o output de todas as tabelas de uma vez.
configura_output_tabelas <- function(ns, dados_tarifas, output) {
  cria_output_tabela("Norte", ns, dados_tarifas, output)
  cria_output_tabela("Nordeste", ns, dados_tarifas, output)
  cria_output_tabela("Sudeste", ns, dados_tarifas, output)
  cria_output_tabela("Sul", ns, dados_tarifas, output)
  cria_output_tabela("Centrooeste", ns, dados_tarifas, output)
}

# Cria o gráfico da aba de tarifas.
cria_grafico_tarifas <- function (df) {
  df <- df %>% 
    rename(Tarifa = "Tarifa\n(em R$/m³)")
  
  fig <- plot_ly() %>% 
    add_bars(data = df, x = ~Distribuidora, y = ~Tarifa, color = ~Regiao, colors = c("#2685BF", "#3D9DD9", "#5FB6D9", "#94D7F2", "#BBE8F2"),
  # fig <- plot_ly(
  #   df,
  #   x = ~Distribuidora,
  #   y = ~Tarifa,
  #   color = ~Regiao,
  #   type = "bar",
  #   text = ~paste0(sprintf("%.2f", Tarifa)),
  #   textposition = "outside",
    marker = list(
      line = list(color = "white", width = 1)  # Adds a border to simulate rounded bars
    )) %>% 
    layout(
      title = list(
        text = "Tarifa por distribuidora <br><sup>em R$/m³</sup>",
        font = list(family = "Arial", size = 16, color = "#333")
      ),
      xaxis = list(
        title = list(text = "Distribuidora", standoff = 25),
        categoryorder = "total descending",
        tickfont = list(family = "Arial", size = 12),
        tickangle = -45  # Angle the labels for better readability
      ),
      yaxis = list(
        title = "Tarifa média (em R$/m³)",
        tickfont = list(family = "Arial", size = 12),
        range = c(0, max(df$Tarifa) * 1.1)  # Slightly increase the y-axis range
      ),
      margin = list(t = 50, b = 150),  # Adjust margins for better spacing
      showlegend = TRUE,  # Keep the legend to clarify regions
      legend = list(
        orientation = "h",  # Horizontal legend at the bottom
        xanchor = "center",
        x = 0.5,
        y = -0.2
      )
      # barmode = "overlay"  # Maintain the clear borders for rounding effect
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
      dados_tarifas <- reactive({
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
      observe({
        output$tabela_ui_tarifas <- renderUI({
          message("Criando tabelas")
          tagList(
            tags$div(
              cria_tabela_div("Norte", "tabela_norte", ns),
              cria_tabela_div("Nordeste", "tabela_nordeste", ns),
              tags$div(
                h4("Sudeste"),
                tableOutput(ns("tabela_sudeste")),
                h5("(Todas as tarifas estão em R$/m³)"),
                class = "table-div"
              ),
              cria_tabela_div("Sul", "tabela_sul", ns),
              cria_tabela_div("Centro-oeste", "tabela_centrooeste", ns),
              class = "tables-div"
            )
          )
        })
      })
      
      cria_tabelas(ns, dados_tarifas, output)
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
             plotlyOutput(ns('grafico_tarifas'))
      )
    ),
    fluidRow(
      column(12,
             uiOutput(ns('tabela_ui_tarifas'))
      )
    )
  )
}
