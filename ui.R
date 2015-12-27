# The user-interface definition of the Shiny web app.
library(shiny)
library(BH)
library(rCharts)
require(markdown)
require(data.table)
library(dplyr)
library(DT)


shinyUI(
        navbarPage("EU CO2 Emissions VizTool", 
                   # multi-page user-interface that includes a navigation bar.
                   tabPanel("Explore the Data",
                            sidebarPanel(
                                    h4('Global Filters', align = "center"),
                                    h5('Adjust the filters to subset the data.', 
                                       align ="center"),
                                    sliderInput("timeline", 
                                                "Timeline:", 
                                                min = 2010,
                                                max = 2014,
                                                value = c(2010, 2011)),
                                    sliderInput("emissions", 
                                                "CO2 Emissions:",
                                                min = 0,
                                                max = 500,
                                                value = c(100, 200) 
                                    ),
                                    
                                    uiOutput("countriesControl"),
                                    uiOutput("manufacturersControl"),
                                    actionButton(inputId = "clearAll", 
                                                 label = "Clear selection", 
                                                 icon = icon("square-o")),
                                    actionButton(inputId = "selectAll", 
                                                 label = "Select all", 
                                                 icon = icon("check-square-o"))
                                    
                            ),
                            mainPanel(
                                    
                                    tabsetPanel(
                                            # Data 
                                            tabPanel(p(icon("table"), "Raw Data"),
                                                     dataTableOutput(outputId="dTable")
                                            ),
                                            
                                            # end of "Raw Data" tab panel
                                            tabPanel(p(icon("globe"), "Countries"),
                                                     h4('Average Vehicle Mass by Country', align = "center"),
                                                     h5('Hover over each point to see the average weight of vehicles in each country.', 
                                                        align ="center"),
                                                     showOutput("massByCountry", "nvd3"),
                                                     h4('Average Emissions by Country', align = "center"),
                                                     h5('Hover over each point to see the average CO2 emission level of vehicles in each country.', 
                                                        align ="center"),
                                                     showOutput("emissionsByCountry", "nvd3")
                                            ),  # end of "Countries" tab panel
                                            tabPanel(p(icon("car"), "Manufacturers"),
                                                     h4('Average Vehicle Mass by Manufacturer', align = "center"),
                                                     h5('Hover over each point to see the average weight of vehicles for each manufacturer.', 
                                                        align ="center"),
                                                     showOutput("massByManufacturer", "nvd3"),
                                                     h4('Average Emissions by Manufacturer', align = "center"),
                                                     h5('Hover over each point to see the average CO2 emission level of vehicles for each manufacturer.', 
                                                        align ="center"),
                                                     showOutput("emissionsByManufacturer", "nvd3")
                                            ),  # end of "Manufacturers" tab panel
                                            tabPanel(p(icon("line-chart"), "Other Visualizations"),
                                                     h4('Vehicle Mass x CO2 Emissions', align = "center"),
                                                     h5('Click on the fuel types to insert or remove them from the plot. Click on or hover over each point to see the vehicle mass and the CO2 emission level.', 
                                                        align ="center"),
                                                     showOutput("CO2ByMass", "nvd3"),
                                                     h4('Average CO2 Vehicle Emissions x Year', align = "center"),
                                                     h5('Hover over each point to see the average CO2 emission level of vehicles in a specific year.', 
                                                        align = "center"),
                                                     showOutput("CO2ByYear", "nvd3")
                                            ) # end of "Other Visualizations" tab panel
                                            
                                    )
                                    
                            )     
                   ), # end of "Explore the Data" tab panel
                   tabPanel("Instructions",
                            mainPanel(
                                    includeMarkdown("instructions.md")
                            )
                   ), # end of "Instructions" tab panel
                   tabPanel("About",
                            mainPanel(
                                    includeMarkdown("about.md")
                        )
                ) # end of "About" tab panel        
        )                    
)          