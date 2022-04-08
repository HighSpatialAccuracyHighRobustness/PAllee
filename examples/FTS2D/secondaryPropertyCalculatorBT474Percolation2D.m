function p = secondaryPropertyCalculatorBT474Percolation2D(PAlleeBT474)
   %abbreviating PAllee    
    p=PAlleeBT474;
    %abbreviating PAlleeInputProperties
    i = p.PAlleeInputProperties;
    %calculating effective cell area from nucleus radius
    p.cellArea = pi*i.cellNucleusRadius^2;
    %linking URDME with matlab
    p=p.URDMEStartup();
    %load URDME umod struct
    p=p.loadURDMEGeometry();
    %subVolume areathreshold = threshold fraction*subVolume area
    p.areaThreshold = i.CP2*p.URDMEUmod.vol;
    %initialize total cell number record
    p.totalCellNumber = zeros(1,length(i.timeSpan));
    %initialize cell number spatio-temperal record 
    p.cellNumberSpatioTemporal = zeros(length(p.URDMEUmod.vol), length(i.timeSpan));
    %read the number of species
    p.numberSpecies = numel(p.URDMEXmi.fieldnames);
    %read the x, y coordinates
    p.xCoordinates = p.URDMEXmi.x;
    p.yCoordinates = p.URDMEXmi.y;
    %read the number of subVolumes
    p.numberSubvolumes = length(p.URDMEUmod.vol);
    %generate the initial region index list
    p = p.regionInitialDistributionGenerator();
end