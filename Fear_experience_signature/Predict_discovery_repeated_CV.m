
% the discovery dataset is available at https://figshare.com/articles/dataset/Subjective_fear_dataset/13271102
load('Discovery_dataset.mat')
load('fear_datasets_idx.mat')

nsub = 67;
nrepeat = 10; % for 10X10 cross-validation
nlevel = 5; % 5 ratings
predicted_ratings = zeros(length(discovery.Y),nrepeat);

for repeat = 1:nrepeat
    CVindex = GenerateCV(nsub, nlevel, repeat); 
    CVindex = CVindex(discovery_label_idx);
    [~, stats] = predict(discovery,  'algorithm_name', 'cv_svr', 'nfolds', CVindex, 'error_type', 'mse');
    predicted_ratings(:, repeat) = stats.yfit;
end

%% overall (between- and within-subjects) prediction-outcome correlations
true_ratings = discovery.Y;
prediction_outcome_corrs = corr(true_ratings, predicted_ratings);

%% Within-subject (5 or 4 pairs) prediction-outcome correlations
subject = repmat(1:nsub, nlevel,1);
subject = subject(:);
subject = subject(discovery_label_idx);

within_subj_corrs = zeros(nsub, nrepeat);
within_subj_rmse = zeros(nsub, nrepeat);
for n = 1:nrepeat
    for i = 1:nsub
    subY = true_ratings(subject==i);
    subyfit = predicted_ratings(subject==i, n);
    within_subj_corrs(i, n) = corr(subY, subyfit);
    err = subY - subyfit;
    mse = (err' * err)/length(err);
    within_subj_rmse(i, n) = sqrt(mse);
    end
end

%% classifications
Accuracy_per_level = zeros(nrepeat, 4);
Accuracy_se_per_level = zeros(nrepeat, 4);
Accuracy_p_per_level = zeros(nrepeat, 4);
Accuracy_low_medium_high = zeros(nrepeat, 3);
Accuracy_se_low_medium_high = zeros(nrepeat, 3);
Accuracy_p_low_medium_high = zeros(nrepeat, 3);
for n = 1:nrepeat
    PE = predicted_ratings(:, n);
    PE = [PE(1:end-4); NaN; PE(end-3:end); NaN]; % include rating 5 for last two subjects
    PE = reshape(PE, [5, nsub])';
    PE_low = nanmean(PE(:, 1:2), 2);
    PE_medium = PE(:, 3);
    PE_high = nanmean(PE(:, 4:5), 2);
    % level 2 vs. 1
    ROC = roc_plot([PE(:, 2);PE(:,1)], [ones(nsub,1);zeros(nsub,1)], 'twochoice');
    Accuracy_per_level(n, 1) = ROC.accuracy;
    Accuracy_se_per_level(n, 1) = ROC.accuracy_se;
    Accuracy_p_per_level(n, 1) = ROC.accuracy_p;
    % level 3 vs. 2
    ROC = roc_plot([PE(:, 3);PE(:,2)], [ones(nsub,1);zeros(nsub,1)], 'twochoice');
    Accuracy_per_level(n, 2) = ROC.accuracy;
    Accuracy_se_per_level(n, 2) = ROC.accuracy_se;
    Accuracy_p_per_level(n, 2) = ROC.accuracy_p;
    % level 4 vs. 3
    ROC = roc_plot([PE(:, 4);PE(:,3)], [ones(nsub,1);zeros(nsub,1)], 'twochoice');
    Accuracy_per_level(n, 3) = ROC.accuracy;
    Accuracy_se_per_level(n, 3) = ROC.accuracy_se;
    Accuracy_p_per_level(n, 3) = ROC.accuracy_p;
    % level 5 vs. 4
    ROC = roc_plot([PE(1:end-2, 5);PE(1:end-2,4)], [ones(nsub-2,1);zeros(nsub-2,1)], 'twochoice');
    Accuracy_per_level(n, 4) = ROC.accuracy;
    Accuracy_se_per_level(n, 4) = ROC.accuracy_se;
    Accuracy_p_per_level(n, 4) = ROC.accuracy_p;
    % low vs. meduim
    ROC = roc_plot([PE_medium;PE_low], [ones(nsub,1);zeros(nsub,1)], 'twochoice');
    Accuracy_low_medium_high(n,1) = ROC.accuracy;
    Accuracy_se_low_medium_high(n,1) = ROC.accuracy_se;
    Accuracy_p_low_medium_high(n,1) = ROC.accuracy_p;
    % medium vs. high
    ROC = roc_plot([PE_high;PE_medium], [ones(nsub,1);zeros(nsub,1)], 'twochoice');
    Accuracy_low_medium_high(n,2) = ROC.accuracy;
    Accuracy_se_low_medium_high(n,2) = ROC.accuracy_se;
    Accuracy_p_low_medium_high(n,2) = ROC.accuracy_p;
    % low vs. high
    ROC = roc_plot([PE_high;PE_low], [ones(nsub,1);zeros(nsub,1)], 'twochoice');
    Accuracy_low_medium_high(n,3) = ROC.accuracy;
    Accuracy_se_low_medium_high(n,3) = ROC.accuracy_se;
    Accuracy_p_low_medium_high(n,3) = ROC.accuracy_p;
end

%% plot
create_figure('Whole-brain Prediction');
predicted_ratings_reshaped = mean(predicted_ratings, 2);
predicted_ratings_reshaped = [predicted_ratings_reshaped(1:end-4); NaN; predicted_ratings_reshaped(end-3:end); NaN]; 
predicted_ratings_reshaped = reshape(predicted_ratings_reshaped, [5, nsub])';
lineplot_columns(predicted_ratings_reshaped, 'color', [.7 .3 .3], 'markerfacecolor', [1 .5 0]);
xlabel('True Rating');
ylabel('Predicted Rating')
set(gca,'FontSize',20);
set(gca,'linewidth', 2)
set(gca, 'XTick', 1:5)
xlim([0.8 5.2])
ylim([0 5])
set(gcf, 'Color', 'w');
% export_fig Discovery_whole-brain_prediction -tiff -r500