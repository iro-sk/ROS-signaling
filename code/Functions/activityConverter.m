function[transYap1pwAct, transSln1pwAct, transMsnpwAct, transTargetsAct] = ...
    activityConverter(Yap1pwOld, Sln1pwOld, MsnpwOld, TargetsOld, iteration,...
    transYap1pwAct, transSln1pwAct, transMsnpwAct, transTargetsAct)

%written by: Julia M�nch
%date: 2019-11-12
%updated by iro @ 2021-03
%description: this function converts each pathway component's vector
%   describing (1) presence, (2) phosphorylation (& oxidation) and (3) specific activation
%   into a binary value indicating the component's activity (0 = inactive,
%   1 = active) to enable better depiction via 'plotTransitions'
%arguments: 
%   1.-4. input values for each iteration in 'reachSteadyState' (Yap1pwOld, Sln1pwOld, MsnpwOld, TargetsOld
%   5. number of iteration
%   6.-10. matrix containing converted activities for each time step that is
%   extended after each iteration (transYap1pwAct, transSln1pwAct, transMsnpwAct, transTargetsAct)
%   11. path of folder containing data for specific ROS conditions
%returns: matrix for each pathway depicting the states of the components'
%   activity transitions; saves matrices as txt files in folder specified
%   under path

 
%% Yap1 %%
activity = zeros(height(Yap1pwOld), 1);
if Yap1pwOld{1,4} == 1 && Yap1pwOld{1,2} == 1
    activity(1) = 1;
end
if Yap1pwOld{2,4} == 1 && Yap1pwOld{2,2} == 1
    activity(2) = 1;
end
if Yap1pwOld{3,4} == 1 && Yap1pwOld{3,2} == 1
    activity(3) = 1;
end
if Yap1pwOld{4,4} == 1 && Yap1pwOld{4,2} == 1
    activity(4) = 1;
end
if Yap1pwOld{5,4} == 1 && Yap1pwOld{5,2} == 1
    activity(5) = 1;
end
if Yap1pwOld{6,2} == 1 && Yap1pwOld{6,4} == 1
    activity(6) = 1;
end

activity = table(activity);
activity.Properties.VariableNames{1} = ['act', num2str(iteration-1)];

if iteration == 1
    transYap1pwAct = [table(Yap1pwOld{:,1}), activity];
else
    transYap1pwAct = [transYap1pwAct, activity];
end

%% Sln1pw %%
activity = zeros(height(Sln1pwOld), 1);

if Sln1pwOld{1,2} == 1 && Sln1pwOld{1,4} == 1
    activity(1) = 1;
end
if Sln1pwOld{2,2} == 1 && Sln1pwOld{2,4} == 1
    activity(2) = 1;
end
if Sln1pwOld{3,2} == 1 && Sln1pwOld{3,4} == 1
    activity(3) = 1;
end

activity = table(activity);
activity.Properties.VariableNames{1} = ['act', num2str(iteration-1)];

if iteration == 1
    transSln1pwAct = [table(Sln1pwOld{:,1}), activity];
else
    transSln1pwAct = [transSln1pwAct, activity];
end

%% Msnpw %%
activity = zeros(height(MsnpwOld), 1);

if MsnpwOld{1,2} == 1 && MsnpwOld{1,4} == 1
    activity(1) = 1;
end
if MsnpwOld{2,2} == 1 && MsnpwOld{2,4} == 1
    activity(2) = 1;
end
if MsnpwOld{3,2} == 1 && MsnpwOld{3,4} == 1
    activity(3) = 1;
end


activity = table(activity);
activity.Properties.VariableNames{1} = ['act', num2str(iteration-1)];

if iteration == 1
    transMsnpwAct = [table(MsnpwOld{:,1}), activity];
else
    transMsnpwAct = [transMsnpwAct, activity];
end


%% Targets %% 
%no conversion necessary
if iteration == 1
    transTargetsAct = TargetsOld;
    transTargetsAct.Properties.VariableNames{2} = ['act', num2str(iteration-1)];
else
    append = table(TargetsOld{:,2});
    append.Properties.VariableNames{1} = ['act', num2str(iteration-1)];
    transTargetsAct = [transTargetsAct, append];
end

end


