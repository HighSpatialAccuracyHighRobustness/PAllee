function PAlleeBT474 = formDiffusionOperatorBT474Perco2D(PAlleeBT474)
    %abbreviating PAllee    
    p=PAlleeBT474;
    %abbreviating PAlleeInputProperties
    i=p.PAlleeInputProperties;
    %abbreviating the Diffusion operator
    D =p.URDMEUmod.D;
    %% extract the diffusion operators for each species
    D_prepromotion = D(1:4:end,1:4:end);
    D_promoted = D(2:4:end,2:4:end);
    D_newborn = D(3:4:end,3:4:end);
    D_mitogen = D(4:4:end,4:4:end);
    %% setting Dirichlet boundary condition
    %% by setting the diffusion propensities 
    %% of the boundary subVolumes to zero
    enpiFn = p.URDMEXmi.edgeNodesPositionInFEMNodes;
    D_prepromotion(enpiFn,:)=0;
    D_promoted(enpiFn,:)=0;
    D_newborn(enpiFn,:)=0;
    D_mitogen(enpiFn,:)=0;
    D_prepromotion(:,enpiFn)=0;
    D_promoted(:,enpiFn)=0;
    D_newborn(:,enpiFn)=0;
    D_mitogen(:,enpiFn)=0;
    %% assign user accustomed value for ezch species
    D(1:4:end,1:4:end) = i.D1*D_prepromotion;
    D(2:4:end,2:4:end) = i.D2*D_promoted;
    D(3:4:end,3:4:end) = i.D3*D_newborn;
    D(4:4:end,4:4:end) = i.D4*D_mitogen;
    %% backup the full matrix
    p.fullDBackup = D;
    %% calculate the Poisson coefficients of cells getting out of each subVolume
    %% enforce sum of rows criterion when assigning the diagonal elements
    d = full(sum(D,1));
    Dsize = size(D,1);
    D = D+sparse(1:Dsize,1:Dsize,-d);
    %% feed it back to PAllee
    p.D = D;
    PAlleeBT474 = p;
end