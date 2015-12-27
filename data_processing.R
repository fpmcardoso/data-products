require(data.table)
library(dplyr)
library(DT)
library(rCharts)
require(ggplot2)

rm(list=ls(all.names = TRUE))


# Read sample
sample<- read.csv(file = "./data/sample.csv", header = TRUE, sep = ",",na.strings = c("", " ") ,colClasses = c("character", "factor", "factor", "factor", "numeric", "numeric", "factor", "factor", "factor", "factor", "numeric", "numeric"))



## Filtering Functions


filterAll <- function(data, minYear, maxYear, minEmission,
                           maxEmission, countries, manufacturers) {
        result <- data %>% filter(Year >= minYear, Year <= maxYear,
                                CO2_Emissions >= minEmission, CO2_Emissions <= maxEmission,
                                Country %in% countries,
                                Manufacturer %in% manufacturers) 
        return(result)
}


## Summarization Functions

CO2ByManufacturerAvg <- function(data,  minYear, maxYear, minEmission,
                              maxEmission, countries, manufacturers) {
        dt <-filterAll(data, minYear, maxYear,minEmission,
                       maxEmission, countries, manufacturers)
        
        result <- dt %>% 
                group_by(Manufacturer) %>% 
                summarise(avg = round(mean(CO2_Emissions, na.rm = TRUE)),2) %>% 
                arrange(avg)
        return(result)      
}



CO2ByCountryAvg <- function(data,  minYear, maxYear, minEmission,
                               maxEmission, countries, manufacturers) {
        dt <-filterAll(data, minYear, maxYear,minEmission,
                             maxEmission, countries, manufacturers)
        
        result <- dt %>% 
                group_by(Country) %>% 
                summarise(avg = round(mean(CO2_Emissions, na.rm = TRUE)),2) %>% 
                arrange(avg)
        return(result)      
}


MassByManufacturerAvg <- function(data,  minYear, maxYear, minEmission,
                            maxEmission, countries, manufacturers) {
        dt <-filterAll(data, minYear, maxYear,minEmission,
                       maxEmission, countries, manufacturers)
        
        result <- dt %>% 
                group_by(Manufacturer) %>% 
                summarise(avg = round(mean(Mass, na.rm = TRUE)),2) %>% 
                arrange(avg)
        return(result)      
}


MassByCountryAvg <- function(data,  minYear, maxYear, minEmission,
                                  maxEmission, countries, manufacturers) {
        dt <-filterAll(data, minYear, maxYear,minEmission,
                       maxEmission, countries, manufacturers)
        
        result <- dt %>% 
                group_by(Country) %>% 
                summarise(avg = round(mean(Mass, na.rm = TRUE),2)) %>% 
                arrange(avg)
        return(result)      
}


CO2ByMass <- function(data,  minYear, maxYear, minEmission,
                                            maxEmission, countries, manufacturers) {
        dt <-filterAll(data, minYear, maxYear,minEmission,
                       maxEmission, countries, manufacturers)
        dt$Mass <- round(dt$Mass, digits = 2)
        dt$CO2_Emissions <- round(dt$CO2_Emissions, digits = 2)
        
        result <- dt %>% 
                distinct(CO2_Emissions, Mass, Fuel_Type) %>% 
                select(CO2_Emissions, Mass, Fuel_Type) %>%
                na.omit() 
        
        
        if(nrow(result) > 300){
                result <- result %>% sample_n(300)
        }

        return(result)      
}


CO2ByYear <- function(data,  minYear, maxYear, minEmission,
                      maxEmission, countries, manufacturers) {
        dt <-filterAll(data, minYear, maxYear,minEmission,
                       maxEmission, countries, manufacturers)
        
        result <- dt %>% 
                group_by(Year) %>% 
                summarise(avg = mean(CO2_Emissions, na.rm = TRUE)) %>% 
                round(digits = 2) %>%
                arrange(Year)
        
        return(result)      
}


## Plotting Functions


plotCountries <- function(data, dom = "Countries", 
                                   xAxisLabel = "Country",
                                   yAxisLabel = "Avg CO2 Emissions (g/km)") {
        
        emissionsByCountry <- nPlot(
                        avg ~ Country,
                        data = data,
                        type = "multiBarChart",
                        dom = dom, width = 650
                )
        emissionsByCountry$chart(margin = list(left = 100))
        emissionsByCountry$chart(color = c('orange', 'red', 'green'))
        emissionsByCountry$yAxis(axisLabel = yAxisLabel, width = 80)
        emissionsByCountry$xAxis(axisLabel = xAxisLabel, width = 200,
                                       rotateLabels = -20, height = 200)
        emissionsByCountry$chart(tooltipContent = "#! function(key, x, y, e){ 
  return '<h5><b>Avg CO2 Emissions</b>: ' + e.point.avg + '<br>' + '<b>Country</b>: ' 
    + e.point.Country + '<br>'
    + '</h5>'
} !#")
        
        emissionsByCountry
        }

plotManufacturers <- function(data, dom = "Manufacturers", 
                          xAxisLabel = "Manufacturer",
                          yAxisLabel = "Avg CO2 Emissions (g/km)") {
        
        emissionsByManufacturer <- nPlot(
                avg ~ Manufacturer,
                data = data,
                type = "multiBarChart",
                dom = dom, width = 650
        )
        emissionsByManufacturer$chart(margin = list(left = 100))
        emissionsByManufacturer$chart(color = c('red', 'orange', 'purple'))
        emissionsByManufacturer$yAxis(axisLabel = yAxisLabel, width = 80)
        emissionsByManufacturer$xAxis(axisLabel = xAxisLabel, width = 200,
                                 rotateLabels = -20, height = 200)
        emissionsByManufacturer$chart(tooltipContent = "#! function(key, x, y, e){ 
  return '<h5><b>Avg CO2 Emissions</b>: ' + e.point.avg + '<br>' + '<b>Manufacturer</b>: ' 
    + e.point.Manufacturer + '<br>'
    + '</h5>'
} !#")
        emissionsByManufacturer
}

plotMassByManufacturer <- function(data, dom = "MassByManufacturers", 
                              xAxisLabel = "Manufacturer",
                              yAxisLabel = "Avg Vehicle Mass (kg)") {
        
        massByManufacturer <- nPlot(
                avg ~ Manufacturer,
                data = data,
                type = "multiBarChart",
                dom = dom, width = 650
        )
        massByManufacturer$chart(margin = list(left = 100))
        massByManufacturer$chart(color = c('grey', 'red', 'black'))
        massByManufacturer$yAxis(axisLabel = yAxisLabel, width = 80)
        massByManufacturer$xAxis(axisLabel = xAxisLabel, width = 200,
                                      rotateLabels = -20, height = 200)
        massByManufacturer$chart(tooltipContent = "#! function(key, x, y, e){ 
  return '<h5><b>Avg Vehicle mass</b>: ' + e.point.avg + '<br>' + '<b>Manufacturer</b>: ' 
    + e.point.Manufacturer + '<br>'
    + '</h5>'
} !#")
        massByManufacturer
}


plotMassByCountry <- function(data, dom = "MassByCountries", 
                                   xAxisLabel = "Country",
                                   yAxisLabel = "Avg Vehicle Mass (kg)") {
        
        massByManufacturer <- nPlot(
                avg ~ Country,
                data = data,
                type = "multiBarChart",
                dom = dom, width = 650
        )
        massByManufacturer$chart(margin = list(left = 100))
        massByManufacturer$chart(color = c('grey', 'red', 'green'))
        massByManufacturer$yAxis(axisLabel = yAxisLabel, width = 80)
        massByManufacturer$xAxis(axisLabel = xAxisLabel, width = 200,
                                 rotateLabels = -20, height = 200)
        massByManufacturer$chart(tooltipContent = "#! function(key, x, y, e){ 
  return '<h5><b>Avg Vehicle mass</b>: ' + e.point.avg + '<br>' + '<b>Country</b>: ' 
    + e.point.Country + '<br>'
    + '</h5>'
} !#")
        massByManufacturer
}

plotCO2ByMass <- function(data, dom = "CO2xMass", 
                              yAxisLabel = "Avg Vehicle Mass (kg)",
                              xAxisLabel = "Avg CO2 Emissions (g/km)") {

        plot <- nPlot(
                Mass ~ CO2_Emissions,
                data = data,
                group = "Fuel_Type",
                type = "scatterChart",
                dom = dom, width = 650, height = 400
        )
        plot$chart(margin = list(left = 100))
        plot$chart(color = c('red', 'green', 'blue', 'yellow', 'black', 'grey', 'purple'))
        plot$chart(tooltipContent = "#! function(key, x, y, e){ 
  return '<h5><b>Vehicle mass</b>: ' + e.point.Mass + '<br>' + '<b>CO2 emissions</b>: ' 
    + e.point.CO2_Emissions + '<br>'
    + '</h5>'
} !#")
        plot
}

plotCO2ByYear <- function(data, dom = "CO2xYear", 
                          yAxisLabel = "Avg CO2 Emissions (g/km)",
                          xAxisLabel = "Year") {
        
        plot <- nPlot(
                avg ~ Year,
                data = data,
                type = "lineChart",
                dom = dom, width = 650, height = 400
        )
        plot$chart(margin = list(left = 100))
        plot$chart(color = c('black', 'black', 'black'))
        plot$chart(tooltipContent = "#! function(key, x, y, e){ 
  return '<h5><b>Year</b>: ' + e.point.Year + '<br>' + '<b>Avg CO2 emissions</b>: ' 
                   + e.point.avg + '<br>'
                   + '</h5>'
} !#")
        plot
}

