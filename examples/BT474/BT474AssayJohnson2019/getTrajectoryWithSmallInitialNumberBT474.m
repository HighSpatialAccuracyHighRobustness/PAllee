function p = getTrajectoryWithSmallInitialNumberBT474(PAlleeBT474)
   %% abbreviating
    p = PAlleeBT474;
    i=p.PAlleeInputProperties;
    workdir = i.workingDirectory;
     id = p.workerID;
    umod = p.URDMEUmod;
    %% create worker-specific directory for parallel computation
    workerSpecificDirectory = [workdir, num2str(id)];
    if ~exist(workerSpecificDirectory,'dir') 
        mkdir(workerSpecificDirectory);
    end
    %% load time span into URDME umod struct
    p.URDMEUmod.tspan = i.timeSpan;
    umod.tspan = i.timeSpan;
    %% URDME script,  generating C language reaction kernel
    [~,umod.N,umod.G] = rparse(p.customReactions,p.Species,p.poissonCoefficients,[workerSpecificDirectory,'/fange',num2str(id),'.c']); 
    %% URDME script, core urdme kernel
    p.URDMEUmod_out = urdme(workdir,id,umod, 'propensities', ['fange',num2str(id)],'report',0);
    %% calculate Spatio-temporal and total cell number from output raw data
    u = p.URDMEUmod_out.U;
    p.cellNumberSpatioTemporal = u(1:4:end,:)+u(2:4:end,:)+u(3:4:end,:);
    p.totalCellNumber = sum(u(1:4:end,:)+u(2:4:end,:)+u(3:4:end,:));
end