library(shiny)
        
#===============================================================================
# UI
estrutura_tarifaria_ui <- function(id) {
  ns <- NS(id)
  tagList(
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