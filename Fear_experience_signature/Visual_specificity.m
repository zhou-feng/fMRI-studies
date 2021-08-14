% clear, clc

load('VIFS_response_cv.mat')
vifs = mean(vifs, 3);

load('Visual_features.mat')

edge = features(:, 1);
saliency = features(:, 2);
congestion = features(:, 4);
entropy = features(:, 5);

for i = 1:10
    redge(i,1) = corr(edge, response(1,:,i)');
    rsaliency(i,1) = corr(saliency, response(1,:,i)');
    rcongestion(i,1) = corr(congestion, response(1,:,i)');
    rentropy(i,1) = corr(entropy, response(1,:,i)');
end


mean(rsaliency)
mean(rcongestion)
mean(redge)
mean(rentropy)



for i = 1:67
    subvifs = vifs(i,:);
    idx = isnan(subvifs);
    subvifs(idx) = [];
    subedge= edge;
    subedge(idx) = [];
    subsaliency = saliency;
    subsaliency(idx) = [];
    subcongestion = congestion;
    subcongestion(idx) = [];
    subentropy = entropy;
    subentropy(idx) = [];
    corrs_edge(i, 1) = corr(subvifs', subedge);
    corrs_saliency(i, 1) = corr(subvifs', subsaliency);
    corrs_congestion(i, 1) = corr(subvifs', subcongestion);
    corrs_entropy(i, 1) = corr(subvifs', subentropy);
end


[h, p] = ttest(corrs_fear- corrs_saliency)
[h, p] = ttest(corrs_fear- corrs_congestion)
[h, p] = ttest(corrs_fear- corrs_entropy)
[h, p] = ttest(corrs_fear- corrs_edge)