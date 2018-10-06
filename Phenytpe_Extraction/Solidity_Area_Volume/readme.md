##	SorghumPhenotyping1.m code description (26/09/2018):

This code involves a straightforward implementation of the functions contained within the image processing toolbox of MATLAB. As such, this code will only work in MATLAB with the image processing toolbox added. A precursor to running this code is the SorghumApp that is used crop the panicle from the lightbox image and the cropped images are stored, each in one subfolder. For this code to work there is a predefined directory structure in which the cropped images are to organized. There are three steps involved in the code:
	
	(1) Reading the cropped sorghum panicle image
	(2) Isolating the panicle from the blue background of light box
	(3) Extracting the phenotypes of interest from the isolated panicle and saving the data.

Elaboration of the code:
For step (1), the images should be stored as 'jpg' files and the filename should be prefixed with the word 'Panicle_'. Each image should be placed in a separate folder and all the folders should be collected into a master folder. The codes should be stored outside the master folder. The required codes are: 
	
	SorghumPhenotyping1.m and createMaskBlueBack.m
	
The latter is a function that is called from SorghumPhenotyping1.m; The directory structure and organization was based simply on the format of data received. Any user of MATLAB will find it easy to modify the code to suit other directory structures and file formats. 

In step (2), we convert the image from RGB to HSV color space so we can remove the blue background. The process of erosion and dilation is carried out to remove any spurious background pixels from the image.

In step (3) we calculate the various phenotypes of the isolated sorghum panicle such as its length, projected 2-D area, solidity, median and standard deviation of widths, hue and saturation information. Also the width of the panicle along its entire length is recorded for postprocessing. During the postprocessing the front view and side view images of the panicle are matched to obtain an approximate pixel volume of the panicle.

The phenotypic data are then written into the same folder as the panicle image.
