function PAlleeBT474 = formCustomReactionsBT474(PAlleeBT474)
    %% abbreviating
    p= PAlleeBT474;
    i=p.PAlleeInputProperties;
    %% define the user-accustomed reactions using URDME grammar
    %the species
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %c1 : unpromoted cell
    %c2 : promoted cell
    %c3 : neborn cell
    %c4 : phenomenological, secreted mitogenic signal package 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %the reactions
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % one c1 secrets  one c4 with Poisson coefficient mu1
    r1 = 'c1 > mu1*c1 > c1 + c4';
    % one c1 gets promoted  upon capturing one c4 with Poisson coefficient Gamma0
    r2 = 'c1 + c4 > Gamma0*c1*c4/vol > c2';
    %one c1 divide into two c3 with Poisson coefficient gamma0
    %if the cell area exceeds threchold in this subVolume, forbid
    %this reaction (unpromoted mitosis) in this subVolume
    r3 = ['c1 > gamma0*c1*((c1*cell_area+c2*cell_area+c3*0.5*cell_area)<(',num2str(i.CP1),'*vol)) > c3 + c3'];
    %one c3 becomes c1 with Poisson coefficient mu
    r4 = 'c3 > mu*c3 > c1';
    % one c1 dies with Poisson coefficient death
    r5 = 'c1 > death*c1*(c1>0) > @';
    % one c4 decomposites with Poisson coefficient decomposition
    r6 = 'c4 > decomposition*c4*(c4>0) > @';
    %one c2 divide into two c3 with Poisson coefficient gamma1
    %if the cell area exceeds threchold in this subVolume, forbid
    %this reaction (promoted mitosis) in this subVolume
    r7 = ['c2 > gamma1*c2*((c1*cell_area+c2*cell_area+c3*0.5*cell_area)<(',num2str(i.CP1),'*vol)) > c3 + c3'];
    % one c2 dies with Poisson coefficient death
    r8 = 'c2 > death*c2*(c2>0) > @';
    % one c3 dies with Poisson coefficient death
    r9 = 'c3 > death*c3*(c3>0) > @';
    % one c2 secrets  one c4 with Poisson coefficient mu1
    r10= 'c2 > mu1*c2 > c2 + c4';
    %% labeling the sepcies, should the same as that in pre-built Comsol model
    p.Species = {'c1' 'c2' 'c3' 'c4'};
    %% making value table for the Poisson coefficients, which are called 'rates' in URDME, 
    %% and cell_area
    eval(['p.poissonCoefficients = {','''Gamma0''',' ',num2str(i.Gamma0),' ','''gamma0''',' ',num2str(i.gamma0),...
        ' ','''mu''',' ',num2str(i.mu),' ','''death''',' ',num2str(i.death),...
        ' ','''mu1''',' ',num2str(i.mu1),' ','''decomposition''',' ',num2str(i.decomposition),...
        ' ','''cell_area''',' ',num2str(p.cellArea),...
        ' ','''gamma1''',' ',num2str(i.gamma1),'};']);
    %% labeling the reactions
    p.customReactions = {r1 r2 r3 r4 r5 r6,r7,r8,r9,r10};
   %%
    PAlleeBT474=p;
end