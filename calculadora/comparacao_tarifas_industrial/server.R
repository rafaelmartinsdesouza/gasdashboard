library(plotly)
library(googlesheets4)
library(tidyverse)
library(googledrive)

# Importando função de busca de dados na planilha google.
source("calculadora/utils.R")

message("Rodando aba de comparação tarifária para o segmento industrial")

SEGMENTO_INDUSTRIAL <- "industrial"

# Por enquanto o valor específico de consumo fica salvo em uma variável.
consumo_medio_industrial <- 600000

# URL da planilha
sheet_url = "https://docs.google.com/spreadsheets/d/1f0IC0tKz4_0O0PTsqqv4_lLc-jDEiFT5Rpx-uALiReM/edit?usp=sharing"


#===============================================================================
# Servidor.
comp_industrial_server <- function(id) {
  comparacao_server(id, SEGMENTO_INDUSTRIAL, consumo_medio_industrial)
}