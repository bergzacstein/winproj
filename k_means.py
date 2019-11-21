# -*- coding: utf-8 -*-
"""
Created on Wed Nov 20 10:22:05 2019

@author: jusugacadavid
"""
# -*- coding: utf-8 -*-
"""
Created on Fri Dec 28 15:30:20 2018

@author: jusugacadavid
"""


# Importing the libraries
import numpy as np
import matplotlib.pyplot as plt
plt.rcParams.update({'font.size': 22})
import pandas as pd
import numpy as np
import platform
import tempfile
import os
import matplotlib.pyplot as plt
from scipy import ndimage as ndi
# requires skimage package
from skimage import io as skio
from skimage import color
import skimage.feature as skf
from scipy import ndimage as ndi
import cv2
from sklearn.cluster import KMeans
from sklearn.preprocessing import MinMaxScaler
import scipy

plt.close('all')

# Importing the dataset
#ima = skio.imread('C:/Users/jusugacadavid/OneDrive/Thèse/Recherche/Athens - Image processing/Project/base/cmp_b0004.jpg', as_gray = False)
ima = skio.imread('C:/Users/jusugacadavid/OneDrive/Thèse/Recherche/Athens - Image processing/Project/telecom.jpeg', as_gray = False)

# Visualize the image
image = plt.figure("Original image")
plt.imshow(ima)
image.show()

# Image in L*a*b format (CIE)
imalab = color.rgb2lab(ima)


# Histogram
#histo = plt.figure("Histogram of original image")
#plt.hist(ima.reshape((-1,)),bins=255)
#histo.show()
# Creating the dataset


X = imalab[:,:,1:3]
L = imalab[:,:,0]

imalab_shapes = np.shape(imalab)

dim_y, dim_x = np.shape(X)[0], np.shape(X)[1]

# We reshape to have (numb. pixels, a, b)
X_res = np.reshape(X, (dim_y*dim_x, 2))
L_res = np.reshape(L, (dim_y*dim_x, 1))

# Scale to do clustering
scaler = MinMaxScaler()
scaler.fit(X_res)
X_res = scaler.transform(X_res)

# With first approach, do not use
#imalab_rec1 = np.zeros((dim_y*dim_x, 3))
#imalab_rec1[:][1] = L_res

# Applying k-means with the right number of clusters
kmeans = KMeans(n_clusters = 3, init = 'k-means++',
                    max_iter = 300, n_init = 10,
                    random_state = 0) # We use K-Means++ to avoid the trap
y_kmeans = kmeans.fit_predict(X_res) #We use fir predict to get the cluster to which each instance belong

# Visualizing the clusters
Cluster_graph = plt.figure("Clusters")
plt.scatter(X_res[y_kmeans == 0, 0], X_res[y_kmeans == 0, 1], s = 100, c = 'red', label = 'cluster 1')
plt.scatter(X_res[y_kmeans == 1, 0], X_res[y_kmeans == 1, 1], s = 100, c = 'blue', label = 'cluster 2')
plt.scatter(X_res[y_kmeans == 2, 0], X_res[y_kmeans == 2, 1], s = 100, c = 'green', label = 'cluster 3')
plt.scatter(X_res[y_kmeans == 3, 0], X_res[y_kmeans == 3, 1], s = 100, c = 'cyan', label = 'cluster 4')
#plt.scatter(X_res[y_kmeans == 4, 0], X_res[y_kmeans == 4, 1], s = 100, c = 'magenta', label = 'cluster 5')
plt.scatter(kmeans.cluster_centers_[:,0],kmeans.cluster_centers_[:,1], s = 300, c = 'black',marker = 'x', label = 'Centroids')
plt.title('Clusters')
plt.legend()
plt.show()

copy_X = np.copy(X_res)

# Second approach

# One pixel value per cluster


# 4 Clusters
#pixel_values = [63, 128, 191, 255]


# 3 Clusters
pixel_values = [85, 170, 255]

#Second_approach
for cluster in range(max(y_kmeans) + 1):
    copy_X[y_kmeans == cluster] = pixel_values[cluster]

# Use just one of the coordinates (just one necessary)
copy_X = np.delete(copy_X, 1, 1)

copy_X = np.reshape(copy_X, imalab_shapes[0:2])
Clustered_image = plt.figure("Clustered Image")
plt.imshow(copy_X)
image.show()
plt.savefig('C:/Users/jusugacadavid/OneDrive/Thèse/Recherche/Athens - Image processing/Project/hotwindow.jpg')

fft = np.fft.fft2(copy_X)
shiffted_fft = np.fft.fftshift(fft)

# Display the fourier transform centered on 0
fourier = plt.figure("Fourier Transform")
modfft=np.log(np.abs(np.fft.fftshift(np.fft.fft2(copy_X)))+0.1);
plt.imshow(modfft, cmap= "gray")
fourier.show()

# edges detection for floors (detect edges paralel to x)
image_edges_floors = plt.figure("Image floors")
im = scipy.signal.convolve2d(copy_X, np.array([[-1] ,[ 0] , [1]]))
plt.imshow(im, cmap = "gray")
image_edges_floors.show()

# column wise sum of values
floors_peaks = plt.figure("Image floors peaks")
line_sum_floors = (np.sum(im, axis = 1))**2
plt.plot(line_sum_floors)
floors_peaks.show()

# edges detection for windows (detects edges paralel to y)
image_edges_windows = plt.figure("image windows")
#im = scipy.signal.convolve2d(copy_X, np.array([[-1 , 0 ,1], [-1 , 0 ,1], [-1 , 0 ,1]]))
im = scipy.signal.convolve2d(copy_X, np.array([[-1 , 0 ,1]]))
plt.imshow(im, cmap = "gray")
image_edges_windows.show()

# row wise sum of values
windows_peaks = plt.figure("Image window peaks")
line_sum_windows = (np.sum(im, axis = 0))

plt.plot(line_sum_windows)
windows_peaks.show()




# EXECUTE THIS IF ELBOW METHOD WANTED
# Using the Elbow Method to find the number of Clusters

wcss = [] # Wcss is also called inertia
for i in range(1,11):
    kmeans = KMeans(n_clusters = i, init = 'k-means++',
                    max_iter = 300, n_init = 10,
                    random_state = 0) # We use K-Means++ to avoid the trap
    kmeans.fit(X_res)
    wcss.append(kmeans.inertia_)
Elbow = plt.figure("Elbow method")
plt.plot(range(1, 11), wcss)
plt.title('The Elbow Method')
plt.xlabel('Number of Clusters')
plt.ylabel('wcss')
plt.show()

