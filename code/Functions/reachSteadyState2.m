function [Yap1pw, Sln1pw, Msnpw, Targets] = ...
    reachSteadyState2(count, Yap1pwIn, Sln1pwIn, MsnpwIn, TargetsIn, ROSLevel, path, activeCrosstalk)

%written by: Julia M�nch
%data: 2019-10-31
%updated by iro @ 2021-04
%description: function to define the Boolean rules; loops over discrete time
%   steps until states do not change anymore; stop looping if steady state is
%   not reached after 100 interations; then find SS for next ROS
%   condition; states for inital condition before changing ROS condition, SS
%   for specific ROS condition and transitions from init to SS are
%   saved as txt files, activity transitions for each pathway tables are
%   saved as txt files, simulated gene ranks are saved as txt file
%input: 
%   1.-4. matrix representations of pathways at time = t
%   5. ROS level, changed when SS is reached for respective input
%   6. path of folder containing data for specific nutrient conditions 
%returns: matrix representations of pathways at time = t+1
%contains functions:
%   1. activityConverter (converts states in vector form into integer representing activity )
%   2. saveTransitions (saves transitions)
%   3. TFtargets (isolates transitions of TF activity from pathway tables)
%   4. getRanks (creates ranks for target genes)


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% set starting values %%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Yap1pw = Yap1pwIn;
Sln1pw = Sln1pwIn;
Msnpw = MsnpwIn;
Targets = TargetsIn;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% run until steady state is reached %%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iteration = 1;

while true
    
    %save old values for comparison
    Yap1pwOld = Yap1pw;
    Sln1pwOld = Sln1pw;
    MsnpwOld = Msnpw;
    TargetsOld = Targets;
    ROSLevelOld = ROSLevel;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% Yap1 pathway %%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Gpx3 part %%%

    %H2O2 Sensing and activation through oxidation of Gpx3 (Delaunay et al., 2002)
    if ROSLevelOld == 1 && Yap1pwOld{1,2} == 1
        Yap1pw{1,3} = 1;
    else
        Yap1pw{1,3} = 0;
    end

    if Yap1pwOld{1,3} == 1 
        Yap1pw{1,4} = 1;
    else
        Yap1pw{1,4} = 0;
    end
    
    %Ybp1 activation by H2O2 (Veal et al, 2003)
    if ROSLevelOld == 1 && Yap1pwOld{2,2} == 1
        Yap1pw{2,4} = 1;
    else
        Yap1pw{2,4} = 0;
    end

    %Yap1 is oxidized by Ybp1 and Gpx3 (Delaunay et al, 2002; Veal et al,
    %2003), Crm1 is deactivated (Kuge et al, 1998)
    if Yap1pwOld{2,4} == 1 && Yap1pwOld{1,4} == 1 && Yap1pwOld{6,2} == 1
        Yap1pw{6,3} = 1;
        Yap1pw{4,4} = 0;
    else
        Yap1pw{6,3} = 0;
        Yap1pw{4,4} = 1;
    end


    %Oxidized Yap1 is transfered to the nucleus by Pse1, where it is activated (Isoyama et al, 2001)
    if Yap1pwOld{6,3} == 1 && Yap1pwOld{4,4} == 0 && Yap1pwOld{3,2} == 1 && Yap1pwOld{3,2} == 1
        Yap1pw{3,4} = 1;
    else
        Yap1pw{3,4} = 0;
    end
    
    if Yap1pwOld{3,4} == 1
        Yap1pw{6,4} = 1;
    else
        Yap1pw{6,4} = 0;
    end
    
    %active Yap1 induces Trx transcription (Izawa et al, 1999), same for
    %Gsh1, Glr1 and Trr1. (Grant et al, 1996; Toone et al, 2001; Lee et al,
    %1999) 
    if Yap1pwOld{6,4} == 1
        Targets{1,2} = 1;
        Targets{4,2} = 1;
        Targets{5,2} = 1;
        Targets{6,2} = 1;
    else
        Targets{1,2} = 0;
        Targets{4,2} = 0;
        Targets{5,2} = 0;
        Targets{6,2} = 0;
    end
    
    %Trx is expressed and appears in the Yap1 pathway (no reference, just
    %logical)
    if TargetsOld{1,2} == 1
        Yap1pw{5,4} = 1;
    else
        Yap1pw{5,4} = 0;
    end
      
    %% Sln1 pathway 
    
    %Sln1 phosphorylation under oxidative stress
    
    if ROSLevelOld == 1 && Sln1pwOld{1,2} == 1
        Sln1pw{1,3} = 1;
    else
        Sln1pw{1,3} = 0;
    end
    
    %Sln1 gets activated by phosphorylation
    if Sln1pwOld{1,3} == 1
        Sln1pw{1,4} = 1;
    else
        Sln1pw{1,4} = 0;
    end
        
    %Ypd1 gets phosphorylated
    if Sln1pwOld{1,4} == 1 && Sln1pwOld{2,2} == 1
        Sln1pw{2,3} = 1;
    else
        Sln1pw{2,3} = 0;
    end
    
    %Ypd1 get active by phosphorylation
    if Sln1pwOld{2,3} == 1
        Sln1pw{2,4} = 1;
    else
        Sln1pw{2,4} = 0;
    end
    
    %same for Skn7
    if Sln1pwOld{2,4} == 1 && Sln1pw{3,2} == 1
        Sln1pw{3,3} = 1;
    else
        Sln1pw{3,3} = 0;
    end
    
    if Sln1pwOld{3,3} == 1
        Sln1pw{3,4} = 1;
    else
        Sln1pw{3,4} = 0;
    end
    
    %when Skn7 is activated Ola1 is expressed (ref)
    if Sln1pwOld{3,4} == 1
        Targets{3,2} = 1;
    else
        Targets{3,2} = 0;
    end
    
    %additional comment on Msnpw: Snf1 appears here but is not used. The
    %purpose of this is to be available for a later use, as an input from
    %the nutrient pathway which can be added as a crosstalk point.
    
    
    %% Msn2/4 pathway %% 
    
    % Trx acts as a H2O2 sensor and turns into its active, reduced form (Boisnard et al, 2009)
    if ROSLevelOld == 1 && MsnpwOld{1,2} == 1
        Msnpw{1,4} = 1;
    else
        Msnpw{1,4} = 0;
    end
    
    
    % active Trx mediates nuclear transport of Msn2/4 transcription factor
    % (Boisnard et al, 2009) (Snf1 is inactive)
    if MsnpwOld{1,4} == 1 && MsnpwOld{2,3} == 1 && MsnpwOld{2,2} == 1
        Msnpw{2,4} = 1;
    else
        Msnpw{2,4} = 0;
    end
    
    %Snf1 inhibits nuclear transport of Msn2/4 by dephosphorylation (De Wever et al, 2005)⁠ 
    if MsnpwOld{3,4} == 1
        Msnpw{2,3} = 0;
    else
        Msnpw{2,3} = 1;
    end
    
    %include crosstalk
    [Yap1pw, Sln1pw, Msnpw, Targets] = ...
        crosstalk(Yap1pwOld, Sln1pwOld, MsnpwOld, TargetsOld,...
        Yap1pw, Sln1pw, Msnpw, Targets, activeCrosstalk);
    
    %% create table for transcription factors
        
    
    %% convert modifications into activity
    if iteration == 1
        transYap1pwAct = [];
        transMsnpwAct = [];
        transSln1pwAct = [];
        transTargetsAct = [];
    end
    
    [transYap1pwAct, transSln1pwAct,  transMsnpwAct, transTargetsAct] = ...
        activityConverter(Yap1pwOld, Sln1pwOld, MsnpwOld, TargetsOld, iteration,...
        transYap1pwAct, transSln1pwAct, transMsnpwAct, transTargetsAct);
    
    
    %% save initial conditions and...
    if (iteration == 1)
        writetable(Yap1pwOld, [path, 'Yap1pw_init.txt'], 'Delimiter', '\t');
        writetable(Sln1pwOld, [path, 'Sln1pw_init.txt'], 'Delimiter', '\t');
        writetable(MsnpwOld, [path, 'Msnpw_init.txt'], 'Delimiter', '\t');
        writetable(TargetsOld, [path, 'Targets_init.txt'], 'Delimiter', '\t');
        writematrix(ROSLevelOld, [path, 'ROS_init.txt'], 'Delimiter', '\t');
    % ...create file that contains transitions (is extended after each iteration)
        transYap1pw = Yap1pwOld;
        transSln1pw = Sln1pwOld;
        transMsnpw = MsnpwOld;
        transTargets = TargetsOld;
        transitions = {transYap1pw, transSln1pw, transMsnpw, transTargets};
        transNames = {'transYap1pw', 'transSln1pw', 'transMsnpw', 'transTargets'};
    end
    
    [transitions] = saveTransitions(iteration, Yap1pwOld, Sln1pwOld, MsnpwOld, TargetsOld, transitions);
   
       
    %% if states do not change anymore, steady state is reached -> break the loop
    
    if isequal(ROSLevelOld, ROSLevel) && isequal(Yap1pwOld, Yap1pw) && ...
            isequal(Sln1pwOld, Sln1pw) && isequal(MsnpwOld, Msnpw) &&...
            isequal(TargetsOld, Targets)
        disp('You have reached a steady state! :)');
        break;
    else
        disp(['Iteration ', num2str(iteration), ' completed!']);
    end
    
    %% stop simulation if steady state is not reached after 100 iterations
    
    if (iteration == 100)
        disp('Steady state could not be reached. Process aborted.')
        break;
    end
    
    iteration = iteration + 1;
        
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% readout %%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%save results in SS for new nutrient conditions
writematrix(num2str(ROSLevel), [path, 'ROS_SS.txt'], 'Delimiter', '\t');
writetable(Yap1pw, [path, 'Yap1pw_SS.txt'], 'Delimiter', '\t');
writetable(Sln1pw, [path, 'Sln1pw_SS.txt'], 'Delimiter', '\t');
writetable(Msnpw, [path, 'Msnpw_SS.txt'], 'Delimiter', '\t');
writetable(Targets, [path, 'Targets_SS.txt'], 'Delimiter', '\t');

%save files that contain transitions
for i = 1:length(transitions)
    writetable(transitions{i}, [path, 'Transitions/', transNames{i}, '.txt'], 'Delimiter', '\t');
end

%save files that contain activity transitions
writetable(transYap1pwAct, [path, 'Activity/Transitions/', 'transYap1pw.txt'], 'Delimiter', '\t');
writetable(transMsnpwAct, [path, 'Activity/Transitions/', 'transMsnpw.txt'], 'Delimiter', '\t');
writetable(transSln1pwAct, [path, 'Activity/Transitions/', 'transSln1pw.txt'], 'Delimiter', '\t');

writetable(transTargetsAct, [path, 'Activity/Transitions/', 'transTargets.txt'], 'Delimiter', '\t');

%create file with transitions of TF factors
%[transTFAct] = TFtargets(transMsnpwAct, transSln1pwAct, transYap1pwAct);
%writetable(transTFAct, [path, 'Activity/Transitions/', 'transTF.txt'], 'Delimiter', '\t');

%create files with regulated genes
%load('../Combined/reduced_ecYeast_batch.mat');
%model = ecModel_batch;
%[ranks] = getRanks(transTFAct);
%writetable(ranks, [path, 'enzRanks.txt'], 'Delimiter', '\t');
end
