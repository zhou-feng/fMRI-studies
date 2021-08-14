load('Discovery_dataset.mat')
load('Validation_dataset.mat')
load('Generalization_dataset.mat')
discovery_data = double(discovery.dat');
discovery_label = discovery.Y;
clear discovery

for i = 1:10000
    discovery_perm_label = discovery_label(randperm(length(discovery_label)));
    dataobj = data('spider data', discovery_data, discovery_perm_label);
    svrobj = svr({'C=1', 'optimizer="andre"', kernel('linear')});
    [~, svrobj] = train(svrobj, dataobj, loss);
    discovery_perm_weight(i,:)= get_w(svrobj); % used for similarity analysis
    validation_PE = double(validation.dat')*discovery_perm_weight(i,:)';
    perm_pred_validation(i, 1) = corr(validation.Y, validation_PE);
    generalization_PE = double(generalization.dat')*discovery_perm_weight(i,:)';
    perm_pred_generalization(i, 1) = corr(generalization.Y, generalization_PE);
end

