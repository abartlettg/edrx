ED Rx Webscraping Project
2nd Project for NYC Data Science Academy Bootcamp
Written by Adriana Bartlett Gray

Description:
The purpose of this project is to utilize webscraping skills and data analysis skills to explore pricing of ED medications when using the goodrx.com discount.

Project Status:
This project is still a work-in-progress.  Selenium webscraping script runs properly to retrieve and write data to an output file.  And, R script works properly to load multiple data files into one dataframe for analysis. 

Requirements:
* Python
* Selenium
* R

Installation & Use:
* Modify python script with URL and zipcode, then run.
* Rename output files with the following format 'rx_name_rx_dose_rx_count_zipcode.csv'... for example sildenafil 100 mg 30 count in zipcode 10025, rename to 'sildenafil_100_30_10025.csv'.
* Modify rx_list and zipcode_list in R file to reflect the files you want to analyze in the data directory, then run to read in all files and create one dataframe for analysis.

Known Bugs:
There are no bugs in the working code, as it is.  However, I plan to do more work to better streamline processing so that an input file or files can be used for rx_name, rx_dose, rx_count, and zipcodes to webscrape information for and then place into one output file so that R processing is not needed to combine data after running the webscraping portion.  This work was put on hold as I was receiving messages from goodrx indicating that their site had detected webscraping and would block me from their site.
