function PAlleeInputPropertiesBT474 = InputPropertyFileMakerBT474()
    i = PAlleeInputPropertiesClassDefinition;
    i.workingDirectory = '~/PAllee/';
    i.dataSaveDirectory ='~/PAllee/examples/BT474/'; 
    i.URDMELink = '';
    i.comsolMPHDirectory = '~/PAllee/examples/BT474/comsolURDMEGeometryBT474.mph';
    i.cellNucleusRadius = 1e-5;
    i.initialCellNumber=10;
    i.timeSpan=3600*[0:4:320];
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
    
    i.regionInitialDistributionBoudaries = [-3.817e-5, 3.558e-5, -2.897e-5, 2.784e-5];
    
    i.timeWindowForBigInitialCellNumber=3600*4*[0:8];
    i.timeWindowFor2DPercolation=3600*4*[0:8];
    i.secondaryPropertyCalculator=@secondaryPropertyCalculatorBT474;
    i.formDiffusionOperator=@formDiffusionOperatorBT474;
    i.setRandomInitialDistribution=@setRandomInitialDistributionBT474;
    i.formCustomReactions=@formCustomReactionsBT474;
    if  i.initialCellNumber<10
        i.getTrajectory=@getTrajectoryWithSmallInitialNumberBT474;
   else
        i.getTrajectory=@getTrajectoryWithBigInitialNumberBT474;
   end
    PAlleeInputPropertiesBT474 = i;
    save([i.workingDirectory,'examples/BT474/PAlleeInputPropertiesBT474.mat'],'PAlleeInputPropertiesBT474');
end