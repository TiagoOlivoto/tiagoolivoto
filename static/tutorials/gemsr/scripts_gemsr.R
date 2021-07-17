## ----collapse = TRUE, message=FALSE, warning=FALSE-------------------------------------------------
library(tidyverse)  # manipulação de dados
library(metan)
library(rio)        # importação/exportação de dados

# gerar tabelas html
print_tbl <- function(table, digits = 3, n = NULL, ...){
  if(!missing(n)){
    knitr::kable(head(table, n = n), booktabs = TRUE, digits = digits, ...)
  } else{
  knitr::kable(table, booktabs = TRUE, digits = digits, ...)
  }
}


## ----collapse = TRUE-------------------------------------------------------------------------------
str <- c ("Env1", "env 1", "env.1")
str %>% factor() %>% levels()


## ----collapse = TRUE-------------------------------------------------------------------------------
tidy_strings(str)


## ----collapse = TRUE-------------------------------------------------------------------------------
messy_env <- c ("ENV 1", "Env 1", "Env1", "env1", "Env.1", "Env_1")
tidy_strings(messy_env)


## ----collapse = TRUE-------------------------------------------------------------------------------
messy_gen <- c ("GEN1", "gen 2", "Gen.3", "gen-4", "Gen_5", "GEN_6")
tidy_strings(messy_gen)


## ----collapse = TRUE-------------------------------------------------------------------------------
messy_int <- c ("EnvGen", "Env_Gen", "env gen", "Env Gen", "ENV.GEN", "ENV_GEN")
tidy_strings(messy_int)


## ----collapse = TRUE-------------------------------------------------------------------------------
df <- tibble(Env = messy_env,
             gen = messy_gen,
             Env_Gen = interaction(Env, gen),
             y = rnorm(6, 300, 10))
print_tbl(df)

df_tidy <- tidy_strings(df, sep = "")
print_tbl(df)


## ----collapse = TRUE,  message = FALSE, warning=FALSE----------------------------------------------
# Dados "bagunçados"
# Apenas 40 linhas 
df_messy <- import("http://bit.ly/df_messy", setclass = "tbl")
df_messy %>% print_tbl(n = 40)



## ----collapse = TRUE-------------------------------------------------------------------------------
df_tidy <- 
  df_messy %>% 
  tidy_colnames() %>% # formata nomes das variáveis
  fill_na() %>%  # preenche NAs
  tidy_strings(sep = "") # formata strings

df_tidy %>% print_tbl(n = 40)

# exportar os dados 'arrumados'
# export(df_tidy, "df_tidy.xlsx")


## ----collapse = TRUE-------------------------------------------------------------------------------
df_tidy2 <- 
  add_cols(df_tidy,
           ALT_PLANT_CM = ALT_PLANT * 100,
           .after = ALT_PLANT)
print_tbl(df_tidy2, n = 5)


## ----collapse = TRUE-------------------------------------------------------------------------------
select_cols(df_tidy, ENV, GEN) %>% print_tbl(n = 5)
select_rows(df_tidy, 1:3) %>% print_tbl(n = 5)


## ----collapse = TRUE-------------------------------------------------------------------------------
select_numeric_cols(df_tidy) %>% print_tbl(n = 5)


# Implementação dplyr
select(df_tidy, where(is.numeric)) %>% print_tbl(n = 5)


select_non_numeric_cols(df_tidy) %>% print_tbl(n = 5)


# Implementação dplyr
select(df_tidy, where(~!is.numeric(.x))) %>% print_tbl(n = 5)


## ----collapse = TRUE-------------------------------------------------------------------------------
select_first_col(df_tidy) %>% print_tbl(n = 5)
select_last_col(df_tidy) %>% print_tbl(n = 5)


## ----collapse = TRUE-------------------------------------------------------------------------------
remove_cols(df_tidy, ENV, GEN) %>% print_tbl(n = 5)

# Implementação dplyr
select(df_tidy, -c(ENV, GEN)) %>% print_tbl(n = 5)



## ----collapse = TRUE-------------------------------------------------------------------------------
concatenado <- 
  concatenate(df_tidy, ENV, GEN, BLOCO,
              .after = BLOCO, 
              new_var = FATORES)
print_tbl(concatenado, n = 5)


## ----collapse = TRUE-------------------------------------------------------------------------------
concatenate(df_tidy, ENV, GEN, BLOCO, drop = TRUE) %>% head()
concatenate(df_tidy, ENV, GEN, BLOCO, pull = TRUE) %>% head()


## ----collapse = TRUE-------------------------------------------------------------------------------
get_levels(df_tidy, ENV)
get_level_size(df_tidy, ENV) %>% print_tbl()


## ----collapse = TRUE-------------------------------------------------------------------------------
round_cols(df_tidy, digits = 1) %>% print_tbl(n = 5)


## ----collapse = TRUE-------------------------------------------------------------------------------
round_cols(df_tidy, ALT_PLANT:COMPES, digits = 0) %>% print_tbl(n = 5)


## ----collapse = TRUE-------------------------------------------------------------------------------
extract_number(df_tidy, GEN) %>% print_tbl(n = 5)


## ----collapse = TRUE-------------------------------------------------------------------------------
replace_number(df_tidy,
               BLOCO,
               pattern  = "1",
               replacement  = "Rep_1") %>% 
  print_tbl(n = 5)


## ----collapse = TRUE-------------------------------------------------------------------------------
extract_string(df_tidy, GEN) %>% print_tbl(n = 5)


## ----collapse = TRUE-------------------------------------------------------------------------------
replace_string(df_tidy,
               GEN,
               pattern = "H",
               replacement  = "GEN_") %>% 
  print_tbl(n = 5)


## ----collapse = TRUE-------------------------------------------------------------------------------
remove_strings(df_tidy) %>% print_tbl(n = 5)


## ----collapse = TRUE-------------------------------------------------------------------------------
df_selegen <- 
  df_to_selegen_54(df_tidy,
                   env = ENV,
                   gen = GEN,
                   rep = BLOCO)
print_tbl(df_selegen, n = 15)



## ----collapse = TRUE-------------------------------------------------------------------------------
df_list <- split_factors(df_tidy, ENV)
df_list
rbind_fill_id(df_list, .id = "AMBIENTE")


## ----collapse = TRUE-------------------------------------------------------------------------------
# Cria uma tabela bidirecional
tab <- make_mat(df_tidy,
                row = GEN,
                col = ENV,
                value = NGE)
print_tbl(tab)


# máximo valor observado
tab2 <- make_mat(df_tidy,
                row = GEN,
                col = ENV,
                value = NGE,
                fun = max)
print_tbl(tab2)

# soma de linhas e colunas
row_col_sum(tab) %>% print_tbl()

# média de linhas e colunas
row_col_mean(tab) %>% print_tbl()


## ----collapse = TRUE,  message = FALSE, warning=FALSE----------------------------------------------
# Dados "bagunçados"
df_messy <- import("http://bit.ly/df_messy", setclass = "tbl") %>% head(20)




## ----collapse = TRUE,  message = FALSE, warning=FALSE----------------------------------------------

# checar para ver se tem NA
has_na(df_messy)

# remover colunas com NA
remove_cols_na(df_messy) %>% print_tbl()

# remover linhas com NA
remove_rows_na(df_messy) %>% print_tbl()

# selecionar colunas com NA
select_cols_na(df_messy) %>% print_tbl()

# selecionar colunas com NA
select_rows_na(df_messy) %>% print_tbl()

# substituir NA por um valor
replace_na(df_messy, replacement = "FALTA")


## ----collapse = TRUE,  message = FALSE, warning=FALSE----------------------------------------------

# checar para ver se tem NA
has_zero(df_messy)

# remover colunas com NA
remove_cols_zero(df_messy) %>% print_tbl()

# remover linhas com NA
remove_rows_zero(df_messy) %>% print_tbl()

# selecionar colunas com NA
select_cols_zero(df_messy) %>% print_tbl()

# selecionar colunas com NA
select_rows_zero(df_messy) %>% print_tbl()

# substituir NA por um valor
replace_zero(df_messy, replacement = NA) # padrão


## ---- echo=FALSE, eval=TRUE------------------------------------------------------------------------


## ----collapse = TRUE, message = FALSE, warning=FALSE-----------------------------------------------
library(metan)
library(rio)

# gerar tabelas html
print_tbl <- function(table, digits = 3, ...){
  knitr::kable(table, booktabs = TRUE, digits = digits, ...)
}

# Dados "arrumados"
df_tidy <- import("http://bit.ly/df_tidy", setclass = "tbl")



## ----collapse = TRUE-------------------------------------------------------------------------------
inspect(df_tidy)


# converter as três primeiras colunas para fator
df_ok <- 
  df_tidy %>% 
  metan::as_factor(1:3)



## ----collapse = TRUE-------------------------------------------------------------------------------
# Encontrar fragmentos de texto
find_text_in_num(df_ok, MMG)
df_ok[112, 12]

# substitui '..' por '.' e converte para numérico
df_ok <- 
  df_ok %>% 
  replace_string(MMG, pattern = "\\.{2}", replacement = ".") %>% 
  as_numeric(MMG)



## ----collapse = TRUE, fig.width=10, fig.height=10--------------------------------------------------
df_ok <- 
  df_ok %>% 
  replace_zero(ALT_PLANT)

# Nova inspeção
inspect(df_ok, plot = TRUE)



## ----collapse = TRUE, fig.width=10, fig.height=8---------------------------------------------------
# Outlier NFIL
find_outliers(df_ok, NFIL, plots = TRUE)

# Outlier NGE
find_outliers(df_ok, NGE, plots = TRUE)


# Corrigir valores
df_ok[22, 13] <- 530.2

# Exportar df_ok
# export(df_ok, "df_ok.xlsx")

## ---- echo=FALSE, eval=TRUE------------------------------------------------------------------------


## ----collapse = TRUE, message = FALSE, warning=FALSE-----------------------------------------------
library(metan)
library(rio)

# gerar tabelas html
print_tbl <- function(table, digits = 3, ...){
  knitr::kable(table, booktabs = TRUE, digits = digits, ...)
}

# dados
df <- import("http://bit.ly/df_ok", setclass = "tbl")
inspect(df, verbose = FALSE) %>% print_tbl()


## ----collapse = TRUE-------------------------------------------------------------------------------
mean(df$MGE)


## ----collapse = TRUE-------------------------------------------------------------------------------
aggregate(MGE ~ GEN, data = df, FUN = mean) %>% print_tbl()



## ----collapse = TRUE-------------------------------------------------------------------------------
ov_mean <- means_by(df)
print_tbl(ov_mean)


## ----collapse = TRUE-------------------------------------------------------------------------------
means_gen <- means_by(df, GEN)
print_tbl(means_gen)



## ----collapse = TRUE-------------------------------------------------------------------------------
# Erro padrão da média para variáveis numéricas que contém (SAB)
df %>% sem(contains("SAB")) %>% print_tbl()


# Intervalo de confiança 0,95 para a média
# Variáveis com largura de nome maior que 3 caracteres
# Agrupado por níveis de ENV
df %>%
  group_by(ENV) %>%
  ci_mean(width_greater_than(3)) %>% 
  print_tbl()


## ----collapse = TRUE,, mensagem = FALSE, fig.height = 5, fig.width = 10, fig.align =" center "-----
all <- desc_stat(df, stats = "all")
print_tbl(all)


## ----collapse = TRUE,, mensagem = FALSE, fig.height = 5, fig.width = 10, fig.align =" center "-----
stat1 <- 
  df %>% 
  desc_stat(ALT_ESP, ALT_PLANT, COMP_SAB,
            hist = TRUE)
print_tbl(stat1)


## ----collapse = TRUE,, mensagem = FALSE, fig.height = 5, fig.width = 5.5, fig.align =" center "----
stats_c <-
  desc_stat(df,
            contains("C"),
            stats = ("mean, se, cv, max, min, n, n.valid"),
            by = ENV)
print_tbl(stats_c)


## ----collapse = TRUE,, mensagem = FALSE, fig.height = 5, fig.width = 5.5, fig.align =" center "----
desc_wider(stats_c, mean) %>% print_tbl()


## ----collapse = TRUE-------------------------------------------------------------------------------
stats_grp <- 
  df %>% 
  group_by(ENV, GEN) %>%
  desc_stat(MGE, MMG,
            stats = c("mean, se, n"))
print_tbl(stats_grp)



## ---- echo=FALSE, eval=TRUE------------------------------------------------------------------------


## ----collapse = TRUE, message = FALSE, warning=FALSE-----------------------------------------------
library(metan)
library(rio)
library(emmeans)

# gerar tabelas html
print_tbl <- function(table, digits = 3, ...){
  knitr::kable(table, booktabs = TRUE, digits = digits, ...)
}

# dados
df <- import("http://bit.ly/df_ge", setclass = "tbl")
print(df)


## ----collapse = TRUE, warning=FALSE----------------------------------------------------------------
ind_an <- anova_ind(df,
                    env = ENV,
                    gen = GEN,
                    rep = BLOCO,
                    resp = everything(),
                    verbose = FALSE)
print(ind_an)

# Obter dados de todas as variáveis (Coeficiente de variação)
gmd(ind_an, "CV") %>% print_tbl()

# F-máximo
gmd(ind_an, what = "FMAX") %>% print_tbl()



## ----collapse = TRUE, warning=FALSE, fig.height=3, fig.width=10------------------------------------
ind_an2 <- gafem(df,
                gen = GEN,
                rep = BLOCO,
                resp = everything(),
                by = ENV,
                verbose = FALSE)

# Obter dados de todas as variáveis
# P-value
pval <- gmd(ind_an2, what = "Pr(>F)", verbose = FALSE)
print_tbl(pval)

# Comparação de médias (MGE dentro do ambiente 2)
model_mge_a2 <- ind_an2[[2]][[2]][["MGE"]][["model"]]
pairwise_means <- tukey_hsd(model_mge_a2, "GEN")
print_tbl(pairwise_means)

# comparações de médias com o pacote emmeans
(means <- emmeans(model_mge_a2, "GEN"))
plot(means,
     comparisons = TRUE,
     CIs = FALSE,
     xlab = "Massa de grãos por espiga",
     ylab = "Genótipos")

## ---- echo=FALSE, eval=TRUE------------------------------------------------------------------------


## ----collapse = TRUE, message = FALSE, warning=FALSE-----------------------------------------------
library(metan)
library(rio)

# gerar tabelas html
print_tbl <- function(table, digits = 3, ...){
  knitr::kable(table, booktabs = TRUE, digits = digits, ...)
}

# dados
df_g <- import("http://bit.ly/df_g", setclass = "tbl")
inspect(df_g, verbose = FALSE) %>% print_tbl()



## ----collapse = TRUE-------------------------------------------------------------------------------
gen_mod <- 
  gamem(df_g,
        gen = GEN,
        rep = BLOCO,
        resp = everything())



## ----collapse = TRUE, fig.width=10-----------------------------------------------------------------
plot(gen_mod, type = "res") # padrão
plot(gen_mod, type = "re") # padrão



## ----collapse = TRUE-------------------------------------------------------------------------------
details <- gmd(gen_mod, "details")
print_tbl(details)


## ----collapse = TRUE-------------------------------------------------------------------------------
lrt <- gmd(gen_mod, "lrt") 
print_tbl(lrt)


## ----collapse = TRUE, fig.width=10-----------------------------------------------------------------
vcomp <- gmd(gen_mod, "vcomp")
print_tbl(vcomp)
plot(gen_mod, type = "vcomp")


## ----collapse = TRUE-------------------------------------------------------------------------------
genpar <- gmd(gen_mod, "genpar")
print_tbl(genpar)


## ----collapse = TRUE-------------------------------------------------------------------------------
blupg <- gmd(gen_mod, "blupg")
print_tbl(blupg)

# plotar os BLUPS (default)
plot_blup(gen_mod)

# Trait MGE
plot_blup(gen_mod,
          var = "MGE",
          height.err.bar = 0,
          col.shape = c("black", "gray"),
          x.lab = "Massa de grãos por espiga (g)",
          y.lab = "Híbridos de milho")


## ----collapse = TRUE, message = FALSE, warning=FALSE-----------------------------------------------
df_ge <- import("http://bit.ly/df_ge", setclass = "tbl")
mod_gen_whithin <- 
    gamem(df_ge,
          gen = GEN,
          rep = BLOCO,
          resp = everything(),
          by = ENV, verbose = FALSE)

gmd(mod_gen_whithin, "lrt") %>%  print_tbl()
gmd(mod_gen_whithin, "vcomp") %>% print_tbl()

## ---- echo=FALSE, eval=TRUE------------------------------------------------------------------------


## ----collapse = TRUE, message = FALSE, warning=FALSE-----------------------------------------------
library(metan)
library(rio)

# gerar tabelas html
print_tbl <- function(table, digits = 3, ...){
  knitr::kable(table, booktabs = TRUE, digits = digits, ...)
}


df_ge <- import("http://bit.ly/df_ge", setclass = "tbl")
inspect(df_ge, verbose = FALSE) %>% print_tbl()

joint_an <- 
    anova_joint(df_ge,
                env = ENV, 
                gen = GEN,
                rep = BLOCO,
                resp = everything(), 
                verbose = FALSE)



## ----collapse = TRUE-------------------------------------------------------------------------------
args(gamem_met)


## ----collapse = TRUE, echo = TRUE------------------------------------------------------------------
met_mixed <-
  gamem_met(df_ge,
            env = ENV,
            gen = GEN,
            rep = BLOCO,
            resp = everything(),
            random = "gen", #Default
            verbose = TRUE) #Padrão



## ----collapse = TRUE, echo = TRUE, fig.width = 7, fig.height = 7, fig.align =" center "------------
plot(met_mixed)


## ----collapse = TRUE, echo = TRUE, fig.width = 10, fig.height = 3.33, fig.align =" center "--------
plot(met_mixed, type = "re")


## ----collapse = TRUE, aviso = F, mensagem = F------------------------------------------------------
lrt <- gmd(met_mixed, "lrt")
print_tbl(lrt)


## ----collapse = TRUE, fig.width = 10---------------------------------------------------------------
vcomp <- gmd(met_mixed, "vcomp")
print_tbl(vcomp)
# plot
plot(met_mixed, type = "vcomp")


## ----collapse = TRUE-------------------------------------------------------------------------------
genpar <- gmd(met_mixed, "genpar")
print_tbl(genpar)


## ----collapse = TRUE-------------------------------------------------------------------------------
met_mixed$MGE$BLUPgen
blupg <- gmd(met_mixed, "blupg")
print_tbl(blupg)


## ----collapse = TRUE, echo = TRUE, fig.height = 5, fig.width = 10, fig.align =" center ", mensagem = F, aviso = F----
a <- plot_blup(met_mixed, var = "MGE")
b <- plot_blup(met_mixed,
               var = "MGE",
               col.shape = c("gray20", "gray80"),
               plot_theme = theme_metan(grid = "y"))
arrange_ggplot(a, b, tag_levels = "a")



## ----collapse = TRUE-------------------------------------------------------------------------------
blupint <- met_mixed$MGE$BLUPint
print_tbl(blupint)


## ---- echo=FALSE, eval=TRUE------------------------------------------------------------------------


## ----collapse = TRUE-------------------------------------------------------------------------------
library(metan)
library(rio)
df_ge <- import("http://bit.ly/df_ge", setclass = "tbl")

# gerar tabelas html
print_tbl <- function(table, digits = 3, ...){
  knitr::kable(table, booktabs = TRUE, digits = digits, ...)
}


## ----collapse = TRUE,, fig.width = 12, fig.height = 5, aviso = FALSE, mensagem = FALSE-------------
a <- ge_plot(df_ge, ENV, GEN, MMG)
b <- ge_plot(df_ge, ENV, GEN, MMG, type = 2)
arrange_ggplot(a, b, tag_levels = "a")


## ----collapse = TRUE-------------------------------------------------------------------------------
ge_winners(df_ge, ENV, GEN, resp = everything()) %>% print_tbl()


## ----collapse = TRUE-------------------------------------------------------------------------------
winners <- 
ge_winners(df_ge, ENV, GEN,
           resp = everything(),
           type = "ranks",
           better = c("l, l, h, h, h, h, h, h, h, h"))

print_tbl(winners)


## ----collapse = TRUE-------------------------------------------------------------------------------
details <- ge_details(df_ge, ENV, GEN, resp = everything())
print_tbl(details)



## ----collapse = TRUE-------------------------------------------------------------------------------
mat <- make_mat(df_ge, GEN, ENV, MMG)
print_tbl(mat)


## ----collapse = TRUE-------------------------------------------------------------------------------
ge_ef <- ge_effects(df_ge, ENV, GEN, MMG)
print_tbl(ge_ef$MMG)

# o mesmo efeito é calculado com o resíduo do modelo aditivo
ge_ef2 <- 
df_ge %>% 
  means_by(GEN, ENV) %>% 
  lm(MMG ~ GEN + ENV, data = .) %>% 
  residuals() %>% 
  matrix(nrow = 13, byrow = TRUE)
print_tbl(ge_ef2)


## ----collapse = TRUE-------------------------------------------------------------------------------
gge_ef <- ge_effects(df_ge, ENV, GEN, MMG, type = "gge")
print_tbl(gge_ef$MMG)

# o mesmo efeito é calculado com o resíduo do modelo aditivo
gge_ef2 <- 
df_ge %>% 
  means_by(GEN, ENV) %>% 
  lm(MMG ~ ENV, data = .) %>% 
  residuals() %>% 
  matrix(nrow = 13, byrow = TRUE)
print_tbl(gge_ef2)


## ----collapse = TRUE,, fig.width = 5, fig.height = 4, aviso = FALSE, mensagem = FALSE, fig.align =" center "----
d1 <- ge_cluster(df_ge, ENV, GEN, MMG, nclust = 2)
plot(d1, nclust = 2)



## ----collapse = TRUE-------------------------------------------------------------------------------
mod <- env_dissimilarity(df_ge, ENV, GEN, BLOCO, MMG)

# Coeficiente de correlação de Pearson
print_tbl(mod$MMG$correlation)

# Quadrado médio GxEjj '
print_tbl(mod$MMG$MSGE)

#% Parte simples do QM GxEjj '(Robertson, 1959)
print_tbl(mod$MMG$SPART_RO)

#% Da parte complexa do QM  GxEjj '(Robertson, 1959)
print_tbl(mod$MMG$CPART_RO)


#% Parte simples do QM  GxEjj '(Cruz e Castoldi, 1991)
print_tbl(mod$MMG$SPART_CC)

#% Parte complexa do QM  GxEjj '(Cruz e Castoldi, 1991)
print_tbl(mod$MMG$CPART_CC)




## ----collapse = TRUE,, fig.width = 10, fig.height = 6----------------------------------------------
plot(mod)


## ----collapse = TRUE,, fig.width = 10, fig.height = 10, aviso = FALSE, mensagem = FALSE------------
reg_model <- ge_reg(df_ge,
                    env = ENV,
                    gen = GEN,
                    rep = BLOCO,
                    resp = MMG,
                    verbose = FALSE)

# Use o método print()
# ANOVA
print_tbl(reg_model$MMG$anova)

# REGRESSÃO
print_tbl(reg_model$MMG$regression)


# Gráfico
p1 <- plot(reg_model)
p2 <- plot(reg_model,
           x.lab = "Índice ambiental",
           y.lab = "Massa de Mil Grãos (g)",
           plot_theme = theme_metan_minimal())
p3 <- plot(reg_model, type = 2)

# reunir os plots
arrange_ggplot((p1 + p2), p3, ncol = 1,
               guides = "collect",
               tag_levels = "A",
               tag_suffix = ")")


## ----collapse = TRUE,, fig.width = 5, fig.height = 4, aviso = FALSE, mensagem = FALSE--------------
ann1 <- Annicchiarico(df_ge,
                      env = ENV,
                      gen = GEN,
                      rep = BLOCO,
                      resp = everything(),
                      verbose = FALSE)

# Wi
gmd(ann1) %>% print_tbl()

# Ranques
gmd(ann1, "rank")  %>% print_tbl()

# classificação dos ambientes
ann1$ALT_PLANT$environments  %>% print_tbl()


## ----collapse = TRUE-------------------------------------------------------------------------------
super <- superiority(df_ge,
                     env = ENV,
                     gen = GEN,
                     resp = everything(),
                     verbose = FALSE)
gmd(super) %>% print_tbl()


## ----collapse = TRUE,, fig.width = 5, fig.height = 4, aviso = FALSE, mensagem = FALSE--------------
fato <- ge_factanal(df_ge, 
                    env = ENV,
                    gen = GEN,
                    rep = BLOCO,
                    resp = everything(),
                    verbose = FALSE,
                    mineval = 0.7)

# plot
plot(fato, var = "MMG")

# Autovalores e variância
print_tbl(fato$MMG$PCA)

# Cargas fatoriais após rotação varimax
print_tbl(fato$MMG$FA)

# Estratificação
print_tbl(fato$MMG$env_strat)



## ----collapse = TRUE-------------------------------------------------------------------------------
stat_ge <- ge_stats(df_ge,
                    env = ENV,
                    gen = GEN,
                    rep = BLOCO,
                    resp = c(MMG, MGE))
# estatisticas
gmd(stat_ge, "stats") %>% print_tbl()

# Ranques
gmd(stat_ge, "ranks") %>% print_tbl()



## ----collapse = TRUE, fig.width = 10, fig.height = 10----------------------------------------------
corr_stab_ind(stat_ge)


## ---- echo=FALSE, eval=TRUE------------------------------------------------------------------------


## ----collapse = TRUE-------------------------------------------------------------------------------
library(metan)
library(rio)

# gerar tabelas html
print_tbl <- function(table, digits = 3, ...){
  knitr::kable(table, booktabs = TRUE, digits = digits, ...)
}


df_ge <- import("http://bit.ly/df_ge", setclass = "tbl")
inspect(df_ge, verbose = FALSE) %>% print_tbl()


## ----collapse = TRUE, warning = FALSE, message = FALSE, echo=TRUE, fig.height=3.5------------------
ammi_model <- 
  performs_ammi(df_ge,
                env = ENV,
                gen = GEN,
                rep = BLOCO,
                resp = MGE:MMG,
                verbose = FALSE)


## ----collapse = TRUE, warning = FALSE, message = FALSE, echo=TRUE, fig.width=8, fig.height=8, fig.align="center"----
plot(ammi_model)


## ----collapse = TRUE-------------------------------------------------------------------------------
gmd(ammi_model, "ipca_pval") %>% print_tbl()
gmd(ammi_model, "ipca_expl") %>% print_tbl()
gmd(ammi_model, "ipca_accum") %>% print_tbl()


## ----collapse = TRUE, collapse = TRUE, comment = "#", eval=T, fig.width=10-------------------------
# Validação cruzada para os membros de modelos da família AMMI
cvalida <- 
  cv_ammif(df_ge,
          env = ENV,
          gen = GEN,
          rep = BLOCO,
          resp = MGE,
          nboot = 20,
          verbose = FALSE)
p1 <- plot(cvalida)
p2 <- plot(cvalida,
          width.boxplot = 0.5,
          col.boxplot = "white",
          plot_theme = theme_metan_minimal())
p1 + p2


## --------------------------------------------------------------------------------------------------
predicted <- predict(ammi_model, naxis = c(3, 2, 1))
print_tbl(predicted$MGE)


## ----collapse = TRUE, warning = FALSE, message = FALSE, echo=TRUE, fig.height=5, fig.width=10, fig.align="center"----
p1 <- plot_scores(ammi_model)
p2 <- plot_scores(ammi_model,
                  x.lab = "Massa de grãos por espiga",
                  col.segm.env = "black",
                  col.gen = "gray",
                  col.env = "black",
                  highlight = c("H8", "H6", "H2"),
                  plot_theme = theme_metan_minimal())
arrange_ggplot(p1, p2, tag_levels = "a")


## ----collapse = TRUE, warning = FALSE, message = FALSE, echo=TRUE, fig.height=5, fig.width=10, fig.align="center"----
p3 <- plot_scores(ammi_model, type = 2)
p4 <- plot_scores(ammi_model,
                  type = 2,
                  col.segm.env = "black",
                  col.gen = "gray",
                  col.env = "black",
                  highlight = c("H8", "H6", "H2"),
                  plot_theme = theme_metan_minimal())

arrange_ggplot(p3, p4, tag_levels = "a")


## ----fig.width=12, fig.height=10-------------------------------------------------------------------
p <-
plot_scores(ammi_model,
            type = 2,
            col.segm.env = "black",
            col.gen = "gray",
            col.env = "black",
            highlight = c("H8", "H6", "H2"),
            col.highlight = "blue",
            size.tex.env = 5)

p1 <- p  + ggthemes::theme_base()
p2 <- p  + ggthemes::theme_clean()
p3 <- p  + ggthemes::theme_excel_new()
p4 <- p  + ggthemes::theme_solarized()
p5 <- p  + ggthemes::theme_solid()


arrange_ggplot((p1 + p2 + p3) / (p4 + p5),
               tag_levels = "i",
               tag_prefix = "p.",
               tag_suffix = ")",
               guides = "collect",
               title = "Meus biplots AMMI",
               subtitle = "Combinados no metan",
               caption = "Fonte: ...")



## ---- echo=FALSE, eval=TRUE------------------------------------------------------------------------


## ----collapse = TRUE, collapse = TRUE--------------------------------------------------------------
library(metan)
library(rio)

# gerar tabelas html
print_tbl <- function(table, digits = 3, ...){
  knitr::kable(table, booktabs = TRUE, digits = digits, ...)
}


df_ge <- import("http://bit.ly/df_ge", setclass = "tbl")


## ----collapse = TRUE, echo = TRUE------------------------------------------------------------------
gge_model <- 
  gge(df_ge,
      env = ENV,
      gen = GEN,
      resp = MMG)



## ----collapse = TRUE, echo = TRUE, fig.width = 10, fig.height = 5, fig.align =" center ", message = F, warning = F----
a <- plot(gge_model)
b <- plot(gge_model,
          col.gen = "orange",
          size.text.env = 2,
          plot_theme = theme_metan (grid = "both"))
arrange_ggplot(a, b, tag_levels = "a")



## ----collapse = TRUE, echo = TRUE, fig.width = 10, fig.height = 5, fig.align =" center ", message = F, warning = F----
gge_model <- gge (df_ge, ENV, GEN, MMG, svp = "genotype")
c <- plot(gge_model, type = 2)
d <- plot(gge_model,
          type = 2,
          col.gen = "black",
          col.env = "red",
          axis_expand = 1.5,
          plot_theme = theme_metan_minimal())
arrange_ggplot(c, d, tag_levels = list(c("c", "d")))



## ----collapse = TRUE, echo = TRUE, fig.width = 10, fig.height = 5, fig.align =" center ", message = F, warning = F----
gge_model <- gge (df_ge, ENV, GEN, MMG, svp = "symmetrical")
e <- plot(gge_model, type = 3)
f <- plot(gge_model,
          type = 3,
          size.shape.win = 5,
          large_label = 6,
          col.gen = "black",
          col.env = "gray",
          title = FALSE,
          plot_theme = theme_metan(color.background = transparent_color()))
arrange_ggplot(e, f, tag_levels = list (c("e", "f")))



## ----collapse = TRUE, echo = TRUE, fig.width = 10, fig.height = 5, fig.align =" center ", message = F, warning = F----
gge_model <- gge (df_ge, ENV, GEN, MMG)
g <- plot(gge_model, type = 4)
h <- plot(gge_model,
          type = 4,
          plot_theme = theme_metan_minimal())
arrange_ggplot(g, h, tag_levels = list (c ("g", "h")))



## ----collapse = TRUE, echo = TRUE, fig.width = 10, fig.height = 5, fig.align =" center ", message = F, warning = F----
gge_model <- gge (df_ge, ENV, GEN, MMG, svp = "symmetrical")
i <- plot(gge_model, type = 5, sel_env = "A2")
j <- plot(gge_model,
          type = 5,
          sel_env = "A2",
          col.gen = "black",
          col.env = "black",
          size.text.env = 12,
          axis_expand = 1.5)
arrange_ggplot(i, j, tag_levels = list(c("i", "j")))



## ----collapse = TRUE, echo = TRUE, fig.width = 10, fig.height = 5, fig.align =" center ", message = F, warning = F----

gge_model <- gge(df_ge, ENV, GEN, MMG)
k <- plot(gge_model, type = 6)
l <- plot(gge_model,
          type = 6,
          col.line = "red",
          col.gen = "black",
          col.env = "black",
          col.circle = "blue",
          col.alpha.circle = 1,
          size.text.env = 8,
          axis_expand = 1.5,
          size.shape = 4,
          plot_theme = theme_metan(color.background = "white"))
arrange_ggplot(k, l, tag_levels = list (c ("k", "l")))



## ----collapse = TRUE, echo = TRUE, fig.width = 10, fig.height = 5, fig.align =" center ", message = F, warning = F----
gge_model <- gge(df_ge, ENV, GEN, MMG, svp = "genotype")
m <- plot(gge_model, type = 7, sel_gen = "H4")
n <- plot(gge_model,
          type = 7,
          sel_gen = "H4",
          col.gen = "black",
          col.env = "black",
          size.text.env = 10,
          axis_expand = 1.5,
          plot_theme = theme_metan (grid = "both"))
arrange_ggplot(m, n, tag_levels = list(c("m", "n")))



## ----collapse = TRUE, echo = TRUE, fig.width = 10, fig.height = 5, fig.align =" center ", message = F, warning = F----
o <- plot(gge_model, type = 8)
p <- plot(gge_model,
          type = 8,
          col.gen = "black",
          col.env = "gray",
          size.text.gen = 6,
          plot_theme = theme_metan_minimal())
arrange_ggplot(o, p, tag_levels = list (c ("o", "p")))



## ----collapse = TRUE, echo = TRUE, fig.width = 10, fig.height = 5, fig.align =" center ", message = F, warning = F----
gge_model <- gge (df_ge, ENV, GEN, MMG, svp = "symmetrical")
q <- plot(gge_model,
          type = 9, 
          sel_gen1 = "H8",
          sel_gen2 = "H10")
r <- plot(gge_model,
          type = 9,
          sel_gen1 = "H8",
          sel_gen2 = "H10",
          col.gen = "black",
          size.text.gen = 1,
          size.text.win = 5,
          title = FALSE,
          plot_theme = theme_metan_minimal())
arrange_ggplot(q, r, tag_levels = list (c("q", "r")))



## ----collapse = TRUE, echo = TRUE, fig.width = 10, fig.height = 5, fig.align =" center ", message = F, warning = F----
gge_model <- gge(df_ge, ENV, GEN, MMG)
s <- plot(gge_model, type = 10)
t <- plot(gge_model,
          type = 10,
          col.gen = "black",
          título = FALSE)
arrange_ggplot(s, t, tag_levels = list (c("s", "t")))


## ---- echo=FALSE, eval=TRUE------------------------------------------------------------------------


## ----collapse = TRUE-------------------------------------------------------------------------------
library(metan)
library(rio)
library(ggforce)

# gerar tabelas html
print_tbl <- function(table, digits = 3, ...){
  knitr::kable(table, booktabs = TRUE, digits = digits, ...)
}


df_ge <- import("http://bit.ly/df_ge", setclass = "tbl")


## ----collapse = TRUE-------------------------------------------------------------------------------
model_waasb <- 
  waasb(df_ge,
        env = ENV,
        gen = GEN,
        rep = BLOCO,
        resp = everything(), 
        verbose = FALSE)

# índice WAASB
waasb_ind <- gmd(model_waasb, "WAASB")
print_tbl(waasb_ind)


## ----fig.width=8-----------------------------------------------------------------------------------
p1 <- plot_scores(model_waasb, var = 9)
p2 <- plot_scores(model_waasb, type = 2, var = 9)
p1 + p2


## ----fig.width=10----------------------------------------------------------------------------------
p3 <- plot_scores(model_waasb, type = 3, var = 9)
p4 <- plot_scores(model_waasb,
                  type = 3,
                  var = 9,
                  highlight = c("H1", "H6"),
                  plot_theme = theme_metan_minimal(),
                  title = FALSE)

arrange_ggplot(p3, p4, tag_levels = "a", guides = "collect")

# extendendo o plot

desc <- c("Esses híbridos têm rendimento de grãos acima da média geral. \ N
Eles são mais estáveis do que aqueles acima da linha horizontal")
plot_scores(model_waasb,
            type = 3,
            var = 9, 
            x.lab = "Massa de mil grãos (g)",
            y.lab = "Média poderada dos escores absolutos (WAASB)",
            col.segm.env = "transparent") +
geom_mark_rect(aes(filter =  Code  %in% c("H13", "H4", "H6"),
                     label = "Descrição",
                     description = desc),
               label.fontsize = 9,
               show.legend = F,
               con.cap = 0,
               con.colour = "red",
               color = "red",
               expand = 0.015,
               label.buffer = unit(2, "cm"))+
theme_gray()+
theme(legend.position = c(0.1, 0.9),
      legend.background = element_blank(),
      legend.title = element_blank(),
      aspect.ratio = 1)


## ----collapse = TRUE-------------------------------------------------------------------------------
waasby_ind <- gmd(model_waasb, what = "WAASBY")
print_tbl(waasby_ind, digits = 2)

plot_waasby(model_waasb, var = "MMG")


## ----collapse = TRUE-------------------------------------------------------------------------------
mtsi_model <- mtsi(model_waasb, verbose = FALSE)

# Autovalores e variância explicada
print_tbl(mtsi_model$PCA)

# Diferencial de seleção para estabilidade
print_tbl(mtsi_model$sel_dif_stab)

# Diferencial de seleção para performance
print_tbl(mtsi_model$sel_dif_trait)



## ----collapse = TRUE, message = FALSE, warning=FALSE-----------------------------------------------
# dados
df_g <- import("http://bit.ly/df_g", setclass = "tbl")



## ----collapse = TRUE-------------------------------------------------------------------------------
gen_mod <- 
  gamem(df_g,
        gen = GEN,
        rep = BLOCO,
        resp = everything(),
        verbose = FALSE)


mgidi_mod <- mgidi(gen_mod)

# radar plot
plot(mgidi_mod)

# pontos fortes e fracos
plot(mgidi_mod, type = "contribution", genotypes = "all")
print_tbl(mgidi_mod$sel_dif)



## ---- echo=FALSE, eval=TRUE------------------------------------------------------------------------


## ----collapse = TRUE, collapse = TRUE--------------------------------------------------------------
library(metan)
library(rio)
# gerar tabelas html
print_tbl <- function(table, digits = 3, ...){
  knitr::kable(table, booktabs = TRUE, digits = digits, ...)
}
df_ge <- import("http://bit.ly/df_ge", setclass = "tbl")


## ----collapse = TRUE, fig.width = 7, fig.height = 7, mensagem = FALSE, aviso = FALSE, fig.align =" center "----
# Todas as variáveis ​​numéricas
ccoef <- corr_coef(df_ge)
plot(ccoef)


## ----collapse = TRUE, fig.width = 7, fig.height = 7, mensagem = FALSE, aviso = FALSE, fig.align =" center "----
ccoef2 <- corr_coef(df_ge, contains("A"))
plot(ccoef2, dígitos = 2)



## ----collapse = TRUE,, eval = FALSE, fig.height = 12, fig.width = 12, fig.align =" center "--------
## a <- corr_plot(df_ge, MMG, MGE, COMPES, DIAMES, NGE)
## 
## 
## corr_plot(df_ge, MMG, MGE, COMPES, DIAMES, NGE,
##           lower = NULL,
##           upper = "corr")
## 
## corr_plot(df_ge, MMG, MGE, COMPES, DIAMES, NGE,
##           shape.point = 19,
##           size.point = 2,
##           alpha.point = 0.5,
##           alpha.diag = 0,
##           pan.spacing = 0,
##           diag.type = "boxplot",
##           col.sign = "gray",
##           alpha.sign = 0.3,
##           axis.labels = TRUE)
## 
## corr_plot(df_ge, MMG, MGE, COMPES, DIAMES, NGE,
##           prob = 0.01,
##           shape.point = 21,
##           col.point = "black",
##           fill.point = "orange",
##           size.point = 2,
##           alpha.point = 0.6,
##           maxsize = 4,
##           minsize = 2,
##           smooth = TRUE,
##           size.smooth = 1,
##           col.smooth = "black",
##           col.sign = "cyan",
##           col.up.panel = "black",
##           col.lw.panel = "black",
##           col.dia.panel = "black",
##           pan.spacing = 0,
##           lab.position = "tl")
## 


## ----collapse = TRUE, fig.height = 6, fig.width = 6------------------------------------------------
corr_plot(df_ge, MMG, MGE, COMPES, DIAMES, NGE, col.by = ENV)


## ----collapse = TRUE,, fig.height = 5, fig.width = 5.5, fig.align =" center "----------------------
df_g <- import("http://bit.ly/df_g", setclass = "tbl")
correl <- covcor_design(df_g,
                        gen = GEN,
                        rep = BLOCO,
                        resp = c(MMG, MGE, COMPES, DIAMES, NGE))


## ----collapse = TRUE-------------------------------------------------------------------------------
# genéticas
print_tbl(correl$geno_cor)

# fenotípicas
print_tbl(correl$phen_cor)

# residuais
print_tbl(correl$resi_cor)


## ----collapse = TRUE-------------------------------------------------------------------------------
# genéticas
print_tbl(correl$geno_cov)

# fenotípicas
print_tbl(correl$phen_cov)

# residuais
print_tbl(correl$resi_cov)


## ----collapse = TRUE,, fig.height = 5, fig.width = 5.5, fig.align =" center ", mensagem = FALSE, aviso = FALSE----
D2 <- mahala(.means = correl$means, covar = correl$resi_cov, inverted = FALSE)
print_tbl(D2)
D2 %>% 
  as.dist() %>% 
  hclust() %>% 
  plot()


## ----collapse = TRUE-------------------------------------------------------------------------------
colin <- colindiag(df_ge)
print(colin)

print_tbl(colin$evalevet)


## ----collapse = TRUE-------------------------------------------------------------------------------
colin2 <- colindiag(df_ge, by = ENV)
print(colin2)         


## ----collapse = TRUE-------------------------------------------------------------------------------
pcoeff <- path_coeff(df_ge, resp = MGE)
print(pcoeff)


## ----collapse = TRUE-------------------------------------------------------------------------------
pcoeff2 <-
  path_coeff(df_ge,
             resp = MGE,
             pred = c(MMG, COMPES, DIAMES, NGE))
print(pcoeff2)




## ----collapse = TRUE-------------------------------------------------------------------------------
pcoeff3 <-
  path_coeff(df_ge,
             resp = MGE,
             brutstep = TRUE)
print(pcoeff3$Models$Model_4)


## ----collapse = TRUE-------------------------------------------------------------------------------
pcoeff4 <-
  path_coeff(df_ge,
             resp = MGE,
             pred = c(MMG, COMPES, DIAMES, NGE),
             by = ENV)


## ----collapse = TRUE-------------------------------------------------------------------------------
data_cc <- 
  df_ge %>% 
  rename(ESP_COMPES = COMPES,
         ESP_DIAMES = DIAMES,
         ESP_COMPSAB = COMP_SAB,
         GRAO_MGE = MGE,
         GRAO_MMG = MMG)
  
# Digitar os nomes das variáveis
cc1 <- can_corr(data_cc,
                FG = c(GRAO_MGE, GRAO_MMG),
                SG = c(ESP_COMPES, ESP_DIAMES, ESP_COMPSAB))

# usando select helpers
cc2 <- can_corr(data_cc,
                FG = contains("GRAO_"),
                SG = contains("ESP_"))



## ---- echo=FALSE, eval=TRUE------------------------------------------------------------------------

