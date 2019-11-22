#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 20 09:52:26 2019

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


image = cv2.imread('images/easyBuilding.png')
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

#thresh = 50
#binary = cv2.threshold(gray, thresh, 255, cv2.THRESH_BINARY)[1]
#plt.imshow(binary, cmap = 'gray')

#th3 = cv2.adaptiveThreshold(gray,255,cv2.ADAPTIVE_THRESH_GAUSSIAN_C,\
#            cv2.THRESH_BINARY,11,2)
#plt.imshow(th3, cmap = 'gray')

# blur and grayscale before thresholding
#blur = skimage.filters.gaussian(gray, sigma=2.0)
#t = skimage.filters.threshold_otsu(blur)
#mask = blur > t
#plt.imshow(mask, cmap = 'gray')
  
#cv2.imshow('Original image',image)
#cv2.imshow('Gray image', gray)
#plt.imshow(gray, cmap = 'gray')

# creating a Histograms Equalization 
# of a image using cv2.equalizeHist() 
equ = cv2.equalizeHist(gray) 
#plt.imshow(equ, cmap = 'gray')

#hist_equ = plt.hist(equ.reshape((-1,)),bins=255) 
#hist_equ

#threshold1 = 85
#threshold2 = 170
#value1 = 0
#value2 = 85
#value3 = 170
#value4 = 255

#for i in range(len(equ)):
 #   for j in range(len(equ[i])):
  #      if equ[i][j] < threshold1: 
   #         equ[i][j] = value1
    #    elif equ[i][j] > threshold1: 
     #       equ[i][j] = value2
      #  elif equ[i][j] > threshold2: 
       #     equ[i][j] = value3 
        #else: 
         #   equ[i][j] = value4
            
#plt.imshow(equ, cmap = 'gray')
    
    
#kernel = np.ones((1,20),np.uint8)
#closing = cv2.morphologyEx(equ, cv2.MORPH_CLOSE, kernel)
#opening = cv2.morphologyEx(closing, cv2.MORPH_OPEN, kernel)
#gradient = cv2.morphologyEx(equ, cv2.MORPH_GRADIENT, kernel)
#plt.imshow(closing, cmap = 'gray')

def to_three_channel(img):
	gray = np.zeros(img.shape + (3,)).astype("uint8")
	for i in range(3):
		gray[...,i] = img
	return gray

def get_factor(start_val, end_val, iterations):
	return math.exp(1)**(math.log(end_val/start_val)/iterations)


def canny(img, minval, maxval):
	img = cv2.medianBlur(img,5)
	img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
	img = cv2.Canny(img, minval, maxval)
	return to_three_channel(img)

minval = 10
maxval = 30

cv2.imwrite('images/ie.jpg', equ) 
im = cv2.imread('images/ie.jpg')
canny1 = canny(im, minval, maxval)
#plt.imshow(canny1, cmap = 'gray')


def sobel(img, t):
	sobelx = cv2.Sobel(img,cv2.CV_64F,1,0,ksize=3)
	sobely = cv2.Sobel(img,cv2.CV_64F,0,1,ksize=3)
	edges = np.abs(sobelx) + np.abs(sobely)
	edges = np.mean(edges, axis=2)
	m = np.max(edges)
	edges[edges > m*t] = 255
	edges[edges <= m*t] = 0
	return to_three_channel(edges)

threshold = 0.12
sobel1 = sobel(im, threshold)
#plt.imshow(sobel1, cmap = 'gray') 

#f = np.fft.fft2(equ)
#fshift = np.fft.fftshift(f)
#magnitude_spectrum = 20*np.log(np.abs(fshift))

#plt.subplot(121),plt.imshow(equ, cmap = 'gray')
#plt.title('Input Image'), plt.xticks([]), plt.yticks([])
#plt.subplot(122),plt.imshow(magnitude_spectrum, cmap = 'gray')
#plt.title('Magnitude Spectrum'), plt.xticks([]), plt.yticks([])
#plt.show()

kernelx = np.array([[1,1,1],[0,0,0],[-1,-1,-1]])
kernely = np.array([[-1,0,1],[-1,0,1],[-1,0,1]])
img_prewittx = cv2.filter2D(equ, -1, kernelx)
img_prewitty = cv2.filter2D(equ, -1, kernely)

#plt.imshow(img_prewitty, cmap = 'gray')


kernel = np.ones((5,5),np.uint8)
openingx = cv2.morphologyEx(img_prewittx, cv2.MORPH_OPEN, kernel)
plt.imshow(openingx, cmap = 'gray')
#plt.imshow(opening)

#import numarray
#Sum all the rows:
#t1 = [sum(opening[i]) for i in range(4)]

# Sum all the columns:
#t2 = [sum(opening[:,i]) for i in range(4)]

#sumy = np.sum(opening,axis=0)
#plt.plot(sumy)
#kernel2 = np.ones((1,20), np.uint8)  # note this is a horizontal kernel
#d_im = cv2.dilate(opening, kernel2, iterations=1)
#e_im = cv2.erode(d_im, kernel2, iterations=1)

#res = list(map(sum, e_im))
#plt.plot(res, range(len(res)))
#plt.imshow(e_im, cmap = 'gray')

#sum = opening.sum(axis=1)
#plt.figure(figsize=(5,5))
#plt.plot(sum)
#plt.show

#def detect(self, c): 
    

sumx = openingx.sum(axis=1)
plt.figure(figsize=(5,5))
plt.plot(sumx)
#plt.axhline(y=20000, color='r', linestyle='-')
plt.show

#from scipy.signal import argrelextrema
# for local maxima
#argrelextrema(sumx, np.greater)

