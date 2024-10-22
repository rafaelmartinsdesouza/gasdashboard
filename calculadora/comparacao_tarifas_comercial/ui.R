library(shiny)
library(plotly)
library(googlesheets4)
library(tidyverse)
library(googledrive)

source("calculadora/funcoes_comparacao.R")

SEGMENTO_COMERCIAL <- "comercial"

#===============================================================================
# UI.
comp_comercial_ui <- function(id){
  comparacao_ui(id, SEGMENTO_COMERCIAL)
}