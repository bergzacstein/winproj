#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Nov 21 18:18:41 2019

@author: Mateusz
"""
import numpy as np
import skimage
from skimage import io as skio
import matplotlib.pyplot as plt
from utils import *

import cv2
import os
import numpy as np
import math

import sys
import skimage.color
import skimage.filters
import skimage.io
import skimage.viewer


image = cv2.imread('images/build.jpg')
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
median = cv2.medianBlur(gray,5)
#kernel = np.ones((5,5),np.uint8)
#sharp = cv2.filter2D(median, -1, kernel)
#plt.imshow(sharp, cmap='gray')
ret,thresh1 = cv2.threshold(median,127,255,cv2.THRESH_BINARY)
#im2, contours, hierarchy = cv2.findContours(thresh1, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
#c = cv2.drawContours(im2, contours, -1, (0,255,0), 3)
#area = cv2.contourArea(im2)
#plt.imshow(c, cmap = 'gray')



#Convert image to grayscale, median blur to smooth 
#Sharpen image to enhance edges
#Threshold
#Perform morphological transformations
#Find contours and filter using minimum/maximum threshold area
#Crop and save ROI

