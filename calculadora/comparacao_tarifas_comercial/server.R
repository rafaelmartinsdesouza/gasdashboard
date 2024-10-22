library(plotly)
library(googlesheets4)
library(tidyverse)
library(googledrive)

# Importanto função que busca dados na google sheet.
source("calculadora/funcoes_comparacao.R")

message("Rodando aba de comparação tarifária para o segmento comercial")

SEGMENTO_COMERCIAL <- "comercial"

# Por enquanto o valor específico de consumo fica salvo em uma variável.
consumo_medio_comercial <- 800


#===============================================================================
# Servidor.
comp_comercial_server <- function(id) {
  comparacao_server(id, SEGMENTO_COMERCIAL, consumo_medio_comercial)
}