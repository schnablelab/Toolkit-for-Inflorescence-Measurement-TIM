#	Instruction

This code was implemented to find the length and width of the sorghum panicle from its image. The bottom of the image is considered as the starting point of the panicle. 

Before running the codes, please make sure the images are in either ‘.JPG’ or ‘.jpg’ formats. And a path of the directory stored the image should be provided.

The code that need to be customized is as follow:

	temp_path = ‘home/user/Desktop’;
	paniclePhenotype(temp_path);

So, the temp_path needs to be changed according to the directory where the images stored.

The main code is named as “paniclePhenotype” with following functions used in the feature extractions:

	“KnnRB” function is used to segment the original RGB images.
	“SkelToGraph” function is used to convert the skeleton image to the graph mode.
	“PanicleMainPath” function is used to calculate the boundary of the panicle and its path form the bottom to the top.

A a folder will be automatically created inside the input path to store the results images showing skeleton path plus one excel file containing the length and width extracted from all images in pixels.

For detailed information please check the supplemental methods for "Semi-Automated Feature Extraction from RGB Images for sorghum panicle architecture GWAS ".




