library(plotly)
library(googlesheets4)
library(tidyverse)
library(googledrive)

# Importando função de busca de dados na planilha google.
source("calculadora/funcoes_comparacao.R")

message("Rodando aba de comparação tarifária para o segmento residencial")

SEGMENTO_RESIDENCIAL <- "residencial"

# Por enquanto o valor específico de consumo fica salvo em uma variável.
consumo_medio_residencial <- 12

# URL da planilha
sheet_url = "https://docs.google.com/spreadsheets/d/1f0IC0tKz4_0O0PTsqqv4_lLc-jDEiFT5Rpx-uALiReM/edit?usp=sharing"


#===============================================================================
# Servidor.
comp_residencial_server <- function(id) {
  comparacao_server(id, SEGMENTO_RESIDENCIAL, consumo_medio_residencial)
}