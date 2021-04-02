function[transTFAct] = TFtargets(transYap1pwpwAct, transSln1pwAct, transMsnpwAct)

%written by: Julia M�nch
%date: 02-12-07
%updated by iro @ 2021-03
%description: this function returns a single matrix containing the activity
%transitions of all transcription factors included in the boolean model
%arguments: 
%   1-3. matrices including the activity transitions of the Yap1, Sln1 and
%   Msn2/4 pathays
%returns: matrix with transitions of TF activity

TF = [string('Yap1'), string('Msn2'), string('Msn4'), string('Skn7')]';

%Change numbers below. to what ?
Yap1 = transYap1pwpwAct{15,(2:size(transYap1pwpwAct,2))};
Skn7 = transSln1pwAct{13,(2:size(transSln1pwAct,2))};
Msn2 = transMsnpwAct{15,(2:size(transMsnpwAct,2))};
Msn4 = transMsnpwAct{16,(2:size(transMsnpwAct,2))};

transTFAct = [Yap1; Msn2; Msn4; Skn7];
transTFAct = array2table([TF, transTFAct]);
transTFAct.Properties.VariableNames{1} = 'Name';
for i = 1:(width(transTFAct)-1)
    transTFAct.Properties.VariableNames{i+1} = ['act', num2str(i)];
end
end
