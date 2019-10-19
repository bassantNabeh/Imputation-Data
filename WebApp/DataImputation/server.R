#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(
    
    function(input, output, session) {
        observeEvent(input$buttonMice, {
            message("running MICE.R")
            source("newFireballDataMice.R")
           # print(MSE)
        })
        
        observeEvent(input$buttonRF, {
            message("running RandomForest.R")
            source("newFireballDataRF.R")
            #print(MSE)
        })
        
        observeEvent(input$buttonXg, {
            message("running XGBoost.R")
            source("xgboost.R")
            #print(MSE)
        })
        
        observeEvent(input$buttonSVD, {
            message("running GRSVD.R")
            source("GRSVD.R")
            #print(MSE)
        })
        
        
        output$renderprint <- renderPrint(
            MSE
        )
        
    }
    
    # function(input, output) 
    # {
    #     
    #     # Reactive value for selected dataset ----
    #     datasetInput <- reactive({
    #         switch(input$dataset,
    #                "Fireball_And_Bolide_Reports" = Fireball_And_Bolide_Reports,
    #                "Near_Earth_Comets_Orbital_Elements" = Near_Earth_Comets_Orbital_Elements,
    #                "Meteorite_Landings" = Meteorite_Landings,
    #                "Global-Landslide-Rainfall" = Global_Landslide_Rainfall)
    #     })
    #     
    #     
    #     # Table of selected dataset ----
    #     output$table <- renderTable({
    #         datasetInput()
    #     })
    #     
    #     
    #     # Downloadable csv of selected dataset ----
    #     output$downloadData <- downloadHandler(
    #         filename = function() {
    #             paste(input$dataset, ".csv", sep = "")
    #         },
    #         content = function(file) {
    #             write.csv(datasetInput(), file, row.names = FALSE)
    #         }
    #     )
    #     
    # }
)
