### Contratos Vigentes 

vig <- read_excel('vigentes_ano.xlsx')
vig <- vig %>% dplyr::rename(ano = index, num = '0')
fig_vig <- plotly::plot_ly(vig, x= ~ano, y=~num, name = 'numero de contratos',
                           type = 'scatter', mode = 'lines', line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[1]))
fig_vig <- fig_vig %>% 
  layout(#title = list(text = '', size = 60),
    yaxis = list(title = 'Número de contratos vigentes', size = 40),
    xaxis = list(title = 'Ano', size = 40))
fig_vig <- fig_vig %>% plotly::layout(annotations =
                                        list(x = 0, y = -0.1,
                                             text = '<b> Fonte </b>: ANP.',
                                             showarrow = F,
                                             xref = 'paper',
                                             yref = 'paper',
                                             align = 'left',
                                             size = 40))
fig_vig

### Vigências por tipo de Comprador
vig_c <- read_csv('vigencia_comprador.csv',
                  show_col_types = FALSE)
vig_c <- vig_c %>% dplyr::rename(livre = "consumidor livre",
                                 distribuidor_gnc = "distribuidor de gnc",
                                 distribuidor_gnl = "distribuidor de gnl",
                                 produtor_boca = "produtor (boca do poço)")
fig_vigc <- plotly::plot_ly(vig_c,
                            x = ~ano,
                            y =~comercializador,
                            type = 'scatter', mode = 'lines', line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[1]),
                            name = 'Comercializador')
fig_vigc <- fig_vigc %>% add_trace(y = ~livre, 
                                   name = 'Consumidor Livre', line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[2]))
fig_vigc <- fig_vigc %>% add_trace(y = ~distribuidor_gnc, 
                                   name = 'Distribuidora de GNC', line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[3]))
fig_vigc <- fig_vigc %>% add_trace(y = ~distribuidor_gnl, 
                                   name = 'Distribuidora de GNL', line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[4]))
fig_vigc <- fig_vigc %>% add_trace(y = ~distribuidora, 
                                   name = 'Distribuidora Local (Gás Canalizado)', line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[5]))
fig_vigc <- fig_vigc %>% add_trace(y = ~outros, 
                                   name = 'Outros', line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[6]))
fig_vigc <- fig_vigc %>% add_trace(y = ~produtor_boca, 
                                   name = 'Produtor (boca do poço)', line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[7]))
fig_vigc <- fig_vigc %>% layout(showlegend = TRUE, legend = list(font = list(size = 18)),
                                yaxis = list(title = list(text ='Comercializador', size = 18)),
                                xaxis = list(title = list(text ='Ano', size = 30)))
fig_vigc

### Assinaturas
#Quantidade de Contratos Assinados por Tipo de Comprador
ass <- read.csv('tabela_total_contratos.csv')
ass %>% dplyr::filter(ano >= '2020') -> ass

fig_ass <- plot_ly(ass, x = ~ano, y = ~comercializador, name = 'Comercializador',
                   type = 'scatter', mode = 'lines', line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[1]))
fig_ass <- fig_ass %>% add_trace(y = ~consumidor.livre, name = 'Consumidor Livre', line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[2]))
fig_ass <- fig_ass %>% add_trace(y = ~distribuidor.de.gnc, name = 'Distribuidora de GNC', line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[3]))
fig_ass <- fig_ass %>% add_trace(y = ~distribuidor.de.gnl, name = 'Distribuidora de GNL', line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[4]))
fig_ass <- fig_ass %>% add_trace(y = ~distribuidora, name = 'Distribuidora Local de Gás Canalizado', line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[5]))
fig_ass <- fig_ass %>% add_trace(y = ~produtor..boca.do.poço., name = 'Produtor (boca do poço)', line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[6]))
fig_ass <- fig_ass %>% add_trace(y = ~outros, name = 'Outros', line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[7]))

fig_ass <- fig_ass %>% add_trace(ass , 
                                 x = ~ano, 
                                 y = ~total, 
                                 type = 'scatter',  
                                 mode = 'lines', 
                                 name = 'Total')
fig_ass <- fig_ass %>% layout(title = "",
                              yaxis = list(title = 'Número de Contratos'),
                              xaxis = list(title = 'Ano'), 
                              barmode = 'group',
                              autosize = TRUE)
fig_ass <- fig_ass %>% plotly::layout(annotations =
                                        list(x = 0, y = -0.1,
                                             text = '<b> Fonte </b>: ANP',
                                             showarrow = F,
                                             xref = 'paper',
                                             yref = 'paper',
                                             align = 'left'))
fig_ass

### Market Share da Petrobrás
# Market Share da Petrobras em Relação às <br> Quantidades Diárias Contratadas
ms_petro<-read.csv2("graph_files/marketshare_petro.csv")
ms_petro$data <- stringr::str_replace_all(ms_petro$data, "/", "-")
ms_petro$data <- lubridate::as_date(ms_petro$data, format = '%d-%m-%Y')

ms_petro %>%
  dplyr::filter(data >= "2024-01-01" & data <= "2025-12-31") -> ms_petro
fig_ms <- plotly::plot_ly(ms_petro,
                          type = 'scatter', mode = 'lines', line = list(width = 6),
                          mode = 'lines')%>% add_trace(x = ~data,
                                                       y = ~ms,
                                                       name = 'Market Share')
fig_ms <- fig_ms %>% plotly::layout(title = '',
                                    xaxis = list(title = 'Ano'),
                                    yaxis = list (title = '%'),
                                    showlegend = FALSE)

fig_ms <- fig_ms %>% plotly::layout(annotations =
                                      list(x = 0, y = -0.1,
                                           text = '<b> Fonte </b>: Publicidade dos Contratos de Compra e Venda - ANP',                                      showarrow = F,
                                           xref = 'paper',
                                           yref = 'paper',
                                           align = 'left')
)

#ajustando as margens para caber a fonte#
fig_ms <- fig_ms %>% plotly::layout(margin =list(
  l = 50,
  r = 50,
  b = 100,
  t = 100,
  pad = 4))


### Oferta Nacional 

oferta_nacional <- read.csv2("oferta_nacional_mensal.csv")
oferta_nacional$data <- stringr::str_replace_all(oferta_nacional$data, "/", "-")
oferta_nacional$data <- lubridate::as_date(oferta_nacional$data, format = '%d-%m-%Y')
fig_ofertanac <- plotly::plot_ly(oferta_nacional,
                                 x = ~data,
                                 y = ~producao,
                                 name = 'Produção', type = 'scatter', mode = 'none', stackgroup = 'one', line = list(color = brewer.pal(n = 8, name = "Dark2")[1]))
fig_ofertanac <- fig_ofertanac %>% add_trace (y = ~reinjecao, name = "Reinjeção", line = list(color = brewer.pal(n = 8, name = "Dark2")[2]))
fig_ofertanac <- fig_ofertanac %>% add_trace (y = ~queima_perda, name = "Queimas e Perdas", line = list(color = brewer.pal(n = 8, name = "Dark2")[3]))
fig_ofertanac <- fig_ofertanac %>% add_trace (y = ~consumo_EeP, name = "Consumo E & P", line = list(color = brewer.pal(n = 8, name = "Dark2")[4]))
fig_ofertanac <- fig_ofertanac %>% add_trace (y = ~absorcao_upgn, name = "Absorção nas UPGN's", line = list(color = brewer.pal(n = 8, name = "Dark2")[5]))
fig_ofertanac <- fig_ofertanac %>% add_trace (y = ~oferta_liquida, name = "Oferta Líquida", line = list(color = brewer.pal(n = 8, name = "Dark2")[6]))
fig_ofertanac <- fig_ofertanac %>%  plotly::layout(title = '',
                                                   xaxis = list(title = 'Ano'),
                                                   yaxis = list (title = 'Volume em m³/dia'),
                                                   legend=list(title=list(text='<b> Fontes</b>'))) %>%
layout(margin = list(l = 50, r = 50, b = 50, t = 50, pad = 10))
fig_ofertanac

## Regulação 
# Limite para Enquadramento como Consumidor Livre
limite <- read.csv2('graph_files/limite_cl.csv')
limite %>%dplyr::mutate(limite = limite/1000) -> limite
fig_cl <- plotly::plot_ly(limite,
                          x = ~limite,
                          y = ~estado,
                          type = "bar",
                          orientation = "h",
                          hoverinfo = "none",
                          text = ~limite,
                          textposition = 'top')%>%
  layout(title = "",
         xaxis = list(title="Limite (em 1000 m³/dia)"),
         yaxis=list(title = "UF",
                    categoryorder="total descending"), ticksuffix = "   ")


fig_cl <- fig_cl %>%plotly::layout(annotations = list(x = .01, 
                                                     y = -0.06,
                                                     text = '<b>Fonte</b>: Regulações Estaduais',                                                    showarrow = F,
                                                     xref = 'paper',
                                                     yref = 'paper',
                                                     align = 'left',
                                                     margin = list(l = 50, r = 50, b = 50, t = 100, pad = 10)
))

### Oferta Internacional
# Oferta Internacional
oferta_imp <- read.csv2("oferta_importada_mensal.csv")
oferta_imp$data <- stringr::str_replace_all(oferta_imp$data, "/", "-")
oferta_imp$data <- lubridate::as_date(oferta_imp$data, format = '%d-%m-%Y')

fig_ofertaimp<- plotly::plot_ly(oferta_imp,
                                x = ~data,
                                y = ~argentina,
                                name = 'Argentina', type = 'scatter', mode = 'none', stackgroup = 'one',
                                line = list(color = brewer.pal(n = 8, name = "Dark2")[1]))
fig_ofertaimp <- fig_ofertaimp %>% add_trace (y = ~bolivia, name = "Boliviana",
                                              line = list(color = brewer.pal(n = 8, name = "Dark2")[2]))
fig_ofertaimp <- fig_ofertaimp %>% add_trace (y = ~regaseificacao_gnl, name = "Regaseificação (GNL)",
                                              line = list(color = brewer.pal(n = 8, name = "Dark2")[3]))
fig_ofertaimp <- fig_ofertaimp %>%  plotly::layout(title = '',
                                                   xaxis = list(title = 'Ano'),
                                                   yaxis = list (title = 'Volume em m³/dia'),
                                                   legend=list(title=list(text='<b>Fontes</b>'))) %>%
  layout(margin = list(l = 50, r = 50, b = 100, t = 100, pad = 4))

fig_ofertaimp <- fig_ofertaimp %>%plotly::layout(annotations = 
                                                   list(x = 0, y = -0.2,
                                                        text = '<b>Fonte</b>: Publicidade dos Contratos de Compra e Venda - ANP',                                      showarrow = F,
                                                        xref = 'paper',
                                                        yref = 'paper',
                                                        align = 'left')
)

### Reservas
#Reservas Relativas
reservas_prod <- read.csv2('reservas_prod.csv')
reservas_prod$data <- as.character(reservas_prod$data)
reservas_prod$data <- lubridate::as_date(reservas_prod$data, format = '%Y')
reservas_prod$reservas_pb <- as.integer(reservas_prod$reservas_pb)
reservas_prod$reservas_pl <- as.integer(reservas_prod$reservas_pl)

fig_res_prod <- plotly::plot_ly(reservas_prod,
                                x =~data,
                                y =~reservas_pl,
                                name = "Reservas/Produção Líquida",
                                type = 'scatter',
                                mode = 'lines', line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[1]))
fig_res_prod <- fig_res_prod %>% add_trace(y = ~reservas_pb,
                                           name = 'Reservas/Produção Líquida', line = list(width = 6,color = brewer.pal(n = 8, name = "Dark2")[2]))
fig_res_prod %>% plotly::layout(xaxis = list(title = 'Data'),
                                yaxis = list(title = 'R/P (Ano)'),
                                title = '')

#### Petrobras
#Produção por concessionários

prod <- read.csv2('graph_files/prod_concessionario.csv')
#Quando eu declaro o que eu quero mostrar quando passa o mouse por cima 
#eu tenho que formatar o número com separador de milhar e decimal por que por
#algum motivo o plotly tira a formatação bonitinha - então eu tenho que formatar dentro
# do código do gráfico mesmo

prod[1,1] <- "Petrobras"
prod[2,1] <- "Demais Concessionários"

prod_out <- read.csv2('graph_files/prod_outros.csv')
prod_out%>%dplyr::mutate(perc_res = round(residual*100, digits = 2)) -> prod_out

fig_teste <- plot_ly()
fig_teste <- fig_teste%>% add_bars(prod,
                                  x = ~prod$concessionario,
                                  y = ~prod$barris,
                                  #textinfo = "label" ),
                                  #domain = list(x = c(0, 0.4), y = c(0.4, 1)),
                                  # domain = list(row = 0, column = 0),
                                  hoverinfo = 'text',
                                  hovertext = paste("<b>Produção de Petróleo (em barris):</b>",formatC(prod$barris, 
                                                                                                       format="f",
                                                                                                       big.mark = ".",
                                                                                                       decimal.mark = ",",
                                                                                                       digits=2),
                                                    "<br><b>Produção de Gás Natural (em mil m³):</b>",formatC(prod$gn,
                                                                                                              format="f",
                                                                                                              big.mark = ".",
                                                                                                              decimal.mark = ",",
                                                                                                              digits=2))
                                  )
fig_teste <- fig_teste %>% layout(title = "",
                                  showlegend = F,
                                  #height = 900,
                                  # grid=list(rows=1, columns=2),
                                  xaxis = list(title = "Concessionário", showgrid = FALSE, zeroline = FALSE, showticklabels = TRUE),
                                  yaxis = list(title = "Barris", showgrid = TRUE, zeroline = TRUE, showticklabels = TRUE))
fig_teste

fig_teste1 <- plot_ly()
fig_teste1 <- fig_teste1 %>%  add_bars(prod_out,
                                  x = ~prod_out$concessionario,
                                  y = ~prod_out$perc_res,
                                  domain = list(x = c(0.35, 0.75), y = c(0.4, 1)),
                                  # domain = list(row = 0, column = 1),
                                  textinfo = 'value+label',
                                  hoverinfo = 'text',
                                  hovertext = paste("<b>Produção de Petróleo (em Barris):</b>", formatC(prod_out$barris,
                                                                                                        format="f",
                                                                                                        big.mark = ".",
                                                                                                        decimal.mark = ",",
                                                                                                        digits=2),
                                                    "<br><b>Produção de Gás Natural (em mil m³):</b>", formatC(prod_out$gn,
                                                                                                               format="f",
                                                                                                               big.mark = ".",
                                                                                                               decimal.mark = ",",
                                                                                                               digits=2)))
fig_teste1 <- fig_teste1 %>% layout(title = "",
                                  showlegend = F,
                                  #height = 900,
                                  # grid=list(rows=1, columns=2),
                                  xaxis = list(title = "Concessionário", showgrid = FALSE, zeroline = FALSE, showticklabels = TRUE),
                                  yaxis = list(title = "%", showgrid = TRUE, zeroline = TRUE, showticklabels = TRUE))

fig_teste1

### Oferta Interna

oferta_int <-read.csv2('oferta_interna.csv')
oferta_int$data <- as.character(oferta_int$data)
oferta_int$data <- lubridate::as_date(oferta_int$data, 
                                      format = '%Y')
fig_ofertaint<- plotly::plot_ly(oferta_int,
                                x = ~data,
                                y = ~produca_bruta,
                                name = 'Produção Bruta', 
                                type = 'scatter', 
                                mode = 'none', 
                                stackgroup = 'one', 
                                line = list(width = 6,color = brewer.pal(n = 8, name = "Dark2")[1]))
fig_ofertaint <- fig_ofertaint %>% add_trace (y = ~import, 
                                              name = "Importação", line = list(width = 6,color = brewer.pal(n = 8, name = "Dark2")[2]))
fig_ofertaint <- fig_ofertaint %>% add_lines(y = ~oferta_interna, 
                                             name = 'Oferta Interna', 
                                             fill = 'none', 
                                             stackgroup = 'two', line = list(width = 6,color = brewer.pal(n = 8, name = "Dark2")[3]))
fig_ofertaint <- fig_ofertaint %>% add_lines(y = ~reinj_perdas, 
                                             name = 'Reinjeção e Perdas', 
                                             fill = 'none', 
                                             stackgroup = 'three', line = list(width = 6,color = brewer.pal(n = 8, name = "Dark2")[4]))
fig_ofertaint   <- fig_ofertaint   %>%  plotly::layout(title = '',
                                                       xaxis = list(title = 'Ano'),
                                                       yaxis = list (title = 'Volume em milhões de m³/dia'),
                                                       legend=list(title=list(text='<b> Fontes </b>')))

### Demanda por segmento de consumo 
demanda_seg <- read.csv2("demanda_segmento.csv")
demanda_seg$data <- stringr::str_replace_all(demanda_seg$data, "/", "-")
demanda_seg$data <- lubridate::as_date(demanda_seg$data, format = '%d-%m-%Y')
fig_demandaseg<- plotly::plot_ly(demanda_seg,
                                 x = ~data,
                                 y = ~industrial,
                                 name = 'Industrial', type = 'scatter', mode = 'none', stackgroup = 'one',
                                 line = list(width = 1,color = brewer.pal(n = 8, name = "Dark2")[1]))
fig_demandaseg <- fig_demandaseg %>% add_trace (y = ~automotivo, name = "Automotivo", line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[2]))
fig_demandaseg <- fig_demandaseg %>% add_trace (y = ~ger_ele, name = "Geração Elétrica", line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[4]))
fig_demandaseg <- fig_demandaseg %>% add_trace (y = ~cogeracao, name = "Cogeração", line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[5]))
fig_demandaseg <- fig_demandaseg %>% add_trace (y = ~residencial, name = "Residencial", line = list(width = 2,color = brewer.pal(n = 8, name = "Dark2")[5]))
fig_demandaseg <- fig_demandaseg %>% add_trace (y = ~comercial, name = "Comercial", line = list(width = 2,color = brewer.pal(n = 8, name = "Dark2")[6]))
fig_demandaseg <- fig_demandaseg %>% add_trace (y = ~outros_mais_GNC, name = "Outros (incluindo GNC)", line = list(width = 2,color = brewer.pal(n = 8, name = "Dark2")[3]))

fig_demandaseg <- fig_demandaseg %>%  plotly::layout(title = '',
                                                     xaxis = list(title = 'Ano'),
                                                     yaxis = list (title = 'Volume em m³/dia'),
                                                     legend=list(title=list(text='<b> Segmentos </b>'))) %>%
  layout(margin = list(l = 50, r = 50, b = 50, t = 50, pad = 10))
fig_demandaseg

### Demanda por distribuidora com segmento termelétrico

demanda_dist <- read.csv2("demanda_distribuidora_com_termica.csv")
demanda_dist%>%dplyr::rename(data = X) -> demanda_dist
demanda_dist$data <- stringr::str_replace_all(demanda_dist$data, "/", "-")
demanda_dist$data <- lubridate::as_date(demanda_dist$data, format = '%d-%m-%Y')
fig_demandist<- plotly::plot_ly(demanda_dist,
                                x = ~data,
                                y = ~comgas,
                                name = 'Comgás', type = 'scatter', mode = 'none', stackgroup = 'one', 
                                line = list(width = 2,color = brewer.pal(n = 8, name = "Dark2")[1]))
fig_demandist<- fig_demandist %>% add_trace (y = ~ceg, name = "CEG",
                                             line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[2]))
fig_demandist<- fig_demandist %>% add_trace (y = ~ceg_rio, name = "CEG Rio",
                                             line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[3]))
fig_demandist<- fig_demandist %>% add_trace (y = ~bahiagas, name = "BahiaGás",
                                             line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[4]))
fig_demandist<- fig_demandist %>% add_trace (y = ~copergas, name = "Copergás",
                                             line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[5]))
fig_demandist<- fig_demandist %>% add_trace (y = ~cigas, name = "Cigás",
                                             line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[6]))
fig_demandist<- fig_demandist %>% add_trace (y = ~gasmig, name = "Gasmig",
                                             line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[7]))
fig_demandist<- fig_demandist %>% add_trace (y = ~esgas, name = "ES Gás",
                                             line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[8]))
fig_demandist<- fig_demandist %>% add_trace (y = ~gasmar, name = "Gasmar",
                                             line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[1]))
fig_demandist<- fig_demandist %>% add_trace (y = ~sulgas, name = "Sul Gás",
                                             line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[2]))
fig_demandist<- fig_demandist %>% add_trace (y = ~scgas, name = "SC Gás",
                                             line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[3]))
fig_demandist<- fig_demandist %>% add_trace (y = ~compagas, name = "Compagas",
                                             line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[4]))
fig_demandist<- fig_demandist %>% add_trace (y = ~msgas, name = "MS Gás",
                                             line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[5]))
fig_demandist<- fig_demandist %>% add_trace (y = ~cegas, name = "Cegás",
                                             line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[5]))
fig_demandist<- fig_demandist %>% add_trace (y = ~naturgy_sp, name = "Naturgy SP",
                                             line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[6]))
fig_demandist<- fig_demandist %>% add_trace (y = ~gas_brasiliano, name = "Gas Brasiliano",
                                             line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[7]))
fig_demandist<- fig_demandist %>% add_trace (y = ~algas, name = "Algás",
                                             line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[8]))
fig_demandist<- fig_demandist %>% add_trace (y = ~potigas, name = "Potigás",
                                             line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[1]))
fig_demandist<- fig_demandist %>% add_trace (y = ~pbgas, name = "PB Gás",
                                             line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[2]))
fig_demandist<- fig_demandist %>% add_trace (y = ~cebgas, name = "Cebgás",
                                             line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[3]))
fig_demandist<- fig_demandist %>% add_trace (y = ~mtgas, name = "MT Gás",
                                             line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[4]))
fig_demandist<- fig_demandist %>% add_trace (y = ~goiasgas, name = "Goiás Gás",
                                             line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[5]))
fig_demandist<- fig_demandist %>% add_trace (y = ~gaspisa, name = "Gaspisa",
                                             line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[6]))
fig_demandist <- fig_demandist %>%  plotly::layout(title = 'Demanda (Com termelétricas)',
                                                   xaxis = list(title = 'Ano'),
                                                   yaxis = list (title = 'Volume em m³/dia'),
                                                   legend=list(title=list(text='<b> Distribuidoras </b>'))) %>%
  layout(margin = list(l = 50, r = 50, b = 50, t = 50, pad = 10))

#### Demanda por distribuidora sem segmento termelétrico 
demanda_dist_st <- read.csv2("demanda_distribuidora_sem_termica.csv")
demanda_dist_st$data <- stringr::str_replace_all(demanda_dist_st$data, "/", "-")
demanda_dist_st$data <- lubridate::as_date(demanda_dist_st$data, format = '%d-%m-%Y')
fig_demandist_st<- plotly::plot_ly(demanda_dist_st,
                                   x = ~data,
                                   y = ~comgas,
                                   name = 'Comgás', type = 'scatter', mode = 'none', stackgroup = 'one',
                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[1]))
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~ceg, name = "CEG",
                                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[2]))
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~ceg_rio, name = "CEG Rio",
                                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[3]))
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~bahiagas, name = "BahiaGás",
                                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[4]))
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~copergas, name = "Copergás",
                                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[5]))
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~cigas, name = "Cigás",
                                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[6]))
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~gasmig, name = "Gasmig",
                                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[7]))
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~esgas, name = "ES Gás",
                                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[8]))
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~gasmar, name = "Gasmar",
                                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[1]))
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~sulgas, name = "Sul Gás",
                                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[2]))
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~scgas, name = "SC Gás",
                                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[3]))
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~compagas, name = "Compagas",
                                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[4]))
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~msgas, name = "MS Gás",
                                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[5]))
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~cegas, name = "Cegás",
                                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[6]))
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~naturgy_sp, name = "Naturgy SP",
                                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[7]))
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~gas_brasiliano, name = "Gas Brasiliano",
                                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[8]))
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~algas, name = "Algás",
                                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[1]))
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~potigas, name = "Potigás",
                                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[2]))
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~pbgas, name = "PB Gás",
                                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[3]))
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~cebgas, name = "Cebgás",
                                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[4]))
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~mtgas, name = "MT Gás",
                                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[5]))
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~goiasgas, name = "Goiás Gás",
                                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[6]))
fig_demandist_st<- fig_demandist_st %>% add_trace (y = ~gaspisa, name = "Gaspisa",
                                                   line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[7]))
fig_demandist_st <- fig_demandist_st %>%  plotly::layout(title = '',
                                                         xaxis = list(title = 'Ano'),
                                                         yaxis = list (title = 'Volume em m³/dia'),
                                                         legend=list(title=list(text='<b> Distribuidoras </b>'))) %>%
  layout(margin = list(l = 50, r = 50, b = 50, t = 50, pad = 10))

### Consumo não-termelétrico
consumo_70 <-read.csv2('consumo_70.csv')
consumo_70$data <- stringr::str_replace_all(consumo_70$data, "/", "-")
consumo_70$data <- lubridate::as_date(consumo_70$data, format = '%d-%m-%Y')
fig_consumo70 <- plotly::plot_ly(consumo_70,
                                 x = ~data,
                                 y=~quimica,
                                 type = 'scatter', 
                                 mode = 'none', 
                                 stackgroup = 'one',
                                 name = 'Química',
                                 line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[1])) %>%
  add_trace(y=~ferro_gusa_aco,name = 'Ferro-Gusa e Aço',
            line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[2])) %>%
  add_trace(y=~ceramica,name = 'Cerâmica',
            line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[3])) %>%
  add_trace(y=~papel_celulose,name = 'Papel e Celulose',
            line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[4])) %>%
  add_trace(y=~alimentos_bebidas,name = 'Alimentos e Bebidas',
            line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[5])) %>%
  add_trace(y=~nao_ferroso,name = 'Não-Ferrosos e Outros (Metalurgia)',
            line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[6])) %>%
  add_trace(y=~mineiracao,name = 'Mineração e Pelotização',
            line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[7])) %>%
  add_trace(y=~textil,name = 'Têxtil',
            line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[8])) %>%
  add_trace(y=~outros_industrial,name = 'Outros (Industrial)',
            line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[1])) %>%
  add_trace(y=~residencial_com,name = 'Residencial, Comercial e Público',
            line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[2])) %>%
  add_trace(y=~transporte_gnv,name = 'Transportes (GNV)',
            line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[3])) %>%
  add_trace(y=~nao_energetico,name = 'Não Energético (matéria prima)',
            line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[4])) %>%
  add_trace(y=~refino_petroleo,name = 'Refino de Petróleo',
            line = list(width = 2, color = brewer.pal(n = 8, name = "Dark2")[5]))

fig_consumo70 %>% plotly::layout(xaxis = list(title = 'Data'),
                                 yaxis = list(title = 'Milhões'),
                                 title="")




### Balanço Nacional Mensal
balanco <-read.csv2("balanco.csv")
balanco$data <- stringr::str_replace_all(balanco$data, "/", "-")
balanco$data <- lubridate::as_date(balanco$data, format = '%d-%m-%Y')
fig_balanco<- plotly::plot_ly(balanco,
                              x = ~data,
                              y = ~oferta_nacional,
                              name = 'Oferta Nacional', 
                              type = 'scatter', 
                              mode = 'none', 
                              stackgroup = 'one',
                              legendgroup = 'group1',
                              line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[1]))
fig_balanco<- fig_balanco %>% add_trace (y = ~oferta_boliviana, 
                                         name = "Bolívia",
                                         legendgroup = 'group1',
                                         line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[2]))
fig_balanco<- fig_balanco %>% add_trace (y = ~gnl, 
                                         name = "GNL",
                                         legendgroup = 'group1',
                                         line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[3]))
#se quando eu não quiser empilhar é so colocar em outro stackgroup
fig_balanco <- fig_balanco %>% add_lines(y = ~perdas_ajustes, 
                                         name = 'Perdas e Ajustes', 
                                         fill = 'none', 
                                         stackgroup = 'two',
                                         legendgroup = 'group2',
                                         line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[4]))
fig_balanco <- fig_balanco %>% add_lines(y = ~demanda_nt, 
                                         name = 'Demanda Não Termelétrica', 
                                         fill = 'none', 
                                         stackgroup = 'two',
                                         legendgroup = 'group2',
                                         line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[5]))
fig_balanco  <- fig_balanco  %>%  plotly::layout(title = '',
                                                 xaxis = list(title = 'Ano'),
                                                 yaxis = list (title = 'Volume em milhões de m³/dia'),
                                                 legend=list(title=list(text='<b> Oferta e Demanda </b>')))
fig_balanco

### Balanço Nacional Anual
balanco_anual<-read.csv2('balanco_anual.csv')
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
                                    legendgroup = 'group1',
                                    line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[1]))
fig_balanco_anual<- fig_balanco_anual %>% add_trace (y = ~oferta_bolivia, 
                                                     name = "Bolívia",
                                                     legendgroup = 'group1',
                                                     line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[2]))
fig_balanco_anual<- fig_balanco_anual %>% add_trace (y = ~gnl, 
                                                     name = "GNL",
                                                     legendgroup = 'group1',
                                                     line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[3]))
#se quando eu não quiser empilhar é so colocar em outro stackgroup
fig_balanco_anual <- fig_balanco_anual %>% add_lines(y = ~perdas_ajustes, 
                                                     name = 'Perdas e Ajustes', 
                                                     fill = 'none', 
                                                     stackgroup = 'two',
                                                     legendgroup = 'group2',
                                                     line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[4]))
fig_balanco_anual <- fig_balanco_anual %>% add_lines(y = ~demanda_nt, 
                                                     name = 'Demanda Não Termelétrica', 
                                                     fill = 'none', 
                                                     stackgroup = 'two',
                                                     legendgroup = 'group2',
                                                     line = list(width = 6, color = brewer.pal(n = 8, name = "Dark2")[5]))
fig_balanco_anual  <- fig_balanco_anual  %>%  plotly::layout(title = '',
                                                             xaxis = list(title = 'Ano'),
                                                             yaxis = list (title = 'Volume em milhões de m³/dia'),
                                                             legend=list(title=list(text='<b> Oferta e Demanda </b>')))
fig_balanco_anual

# Comercialização {data-icon="ion-ios-paper-outline"}
## Column {.tabset}
### QDC contratada por região
qdc_reg<- read.csv2("qdc_reg.csv")
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
fig_qdcreg <- fig_qdcreg %>%  plotly::layout(title = '',
                                             xaxis = list(title = 'Ano'),
                                             yaxis = list (title = 'Volume em m³/dia'),
                                             legend=list(title=list(text='<b> Região </b>'))) %>% layout(autosize = TRUE)
fig_qdcreg <- fig_qdcreg %>% plotly::layout(annotations = list(x = 0, 
                                                               y = -0.10,
                                                               text = '<b> Fonte </b>: Publicidade dos Contratos de Compra e Venda - ANP',                                                    showarrow = F,
                                                               xref = 'paper',
                                                               yref = 'paper',
                                                               align = 'left',
                                                               margin = list(l = 50, r = 50, b = 100, t = 100, pad = 4)
))

### QDC contratada por Estado
qdc_uf<- read.csv2("qdc_uf.csv")
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
fig_qdcuf <- fig_qdcuf %>%  plotly::layout(title = '',
                                           xaxis = list(title = 'Ano'),
                                           yaxis = list (title = 'Volume em m³/dia'),
                                           legend=list(title=list(text='<b> Estado </b>',
                                                                  orientation = "h",   # show entries horizontally
                                                                  xanchor = "center",  # use center of legend as anchor
                                                                  x = 0.5))) %>% 
  layout(margin = list(l = 50, r = 50, b = 50, t = 50, pad = 10))

### Comercialização entre Produtores
#Quantidade Diária Contratada por Fornecedor
qdc_for <- read.csv2("qdc_fornecedor.csv")
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
fig_qdcfor <- fig_qdcfor %>% plotly::layout(title = '',
                                            xaxis = list(title = 'Ano'),
                                            yaxis = list (title = 'Volume em m³/dia'))


### Contratação das Distribuidoras
#'Quantidade Diária Contratada por Distribuidora
qdc_dist<- read.csv2("qdc_dist.csv")
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
fig_qdcdist <- fig_qdcdist %>%  plotly::layout(title ="",
                                               xaxis = list(title = 'Ano'),
                                               yaxis = list (title = 'Volume em m³/dia'),
                                               legend=list(title=list(text='<b> Distribuidora </b>'))) %>% layout(autosize = TRUE)

### Modalidades de Contratação
#Quantidade Diária Contratada Média por Modalidade de Contratação
qdc_mod<- read.csv2("qdc_mod.csv")
qdc_mod$data <- str_replace_all(qdc_mod$data, "/", "-")
qdc_mod$data <- lubridate::as_date(qdc_mod$data, format = '%d-%m-%Y')
qdc_mod %>% dplyr::filter(data >= "2024-01-01")-> qdc_mod
fig_qdcmod <- plotly::plot_ly(qdc_mod,
                              x = ~data,
                              y = ~firme.inflexivel,
                              name = 'Firme Inflexível', type = 'scatter', mode = 'none', stackgroup = 'one')
fig_qdcmod <- fig_qdcmod %>% add_trace (y = ~firme, name = "Firme")
fig_qdcmod <- fig_qdcmod %>% add_trace (y = ~interruptivel, name = "Interruptivel")
fig_qdcmod <- fig_qdcmod %>%  plotly::layout(title = '',
                                             xaxis = list(title = 'Ano'),
                                             yaxis = list (title = 'Volume em m³/dia'),
                                             legend=list(title=list(text='<b> Modalidade </b>'))) %>%
  layout(autosize = TRUE)



### Extensão da Rede
#Extensões das Redes de Transporte e Distribuição
ext_rede<-read.csv2("ext_rede.csv")
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
                           name = 'Transporte',
                           type = 'scatter', mode = 'lines', line = list(width = 6,color = brewer.pal(n = 8, name = "Dark2")[1]))

fig_ext <- fig_ext %>% plotly::add_trace(y = ~distribuicao, 
                                         name = 'Distribuição', 
                                         mode = 'lines', 
                                         line = list(width = 6,color = brewer.pal(n = 8, name = "Dark2")[2]))
fig_ext <- fig_ext %>% plotly::layout(title = '',
                                      xaxis = list(title = 'Ano'),
                                      yaxis = list (title = 'Quilômetros')
                                      #legend = list(x = 0, y = 0.8),
                                      #legend = list(x = 0.5, y = 1),
                                      #margin= m
) %>%
  layout(autosize = TRUE)






