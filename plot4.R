#Plot4.R

Sys.setlocale("LC_TIME", "C")

#load library, dlpyr and lubridate assumed installed
library(dplyr)
library(lubridate)
#Step 1.  Downloading and unzipping dataset
#Download
if(!file.exists("./data")){dir.create("./data")} 
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
destfile="./data/household_power_consumption_Dataset.zip"
if(!file.exists("./data/household_power_consumption_Dataset.zip")){download.file(fileUrl,destfile=destfile)}
#Unzip
datasetDir <- "./data"
unzip(destfile, exdir = ".")
#if(!file.exists(datasetDir)) { unzip(destfile, exdir = ".") }

#read data file
household_power_consumption <- read.csv("./household_power_consumption.txt", sep=";", stringsAsFactors=FALSE)


# The following descriptions of the 9 variables in the dataset are taken from the UCI web site:
#       
# Date: Date in format dd/mm/yyyy
# Time: time in format hh:mm:ss
# Global_active_power: household global minute-averaged active power (in kilowatt)
# Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
# Voltage: minute-averaged voltage (in volt)
# Global_intensity: household global minute-averaged current intensity (in ampere)
# Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered).
# Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light.
# Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.

# convert Date from chr to Date
household_power_consumption$Date <- as.Date(household_power_consumption$Date,"%d/%m/%Y")
hpc_subset <- filter(household_power_consumption,Date >= "2007-02-01" , Date < "2007-02-03")

# convert to numeric
hpc_subset$Global_active_power <- as.numeric(hpc_subset$Global_active_power)
hpc_subset$Sub_metering_1 <- as.numeric(hpc_subset$Sub_metering_1)
hpc_subset$Sub_metering_2 <- as.numeric(hpc_subset$Sub_metering_2)
hpc_subset$Sub_metering_3 <- as.numeric(hpc_subset$Sub_metering_3)
hpc_subset$Voltage <- as.numeric(hpc_subset$Voltage)

# plot as png file

# make datetime
hpc_subset$Datetime <- ymd_hms(paste(hpc_subset$Date,hpc_subset$Time))

png(filename = "plot4.png",   width = 480, height = 480, units = "px")
par(mfrow = c(2,2))
#plot order 1 (1,1)
plot(hpc_subset$Datetime,hpc_subset$Global_active_power,type = "l", xlab="", ylab ="Global Active Power (kilowatts)")

#plot order 2 (1,2)
plot(hpc_subset$Datetime,hpc_subset$Voltage,type = "l", xlab="datetime", ylab ="Voltage")


#plot order 3 (2,1)
plot(hpc_subset$Datetime,hpc_subset$Sub_metering_1,type = "l", xlab="", ylab ="Energy sub metering")
points(hpc_subset$Datetime,hpc_subset$Sub_metering_2,type = "l", col ="red")
points(hpc_subset$Datetime,hpc_subset$Sub_metering_3,type = "l", col ="blue")
legend("topright", max_y, c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), cex=0.8,col=plot_colors,bty="n"  ,   lty=1)

#plot order 4 (2,2)
plot(hpc_subset$Datetime,hpc_subset$Global_reactive_power,type = "l", xlab="datetime", ylab ="Global_reactive_power")

dev.off()

