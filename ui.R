#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(shinyWidgets)

# Define UI for application that draws a histogram
my_ui <- shinyUI(navbarPage(
  
  #pagetheme
  theme="journal",
  
  # Application title
  p(strong("Leading Causes of Death in the United States")),

    tabPanel(
      p(strong("Summary of our Project")),
      
    # Summary of Analysis
    mainPanel(
      p(strong("Our Data")),
      br("We are working with data from the National Center for Health Statistics (NCHS)"),
      br("This data set contains data on the top leading cause of death and its death rate/age 
          adjusted death rate in each state from 1999 to 2016"),
      br("Our target audience are individuals who are interested in learning about the top leading 
          causes of deaths in the United States, whether it be by year, states, or as a nation.
          We are hoping these individuals have a goal of using this data in order to figure out what
          causes are most important to address in order to decrease death rate due to these causes."),
      hr(),
      p(strong("Goal Questions:")),
      br("1) How does adjusting for age (confounding) change the death rates? "),
      br("2) How do causes of death (on national and state level) change over time (if any)?"),
      br("3) What are the all time leading causes of death in each state?"),
      br(),
      img(src = "uw.jpg", width = "900px", height = "150px")
       #plotOutput("distPlot")
    ),
    hr(),
    print("This webpage was created by students at the University of Washington enrolled in Spring 2019 Info201.")
    ),

  
  #Panel for crude leading causes of death by year/state
  tabPanel(
    p(strong("Leading Causes of Death"))
  ),
  
  #Panel changes in leading causes of death in each state
  tabPanel(
    p(strong("Change in Leading Causes of Death"))
  ),
  
  #Panel for age adjusted rates
  tabPanel(
    p(strong("Age Adjusted Rates"))
  ),

  #changes background color
  background_color <- setBackgroundColor("lightblue")
  
))
