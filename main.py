# -*- coding: utf-8 -*-

import numpy as np
import skimage, scipy
from utils import *
import matplotlib.pyplot as plt
import skimage.morphology as morpho

#Sets current working directory
#import os
#cdir_path = os.path.dirname(os.path.realpath(__file__))
#Change dir_path to another folder if your image files are somewhere else
#os.chdir(dir_path)

def lazy_fft(x):
    """Returns the Fourier transform of an image."""
    return np.log(np.abs(np.fft.fftshift(np.fft.fft2(x))))

def lazy_imshow(image, grey=True):
    """A shortcut to quickly show a picture in greyscale using matplot lib. """
    if grey: 
        plt.imshow(image, cmap='gray')
    else: 
        plt.imshow(image)
    plt.show()

def count_floors(windows_list):
    """From a list of coordinates, corresponding to positions of windows,
    guesses the number of floors of the building."""
    nb_floors = None
    return nb_floors

import matchsel
import importlib
importlib.reload(matchsel)
from matchsel import *

image = skio.imread('img/telecom.jpeg')
im_grayscale = skimage.color.rgb2hsv(image)[:,:,2]
selection = ((708, 393), (757, 529))
#selection = ((1412, 2572), (1722, 2784))
#selection = ((1380, 1380), (1550,1550))
#selection = ((1835, 758), (1897, 949))
similarity_matrix = horizontal_match_selection(im_grayscale, selection, sim=exp_sim)
plt.plot(similarity_matrix)
plt.show()


#median filtering
#convolve with vertical [-1 0 1]

im = im_grayscale
im = scipy.signal.convolve2d(im, np.ones((10,10)))
im = scipy.ndimage.filters.maximum_filter(im, 20)
im = scipy.signal.medfilt(im)
#im = scipy.signal.convolve2d(im, np.array([[-1],[0 ], [1]]))
#im = im**2

nb_floors, similarity_matrix = match_selection(im, selection, 8)

#Detect windows borders with horizontal edge detections + sum on the rows
#And then detect windows with vertical edge detections + sum on the columns
#Use the peaks of these two sums to detect coordinates of a window
#Search for this window, on the row of this window, using a match for euclidian distance. 
#Use that to guess whether or not this detected window belongs to a floor (we should see a lot of windows)
#Combine results of every detected window
#???
#Profit. 

im = scipy.signal.convolve2d(im, np.array([[1,0,-1]]))

lazy_imshow(im)
lazy_imshow(similarity_matrix)


im = similarity_matrix
im = scipy.ndimage.filters.maximum_filter(im, 10)


np.ones(X_copy.shape)

lazy_imshow(im)



