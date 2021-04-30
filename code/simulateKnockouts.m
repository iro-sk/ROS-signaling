%% Boolean Model running knockouts

%written by: Linnea and Julia
%date: 2020-04-16
%updated by iro @ 2021-04
%description: 
%   script to produce data for different ROS conditions: not present (0)
%and  present (1)
%   -crosstalk activities between pathways that can
%   manually be turned off and on
%   -knockouts can be simulated by providing name of component to turn off

%contains functions:
%   1. initialization
%   2. knockouts
%   3. reachSteadyState 
%       contains 4. activityConverter
%                5. saveTransitions
%                6. crosstalk
%                7. TFtargets
%                8. getRanks
%   9. plotActivity
%   10. plotTransitions
%   11. barPlot

%clear command window, close figures, clear variables
clc; 
close all;
clear;

%add path to functions
addpath ('Functions');

global ROS;

%% Initialize Model %%%

[Yap1pw, Sln1pw, Msnpw, Targets] = initialization ();

%% Produce data for different nutrient levels %%%

%manually change nutrient levels
ROS = [0 1]; %sequence of ROS concentration

%determine knockout sequence
knockouts = ["WT", "Yap1", "Snf1", "Msn"];

foldername = ['KO_ROS', num2str(ROS(2)),'/'];
path = ['../results/', foldername];
%path = ['Data/Validation/', foldername]; %for validation knockouts

%manually change crosstalks (0 turns off, 1 turns on -> when both
%crosstalks are off the models work as described. When crosstalk 1 turns on
%the Trx has been expressed and acts as a negative feedback for Yap1 ->
%the signaling pathway enters a feedback loop. Crosstalk 2 is turned off. When on it signifies the PKA negative
%regulation action. 
activeCrosstalk = [0 0]; 


%%

% loop over ROS levels and knockouts;

for i = 1:length(knockouts)
    
	ROSLevel = ROS(i);
       
    %create folders if they don't already exist
    mkdir(path,[num2str(i),'/'])
    mkdir(path, ['Transitions/',num2str(i),'/'])
    mkdir(path, 'Figures/')
    mkdir(path, 'Activity/')
    mkdir([path, 'Activity/'], ['Transitions/',num2str(i),'/'])
    
	disp(['ROS level: ', num2str(ROS(i))]);
    
    %run the boolean model to create txt files
    
    %create knockout (first after system has reached steady state for
    %inital conditions)
 

    [Yap1pw, Sln1pw, Msnpw, Targets] = initialization ();
    
    [Yap1pw, Sln1pw, Msnpw, Targets] = ...
        reachSteadyState2(i, Yap1pw, Sln1pw, Msnpw, Targets, ROS(1), path, activeCrosstalk);
    if i > 1
        [Yap1pw, Sln1pw, Msnpw, Targets] = knockout2(Yap1pw, Sln1pw, Msnpw, Targets, knockouts{1,i});        
    end
    
    [Yap1pw, Sln1pw, Msnpw, Targets] = ...
        reachSteadyState2(i,Yap1pw, Sln1pw, Msnpw, Targets, ROSLevel, path, activeCrosstalk);

end


%% Create Figures

% create array containing all pathways of interest

pathway = {dir([path, 'Activity/Transitions/1/' '*.txt']).name};

%loop over pathways
for i = 1:length(pathway)
    
    %create folder for figures
    mkdir([path, 'Figures/'], 'Transitions/')
    mkdir([path, 'Figures/'], 'Heatmaps/')
    mkdir([path, 'Figures/'], 'Change/')
    
    plotActivity2(pathway{i}, path, nutr, knockouts)
    %plotTransitions(pathway{i}, path)
    %barPlot(pathway{i}, path)
        
end