# GoodRx Webscraping Using Selenium

from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import pandas as pd

# Set Path for Input and Output Files
DFPATH = "C:\\Users\\adria\\NYCDSA\\Online Bootcamp\\Rx Project\\Data"
# Set Path for Chrome Driver
CDPATH = "C:\\Users\\adria\\chromedriver_win32\\chromedriver.exe"

driver = webdriver.Chrome(CDPATH)

##### Optimally, I wanted this code to cycle through a list of URLs and ZipCodes, but the goodrx site was detecting
##### webscraping and refusing to move forward when designed like this.  Concerned that I may be booted off the site
##### completely prior to getting all the data I want to analyze for this project, I decided to run the script separately
##### for each URL and zip code combination to continue and come back to this later to optimize if I decide I want more
##### data or to run this for analysis on different types of Rxs in the future.  
url_lis = ["https://www.goodrx.com/sildenafil?dosage=100mg&form=tablet&label_override=sildenafil&quantity=30&sort_type=popularity"]
#"https://www.goodrx.com/vardenafil?dosage=20mg&form=tablet&label_override=vardenafil&quantity=30&sort_type=popularity"
#"https://www.goodrx.com/sildenafil?dosage=100mg&form=tablet&label_override=sildenafil&quantity=30&sort_type=popularity"
#"https://www.goodrx.com/tadalafil-cialis?dosage=20mg&amp;form=tablet&amp;label_override=tadalafil+%28Cialis%29&amp;quantity=30&amp;sort_type=popularity"]
zipcode_lis = [90011]
#10025
#60629
#77084
#90011

# Loop through URL List
for u in url_lis:
		driver.get(u)

# Closing initial popup
		try:
			ok_btn = WebDriverWait(driver, 10).until(
				EC.presence_of_element_located((By.CLASS_NAME, "okButton-hyrC_"))
				)
			time.sleep(2)
			ok_btn.click()
		except:
			print("OK Button Not Detected")

# Loop through Zipcode List
		for z in zipcode_lis:
				set_loc_btn = driver.find_element_by_class_name("btn-3E6az")
				time.sleep(2)
				set_loc_btn.click()

				try:
					enter_zip = WebDriverWait(driver, 10).until(
								EC.presence_of_element_located((By.ID, "locationModalInput"))
								)
					time.sleep(2)
					enter_zip.send_keys(z)
					enter_zip.send_keys(Keys.RETURN)
				except:
					print("Enter Zip Did Not Work")

# Gather Pharmacy and Rx Price Data 

# This needs to be an implicit wait because elements for prior zip code
# already exist on the page (EC are already satisfied by previous data)
				time.sleep(7)

				pharm_name_lis = []
				pharm_name = driver.find_elements_by_class_name("goldAddUnderline-1CwEN")
				for i in pharm_name:
					pharm_name_lis.append(i.text)
				print(pharm_name_lis)
				print(len(pharm_name_lis))

# Not all records contain a list price so an index needs to be used to check element by element.
				num = len(pharm_name_lis)
				idx = [i for i in range(num)]
				print(idx)

				time.sleep(2)

				rx_full_price_lis = []
				for i in idx:
					xp = "//*[@id='uat-price-row-coupon-" + str(i) + "']/div[2]/div/span[1]"
					try:
						rx_full_price = driver.find_element_by_xpath(xp)
						rx_full_price_lis.append(rx_full_price.text)

					except:
						rx_full_price_lis.append("")

				rx_full_price_lis = [s[1:-6:] for s in rx_full_price_lis]
				rx_full_price_lis = [s.replace(',','') for s in rx_full_price_lis]
				print(rx_full_price_lis)
				print(len(rx_full_price_lis))

				time.sleep(2)

				rx_disc_price_lis = []
				rx_disc_price = driver.find_elements_by_class_name("display-2zakM")
				for i in rx_disc_price:
					rx_disc_price_lis.append(i.text)
				rx_disc_price_lis = [s[27:-2:] for s in rx_disc_price_lis]
				print(rx_disc_price_lis)
				print(len(rx_disc_price_lis))

				rx_df = pd.DataFrame(list(zip(pharm_name_lis, rx_full_price_lis, rx_disc_price_lis)),
               				   columns =['pharmacy_name', 'rx_full_price', 'rx_disc_price'])
				rx_df = rx_df.assign(url=u, zipcode=z)

				filename = DFPATH + '\\results.csv'
				#with open(filename, 'a') as file_object:
    				#file_object.write("xxxxxxx")
				rx_df.to_csv(filename, header=False)
				print(rx_df)

				driver.quit()

#Outer Logic:
#		•	Initialize results.csv and log.txt
#		•	Read in rx.csv as DF and zipcode.csv as LIST
#		•	Create list of URLS from data in rx.csv
#		•	For i in URL list:
#				o	Open URL
#				o	For i in zipcode list:
#							Set zip code
#							Gather data
#							Check that #pharm = #list = #disc
#							Write to DF
#				o	Clean DF
#				o	Write to results.csv (append)
#				o	Write to log.csv (append)



#time.sleep(5)

#driver.quit()


