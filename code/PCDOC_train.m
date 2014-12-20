%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) Javier Sánchez Monedero (jsanchezm at uco dot es)
% 
% This code implements the Pairwise Class Distances (PCD) projection and the
% associated PCD Ordinal Classifier (PCDOC).
% 
% The code has been tested with Ubuntu 11.04 x86_64 and Matlab R2009a
% 
% If you use this code, please cite the associated paper
% Code updates and citing information:
% http://www.uco.es/grupos/ayrna/neco-pairwisedistances
% 
% AYRNA Research group's website:
% http://www.uco.es/ayrna 
%
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 3
% of the License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA. 
% Licence available at: http://www.gnu.org/licenses/gpl-3.0.html
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% [pcdocModel, TrainPredictedZ] = ...
%                   PCDOC_train(TrainP, TrainT, Q, hyperparam)
%
% DESCRIPTION: 
%   This function uses the pcdocModel for predicting Z (latent
%   representation) of paterns TestP
% INPUT: 
%   - pcdocModel: trained model
%   - TestP: patterns attributes
% OUTPUT: 
%   - pcdocModel: trained regression model and thressholds
%   - TrainPredictedY: 

function [pcdocModel, TrainPredictedY] = PCDOC_train(TrainP, TrainT, Q, hyperparam)

    pcdocModel.svrhyperparam = hyperparam;
    %% PCD projection
    % width 
    width = 1/Q;
    % maximum Z value
    maxZ = 1;
    % Thressholds used for classification purposes when predicting
    % new values of Z for unseen data. 
    pcdocModel.T = width:width:maxZ;

    % Calculate the projection
    TrainZ = pcdprojection(TrainP,TrainT,Q);

    %% e-SVR training
    svrParameters = ...
        ['-s 3 -t 2 -c ' num2str(hyperparam.c) ' -p ' num2str(hyperparam.e) ...
        ' -g ' num2str(hyperparam.k)];

    pcdocModel.svrmodel = svmtrain(TrainZ, TrainP, svrParameters);
    [TrainPredictedZ] = ...
        svmpredict(TrainT, TrainP, pcdocModel.svrmodel);

    TrainPredictedY = PCDOC_classify(TrainPredictedZ, pcdocModel.T, Q);
    
end
