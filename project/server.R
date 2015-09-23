library(shiny)
library(datasets)
library(googleVis)
library(plyr)

# Define a server for the Shiny app
shinyServer(function(input, output) {

    # We want to read in the population of each state, and assign population weights
    # to each state, since later on there is the need to take a weighted average of
    # these arrest numbers by regions and divisions, and that the numbers are currently
    # normalized to per 100,000 people.
    state.pop.k <- as.data.frame(state.x77)$Population
    state.pop.wt <- state.pop.k / sum(state.pop.k)
    
    # Get states and USArrests datasets and combine them column-wise
    usa <- cbind(state.name = row.names(USArrests), USArrests[,c(1,2,4)],
                 state.pop.wt, state.pop.k, state.division, state.region)
    
    # Here the by-division and by-region statistics are calculated. Since the
    # population of each of the states are different, this would need to be a
    # population-weighted average to make an accurate divisional and regional
    # average per 100,000 people.
    usad <- ddply(usa, .(state.division), summarise,
                  Murder=round(weighted.mean(Murder, state.pop.wt),1),
                  Assault=round(weighted.mean(Assault, state.pop.wt),1),
                  Rape=round(weighted.mean(Rape, state.pop.wt),1))
    usar <- ddply(usa, .(state.region), summarise,
                  Murder=round(weighted.mean(Murder, state.pop.wt),1),
                  Assault=round(weighted.mean(Assault, state.pop.wt),1),
                  Rape=round(weighted.mean(Rape, state.pop.wt),1))

    # This part is for the map plotting. Since the US Map on GoogleVis does not 
    # know groupings of divisions, but only states, we would trick them to act as
    # divisions by giving constructing another data frame so that each of the state
    # the divisional average so that each division would have one arrest stat per
    # crime. This would also help the GoogleVis map to reflect this.
    
    usad.1 <- usa[c("state.name","state.division")]
    usad.2 <- merge(usad.1, usad, by="state.division", all.x=TRUE)

    # Use the aforementioned method for regions.
    
    usar.1 <- usa[c("state.name","state.region")]
    usar.2 <- merge(usar.1, usar, by="state.region", all.x=TRUE)

    # Map options
    myMapOpts <- list(region="US", displayMode="regions", 
                   resolution="provinces",
                   width=450, height=350,
                   colorAxis="{colors:['#FFFFFF', '#007F7F']}"
    )
    
    # Render the data table
    output$arrestTable <- renderDataTable({
        if (input$grouping == 'State') {
            mydata <- usa[c(1, which(names(usa) == input$crime.type), 6:8)]
        } else if (input$grouping == 'Division') {
            mydata <- usad[c(1, which(names(usad) == input$crime.type))]
        } else if (input$grouping == 'Region') {
            mydata <- usar[c(1, which(names(usar) == input$crime.type))]
        }
        mydata
    }, options = list(pageLength = 10))
    
    # Plot the bar graph
    output$arrestPlot <- renderPlot({

        # Render a barplot
        par(mai=c(1.2,1.8,0.5,1))
        if (input$grouping == 'State') {
            colIndex = which(names(usa) == input$crime.type)
            usa.gc <- usa[order(usa[colIndex]),]
            mylabels <- row.names(usa.gc)
            mylabsize <- 0.9
        } else if (input$grouping == 'Division') {
            colIndex = which(names(usad) == input$crime.type)
            usa.gc <- usad[order(usad[colIndex]),]
            mylabels <- usa.gc$state.division
            mylabsize <- 1
        } else if (input$grouping == 'Region') {
            colIndex = which(names(usar) == input$crime.type)
            usa.gc <- usar[order(usar[colIndex]),]
            mylabels <- usa.gc$state.region
            mylabsize <- 1
        }

        barplot(usa.gc[,input$crime.type], 
              main= paste('Arrest Statistics for', input$crime.type, 'by', input$grouping),
              xlab="# Arrests Per 100,000",
              names.arg=mylabels,
              cex.names = mylabsize, col="#009f9f",
              horiz=TRUE, las=1)
      
    }, height=700, width=600)

    # The title for the US Map
    output$arrestMapTitle <- renderText({
      paste("Arrest Statistics for",
            input$crime.type,
            "Per 100,000 People By",
            input$grouping)
    })
    
    # The US Map
    output$arrestMap <- renderGvis({

      if (input$grouping == 'State') {
        usa.gc <- usa
        myHoverVar = "state.name"
      } else if (input$grouping == 'Division') {
        usa.gc <- usad.2
        myHoverVar = "state.division"
      } else if (input$grouping == 'Region') {
        usa.gc <- usar.2
        myHoverVar = "state.region"
      }
      
      gvisGeoChart(usa.gc, locationvar="state.name",
                   colorvar=input$crime.type, hovervar=myHoverVar,
                   options=myMapOpts)
      
    })
    
})
