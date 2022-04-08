function PAlleeInputPropertiesBT474Perco2D = InputPropertyFileMakerBT474Perco2D()
    i = PAlleeInputPropertiesClassDefinition;
    i.workingDirectory = '/public/home/yrl/';
    i.dataSaveDirectory =[i.workingDirectory,'PAllee/examples/FTS2D/']; 
    i.URDMELink = [i.workingDirectory,'PAllee/examples/FTS2D/UmodFiles/0.55'];
    i.URDMEGeometryDirectory = [i.workingDirectory,'PAllee/examples/FTS2D/UmodFiles/0.55/umod_0.55_1.mat'];
    i.comsolMPHDirectory = '';
    i.cellNucleusRadius = 1e-5;
    i.initialCellNumber=2;
    i.timeSpan=3600*[0:4:800];
    i.Gamma0=[1.72146030787756e-05];
    i.gamma0=[2.72256513093364e-06];
    i.mu=[1.80742210245233e-05];
    i.death=[7.43689516833597e-08];
    i.mu1=[4.85306014927395e-05];
    i.decomposition=[0.000459306577776131];
    i.gamma1=[3.31862475898130e-06];
    i.D1=[13.0578752141521];
    i.D2=[13.0578752141521];
    i.D3=[3.54816015269286];
    i.D4=[4.00128467378280];
    i.CP1=[0.746476422676422];
    i.CP2=[0.702166373793946];
    i.L = 2*(20*3^0.5+20)*1e-6;
    i.regionInitialDistributionBoudaries = [0.01*i.L, 0.99*i.L, 8.01*i.L, 8.99*i.L];
    
    i.timeWindowForBigInitialCellNumber=3600*4*[0:8];
    i.timeWindowFor2DPercolation=3600*4*[0:8];
    i.secondaryPropertyCalculator=@secondaryPropertyCalculatorBT474Percolation2D;
    i.formDiffusionOperator=@formDiffusionOperatorBT474Perco2D;
    i.setRandomInitialDistribution=@setRandomInitialDistributionBT474;
    i.formCustomReactions=@formCustomReactionsBT474;
    
    i.getTrajectory=@getTrajectoryFor2DPercolationBT474;
  
        
  
    PAlleeInputPropertiesBT474Perco2D = i;
    save([i.workingDirectory,'PAllee/examples/FTS2D/PAlleeInputPropertiesBT474Perco2D.mat'],'PAlleeInputPropertiesBT474Perco2D');
end