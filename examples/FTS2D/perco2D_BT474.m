function successfulPenetrate = perco2D_BT474(PAlleeInputPropertiesBT474Perco2D)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%A script customized for BT474 cancer cell culture (Johnson, 2019)
%in percolation wells.
%To make a model for your own cell culture assays, you need to at least
%make adaptation to the PAlleeInputProperties class, or furthermore, the 
% PAllee class itself.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load the matlab MAT file containing PAlleeInputPropertiesBT474
%load('/public/home/yrl/PAllee/examples/FTS2D/PAlleeInputPropertiesBT474Perco2D.mat'); 

%construct a PAllee object named 'PAlleeBT474'
PAlleeBT474Perco2D = PAlleeBT474ClassDefinition();
%assign the PAlleeInputProperties loaded just now to 'PAlleeBT474'
PAlleeBT474Perco2D.PAlleeInputProperties = PAlleeInputPropertiesBT474Perco2D;
%% abbreviating
b = PAlleeBT474Perco2D;
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
%% registering successful Penetration occurences (Boolean Type)
rightEdge = find((b.xCoordinates>16*i.L+1e-19).*(b.xCoordinates<17*i.L-1e-19));
successfulPenetrate = sum(b.cellNumberSpatioTemporal(rightEdge,:),1)>0;
%% feed it back
PAlleeBT474Perco2D = b;
%% save the PAllee object to user-designated save directory
save([i.dataSaveDirectory,'/dataBT474Perco2D.mat'], 'PAlleeBT474Perco2D')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reference
%Johnson, K.E., et al., Cancer cell population growth kinetics at low densities 
%deviate from the exponential growth model and suggest an Allee effect. 
%PLoS biology, 2019. 17(8): p. e3000399-e3000399.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%