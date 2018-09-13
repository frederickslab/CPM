function [mdl_summary, mdl_features, y_predict, performance] = cpm_main(x,y,varargin)
%% Performs Connectome-Based Predictive Modeling (CPM)
% See Shen et al., 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUTS
% Predictor / feature variable "x" is n x nsubs OR n x m x nsubs
% Outcome variable "y" is i x nsubs
% Optional parameters: TBD
%
% OUTPUTS
% returns mdl, a structure containing the predictive edges and associated p and r vals
%
% e.g., [m1,m2,yhat,perf]=cpm_main(data,gF,'pthresh',0.05,'kfolds',2);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parse input
p=inputParser;
defaultpthresh=0.01;
defaultkfolds=2; % TODO: take + loop over vec of different kfolds

addRequired(p,'x',@isnumeric);
addRequired(p,'y',@isnumeric); % must be n x nsubs
addParameter(p,'pthresh',defaultpthresh,@isnumeric);
addParameter(p,'kfolds',defaultkfolds,@isnumeric);

parse(p,x,y,varargin{:});

pthresh = p.Results.pthresh;
kfolds = p.Results.kfolds;

clearvars p

%% Errors

[x,y]=cpm_check_errors(x,y,kfolds);

%% Run train / test
[mdl_summary,mdl_features,y_test, y_predict]=cpm_cv(x,y,pthresh,kfolds);
% TODO: choose + return mdl_summary, mdl_features

%% Check performance
[performance(1),performance(2)]=corr(y_predict(:),y_test(:));

fprintf('\nDone.\n')

end
