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
        kernel = np.array([[1, 1, 1] ,[0, 0, 0] , [-1, -1, -1]])
    elif axis == 1: #Windows
        kernel = np.array([[-1 , 0 ,1], [-1 , 0 ,1], [-1 , 0 ,1]])
    im = scipy.signal.convolve2d(image, kernel)
    #Opening
    #kernel = np.ones((4,4),np.uint8)
    #im = cv2.morphologyEx(im, cv2.MORPH_OPEN, kernel)
    if wordy:
        lazy_imshow(im)
    #We project these gradient values on an axis by summing them.  
    #Counter-intuitively the axis argument in np.sum() is not the one you'd expect. 
    line_sum = np.sum(im, axis = 1-axis)
    return line_sum


def clean_projection(line, beta, wordy=False):
    """Juan's method of cleaning projected edges,
    using manual heuristics and moving average."""
    #line has a lot of noise on the leftmost and rightmost values. Remove them. 
    line[:40] = 0
    line[-40:] = 0
    #Line sum also has negative values. TRASH them.
    line = line[line >= 0]
    #This graph is still very spiky. To smoothen it, we compute a moving average. 
    line = np.convolve(line, np.ones((beta,))/beta, mode='valid')
    return line


def detect_peaks_nb(line, alpha=0.92):
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
    return openingx, sumx 


def juan_routine(image, alpha=0.92, beta=4, get_peaks=False, wordy=True):
    """Juan's routine to guesstimate the number of floors and windows of a building.
    Takes a clustered image as an input. Returns (nb_floors, nb_windows).
    alpha is selectivity. Higher alpha = less floors found.
    beta is the smoothening coefficient. Higher = less floors found. """
    # Compute projections of horizontal and vertical edges
    floors = project_edges(clustered_image, axis=0, wordy=wordy)
    windows = project_edges(clustered_image, axis=1, wordy=wordy)

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
    floors = clean_projection(floors, beta)
    windows = clean_projection(windows, beta)
    disp_wordy(floors, windows, alpha, wordy)
    
    if get_peaks:
        return floors, windows
    else:
        # Smartly find how many peaks are there. This depends on the alpha parameter.  
        # Finally, guess the number of windows and floors.
        nb_floors = sum(detect_peaks_nb(floors, alpha))
        nb_windows = sum(detect_peaks_nb(windows, alpha))*nb_floors # Assume that every floor has the same number of windows.
        return nb_floors, nb_windows


def detect_peaks_coordinates(line, alpha=0.92):
    """Given a lists of spiky value, keep only the spikes
    that are above quantile of (alpha), and then look for the index of the max of these spikes."""
    quantile = np.quantile(line, alpha)
    peaks_clusters = []
    temp_list = []
    last_value = 0
    for i, value in enumerate(line):
        if value >= quantile and last_value >= 0:
            temp_list.append((i,value))
        else:
            if temp_list != []:
                peaks_clusters.append(temp_list)
            temp_list = []
        last_value = value
    #peaks_cluster is now a list of lists, containing tuples (index, values)
    #For each sublist, we look for max(values) and return corresponding coordinate in the picture. 
    max_indexes = []
    for cluster in peaks_clusters:
        indexes, values = zip(*cluster)
        maximum = max(values)
        index = indexes[values.index(maximum)]
        max_indexes.append(index)
    return max_indexes


def score_windowness(line, ceil = 0.95):
    """According to a similarity vector, return a windowness score.
    This score is high if the window was found several times on the same row. 
    The higher the value, the more likely it is to be a window. """
    score = sum(detect_peaks_nb(line, ceil))
    return score


def get_boxes_and_scores(image, floors, windows, alpha, wordy=False):
    """Given an image and (floors, windows) as obtained through Juan's method,
    deduce from (floors, windows) several selection boxes that _could_ be windows. 
    Then count how many times do these selection boxes repeats itself on the horizontal axis."""
    floors_coords  = detect_peaks_coordinates(floors, alpha)
    windows_coords = detect_peaks_coordinates(windows, alpha)
    n = len(floors_coords) - 1
    m = len(windows_coords) - 1
    boxes_and_score = []
    for i in range(n): #iterate through floors
        for j in range(m): #iterate through windows
            topleft_x = windows_coords[j]
            topleft_y = floors_coords[i]
            bottomright_x = windows_coords[j+1]
            bottomright_y = floors_coords[i+1]
            selection = ((topleft_x, topleft_y), (bottomright_x, bottomright_y))
            similarity = horizontal_match_selection(image, selection)
            score = score_windowness(similarity)
            boxes_and_score.append((selection, score))
    boxes, scores = list(zip(*boxes_and_score))
    return boxes, scores


def guess_nb_floors(boxes, scores, delta=0.1, wordy=False):
    """delta : repetition sensibility"""
    ceil = np.quantile(scores, delta)
    assumed_windows = []
    topleft_x = []
    topleft_y = []
    bottomright_x = []
    bottomright_y = []
    for i, box in enumerate(boxes):
        score = scores[i]
        if score >= ceil:
            assumed_windows.append(box)
            topleft_x.append(box[0][0])
            topleft_y.append(box[0][1])
            bottomright_x.append(box[1][0])
            bottomright_y.append(box[1][1])
    topleft_x = np.array(topleft_x)
    topleft_y = np.array(topleft_y)
    bottomright_x = np.array(bottomright_x)
    bottomright_y = np.array(bottomright_y)
    # assumed_windows is a list of coordinates of what we think are windows. 
    # First, compute a quick and dirty estimate.
    building_size = max(bottomright_y) - min(topleft_y)
    window_sizes = np.abs(bottomright_y - topleft_y)
    quick_nb_floors = building_size / np.average(window_sizes)

    return quick_nb_floors
    

#Load a picture
image = skio.imread('img/telecom.jpeg')

### Matheu's routine
openingx, sumx = mateusz_routine(image)


### Juan's routine

# Compute the adaptative equalized histogram 
image_eq = skimage.exposure.equalize_adapthist(image, clip_limit=0.03)

#Apply k-means classification to the picture, with k=3
clustered_image = apply_kmeans(image_eq)
floors, windows = juan_routine(clustered_image, 0.92, 12, True, True)

### Nicolas' routine

boxes, scores = get_boxes_and_scores(image_eq, floors, windows, 0.92)
nb_floors = guess_nb_floors(boxes, scores, 0.1)
print('Number of floors : ', nb_floors)