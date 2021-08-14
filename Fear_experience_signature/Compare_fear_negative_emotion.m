%% VIFS and PINES predict general negative emotion (table 2)
VIFS = fmri_data('VIFS.nii', 'GM_mask.nii');
PINES = fmri_data('PINES.nii', 'PINES_mask.nii'); % Chang et al. 2015, Plos Biology
% PINES dataset is available from https://neurovault.org/collections/1964/
% we test both signatures on PINES holdout dataset only
load('PINES_holdout.mat')
PINES_VIFS_PE = double(PINES_holdout.dat'*VIFS.dat);
PINES_PINES_PE = double(PINES_holdout.dat'*PINES.dat);

pred_PINES_r_VIFS = corr(PINES_VIFS_PE, PINES_holdout.Y);
pred_PINES_r_PINES = corr(PINES_PINES_PE, PINES_holdout.Y);

%% VIFS and PINES predict fear (table 2)
VIFS = fmri_data('VIFS.nii', 'GM_mask.nii');
PINES = fmri_data('PINES.nii', 'PINES_mask.nii'); % Chang et al. 2015, Plos Biology
load('Discovery_dataset.mat')
discovery_PINES_PE = double(discovery.dat'*PINES.dat);
pred_discovery_r_PINES = corr(discovery_PINES_PE, discovery.Y);
% pred_discovery_r_VIFS can be obtained from Predict_discovery_repeated_CV
load('Validation_dataset.mat');
validation_PINES_PE = double(validation.dat'*PINES.dat);
pred_validation_r_PINES = corr(validation_PINES_PE, validation.Y);
validation_VIFS_PE = double(validation.dat'*VIFS.dat);
pred_validation_r_VIFS = corr(validation_VIFS_PE, validation.Y);
load('generalization_dataset.mat');
generalization_PINES_PE = double(generalization.dat'*PINES.dat);
pred_generalization_r_PINES = corr(generalization_PINES_PE, generalization.Y);
generalization_VIFS_PE = double(generalization.dat'*VIFS.dat);
pred_generalization_r_VIFS = corr(generalization_VIFS_PE, generalization.Y);