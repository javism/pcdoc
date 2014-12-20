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

% TestPredictedZ = PCDOC_predict(pcdocModel, TestP)
%
% DESCRIPTION: 
%   This function uses the pcdocModel for predicting Z (latent
%   representation) of paterns TestP
% INPUT: 
%   - pcdocModel: trained model
%   - TestP: patterns attributes
%   - TestT: patterns labels
% OUTPUT: 
%   - TestPredictedZ: 

function TestPredictedY = PCDOC_predict(pcdocModel, TestP, Q)

    DummyTestT = rand(size(TestP,1),1);

    % svmpredict needs TestT
    TestPredictedZ = ...
                    svmpredict(DummyTestT, TestP, pcdocModel.svrmodel);

    TestPredictedY = PCDOC_classify(TestPredictedZ, pcdocModel.T, Q);

    %TestPredictedY = TestPredictedY';
        
end
