
% Execution example of the PCDOC algorithm by using e-SVR as regressor tool
clearvars;

% Add libSVM matlab version. It is compiled for 64bits machines running
% GNU/Linux. 
addpath libsvm-mat-3.0-1/
addpath tools/

datasetTrainFile = '../ordinal-classification-datasets/contact-lenses/gpor/train_contact-lenses.0';
datasetTestFile = '../ordinal-classification-datasets/contact-lenses/gpor/test_contact-lenses.0';

% SVR hyperparameters example (must be crossvalided):
hyperparam.k = 0.001;
hyperparam.c = 1000;
hyperparam.e = 0.1000;

% Load and preprocess (standarize) data
dataset = ...
    PCDOC_preprocess(datasetTrainFile,datasetTestFile);

% Run PCDOC algorithm
[pcdocModel, TrainPredictedY] = PCDOC_train(dataset.TrainP,dataset.TrainT,dataset.Q, hyperparam);
TestPredictedY = PCDOC_predict(pcdocModel, dataset.TestP, dataset.Q);

% Generate statistics
pmTrain = PCDOC_performanceMetrics(dataset.TrainT, TrainPredictedY);
pmTest = PCDOC_performanceMetrics(dataset.TestT, TestPredictedY);

% Print statistics:
fprintf('\nPerformance metrics:\n');
fprintf('Acc: %f\n', pmTest.acc);
fprintf('MAE: %f\n', pmTest.mae);
fprintf('AMAE: %f\n', pmTest.amae);
fprintf('Kendalls Taub: %f\n', pmTest.kendall);
