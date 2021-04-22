function [Yap1pw, Sln1pw, Msnpw, Targets] = ...
    knockout(Yap1pw, Sln1pw, Msnpw, Targets, knockouts)

%taken from group folder in dropbox, slightly modified
%date: 2021-04-14
%description: this function modifies each pathway's components by setting
%   the genes/proteins in knockouts to 0
%arguments:
%   1.-8. pathway tables to be changed (Yap1pw, Sln1pw, Msnpw, Targets)
%   9. knockouts = cell of strings with components that should be knocked
%   out
%returns: modified tables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% create knockouts %%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nKnockouts = length(knockouts);
 
for i = 1:nKnockouts
    proteinName = knockouts{i};
     
    % find position of protein in data files
    for j = {Yap1pw, Sln1pw, Msnpw, Targets}
        players = j{1}.Name;
        pos = find(proteinName == players, 1);
        if ~isempty(pos)
            break;
        end
    end
     
    % change presence/activity in corresponding table to 0
    if isequal(j{1},Metabolites)
        Metabolites{pos,2} = 0;
    elseif isequal(j{1},PKApw)
        PKApw{pos,2} = 0;
    elseif isequal(j{1},Snf1pw)
        Snf1pw{pos,2} = 0;
    elseif isequal(j{1},TORpw)
        TORpw{pos,2} = 0; 
    elseif isequal(j{1},Enzymes)
        Enzymes{pos,2} = 0; 
    elseif isequal(j{1},Targets)
        Targets{pos,2} = 0;
    end
end
 
end