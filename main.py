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

def score_windowness(sim_matrix, ceil = 0.95):
    """According to a similarity vector, return a windowness score.
    This score is high if the window was found several times on the same row. 
    The higher the value, the more likely it is to be a window. """
    peaks = sim_matrix[sim_matrix >= np.quantile(sim_matrix, ceil)]
    #Normalization
    peaks = (peaks - min(peaks))
    peaks = peaks / max(peaks)
    #Take 100 best values
    n = min(len(sim_matrix), 200)
    peaks = peaks[np.argsort(peaks)[-n:]]
    #A good number of windows on a row is between 
    score = np.sum(peaks) / len(peaks)
    return score

from perf_kmeans import *

import matchsel
import importlib
importlib.reload(matchsel)
from matchsel import *


image = skio.imread('img/telecom.jpeg')
#We apply k-means classification on the picture. 
clustered_image = apply_kmeans(image)
lazy_imshow(clustered_image)

#We look for similar windows for this selection, which is an actual window. 
selection = ((708, 393), (757, 529))
similarity_matrix = horizontal_match_selection(clustered_image, selection, sim=l2_sim)
print(score_windowness(similarity_matrix))

# On a random selection, we see that the score is lower. This is great !
stupid_selection = ((718, 1393), (757, 1529))
similarity_matrix = horizontal_match_selection(clustered_image, stupid_selection, sim=l2_sim)
print(score_windowness(similarity_matrix))

plt.plot(similarity_matrix)
plt.axhline(y=np.quantile(similarity_matrix, 0.95), color='r')
plt.show()





#selection = ((1412, 2572), (1722, 2784))
#selection = ((1380, 1380), (1550,1550))
#selection = ((1835, 758), (1897, 949))


#median filtering
#convolve with vertical [-1 0 1]

#im = im_grayscale
#im = scipy.signal.convolve2d(im, np.ones((10,10)))
#im = scipy.ndimage.filters.maximum_filter(im, 20)
#im = scipy.signal.medfilt(im)

#im = similarity_matrix
#im = scipy.ndimage.filters.maximum_filter(im, 10)



