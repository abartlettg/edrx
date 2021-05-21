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
  geom_boxplot() +
  labs(x='Zip Code', y='GoodRx Discount Price') +
  theme(panel.background = element_rect(fill = "#4495A2"))

edrx_df %>%
  filter(RxName =='tadalafil' & RxDose == 20) %>%
  ggplot(aes(as.character(ZipCode), DiscPrice)) +
  geom_boxplot() +
  labs(x='Zip Code', y='GoodRx Discount Price') +
  theme(panel.background = element_rect(fill = "#F9D448"))

edrx_df %>%
  filter(RxName =='vardenafil' & RxDose == 20) %>%
  ggplot(aes(as.character(ZipCode), DiscPrice)) +
  geom_boxplot() +
  labs(x='Zip Code', y='GoodRx Discount Price') +
  theme(panel.background = element_rect(fill = "#7CA655"))

### Boxplot by ZipCode for Variation in List Price ###
  
edrx_df %>%
  filter(RxName =='sildenafil' & RxDose == 50) %>%
  ggplot(aes(as.character(ZipCode), ListPrice)) +
  geom_boxplot() +
  labs(x='Zip Code', y='List Price Without Discount') +
  theme(panel.background = element_rect(fill = "#4495A2"))

edrx_df %>%
  filter(RxName =='tadalafil' & RxDose == 20) %>%
  ggplot(aes(as.character(ZipCode), ListPrice)) +
  geom_boxplot() +
  labs(x='Zip Code', y='List Price Without Discount') +
  theme(panel.background = element_rect(fill = "#F9D448"))


edrx_df %>%
  filter(RxName =='vardenafil' & RxDose == 20) %>%
  ggplot(aes(as.character(ZipCode), ListPrice)) +
  geom_boxplot() +
  labs(x='Zip Code', y='List Price Without Discount') +
  theme(panel.background = element_rect(fill = "#7CA655"))

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
  ggplot(aes(x = factor(RxDose, level = c(100,50,25,20)), MinDiscPricePerMg)) +
  geom_col() +
  labs(x='Pill Dose', y='Minimum Discount Price Per Mg') +
  theme(panel.background = element_rect(fill = "#4495A2"))

edrx_sum_df %>%
  filter(RxName == 'tadalafil') %>%
  mutate(MinDiscPricePerMg = MinDiscPrice/((as.numeric(RxDose))*30)) %>%
  ggplot(aes(x = factor(RxDose, level = c(20,10,5,2.5)), MinDiscPricePerMg)) +
  geom_col() +
  labs(x='Pill Dose', y='Minimum Discount Price Per Mg') +
  theme(panel.background = element_rect(fill = "#F9D448"))
  

edrx_sum_df %>%
  filter(RxName == 'vardenafil') %>%
  mutate(MinDiscPricePerMg = MinDiscPrice/((as.numeric(RxDose))*30)) %>%
  ggplot(aes(x = factor(RxDose, level = c(20,10,5,2.5)), MinDiscPricePerMg)) +
  geom_col() +
  labs(x='Pill Dose', y='Minimum Discount Price Per Mg') +
  theme(panel.background = element_rect(fill = "#7CA655"))

### Analysis of Lowest Cost Pharmacies when using GoodRx for the most
### often prescribed dosages (according to drugs.com) of the three Rxs
### Sildenafil 50
### Tadalafil 20
### Vardenafil 20

unique(edrx_df$Pharmacy)
# 28 unique pharmacy names which appear to already be standardized...
# no duplicates due to differences in capitalization, punctuation, or spelling

# First, get average DiscPrice for each pharmacy
pharm_data = edrx_df %>%
  filter(RxName == 'vardenafil' & RxDose == '20') %>%
  group_by(Pharmacy) %>%
  summarise(AvgDiscPrice = mean(DiscPrice)) %>%
  arrange(AvgDiscPrice)

pharm_df = data.frame(pharm_data)
pharm_df_10 = slice_head(pharm_df,n=10)

pharm_df_10 %>%
  ggplot(aes(Pharmacy, AvgDiscPrice)) +
  geom_col()

### The above graphs are not really useful for presentation because there
### are too many smaller/regional pharmacies that show up.  This could cause
### the audience to lose interest if they don't see pharmacies that they 
### personally recognize on the graph.

# So, let's ask this question instead...
# Which pharmacies show up the most across all data for having discount
# pricing through GoodRx?  The most a pharmacy can show up is 48 times
# because there are 48 data files for different Rx, Dose, and Zipcode.
# Selecting pharmacies w/a count of >36 in the data, will give us the
# pharmacies that show up more than 75% when searching for a particular
# Rx and Dose across multiple zipcodes.

pharm_tally = edrx_df %>%
  select('RxName', 'RxDose', 'Pharmacy', 'DiscPrice') %>%
  group_by(Pharmacy) %>%
  tally()
  
pharm_tally_df = data.frame(pharm_tally)
pharm_tally_df

nw_pharm = pharm_tally_df %>%
  filter(n>36)
nw_pharm_df = data.frame(nw_pharm)
 
# This gives us the following nationwide pharmacies:
# 1       Costco 42
# 2 CVS Pharmacy 38
# 3 Target (CVS) 48
# 4    Walgreens 44
# 5      Walmart 48
# Use these pharmacies to do a side by side comparison

# Boxplot variation in pricing by mg across zipcodes by pharmacies having
# the most GoodRx discounts.

edrx_nw_pharm = inner_join(edrx_df, nw_pharm_df, by='Pharmacy' )

edrx_nw_pharm_df = data.frame(edrx_nw_pharm)
edrx_nw_pharm_df

edrx_nw_pharm_df %>%
  filter(RxName == 'sildenafil' & (!is.na(DiscPrice))) %>%
  group_by(Pharmacy) %>%
  mutate(DiscPricePerMg = DiscPrice/((as.numeric(RxDose))*(as.numeric(RxCount)))) %>%
  ggplot(aes(Pharmacy,DiscPricePerMg)) +
  geom_boxplot() +
  labs(x='Nationwide Pharmacy', y='GoodRx Discount Price') +
  theme(panel.background = element_rect(fill = "#4495A2"))

edrx_nw_pharm_df %>%
  filter(RxName == 'tadalafil' & (!is.na(DiscPrice))) %>%
  group_by(Pharmacy) %>%
  mutate(DiscPricePerMg = DiscPrice/((as.numeric(RxDose))*(as.numeric(RxCount)))) %>%
  ggplot(aes(Pharmacy,DiscPricePerMg)) +
  geom_boxplot() +
  labs(x='Nationwide Pharmacy', y='GoodRx Discount Price') +
  theme(panel.background = element_rect(fill = "#F9D448"))

edrx_nw_pharm_df %>%
  filter(RxName == 'vardenafil' & (!is.na(DiscPrice))) %>%
  group_by(Pharmacy) %>%
  mutate(DiscPricePerMg = DiscPrice/((as.numeric(RxDose))*(as.numeric(RxCount)))) %>%
  ggplot(aes(Pharmacy,DiscPricePerMg)) +
  geom_boxplot() +
  labs(x='Nationwide Pharmacy', y='GoodRx Discount Price') +
  theme(panel.background = element_rect(fill = "#7CA655"))

### The above shows that Walmart and Costco are a safe bet for getting a great
### price on the two most prescribed ED Meds through a Nationwide Pharmacy, but
### for Vardenafil (newly generic), you are better off going to the other three
### pharmacies.  This is not entirely unexpected as Costco and Walmart are 
### power players when it comes to buying in bulk for highly popular products,
### but don't pay attention as much to using their negotiation power with 
### products that are not mainstream.

### This is good to know if you commonly shop at Walmart or Costco and are 
### prescribed sildenafil or tadalafil.  You can count on these two big
### pharmacies to provide these Rxs at a cost that is not necessarily the 
### absolute lowest, but within a tight range around lowest discount price 
### with GoodRx card so that you don't necessarily have to look up the price
### on GoodRx to know you will get a good deal.

### ENHANCEMENTS TO COLOR, LABELS, AND LEVELS ONLY DONE FOR GRAPHS
### USEFUL FOR PRESENTATION.

