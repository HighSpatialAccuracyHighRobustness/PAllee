function p = getTrajectoryWithBigInitialNumberBT474(PAlleeBT474)    
 %% abbreviating
p = PAlleeBT474;
i=p.PAlleeInputProperties;
workdir = i.workingDirectory;
id = p.workerID;
umod = p.URDMEUmod;
%% create worker-specific directory for parallel computation
workerSpecificDirectory = [workdir,num2str(id)];
if ~exist(workerSpecificDirectory,'dir') 
    mkdir(workerSpecificDirectory);
end
%% load time span into URDME unod struct
p.URDMEUmod.tspan = i.timeSpan;
%% URDME script,  generating C language reaction kernel
[~,umod.N,umod.G] = rparse(p.customReactions,p.Species,p.poissonCoefficients,[workerSpecificDirectory,'/fange',num2str(id),'.c']); 
u0 = umod.u0;
%% initialize the overcrowdedness flags
p.overcrowdFlag = (u0(1,:)'*p.cellArea+u0(2,:)'*p.cellArea+u0(3,:)'*0.5*p.cellArea) > p.areaThreshold;
%% periodically check for overcrowdedness and update the diffusion operator if necessary
nw = length(i.timeWindowForBigInitialCellNumber);
% for each time window, do the checking-updating
for j = 1:ceil( length(i.timeSpan)/(nw-1) )
    %specific updating rules are in the function
    %'updateDiffusionOperatorForCrowdedness'
    umod = p.updateDiffusionOperatorForCrowdedness(umod);  
    %take a short time window as the time span
    umod.tspan = i.timeWindowForBigInitialCellNumber;
    %UREME script, output umod_out struct
    p.URDMEUmod_out = urdme(workdir,id,umod,'propensities',['fange',num2str(id)],'report',0);
    %get umod.u out, which contains spatiotemperal information
    u = p.URDMEUmod_out.U;
    %write umod.u into corresponding columns in cellNumberSpatioTemporal
    p.cellNumberSpatioTemporal(:,8*(j-1)+1:8*j) =  u(1:4:end,2:end)+u(2:4:end,2:end)+u(3:4:end,2:end);
    %assign u0 in the next window as the last state in this window 
    u0(1,:) = u(1:4:end,end);
    u0(2,:) = u(2:4:end,end);
    u0(3,:) = u(3:4:end,end);
    u0(4,:) = u(4:4:end,end);
    umod.u0 = u0;
end
%% calculate total cell number trajectory
    p.totalCellNumber = sum(p.cellNumberSpatioTemporal(:,1:length(i.timeSpan)),1);
end