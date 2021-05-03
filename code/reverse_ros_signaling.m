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

foldername = ['ROS', num2str(ROS(2)), '-ROS', num2str(ROS(1)),'/'];
path = ['../results/', foldername];

%manually change crosstalks (0 turns off, 1 turns on -> when both
%crosstalks are off the models work as described. When crosstalk 1 turns on
%the Trx has been expressed and acts as a negative feedback for Yap1 ->
%the signaling pathway enters a feedback loop. Crosstalk 2 is turned off. When on it signifies the PKA negative
%regulation action. 
activeCrosstalk = [0 0]; 

%path = ['Data/Validation/', foldername]; for validation knockouts

%%

% loop over ROS levels;

for i = length(ROS):-1:1
    
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
        reachSteadyState(Yap1pw, Sln1pw, Msnpw, Targets, ROSLevel, path, activeCrosstalk);

    
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
