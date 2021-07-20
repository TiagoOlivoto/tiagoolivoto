+++
title = "Tutoriais Agroclimatologia [Português]"
linktitle = "Tutoriais Agroclimatologia [Português]"
summary = "Este material apresenta os scripts e gráficos confeccionados com o software R, que servem de apoio para as disciplinas de Agroclimatologia e Meteorologia, ofertadas pelo Departamento de Ciências Agronômicas e Ambientais da Universidade Federal de Santa Maria, Campus Frederico Westphalen - RS"
date = "2021/07/19"
lastmod = "2020/04/04"
toc = true  # Show table of contents? true/false
type = "docs"  # Do not modify.
[menu.climato]
    parent = "Agroclimatologia"
    weight = 1
+++





# <i class="fas fa-box-open"></i> Pacotes necessários


```r
library(tidyverse)  # manipulação de dados
library(metan)
library(rio)        # importação/exportação de dados
```


# <i class="fas fa-database"></i> Conjuntos de dados

O conjunto de dados em formato `.csv` formam obtidos do site do [Instituto Nacional de Meteorologia](https://tempo.inmet.gov.br/TabelaEstacoes/A001) - INMET. O arquivo apresenta dados horários do ano de 2020, obtidos na Estação Automática FREDERICO WESTPHALEN (A854), totalizando 8784 observações. Os dados são importados diretamente no software R com

```r
clima <- import("https://bit.ly/inmet_fred_2020")
# Primeiras 15 linhas
knitr::kable(head(clima, n = 10), booktabs = TRUE, digits = 3)
```



|DATA       | DIA| MES| HORA| TEMP_INST| TEMP_MAX| TEMP_MIN| UM_INST| UM_MAX| UM_MIN| ORV_INST| ORV_MAX| ORV_MIN| PRESS_INST| PRESS_MAX| PRESS_MIN| VEL_VE| DIR_VE| RAJ_VE|  RADIAC| PRECIP|
|:----------|---:|---:|----:|---------:|--------:|--------:|-------:|------:|------:|--------:|-------:|-------:|----------:|---------:|---------:|------:|------:|------:|-------:|------:|
|01/01/2020 |   1|   1|    1|      21.5|     22.0|     21.5|      94|     94|     92|     20.6|    20.9|    20.3|      952.8|     952.8|     952.7|    0.0|    216|    2.2|      NA|      0|
|01/01/2020 |   1|   1|    2|      21.0|     21.5|     21.0|      95|     95|     94|     20.2|    20.5|    20.2|      952.2|     952.8|     952.2|    0.0|    194|    0.5|      NA|      0|
|01/01/2020 |   1|   1|    3|      20.8|     21.0|     20.7|      96|     96|     95|     20.1|    20.2|    19.9|      951.6|     952.2|     951.5|    0.0|    194|    0.0|      NA|      0|
|01/01/2020 |   1|   1|    4|      20.8|     21.0|     20.8|      96|     96|     96|     20.0|    20.3|    20.0|      951.6|     951.7|     951.5|    0.0|    180|    0.0|      NA|      0|
|01/01/2020 |   1|   1|    5|      21.1|     21.2|     20.8|      96|     96|     96|     20.3|    20.5|    20.0|      951.8|     951.9|     951.6|    0.0|    186|    0.0|      NA|      0|
|01/01/2020 |   1|   1|    6|      21.2|     21.2|     21.0|      96|     96|     96|     20.5|    20.5|    20.3|      952.2|     952.2|     951.8|    0.1|    245|    0.8|    3.86|      0|
|01/01/2020 |   1|   1|    7|      22.1|     22.1|     21.2|      94|     96|     94|     21.0|    21.2|    20.4|      952.5|     952.5|     952.2|    0.5|    175|    1.1|  164.36|      0|
|01/01/2020 |   1|   1|    8|      23.6|     23.6|     22.1|      88|     94|     88|     21.5|    21.9|    21.0|      952.9|     953.0|     952.5|    0.3|      1|    1.8|  439.06|      0|
|01/01/2020 |   1|   1|    9|      24.7|     24.8|     23.5|      82|     88|     81|     21.5|    21.6|    20.7|      953.0|     953.0|     952.7|    1.5|    353|    2.7| 1170.25|      0|
|01/01/2020 |   1|   1|   10|      25.1|     25.3|     24.7|      81|     83|     79|     21.8|    22.0|    21.3|      953.2|     953.2|     952.7|    1.5|    250|    3.7|  795.01|      0|


* DATA: A data do ano.
* DIA: O dia do mês.
* MÊS: O mes do ano.
* HORA: A hora do dia.
* TEMP_INST,	TEMP_MAX,	TEMP_MIN: Temperaturas (ºC) instantâneas, máximas e mínimas, respectivamente.
* UM_INST,	UM_MAX,	UM_MIN: Umidade do ar (%) instantâneas, máximas e mínimas, respectivamente.
* ORV_INST,	ORV_MAX,	ORV_MIN: Ponto de orvalho (ºC) instantâneas, máximas e mínimas, respectivamente.
* PRESS_INST,	PRESS_MAX,	PRESS_MIN: Temperaturas instantâneas, máximas e mínimas, respectivamente.
* VEL_VE,	DIR_VE,	RAJ_VE: Velocidade (m s\\(^{-1}\\)), direção (º) e rajada (m s\\(^-1\\)).
* RADIAC: Radiação (KJ m\\(^{-2}\\))
* PRECIP: Precipitação pluviometrica (mm).

<a href="https://bit.ly/inmet_fred_2020">
  <button class="btn btn-success"><i class="fa fa-save"></i> Download inmet_fred_2020.csv</button>
</a>


<a href="http://bit.ly/inmet_fred_2020_xlsx">
  <button class="btn btn-success"><i class="fa fa-save"></i> Download inmet_fred_2020.xlsx</button>
</a>



# <i class="fab fa-creative-commons"></i> Licença

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/" target="_blank" rel="noopener"><img alt="Licença Creative Commons" style="border-width:0" src="https://raw.githubusercontent.com/TiagoOlivoto/tiagoolivoto/master/static/img/gemsr/license.jpg" width="300" height="214" /></a><br />Este conteúdo está licenciado com uma Licença <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons - Atribuição-NãoComercial-CompartilhaIgual 4.0 Internacional</a>. O resumo legível da licença afirma que você tem o direito de:

<i class="fas fa-check"></i> **Compartilhar** — copiar e redistribuir o material em qualquer suporte ou formato

<i class="fas fa-check"></i>**Adaptar** — remixar, transformar, e criar a partir do material

<i class="fas fa-check"></i>**Atribuição** — Você deve dar o crédito apropriado, prover um link para a licença e indicar se mudanças foram feitas. Você deve fazê-lo em qualquer circunstância razoável, mas de nenhuma maneira que sugira que o licenciante apoia você ou o seu uso.

<i class="fas fa-check"></i>**De acordo com os termos seguintes**

   * **Não Comercial** — Você não pode usar o material para fins comerciais.

   * **CompartilhaIgual** — Se você remixar, transformar, ou criar a partir do material, tem de distribuir as suas contribuições sob a mesma licença que o original.

   * **Sem restrições adicionais** — Você não pode aplicar termos jurídicos ou medidas de caráter tecnológico que restrinjam legalmente outros de fazerem algo que a licença permita.
