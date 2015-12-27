# The server-side definition of the Shiny web app.

library(shiny)

# Load data processing source file
source("data_processing.R")

# Load checkbox values
countries <- as.character(unique(sample$Country))
manufacturers<- as.character(unique(sample$Manufacturer))


# Shiny server
shinyServer(
        function(input, output) {
                # Initialize reactive values
                values <- reactiveValues()
                values$countries <- countries
                values$manufacturers <- manufacturers
                
                # Create event type checkbox
                output$countriesControl <- renderUI({
                        checkboxGroupInput('countries', 'EU Member Countries:', 
                                           countries, selected = values$countries)
                })
                
                output$manufacturersControl <- renderUI({
                        checkboxGroupInput('manufacturers', 'Manufacturers:', 
                                           manufacturers, selected = values$manufacturers)
                })
                
                
                # Add observer on select-all button
                observe({
                        if(input$selectAll == 0) return()
                        values$countries <- countries
                        values$manufacturers <- manufacturers
                })
                
                # Add observer on clear-all button
                observe({
                        if(input$clearAll == 0) return()
                        values$countries <- c() # empty list
                        values$manufacturers <- c()
                })
                
                # Prepare dataset
                
                dataTable <- reactive({
                        filterAll(sample, input$timeline[1], 
                                          input$timeline[2], input$emissions[1],
                                          input$emissions[2], input$countries, input$manufacturers)
                })
                

                
                dataTableCountries <- reactive({
                        CO2ByCountryAvg(sample, input$timeline[1], 
                                       input$timeline[2], input$emissions[1],
                                       input$emissions[2], input$countries, input$manufacturers)
                })
                
                dataTableManufacturers <- reactive({
                        CO2ByManufacturerAvg(sample, input$timeline[1], 
                                          input$timeline[2], input$emissions[1],
                                          input$emissions[2], input$countries, input$manufacturers)
                })
                
                dataTableMassByManufacturerAvg <- reactive({
                        MassByManufacturerAvg(sample, input$timeline[1], 
                                             input$timeline[2], input$emissions[1],
                                             input$emissions[2], input$countries, input$manufacturers)
                })
                
                dataTableMassByCountryAvg <- reactive({
                        MassByCountryAvg(sample, input$timeline[1], 
                                              input$timeline[2], input$emissions[1],
                                              input$emissions[2], input$countries, input$manufacturers)
                })
                
                dataTableCO2ByMass <- reactive({
                        CO2ByMass(sample, input$timeline[1], 
                                         input$timeline[2], input$emissions[1],
                                         input$emissions[2], input$countries, input$manufacturers)
                })
                
                
                dataTableCO2ByYear <- reactive({
                        CO2ByYear(sample, input$timeline[1], 
                                  input$timeline[2], input$emissions[1],
                                  input$emissions[2], input$countries, input$manufacturers)
                })
                
                
                # Render data table
                output$dTable <- renderDataTable({
                        dataTable()
                })
                
                
                output$emissionsByCountry <- renderChart2({
                        plotCountries(dataTableCountries())
                })
                
                output$emissionsByManufacturer <- renderChart2({
                        plotManufacturers(dataTableManufacturers())
                })
                
                output$massByManufacturer <- renderChart2({
                        plotMassByManufacturer(dataTableMassByManufacturerAvg())
                })
                
                output$massByCountry <- renderChart2({
                        plotMassByCountry(dataTableMassByCountryAvg())
                })
                
                output$CO2ByMass <- renderChart2({
                        plotCO2ByMass(dataTableCO2ByMass())
                })
                
                output$CO2ByYear <- renderChart2({
                        plotCO2ByYear(dataTableCO2ByYear())
                })
                
        }        
         # end of function(input, output)
)