library(shiny)
library(plotly)
library(googlesheets4)
library(tidyverse)
library(googledrive)

SEGMENTO_INDUSTRIAL <- "industrial"

#===============================================================================
# UI.
comp_industrial_ui <- function(id){
  comparacao_ui(id, SEGMENTO_INDUSTRIAL)
}