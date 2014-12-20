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

% [Z,ZC] = pcdprojection(X,Y,Q)
%
% DESCRIPTION: 
%   This function implements the Pairwise Class Distances projection.
%   The distances calculation code is not optimized, however, it is more
%   understable in the way it is writed. 
% INPUT: 
%   - X: patterns attributes
%   - Y: patterns class labels
%   - Q: number of classes
% OUTPUT: 
%   - Z: the PCD projection (latent representation). 
%   - ZC: the PCD projection separated for each class
%   - Dmin,DminIdx,Ztemp,NC: are returning for teaching purposes, such as
%   for the projection analysis. 

function [Z,ZC,Dmin,DminIdx,NC] = pcdprojection(X,Y,Q)
    
% Number of pattern per class
NC = orderedClassDistribution(Y,Q);

% width 
width = 1/Q;

% center for each class
center = zeros(Q,1);

% Get distances between adjacent classes using pdist() with the default
% distance (Euclidean)
% Dmin is \kappa in the Equations
Dmin = cell(Q,Q);
DminIdx = cell(Q,Q);

for i = 1:Q
     j = i + 1;
     if j<=Q
        % i+1 class
        % Class 1
        Ni=size(X(Y==i,:),1);
        Nj=size(X(Y==j,:),1);
        Xsub = [X(Y==i,:); X(Y==j,:)];
        XsubDist = squareform(pdist(Xsub));

        % 'Supress' distances between elements of the same class for
        % ignoring them when calculating the minimum distances
        XsubDist(1:Ni,1:Ni) = inf;
        XsubDist(Ni+1:end,Ni+1:end) = inf;

        % Get the shortest distances
        [XdubDistMin XdubDistMinIdx] = min(XsubDist,[],1);

        % Save the pairwise distances for classes i and j
        Dmin{i,j} = XdubDistMin';
        DminIdx{i,j} = XdubDistMinIdx';
    end

end


Ztemp=cell(Q,1);

for i=1:Q
    Ztemp{i,1} = ones(NC(i),1)*inf;
end

% class 1,2
i = 1;
center(i) = 0;

DminJr = Dmin{i,i+1};
DminJr = DminJr(1:NC(i),:);

W = DminJr / max(DminJr);
Ztemp{i,1} = center(i) + width*(1-W)*(1/2);

clear DminJr W;

for i=2:Q-1   
    % Get distances only for the element on i class
    
    % Look to the class on the right
    DminJr = Dmin{i,i+1};
    DminJr = DminJr(1:NC(i),:);
    
    % Look to the class on the left
    DminJl = Dmin{i-1,i};
    DminJl = DminJl(NC(i-1)+1:end,:);
    
    W = (DminJl+DminJr)/(max(DminJl+DminJr));
    
    center(i) = i*width-width/2;
    ZWtemp = zeros(NC(i),1);
    
    for n = 1:size(DminJl)
         if DminJl(n)<=DminJr(n) 
             ZWtemp(n,1) = center(i) - ((width/2)*(1-W(n,1)));
         else
             ZWtemp(n,1) = center(i) + ((width/2)*(1-W(n,1)));
         end
    end
    Ztemp{i,1} = ZWtemp;
    clear ZWtemp;
end

%class Q-1,Q
i=Q;
center(Q) = 1;
DminJl = Dmin{Q-1,Q};
DminJl = DminJl(NC(Q-1)+1:end,:);

W = DminJl / max(DminJl);
Ztemp{i,1} = center(i) - width*(1-W)*(1/2);

clear DminJr;

% Join ZC for each class in Z
ZC = cell(Q,1);
poffset = 0;
for i=1:Q
    temp = Ztemp{i,1};
   
    if i==1
        Z = temp;
    else
        Z = [Z;temp];
    end
    
    ZC{i,1} = temp;
  
    poffset=poffset+NC(i);
end

end
