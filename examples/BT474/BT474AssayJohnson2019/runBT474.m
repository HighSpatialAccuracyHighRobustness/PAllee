function runBT474(PAlleeInputPropertiesBT474)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%A script customized for BT474 cancer cell culture aassays (Johnson, 2019)
%To make a model for your own cell culture assays, you need to at least
%make adaptation to the PAlleeInputProperties class, or furthermore, the 
% PAllee class itself.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load the matlab MAT file containing PAlleeInputPropertiesBT474
% load('~/PAllee/examples/BT474/PAlleeInputPropertiesBT474.mat'); 

%construct a PAllee object named 'PAlleeBT474'
PAlleeBT474 = PAlleeBT474ClassDefinition();
%assign the PAlleeInputProperties loaded just now to 'PAlleeBT474'
PAlleeBT474.PAlleeInputProperties = PAlleeInputPropertiesBT474;
%% abbreviating
b = PAlleeBT474;
i = b.PAlleeInputProperties;
%% 
%get worker id for parallel computation
%if only one cpu is used, the id is 0
b = b.getWorkerID();
%% call user-accustomed functions in PAlleeInputPropertiesBT474 sequentially
b = i.secondaryPropertyCalculator(b);
b = i.formCustomReactions(b);
b = i.formDiffusionOperator(b);
b = i.setRandomInitialDistribution(b);
b = i.getTrajectory(b);
%feed it back
PAlleeBT474 = b;
%save the PAllee object to user-designated save directory
save([i.dataSaveDirectory,'/dataBT474.mat'], 'PAlleeBT474')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reference
%Johnson, K.E., et al., Cancer cell population growth kinetics at low densities 
%deviate from the exponential growth model and suggest an Allee effect. 
%PLoS biology, 2019. 17(8): p. e3000399-e3000399.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%