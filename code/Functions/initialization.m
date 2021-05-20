function [Yap1pw, Sln1pw, Msnpw, Targets] = initialization ()
%updated by iro @ 2020-03
%description: function to define the pathways and respective components 
%and set the initial condition for a Boolean Network including
%   (1) Target Genes
%   (2) Yap1 pathway
%   (3) Sln1 pathway
%   (4) Msn2/4 pathway
%returns: matrix representation of each pathway 
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% components and initial values %%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% Target genes %%
Name = ["TRX", "DNM1", "OLA1", "GSH1", "GLR1", "TRR1", "CTT1"]';
activity = zeros(length(Name),1);
Targets = table(Name, activity);


%%% Yap1pw %%%
Name = ["Gpx3", "Ybp1", "Pse1", "Crm1", "Trx1", "Yap1"]';
presence = ones(length(Name), 1);
phosphorylationORoxidation = zeros(length(Name),1);
spec_activation = zeros(length(Name),1);
Yap1pw = table(Name, presence, phosphorylationORoxidation, spec_activation);
Yap1pw{4,4} = 1; %Crm1 is always active
%Yap1pw{5,2} = 0; %Trx is not there yet

 
%%% Sln1pw %%%
Name = ["Sln1", "Ypd1", "Skn7"]';
presence = ones(length(Name), 1);
phosphorylationORoxidation = zeros(length(Name),1);
spec_activation = zeros(length(Name),1);
Sln1pw = table(Name, presence, phosphorylationORoxidation, spec_activation);


%%% Msnpw %%% 
Name = ["Trx", "Msn", "Snf1"]';
presence = ones(length(Name), 1);
phosphorylationORoxidation = zeros(length(Name),1);
spec_activation = zeros(length(Name),1);
Msnpw = table(Name, presence, phosphorylationORoxidation, spec_activation);
Msnpw{2,3} = 1; %Msn2/4 is phosphorylated
%Msnpw{3,4} = 1; % to switch on Snf1 switch
end