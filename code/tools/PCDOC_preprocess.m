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

% DataSet = PCDOC_preprocess(trainFileName, testFilename)
%
% DESCRIPTION: 
%   Load, standarize train+test dataset and extract dataset information
% INPUT: 
%   - trainFileName: train set file name
%   - testFilename: test set file name
% OUTPUT: 
%   - DataSet: structure containing the preprocessed dataset patterns and
%   some useful information (i.e. number of classes, number of patterns).

function DataSet = PCDOC_preprocess(trainFileName, testFilename)

    % Copy settings
    DataSet.trainFileName = trainFileName;
    DataSet.testFilename = testFilename;

    rawTrain=load(trainFileName);
    rawTest=load(testFilename);

    TrainT = rawTrain(:,end);
    TrainP = rawTrain(:,1:end-1);
    
    TestT = rawTest(:,end);
    TestP = rawTest(:,1:end-1);
    
    clear rawTrain rawTest;

    % Check for constant attributes that we can delete. Otherwise a
    % NaN can be obtained later
    minvals = min(TrainP);
    maxvals = max(TrainP);

    r = 0;
    for k=1:size(TrainP,2)
        if minvals(k) == maxvals(k)
            r = r + 1;
            index(r) = k;
        end
    end

    if r > 0
        r = 0;
        for k=1:size(index,2)
            TrainP(:,index(k)-r) = [];
            TestP(:,index(k)-r) = [];
            r = r + 1;
        end
    end

    clear index r minvals minvals;
    
    % Standarize data
    [TrainP, XMeans, XStds] = standarize(TrainP);
    
    % Test data is standarized with Mean and STD of the train set.
    TestP = standarize(TestP,XMeans,XStds);
    
    % Get Number of classes
    DataSet.Q = max(max(TrainT),max(TestT)); 
    
    % Number of patterns
    DataSet.N = size(TrainT,1); % 
    
    DataSet.TrainP = TrainP;
    DataSet.TrainT = TrainT;
    DataSet.TestP = TestP;
    DataSet.TestT = TestT;

    clear TrainP TrainT TestP TestT;
end
