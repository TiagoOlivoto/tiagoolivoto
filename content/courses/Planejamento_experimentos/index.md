---
title: "Planejamento e Análise de Experimentos Agronômicos [Português]"
summary: Curso voltado a alunos de graduação, pós-graduação, professores e profissionais que desejam aperfeiçoar os conhecimentos no planejamento e análise de experimentos agronômicos
date: "2020-05-19T00:00:00Z"
lastmod: "2020/04/04"
tags:
- Melhoramento Genético
- Experimentação Agrícola
- Planejamento de Experimentos
- Análise de Experimentos
- Pacotes R
---


<style>
body {
  margin: 7;
  font-family: Arial, Helvetica, sans-serif;
}

.topnav {
  overflow: hidden;
  background-color: #4169E1;
}

.topnav a {
  float: left;
  color: #f2f2f2;
  text-align: center;
  padding: 14px 10px;
  text-decoration: none;
  font-size: 17px;
}

.topnav a:hover {
  background-color: #ddd;
  color: black;
}

.topnav a.active {
  background-color: #4CAF50;
  color: white;
}
</style>


<div class="topnav">
  <a class="active" href="#home">Home</a>
  <a href="#modalidade">Modalidade</a>
  <a href="#cargahoraria">Carga Horária</a>
  <a href="#ementa">Ementa</a>
  <a href="#ministrante">Ministrante</a>
  <a href="#requisitos">Requisitos</a>
  <a href="#materialdidatico">Material didático</a>
  <a href="#investimento">Investimento</a>
  <a href="#inscricao">Inscrição</a>
</div>




<div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
  <ol class="carousel-indicators">
    <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
    <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
    <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
    <li data-target="#carouselExampleIndicators" data-slide-to="3"></li>
    <li data-target="#carouselExampleIndicators" data-slide-to="4"></li>
  </ol>
  <div class="carousel-inner">
    <div class="carousel-item active">
      <img class="d-block w-100" src="https://raw.githubusercontent.com/TiagoOlivoto/tiagoolivoto/master/static/img/curso_planejamento/img1.png" alt="First slide">
    </div>
    <div class="carousel-item">
      <img class="d-block w-100" src="https://raw.githubusercontent.com/TiagoOlivoto/tiagoolivoto/master/static/img/curso_planejamento/img2.png" alt="Second slide">
    </div>
    <div class="carousel-item">
      <img class="d-block w-100" src="https://raw.githubusercontent.com/TiagoOlivoto/tiagoolivoto/master/static/img/curso_planejamento/img3.png" alt="Third slide">
    </div>
    <div class="carousel-item">
      <img class="d-block w-100" src="https://raw.githubusercontent.com/TiagoOlivoto/tiagoolivoto/master/static/img/curso_planejamento/img4.png" alt="Third slide">
    </div>
    <div class="carousel-item">
      <img class="d-block w-100" src="https://raw.githubusercontent.com/TiagoOlivoto/tiagoolivoto/master/static/img/curso_planejamento/img5.png" alt="Third slide">
    </div>
  </div>
  <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
    <span class="sr-only">Previous</span>
  </a>
  <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
    <span class="carousel-control-next-icon" aria-hidden="true"></span>
    <span class="sr-only">Next</span>
  </a>
</div>








<div class="container">
<div class="col-md-12">
<div class="row">


<div class="col-md-3">
<div class="box-simple">
<div class="icon">
<i class="far fa-calendar-alt fa-4x"></i>
</div>
DATA<br>06/06 e 13/06/2020
</div>
</div>

<div class="col-md-3">
<div class="box-simple">
<div class="icon">
<i class="far fa-clock fa-4x"></i>
</div>
CARGA HORÁRIA<br> 08 horas/aula
</div>
</div>

<div class="col-md-3">
<div class="box-simple">
<div class="icon">
<i class="fas fa-map-marked-alt fa-4x"></i>
</div>
MODALIDADE:<br> online
</div>
</div>

<div class="col-md-3">
<div class="box-simple">
<div class="icon">
<i class="fas fa-dollar-sign fa-4x"></i>
</div>
INVESTIMENTO<br>R$250,00
</div>
</div>
</div>
</div>
</div>


<div class="jumbotron">
  <h1 class="display-4">Apresentação</h1>
  <p class="lead">O curso tem a finalidade de proporcionar a compreensão dos conhecimentos necessários para o planejamento e análise de experimentos agronômicos. Nele serão abordados aspectos teóricos e a aplicação prática das principais etapas relacionadas a análise dos tipos de experimentos mais utilizados na agronomia.</p>
  <hr class="my-4">
  <p>O curso é baseado nos softwarse R e RStudio, ferramentas gratuítas e poderosas. Este site, por exemplo, foi construído utilizando estas ferramentas <i class="em em-100" aria-role="presentation" aria-label="HUNDRED POINTS SYMBOL"></i>.</p>

<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">
   Leia uma pequena introdução ao R aqui!
  </a>
</p>


<div class="collapse" id="collapseExample">
  <div class="card card-body">

O artigo <a href="https://www.jstor.org/stable/1390807?seq=1#page_scan_tab_contents" target="_blank">R: A Language for Data Analysis and Graphics</a> marca o início de uma nova era no processamento e análise de dados: o desenvolvimento do software R. O R é uma linguagem e ambiente estatístico que traz muitas vantagens para o usuário, embora elas não sejam tão obvias inicialmente: (i) o R é um Software Livre (livre no sentido de liberdade) distribuído sob a <a href="https://www.gnu.org/licenses/quick-guide-gplv3.html" target="_blank">Licença Pública Geral</a>, podendo ser livremente copiado, distribuído, e instalado em diversos computadores livremente. Isso contrasta com softwares comerciais, que têm licenças altamente restritivas, que não permitem que cópias sejam distribuídas ou instaladas em mais de um computador sem a devida licença (que obviamente é paga!); (ii) a grande maioria dos Softwares livres são grátis, e o R não é uma exceção; (iii) os códigos-fontes R estão disponíveis para os usuários, e atualmente são gerenciados por um grupo chamado <a href="https://www.r-project.org/" target="_blank">R Development Core Team</a>. A vantagem de ter o código aberto é que falhas podem ser detectadas e rapidamente corrigidas. Este sistema de revisão depende da participação dos usuários. Em contraste, em muitos pacotes comerciais, as falhas não são corrigidas até o lançamento da próxima versão, o que pode levar vários anos; (iv) o R fornece um interface de entrada por linha de comando (ELC).

No software R, todos os comandos são digitados e o mouse é pouco usado. Pode parecer antigo, pouco amigável ou até pobre em recursos visuais, mas isso faz com que nos deparemos com o melhor recurso do R: a sua flexibilidade. Para usuários familiarizados, a linguagem do R se torna clara e simples. Com poucos comandos, funções poderosas podem ser criadas e o usuário é sempre consciente do que foi pedido através da ELC (Meus dados, minhas análises!). Isso contrasta com pacotes que possuem uma interface amigável (aponte e clique), mas escondem a dinâmica dos cálculos e, potencialmente, os seus erros. Finalmente, o R fornece uma ampla variedade de procedimentos estatísticos básicos ou que exigem grande esforço computacional (modelagem linear e não linear, testes estatísticos clássicos, análise de séries temporais, classificação, agrupamento, etc.) e recursos gráficos elegantes. Um dos pontos fortes de R é a facilidade com que gráficos de qualidade podem ser produzidos, incluindo símbolos matemáticos e fórmulas, quando necessário. O software R está disponível em uma ampla variedade de plataformas UNIX e sistemas similares (incluindo FreeBSD e Linux), Windows e MacOS.

Quem já é usuário de softwares por linhas de comando, como o SAS, provavelmente não notou nenhuma grande diferença até aqui. Toda análise se resume à seguinte sequência *dados > códigos > saída*. A experiência do usuário com o R, no entanto, pode ser mais atrativa utilizando o <a href="https://www.rstudio.com/" target="_blank">RStudio</a>. O Rstudio é um produto de código aberto disponível publicamente em 28/02/2011 que está disponível gratuitamente. Ele é um ambiente de desenvolvimento integrado para R que inclui (i) janelas de edição de texto a partir das quais o código pode ser enviado para o console e/ou salvo no sistema operacional, (ii) listas de objetos em sua área de trabalho, (iii) histórico infinito dos comandos facilmente pesquisável com capacidade de inserir, a partir do histórico, um comando no console novamente; (iv); interface com o sistema operacional para acesso a arquivos; (v) janela de ajuda com botões de voltar e avançar; (vi) download de pacotes. Apesar de todas estas capacidades, o RStudio é muito fácil de utilizar.

</div>
</div>
</div>





Do campo ao excel, serão discutidos os cuidados necessários na coleta de dados e a estrutura de tabulação necessária para criação de um arquivo de dados pronto para ser analisado em qualquer software estatístico.

De posse de diversos conjuntos de dados que exemplificam os mais comumente usados experimentos agronomicos uni e bifatoriais, será visto como realizar a inspeção prévia dos dados buscando a presença de possíveis equívocos na digitação, como computar as mais conhecidas medidas de estatistica descritiva, bem como as etapas para realização da análise de variância considerando o delineamento utilizado.

Por fim, será visto como utilizando pocos comandos, gráficos poderosos podem ser criados para a apresentação dos dados, considerando a estrutura do experimento analisado.







<div style="padding-left:16px" id = "modalidade">
  <h1>Modalidade</h1>
  <p>
  O curso será realizado em modalidade online. Os alunos inscritos receberão um link para acesso a sala de aula virtual. Como a interação professor-aluno é fundamental para o aprendizado, os alunos poderão, de maneira ordenada, interagir com o professor realizando perguntas, expondo experiências e tirando dúvidas de possíveis erros ocorridos na análise.
  </p>
</div>



<div style="padding-left:16px" id = "cargahoraria">
  <h1>Carga horária</h1>
  <p>
A carga horária do curso é de 08 horas que serão divididas em duas aulas de 04 horas, a serem realizadas nos dias 06/06 e 13/06/2020 (sábados), das 13:30 as 17:30 h. Com base legal no <a href="http://www.planalto.gov.br/ccivil_03/_ato2004-2006/2004/decreto/d5154.htm" target="_blank">Decreto Presidencial N° 5.154 (23 de julho de 2004)</a>, um certificado de participação será enviado após a conclusão do curso.
  </p>
</div>



<div style="padding-left:16px" id = "ementa">
  <h1>Ementa</h1>
  <p>
O curso abordará os aspectos teóricos e práticos dos seguintes tópicos<br>
<i class="fas fa-check"></i>Planejamento experimental<br>
<i class="fas fa-check"></i>Coleta e tabulação de dados<br>
<i class="fas fa-check"></i>Introdução ao software R<br>
<i class="fas fa-check"></i>Delineamentos DIC e DBC<br>
<i class="fas fa-check"></i>Análise de regressão<br>
<i class="fas fa-check"></i>Experimentos fatoriais<br>
<i class="fas fa-check"></i>Confecção de gráficos
  </p>
</div>











<div style="padding-left:16px" id = "ministrante">
  <h1>Ministrante</h1>
  <p>
O curso será ministrado por Tiago Olivoto. Tiago Olivoto é Engenheiro Agrônomo com Mestrado e Doutorado em Agronomia com ênfase em Melhoramento Genético Vegetal e Experimentação Agrícola. Consulte o resumo do perfil de Tiago clicando no botão abaixo ou visite seu perfil completo nas plataformas abaixo.

<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#perfiltiago" role="button" aria-expanded="false" aria-controls="perfiltiago">
  Veja o resumo aqui!
  </a>
</p>


<div class="collapse" id="perfiltiago">
  <div class="card card-body">

Tiago Olivoto é Técnico Agrícola pela Escola Estadual de Educação Básica Viadutos (2008), Engenheiro agrônomo pela Universidade do Oeste de Santa Catarina (2014), Mestre em Agronomia: Agricultura e Ambiente pela Universidade Federal de Santa Maria (2017) e Doutor em Agronomia com ênfase em Melhoramento Genético Vegetal e Experimentação Agrícola pela Universidade Federal de Santa Maria (2020). Tem experiência profissional como Técnico Agrícola (2008-2011), consultor técnico de vendas (2012-2013), na administração pública e gestão de pessoas (2014-2015), atuando como Secretário Municipal da Agricultura e Meio Ambiente no município de Cacique Doble-RS. Foi professor (bolsista) do Instituto Federal de Educação, Ciência e Tecnologia do Rio Grande do Sul, edital nº 271, de 17 de julho de 2014, atuando na ação Bolsa-Formação do Programa Nacional de Acesso ao Ensino Técnico e Emprego (PRONATEC), na Unidade Remota de Cacique Doble. Atualmente é Professor do Ensino Superior da UNIDEAU, sendo membro do Núcleo Docente Estruturante do curso de Agronomia. É membro atuante da International Biometric Society (IBS), American Society of Agronomy (ASA), Crop Science Society of America (CSSA) e da Soil Science Society of America (SSSA). É integrante da comissão de Jovens Pesquisadores da Região Brasileira da Sociedade Internacional de Biometria, RBras, (JP-RBras) representando os estados do RS, SC e PR. Atua também como revisor ad hoc em revistas científicas nacionais e internacionais, sendo membro do Conselho Editorial da revista Genetics and Molecular Research. Exerce atividades de pesquisa relacionadas ao planejamento, condução e avaliação de experimentos com culturas anuais, com ênfase no desenvolvimento e aperfeiçoamento de métodos estatístico-experimentais para avaliação de ensaios multi-ambientes em melhoramento genético de plantas. Em seu Currículo, os termos mais frequentes na contextualização da produção científica são: análise de ensaios multi-ambientes, índices multivariados, intervalo de confiança para correlação, planejamento de experimentos, seleção indireta, interação genótipo-vs-ambiente, modelos mistos e parâmetros genéticos. Tem experiência com os softwares Gênes, GEA-R, R, SAS e SPSS. Desenvolveu o pacote para sofware R metan , voltado para a checagem, manipulação, análise e apresentação de dados de ensaios multi-ambientes.

</div>
</div>




<div class="container">
<div class="col-md-12">
<div class="row">

<div class="col-md-3">
<div class="box-simple">
<a href="http://lattes.cnpq.br/2432360896340086">
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
<a href="https://www.mendeley.com/profiles/tiago-olivoto/">
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
<a href="https://www.researchgate.net/profile/Tiago_Olivoto2">
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
<a href="https://scholar.google.com/citations?user=QjxIJkcAAAAJ&hl=pt-BR">
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








<div style="padding-left:16px" id = "requisitos">
  <h1>Requisitos</h1>
  <p>
Para o acompanhamento do curso é <b>sugerido</b> que o participante tenha concluído a disciplina de experimentação agrícola (ou equivalente) ou possua conhecimentos básicos nesta área de estudo.

<div class="alert alert-warning" role="alert">
  Durante o curso, não serão abordados aspectos teóricos básicos, tais como princípios da experimentação, características dos principais delineamentos experimentais, etc.
</div>

É necessário que o participante possua computador com conexão a internet ativa e que os softwares necessários estejam previamente instalados. Os seguintes softwares serão utilizados no curso.
* [R](https://cran.r-project.org/bin/windows/base/)
* [RStudio](https://rstudio.com/products/rstudio/download/)

No ato da inscrição, o aluno com inscrição confirmada receberá um link para acesso a instruções de instalação destes softwares e as bibliotecas necessárias para realização das análises.

  </p>
</div>












<div style="padding-left:16px" id = "materialdidatico">
  <h1>Material didático</h1>
  <p>
Na sexta-feira, 05/06/2020, o aluno receberá um e-mail contendo as orientações para download dos seguintes materiais didáticos

<i class="fas fa-check"></i>Uma apostila com conteúdo voltado para a o uso do software R para a avaliação de dados experimentais.<br>
<i class="fas fa-check"></i>Os conjuntos de dados utilizados em todos os exemplos, em formato Excel.<br>
<i class="fas fa-check"></i>Um script R com os códigos utilizados durante o curso.

  </p>
</div>












<div style="padding-left:16px" id = "investimento">
  <h1>Investimento</h1>
  <p>

O valor da inscrição para o curso é de R$250,00 que deverão ser pagos via depósito ou transferência bancária (Banco do Brasil ou Sicredi) ou utilizando o PayPal. Neste último caso, basta clicar em *Comprar agora* e seguir as instruções.


<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/matheusmcuba/icones-bancos-brasileiros@1.1/dist/all.css">

<div class="container" id="listaICones">
        <div class="row">
            <div class="col icone" data-color="#006802">
                <span class="ibb-banco-brasil fa-4x"></span><br>
                <code class="text-muted">Banco do Brasil</code><br>
                <small>AG: 0680-7</small><br>
                <small>CC: 38398-8</small><br>
                <small>Titular: Tiago Olivoto</small><br>
                <small>CPF: 019.689.590-17</small>
            </div>
            <div class="col icone" data-color="#003882">
                <span class="ibb-sicredi fa-4x"></span><br>
                <code class="text-muted">Banco Sicredi</code><br>
                <small>AG: 0268</small><br>
                <small>CC: 47216-6</small><br>
                <small>Titular: Tiago Olivoto</small><br>
                <small>CPF: 019.689.590-17</small>
            </div>
            <div class="col icone" data-color="#003882">
                <span class="fab fa-paypal fa-4x"></span><br>
                <code class="text-muted">PayPal</code><br>
<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_blank">
<input type="hidden" name="cmd" value="_s-xclick">
<input type="hidden" name="hosted_button_id" value="38TR5JJWAP4ZS">
<input type="image" src="https://www.paypalobjects.com/pt_BR/BR/i/btn/btn_buynowCC_LG.gif" border="0" name="submit" alt="PayPal - A maneira fácil e segura de enviar pagamentos online!">
<img alt="" border="0" src="https://www.paypalobjects.com/pt_BR/i/scr/pixel.gif" width="1" height="1">
</form>
            </div>
            </div>
            </div>
  </p>
</div>




<div style="padding-left:16px" id = "inscricao">
  <h1>Inscrição</h1>
  <p>


Após o pagamento da taxa de inscrição, preencha o formulário de inscrição (clique em *Realizar inscrição*), anexando o comprovante de pagamento, ao final do processo.

<br>

 <div class="form-row text-center">
    <div class="col-12">
        <a href="https://docs.google.com/forms/d/e/1FAIpQLSfJRva4FniZqzx9PRRezoFLj1-H6ie5WgkWKYSqmEFkDG9XPQ/viewform" target="_blank" class="btn btn-primary btn-lg">Realizar inscrição</a>
    </div>
 </div>


<br>

Se você tem alguma dúvida, por favor, não deixe de [escrever uma mensagem](https://olivoto.netlify.app/#contact).

  </p>
</div>
