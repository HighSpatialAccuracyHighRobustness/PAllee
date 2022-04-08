function PAlleeBT474=setRandomInitialDistributionBT474(PAlleeBT474)
    %% abbreviating
    p=PAlleeBT474;
    i=p.PAlleeInputProperties;
    %initialize umod.u0 in URDME grammar
    u0 = zeros(p.numberSpecies, p.numberSubvolumes);
    nc1 = i.initialCellNumber;
    %get initial region indices
    initialRegions = p.regionInitialDistribution;
    numberInitialRegions = length(initialRegions);
    %designate a location index for every individual cell
    locationDesignation = initialRegions(floor(numberInitialRegions*rand(1,nc1))+1);
    %% write number of cells at every location into u0 matrix
    u0(1,:) = full(sparse(1,double(locationDesignation'),1,1,p.numberSubvolumes));
    u0(2,:) = 0;
    u0(3,:) = 0;
    u0(4,:) = 0;
    %% feed it back
    p.InitialCellNumberDistribution = u0;
    p.URDMEUmod.u0 = u0;
    PAlleeBT474 = p;
end