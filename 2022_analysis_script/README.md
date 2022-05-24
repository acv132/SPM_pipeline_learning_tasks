
##### Starting 
Before running any matlab scripts, make sure to change the data paths in the ''utils\importPaths.m'' function

##### behavioral folder 
contains analysis scripts for behavioral data

##### fmri folder
contains analysis scripts for fmri data
	
##### Trouble-shooting advice
Parts of the code might not work properly if the directories of used data or resulting SPM files is changed between analysis steps, 
for instance when running the first-level analysis and then moving the resulting data to another directory or renaming a folder.
Those problems mainly arise due to the toolboxes used which are not equipped to handle this very well (or I was not willing to extend
my scripts to unneccessary lengths to catch this kind of error). Therefore, if you run into problems that are seemingly unsolvable,
it might help to delete some files and re-run previous analysis steps.