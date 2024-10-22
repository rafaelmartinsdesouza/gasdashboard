library(plotly)
library(googlesheets4)
library(tidyverse)
library(googledrive)

# Importando função de busca de dados na planilha google.
source("calculadora/funcoes_comparacao.R")

message("Rodando aba de comparação tarifária para o segmento residencial")

SEGMENTO_RESIDENCIAL <- "residencial"

# Por enquanto o valor específico de consumo fica salvo em uma variável.
CONSUMO_FIXO_RESIDENCIAL <- 12


#===============================================================================
# Servidor.
comp_residencial_server <- function(id) {
  message("===================================================================")
  message("Servidor da aba de tarifas para valor fixo do segmento residencial \n")
  
  comparacao_server(id, SEGMENTO_RESIDENCIAL, CONSUMO_FIXO_RESIDENCIAL)
}