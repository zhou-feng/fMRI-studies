%% VIFS predicts threat
VIFS = fmri_data('VIFS.nii', 'GM_mask.nii');
% Reddan threat conditioning data is from Reddan et al. 2018, Neuron
load('Reddan_threat.mat');
Reddan_threat_VIFS_PE = double(Reddan_threat.dat'*VIFS.dat);
ROC_Reddan = roc_plot(Reddan_threat_VIFS_PE, [ones(68,1);zeros(68,1)], 'twochoice'); % two-choice, 68 subjects

% Zhou threat conditioning data is available from request
load('Zhou_threat.mat')
Zhou_threat_VIFS_PE = double(Zhou_threat.dat'*VIFS.dat);
ROC_Zhou = roc_plot(Zhou_threat_VIFS_PE, [ones(58,1);zeros(58,1)], 'twochoice'); % two-choice, 58 subjects

%% TPS predicts fear
TPS = fmri_data('TPS.nii', 'threat_mask.nii'); % from Reddan et al. 2018
load('Discovery_dataset_threat_mask.mat')
Discovery_TPS_PE = double(discovery.dat'*TPS.dat);
discovery_prediction_outcome_corr = corr(Discovery_TPS_PE, discovery.Y);

load('Validation_dataset_threat_mask.mat')
validation_TPS_PE = double(validation.dat'*TPS.dat);
validation_prediction_outcome_corr = corr(validation_TPS_PE, validation.Y);

load('Generalization_dataset_threat_mask.mat')
generalization_TPS_PE = double(generalization.dat'*TPS.dat);
generalization_prediction_outcome_corr = corr(generalization_TPS_PE, generalization.Y);
