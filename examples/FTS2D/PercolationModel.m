% This function is used for generating percolation configurations
% variables introduction
% k                     label for distinguishing diffenrent configurations with the same
%                       percolation occupation probability
% modelPath     where you store the .mphbin files
function PercolationModel(k,modelPath)
%% Input basic data
LengthB=17*2*(20*3^0.5+20)*1e-6; %input('The length of the outer region='); 
LengthIn=LengthB/17; %input('The length of the inner region='); 
NumIn=17; %input('The number of inner small square=');
RatioList=[0.45,0.55]; %input('The volume ratio of small squares=');
% Margin=(20*3^0.5+20)*1e-6; %input('The margin of the region=');

%% Import comsol
import com.comsol.model.*
import com.comsol.model.util.*
ModelUtil.clear;
%%Generate models
numR=length(RatioList);
for nd=1:numR
    Ratio=RatioList(nd);
        %% Generate coordinate data
        modelName=['Model-' num2str(Ratio) '-' num2str(k)];
         x0=linspace(0,LengthB-LengthB/NumIn,NumIn);
         y0=linspace(0,LengthB-LengthB/NumIn,NumIn);
         
        [x0,y0] = meshgrid(x0,y0);
        p=unifrnd(0,1,[NumIn,NumIn]);
        rng(k,'v5uniform');
        pc=find(p<=Ratio); %Generate randdom number
        x=x0(pc);
        y=y0(pc);
        
        numT=length(pc(:));
        %% Basic settings
        model = ModelUtil.create(['Model-' num2str(Ratio) '-' num2str(k)]);
        model.modelPath(modelPath);
        comp1=model.component.create('comp1',true);
        geom1=model.component('comp1').geom.create('geom1', 2);
        %% Set parameters
        model.param.set('LB', LengthB);
        model.param.set('Lin', LengthIn);
        model.param.set('LS', LengthB/NumIn);
        %% Creat a selection
        selName='Sqs';
        geom1.selection().create(selName,'CumulativeSelection');
        %% Build Geometry
        for i=1:numT
           name= strcat('S',num2str(i));
           sq=geom1.create(name,'Square');
           sq.set('size', LengthB/NumIn);
           sq.set('pos', [x(i) y(i)]);
           geom1.feature(name).set('contributeto',selName);

           
        end
    
        model.component('comp1').geom('geom1').create('sqkn', 'Square');
        model.component('comp1').geom('geom1').feature('sqkn').set('size', LengthIn);
        model.component('comp1').geom('geom1').feature('sqkn').set('pos', [0 (LengthB-LengthIn)/2]);
        geom1.feature('sqkn').set('contributeto',selName);

        %% Form a union
        geom1.create('uni1', 'Union');
        model.component('comp1').geom('geom1').feature('uni1').set('intbnd', false);
        model.component('comp1').geom('geom1').feature('uni1').selection('input').named('Sqs');
        model.component('comp1').geom('geom1').run('uni1');
        geom1.run('fin');
        %% Export model
        geom1.run;
        model.component('comp1').geom('geom1').exportFinal([ modelPath,'/Model-' num2str(Ratio) '-' num2str(k) '.mphbin']);

end

end