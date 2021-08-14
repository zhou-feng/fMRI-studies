
load('Discovery_dataset.mat')
[~, stats] = predict(discovery,  'algorithm_name', 'cv_svr', 'nfolds', 1, 'error_type', 'mse');


Haufe_pattern = cov(discovery.dat')*stats.weight_obj.dat/cov(stats.weight_obj.dat'*discovery.dat);
% however, the covariance matrix is huge and we probably couldn't get it
% done in this

% alternatively, we can use the script from Keith A. Bush
% which splits the data into n bricks
% https://github.com/kabush/kablab/blob/master/mvpa/fast_haufe.m
Haufe_pattern = fast_haufe(double(discovery.dat'), double(stats.weight_obj.dat), 500);