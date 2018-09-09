library(markdown)
library(shiny)

pag_graficos <- sidebarLayout(
  sidebarPanel(
    p(h4(strong("Gráficos para Variáveis Qualitativas"))),
    p("Existem vários tipos de gráficos para representar variáveis qualitativas. Vários são versões diferentes do mesmo princípio, logo nos limitaremos a apresentar dois deles: gráficos em barras e de composição em setores (“pizza” ou retângulos)."),
    selectInput("tipo", "Selecione o Tipo de Gráfico:", 
                choices=c("Gráfico de Barras" = "barras", "Gráfico de Pizza" = "pizza")),
    h5(strong("Base de Dados")),
    p("O conjunto de dados relaciona o consumo de álcool entre jovens de escolas portuguesas e informações sociais, de gênero e de hábitos."),
    p("A base de dados está disponível no ", a("Kaggle.", href = "https://www.kaggle.com/uciml/student-alcohol-consumption/")),
    br(),
    width = 4
    
    
  ),
  mainPanel(
    h3(strong(textOutput("titulo_grafico"))),
    textOutput("tipo_selecionado"),
    selectInput("parametro", h5("Selecione o dado a visualizar:"),
                choices = c("Escola" = "school", "Sexo" = "sex",
                            "Faixa Etária" = "age", "Moradia" = "address",
                            "Tempo de Estudo" = "studytime",
                            "Número de Reprovações" = "failures",
                            "Vida Social" = "goout",
                            "Saúde" = "health", 
                            "Frequência Escolar" = "absences",
                            "Rendimento Escolar" = "G3")
    ),
    br(),
    plotOutput("plot"))
)

navbarPage("App Bioestatística",
           tabPanel("Home",
                    sidebarLayout(
                      sidebarPanel(
                        p("Bem-vindo ao nosso app de Bioestatística! Nele tentamos fazer com que o ensino da bioestatística seja facilitado e tenha maior alcance, para todos."),
                        p("Navegue pelos menus acima para explorar nosso conteúdo."),
                        br(),
                        p("O projeto do App de Bioestatística é um projeto de Iniciação Científica do aluno de graduação da Universidade Federal de São Paulo  ",
                          strong("João Henrique de Araujo Morais"), 
                          " orientado pela Profa. Dra.",
                          strong("Camila Bertini Martins.")),
                        br(),
                        p("Contato: ", a("joao.tlp@gmail.com")),
                        br(),
                        br(),
                        img(src = "unifesp_logo.png", height = 118, width = 200)
                      ),
                      mainPanel(
                        h1(strong("App Bioestatística")),
                        h5("Uma forma reinventada de ensinar ", strong("bioestatística")),
                        br(),
                        img(src = "biostatistics.png", height=108, width=400),
                        br(),
                        h4("Conteúdo do aplicativo:"),
                        h5(strong("Estatística Descritiva")),
                        p(strong("1)"), "Tipo de variáveis"),
                        p(strong("2)"), "Distribuição de frequências"),
                        p(strong("3)"), "Gráficos: Gráficos de Barras e Pizza, Histograma, Gráfico de Séries, Gráficos de Dispersão, Boxplot."),
                        p(strong("4)"), "Medidas resumo: Média, Moda, Mediana, Mínimo, Máximo, Variância, Desvio Padrão, Erro Padrão, Quantis"),
                        h5(strong("Probabilidade")),
                        p(strong("5)"), "Definição de Probabilidade"),
                        p(strong("6)"), "Teorema de Bayes"),
                        p(strong("7)"), "Probabilidade Condicional"),
                        p(strong("8)"), "Variável aleatória"),
                        p(strong("9)"), "Distribuições de Probabilidade: Principais distribuições"),
                        h5(strong("Inferência")),
                        p(strong("10)"), "Introdução à inferência (população e amostra)"),
                        p(strong("11)"), "Tipos de Amostragem"),
                        p(strong("12)"), "Teorema do Limite Central"),
                        p(strong("13)"), "Cálculo do tamanho de amostra"),
                        p(strong("14)"), "Estimação Pontual e Intervalar"),
                        p(strong("15)"), "Testes de Hipóteses"),
                        p(strong("16)"), "Cálculo de medidas de associação")
                      )
                    ), icon = icon("home", lib = "font-awesome")),
           navbarMenu("Descritiva",
                      tabPanel("Tipos de Variáveis",
                               p(h2("Tipos de Variáveis")),
                               p("Aqui se mostrarão os tipos de variáveis.")),
                      tabPanel("Distribuição de Frequências",
                               p(h2("Distribuição de Frequências")),
                               p("Aqui se mostrarão as distribuições de frequências.")),
                      tabPanel("Gráficos",
                               pag_graficos)
                      ,icon = icon("pie-chart", lib = "font-awesome")),
           navbarMenu("Probabilidade",
                      tabPanel("Definição de Probabilidade",
                               p(h2("Definição de Probabilidade")),
                               p("Definição: perspectiva favorável de que algo venha a ocorrer; possibilidade, chance.")),
                      tabPanel("Teorema de Bayes",
                               p(h2("Teorema de Bayes")),
                               p("Você já conhece o Teorema de Bayes?"))
                      ,icon = icon("percent", lib = "font-awesome")),
           navbarMenu("Inferência",
                      tabPanel("Definição de Probabilidade",
                               p(h2("Definição de Probabilidade")),
                               p("Definição: perspectiva favorável de que algo venha a ocorrer; possibilidade, chance."))
                      ,icon = icon("area-chart", lib = "font-awesome")),
           navbarMenu("Acessibilidade",
                      tabPanel("Definição de Probabilidade",
                               p(h2("Definição de Probabilidade")),
                               p("Definição: perspectiva favorável de que algo venha a ocorrer; possibilidade, chance."))
                      ,icon = icon("assistive-listening-systems", lib = "font-awesome"))
           
)