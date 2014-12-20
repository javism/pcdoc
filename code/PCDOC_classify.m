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

% Y = PCDOC_classify(Z, pcdocModel.T, Q)
%
% DESCRIPTION: 
%   This function uses Z latent representation and thressholds for classifying 
%   patterns according to they latent representation.
% INPUT: 
%   - Z: patterns latent representation
%   - T: thressholds
%   - Q: number of classes
% OUTPUT: 
%   - Y: predicted patterns labels

function Y = PCDOC_classify(Z, T, Q)

    Y = zeros(size(Z));
    
    for ii=1:Q-1
        
        if (ii == 1)
            indx = Z<=T(ii);
        else
            indx = and(Z>T(ii-1), Z<=T(ii));
        end

        Y(indx) = ii;
    end
    
    % last class
    indx = Z>T(Q-1);
    Y(indx) = Q;
    
end
