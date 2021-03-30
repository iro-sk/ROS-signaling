% boolean model on ROS signaling
% ROS in H2O2 form present (1) and absent (0)

%clear command window, close figures, clear variables
clc; 
close all;
clear;

%add path to functions
addpath ('Functions');

global ROS;

%% Initialize Model %%%

[Yap1pw, Sln1pw, Msnpw, Targets] = initialization ();

%manually change nutrient levels
ROS = [0 1]; %sequence of ROS concentration

%determine knockout
%knockouts = {};

foldername = ['ROS', num2str(ROS(1)), '-ROS', num2str(ROS(2)),'/'];
path = ['../results/', foldername];

% something with the crosstalks here? what are the crosstalks?
%path = ['Data/Validation/', foldername]; for validation knockouts

%%

% loop over ROS levels;

for i = 1:length(ROS)
    
	ROSLevel = ROS(i);


	%create folders if they don't already exist
	mkdir(path)
	mkdir(path, 'Transitions/')
	mkdir(path, 'Figures/')
	mkdir(path, 'Activity/')
	mkdir([path, 'Activity/'], 'Transitions/')

	disp(['ROS level: ', num2str(ROS(i))]);

	%run the boolean model to create txt files
	%create knockout (first after system has reached steady state for inital conditions)
%    if i > 1 
%		[Yap1pw, Sln1pw, Msnpw, Targets] = knockout(Yap1pw, Sln1pw, Msnpw, Targets, knockouts);
%    end
        [ROSLevel, Yap1pw, Sln1pw, Msnpw, Targets] = ...
        reachSteadyState(Yap1pw, Sln1pw, Msnpw, Targets, ROSLevel, path);

    
end

%% Create Figures

% create array containing all pathways of interest

pathway = {dir([path, 'Activity/Transitions/' '*.txt']).name};
%loop over pathways
for i = 1:length(pathway)
    
    %create folder for figures
    mkdir([path, 'Figures/'], 'Transitions/')
    mkdir([path, 'Figures/'], 'Heatmaps/')
    mkdir([path, 'Figures/'], 'Change/')
    
    plotActivity(pathway{i}, path, ROS)
    plotTransitions(pathway{i}, path)
    barPlot(pathway{i}, path)
        
end





