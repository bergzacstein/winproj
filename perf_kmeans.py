# -*- coding: utf-8 -*-

from skimage import io as skio
from skimage import color
import numpy as np
from sklearn.cluster import KMeans
from sklearn.preprocessing import MinMaxScaler

def import_file(filename):
    return skio.imread('im/' + filename, as_gray = False)

def apply_kmeans(ima, clusters_colors = [85, 170, 255]):
    """Performs a kmeans classification on the RGB image (ima).
    Value of k is the length of (clusters_colors).
    Returns an image with the correct colorization. """
    #k in the number of colors
    k = len(clusters_colors)

    imalab = color.rgb2lab(ima)
    X = imalab[:,:,1:3]
    #L = imalab[:,:,0]

    imalab_shapes = np.shape(imalab)
    dim_y, dim_x = np.shape(X)[0], np.shape(X)[1]

    # We reshape to have (numb. pixels, a, b)
    X_res = np.reshape(X, (dim_y*dim_x, 2))
    #L_res = np.reshape(L, (dim_y*dim_x, 1))

    # Scale to do clustering
    scaler = MinMaxScaler()
    scaler.fit(X_res)
    X_res = scaler.transform(X_res)

    # Applying k-means with the right number of clusters
    kmeans = KMeans(n_clusters = k, init = 'k-means++',
                        max_iter = 300, n_init = 10,
                        random_state = 0) # We use K-Means++ to avoid the trap
    y_kmeans = kmeans.fit_predict(X_res) #We use fir predict to get the cluster to which each instance belong
    
    #y_kmeans is a vector that contains all of our pixel values. 
    #We reshape it into a matrix. 
    output_X = np.copy(X_res)

    for cluster in range(max(y_kmeans) + 1):
        output_X[y_kmeans == cluster] = clusters_colors[cluster]

    output_X = np.delete(output_X, 1, 1)
    output_X = np.reshape(output_X, imalab_shapes[0:2])

    return output_X

