library(shiny)
library(googlesheets4)
library(jsonlite)

#=============================================================================
# Autenticação para acesso das planilhas.

# Transformando as credenciais salvas como variávies de ambiete em uma lista.
credenciais <- list(
  type = Sys.getenv("GOOGLE_SHEETS_TYPE"),
  project_id = Sys.getenv("GOOGLE_SHEETS_PROJECT_ID"),
  private_key_id = Sys.getenv("GOOGLE_SHEETS_PRIVATE_KEY_ID"),
  private_key = Sys.getenv("GOOGLE_SHEETS_PRIVATE_KEY"),
  client_email = Sys.getenv("GOOGLE_SHEETS_CLIENT_EMAIL"),
  client_id = Sys.getenv("GOOGLE_SHEETS_CLIENT_ID"),
  auth_uri = Sys.getenv("GOOGLE_SHEETS_AUTH_URI"),
  token_uri = Sys.getenv("GOOGLE_SHEETS_TOKEN_URI"),
  auth_provider_x509_cert_url = Sys.getenv("GOOGLE_SHEETS_AUTH_PROVIDER_X509_CERT_URL"),
  client_x509_cert_url = Sys.getenv("GOOGLE_SHEETS_CLIENT_X509_CERT_URL"),
  universe_domain = Sys.getenv("GOOGLE_SHEETS_UNIVERSE_DOMAIN")
)

# Transformando essa lista em arquivo JSON temporário que o gs4_auth consegue en
# tender.
credenciais_temp_path <- tempfile(fileext = ".json")
write(jsonlite::toJSON(credenciais, auto_unbox = TRUE, pretty = TRUE), credenciais_temp_path)

# Autenticando com esse arquivo temporário.
gs4_auth(path = credenciais_temp_path)

# URL pra acesso da planilha.
sheet_url = "https://docs.google.com/spreadsheets/d/1f0IC0tKz4_0O0PTsqqv4_lLc-jDEiFT5Rpx-uALiReM/edit?usp=sharing"


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