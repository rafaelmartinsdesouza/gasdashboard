# Abertura {data-icon="ion-android-navigate"}

## Column {.tabset}

### Acompanhamento do TCC

```{r}
```

### Agentes Autorizados pela ANP

```{r}
```

### Market Share Petrobras {data-width=700}

```{r}
#tags$embed(seamless="seamless",  
#                  src= 'fig_ms.html',
#                  width='100%',
#                  height = 400)
ms_petro<-read.csv2("graph_files/marketshare_petro.csv")
ms_petro$data <- stringr::str_replace_all(ms_petro$data, "/", "-")
ms_petro$data <- lubridate::as_date(ms_petro$data, format = '%d-%m-%Y')
ms_petro %>%
  dplyr::filter(data >= "2024-01-01") -> ms_petro
fig_ms <- plotly::plot_ly(ms_petro,
                          type = 'scatter',
                          mode = 'lines')%>% add_trace(x = ~data, 
                                                       y = ~ms,
                                                       name = 'Market Share')
fig_ms <- fig_ms %>% plotly::layout(title = 'Market Share da Petrobras - QDC',
                                    xaxis = list(title = 'Ano'),
                                    yaxis = list (title = '%'),
                                    showlegend = FALSE)
fig_ms

```

### Índice de Concentração no elo da comercialização {data-width=700}

```{r}
hhi<-read.csv2("graph_files/hhi.csv")
hhi$data <-stringr::str_replace_all(hhi$data, "/", "-")
hhi$data <- lubridate::as_date(hhi$data, format = '%d-%m-%Y')
hhi %>%
  filter(data >= "2024-01-01") -> hhi
fig_hhi <- plotly::plot_ly(hhi,
                           type = 'scatter',
                           mode = 'lines')%>% add_trace(x = ~data, 
                                                        y = ~hhi,
                                                        name = 'índice')
fig_hhi <- fig_hhi %>% plotly::layout(title = 'Índice HHI QDC',
                                      xaxis = list(title = 'Ano'),
                                      yaxis = list (title = 'HHI'), 
                                      showlegend = FALSE)
fig_hhi
```

# Regulação {data-icon="ion-ios-book"}

## Column {.tabset}

### Órgãos Reguladores Estaduais {data-width=700}

```{r}
```

### Atualizações Regulatórias e Legislativas

```{r}
```

### Acompanhamento da Agenda Regulatória

```{r}
```

### Governança

```{r}
```

# Oferta e Demanda {data-icon="ion-arrow-graph-up-right"}

## Column {.tabset}

### Oferta

#### Oferta Internacional {data-width=350}

```{r}
# Oferta Internacional
oferta_imp <- read.csv2("graph_files/oferta_importada_mensal.csv")
oferta_imp$data <- stringr::str_replace_all(oferta_imp$data, "/", "-")
oferta_imp$data <- lubridate::as_date(oferta_imp$data, format = '%d-%m-%Y')

fig_ofertaimp<- plotly::plot_ly(oferta_imp,
                                x = ~data,
                                y = ~bolivia,
                                name = 'Boliviana', type = 'scatter', mode = 'none', stackgroup = 'one')

fig_ofertaimp <- fig_ofertaimp %>% add_trace (y = ~argentina, name = "Argentina")
fig_ofertaimp <- fig_ofertaimp %>% add_trace (y = ~regaseificacao_gnl, name = "Regaseificação (GNL)")
fig_ofertaimp <- fig_ofertaimp %>%  plotly::layout(title = 'Oferta Importada',
                                                   xaxis = list(title = 'Ano'),
                                                   yaxis = list (title = 'Volume em m³/dia'),
                                                   legend=list(title=list(text='<b> Fontes</b>'))) %>%
  layout(margin = list(l = 50, r = 50, b = 50, t = 50, pad = 10))
fig_ofertaimp
``` 

#### Oferta Nacional {data-width=350}

```{r}
# Oferta Nacional
oferta_nacional <- read.csv2("graph_files/oferta_nacional_mensal.csv")
oferta_nacional$data <- stringr::str_replace_all(oferta_nacional$data, "/", "-")
oferta_nacional$data <- lubridate::as_date(oferta_nacional$data, format = '%d-%m-%Y')
fig_ofertanac <- plotly::plot_ly(oferta_nacional,
                                 x = ~data,
                                 y = ~producao,
                                 name = 'Produção', type = 'scatter', mode = 'none', stackgroup = 'one')
fig_ofertanac <- fig_ofertanac %>% add_trace (y = ~reinjecao, name = "Reinjeção")
fig_ofertanac <- fig_ofertanac %>% add_trace (y = ~queima_perda, name = "Queimas e Perdas")
fig_ofertanac <- fig_ofertanac %>% add_trace (y = ~consumo_EeP, name = "Consumo E & P")
fig_ofertanac <- fig_ofertanac %>% add_trace (y = ~absorcao_upgn, name = "Absorção nas UPGN's")
fig_ofertanac <- fig_ofertanac %>% add_trace (y = ~oferta_liquida, name = "Oferta Líquida")
fig_ofertanac <- fig_ofertanac %>%  plotly::layout(title = 'Oferta Nacional',
                                                   xaxis = list(title = 'Ano'),
                                                   yaxis = list (title = 'Volume em m³/dia'),
                                                   legend=list(title=list(text='<b> Fontes</b>'))) %>%
  #layout(autosize = TRUE) 
  layout(margin = list(l = 50, r = 50, b = 50, t = 50, pad = 10))


fig_ofertanac
```

#### Oferta Interna
```{r}

#------------------------------------------------------------------------------#
#oferta interna#

oferta_int <-read.csv2('graph_files/oferta_interna.csv')


oferta_int$data <- as.character(oferta_int$data)

oferta_int$data <- lubridate::as_date(oferta_int$data, 
                                      format = '%Y')

fig_ofertaint<- plotly::plot_ly(oferta_int,
                                x = ~data,
                                y = ~produca_bruta,
                                name = 'Produção Bruta', 
                                type = 'scatter', 
                                mode = 'none', 
                                stackgroup = 'one')

fig_ofertaint <- fig_ofertaint %>% add_trace (y = ~import, 
                                              name = "Importação")

fig_ofertaint <- fig_ofertaint %>% add_lines(y = ~oferta_interna, 
                                             name = 'Oferta Interna', 
                                             fill = 'none', 
                                             stackgroup = 'two')

fig_ofertaint <- fig_ofertaint %>% add_lines(y = ~reinj_perdas, 
                                             name = 'Reinjeção e Perdas', 
                                             fill = 'none', 
                                             stackgroup = 'three')


fig_ofertaint   <- fig_ofertaint   %>%  plotly::layout(title = 'Oferta Interna de Gás Natural',
                                                       xaxis = list(title = 'Ano'),
                                                       yaxis = list (title = 'Volume em milhões de m³/dia'),
                                                       legend=list(title=list(text='<b> Fontes </b>')))


fig_ofertaint 
```


### Demanda {data-width=700}

#### Demanda por segmento de consumo {data-width=700}

```{r}
demanda_seg <- read.csv2("graph_files/demanda_segmento.csv")
demanda_seg$data <- stringr::str_replace_all(demanda_seg$data, "/", "-")
demanda_seg$data <- lubridate::as_date(demanda_seg$data, format = '%d-%m-%Y')
fig_demandaseg<- plotly::plot_ly(demanda_seg,
                                 x = ~data,
                                 y = ~industrial,
                                 name = 'Industrial', type = 'scatter', mode = 'none', stackgroup = 'one')
fig_demandaseg <- fig_demandaseg %>% add_trace (y = ~automotivo, name = "Automotivo")
fig_demandaseg <- fig_demandaseg %>% add_trace (y = ~ger_ele, name = "Geração Elétrica")
fig_demandaseg <- fig_demandaseg %>% add_trace (y = ~cogeracao, name = "Cogeração")
fig_demandaseg <- fig_demandaseg %>% add_trace (y = ~residencial, name = "Residencial")
fig_demandaseg <- fig_demandaseg %>% add_trace (y = ~comercial, name = "Comercial")
fig_demandaseg <- fig_demandaseg %>% add_trace (y = ~outros_mais_GNC, name = "Outros (incluindo GNC)")

fig_demandaseg <- fig_demandaseg %>%  plotly::layout(title = 'Demanda',
                                                     xaxis = list(title = 'Ano'),
                                                     yaxis = list (title = 'Volume em m³/dia'),
                                                     legend=list(title=list(text='<b> Segmentos </b>'))) %>%
  layout(margin = list(l = 50, r = 50, b = 50, t = 50, pad = 10))
fig_demandaseg
```

#### Demanda por distribuidora com segmento termelétrico {data-width=700}

```{r}
demanda_dist <- read.csv2("graph_files/demanda_distribuidora_com_termica.csv")
demanda_dist%>%dplyr::rename(data = X) -> demanda_dist
demanda_dist$data <- stringr::str_replace_all(demanda_dist$data, "/", "-")
demanda_dist$data <- lubridate::as_date(demanda_dist$data, format = '%d-%m-%Y')
fig_demandist<- plotly::plot_ly(demanda_dist,
                                x = ~data,
                                y = ~comgas,
                                name = 'Comgás', type = 'scatter', mode = 'none', stackgroup = 'one')
fig_demandist<- fig_demandist %>% add_trace (y = ~ceg, name = "CEG")
fig_demandist<- fig_demandist %>% add_trace (y = ~ceg_rio, name = "CEG Rio")
fig_demandist<- fig_demandist %>% add_trace (y = ~bahiagas, name = "BahiaGás")
fig_demandist<- fig_demandist %>% add_trace (y = ~copergas, name = "Copergás")
fig_demandist<- fig_demandist %>% add_trace (y = ~cigas, name = "Cigás")
fig_demandist<- fig_demandist %>% add_trace (y = ~gasmig, name = "Gasmig")
fig_demandist<- fig_demandist %>% add_trace (y = ~esgas, name = "ES Gás")
fig_demandist<- fig_demandist %>% add_trace (y = ~gasmar, name = "Gasmar")
fig_demandist<- fig_demandist %>% add_trace (y = ~sulgas, name = "Sul Gás")
fig_demandist<- fig_demandist %>% add_trace (y = ~scgas, name = "SC Gás")
fig_demandist<- fig_demandist %>% add_trace (y = ~compagas, name = "Compagas")
fig_demandist<- fig_demandist %>% add_trace (y = ~msgas, name = "MS Gás")
fig_demandist<- fig_demandist %>% add_trace (y = ~cegas, name = "Cegás")
fig_demandist<- fig_demandist %>% add_trace (y = ~naturgy_sp, name = "Naturgy SP")
fig_demandist<- fig_demandist %>% add_trace (y = ~gas_brasiliano, name = "Gas Brasiliano")
fig_demandist<- fig_demandist %>% add_trace (y = ~algas, name = "Algás")
fig_demandist<- fig_demandist %>% add_trace (y = ~potigas, name = "Potigás")
fig_demandist<- fig_demandist %>% add_trace (y = ~pbgas, name = "PB Gás")
fig_demandist<- fig_demandist %>% add_trace (y = ~cebgas, name = "Cebgás")
fig_demandist<- fig_demandist %>% add_trace (y = ~mtgas, name = "MT Gás")
fig_demandist<- fig_demandist %>% add_trace (y = ~goiasgas, name = "Goiás Gás")
fig_demandist<- fig_demandist %>% add_trace (y = ~gaspisa, name = "Gaspisa")
fig_demandist <- fig_demandist %>%  plotly::layout(title = 'Demanda (Com termelétricas)',
                                                   xaxis = list(title = 'Ano'),
                                                   yaxis = list (title = 'Volume em m³/dia'),
                                                   legend=list(title=list(text='<b> Distribuidoras </b>'))) %>%
  layout(margin = list(l = 50, r = 50, b = 50, t = 50, pad = 10))
fig_demandist
```

#### Demanda por distribuidora sem segmento termelétrico {data-width=700}

```{r}
demanda_dist_st <- read.csv2("graph_files/demanda_distribuidora_sem_termica.csv")
demanda_dist_st$data <- stringr::str_replace_all(demanda_dist_st$data, "/", "-")
demanda_dist_st$data <- lubridate::as_date(demanda_dist_st$data, format = '%d-%m-%Y')
fig_demandist_st<- plotly::plot_ly(demanda_dist_st,
                                   x = ~data,
                                   y = ~comgas,
                                   name = 'Comgás', type = 'scatter', mode = 'none', stackgroup = 'one')
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~ceg, name = "CEG")
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~ceg_rio, name = "CEG Rio")
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~bahiagas, name = "BahiaGás")
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~copergas, name = "Copergás")
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~cigas, name = "Cigás")
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~gasmig, name = "Gasmig")
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~esgas, name = "ES Gás")
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~gasmar, name = "Gasmar")
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~sulgas, name = "Sul Gás")
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~scgas, name = "SC Gás")
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~compagas, name = "Compagas")
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~msgas, name = "MS Gás")
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~cegas, name = "Cegás")
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~naturgy_sp, name = "Naturgy SP")
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~gas_brasiliano, name = "Gas Brasiliano")
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~algas, name = "Algás")
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~potigas, name = "Potigás")
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~pbgas, name = "PB Gás")
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~cebgas, name = "Cebgás")
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~mtgas, name = "MT Gás")
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~goiasgas, name = "Goiás Gás")
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~gaspisa, name = "Gaspisa")
fig_demandist_st <- fig_demandist_st %>%  plotly::layout(title = 'Demanda (Com termelétricas)',
                                                         xaxis = list(title = 'Ano'),
                                                         yaxis = list (title = 'Volume em m³/dia'),
                                                         legend=list(title=list(text='<b> Distribuidoras </b>'))) %>%
  layout(margin = list(l = 50, r = 50, b = 50, t = 50, pad = 10))
fig_demandist_st
```


### Balanço Nacional e Malha Integrada

```{r}

#--------------mensal--------------#
balanco <-read.csv2("graph_files/balanço.csv")


balanco$data <- stringr::str_replace_all(balanco$data, "/", "-")


balanco$data <- lubridate::as_date(balanco$data, format = '%d-%m-%Y')

fig_balanco<- plotly::plot_ly(balanco,
                              x = ~data,
                              y = ~oferta_nacional,
                              name = 'Oferta Nacional', 
                              type = 'scatter', 
                              mode = 'none', 
                              stackgroup = 'one',
                              legendgroup = 'group1')

fig_balanco<- fig_balanco %>% add_trace (y = ~oferta_boliviana, 
                                         name = "Bolívia",
                                         legendgroup = 'group1')


fig_balanco<- fig_balanco %>% add_trace (y = ~gnl, 
                                         name = "GNL",
                                         legendgroup = 'group1')

#se quando eu não quiser empilhar é so colocar em outro stackgroup
fig_balanco <- fig_balanco %>% add_lines(y = ~perdas_ajustes, 
                                         name = 'Perdas e Ajustes', 
                                         fill = 'none', 
                                         stackgroup = 'two',
                                         legendgroup = 'group2')


fig_balanco <- fig_balanco %>% add_lines(y = ~demanda_nt, 
                                         name = 'Demanda Não Termelétrica', 
                                         fill = 'none', 
                                         stackgroup = 'three',
                                         legendgroup = 'group2')


fig_balanco  <- fig_balanco  %>%  plotly::layout(title = 'Balanço de Gás Natural (Mensal)',
                                                 xaxis = list(title = 'Ano'),
                                                 yaxis = list (title = 'Volume em milhões de m³/dia'),
                                                 legend=list(title=list(text='<b> Oferta e Demanda </b>')))

fig_balanco

#--------------anual--------------#

balanco_anual<-read.csv2('graph_files/balanco_anual.csv')


balanco_anual$data <- as.character(balanco_anual$data)

balanco_anual$data <- lubridate::as_date(balanco_anual$data, 
                                         format = '%Y')

fig_balanco_anual<- plotly::plot_ly(balanco_anual,
                                    x = ~data,
                                    y = ~oferta_nacional,
                                    name = 'Oferta Nacional', 
                                    type = 'scatter', 
                                    mode = 'none', 
                                    stackgroup = 'one',
                                    legendgroup = 'group1')

fig_balanco_anual<- fig_balanco_anual %>% add_trace (y = ~oferta_bolivia, 
                                                     name = "Bolívia",
                                                     legendgroup = 'group1')


fig_balanco_anual<- fig_balanco_anual %>% add_trace (y = ~gnl, 
                                                     name = "GNL",
                                                     legendgroup = 'group1')

#se quando eu não quiser empilhar é so colocar em outro stackgroup
fig_balanco_anual <- fig_balanco_anual %>% add_lines(y = ~perdas_ajustes, 
                                                     name = 'Perdas e Ajustes', 
                                                     fill = 'none', 
                                                     stackgroup = 'two',
                                                     legendgroup = 'group2')


fig_balanco_anual <- fig_balanco_anual %>% add_lines(y = ~demanda_nt, 
                                                     name = 'Demanda Não Termelétrica', 
                                                     fill = 'none', 
                                                     stackgroup = 'three',
                                                     legendgroup = 'group2')


fig_balanco_anual  <- fig_balanco_anual  %>%  plotly::layout(title = 'Balanço de Gás Natural',
                                                             xaxis = list(title = 'Ano'),
                                                             yaxis = list (title = 'Volume em milhões de m³/dia'),
                                                             legend=list(title=list(text='<b> Oferta e Demanda </b>')))

fig_balanco_anual 

```

# Transporte {data-icon="ion-map"}

## Column {.tabset}

### Mapa das Transportadoras

```{r}

```

### Contratos de Transporte

```{r}
```

### Tarifas

```{r}
```

### Balanceamento

```{r}
```

# Comercialização {data-icon="ion-ios-paper-outline"}

## Column {.tabset}

### Comercialização no País

#### QDC contratada por região

```{r}
qdc_reg<- read.csv2("graph_files/qdc_reg.csv")
qdc_reg %>% dplyr::rename(data = regiao) -> qdc_reg
qdc_reg$data <- stringr::str_replace_all(qdc_reg$data, "/", "-")
qdc_reg$data <- lubridate::as_date(qdc_reg$data, format = '%d-%m-%Y')
qdc_reg %>% dplyr::filter(data >= "2024-01-01")-> qdc_reg
fig_qdcreg <- plotly::plot_ly(qdc_reg,
                              x = ~data,
                              y = ~sudeste,
                              name = 'Sudeste', type = 'scatter', mode = 'none', stackgroup = 'one')
fig_qdcreg <- fig_qdcreg %>% add_trace (y = ~sul, name = "Sul")
fig_qdcreg <- fig_qdcreg %>% add_trace(y = ~nordeste, name = "Nordeste")
fig_qdcreg <- fig_qdcreg %>% add_trace(y = ~centrooeste, name = "Centro-Oeste")
fig_qdcreg <- fig_qdcreg %>%  plotly::layout(title = 'QDC contratada por região',
                                             xaxis = list(title = 'Ano'),
                                             yaxis = list (title = 'Volume em m³/dia'),
                                             legend=list(title=list(text='<b> Região </b>'))) %>% layout(autosize = TRUE)
fig_qdcreg
```

#### QDC contratada por Estado

```{r}

qdc_uf<- read.csv2("graph_files/qdc_uf.csv")
qdc_uf$data <- stringr::str_replace_all(qdc_uf$data, "/", "-")
qdc_uf$data <- lubridate::as_date(qdc_uf$data, format = '%d-%m-%Y')
qdc_uf %>% dplyr::filter(data >= "2024-01-01")-> qdc_uf
fig_qdcuf <- plotly::plot_ly(qdc_uf,
                             x = ~data,
                             y = ~SP,
                             name = 'São Paulo', type = 'scatter', mode = 'none', stackgroup = 'one')
fig_qdcuf <- fig_qdcuf %>% add_trace (y = ~RJ, name = "Rio de Janeiro")
fig_qdcuf <- fig_qdcuf %>% add_trace (y = ~ES, name = "Espírito Santo")
fig_qdcuf <- fig_qdcuf %>% add_trace (y = ~MG, name = "Minas Gerais")
fig_qdcuf <- fig_qdcuf %>% add_trace (y = ~PR, name = "Paraná")
fig_qdcuf <- fig_qdcuf %>% add_trace (y = ~SC, name = "Santa Catarina")
fig_qdcuf <- fig_qdcuf %>% add_trace (y = ~RS, name = "Rio Grande do Sul")
fig_qdcuf <- fig_qdcuf %>% add_trace (y = ~BA, name = "Bahia")
fig_qdcuf <- fig_qdcuf %>% add_trace (y = ~CE, name = "Ceará")
fig_qdcuf <- fig_qdcuf %>% add_trace (y = ~PB, name = "Paraíba")
fig_qdcuf <- fig_qdcuf %>% add_trace (y = ~PE, name = "Pernambuco")
fig_qdcuf <- fig_qdcuf %>% add_trace (y = ~AL, name = "Alagoas")
fig_qdcuf <- fig_qdcuf %>% add_trace (y = ~SE, name = "Sergipe")
fig_qdcuf <- fig_qdcuf %>% add_trace (y = ~RN, name = "Rio Grande do Norte")
fig_qdcuf <- fig_qdcuf %>% add_trace (y = ~MS, name = "Mato Grosso do Sul")
fig_qdcuf <- fig_qdcuf %>%  plotly::layout(title = 'QDC contratada por Estado',
                                           xaxis = list(title = 'Ano'),
                                           yaxis = list (title = 'Volume em m³/dia'),
                                           legend=list(title=list(text='<b> Estado </b>',
                                                                  orientation = "h",   # show entries horizontally
                                                                  xanchor = "center",  # use center of legend as anchor
                                                                  x = 0.5))) %>% 
  layout(margin = list(l = 50, r = 50, b = 50, t = 50, pad = 10))
fig_qdcuf
```

### Comercialização entre Produtores

```{r}
qdc_for <- read.csv2("graph_files/qdc_fornecedor.csv")
qdc_for$date <- stringr::str_replace_all(qdc_for$date, "/", "-")
qdc_for$date <- lubridate::as_date(qdc_for$date, format = '%d-%m-%Y')

qdc_for %>%
  dplyr::filter(date >= "2024-01-01" ) -> qdc_for
fig_qdcfor <- plotly::plot_ly(qdc_for,
                              x = ~date,
                              y = ~petrobras,
                              name = 'Petrobrás', type = 'scatter', mode = 'none', stackgroup = 'one')
fig_qdcfor <- fig_qdcfor %>% add_trace (y = ~Alvopetro, name = "Alvopetro")
fig_qdcfor <- fig_qdcfor %>% add_trace (y = ~Compass, name = "Compass")
fig_qdcfor <- fig_qdcfor %>% add_trace (y = ~ERG, name = "ERG")
fig_qdcfor <- fig_qdcfor %>% add_trace (y = ~Eagle, name = "Eagle")
fig_qdcfor <- fig_qdcfor %>% add_trace (y = ~Equinor, name = "GALP")
fig_qdcfor <- fig_qdcfor %>% add_trace (y = ~NFE, name = "NFE")
fig_qdcfor <- fig_qdcfor %>% add_trace (y = ~Origem, name = "Origem")
fig_qdcfor <- fig_qdcfor %>% add_trace (y = ~tresR, name = "3R")
fig_qdcfor <- fig_qdcfor %>% add_trace (y = ~Petroreconcavo, name = "Petrorecôncavo")
fig_qdcfor <- fig_qdcfor %>% add_trace (y = ~Potiguar, name = "Potiguar")
fig_qdcfor <- fig_qdcfor %>% add_trace (y = ~Shell, name = "Shell")
fig_qdcfor <- fig_qdcfor %>% add_trace (y = ~Tradener, name = "Tradener")
fig_qdcfor <- fig_qdcfor %>% plotly::layout(title = 'Volume de QDC por Fornecedor',
                                            xaxis = list(title = 'Ano'),
                                            yaxis = list (title = 'Volume em m³/dia'))
fig_qdcfor
```

### Contratação das Distribuidoras

```{r}
qdc_dist<- read.csv2("graph_files/qdc_dist.csv")
qdc_dist$data <- stringr::str_replace_all(qdc_dist$data, "/", "-")
qdc_dist$data <- lubridate::as_date(qdc_dist$data, format = '%d-%m-%Y')
qdc_dist %>% dplyr::filter(data >= "2024-01-01")-> qdc_dist
fig_qdcdist <- plotly::plot_ly(qdc_dist,
                               x = ~data,
                               y = ~comgas,
                               name = 'Comgás', type = 'scatter', mode = 'none', stackgroup = 'one')
fig_qdcdist <- fig_qdcdist %>% add_trace (y = ~CEG, name = "CEG")
fig_qdcdist <- fig_qdcdist %>% add_trace (y = ~scgas, name = "SC Gás")
fig_qdcdist <- fig_qdcdist %>% add_trace (y = ~gasmig, name = "Gasmig")
fig_qdcdist <- fig_qdcdist %>% add_trace (y = ~CEG.RIO, name = "CEG Rio")
fig_qdcdist <- fig_qdcdist %>% add_trace (y = ~esgas, name = "ES Gás")
fig_qdcdist <- fig_qdcdist %>% add_trace (y = ~bahiagas, name = "Bahiagás")
fig_qdcdist <- fig_qdcdist %>% add_trace (y = ~copergas, name = "CoperGás")
fig_qdcdist <- fig_qdcdist %>% add_trace (y = ~sulgas, name = "Sulgás")
fig_qdcdist <- fig_qdcdist %>% add_trace (y = ~naturgy, name = "Naturgy SP")
fig_qdcdist <- fig_qdcdist %>% add_trace (y = ~compagas, name = "Compagás")
fig_qdcdist <- fig_qdcdist %>% add_trace (y = ~cegas, name = "Cegás")
fig_qdcdist <- fig_qdcdist %>% add_trace (y = ~necta, name = "Necta")
fig_qdcdist <- fig_qdcdist %>% add_trace (y = ~msgas, name = "MS Gás")
fig_qdcdist <- fig_qdcdist %>% add_trace (y = ~sergas, name = "Sergás")
fig_qdcdist <- fig_qdcdist %>% add_trace (y = ~pbgas, name = "PBGás")
fig_qdcdist <- fig_qdcdist %>% add_trace (y = ~algas, name = "Algás")
fig_qdcdist <- fig_qdcdist %>% add_trace (y = ~potigas, name = "Potigás")
fig_qdcdist <- fig_qdcdist %>%  plotly::layout(title = 'QDC contratada por Distribuidora',
                                               xaxis = list(title = 'Ano'),
                                               yaxis = list (title = 'Volume em m³/dia'),
                                               legend=list(title=list(text='<b> Distribuidora </b>'))) %>%
  layout(autosize = TRUE)
fig_qdcdist
```

### Modalidades de Contratação

```{r}
qdc_mod<- read.csv2("graph_files/qdc_mod.csv")
qdc_mod$data <- str_replace_all(qdc_mod$data, "/", "-")
qdc_mod$data <- lubridate::as_date(qdc_mod$data, format = '%d-%m-%Y')
qdc_mod %>% dplyr::filter(data >= "2024-01-01")-> qdc_mod
fig_qdcmod <- plotly::plot_ly(qdc_mod,
                              x = ~data,
                              y = ~firme.inflexivel,
                              name = 'Firme Inflexível', type = 'scatter', mode = 'none', stackgroup = 'one')
fig_qdcmod <- fig_qdcmod %>% add_trace (y = ~firme, name = "Firme")
fig_qdcmod <- fig_qdcmod %>% add_trace (y = ~interruptivel, name = "Interruptivel")
fig_qdcmod <- fig_qdcmod %>% add_trace (y = ~interruptivel, name = "Interruptivel")
fig_qdcmod <- fig_qdcmod %>%  plotly::layout(title = 'QDC Médio por Modalidade de Contratação',
                                             xaxis = list(title = 'Ano'),
                                             yaxis = list (title = 'Volume em m³/dia'),
                                             legend=list(title=list(text='<b> Modalidade </b>'))) %>%
  layout(autosize = TRUE)
fig_qdcmod
```

### Ambiente Regulado

```{r}
```

### Elegibilidade para Consumidor Livre

```{r}
```

### Consumidores Livres e Parcialmente Livres

```{r}
```

### Estados com Minuta de CUSD

```{r}
```

# Distribuição {data-icon="ion-pie-graph"}

## Column {.tabset}

### Áreas de Concessão

```{r}
areas_concedidas <- sf::read_sf('areas_concedidas/areas_concedidas.shp')

rename(areas_concedidas, Distribuidora = Dstrbdr) -> areas_concedidas

##tinha esquecido da distribuidora do RN##

areas_concedidas[14,1] <- "Potigás"

mapview::mapview(areas_concedidas, zcol = "Distribuidora", layer.name = "Distribuidora")


```

### Composição Acionária das Distribuidoras

### Extensão da Rede

```{r}
ext_rede<-read.csv2("graph_files/ext_rede.csv")
l <- list(
  font = list(
    family = "sans-serif",
    #size = 12,
    color = "#000"),
  bgcolor = "#E2E2E2",
  bordercolor = "#FFFFFF",
  borderwidth = 2,
  orientation = "h",   # show entries horizontally
  xanchor = "right",  # use center of legend as anchor
  x = 0.2, y =  - 0.2) 
m <- list(
  l = 10,
  r = 10,
  b = 100,
  t = 10,
  pad = 20
)
fig_ext <- plotly::plot_ly(ext_rede, 
                           x = ~ano, 
                           y = ~transport,
                           type = 'scatter',
                           mode = 'lines', 
                           name = 'Transporte')
fig_ext <- fig_ext %>% plotly::add_trace(y = ~distribuicao, 
                                         name = 'Distribuição', 
                                         mode = 'lines') 
fig_ext <- fig_ext %>% plotly::layout(title = 'Extensões das Redes de Transporte e Distribuição',
                                      xaxis = list(title = 'Ano'),
                                      yaxis = list (title = 'Quilômetros'),
                                      #legend = list(x = 0, y = 0.8),
                                      legend = list(x = 0.5, y = 1, 
                                                    xanchor = 'right', yanchor = 'top'),
                                      margin= m) %>%
  layout(autosize = TRUE)
fig_ext
```

### Número de Consumidores

```{r}
```

### Contratos de Concessão

```{r}
```

### Características das Áreas de Concessão

```{r}
```

# Sobre o Observatório {data-icon="ion-android-clipboard"}

## Column {.tabset}

### Centro de Estudos de Regulação e Infraestrutura

```{r}
```

### Participantes

```{r}
text_tbl <- data.frame(
  Variável = c("Tarifa Média Convencional", "Box Plot Tarifa Média Convencional","Perdas Não Técnicas Regulatórias", "Box Plot Perdas Não Técnicas Regulatórias"),
  Descrição = c(
    "Tarifa média convencional por estado", "Distribuição dos valores da tarifa média convencional por estado", "Perdas não técnicas regulatórias sobre baixa tensão faturado", "Distribuição dos valores das perdas não técnicas regulatórias sobre baixa tensão faturado" ),
  "Fontes_dos_Dados"= c("Tarifa média convencional por estado obtida no Ranking da Tarifa Residencial (ANEEL)", "Tarifa média convencional por estado obtida no Ranking da Tarifa Residencial (ANEEL)", "Relatório Perdas de Energia Elétrica na Distribuição (ANEEL)", "Relatório Perdas de Energia Elétrica na Distribuição (ANEEL)"),
  "Recorte_Temporal"= c("Set/2022","Set/2022","2021", "2021"),
  "Recorte_Geográfio"= c(rep("UF",4))
)

kbl(text_tbl, col.names = gsub("[_]", " ", names(text_tbl)), align = "c") %>%
  kable_paper(full_width = F) %>%
  column_spec(1, bold = T) %>%
  column_spec(2, width = "30em") %>%
  collapse_rows(columns = 3:4, valign = "middle")

```

### Apoiadores

```{r}
```