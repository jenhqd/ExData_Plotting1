#Download and load packages
dl <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
if(!file.exists('data.zip')) {download.file(dl, destfile = 'data.zip', method = 'curl')}
if(!file.exists('household_power_consumption.txt')) {unzip('data.zip')}
if(file.exists('household_power_consumption.txt')) {file.remove('data.zip')}
library(dplyr)
library(lubridate)
library(readr)
#Read and import a part of dataset that satisfies the condition

f <- function(x, pos) {filter(x, Date %in% c('1/2/2007', '2/2/2007'))}
sub_data <- read_delim_chunked(file = 'household_power_consumption.txt', DataFrameCallback$new(f), delim = ';',
                               chunk_size = 1000)
sub_data$Date <- as_date(dmy(sub_data$Date))
datetime <- with(sub_data, ymd(Date)+hms(Time))
#plotting
png(file = 'plot2.png', width = 480, height = 480)
plot(datetime, sub_data$Global_active_power, type = 'l',
     ylab = 'Global Active Power (kilowatts)', xlab ='')
dev.off()