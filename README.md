# MIA

MIA is a software tool for metabolomics image analysis. These images are typically phase constrast miscroscopy (PCM) images, because fluorescent agents may contaminate the cell extracts which will be used for further quantitative analysis.

![mia](https://user-images.githubusercontent.com/15344717/34085315-56d420fc-e354-11e7-9700-9d3236fab3f2.jpg)

## Installation

MIA is developed under MATLAB, and is packaged using MATLAB compiler. Similar to Java application, the software tool requires installation of MATLAB Compiler Runtime (MCR), which is included in the package. Double-clicking "MyAppInstaller_web.exe" will initialize the installation. After installation of MCR is complete, one can use MIA as an executable.  

## Tutorial

As an executable with graphic user interface, MIA is very easy to use. The workflow is illustrated by the following steps. Although buttons need to be clicked, the workflow is automatic as no parameter input is required in addition to image file selection. The software is designed this way so one is aware of what MIA is doing and can make sure everything is done in a satisfactory manner. 

1) Cell Culture popup menu allows one to choose cell culture type, and Worker Option popup menu allows the users to decide whether Step 6 is performed in a single worker or in parallel. 

2) The Current Directory lists all files in current directory. If the current directory is where the images of interest are stored, then Step 1 can be skipped. Otherwise, click "Step 1 Image Folder" to browse the image folder. 

3) Now the current directory is showing all the image files of interest. One can click on each file to preview the image. The highlighted (clicked) image file will be chosen as reference image in this step. Reference image is used to preview the processing result and calculate the filter radius and disk radius for all files in the folder, typically from the same sample. Circle Radius has a default value of 11, and can be adjusted to capture the bright cells. Since bright cells take up a small portion of the total count, the choice of this value does not noticeably affect the total count. For large images, one can crop the image with a margin size defined in Crop Size text box. 

4) (Adherent Cells Only) Step 3 analyzes bright mitotic cells in the image. The analyzed image is shown in the preview window. 

5) (Adherent Cells Only) Step 4 calculates filter radius and disk radius for dark cell detection in the reference image, which will be used for other images in the folder to save computation time. 

6) (Adherent Cells Only) Step 5 analyzes the dark resting cells in reference image. The analyzed image is shown in the preview windows. The analysis result is shown in the table below the preview window.  

7) Step 6 analyzes all images in the folder. The processed image is shown in the preview window as well. The locations of the cells are automatically saved in spreadsheets. Users can also save one image of interest by clicking on the save button at the top-left corner. At any step, users can change the crop size to be able to switch from fast computation to accurate calculation. 

More detailed tutorial and examples can be found in Tutorial.pdf. 

## Example

Here an example of using MIA to process two adherent cell images is shown. The example images are also included with the package. We use the default options in the popup menus. In Step 1, we change the image folder to “adherent_test” (choosing this folder instead of clicking on the folder). The two TIFF files will show in current directory. In Step 2, we click on either image, the preview window on the right of the tool will show the image. In Step 3, we analyze the bright mitotic cells in the image. The analysis is dependent on Circle Radius and Crop Size, which are automatically defined in Step 2. However, one can adjust these two values. Here we use 300 as crop size to expedite the process for illustration purposes. In Step 4, we need to calculate the two parameters from the reference image. This will take some time, but is not always required. One can directly type input values into the two text boxes. The values will be used in Step 5 and 6. Using the radii calculated from Step 4, we are able to get the processed reference image after clicking Step 5.  In Step 6, we process all images in the folder. Users can also save one image of interest by clicking on the save button at the top-left corner. The image will automatically be save into the current folder with JPEG format. 

## Notes

MIA is designed for on-focus images that were taken in normal light condition. However, some users have reported tjat MIA also applies to blurred or distorted images if one changes the two radii parameters based on experience. This can be done by directly type values into the two text boxes, though it is not recommended. 

## References
1. Du, D. et al, Bioinformatics, submitted
