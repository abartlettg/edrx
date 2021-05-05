# GoodRx Webscraping Using Selenium

from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time

PATH = "C:\\Users\\adria\\chromedriver_win32\\chromedriver.exe"
driver = webdriver.Chrome(PATH)

###### TO BE LOOPED THROUGH 3 DIFFERENT MEDICATION TYPES AND POSSIBLY VARIATIONS IN DOSAGE (TBD) ######
driver.get("https://www.goodrx.com/sildenafil?dosage=100mg&form=tablet&label_override=sildenafil&quantity=30&sort_type=popularity")

# Closing initial popup
try:
	ok_btn = WebDriverWait(driver, 10).until(
		EC.presence_of_element_located((By.CLASS_NAME, "okButton-hyrC_"))
		)
	ok_btn.click()
except:
	print("OK Button Not Detected")

###### TO BE LOOPED THROUGH A LIST OF ZIP CODES TO BE ANALYZED ######
# Setting Location by Zip Code
set_loc_btn = driver.find_element_by_class_name("btn-3E6az")
set_loc_btn.click()

try:
	enter_zip = WebDriverWait(driver, 10).until(
		EC.presence_of_element_located((By.ID, "locationModalInput"))
		)
	enter_zip.send_keys("10025")
	enter_zip.send_keys(Keys.RETURN)
except:
	print("Enter Zip Did Not Work")

####### Gathering Pharmacy and Rx Price Data #######

# This needs to be an implicit wait because elements for prior zip code
# already exist on the page (EC are already satisfied by previous data)
time.sleep(5)

pharm_name_lis = driver.find_elements_by_class_name("goldAddUnderline-1CwEN")
for i in pharm_name_lis:
	print(i.text)
print(len(pharm_name_lis))

# Not all records contain a list price so an index needs to be used to check element by element.
num = len(pharm_name_lis)
idx = [i for i in range(num)]
print(idx)

for i in idx:
	xp = "//*[@id='uat-price-row-coupon-" + str(i) + "']/div[2]/div/span[1]"
	try:	#### //div/ul/li[i]/div/div/span[@class='retailPriceStrikeSavings-1p-dB']  GETTING ALL NULLS... NEED TO WORK ON XPATH ####
		rx_full_price = driver.find_element_by_xpath(xp)
		print(rx_full_price.text)
	except:
		print('NULL')

rx_disc_price_lis = driver.find_elements_by_class_name("display-2zakM")
for i in rx_disc_price_lis:
	print(i.text)
print(len(rx_disc_price_lis))




#time.sleep(5)

#driver.quit()


