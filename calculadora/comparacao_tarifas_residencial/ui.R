library(shiny)
library(plotly)
library(googlesheets4)
library(tidyverse)
library(googledrive)

source("calculadora/funcoes_comparacao.R")

SEGMENTO_RESIDENCIAL <- "residencial"

#===============================================================================
# UI.
comp_residencial_ui <- function(id){
  comparacao_ui(id, SEGMENTO_RESIDENCIAL)
}