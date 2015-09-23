library(shiny)
library(datasets)

# Just take the three crime number columns and drop the % urban population
usaRedux <- cbind(USArrests[,c(1,2,4)])

shinyUI(
    
    # Use a fluid Bootstrap layout
    fluidPage(    
        
        # Give the page a title
        titlePanel(h3("Overview of Arrests Made in US States in 1973", align='center')),
        br(),
        # Generate a row with a sidebar
        sidebarLayout(      

            sidebarPanel(
                helpText("Select the type of crime to see the number of arrests made of that crime in each of the 50 US States in 1973. The number of arrests is normalized to per 100,000 residents."),
                selectInput("crime.type", "Type of Crime:", choices=colnames(usaRedux[,1:3])),
                hr(),
                helpText("The arrest statistics can be broken down groupings of states, divisions, or regions."),
                selectInput("grouping", "Grouping:", choices=c("State","Division","Region"))
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
