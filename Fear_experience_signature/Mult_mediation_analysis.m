clear, clc
%% discovery dataset
load('Mediation_discovery_VIF3.mat')
for n = 1:10
for i = 1:67
    fear_PE{1,i} = PEs{i,1}(:, n);
end
% PINES --> PIFS --> FEAR RESPONSE
[paths_norm{n,1}, toplevelstats_norm{n,1}, indlevelstats_norm{n,1}] = mediation(PINES_PE, fear_rating, fear_PE, 'verbose', 'boot', 'bootsamples', 100000, 'doCIs');

% PIFS --> PINES --> FEAR RESPONSE
[paths_reverse{n,1}, toplevelstats_reverse{n,1}, indlevelstats_reverse{n,1}] = mediation(fear_PE, fear_rating, PINES_PE, 'verbose', 'boot', 'bootsamples', 100000, 'doCIs');
end

for i = 1:10
    norm_mean_path(i,:) = toplevelstats_norm{i, 1}.mean;
    norm_ste_path(i,:) = toplevelstats_norm{i, 1}.ste;
    norm_p_path(i,:) = toplevelstats_norm{i, 1}.p;
    norm_ci_lower_path(i,:) = toplevelstats_norm{i, 1}.ci(:,:,1);
    norm_ci_upper_path(i,:) = toplevelstats_norm{i, 1}.ci(:,:,2);
    norm_z_path(i,:) = toplevelstats_norm{i, 1}.z;
end

for i = 1:10
    reverse_mean_path(i,:) = toplevelstats_reverse{i, 1}.mean;
    reverse_ste_path(i,:) = toplevelstats_reverse{i, 1}.ste;
    reverse_p_path(i,:) = toplevelstats_reverse{i, 1}.p;
    reverse_ci_lower_path(i,:) = toplevelstats_reverse{i, 1}.ci(:,:,1);
    reverse_ci_upper_path(i,:) = toplevelstats_reverse{i, 1}.ci(:,:,2);
    reverse_z_path(i,:) = toplevelstats_reverse{i, 1}.z;
end

%% validation dataset
load('Mediation_validation_VIF3.mat')
% PINES --> PIFS --> FEAR RESPONSE
[paths, toplevelstats, indlevelstats] = mediation(PINES_PE, fear_rating, fear_PE, 'verbose', 'boot', 'bootsamples', 100000, 'doCIs');

% PIFS --> PINES --> FEAR RESPONSE
[paths, toplevelstats, indlevelstats] = mediation(fear_PE, fear_rating, PINES_PE, 'verbose', 'boot', 'bootsamples', 100000, 'doCIs');

