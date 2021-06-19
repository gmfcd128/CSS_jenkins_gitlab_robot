import ast
import filecmp
import inspect
import itertools
import json
import math
import os
import random
import re
import threading
import time
import types
import zipfile

from ast import literal_eval
from datetime import datetime
from functools import cmp_to_key

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn

from robot.libraries.BuiltIn import BuiltIn
from robot.output.logger import LOGGER
from robot.utils import timestr_to_secs
from SeleniumLibrary import SeleniumLibrary

from selenium import webdriver
from selenium.common.exceptions import JavascriptException, WebDriverException, TimeoutException
from selenium.webdriver import ActionChains
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.firefox.options import Options as FirefoxOptions
from selenium.webdriver.common.by import By
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.remote.webelement import WebElement
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support.select import Select
from selenium.webdriver.firefox.options import Options as FirefoxOptions
from os import getcwd
from robot.libraries.OperatingSystem import OperatingSystem
import xlrd

class dctLibrary:

    ROBOT_LISTENER_API_VERSION = 2

    def __init__(self, *args, **kwargs):
        self.api_model_library_fields = None
        self.viewportXpath = "//*[contains(@class, 'ui-grid-render-container-body')]//*[contains(@class, 'ui-grid-viewport')]"
        self.ROBOT_LIBRARY_LISTENER = self

    def _current_browser(self):
        return self.selenium.driver

    def start_test(self, name, attributes):
        self.has_taken_a_screenshot = False 
        BuiltIn().import_library('SeleniumLibrary')

    def start_keyword(self, name, attributes):
        if self.slow_network and attributes['kwname'] in ('Logoff', 'Relogin'):
            if self._current_browser().capabilities['browserName'] == 'chrome':
                self.set_throughput(0, 9999999, 9999999)
            # Set network speed for Firefox once it provides the interface

    def end_keyword(self, name, attributes):
        if attributes['status'] == 'FAIL' and attributes['libname'] not in ['SeleniumLibrary'] and not self.has_taken_a_screenshot and "No browser is open." not in attributes['args'] and attributes['kwname'] != 'Check No Browser Is Open':
            try:
                self.selenium.capture_page_screenshot()
                self.has_taken_a_screenshot = True
            except:
                pass
        elif attributes['status'] == 'PASS':
            self.has_taken_a_screenshot = False
        if attributes['kwname'] == 'Select Frame' and attributes['status'] == 'PASS':
            self.__retry_select_frame(5, attributes['args'][0])    # selenium library bug, "Select Frame" keyword sometimes not work. Retry select frame until it fail, it real select frame
        if self.slow_network and attributes['kwname'] == 'Hover Tab':
            if self._current_browser().capabilities['browserName'] == 'chrome':
                self.set_throughput(1000, 81200, 81200)
            # Set network speed for Firefox once it provides the interface

    def __getattr__(self, name):
        if name == 'rest':
            # url = re.match("https://[^/]+", self._current_browser().current_url).group(0)
            url = BuiltIn().get_variable_value('${dctrackURL}')
            self.rest = REST(url, 'admin', 'sunbird')
            return self.rest
        if name == 'selenium':
            self.selenium = BuiltIn().get_library_instance('SeleniumLibrary')
            return self.selenium
        if name == 'shortPeriodOfTime':
            self.shortPeriodOfTime = timestr_to_secs(BuiltIn().get_variable_value('${shortPeriodOfTime}'))
            return self.shortPeriodOfTime
        if name == 'normalPeriodOfTime':
            self.normalPeriodOfTime = timestr_to_secs(BuiltIn().get_variable_value('${normalPeriodOfTime}'))
            return self.normalPeriodOfTime
        if name == 'longPeriodOfTime':
            self.longPeriodOfTime = timestr_to_secs(BuiltIn().get_variable_value('${longPeriodOfTime}'))
            return self.longPeriodOfTime
        if name == 'slow_network':
            self.slow_network = BuiltIn().get_variable_value('${slowNetwork}')
        if name == 'userManager':
            url = BuiltIn().get_variable_value('${dctrackURL}')
            self.userManager = UserManager(url, 'admin', 'sunbird')
            return self.userManager
        return object.__getattribute__(self, name)

    @keyword(name='Scroll View')
    def scroll_view(self):
        driver = self._current_browser()
        js="window.scrollTo(0, document.body.scrollHeight)"
        driver.execute_script(js)

    @keyword(name='Scroll View With Smooth Method')
    def scroll_view_smooth(self):
        driver = self._current_browser()
        js_Web_Height = 'return document.body.scrollHeight;'
        Web_Height = driver.execute_script(js_Web_Height)
        driver.execute_script("window.scrollTo({ top: %s, behavior: 'smooth' });" %(Web_Height))
    
    @keyword(name='Take Capture Page Screenshot')
    def take_capture_screenshot(self, location):
        try:
            self.selenium.capture_page_screenshot(location)
        except TimeoutException:
            self.selenium.close_all_browsers()
            BuiltIn().fail('Close Browser because TimeoutException happen!!!')

    def __get_web_element(self, locator, timeout=None, message=None):
        timeout = 3 if timeout == None else timeout
        message = 'Element wasn\'t found: "%s".' % locator if message == None else message
        return WebDriverWait(self._current_browser(), timeout).until(EC.presence_of_element_located((By.XPATH, locator.replace('xpath:', ''))), message)
    
    @keyword(name='Scroll Web Element With Smooth')
    def scroll_web_element_with_smooth(self, web_element, top=100, left=0):
        self._current_browser().execute_script('arguments[0].scroll({ top: %s, left: %s ,behavior: "smooth" });' % (top, left), web_element)
        
    @keyword(name='Scroll SideBar To The End')
    def scroll_sidebar_to_the_end(self):
        sideBarXpath = "xpath://*[@class='nav-sidebar-inner-scroll']"
        sideBar = self.__get_web_element(sideBarXpath, message="Scroll element should be vivble.")
        bottom = int(sideBar.get_attribute('scrollTop')) + int(sideBar.get_attribute('offsetHeight'))
        self.scroll_web_element_with_smooth(sideBar, top=bottom,  left=0)

    @keyword(name='Read TXT File')
    def read_txt_file(self,file):
        f = open(file, "r")
        file=f.readlines()
        result=""
        for i in range(len(file)):
            result+=file[i]
        result=result.replace("\n","\\n")
        return result