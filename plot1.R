#Download and load packages
dl <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
if(!file.exists('data.zip')) {download.file(dl, destfile = 'data.zip', method = 'curl')}
if(!file.exists('household_power_consumption.txt')) {unzip('data.zip')}
if(file.exists('household_power_consumption.txt')) {file.remove('data.zip')}
library(dplyr)
library(lubridate)
library(readr)

#not necessary when using read_delim_chunk
memory_required <- 2075259*9*8/(10^9) #calculate based on given rows and cols
if(memory_required < 8){
   source_data <- read.csv('household_power_consumption.txt', sep = ';', colClasses = 'character')
} else {
   print('Alert: Data set is too large!!')
}
#formatting the column to proper classes
source_data[ ,3:9] <- source_data %>% select( ,3:9) %>% mutate_if(is.character, as.numeric)
source_data$Date <- as_date(source_data$Date, format = '%d/%m/%Y')
source_data$Time <- as_hms(source_data$Time)
sub_data <- source_data %>% filter(Date == as.Date('2007-02-01') | Date == as.Date('2007-02-02'))

#using read_delim_chunk to read a part of data instead of read the whole data then subset
f <- function(x, pos) {filter(x, Date %in% c('1/2/2007', '2/2/2007'))}
sub_data <- read_delim_chunked(file = 'household_power_consumption.txt', DataFrameCallback$new(f), delim = ';',
                           chunk_size = 1000)
sapply(sub_data, class)
sub_data$Date <- as_date(dmy(sub_data$Date))

#Plotting
png(file = 'plot1.png', width = 480, height = 480)
with(sub_data, hist(Global_active_power, col = 'red', main = 'Global Active Power',
                    xlab = 'Global Active Power (kilowatts)',
                    ylab = 'Frequency'))
dev.off()