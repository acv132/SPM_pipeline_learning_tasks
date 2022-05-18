function MedList = addMedicationList()
% addMedicationList adds the Med_List.txt file from data to be used in
% analyses
% $Author: A. Kasparbauer, A. Vorreuther

filename = '..\data\Med_List.txt';
delimiter = '\t';
startRow = 2;
formatSpec = '%f%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
dataArray(1) = cellfun(@(x) num2cell(x), dataArray(1), 'UniformOutput', false);
MedList = [dataArray{1:end-1}];
clearvars filename delimiter startRow formatSpec fileID dataArray ans;
end