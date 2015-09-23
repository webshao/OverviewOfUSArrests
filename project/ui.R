library(shiny)
library(datasets)

# Just take the three crime number columns and drop the % urban population
usaRedux <- cbind(USArrests[,c(1,2,4)])

shinyUI(
    
    # Use a fluid Bootstrap layout
    fluidPage(    
        
        # Give the page a title
        titlePanel(
            h3("Overview of Arrests Made in US States in 1973", align='center'),
        ),
        br(),
        # Generate a row with a sidebar
        sidebarLayout(      

            sidebarPanel(
                helpText("Select the type of crime to see the number of arrests made of that crime in each of the 50 US States in 1973. The number of arrests is normalized to per 100,000 residents."),
                selectInput("crime.type", "Type of Crime:", choices=colnames(usaRedux[,1:3])),
                br(),
                helpText("Select the grouping of the arrest statistics, by state, division, or region."),
                selectInput("grouping", "Grouping:", choices=c("State","Division","Region")),
                br(),
                helpText("Navigate through the tabbed panels titled Table, Plot, and Map to explore different ways of visualizing the data."),
                hr(),
                helpText("by Weber Shao on 9/23/2015")
            ),
            
            # Make the main panel a set of three tabs: Table, Plot, and Map
            mainPanel(
                tabsetPanel(
                  tabPanel("Table", dataTableOutput("arrestTable")),
                  tabPanel("Plot", plotOutput("arrestPlot")),
                  tabPanel("Map",
                           h4(textOutput("arrestMapTitle"), align='center'),
                           htmlOutput("arrestMap", align='center'))
                )

            )
            
        )
    )
)
