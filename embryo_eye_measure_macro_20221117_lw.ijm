// Macro to measure lobster embryo eyes

run("Clear Results"); // clear the results table of any previous measurements

// The next line prevents ImageJ from showing the processing steps during 
// processing of a large number of images, speeding up the macro
setBatchMode(true); 

// Show the user a dialog to select a directory of images
inputDirectory = getDirectory("Choose a Directory of Images");
outputfolder3 = getDirectory("Choose a Directory to Save ROIs");

// Get the list of files from that directory
// NOTE: if there are non-image files in this directory, it may cause the macro to crash
fileList = getFileList(inputDirectory);

for (i = 0; i < fileList.length; i++)
{
	if(endsWith(fileList[i], ".tif")) {
			processImage(fileList[i]);
	}
}



setBatchMode(false); // Now disable BatchMode since we are finished
updateResults();  // Update the results table so it shows the filenames

function processImage(imageFile)
{
    // Store the number of results before executing the commands,
    // so we can add the filename just to the new results
    prevNumResults = nResults;  
    
    open(imageFile);
    // Get the filename from the title of the image that's open for adding to the results table
    // We do this instead of using the imageFile parameter so that the
    // directory path is not included on the table
    filename = getTitle();
    minferetiner="150-Infinity";   
    roiManager("reset");
    run("Set Measurements...", "area feret's display redirect=None decimal=3");
    run("8-bit");
	run("Auto Local Threshold", "method=Phansalkar radius=600 parameter_1=0 parameter_2=0");
	run("Extended Particle Analyzer", "min_feret="+ minferetiner + " show=Outlines redirect=None keep=None display add exclude include");
    
    if (roiManager("Count") > 0){
    roiManager("Select", 0);
    roiManager("rename", filename);
    roiManager("Save", outputfolder3 + "ROI_lw_ " + filename + ".zip");
	}

    
    // Now loop through each of the new results, and add the filename to the "Filename" column
    for (row = prevNumResults; row < nResults; row++)
    {
        setResult("Filename", row, filename);
    }

    close("*");  // Closes all images
}