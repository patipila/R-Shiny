
dashboardPage(
  
  dashboardHeader(title="Dane dotyczace gospodarki w R & Shiny Dashboard", titleWidth = 650
                 ),
  
  
  dashboardSidebar(
 
    sidebarMenu(id = "sidebar",
      menuItem("Dane", tabName = "data", icon = icon("database")),
      menuItem("Wizualizacja", tabName = "viz", icon=icon("chart-line")),
      
      sliderInput("slider", "Rok:", 1991, 2019, step=2,value=1991),
      # Panel warunkowy do warunkowego wyglądu widżetu
      # Filtr powinien pojawiać się tylko dla menu wizualizacji i wybranych w nim zakładek
      conditionalPanel("input.sidebar == 'viz' && input.t2 == 'distro'", selectInput(inputId = "var1" , label ="Wybierz wskażnik" , choices = c1)),
      conditionalPanel("input.sidebar == 'viz' && input.t2 == 'trends' ", selectInput(inputId = "var2" , label ="Wybierz wskażnik"  ,choices = c2)),
      conditionalPanel("input.sidebar == 'viz' && input.t2 == 'relation' ", selectInput(inputId = "var3" , label ="Wybierz wskażnik X " , choices = c1, selected = "lifeExp")),
      conditionalPanel("input.sidebar == 'viz' && input.t2 == 'relation' ", selectInput(inputId = "var4" , label ="Wybierz wskażnik Y " , choices = c1, selected = "children")),
      conditionalPanel("input.sidebar == 'viz' && input.t2 == 'trends' ", selectInput(inputId = "var5" , label ="Wybierz kontynent " , choices = c4, selected = "Europe")),
      conditionalPanel("input.sidebar == 'viz' && input.t2 == 'distro' ", selectInput(inputId = "var6" , label ="Wybierz ilosc slupkow " , choices = c(2:20), selected = "5"))
      
    )
  ),
  
  
  dashboardBody(
    tabItems(
      ##Element pierwszej zakładki
      tabItem(tabName = "data", 
              tabBox(id="t1", width = 12, 
                     
                     tabPanel("Dane", dataTableOutput("dataT"), icon = icon("table")), 
                     tabPanel("Struktura", verbatimTextOutput("structure"), icon=icon("uncharted")),
                     tabPanel("Statystyki", verbatimTextOutput("summary"), icon=icon("chart-pie"))
              )

),  
    
# Element drugiej zakładki
    tabItem(tabName = "viz", 
            tabBox(id="t2",  width=12, 
                   tabPanel("Wskazniki w panstwach", value="trends",
                            fluidRow(tags$div(align="center", box(tableOutput("top5"), title = textOutput("head1") , collapsible = TRUE, status = "primary",  collapsed = TRUE, solidHeader = TRUE)),
                                     tags$div(align="center", box(tableOutput("low5"), title = textOutput("head2") , collapsible = TRUE, status = "primary",  collapsed = TRUE, solidHeader = TRUE))
                                     
                            ),
                            withSpinner(plotlyOutput("bar"))
                   ),
            tabPanel("Rozklad", value="distro",
                     withSpinner(plotlyOutput("histplot", height = "350px"))),
            tabPanel("Macierz korelacji", id="corr" , withSpinner(plotlyOutput("cor"))),
            tabPanel("Zwiazek miedzy dwoma wskaznikami", 
                     radioButtons(inputId ="fit" , label = "Wybierz metode wygladzenia" , choices = c("loess", "lm"), selected = "lm" , inline = TRUE), 
                     withSpinner(plotlyOutput("scatter")), value="relation"),
            side = "left"
                   ),
            
            )


)
    )
  )

  
  
