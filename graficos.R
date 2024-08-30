### Contratos Vigentes 

vig <- read_excel('vigentes_ano.xlsx')
vig <- vig %>% dplyr::rename(ano = index, num = '0')
fig_vig <- plotly::plot_ly(vig, x= ~ano, y=~num, name = 'numero de contratos',
                           type = 'scatter', mode = 'lines', line = list(width = 6))
fig_vig <- fig_vig %>% 
  layout(#title = list(text = 'Número total de contratos vigentes por ano', size = 60),
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
                            type = 'scatter', mode = 'lines', line = list(width = 6),
                            name = 'Comercializador')
fig_vigc <- fig_vigc %>% add_trace(y = ~livre, 
                                   name = 'Consumidor Livre')
fig_vigc <- fig_vigc %>% add_trace(y = ~distribuidor_gnc, 
                                   name = 'Distribuidora de GNC')
fig_vigc <- fig_vigc %>% add_trace(y = ~distribuidor_gnl, 
                                   name = 'Distribuidora de GNL')
fig_vigc <- fig_vigc %>% add_trace(y = ~distribuidora, 
                                   name = 'Distribuidora Local (Gás Canalizado)')
fig_vigc <- fig_vigc %>% add_trace(y = ~outros, 
                                   name = 'Outros')
fig_vigc <- fig_vigc %>% add_trace(y = ~produtor_boca, 
                                   name = 'Produtor (boca do poço)')
fig_vigc <- fig_vigc %>% layout(showlegend = TRUE, legend = list(font = list(size = 18)),
                                yaxis = list(title = list(text ='Comercializador', size = 18)),
                                xaxis = list(title = list(text ='Ano', size = 30)))
fig_vigc
