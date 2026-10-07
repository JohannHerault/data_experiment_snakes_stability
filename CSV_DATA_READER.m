%% ============================================================
% CSV DATA READER ((Compatible with MATLAB veersion past 2014)
%
% This script reads CSV files generated from MATLAB .fig files.
%
% Expected CSV format:
%
%   Series,Type,X,Y
%
% Example:
%
%   1,errorbar,0.3,61.260048
%   1,errorbar,0.4,85.123456
%   1,errorbar,0.5,104.567890
%   2,errorbar,0.5,52.861008
%
%% ============================================================

clear all;
close all;
clc;


%% ============================================================
% SELECT CSV FILE
%% ============================================================

[fileName, filePath] = uigetfile( ...
    '*.csv', ...
    'Select CSV file');

if isequal(fileName, 0)

    fprintf('No file selected.\n');

    return;

end


csvFile = fullfile(filePath, fileName);


%% ============================================================
% OPEN CSV FILE
%% ============================================================

fid = fopen(csvFile, 'r');

if fid == -1

    error('Unable to open the CSV file.');

end


%% ============================================================
% READ HEADER
%% ============================================================

header = fgetl(fid);

fprintf('\n');
fprintf('============================================\n');
fprintf('CSV DATA READER\n');
fprintf('============================================\n');

fprintf('File: %s\n', csvFile);
fprintf('Header: %s\n\n', header);


%% ============================================================
% READ DATA
%% ============================================================

data = textscan(fid, ...
    '%f%s%f%f', ...
    'Delimiter', ',');

fclose(fid);


%% ============================================================
% STORE DATA
%% ============================================================

Series = data{1};
Type   = data{2};
X      = data{3};
Y      = data{4};


%% ============================================================
% CHECK DATA
%% ============================================================

if isempty(X)

    error('The CSV file contains no data.');

end


fprintf('Total number of points: %d\n', length(X));


%% ============================================================
% FIND INDIVIDUAL SERIES
%% ============================================================

seriesNumbers = unique(Series);

fprintf('Number of series: %d\n\n', ...
    length(seriesNumbers));


%% ============================================================
% CREATE FIGURE
%% ============================================================

figure;

hold on;

grid on;


%% ============================================================
% PLOT DATA
%% ============================================================

legendText = cell(length(seriesNumbers),1);


for i = 1:length(seriesNumbers)

    % Current series number
    seriesID = seriesNumbers(i);

    % Select current series
    index = (Series == seriesID);

    x = X(index);
    y = Y(index);

    currentType = Type{find(index,1)};


    %% --------------------------------------------------------
    % ERRORBAR DATA
    %% --------------------------------------------------------

    if strcmp(currentType, 'errorbar')

        plot(x, y, '-o');

        legendText{i} = ...
            ['Series ' num2str(seriesID) ' (errorbar)'];


    %% --------------------------------------------------------
    % LINE DATA
    %% --------------------------------------------------------

    elseif strcmp(currentType, 'line')

        plot(x, y, '-');

        legendText{i} = ...
            ['Series ' num2str(seriesID) ' (line)'];


    %% --------------------------------------------------------
    % OTHER DATA
    %% --------------------------------------------------------

    else

        plot(x, y, 'o');

        legendText{i} = ...
            ['Series ' num2str(seriesID)];

    end

end


%% ============================================================
% FORMAT FIGURE
%% ============================================================

hold off;

xlabel('X');

ylabel('Y');

title(['Data from ' fileName], ...
    'Interpreter', 'none');

legend(legendText);

grid on;


%% ============================================================
% DISPLAY SERIES INFORMATION
%% ============================================================

fprintf('\n');
fprintf('--------------------------------------------\n');
fprintf('SERIES INFORMATION\n');
fprintf('--------------------------------------------\n');

for i = 1:length(seriesNumbers)

    seriesID = seriesNumbers(i);

    index = (Series == seriesID);

    nPoints = sum(index);

    currentType = Type{find(index,1)};

    fprintf('Series %d : %d points (%s)\n', ...
        seriesID, ...
        nPoints, ...
        currentType);

end


%% ============================================================
% VARIABLES AVAILABLE IN MATLAB
%% ============================================================
%
% After running this script, the following variables are
% available in the MATLAB workspace:
%
%   Series
%   Type
%   X
%   Y
%
% Example:
%
%   index = (Series == 1);
%
%   x1 = X(index);
%   y1 = Y(index);
%
%   plot(x1,y1,'o-');
%
%% ============================================================

fprintf('\n');
fprintf('CSV file successfully loaded.\n');
fprintf('Variables available: Series, Type, X, Y\n');
fprintf('============================================\n'); 