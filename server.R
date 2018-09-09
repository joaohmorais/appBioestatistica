library(ggplot2)
library(plyr)
library(scales)

function(input, output, session) {
  data <- read.csv("data/student-por.csv")
  data$alc <- (data$Walc + data$Dalc)/2 #parametro objetivo
  data <- data[,c(1:4, 14, 15, 26, 29, 30, 33, 34)] #apenas fatores que importam
  
  
  #Color pallete
  malachite <- "#20BF55"
  dark_imperial_blue <- "#0B4F6C"
  cyan <- "#01BAEF"
  ghost_white <- "#FBFBFF"
  sonic_silver <- "#757575"
  
  colorful_1 <- c("#1A535C", "#4ECDC4", "#7CFF7C", "#FF6B6B", "#FFE14F")
  cyanine <- c("#19B9F2", "#0582CA", "#006494", "#003554", "#051923")
  malachite_to_wine <- c(malachite, dark_imperial_blue, cyan, "#AD82FF", "#753232")
  
  #Categorização
  data$age <- cut(data$age, breaks=3)
  data$age <- revalue(data$age, replace = c("(15,17.3]" = "15 - 17", "(17.3,19.7]" = "17 - 19", "(19.7,22]" = "19 - 22"))
  data$studytime <- cut(data$studytime, breaks = 3)
  data$studytime <- revalue(data$studytime, replace = c("(0.997,2]" = "Até 2 horas", "(2,3]" = "Até 3 horas", "(3,4]" = "4 horas ou mais"))
  data$absences <- cut(data$absences, breaks = 4)
  data$absences <- revalue(data$absences, replace = c("(-0.032,8]" = "Até 10%", "(8,16]" = "Até 20%", "(16,24]" = "Até 30%", "(24,32]" = "Até 40%"))
  data$G3 <- cut(data$G3, breaks = 5)
  data$G3 <- revalue(data$G3, replace = c("(-0.019,3.8]" = "0 - 2", "(3.8,7.6]" = "2 - 4", "(7.6,11.4]" = "4 - 6", "(11.4,15.2]" = "6 - 8", "(15.2,19]" = "8 - 10"))

  #data$school <- revalue(data$school, replace = c("GP" = "Escola Gabriel Pereira", "MS" = "Escola Mousinho da Silveira"))
  
  
  getDataSet <- reactive({
    selectedData <- data[c(input$parametro, "alc")]
    
    colnames(selectedData) <- c("cat", "alc")
    return (selectedData)
  })
  
  getAxisLabel <- reactive ({
    valor <- switch(input$parametro,
                    "school" = "Escola",
                    "sex" = "Sexo",
                    "age" = "Faixa etária",
                    "address" = "Moradia",
                    "studytime" = "Tempo de Estudo",
                    "failures" = "Número de Reprovações", 
                    "goout" = "Vida Social",
                    "health" = "Saúde",
                    "absences" = "Faltas na Escola",
                    "G3" = "Rendimento Escolar")
    return (valor)
  })
  
  getAuxGraphText <- reactive({
    valor <- switch(input$tipo,
                    "barras" = "O gráfico em barras consiste em construir retângulos ou barras, em que uma das dimensões é proporcional à magnitude a ser representada, sendo a outra arbitrária, porém igual para todas as barras. Essas barras são dispostas paralelamente umas às outras, horizontal ou verticalmente.",
                    "pizza" = "O gráfico de composição em setores, sendo em forma de “pizza” o mais conhecido, destina-se a representar a composição, usualmente em porcentagem, de partes de um todo. Consiste num círculo de raio arbitrário, representando o todo, dividido em setores, que correspondem às partes de maneira proporcional.")
    return (valor)
  })
  
  getTipo <- reactive({
    return (input$tipo)
  })
  
  getXValues <- reactive ({
    valores <- switch(input$parametro,
                      "school" = c("Escola Gabriel Pereira", "Escola Mousinho da Silveira"),
                      "sex" = c("Feminino", "Masculino"),
                      "age" = levels(data$age),
                      "address" = c("Moradia Rural", "Moradia Urbana"),
                      "studytime" = levels(data$studytime),
                      "failures" = levels(as.factor(as.character(data$failures))), 
                      "goout" = c("Baixa", "Pouca", "Regular", "Movimentada", "Alta"),
                      "health" = c("Muito Ruim", "Ruim", "Normal", "Boa", "Muito Boa"),
                      "absences" = levels(data$absences),
                      "G3" = levels(data$G3))
  })
  
  
  plotBarras <- reactive({
    selectedData <- getDataSet()
    selectedData$cat <- as.factor(as.character(selectedData$cat))
    selectedData <- aggregate(alc ~ cat, selectedData, mean)
    
    ggplot(data=selectedData, aes(x=cat, y=alc, fill = cat)) +
      geom_bar(stat="identity", colour = "black")+
      scale_fill_manual(values=colorful_1) +
      guides(fill=FALSE) +
      theme_minimal() +
      scale_y_continuous(name = "Consumo de Álcool", breaks = c(0, 0.5, 1,1.5,2,2.5,3), labels = c("Nenhum", "Raro", "Pouco", "Médio", "Frequente", "Alto", "Muito Alto")) +
      scale_x_discrete(name = getAxisLabel(), labels = getXValues())
    
    
    
  })
  
  plotPizza <- reactive({
    freqData <- as.data.frame(table(data[input$parametro]))
    colnames(freqData) <- c("cat", "freq")
    midpoint <- cumsum(freqData$freq) - freqData$freq/2
    midpoint <- sum(freqData$freq) - midpoint
    ggplot(freqData,
           aes(x=" ", y=freqData$freq, fill = freqData$cat)) +
           geom_bar(width = 1, stat = "identity", colour="black") +
           coord_polar(theta = "y") +
           xlab(" ") +
           ylab(" ") +
           scale_fill_manual(values = colorful_1, name = getAxisLabel(), labels = getXValues()) +
           theme(panel.background = element_blank()) +
           scale_y_continuous(breaks = midpoint, labels = percent(freqData$freq/sum(freqData$freq)))
  })
  
  graphInput <- reactive({
    switch(input$tipo,
           "barras" = plotBarras(),
           "pizza" = plotPizza()) 
  })
  
  output$plot <- renderPlot({
    graphInput()
  })
  
  output$tipo_selecionado <- renderText({
    getAuxGraphText()
  })
  
  output$titulo_grafico <- renderText({
    tipo <- getTipo()
    
   paste0("Gráfico de ", tipo)
  })
}