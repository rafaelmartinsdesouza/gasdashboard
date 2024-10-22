library(plotly)
library(googlesheets4)
library(tidyverse)
library(googledrive)

# Importanto função que busca dados na google sheet.
source("calculadora/funcoes_comparacao.R")

message("Rodando aba de comparação tarifária para o segmento comercial")

SEGMENTO_COMERCIAL <- "comercial"

# Por enquanto o valor específico de consumo fica salvo em uma variável.
CONSUMO_FIXO_COMERCIAL <- 800


#===============================================================================
# Servidor.
comp_comercial_server <- function(id) {
  message("===================================================================")
  message("Server da aba de tarifas para valor fixo do segmento comercial \n")
  
  comparacao_server(id, SEGMENTO_COMERCIAL, CONSUMO_FIXO_COMERCIAL)
}