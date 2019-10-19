#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(
    fluidPage(
        
        # Application title
        titlePanel("Data Imputation"),
        
        # Sidebar layout with input and output definitions ----
        sidebarLayout(
            
            # Sidebar panel for inputs ----
            sidebarPanel(
                # # Input: Choose dataset ----
                # selectInput("dataset", "Choose a dataset:",
                #             choices = c("Fireball_And_Bolide_Reports", "Near_Earth_Comets_Orbital_Elements",
                #                         "Meteorite_Landings", "Global_Landslide_Rainfall")),
                # 
                # Button
                
                actionButton("buttonMice", "Run MICE",style="color: dark-blue; background-color: snow;
                             border-color: lightsteelblue; width: 140px"),
                # br(), br(), 
                actionButton("buttonRF", "Run RandomForest",style="color: dark-blue; background-color: snow;
                             border-color: lightsteelblue; width: 140px"),
                br(), br(),
                actionButton("buttonXg", "Run XGBoost",style="color: dark-blue; background-color: snow;
                             border-color: lightsteelblue; width: 140px"),
                # br(), br(),
                actionButton("buttonSVD", "Run GRSVD",style="color: dark-blue; background-color: snow;
                             border-color: lightsteelblue; width: 140px"),
                br(), br(),
                
                helpText("Accuracy = ")
                
            ),
            
            # Main panel for displaying outputs ----
            mainPanel(
                
               # textOutput("")
                
            )
            
            
        )
    )
)
