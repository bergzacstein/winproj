# -*- coding: utf-8 -*-

import numpy as np
import skimage, scipy
from utils import *
import matplotlib.pyplot as plt
import skimage.morphology as morpho
import cv2
from perf_kmeans import *
from matchsel import *

#Sets current working directory
#import os
#cdir_path = os.path.dirname(os.path.realpath(__file__))
#Change dir_path to another folder if your image files are somewhere else
#os.chdir(dir_path)

def lazy_fft(x):
    """Returns the Fourier transform of an image."""
    return np.log(np.abs(np.fft.fftshift(np.fft.fft2(x))))


def lazy_imshow(image, grey=True, title=None):
    """A shortcut to quickly show a picture in greyscale using matplot lib. """
    if grey: 
        plt.imshow(image, cmap='gray')
    else: 
        plt.imshow(image)
    if title:
        plt.title(title)
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


def h_edges(im_rvb):
    """Magic function by Mateusz which returns a highly contrasted
    image with the horizontal edges."""
    try:
        gray_im = cv2.cvtColor(im_rvb, cv2.COLOR_BGR2GRAY)
        image_eq = cv2.equalizeHist(gray_im)
    except:
        image_eq = im_rvb
    #Equalize histogram
    
    #Gradient approximation.  
    k = np.array([[1, 1, 1], [0, 0, 0], [-1, -1, -1]])
    im = cv2.filter2D(image_eq, -1, k)
    return im


def project_edges(image, axis=0, wordy=False):
    """Juan's method to project edges.
    (image) is a k-means clustered image. """
    #Approximate the horizontal or vertical gradient using linear filtering. 
    if axis == 0: #Floors
        kernel = np.array([[-1] ,[ 0] , [1]])
    elif axis == 1: #Windows
        kernel = np.array([[-1 , 0 ,1], [-1 , 0 ,1], [-1 , 0 ,1]])
    im = scipy.signal.convolve2d(image, kernel)
    if wordy:
        lazy_imshow(im)
    #We project these gradient values on an axis by summing them.  
    #Counter-intuitively the axis argument in np.sum() is not the one you'd expect. 
    line_sum = np.sum(im, axis = 1-axis)
    return line_sum


def clean_projection(line, wordy=False):
    """Juan's method of cleaning projected edges,
    using manual heuristics and moving average."""
    #line has a lot of noise on the leftmost and rightmost values. Remove them. 
    line[:10] = 0
    line[-10:] = 0
    #Line sum also has negative values. TRASH them.
    line = line[line >= 0]
    #This graph is still very spiky. To smoothen it, we compute a moving average. 
    line = np.convolve(line, np.ones((5,))/5, mode='valid')
    return line


def detect_peaks(line, alpha=0.92):
    """Juan's method of detecting peaks in a line.
    If 0 is the road, and a value over quantile (alpha) is a bump, 
    we just count the number of bumps in the road."""
    quantile = np.quantile(line, alpha)
    peaks = []
    last_value = 0
    for value in line:
        if value >= quantile and last_value < quantile:
            peaks.append(1)
        else:
            peaks.append(0)
        last_value = value
    return peaks


def mateusz_routine(image, wordy=True):
    """Black magic."""
    #Compute the gradient on the image with normalized histogram
    gradient = h_edges(image)
    if wordy: lazy_imshow(gradient)
    #Do an opening
    kernel = np.ones((5,5),np.uint8)
    openingx = cv2.morphologyEx(gradient, cv2.MORPH_OPEN, kernel)
    if wordy: lazy_imshow(openingx)
    sumx = openingx.sum(axis=1)
    return sumx 


def juan_routine(image, alpha=0.92, wordy=True):
    """Juan's routine to guesstimate the number of floors and windows of a building.
    Takes a clustered image as an input. Returns (nb_floors, nb_windows).
    alpha is selectivity. Higher alpha = less floors found."""
    # Compute projections of horizontal and vertical edges
    floors = project_edges(clustered_image, axis=0, wordy=True)
    windows = project_edges(clustered_image, axis=1, wordy=True)

    def disp_wordy(floors, windows, alpha, wordy):
        """Used in juan_routine() to display graphs."""
        if wordy:
            for i, (title, line) in enumerate([('Floors', floors), ('Windows', windows)]):
                quantile = np.quantile(line, alpha)
                plt.plot(line)
                plt.axhline(y = quantile, color = 'r')
                plt.title(title)
                plt.show()

    disp_wordy(floors, windows, alpha, wordy)

    # Clean those projections.
    floors = clean_projection(floors)
    windows = clean_projection(windows)
    disp_wordy(floors, windows, alpha, wordy)
    
    # Smartly find how many peaks are there. This depends on the alpha parameter.  
    floors = detect_peaks(floors, alpha)
    windows = detect_peaks(windows, alpha)
    
    # Finally, guess the number of windows and floors.
    nb_floors = sum(floors)
    nb_windows = sum(floors)*sum(windows) # Assume that every floor has the same number of windows.
    return nb_floors, nb_windows


def nicolas_routine(wordy=True):
    """Demonstrates how windowness works.
    Picks one selection and looks for similar patterns on the same line."""
    image = skio.imread('img/telecom.jpeg')
    #We look for similar windows for this selection, which is an actual window. 
    selection = ((708, 393), (757, 529))
    sim = horizontal_match_selection(clustered_image, selection, sim=l2_sim)
    print(score_windowness(sim))

    # On a random selection, we see that the score is lower. This is great !
    stupid_selection = ((718, 1393), (757, 1529))
    similarity_matrix = horizontal_match_selection(clustered_image, stupid_selection, sim=l2_sim)
    print(score_windowness(similarity_matrix))
    

#Load a picture
image = skio.imread('img/telecom.jpeg')

### Matheu's routine
mateusz_routine(image)

### Nicolas' routine
nicolas_routine()

### Juan's routine

# Compute the adaptative equalized histogram 
image_eq = skimage.exposure.equalize_adapthist(image, clip_limit=0.03)
#Apply k-means classification to the picture, with k=3
clustered_image = apply_kmeans(image_eq)
juan_routine(clustered_image, 0.92, True)
