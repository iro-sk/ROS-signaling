function [Yap1pw, Sln1pw, Msnpw, Targets] = ... 
crosstalk(Yap1pwOld, Sln1pwOld, MsnpwOld, TargetsOld,...
Yap1pw, Sln1pw, Msnpw, Targets, activeCrosstalk)

%written by: Julia M�nch
%date: 2019-11-18
%updated by iro @ 2021-04
%description: Function that defines crosstalks between pathway; depending
%   on state of crosstalks (0 off and 1 on), states of input's components are
%   changed and returned
%arguments: 
%   1.-4. Old pathway matrices (Yap1pwOld, Sln1pwOld, MsnpwOld,
%   TargetsOld) to refer to
%   5.-8. Actual pathway matrices to be changed (Yap1pw, Sln1pw, Msnpw, Targets)
%   9. vector containing which crosstalks should be turned on/off
%%returns: States of each pathways components that were modified according
%%to crosstalk activity

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Define crosstalks %%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% #1 %%
%active Trx negatively regulates Yap1 pathway (Izawa et al., 1999)
if activeCrosstalk(1) == 1 && TargetsOld{1,2} == 1 && MsnpwOld{1,4} == 1 && Yap1pwOld{6,2} == 1 && Yap1pwOld{5,4} == 1
    Yap1pw{6,4} = 0;
end


%% #2 %%
% active PKA negatively regulates Yap1, Msn and Sln1 pathways (Charizanis et al, 1999; Fernandes et al, 1997; Smith et al, 1998)⁠.
if activeCrosstalk(2) == 1 
    Yap1pw{6,4} = 0;
    Msnpw{2,4} = 0;
    Sln1pw{3,4} = 0;
end
%% #3 %%
%Snf1 that negatively regulates Msn, is involved in nutrient signaling
% if activeCrosstalk(3) == 1 && nutrientinputforactiveSnf1
% Msnpw{3,4} = 1;

%end




end







