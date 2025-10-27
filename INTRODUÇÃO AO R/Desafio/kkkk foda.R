# Bibliotecas
library(rio) 
library(pliman) 
library(ggplot2)
library(dplyr)
library(tibble)
library(tidyr)
library(scales)
library(gridExtra)

# Setar diretório e importar dados
set_wd_here()
analiseFao <- import(file = "FAOSTAT_CO2.xlsx")
analiseBurnedArea <- import(file = "Burned_Area.csv")

# Variáveis globais
df_fao_humid <- data.frame()
df_fao_other <- data.frame()

# Separar DataFrame em dois (humid e other)
nFao <- nrow(analiseFao)
for (j in 1:nFao) {
  if (analiseFao[j, 3] == "Other forest") { 
    df_fao_other <- bind_rows(df_fao_other, analiseFao[j, ])
  } else {
    df_fao_humid <- bind_rows(df_fao_humid, analiseFao[j, ])
  }
}

# Definir unidade e substituir NA por 0
df_fao_humid[4] <- "kt"
df_fao_other[4] <- "kt"
df_fao_humid[is.na(df_fao_humid)] <- 0
df_fao_other[is.na(df_fao_other)] <- 0

# Pivot longer para manipulação
long_Fao_Humid <- pivot_longer(df_fao_humid, cols = c("2012":"2022"), names_to = "Ano", values_to = "Valor")
long_Fao_Other <- pivot_longer(df_fao_other, cols = c("2012":"2022"), names_to = "Ano", values_to = "Valor")

# Converter valores para numérico e somar
long_Fao_Humid$Valor <- as.numeric(long_Fao_Humid$Valor)
df_resumo_FAO_humid <- long_Fao_Humid %>%
  group_by(Area) %>%
  summarize(Soma_Valor = sum(Valor, na.rm = TRUE))

long_Fao_Other$Valor <- as.numeric(long_Fao_Other$Valor)
df_resumo_FAO_other <- long_Fao_Other %>%
  group_by(Area) %>%
  summarize(Soma_Valor = sum(Valor, na.rm = TRUE))

# Calcular proporção e organizar em ordem decrescente
valor_total_FAO_humid <- sum(df_resumo_FAO_humid$Soma_Valor, na.rm = TRUE)
df_resumo_FAO_humid <- df_resumo_FAO_humid %>%
  mutate(Proporcao = (Soma_Valor / valor_total_FAO_humid) * 100) %>%
  arrange(desc(Soma_Valor)) %>%
  top_n(10, Soma_Valor) # Pegar os top 10

df_fao_humid_top10 <- df_resumo_FAO_other %>% top_n(10, Soma_Valor) # Pegar os top 10

valor_total_FAO_other <- sum(df_resumo_FAO_other$Soma_Valor, na.rm = TRUE)
df_resumo_FAO_other <- df_resumo_FAO_other %>%
  mutate(Proporcao = (Soma_Valor / valor_total_FAO_other) * 100) %>%
  arrange(desc(Soma_Valor)) 

df_fao_other_top10 <- df_resumo_FAO_other %>% top_n(10, Soma_Valor) # Pegar os top 10

# Função para plotar gráficos de pizza com % nas fatias
plot_pizza <- function(df, title) {
  ggplot(df, aes(x = "", y = Proporcao, fill = Area)) +
    geom_bar(stat = "identity", width = 1) +
    coord_polar(theta = "y") +
    labs(title = title, x = NULL, y = NULL) +
    geom_text(aes(label = paste0(round(Proporcao, 1), "%")), 
              position = position_stack(vjust = 0.5), size = 4) + # Adiciona as % no gráfico
    theme_void() + 
    theme(legend.title = element_blank(), 
          plot.title = element_text(hjust = 0.5)) # Centraliza o título
}

# Plotar gráficos lado a lado com top 10
p1 <- plot_pizza(df_resumo_FAO_humid, "Top 10 Países que emitem CO2 (Humid)")
p2 <- plot_pizza(df_resumo_FAO_other, "Top 10 Países que emitem CO2 (Other)")

grid.arrange(p1, p2, ncol = 2)
