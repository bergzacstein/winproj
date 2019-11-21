# -*- coding: utf-8 -*-

import numpy as np
import skimage
from utils import *
import matplotlib.pyplot as plt

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

def global_preprocessing(image):
    #Converts from RGB to HSV
    image_hsv = skimage.color.rgb2hsv(image)
    image = image_hsv[:,:,0]
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

def match_selection(image, selection, step = 4):
    """image : a numpy array corresponding to a picture.
    selection : ((topleft_x, topleft_y), (bottomright_x, bottoomright_y))"""
    #selection_im is the part of the image corresponding to the coordinate selection. 
    selection_im = image[selection[0][0]:selection[1][0], selection[0][1]:selection[1][1]]
    selection_width = np.abs(selection[0][0] - selection[1][0])
    selection_height = np.abs(selection[1][1] - selection[0][1])

    step = step #instead of doing pixel_wise comparison, we use a step. 
    lines = image.shape[0] - selection_height
    cols = image.shape[1] - selection_width
    #similarity_matrix holds the result of our similarity test between selection and
    # the subsection of image tested. 
    similarity_matrix = np.zeros((int(lines/step), int(cols/step)))
    for j in range(0, cols, step): #from left to right
        for i in range(0, lines, step): #from top to bottom
            # subsection is now a sample from our image. 
            subsection = image[i:i+selection_width, j:j+selection_height]
            # We score the similarity between subsection and selection_im.
            # This can be done using various measures.
            if selection_im.shape == subsection.shape: 
                similarity = 1 - np.linalg.norm(selection_im - subsection) / np.linalg.norm(selection_im)
                similarity_matrix[int(i/step), int(j/step)] = similarity
    
    nb_floors = None
    return nb_floors, similarity_matrix

image = skio.imread('img/telecom.jpeg')
im_grayscale = skimage.color.rgb2hsv(image)[:,:,2]
selection = ((708, 393), (757, 529))

nb_floors, similarity_matrix = match_selection(im_grayscale, selection)
skio.imsave('images/sim.bmp', similarity_matrix)
