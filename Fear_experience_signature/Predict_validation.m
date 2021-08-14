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
load('Validation_dataset.mat');
predicted_ratings = double(validation.dat)'*weights+bias;
true_ratings = validation.Y;
nsub = 20;
nlevel = 5;
subject = repmat(1:nsub, nlevel,1);
subject = subject(:);

%% prediction-outcome corrs
prediction_outcome_corr = corr(predicted_ratings, true_ratings);
within_subj_corrs = zeros(nsub, 1);
within_subj_rmse = zeros(nsub, 1);
for i = 1:nsub
    subY = true_ratings(subject==i);
    subyfit = predicted_ratings(subject==i);
    within_subj_corrs(i, 1) = corr(subY, subyfit);
    err = subY - subyfit;
    mse = (err' * err)/length(err);
    within_subj_rmse(i, 1) = sqrt(mse);
end

%% classification
Accuracy_per_level = zeros(1, 4);
Accuracy_se_per_level = zeros(1, 4);
Accuracy_p_per_level = zeros(1, 4);
Accuracy_low_medium_high = zeros(1, 3);
Accuracy_se_low_medium_high = zeros(1, 3);
Accuracy_p_low_medium_high = zeros(1, 3);
PE = reshape(predicted_ratings, [5, nsub])';
PE_low = nanmean(PE(:, 1:2), 2);
PE_medium = PE(:, 3);
PE_high = nanmean(PE(:, 4:5), 2);
% level 2 vs. 1
ROC = roc_plot([PE(:, 2);PE(:,1)], [ones(nsub,1);zeros(nsub,1)], 'twochoice');
Accuracy_per_level(1) = ROC.accuracy;
Accuracy_se_per_level(1) = ROC.accuracy_se;
Accuracy_p_per_level(1) = ROC.accuracy_p;
% level 3 vs. 2
ROC = roc_plot([PE(:, 3);PE(:,2)], [ones(nsub,1);zeros(nsub,1)], 'twochoice');
Accuracy_per_level(2) = ROC.accuracy;
Accuracy_se_per_level(2) = ROC.accuracy_se;
Accuracy_p_per_level(2) = ROC.accuracy_p;
% level 4 vs. 3
ROC = roc_plot([PE(:, 4);PE(:,3)], [ones(nsub,1);zeros(nsub,1)], 'twochoice');
Accuracy_per_level(3) = ROC.accuracy;
Accuracy_se_per_level(3) = ROC.accuracy_se;
Accuracy_p_per_level(3) = ROC.accuracy_p;
% level 5 vs. 4
ROC = roc_plot([PE(1:end-2, 5);PE(1:end-2,4)], [ones(nsub-2,1);zeros(nsub-2,1)], 'twochoice');
Accuracy_per_level(4) = ROC.accuracy;
Accuracy_se_per_level(4) = ROC.accuracy_se;
Accuracy_p_per_level(4) = ROC.accuracy_p;
% low vs. meduim
ROC = roc_plot([PE_medium;PE_low], [ones(nsub,1);zeros(nsub,1)], 'twochoice');
Accuracy_low_medium_high(1) = ROC.accuracy;
Accuracy_se_low_medium_high(1) = ROC.accuracy_se;
Accuracy_p_low_medium_high(1) = ROC.accuracy_p;
% medium vs. high
ROC = roc_plot([PE_high;PE_medium], [ones(nsub,1);zeros(nsub,1)], 'twochoice');
Accuracy_low_medium_high(2) = ROC.accuracy;
Accuracy_se_low_medium_high(2) = ROC.accuracy_se;
Accuracy_p_low_medium_high(2) = ROC.accuracy_p;
% low vs. high
ROC = roc_plot([PE_high;PE_low], [ones(nsub,1);zeros(nsub,1)], 'twochoice');
Accuracy_low_medium_high(3) = ROC.accuracy;
Accuracy_se_low_medium_high(3) = ROC.accuracy_se;
Accuracy_p_low_medium_high(3) = ROC.accuracy_p;

%% plot
create_figure('Whole-brain Prediction');
predicted_ratings_reshaped = reshape(predicted_ratings, [5, nsub])';
lineplot_columns(predicted_ratings_reshaped, 'color', [.7 .3 .3], 'markerfacecolor', [1 .5 0]);
% xlabel('True Rating');
ylabel('Predicted Rating')
set(gca,'FontSize',20);
set(gca,'linewidth', 2)
set(gca, 'XTick', 1:5)
xlim([0.8 5.2])
% set(gcf, 'Color', 'w');
% export_fig Validation_whole-brain_prediction -tiff -r500