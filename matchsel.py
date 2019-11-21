import numpy as np

def exp_sim(A,B):
    """Compares A to B (model) using exponentials"""
    m = np.exp(-np.linalg.norm(B-A)) / np.exp(-np.linalg.norm(B))
    return m 

def l2_sim(A,B):
    """Compares A to B (model) """
    return np.linalg.norm(B-A, -2)/np.linalg.norm(B, 2)

def cov_sim(A,B):
    return np.corrcoef()

def horizontal_match_selection(image, selection, step=1, sim=l2_sim):
    """Given an image and a selection, look for 
    image : a numpy array corresponding to a picture.
    selection : ((topleft_x, topleft_y), (bottomright_x, bottoomright_y))"""
    selection_im = image[selection[0][1]:selection[1][1]+1, 
                         selection[0][0]:selection[1][0]+1]
    selection_width = selection_im.shape[1]
    selection_height = selection_im.shape[0]
    line = selection[0][1]
    begin = 0
    end = image.shape[1] - selection_width
    similarities = np.zeros((end-begin+1,))
    similarity = 0
    for row in range(begin, end):
        if row % step == 0: #Every (step), we compute the similarity. Otherwise, propagated. 
            sub_selection_im = image[line : line + selection_height ,
                                    row   : row  + selection_width ]
            similarity = sim(sub_selection_im, selection_im )
        similarities[row-begin] = similarity
    return similarities

def match_selection(image, selection, step = 4, sim = l2_sim):
    """image : a numpy array corresponding to a picture.
    selection : ((topleft_x, topleft_y), (bottomright_x, bottoomright_y))"""
    #selection_im is the part of the image corresponding to the coordinate selection. 
    selection_im = image[selection[0][1]:selection[1][1], selection[0][0]:selection[1][0]]
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
            subsection = image[i:i+selection_height, j:j+selection_width]
            sub_selection_im = selection_im#[0:subsection.shape[0], 0:subsection.shape[1]]
            # We score the similarity between subsection and selection_im.
            # This can be done using various measures.
            similarity = sim(subsection, sub_selection_im)
            try:
                # instead of creating a smaller image
                # add a square of color similarity and of shape selection_im to
                # a big picture
                similarity_matrix[int(i/step), int(j/step)] = similarity
            except:
                print(i/step,j/step)
    
    return similarity_matrix

