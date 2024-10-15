library(shiny)
        
#===============================================================================
# UI
calculadora_faixas_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Custom CSS for Flexbox layout.
    tags$style(HTML("
      .flex-container {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
        justify-content: center; /* Center tables horizontally */
      }
      .flex-item {
        flex: 1 1 300px;
        min-width: 300px;
        max-width: 350px;
        border: 1px solid #ddd;
        padding: 10px;
        margin-bottom: 20px;
        text-align: center; /* Center text inside the flex item */
      }
      table {
        margin-left: auto;
        margin-right: auto;
      }
    ")),
    
    titlePanel(
      h1("Estrutura tarifária da distribuição", align = "center")
    ),
    
    sidebarLayout(
      sidebarPanel(
        width = 2,  # Smaller sidebar width
        selectInput(ns("nome_distribuidora_estrutura"), "Distribuidora:", choices = NULL),
        actionButton(ns("atualizar_estrutura"), "Atualizar")
      ),
      mainPanel(
        width = 9,  # Painel principal maior.
        uiOutput(ns("tabelas")) 
      )
    )
  )
}