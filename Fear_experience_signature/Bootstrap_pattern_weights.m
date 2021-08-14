
load('Discovery_dataset.mat')

[~, stats_boot] = predict(discovery,  'algorithm_name', 'cv_svr', 'nfolds', 1, 'error_type', 'mse', 'bootweights', 'bootsamples', 10000);

data_threshold = threshold(stats_boot.weight_obj, .05, 'fdr');

write(data_threshold, 'thresh', 'fname', 'VIFS_FDR_05.nii');