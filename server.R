library(shiny)
library(plotly)
library(dplyr)
library(ggplot2)

data <- read.csv("./data/NCHS_Leading_Causes_of_Death_United_States.csv")

shinyServer(function(input, output) {
  attach(data)
  sort_years <- data[order(-Year),]
  detach(data)
  
  # Creates chart for age adjusted death rates for disease in a given year
  output$chart <- renderPlotly({
    dataframe <- data.frame(
      select(sort_years, Age.adjusted.Death.Rate, Year, Cause.Name, State) %>% filter(Year == input$year) %>% filter(Cause.Name == input$cause) %>% transmute(Age.adjusted.Death.Rate, State), stringsAsFactors = FALSE)
    plot_ly(dataframe, x = dataframe$State, y = dataframe$Age.adjusted.Death.Rate, type = 'bar', text = dataframe$Age.adjusted.Death.Rate, textposition = 'auto', marker = list(color = "#305f72")) %>% 
      layout(title = paste0("Age Adjusted Death Rates per State"), xaxis = list(title = "States"), yaxis = list(title = "Age Adjusted Death Rates (Per 100,000)"))
  })
  
  chosen_data <- reactive({
    data %>% 
      group_by(Year,Cause.Name) %>% 
      summarise(Total = sum(Deaths)) %>% 
      filter(Cause.Name %in% input$chosenCauses,
             Year >= input$chosenYears[1],
             Year <= input$chosenYears[2])
  })
  
  output$lineGraph <- renderPlot({
    chosen_data() %>% 
      ggplot(aes(x = Year, y = Total, color = Cause.Name)) +
      geom_line() +
      geom_point() +
      labs(title = "Cause of Death on a National Level over time",
           x = "Year",
           y = "Total Deaths per year")
  })
})
 