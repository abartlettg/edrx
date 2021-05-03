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

driver.get("https://www.goodrx.com/sildenafil?dosage=100mg&form=tablet&label_override=sildenafil&quantity=30&sort_type=popularity")
#print(driver.title)

#### WILL LIKELY USE 3 START URLS INSTEAD ####
# enter_rx = driver.find_element_by_name("search-drugs")
# enter_rx.send_keys("sildenafil")
# Seems to get confused here w/dropdown list
# enter_rx.send_keys(Keys.TAB)
#enter_rx.send_keys(Keys.ENTER)
#enter_rx.send_keys = driver.find_element_by_?????
#enter_rx_btn.click()
#### REMOVE WHEN CLEANING UP CODE ####

#### Need to close first popup ####

try:
	ok_btn = WebDriverWait(driver, 10).until(
		EC.presence_of_element_located((By.CLASS_NAME, "okButton-hyrC_"))
		)
	ok_btn.click()
except:
	print("OK Button Not Detected")


#try:
#	set_loc_btn = WebDriverWait(driver, 10).until(
#		EC.presence_of_element_located((By., "Button"))
#		)
#	set_loc_btn.click()
#except:
#	print("Set Location Not Detected")

#driver.find_element_by_tag_name('body').send_keys(Keys.PAGE_DOWN)

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

###### WORKS TO THIS POINT... UPDATE GITHUB ######


#set_loc = driver.find_element_by_class("btn_3E6az")
#set_loc.send_keys("10025")
#set_loc.send_keys(Keys.RETURN)

#print(driver.page_source)

#time.sleep(5)

#driver.quit()


