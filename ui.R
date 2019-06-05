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
library(plotly)

if("devtools" %in% rownames(installed.packages()) == FALSE) {
  install.packages("devtools")
}
library(devtools)
if("fiftystater" %in% rownames(installed.packages()) == FALSE) {
  devtools::install_github("wmurphyrd/fiftystater")
}
library(fiftystater)
# Read in CSV Data
data <- read.csv("data/NCHS_Leading_Causes_of_Death_United_States.csv")

# Sorting data by years in descending order (for the select input in the first bar chart)
attach(data) 
sort_years <- data[order(-Year),] 
detach(data) 

# Define UI for application that draws a histogram
my_ui <- shinyUI(navbarPage(
  
  #pagetheme
  theme="journal",
  
  # Application title
  p(strong("Leading Causes of Death in the United States")),
  
  tabPanel(
    p(strong("Summary of our Project")),
    sidebarLayout(
      sidebarPanel(
        p(strong("About Us")),
        "We are current students at the University of Washington enrolled in INFO201. 
        What consists of this webpage is our final project for the course.",
        tags$style(".well{background-color:lightblue;}"),
        hr(),
        p(strong("Contact Us")),
        br("Kin Vong: ", a(href="mailto:klaivong@gmail.com", "klaivong@gmail.com")),
        br("Connor Voelk:"), a(href="mailto:connorvoelk@gmail.com", "connorvoelk@gmail.com"),
        br(),
        br("Yan Zhe Ong:", a(href="mailto:ongyanzhe@gmail.com", "ongyanzhe@gmail.com")),
        br("Andrew Kats:", a(href="mailto:akats98@gmail.com", "akats98@gmail.com")) 
      ),
      
      #Summary of Analysis
      mainPanel(
        img(src = "uw.jpg", width = "900px", height = "150px"),
        br(),
        br(),
        p(strong("Our Data")),
        br("We are working with data from the National Center for Health Statistics (NCHS)."),
        br("This data set contains data on the top leading cause of death and its death rate/age 
           adjusted death rate in each state from 1999 to 2016."),
        br("Our target audience are individuals who are interested in learning about the top leading 
           causes of deaths in the United States, whether it be by year, states, or as a nation.
           We are hoping these individuals have a goal of using this data in order to figure out what
           causes are most important to address in order to decrease death rate due to these causes."),
        hr(),
        p(strong("Goal Questions:")),
        br("1) What is the age adjusted death rate for a specific cause of death in a given year?"),
        br("2) How do causes of death (on national level) change over time (if any)?"),
        br("3) What are the regional trends and outliers for different casuses of death in each state?")
        )
        )
  ), 
  
  
  #Panel to show histogram that compares how many state have had a specific cause as their leading cause of death per year
  tabPanel(
    #title of panel
    p(strong("Causes Per State")),
    strong("This bar chart compares age adjusted death rates for 
           every state for specific causes of death in a given year"),
    sidebarLayout(
      
      # Creates widget to allow the user to sort by causes of death
      sidebarPanel(
        selectInput(
          inputId = "cause",
          label = "Cause of Death",
          selected = "All causes",
          choices = sort_years$Cause.Name
        ),
        
        # Creates widget to allow user to sort by year
        selectInput(
          inputId = "year",
          label = "Year",
          selected = "1999",
          choices = sort_years$Year
        )
      ),
      mainPanel(
        plotlyOutput("chart"),
        h2(strong("Analysis")),
        h3("What are the age adjusted death rates for certain causes in each state given a certain year?"),
        br("This bar chart allows analysis of the age adjusted death rate (per 100,00) for a cause of death for every state in a given year. 
           This bar chart allows you to compare adjusted death rates for every state for a cause of death in a specific year and allows you 
           to see the change of age adjusted death rates over time. For example, the age adjusted death rate in Alabama for cancer in 1999 
           was 211 deaths per 100,000 people. But in 2016, it was down to just 174 deaths per 100,000 people. This can help provide insight 
           into things like the overall impact of healthcare improvement and how successful improvements of healthcare have been in each individual state."),
        hr(),
        p(strong("Where are these numbers coming from?")),
        br("This chart analyzes age adjusted death rates for the top 10 leading causes of death in every state from 1999 to 2016. The age adjusted death rate 
           is the death rate for individual causes of death when age as a confounder is considered. The reason why the age adjusted death rate is so much smaller 
           than the total deaths for these causes in a lot of cases (as you can see in the graph under the National Deaths by Induvial Causes Overtime tab), is 
           because age is an important factor for a lot of these causes of death. ")
      )
    )
    ),
  
  #Panel to show line graph that shows the national deaths by individuals leading causes overtime
  tabPanel(
    #title of panel
    p(strong("National Deaths by Individual Causes Overtime")),
    strong("This line graph shows the national deaths by individual leading causes of death overtime."),
    sidebarLayout(
      sidebarPanel(
        selectInput("chosenCauses",
                    label = "Causes to view:",
                    choices = unique(data$Cause.Name)[unique(data$Cause.Name) != "All causes"],
                    selected = unique(data$Cause.Name)[unique(data$Cause.Name) != "All causes"],
                    multiple = TRUE),
        
        sliderInput("chosenYears",
                    "Year",
                    min = min(data$Year),
                    max = max(data$Year),
                    value = c(min(data$Year), max(data$Year)),
                    sep = "",
                    step = 1)  
      ),
      mainPanel(
        plotOutput("lineGraph")
      )
    )
  ),
  
  #Panel to show map that shows total amount of deaths caused by specific causes of death in each state
  tabPanel(
    #title of panel
    p(strong("Total Deaths by Causes Per State")),
    strong("This map shows the total amount of deaths caused by specific causes of death in each state."),
    sidebarLayout(
      sidebarPanel(
        radioButtons("radio", label = h3("Cause of Death"),
                     choices = list("Suicide" = 3, "Heart Disease" = 2,
                                    "Cancer" = 1, "Kidney Disease" = 4, 
                                    "Stroke" = 5, "CLRD (Respitory)" = 6, "Unintentional Injuries"
                                    = 7,
                                    "Alzheimer's Disease" = 8, 
                                    "Influenza and Pneumonia" = 9, 
                                    "Diabetes" = 10), 
                     selected = 3),
        
        fluidRow(column(3, verbatimTextOutput("value")))
        
      ),
      mainPanel(
        plotOutput("fifty_map"),
        h2(strong("Analysis")),
        h3("What are the regional trends and outliers for different casuses of death in each state?"),
        br("This map allows insight to regional trends in cause of death. There are some interesting 
           regions that can be seen in each map. For instance, the Suicide Map shows an area just West
           of the middle of the country that has very high suicide rates, once this trend reaches the 
           West coast it stops."),
        br("Another notable trend is that states with very large or very small populations (outliers)
           tend to be the most different and stand out in the maps. For example, on the Suicide Map 
           the large states of California and New York have very low relitve percentages of suicides, 
           while the small population of Alaska is quite large."),
        hr(),
        p(strong("Where are these numbers coming from?")),
        br("All cases of the top ten leading causes of death and all causes of death in the United States from 1999 to 2016 
           were added up to get the largest sample available. From these totals a percentage is found 
           for every state regarding each leading cause. For example, the relative percentages for the Suicide Map is found by
           taking the (total suicide deaths of the state) / (total deaths from the state) * 100, 
           and this is done for every state. It is worth noting that some of these rates can be quite
           small (less than 1%) while others can be large (Above 30%), based on the map being shown.")
        
        
        )
        )
        ),
  
  #changes background color
  background_color <- setBackgroundColor("lightblue")
  
      ))