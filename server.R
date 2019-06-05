library(shiny)
library(plotly)
library(dplyr)
library(ggplot2)
library(fiftystater)

data <- read.csv("./data/NCHS_Leading_Causes_of_Death_United_States.csv")

df <- read.csv(file = "./data/AllTimeStateDeathsWLocation.csv", sep = ",", stringsAsFactors = FALSE)
df <- rename(df, state = State) # rename the State column to state
df$state <- stringr::str_trim(df$state) #remove trailing space
row.names(df) <- df$state # change row names to capitalized state names
df$state <- tolower(df$state) # turn all contents of state to lowercase

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
  
  
  output$fifty_map <- renderPlot({
    # data("fifty_states") # this line is optional due to lazy data loading
    # map_id creates the aesthetic mapping to the state name column in your data
    #takes away the useless, it may have been causing issues
    #turns all state names to lowercase
    
    
    state <- map_data("state")
    # full_join(state, df, by = c("region" = "state")) %>% View
    if(input$radio == "Cancer"){
      p <- ggplot(df, aes(map_id = state)) +
        #   map points to the fifty_states shape data
        geom_map(aes(fill=Cancer/AllCauses*100), map = fifty_states) +
        expand_limits(x = fifty_states$long, y = fifty_states$lat) +
        coord_map() +
        ggtitle("Percentage of Cancer Deaths per State of All Time")+
        scale_x_continuous(breaks = NULL) + 
        scale_y_continuous(breaks = NULL) +
        labs(x = "", y = "") +
        theme(legend.position = "bottom", 
              panel.background = element_blank())
    } else if(input$radio == "Stroke") {
      p <- ggplot(df, aes(map_id = state)) +
        #   map points to the fifty_states shape data
        geom_map(aes(fill=Stroke/AllCauses*100), map = fifty_states) +
        expand_limits(x = fifty_states$long, y = fifty_states$lat) +
        coord_map() +
        ggtitle("Percentage of Stroke Deaths per State of All Time")+
        scale_x_continuous(breaks = NULL) + 
        scale_y_continuous(breaks = NULL) +
        labs(x = "", y = "") +
        theme(legend.position = "bottom", 
              panel.background = element_blank())
    } else if(input$radio == "Suicide") {
      p <- ggplot(df, aes(map_id = state)) +
        #   map points to the fifty_states shape data
        geom_map(aes(fill=Suicide/AllCauses*100), map = fifty_states) +
        expand_limits(x = fifty_states$long, y = fifty_states$lat) +
        coord_map() +
        ggtitle("Percentage of Suicide Deaths per State of All Time")+
        scale_x_continuous(breaks = NULL) + 
        scale_y_continuous(breaks = NULL) +
        labs(x = "", y = "") +
        theme(legend.position = "bottom", 
              panel.background = element_blank())
    } else if(input$radio == "HeartDisease") {
      p <- ggplot(df, aes(map_id = state)) +
        #   map points to the fifty_states shape data
        geom_map(aes(fill=HeartDisease/AllCauses*100), map = fifty_states) +
        expand_limits(x = fifty_states$long, y = fifty_states$lat) +
        coord_map() +
        ggtitle("Percentage of Heart Disease Deaths per State of All Time")+
        scale_x_continuous(breaks = NULL) + 
        scale_y_continuous(breaks = NULL) +
        labs(x = "", y = "") +
        theme(legend.position = "bottom", 
              panel.background = element_blank())
    } else if(input$radio == "KidneyDisease") {
      p <- ggplot(df, aes(map_id = state)) +
        #   map points to the fifty_states shape data
        geom_map(aes(fill=KidneyDisease/AllCauses*100), map = fifty_states) +
        expand_limits(x = fifty_states$long, y = fifty_states$lat) +
        coord_map() +
        ggtitle("Percentage of Kidney Disease Deaths per State of All Time")+
        scale_x_continuous(breaks = NULL) + 
        scale_y_continuous(breaks = NULL) +
        labs(x = "", y = "") +
        theme(legend.position = "bottom", 
              panel.background = element_blank())
    } else if(input$radio == "CLRD") {
      p <- ggplot(df, aes(map_id = state)) +
        #   map points to the fifty_states shape data
        geom_map(aes(fill=CLRD/AllCauses*100), map = fifty_states) +
        expand_limits(x = fifty_states$long, y = fifty_states$lat) +
        coord_map() +
        ggtitle("Percentage of CLRD Deaths per State of All Time")+
        scale_x_continuous(breaks = NULL) + 
        scale_y_continuous(breaks = NULL) +
        labs(x = "", y = "") +
        theme(legend.position = "bottom", 
              panel.background = element_blank())
    } else if(input$radio == "UnintentionalInjuries" ) {
      p <- ggplot(df, aes(map_id = state)) +
        #   map points to the fifty_states shape data
        geom_map(aes(fill=Cancer/AllCauses*100), map = fifty_states) +
        expand_limits(x = fifty_states$long, y = fifty_states$lat) +
        coord_map() +
        ggtitle("Percentage of Unintentional Injury Caused Deaths per State of All Time")+
        scale_x_continuous(breaks = NULL) + 
        scale_y_continuous(breaks = NULL) +
        labs(x = "", y = "") +
        theme(legend.position = "bottom", 
              panel.background = element_blank())
    } else if(input$radio == "AlzheimersDisease") {
      p <- ggplot(df, aes(map_id = state)) +
        #   map points to the fifty_states shape data
        geom_map(aes(fill=AlzheimersDisease/AllCauses*100), map = fifty_states) +
        expand_limits(x = fifty_states$long, y = fifty_states$lat) +
        coord_map() +
        ggtitle("Percentage of Alzheimer's Disease Deaths per State of All Time")+
        scale_x_continuous(breaks = NULL) + 
        scale_y_continuous(breaks = NULL) +
        labs(x = "", y = "") +
        theme(legend.position = "bottom", 
              panel.background = element_blank())
    } else if(input$radio == "InfluenzaPneumonia") {
      p <- ggplot(df, aes(map_id = state)) +
        #   map points to the fifty_states shape data
        geom_map(aes(fill=InfluenzaPneumonia/AllCauses*100), map = fifty_states) +
        expand_limits(x = fifty_states$long, y = fifty_states$lat) +
        coord_map() +
        ggtitle("Percentage of Influenza and Pneumonia Deaths per State of All Time")+
        scale_x_continuous(breaks = NULL) + 
        scale_y_continuous(breaks = NULL) +
        labs(x = "", y = "") +
        theme(legend.position = "bottom", 
              panel.background = element_blank())
    } else if(input$radio == "Diabetes") {
      p <- ggplot(df, aes(map_id = state)) +
        #   map points to the fifty_states shape data
        geom_map(aes(fill=Diabetes/AllCauses*100), map = fifty_states) +
        expand_limits(x = fifty_states$long, y = fifty_states$lat) +
        coord_map() +
        ggtitle("Percentage of Diabetes Deaths per State of All Time")+
        scale_x_continuous(breaks = NULL) + 
        scale_y_continuous(breaks = NULL) +
        labs(x = "", y = "") +
        theme(legend.position = "bottom", 
              panel.background = element_blank())
    }
    
    # p <- ggplot(df, aes(map_id = state)) +
    #   # map points to the fifty_states shape data
    #   geom_map(aes(fill=AllCauses), map = fifty_states) 
    # expand_limits(x = fifty_states$long, y = fifty_states$lat) +
    # coord_map() +
    # scale_x_continuous(breaks = NULL) + 
    #  scale_y_continuous(breaks = NULL) +
    #  labs(x = "", y = "") +
    #  theme(legend.position = "bottom", 
    #        panel.background = element_blank())
    
    p
  })
})
 