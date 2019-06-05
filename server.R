library(shiny)
library(plotly)
library(dplyr)
library(ggplot2)


# Define server logic required to draw a histogram

deaths <- read.csv("./data/NCHS_Leading_Causes_of_Death_United_States.csv")

shinyServer(function(input, output) {
  attach(deaths)
  sort_years <- deaths[order(-Year),]
  detach(deaths)
  
  # Creates chart for age adjusted death rates for disease in a given year
  output$chart <- renderPlotly({
    data <- data.frame(
      select(sort_years, Age.adjusted.Death.Rate, Year, Cause.Name, State) %>% filter(Year == input$year) %>% filter(Cause.Name == input$cause) %>% transmute(Age.adjusted.Death.Rate, State), stringsAsFactors = FALSE)
    plot_ly(data, x = data$State, y = data$Age.adjusted.Death.Rate, type = 'bar', text = data$Age.adjusted.Death.Rate, textposition = 'auto', marker = list(color = "#305f72")) %>% 
      layout(title = paste0("Age Adjusted Death Rates per State"), xaxis = list(title = "States"), yaxis = list(title = "Age Adjusted Death Rates"))
  })
})
 