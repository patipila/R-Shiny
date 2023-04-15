
function(input, output, session){
  
  #Tabela z danymi
  output$dataT <- renderDataTable(my_data)

  
  # Naglowki tabel malych  
  output$head1 <- renderText(
    paste("5 panstw z najwiekszym wskaznikiem", input$var2)
  )
  
  # Naglowki tabel malych   
  output$head2 <- renderText(
    paste("5 panstw z najmniejszym wskaznikiem", input$var2)
  )
  
  
  # Wczytywanie 5 najmniejszych wartosci
  output$top5 <- renderTable({
    
    my_data %>% 
      filter(year==input$slider)%>%
      select(country, input$var2) %>% 
      arrange(desc(get(input$var2))) %>% 
      head(5)
    
  })
  
  # Wczytywanie 5 najwiekszych
  output$low5 <- renderTable({
    
    my_data %>% 
      filter(year==input$slider)%>%
      select(country, input$var2) %>% 
      arrange(get(input$var2)) %>% 
      head(5)
    
    
  })
  
  
  # struktura danych
  output$structure <- renderPrint({
    my_data %>% 
      str()
  })
  
  
  # Statystyki podstawowe
  output$summary <- renderPrint({
    my_data %>% 
      filter(year==input$slider)%>%
      select(-"country",-"year",-"X",-"continent")%>%
      summary()
  })
  
  # Histogram
  output$histplot <- renderPlotly({
    
    p3= my_data %>%
      filter(year==input$slider)%>%
      ggplot() + 
      geom_histogram(mapping = aes(x = get(input$var1)),
                     bins = input$var6,
                     fill = "lightblue",
                     color = "black") +
      labs(x= paste(input$var1))
    
    
    p1= ggplotly(p3)
    
    p2 = my_data %>%
      filter(year==input$slider)%>%
      plot_ly() %>%
      add_boxplot(x=~get(input$var1)) %>% 
      layout(yaxis = list(showticklabels = F))
    
    # Laczenie wykresow
    subplot(p2, p1, nrows = 2, shareX = TRUE) %>%
      hide_legend() %>% 
      layout(title = "Histogram i wykres pudełkowy")
  })
  
  
  ### Wykres slupkowy
  output$bar <- renderPlotly({

    my_data %>% 
    filter(year==input$slider, continent == input$var5)%>%
    plot_ly(color =~ continent) %>% 
    add_bars(x=~country, y=~get(input$var2)) %>% 
    layout(title = paste("Wskaznik", input$var2),
            xaxis = list(title = "Kraj"),
            yaxis = list(title = paste(input$var2 )))
  })
  
  
  ### Wykres punkowy - zaleznosc 
  output$scatter <- renderPlotly({
    p = my_data %>% 
      filter(year==input$slider)%>%
      ggplot(aes(x=get(input$var3), y=get(input$var4))) +
      geom_point() +
      geom_smooth(method=get(input$fit)) +
      labs(title = paste("Relacja miedzy", input$var3 , "a" , input$var4),
           x = input$var3,
           y = input$var4) +
      theme(  plot.title = element_textbox_simple(size=10,
                                                  halign=0.5))
      
    
    # interaktywne pola na wykresie 
    ggplotly(p)
    
  })
  
  
  ## Wykres korelacji
  output$cor <- renderPlotly({
    my_df <- my_data %>% 
      select(-"country",-"continent",-"X",-"year")
    
    # Oblicz macierz korelacji
    corr <- round(cor(my_df), 1)
    
    #Oblicz macierz korelacji wartości p
    p.mat <- cor_pmat(my_df)
    
    corr.plot <- ggcorrplot(
      corr, 
      hc.order = TRUE, 
      lab= TRUE,
      outline.col = "white",
      p.mat = p.mat
    )
    
    ggplotly(corr.plot)
    
  })
  
 
 

  
  
}

