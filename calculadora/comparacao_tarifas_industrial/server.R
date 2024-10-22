library(plotly)
library(googlesheets4)
library(tidyverse)
library(googledrive)

# Importando função de busca de dados na planilha google.
source("calculadora/funcoes_comparacao.R")

message("Rodando servidor de comparação tarifária para o segmento industrial")

SEGMENTO_INDUSTRIAL <- "industrial"

# Por enquanto o valor específico de consumo fica salvo em uma variável.
CONSUMO_FIXO_INDUSTRIAL <- 600000

#===============================================================================
# Servidor.
comp_industrial_server <- function(id) {
  message("===================================================================")
  message("Servidor da aba de tarifas para valor fixo do segmento residencial \n")
  
  comparacao_server(id, SEGMENTO_INDUSTRIAL, CONSUMO_FIXO_INDUSTRIAL)
}