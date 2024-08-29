###Raschunho - Reserva

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
