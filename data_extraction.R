# Format, bind and write a csv containing the full dataset from the different CSVs
library(dplyr)


rm(list=ls(all.names = TRUE))
 

# Extract data from the europa.eu CSV files

raw.data_2010<- read.csv(file = "./data/CO2_passenger_cars_v2.csv", header = TRUE, sep = "\t", quote = "")
data_2010<- raw.data_2010[c("ms" ,"mh","Cn", "Ct", "E..g.km.", "M..kg.", "Ft", "Fm", "Ec..cm3.", "IT", "Er..g.km.")]
data_2010$year<- 2010
colnames(data_2010)<- c("Country","Manufacturer", "Commercial_Name", "Category", "CO2_Emissions", "Mass", "Fuel_Type", "Fuel_Mode", "Engine_Capacity", "Innovative_Technology", "CO2_Reduction", "Year")

raw.data_2011<- read.csv(file = "./data/CO2_passenger_cars_v4.csv", header = TRUE, sep = "\t", quote = "")
data_2011<- raw.data_2011[c("MS" ,"Mh","Cn", "Ct", "e..g.km.", "m..kg.", "Ft", "Fm", "ec..cm3.", "IT", "Er..g.km.")]
data_2011$year<- 2011
colnames(data_2011)<- c("Country","Manufacturer", "Commercial_Name", "Category", "CO2_Emissions", "Mass", "Fuel_Type", "Fuel_Mode", "Engine_Capacity", "Innovative_Technology", "CO2_Reduction", "Year")

raw.data_2012<- read.csv(file = "./data/CO2_passenger_cars_v6.csv", header = TRUE, sep = "\t", quote = "")
data_2012<- raw.data_2012[c("MS" ,"Mh","Cn", "Ct", "e..g.km.", "m..kg.", "Ft", "Fm", "ec..cm3.", "IT", "Er..g.km.")]
data_2012$year<- 2012
colnames(data_2012)<- c("Country","Manufacturer", "Commercial_Name", "Category", "CO2_Emissions", "Mass", "Fuel_Type", "Fuel_Mode", "Engine_Capacity", "Innovative_Technology", "CO2_Reduction", "Year")

raw.data_2013<- read.csv(file = "./data/CO2_passenger_cars_v8.csv", header = TRUE, sep = "\t", quote = "")
data_2013<- raw.data_2013[c("MS" ,"Mh","Cn", "Ct", "e..g.km.", "m..kg.", "Ft", "Fm", "ec..cm3.", "IT", "Er..g.km.")]
data_2013$year<- 2013
colnames(data_2013)<- c("Country","Manufacturer", "Commercial_Name", "Category", "CO2_Emissions", "Mass", "Fuel_Type", "Fuel_Mode", "Engine_Capacity", "Innovative_Technology", "CO2_Reduction", "Year")

raw.data_2014<- read.csv(file = "./data/CO2_passenger_cars_v10.csv", header = TRUE, sep = "\t", quote = "")
data_2014<- raw.data_2014[c("MS","Mh","Cn", "Ct", "e..g.km.", "m..kg.", "Ft", "Fm", "ec..cm3.", "IT", "Er..g.km.")]
data_2014$year<- 2014
colnames(data_2014)<- c("Country","Manufacturer", "Commercial_Name", "Category", "CO2_Emissions", "Mass", "Fuel_Type", "Fuel_Mode", "Engine_Capacity", "Innovative_Technology", "CO2_Reduction", "Year")

rm(list=c("raw.data_2010", "raw.data_2011", "raw.data_2012", "raw.data_2013", "raw.data_2014"))


# Create a full dataset
data_full<- rbind(data_2010, data_2011, data_2012,data_2013, data_2014)
rm(list=c("data_2010", "data_2011", "data_2012", "data_2013", "data_2014"))

# Minor formatting
data_full$Fuel_Type<- tolower(data_full$Fuel_Type)


# Save the full dataset to a csv
# write.csv(data_full, file = "./data/data_full.csv", sep = ",")

# Sample the data

sample<- data_full[sample(1:nrow(data_full), 50000,replace=FALSE),]

# Save a sample.csv file

write.csv(sample, file = "./data/sample.csv", quote = TRUE, row.names = FALSE)