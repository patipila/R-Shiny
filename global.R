library(shiny) # shiny 
library(shinydashboard) # shinydashboard
library(DT)  # tabela
library(dplyr)  # dane
library(plotly) # inna do wykresow
library(ggplot2) # wykresy
library(ggtext) # ladny tekst ggplot
library(ggcorrplot) # wykres korelacji
library(shinycssloaders) 

my_data<- read.csv("https://github.com/patipila/R-Shiny/blob/3e0bdb4adfeb3235f4429d66670dd0807645d2ac/danecale.csv",sep=",")
  
country = rownames(my_data$country)


c1 = my_data %>% 
  select(-c("country","year","X")) %>% 
  names()

c2 = my_data %>% 
  select(-"country", -"income",-"year",-"X") %>% 
  names()

c3= my_data %>% 
  select(-"country",-"year",-"X",-"continent") %>% 
  names()

c4=c("Asia","Europe","Americas","Africa","Oceania")
