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

# Gathering Pharmacy and Rx Price Data

# Note that this NEEDS to be an Implicit Wait because the
# EC are met by data displayed from the PREVIOUS zip code 
# and therefore data related to the previous zip code will 
# be retrieved unless there is a hard-coded wait time
time.sleep(10)

pharm_name_lis = driver.find_elements_by_class_name("goldAddUnderline-1CwEN")
for i in pharm_name_lis:
	print(i.text)

# Note that the full price is not available for every pharmacy
# Need to figure out how to deal with this... need to index somehow
rx_full_price_lis = driver.find_elements_by_class_name("retailPriceStrikeSavings-1p-dB")
for i in rx_full_price_lis:
	print(i.text)

rx_disc_price_lis = driver.find_elements_by_class_name("display-2zakM")
for i in rx_disc_price_lis:
	print(i.text)




#time.sleep(5)

#driver.quit()


