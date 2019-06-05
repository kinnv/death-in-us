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
           This webpage consists of our final project for the course.",
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
        br("This data set contains data on the leading causes of death along with the corresponding total number of deaths as well as the 
            age adjusted death rate in each state from 1999 to 2016."),
        br("Our target audience are individuals who are interested in learning about the leading 
            causes of deaths in the United States, whether it be by year, states, or as a nation.
            We are hoping these individuals have a goal of using this data in order to figure out 
            how they can better maintain their physical well-being"),
        hr(),
        p(strong("Goal Questions:")),
        br("1) How many states have had a specific leading cause of death?"),
        br("2) How do causes of death (on national level) change over time (if any)?"),
        br("3) What are the all time leading causes of death in each state?")
      )
    )
    ), 

  
  #Panel to show histogram that compares how many state have had a specific cause as their leading cause of death per year
  tabPanel(
    #title of panel
    p(strong("Causes Per State")),
    strong("This bar chart compares age adjusted death rates for 
            every state for specific causes of death in a given year"),
    hr(),
    
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
        plotlyOutput("chart")  
      )
    )
  ),
  
  #Panel to show line graph that shows the national deaths by individuals leading causes overtime
  tabPanel(
    #title of panel
    p(strong("National Deaths by Individual Causes Overtime")),
    strong("This line graph shows the national deaths by individual leading causes of death overtime."),
    hr(),
    
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
        plotOutput("lineGraph"),
        hr(),
        p(strong("Analysis")),
        br("Cancer and Heart Diseases are the obvious top two causes of death and both indicate worrying recent trends.
           Deaths by cancer has been constantly on the rice for the past decade and a half and 
           this makes the search for a cure even more pressing. Deaths by heart diseases showed a dip throughout the 2000s,
           but have been back on the rise in this decade."),
        br("All other causes have generally been on the rise throughout the time period,
           which does not bode well for American Health.
           It is interesting to note that Deaths by Stroke also took a dip throughout the whole 2000s,
           but is back on the rise again this decade, similar to the number of deaths due to heart disease.
           This confirms what we already know that deaths by heart diseases and stroke is often correlated."),
        hr(),
        br(strong("Where are these numbers coming from?")),
        br("Depending on the date range chosen by the user, the data will change.
           The user can has delete certain causes that are distorting the graph, for example, cancer and heart diseases,
           and focus on causes that they are more interested in.")
      )
    )
  ),
  
  #Panel to show map that shows total amount of deaths caused by specific causes of death in each state
  tabPanel(
    #title of panel
    p(strong("Total Deaths by Causes Per State")),
    strong("This map shows the total amount of deaths caused by specific causes of death in each state."),
    hr(),
    
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
        hr(),
        p(strong("Analysis")),
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
