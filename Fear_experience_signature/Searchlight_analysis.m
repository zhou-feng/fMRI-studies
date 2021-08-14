load('Discovery_dataset.mat')
load('fear_datasets_idx.mat')

nsub = 67;
nrepeat = 10; % for 10X10 cross-validation
nlevel = 5; % 5 ratings

for repeat = 1:nrepeat
    CVindex = GenerateCV(nsub, nlevel, repeat); 
    CVindex = CVindex(discovery_label_idx);
    pred_outcome_r{repeat,1} = searchlight_predict(discovery, 'alg', 'svr', 'nfolds', CVindex, 'r', 3); % 3-voxel radius
end