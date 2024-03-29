+++
title = "Luzes, câmera {pliman}! analisando imagens no software R [Português]"
linktitle = "Luzes, câmera {pliman}!"
summary = "Apresentação do pacote {pliman} no curso organizado pelo grupo GEEA-UFMG do Instituto de Ciências Agrárias da Universidade Federal de Minas Gerais."
date = "2021/11/25"
lastmod = "2021/12/11"
toc = true  # Show table of contents? true/false
type = "docs"  # Do not modify.
[menu.plimanlca]
parent = "pliman"
weight = 1
+++





<div class="container">
<div class="col-md-12">
<div class="row">
<div class="col-md-3">
<div class="box-simple">
<div class="icon">
<i class="far fa-calendar-alt fa-4x"></i>
</div>
Data<br>11/12/2021
</div>
</div>

<div class="col-md-3">
<div class="box-simple">
<div class="icon">
<i class="far fa-clock fa-4x"></i>
</div>
Duração<br> Das 08:00 as 12:00
</div>
</div>

<div class="col-md-3">
<div class="box-simple">
<div class="icon">
<i class="fas fa-map-marked-alt fa-4x"></i>
</div>
Modalidade:<br> online
</div>
</div>

<div class="col-md-3">
<div class="box-simple">
<div class="icon">
<i class="fab fa-r-project fa-4x"></i>
</div>
Software:<br> R e Rstudio
</div>
</div>
</div>
</div>
</div>


# <i class="fas fa-chalkboard-teacher"></i> Ministrante
<div style="padding-left:16px" id = "ministrante">
<p>
Consulte o resumo do perfil de Tiago clicando no botão abaixo ou visite seu perfil completo nas plataformas acadêmicas.

<p>
<a class="btn btn-primary" data-toggle="collapse" href="#perfiltiago" role="button" aria-expanded="false" aria-controls="perfiltiago">
Veja o resumo aqui!
</a>
</p>


<div class="collapse" id="perfiltiago">
<div class="card card-body">

Tiago Olivoto é Técnico Agrícola pela Escola Estadual de Educação Básica Viadutos (2008), Engenheiro agrônomo pela Universidade do Oeste de Santa Catarina (2014), Mestre em Agronomia: Agricultura e Ambiente pela Universidade Federal de Santa Maria (2017) e Doutor em Agronomia com ênfase em Melhoramento Genético Vegetal e Experimentação Agrícola pela Universidade Federal de Santa Maria (2020). Tem experiência profissional como Técnico Agrícola (2008-2011), consultor técnico de vendas (2012-2013), na administração pública e gestão de pessoas  (2014-2015), atuando como Secretário Municipal da Agricultura e Meio Ambiente no município de Cacique Doble-RS. Atualmente é Professor  Substituto na Universidade Federal de Santa Maria (UFSM). É membro atuante da International Biometric Society (IBS) e integrante da comissão de Jovens Pesquisadores da Região Brasileira da Sociedade Internacional de Biometria, RBras, (JP-RBras) representando os estados do RS, SC e PR. Atua também como revisor ad hoc em revistas científicas nacionais e internacionais. Exerce atividades de pesquisa relacionadas ao planejamento, condução e avaliação de experimentos com culturas anuais, com ênfase no desenvolvimento e aperfeiçoamento de métodos estatístico-experimentais para avaliação de ensaios multi-ambientes em melhoramento genético de plantas. Em seu Currículo, os termos mais frequentes na contextualização da produção científica são: análise de ensaios multi-ambientes, índices multivariados, intervalo de confiança para correlação, planejamento de experimentos, seleção indireta, interação genótipo-vs-ambiente, modelos mistos e parâmetros genéticos. Tem experiência com os softwares Gênes, GEA-R, R, SAS e SPSS. Desenvolveu os pacotes para software R metan (https://tiagoolivoto.github.io/metan/), voltado para a checagem, manipulação, análise e apresentação de dados de ensaios multi-ambientes e pliman (https://tiagoolivoto.github.io/pliman/) voltado para a análise de imagens de plantas.

</div>
</div>




<div class="container">
<div class="col-md-12">
<div class="row">

<div class="col-md-3">
<div class="box-simple">
<a href="http://lattes.cnpq.br/2432360896340086" target="_blank" rel="noopener">
<div class="icon">
<i class="ai ai-4x ai-lattes"></i>
</div>
<h3>
Currículo Lattes
</h3>
</a>
</div>
</div>

<div class="col-md-3">
<div class="box-simple">
<a href="https://www.mendeley.com/profiles/tiago-olivoto/" target="_blank" rel="noopener">
<div class="icon">
<i class="ai ai-4x ai-mendeley"></i>
</div>
<h3>
Mendeley
</h3>
</a>
</div>
</div>

<div class="col-md-3">
<div class="box-simple">
<a href="https://www.researchgate.net/profile/Tiago_Olivoto2" target="_blank" rel="noopener">
<div class="icon">
<i class="ai ai-4x ai-researchgate"></i>
</div>
<h3>
Research Gate
</h3>
</a>
</div>
</div>

<div class="col-md-3">
<div class="box-simple">
<a href="https://scholar.google.com/citations?user=QjxIJkcAAAAJ&hl=pt-BR" target="_blank" rel="noopener">
<div class="icon">
<i class="ai ai-4x ai-google-scholar"></i>
</div>
<h3>
Google Escolar
</h3>
</a>
</div>
</div>
</div>
</div>
</div>

</p>
</div>



# <i class="fas fa-glasses"></i> Visão geral

<img src="https://raw.githubusercontent.com/TiagoOlivoto/pliman/master/man/figures/logo_pliman.svg" align="right" width="250" height="250"/>

{pliman} (**pl**ant **im**age **an**alysis) foi concebido para analisar (também) imagens de plantas, especialmente relacionadas à análise de folhas e sementes.  O pacote irá ajudá-lo a:
* Mensurar a severidade de doenças foliares;
* Contar o número de lesões;
* Obter características da forma das lesões;
* Contar objetos em uma imagem;
* Obter características de objetos (área, perímetro, raio, circularidade, excentricidade, solidez);
* Obter os valores RGB para cada objeto em uma imagem;
* Obter as coordenadas de objetos;
* Obter os contornos de objetos;
* Obter o *convex hull*;
* Isolar objetos;
* Plotar medidas de objetos.


<a href="https://www.researchgate.net/publication/353021781_Measuring_plant_disease_severity_in_R_introducing_and_evaluating_the_pliman_package" target="_blank" rel="noopener"><img src="https://raw.githubusercontent.com/TiagoOlivoto/tiagoolivoto/master/static/tutorials/pliman_lca/paper_pliman.png" width="1000" height="273"/></a>


# <i class="fas fa-tools"></i> Instalação

Instale a versão lançada do pliman do [CRAN](https://CRAN.R-project.org/package=pliman) com:


```r
install.packages ("pliman")

```

Ou instale a versão de desenvolvimento do [GitHub](https://github.com/TiagoOlivoto/pliman)


```r
# instalação do github
if(!require(devtools)){
  install.packages("devtools")
}

install_github ("TiagoOlivoto/pliman")

# Para instalar a vinheta HTML, use
devtools::install_github ("TiagoOlivoto/pliman", build_vignettes = TRUE)

```

*Nota*: Se você for um usuário do Windows, sugere-se primeiro baixar e instalar a versão mais recente do [Rtools](https://cran.r-project.org/bin/windows/Rtools/). Para obter as notas de lançamento mais recentes sobre esta versão de desenvolvimento, consulte o [arquivo NEWS](https://tiagoolivoto.github.io/metan/news/index.html).


# <i class="fas fa-box-open"></i> Pacotes necessários


```r
library(tidyverse)  # manipulação de dados
library(pliman)     # análise de imagens
library(patchwork)  # organizar gráficos
```



# <i class="fas fa-database"></i> Imagens, scripts e orientações

Sugere-se que as imagens sejam baixadas e a pasta definida como diretório padrão. Em meu exemplo, setei o seguinte caminho como diretório padrão. O arquivo .zip contém as imagens e os scripts necessários para reproduzir o conteúdo do material.


```r
# mude de acordo com sua pasta
setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_lca/imgs")
```


<a href="https://github.com/TiagoOlivoto/tiagoolivoto/raw/master/static/tutorials/pliman_lca/pliman_lca.rar">
<button class="btn btn-success"><i class="fa fa-save"></i> Download do material</button>
</a>
<br>

# <i class="fab fa-creative-commons"></i> Licença

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/" target="_blank" rel="noopener"><img alt="Licença Creative Commons" style="border-width:0" src="https://raw.githubusercontent.com/TiagoOlivoto/tiagoolivoto/master/static/img/gemsr/license.jpg" width="300" height="214" /></a><br />Este conteúdo está licenciado com uma Licença <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons - Atribuição-NãoComercial-CompartilhaIgual 4.0 Internacional</a>. O resumo legível da licença afirma que você tem o direito de:

<i class="fas fa-check"></i> **Compartilhar** — copiar e redistribuir o material em qualquer suporte ou formato

<i class="fas fa-check"></i>**Adaptar** — remixar, transformar, e criar a partir do material

<i class="fas fa-check"></i>**Atribuição** — Você deve dar o crédito apropriado, prover um link para a licença e indicar se mudanças foram feitas. Você deve fazê-lo em qualquer circunstância razoável, mas de nenhuma maneira que sugira que o licenciante apoia você ou o seu uso.

<i class="fas fa-check"></i>**De acordo com os termos seguintes**

* **Não Comercial** — Você não pode usar o material para fins comerciais.

* **CompartilhaIgual** — Se você remixar, transformar, ou criar a partir do material, tem de distribuir as suas contribuições sob a mesma licença que o original.

* **Sem restrições adicionais** — Você não pode aplicar termos jurídicos ou medidas de caráter tecnológico que restrinjam legalmente outros de fazerem algo que a licença permita.

