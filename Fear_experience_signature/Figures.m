%% Fig. 1
% surface plot (Fig. 1A)
VIFS_thresholded = fmri_data('VIFS_FDR_05.nii', 'GM_mask.nii');
surface(VIFS_thresholded);


% plot unthresholded ROIs (Fig. 1B)
clear dat
dat = fmri_data('VIFS.nii', 'ACC.nii');
regions = region(dat);
info = roi_contour_map(regions(1,1), 'cluster', 'use_same_range', 'xyz', 1, 'coord', -2, 'color', color);
set(gca, 'XDir','reverse')
set(gcf, 'Color', 'w');

clear dat
dat = fmri_data('VIFS.nii', 'PAG.nii');
regions = region(dat);
info = roi_contour_map(regions(1,1), 'cluster', 'use_same_range', 'xyz', 1, 'coord', 2);
set(gca, 'XDir','reverse')
set(gcf, 'Color', 'w');

clear dat
dat{1} = region(fmri_data('VIFS.nii', 'Amy_left.nii'));
dat{2} = region(fmri_data('VIFS.nii', 'Amy_right.nii'));
info = roi_contour_map([dat{1} dat{2}], 'cluster', 'use_same_range', 'xyz', 2, 'coord', -2);
set(gca, 'XDir','reverse')
set(gcf, 'Color', 'w');

clear dat
dat{1} = region(fmri_data('VIFS.nii', 'Insula_left.nii'));
dat{2} = region(fmri_data('VIFS.nii', 'Insula_right.nii'));
info = roi_contour_map([dat{1} dat{2}], 'cluster', 'use_same_range', 'xyz', 3, 'coord', -6);
set(gca, 'XDir','reverse')
set(gcf, 'Color', 'w');

%% Fig. 2
% for lineplot (e.g., Fig. 2B,C,F,G) see
% Predict_discovery_repeated_CV, Predict_validation and Predict_generalization

% the Fig. 2D,E were plotted using the fillsteplot function
load('TimeSeriesPE_discovery.mat'); % discovery
% load('TimeSeriesPE_validation.mat'); % valdiation
fillsteplot(r1, [50 136 189]/255);
hold on
fillsteplot(r2, [102 194 165]/255);
fillsteplot(r3, [171 221 164]/255);
fillsteplot(r4, [244 109 67]/255);
fillsteplot(r5, [158 1 66]/255);

set(gca,'XTickLabel', { '0','1', '2', '3', '4','5','6', '7', '8', '9'}, 'FontWeight','bold', 'linewidth', 4,'FontSize', 10);
set(gca,'YTick',-30:20:50,'FontWeight','bold', 'linewidth', 4,'FontSize', 10);
plot(mean(r1),'ko','MarkerFaceColor',[50 136 189]/255,'MarkerSize',16,'LineWidth',2);
plot(mean(r2),'ko','MarkerFaceColor',[102 194 165]/255,'MarkerSize',16,'LineWidth',2);
plot(mean(r3),'ko','MarkerFaceColor',[171 221 164]/255,'MarkerSize',16,'LineWidth',2);
plot(mean(r4),'ko','MarkerFaceColor',[244 109 67]/255,'MarkerSize',16,'LineWidth',2);
plot(mean(r5),'ko','MarkerFaceColor',[158 1 66]/255,'MarkerSize',16,'LineWidth',2); 

ylabel('Fear Pattern Expression','FontWeight','bold','FontSize', 20);
xlabel('TR ','FontWeight','bold','FontSize', 20);

%% Fig. 3
% Fig. 3 was plotted using surface (CanlabCore) and 
% brain_activations_wani (cocoanCORE) functions
% corresponding thresholded map are available at https://figshare.com/articles/dataset/Subjective_fear_dataset/13271102

%% Fig. 4
% the function evaluate_spatial_scale (CanlabCore) was used to obtain Fig. 4D
load('Fear_spatial_scale_10CV_1000iters.mat')

num_feats_full = num_feats.num_feats_full;
num_feats_within = num_feats.num_feats_within;
num_feats_conscious = num_feats.num_feats_conscious;
num_feats_subcortical = num_feats.num_feats_subcortical;

pred_outcome_r_full = pred_outcome.pred_outcome_r_full;
pred_outcome_r = pred_outcome.pred_outcome_r;
pred_outcome_r_conscious = pred_outcome.pred_outcome_r_conscious;
pred_outcome_r_subcortical = pred_outcome.pred_outcome_r_subcortical;


num_iterations = 1000;
num_parcels = 7;

mycolors={[166 206 227]/255 [31 120 180]/255  [178 223 138]/255  [51 160 44]/255  [251 154 153]/255  [106 61 154]/255  [255 127 0]/255 [227 26 28]/255 [202 178 214]/255};

for it=1:num_iterations
    [~, ~,x_wb(it,:),y_wb(it,:)] = createFit(num_feats_full(:)', pred_outcome_r_full(it,:),'color',[.2 .2 .2],'linewidth',2);
    [~, ~,x_cons(it,:),y_cons(it,:)] = createFit(num_feats_conscious(:)', pred_outcome_r_conscious(it,:),'color',mycolors{end-1},'linewidth',2);
    [~, ~,x_subcortical(it,:),y_subcortical(it,:)] = createFit(num_feats_subcortical(:)', pred_outcome_r_subcortical(it,:),'color',mycolors{end},'linewidth',2);
    for r=1:num_parcels
        r_within=squeeze((pred_outcome_r(it,r,1:size(pred_outcome_r,3))));
        [~, ~,x{it,r},y{it,r}] = createFit(num_feats_within(r,:)', r_within(:),'color',mycolors{r},'linewidth',2);
    end
end

close all;
figure;
hold on;
boundedline(mean(x_wb),mean(y_wb), std(y_wb),'alpha', 'cmap',[.2 .2 .2]);
boundedline(mean(x_cons), mean(y_cons), std(y_cons),'alpha', 'cmap',mycolors{end-1});
boundedline(mean(x_subcortical), mean(y_subcortical), std(y_subcortical),'alpha', 'cmap',mycolors{end});
for r=1:num_parcels
    clear to_plot_x to_plot_y
    for i=1:size(x,1)
        to_plot_x(i,:)=x{i,r};
        to_plot_y(i,:)=y{i,r};
    end
    x_parcels{r, 1} = mean(to_plot_x);
    y_parcels{r, 1} = mean(to_plot_y);
    boundedline(mean(to_plot_x), mean(to_plot_y), std(to_plot_y),'alpha', 'cmap',mycolors{r}); 
end

h=findobj(gca,'type','line');
set(h,'linewidth',2);
set(gca,'XScale','log')
atlas_labels=networknames;

% pay attention to the legend, which was tested on MATLAB 2015b (might be different on later version?)
% legend(h(1:end),{atlas_labels{:} 'All Parcels' 'Whole-brain'},'Location','SouthEast');
legend(h(end:-1:1),{'Whole-brain', atlas_labels{end-1}, atlas_labels{end}, atlas_labels{1:7}},'Location','SouthEast');
xlabel('Number of voxels', 'FontWeight', 'BOLD')
ylabel('Prediction-outcome correlation','FontWeight', 'BOLD')
xlim([40 1000000])
set(gca, 'YTick', 0.1:0.1:0.6, 'LineWidth',2, 'FontWeight', 'BOLD')
plot(num_feats_full, mean(pred_outcome_r_full), '.', 'markersize', 20, 'color',[.2 .2 .2]);
plot(num_feats_conscious, mean(pred_outcome_r_conscious), '.', 'markersize', 20, 'color',mycolors{end-1});
plot(num_feats_subcortical, mean(pred_outcome_r_subcortical), '.', 'markersize', 20, 'color',mycolors{end});
for  r=1:num_parcels
    plot(num_feats_within(r,:), mean(squeeze(pred_outcome_r(:, r, :))), '.', 'markersize', 20, 'color',mycolors{r});
end
%% Fig. 5
% script used to generate Fig. 5C (scatter plot) can be available from 
% Koban et al. 2019, Nature Communications 