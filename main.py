# -*- coding: utf-8 -*-

import numpy as np
import skimage
from utils import *
import matplotlib.pyplot as plt

#Sets current working directory
import os
dir_path = os.path.dirname(os.path.realpath(__file__))
#Change dir_path to another folder if your image files are somewhere else
os.chdir(dir_path)

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

def global_preprocessing(image):
    #Converts from RGB to HSV
    image_hsv = skimage.color.rgb2hsv(image)
    image = image[:,:,0]
    return image

def edge_detection(image):
    nb_floors = None
    return nb_floors

def detect_contrast(image):
    nb_floors = None
    return nb_floors

def count_floors(windows_list):
    """From a list of coordinates, corresponding to positions of windows,
    guesses the number of floors of the building."""
    nb_floors = None
    return nb_floors

def match_selection(image, selection):
    nb_floors = None
    return nb_floors

