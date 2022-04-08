function mexmake_nsm(workdir,workerid,propensity_file,~)
%MEXMAKE_NSM Makefile for MEXNSM.
%   MEXMAKE_NSM(P) Makes the NSM-solver with propensity source file P,
%   given as a relative path.

% S. Engblom 2017-02-16 (Major revision, URDME 1.3, Comsol 5)
% J. Cullhed 2008-06-18 (make)

if nargin > 3, error('NSM does not accept make arguments.'); end

% global defines, if any
define = [];

% path = location of this make
path = mfilename('fullpath');
path = path(1:end-11); % m-e-x-m-a-k-e-_-n-s-m is 11 chars


 file_name = sprintf('%s',num2str(workerid));
    file_path_name = strcat(workdir,file_name);
    file_path_name_ = strcat(file_path_name,'/');
    if ~exist(file_path_name_,'dir')  
        mkdir(file_path_name_);
    else                                           
        delete([file_path_name_,'*.mexa64'])
    end
    cd(file_path_name_);

    propensity_source = strcat(file_path_name_, propensity_file);



% % determine path to propensity
% if nargin > 0 && ~isempty(propensity_file)
%   % propensity_file is a relative path
%   propensity_source = [pwd '/' propensity_file];
% else
%   % can also compile mexnsm without propensity_file, using inline
%   % propensities only
%   propensity_source = [path '../propensities.c'];
% end

% include and source directories
include = {['-I' path] ['-I' path '../../include']};
link =    {['-L' path] ['-L' path '../']};
source = {[path 'mexnsm.c'] ...
          propensity_source ...
          [path 'nsm.c'] ...
          [path '../binheap.c'] ...
          [path '../inline.c'] ...
          [path '../report.c']};
define = [define '-DMALLOC\(n\)=mxMalloc\(n\) -DFREE\(p\)=mxFree\(p\)'];

% mex extension
mx = mexext;

% platforms (edit here)
if strcmp(mx,'mexa64')
  cc = 'CC=gcc';
  cflags = ['CFLAGS=-fPIC -fno-omit-frame-pointer -std=c99 -O3 ' ...
            '-D_GNU_SOURCE -pthread -fexceptions '];
  
  mex('-silent','-largeArrayDims',cc,[cflags define], ...
      include{:},link{:},source{:});
elseif strcmp(mx,'mexmaci64')
  cflags = 'CFLAGS= -std=c99 ';
  mex('-silent','-largeArrayDims',[cflags define], ...
      include{:},link{:},source{:});
else
  error(['Platform not yet supported. Your MEX file extension is ' ...
         mx '. Please edit mexmake_nsm.m to allow for this extension.']);
end
