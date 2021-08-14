clear, clc
load('fear_datasets_idx.mat')
load('Discovery_dataset.mat')
svrobj = svr({'C=1', 'optimizer="andre"', kernel('linear')});
dataobj = data('spider data', double(discovery.dat)', discovery.Y);
clear discovery
[~, svrobj] = train(svrobj, dataobj, loss);
weights = get_w(svrobj)';
bias = svrobj.b0;
% save('VIFS', 'weights', 'bias', '-v7.3');
% load('VIFS.mat')

% the generalization dataset can be available from the authors of
% Taschereau-Dumouchel et al. 2019, Molecular Psychiatry
load('Generalization_dataset.mat');
predicted_ratings = double(generalization.dat)'*weights+bias;

% or simply use:
% VIFS = fmri_data('VIFS.nii', 'GM_mask.nii');
% predicted_ratings = double(generalization.dat'*VIFS.dat);

true_ratings = generalization.Y;
prediction_outcome_correlation = corr(predicted_ratings, generalization.Y);

predicted_ratings_reshaped = nan(31*6, 1);
predicted_ratings_reshaped(generalization_label_idx) = predicted_ratings;
predicted_ratings_reshaped = reshape(predicted_ratings_reshaped, [6, 31])';
%% plot
create_figure('Whole-brain Prediction');
lineplot_columns(predicted_ratings_reshaped, 'color', [.7 .3 .3], 'markerfacecolor', [1 .5 0]);
xlabel('True Rating');
ylabel('Predicted Rating')
set(gca,'FontSize',20);
set(gca,'linewidth', 2)
set(gca, 'XTick', 1:6)
xlim([0.8 6.2])
set(gcf, 'Color', 'w');
% export_fig Discovery_whole-brain_prediction -tiff -r500