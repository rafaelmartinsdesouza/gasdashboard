library(shiny)
library(plotly)
library(googlesheets4)
library(tidyverse)
library(googledrive)

SEGMENTO <- "comercial"

comp_comercial_ui <- function(id) {
  ns <- NS(id)
  tagList(
    titlePanel(paste("Tarifas para o consumo médio", SEGMENTO, "de gás natural no mes atual")),
    fluidRow(
      column(12,
             # Gráfico de tarifas das distribuidoras.
             plotlyOutput(ns('grafico_tarifas'))
      )
    ),
    fluidRow(
      column(12,
             # Tabelas com tarifas por distruibora por região.
             uiOutput(ns('tabela_ui_tarifas'))
      ),
    )
  )
}