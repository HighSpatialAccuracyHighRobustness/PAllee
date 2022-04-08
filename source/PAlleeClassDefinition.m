classdef PAlleeClassDefinition
% PAlleeClass, an interface to spatial stochastic simulation algorithms 
% focusing on the relationship between paracrine and Allee effect.
%   PAllee = PAlleeClassDefinition() instanciate a PAllee class for the
%   RDME model defined in the PAlleeInputProperties-class 
%   PAlleeInputProperties. The arguments to PAlleeClassDefinition are 
%   passed via property/value pairs in PAlleeInputProperties., see the
%   table below.
% 
%   For example,
%   {
%     PAllee =  PAlleeClassDefinition();
%     PAllee.PAlleeInputProperties = PAlleeInputProperties;
%     }
%   instanciate a PAllee class named 'PAllee' and assign its property 
%   'PAlleeInputProperties' with the user-predefined input information
%   'PAlleeInputProperties'
% 
%   Comsol Java objects are conventionally stored in URDMEUmod.comsol
%   and PDE Toolbox structures in URDMEUmod.pde. After simulating the 
%   resulting object may be loaded back into Comsol (or PDE Toolbox) for
%   visualization and postprocessing. See URDME2COMSOL and URDME2PDE.
% 
%   PAllee class has the following properties:
%   ------------------------------------------
% 
%   Required input predefined property:
%   
%  PAlleeInputProperties     user-predefined input
% 
%   Optional, empty understood when left out:
% 
%     workerID                            for parallel use      
%     URDMELink                    the directory of URDME
%     comsolModel         MPH file of predefined comsol model
%     URDMEUmod                 URDME Umod struct 
%     URDMEXmi             property xmi of URDME Umod struct 
%     cellArea                   the minimum area of a cell (that of its nucleus)
%     areaThreshold        restriction of proliferation and migration with 
%                                    regard to crowdedness
%     Species                     the labels of the species defined in URDME           
%     customReactions     the labels of the species defined in URDME     
%     poissonCoefficients  value table of the poisson coefficients of the
%                                       reactions
%     fullDBackup              backup of the diffusion matrix (full means against sparse)
%     D                               the diffusion matrix
%     InitialCellNumberDistribution     'u0' in URDME umod struct, a 2D array
%                                                         with cell number and location as indices
%     totalCellNumber       all cell species added together, one entry for one time step            
%     URDMEUmod_out                            URDME output struct
%     cellNumberSpatioTemporal             URDME umod_out.U
%     numberSpecies                                 number of species
%     xCoordinates                x coordinates of the URDME subVolumes
%     yCoordinates                y coordinates of the URDME subVolumes
%     numberSubvolumes    total number of EURDME subVolumes
%     regionInitialDistribution     an array of indices of initial regions 
%     overcrowdFlag                    1D array recording the overcrowdedness in
%                                                 each URDME subVolume
%                                                 
% PAlleeClass has the following methods:
% -------------------------------------------------------------
%PAlleeClassDefinition               the constructor
% URDMEStartup(obj)                linking URDME with matlab
% geometryComsolToURDME(obj)    from Comsol MPH file to URDME umod struct
% regionInitialDistributionGenerator(obj)  given regionInitialDistributionBoudaries  
%                                                   in PAlleeInputProperties, output regionInitialDistribution
%getWorkerID(obj)                      for parallel computation
%readTrajectory(obj, speciesIndex)    read from output data the agent number
%                                                         trajetory of a specific species
%updateDiffusionOperatorForCrowdedness(obj umod)     dealing with unphysical
%                                                             overcrowdedness in the subVolumes,
%                                                             'umod' is the temporary umod struct
%                                                             during one simulation
% R. Yang, Y. Shao 2021-09-14





    properties
        workerID=[];
        PAlleeInputProperties= [];
        URDMELink = '';
        comsolModel = [];
        URDMEUmod=[];
        URDMEXmi=[];  
        cellArea=[];
        areaThreshold=[];
        Species={};
        customReactions={};
        poissonCoefficients={};
        fullDBackup = [];
        D = [];
        InitialCellNumberDistribution = [];
        totalCellNumber=[];
        URDMEUmod_out=[];
        cellNumberSpatioTemporal=[];
        numberSpecies=[];
        xCoordinates=[];
        yCoordinates=[];
        numberSubvolumes=[];
        regionInitialDistribution =[];
        overcrowdFlag = [];
    end
    methods
    %the constructor
        function obj = PAlleeClassDefinition()
        end
    %linking URDME with matlab
        function obj=URDMEStartup(obj)
                if isempty(obj.URDMELink)     %whether already linked
                    obj.URDMELink = startup();%startup() is a built-in URDME function
                end
        end
    %from Comsol MPH file to URDME umod struct
        function obj= loadURDMEGeometry(obj)
            i = obj.PAlleeInputProperties;
            load(i.URDMEGeometryDirectory);
            obj.URDMEUmod = umod;
            obj.URDMEXmi = xmi;
        end
    %given regionInitialDistributionBoudaries in PAlleeInputProperties,
    %output regionInitialDistribution, for seeding the cells randomly among
    %all user-input initial regions
         function obj = regionInitialDistributionGenerator(obj)
             i = obj.PAlleeInputProperties;%abbreviating PAlleeInputProperties
             bs = i.regionInitialDistributionBoudaries;%abbreviating regionInitialDistributionBoudaries
             for (index = 1 : size(bs,1) )    %read the regions one by one
                 %for the region in the row with index 'index', read and append the
                 %region index to the region list
                 %bs(index,1) is boundary xLeft
                 %bs(index,2) is boundary xRight
                 %bs(index,3) is boundary yDown
                 %bs(index,4) is boundary yUp
                    regionFlag = (obj.xCoordinates>bs(index,1)).*(obj.xCoordinates<bs(index,2)).*...
                        (obj.yCoordinates>bs(index,3)).*(obj.yCoordinates<bs(index,4));%get region-flags by comparing the coordinates with the boundaries
                    region = find(regionFlag);%find the region index with the region flag
                    obj.regionInitialDistribution = [obj.regionInitialDistribution,...
                    region];%append the region to the region list
             end
         end
       %for parallel computation
            function obj  = getWorkerID(obj)
                CT = getCurrentTask();%which cpu is running
                if ~isempty(CT)%if user is using parallel computing
                    obj.workerID = CT.ID;
                else                   %if user is not using parallel computing, id=0
                    CT.ID = 0;
                    obj.workerID = CT.ID;
                end
            end
        %read from output data the agent number trajetory of a specific species
             function trajectory  = readTrajectory(obj, speciesIndex)
                u = obj.URDMEUmod_out.U;
                %2D trajectory array, row index is for locations and column
                %index is for time steps
                trajectory = u(speciesIndex:obj.numberSpecies:end, :);
             end
            %dealing with unphysical  overcrowdedness in the subVolumes,
            %umod is the temporary umod struct during one simulation
            function umod = updateDiffusionOperatorForCrowdedness(obj,umod)
                i = obj.PAlleeInputProperties;%abbreviating PAlleeInputProperties
                u0 = umod.u0;
                overcrowdFlagOld = obj.overcrowdFlag;%backup the flags
                %if a subVolume's total cell area exceeds areaThreshold, flag up
                obj.overcrowdFlag = (u0(1,:)'*obj.cellArea+u0(2,:)'*obj.cellArea+u0(3,:)'*0.5*obj.cellArea) > obj.areaThreshold;
                % if any flag has changed , update the Diffusion Operator
                if  ~sum(obj.overcrowdFlag ~=  overcrowdFlagOld) 
                    %read from backup the Diffusion Operator ('full' means against 'sparse')
                    fullD = obj.fullDBackup;
                    %% extract the diffusion operators for each species
                    fullD_prepromotion = fullD(1:4:end,1:4:end);
                    fullD_promoted = fullD(2:4:end,2:4:end);
                    fullD_newborn = fullD(3:4:end,3:4:end);
                    fullD_mitogen = fullD(4:4:end,4:4:end);
                    
                    %% forbid cells go to overcrowded subVolumes 
                    fullD_prepromotion(find(obj.overcrowdFlag>0),:)=0;
                    fullD_promoted(find(obj.overcrowdFlag>0),:)=0;
                    fullD_newborn(find(obj.overcrowdFlag>0),:)=0;

                    %% assign user accustomed value for ezch species
                    fullD(1:4:end,1:4:end) = i.D1*fullD_prepromotion;
                    fullD(2:4:end,2:4:end) = i.D2*fullD_promoted;
                    fullD(3:4:end,3:4:end) = i.D3*fullD_newborn;
                    fullD(4:4:end,4:4:end) = i.D4*fullD_mitogen;
                    %%
                    %define a temporary sparse D matrix for umod struct
                    tmpD = sparse(fullD);
                    clear fullD fullD_prepromotion fullD_promoted fullD_newborn fullD_mitogen
                    %calculate the Poisson coefficients of cells getting out of each subVolume
                    %% enforce sum of rows criterion when assigning the diagonal elements
                    d = full(sum(tmpD,1));
                    tmpDsize = size(tmpD,1);
                    tmpD = tmpD+sparse(1:tmpDsize,1:tmpDsize,-d);
                    clear d
                    umod.D = tmpD;
                    clear tmpD
                end
            end
    end

end