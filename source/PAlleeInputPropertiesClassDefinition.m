classdef PAlleeInputPropertiesClassDefinition 
% PAlleeInputProperties, an interface to input user accustomed properties
% into  PAlleeClass
%  PAlleeInputProperties = PAlleeInputPropertiesClassDefinition () instanciate a 
%   PAlleeInputProperties class 
%   The arguments to PAlleeClassDefinition are 
%   passed via property/value pairs in PAlleeInputProperties, see the
%   table below.
%   For example,
%   {
%     PAllee =  PAlleeClassDefinition();
%     PAllee.PAlleeInputProperties = PAlleeInputProperties;
%     }
%   instanciate a PAllee class named 'PAllee' and assign its property 
%   'PAlleeInputProperties' with the user-predefined input information
%   'PAlleeInputProperties'
% 
%   PAlleeInputProperties class has the following properties:
%   ------------------------------------------
% 
%   All properties are required
%         workingDirectory                woking directory of PAllee
%         dataSaveDirectory              where to save the output dataset
%         URDMELink                         directory of URDME
%         comsolMPHDirectory         directory of user-accustomed comsol model .MPH file
%         URDMEGeometryDirectory     directory of user-accustomed URDME geometry .MAT file
%         cellNucleusRadius               user-assumed nucleus radius for every cell
%         initialCellNumber                the initial number of unpromoted cells ,
%                                                     initial numbers of other cells are set to zero in PAllee
%         timeSpan                             an array time points that needs output. The unit is second
%         Gamma0                              Poisson coefficient for mitogenic promotion
%         gamma0                              Poisson coefficient for umpromoted mitosis
%         mu                                       Poisson coefficient for newborn growth
%         death                                   Poisson coefficient for cell death
%         mu1                                     Poisson coefficient for mitogen secretion
%         decomposition                    Poisson coefficient for mitogen decomposition
%         gamma1                              Poisson coefficient for promoted mitosis
%         D1                                        Poisson coefficient for migration of unpromoted cells
%         D2                                        Poisson coefficient for migration of promoted cells
%         D3                                        Poisson coefficient for migration of newborn cells
%         D4                                        Poisson coefficient for secreted mitogenic signal package
%         CP1                                      control parameter of mitosis to avoid unphysical overcrowding 
%         CP2                                      control parameter of migration to avoid unphysical overcrowding 
%         L                                          Size of percolation lattice
%         timeWindowForBigInitialCellNumber  For how many step should we check for overcrowdeness
%                                                                       and
%                                                                       then update the diffusion operator  for big initial cell 
%                                                                          numbers at the parameter fitting stage
%         timeWindowFor2DPercolation            For how many step should we check for overcrowdeness
%                                                                       and then update the diffusion operator for 2D Percolation
%                                                                       at the prediction generation stage
%         regionInitialDistributionBoudaries     a 2D array, every row is a 1 by 4 array containing the x-y 
%                                                                     boundaries of one region, e.g., for 3 initial regions, this property
%                                                                         will be like
%                                                                         [xLeft_1, xRight_1, yDown_1, yUp_1;
%                                                                          xLeft_2, xRight_2, yDown_2, yUp_2;
%                                                                          xLeft_3, xRight_3, yDown_3, yUp_3]
%                                                                         
%         secondaryPropertyCalculator        a handle pointing to a user-accustomed secondary property calculator function
%                                                                an example is shown in the directory 'examples'
%         formDiffusionOperator                  a handle pointing to a user-accustomed form-diffusion-operator function 
%                                                                 an example is shown in the directory 'examples'
%         setRandomInitialDistribution         a handle pointing to a user-accustomed set-random-initial-distribution function 
%                                                                 an example is shown in the directory 'examples'
%         formCustomReactions                    a handle pointing to a user-accustomed form-custom-reactions function 
%                                                                 an example is shown in the directory 'examples'
%         getTrajectory                                  a handle pointing to a user-accustomed get-trajectory function 
%                                                                 an example is shown in the directory 'examples'

    properties
        workingDirectory = '';
        dataSaveDirectory =''; 
        URDMELink = '';
        comsolMPHDirectory = '';
        URDMEGeometryDirectory = '';
        cellNucleusRadius = [];
        initialCellNumber=[];
        timeSpan=[];
        Gamma0=[];
        gamma0=[];
        mu=[];
        death=[];
        mu1=[];
        decomposition=[];
        gamma1=[];
        D1=[];
        D2=[];
        D3=[];
        D4=[];
        CP1=[];
        CP2=[];
        L = [];
        timeWindowForBigInitialCellNumber=[];
        timeWindowFor2DPercolation = [];
        regionInitialDistributionBoudaries = [];
        secondaryPropertyCalculator=[];
        formDiffusionOperator=[];
        setRandomInitialDistribution=[];
        formCustomReactions=[];
        getTrajectory=[];
    end
    methods
        function obj = PAlleeInputPropertiesClassDefinition()
        end
    end

end