# Adriana Bartlett Gray
# EDA - ED Rx Data from Webscraping

# Load libraries & read in files

library(tidyr)
library(dplyr)
library(ggplot2)
library(lubridate)
library(readr)
library(stringr)

setwd("C:/Users/adria/NYCDSA/Online Bootcamp/Rx Project")


#rx_list = list(list("sildenafil",100,30), list("tadalafil",20,30), list("vardenafil",20,30))
#print(rx_list)

# List of rxname, rxdose, and rxcount used for webscraping
rx_list = list((list("sildenafil",100,30)), (list("tadalafil",20,30)), (list("vardenafil",20,30)))

# List of zipcodes used for webscraping
zc_list = list(10025,60629,77084,90011)
#print(zc_list)


# Creating empty data frame to read files into
edrx_df <- data.frame(matrix(ncol = 8, nrow = 0))
colnames(edrx_df) <- c('Pharmacy', 'ListPrice', 'DiscPrice', 'URL', 'ZipCode', 'RxName', 'RxDose', 'RxCount')


# Uses lists above to build file names (of webscraping output) to read in and append to one dataframe for analysis
for(i in 1:length(rx_list)) {
  for(z in 1:length(zc_list)) {
    dfp1 = paste((rx_list[[i]][1]),(as.character(rx_list[[i]][2])),(as.character(rx_list[[i]][3])),sep='_')
    dfp2 = paste(dfp1,(as.character(zc_list[z])),sep='_')
    datafilename = paste(dfp2, "csv", sep=".")
    print(datafilename)
    data_file = read.csv(paste('Data/', datafilename, sep=''))
    colnames(data_file) <- c('Pharmacy', 'ListPrice', 'DiscPrice', 'URL', 'ZipCode')
    data_file$RxName = rx_list[[i]][1]
    data_file$RxDose = rx_list[[i]][2]
    data_file$RxCount = rx_list[[i]][3]
    edrx_df = rbind(edrx_df, data_file)
    }
  }
  
    
##################### Code for data analysis to be added ##################### 



