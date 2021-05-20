# Adriana Bartlett Gray
# EDA - ED Rx Data from Webscraping

# Load libraries & read in files

library(tidyr)
library(dplyr)
library(ggplot2)
library(lubridate)
library(readr)
library(stringr)

########## THIS SECTION READS IN ALL DATA FILES CREATED THROUGH WEBSCRAPING ########## 
##########      AND PUTS ALL DATA INTO ONE DATAFRAME READY FOR ANALYSIS.    ########## 

setwd("C:/Users/adria/NYCDSA/Online Bootcamp/Rx Project")


#rx_list = list(list("sildenafil",100,30), list("tadalafil",20,30), list("vardenafil",20,30))
#print(rx_list)

# List of rxname, rxdose, and rxcount used for webscraping
rx_list = list((c("sildenafil",20,30)),
               (c("sildenafil",25,30)),
               (c("sildenafil",50,30)),
               (c("sildenafil",100,30)),
               (c("tadalafil",2.5,30)),
               (c("tadalafil",5,30)),
               (c("tadalafil",10,30)),
               (c("tadalafil",20,30)),
               (c("vardenafil",2.5,30)),
               (c("vardenafil",5,30)),
               (c("vardenafil",10,30)),
               (c("vardenafil",20,30)))

# List of zipcodes used for webscraping
zc_list = list(10025,60629,77084,90011)
#print(zc_list)


# Creating empty data frame to read files into
edrx_df <- data.frame(matrix(ncol = 9, nrow = 0))
colnames(edrx_df) <- c('FileIDX','Pharmacy', 'ListPrice', 'DiscPrice', 'URL', 'ZipCode', 'RxName', 'RxDose', 'RxCount')


# Uses lists above to build file names (of webscraping output) to read in and append to one dataframe for analysis
for(i in 1:length(rx_list)) {
  for(z in 1:length(zc_list)) {
    dfp1 = paste((rx_list[[i]][1]),(as.character(rx_list[[i]][2])),(as.character(rx_list[[i]][3])),sep='_')
    dfp2 = paste(dfp1,(as.character(zc_list[z])),sep='_')
    datafilename = paste(dfp2, "csv", sep=".")
    print(datafilename)
    data_file = read.csv(paste('Data/', datafilename, sep=''))
    colnames(data_file) <- c('FileIDX','Pharmacy', 'ListPrice', 'DiscPrice', 'URL', 'ZipCode')
    data_file$RxName = rx_list[[i]][1]
    data_file$RxDose = rx_list[[i]][2]
    data_file$RxCount = rx_list[[i]][3]
    edrx_df = rbind(edrx_df, data_file)
    }
  }
  
    
##################### DATA ANALYSIS #####################

### Overall Summary of Data ###

edrx_sum = edrx_df %>%
  select('ZipCode', 'RxName', 'RxDose', 'DiscPrice', 'ListPrice') %>%
  filter(!is.na(DiscPrice), !is.na(ListPrice)) %>%
  group_by(ZipCode, RxName, RxDose) %>%
  summarise(min(DiscPrice), mean(DiscPrice), median(DiscPrice), max(DiscPrice), min(ListPrice), mean(ListPrice), median(ListPrice), max(ListPrice))

edrx_sum_df = data.frame(edrx_sum)


### Boxplot by ZipCode for Variation in Discount Price ###

edrx_df %>%
  filter(RxName =='sildenafil' & RxDose == 50) %>%
  ggplot(aes(as.character(ZipCode), DiscPrice)) +
  geom_boxplot()

edrx_df %>%
  filter(RxName =='tadalafil' & RxDose == 20) %>%
  ggplot(aes(as.character(ZipCode), DiscPrice)) +
  geom_boxplot()
  
edrx_df %>%
  filter(RxName =='vardenafil' & RxDose == 20) %>%
  ggplot(aes(as.character(ZipCode), DiscPrice)) +
  geom_boxplot()

### Boxplot by ZipCode for Variation in List Price ###
  
edrx_df %>%
  filter(RxName =='sildenafil' & RxDose == 50) %>%
  ggplot(aes(as.character(ZipCode), ListPrice)) +
  geom_boxplot()

edrx_df %>%
  filter(RxName =='tadalafil' & RxDose == 20) %>%
  ggplot(aes(as.character(ZipCode), ListPrice)) +
  geom_boxplot()

edrx_df %>%
  filter(RxName =='vardenafil' & RxDose == 20) %>%
  ggplot(aes(as.character(ZipCode), ListPrice)) +
  geom_boxplot()

#############################################################################
### From the above, we see...
###    * significant savings using the GoodRx Discount
###    * wide variation in pricing even when using the GoodRx Discount,
###      indicating that it's worth it to not just carry the GoodRx card
###      with you, but look up the pharmacies w/lowest GoodRx prices online 
###      before filling your Rx
###    * median (represented by line on boxplot) does not appear to vary
###      that much by zipcode
###      --> Given this, the remainder of the analysis will focus on
###          other factors instead of comparing across zipcodes
#############################################################################

### Boxplot for each Rx type showing cost/mg by mg size pill
### - for the consideration of pill splitting to reduce cost

edrx_df %>%
  filter(RxName == 'sildenafil') %>%
  mutate(DiscPricePer50Mg = (DiscPrice/((as.numeric(RxDose))*(as.numeric(RxCount)))*50)) %>%
  ggplot(aes((as.character(RxDose)),DiscPricePer50Mg)) +
  geom_boxplot()

edrx_df %>%
  filter(RxName == 'tadalafil') %>%
  mutate(DiscPricePerMg = DiscPrice/((as.numeric(RxDose))*(as.numeric(RxCount)))) %>%
  ggplot(aes((as.character(RxDose)),DiscPricePerMg)) +
  geom_boxplot()

edrx_df %>%
  filter(RxName == 'vardenafil') %>%
  mutate(DiscPricePerMg = DiscPrice/((as.numeric(RxDose))*(as.numeric(RxCount)))) %>%
  ggplot(aes((as.character(RxDose)),DiscPricePerMg)) +
  geom_boxplot()

### The resulting box plots from above are not useful for presentation purposes
### because they don't visualize the comparison well enough.  For a consumer who
### is trying to minimize cost, it makes better sense to assume they will choose
### from the lowest cost pharmacy first... so a bar chart is better to show
### this more clearly.

### Barchart for each Rx type showing cost/mg by mg size pill
### - for the consideration of pill splitting to reduce cost

edrx_sum_df$MinDiscPrice = edrx_sum_df$min.DiscPrice.

edrx_sum_df %>%
  filter(RxName == 'sildenafil') %>%
  mutate(MinDiscPricePerMg = MinDiscPrice/((as.numeric(RxDose))*30)) %>%
  ggplot(aes(RxDose, MinDiscPricePerMg)) +
  geom_col()

edrx_sum_df %>%
  filter(RxName == 'tadalafil') %>%
  mutate(MinDiscPricePerMg = MinDiscPrice/((as.numeric(RxDose))*30)) %>%
  ggplot(aes(RxDose, MinDiscPricePerMg)) +
  geom_col()

edrx_sum_df %>%
  filter(RxName == 'vardenafil') %>%
  mutate(MinDiscPricePerMg = MinDiscPrice/((as.numeric(RxDose))*30)) %>%
  ggplot(aes(RxDose, MinDiscPricePerMg)) +
  geom_col()

### RETURN TO ALL GRAPHS TO IMPROVE AESTHETICS FOR PRESENTATION



