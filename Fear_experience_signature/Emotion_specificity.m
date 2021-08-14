clear, clc

load('Online_ratings.mat')

mfear = mean(fear);
mdisgust = mean(disgust);
marousal = mean(arousal);
mangry = mean(angry);
mvalence = mean(valence);
msadness = mean(sadness);

load('VIFS_response_cv.mat')
vifs = nanmean(vifs);

for i = 1:10
    rfear(i,1) = corr(mfear', vifs(1,:,i)');
    rdisgust(i,1) = corr(mdisgust', vifs(1,:,i)');
    rarousal(i,1) = corr(marousal', vifs(1,:,i)');
    rangry(i,1) = corr(mangry', vifs(1,:,i)');
    rvalence(i,1) = corr(mvalence', vifs(1,:,i)');
    rsadness(i, 1) = corr(msadness', vifs(1,:,i)');
end

mean(rfear)
mean(rdisgust)
mean(rangry)
mean(rsadness)
mean(rarousal)
mean(rvalence)


load('VIFS_response_cv.mat')
vifs = mean(vifs, 3);
for i = 1:67
    subvifs = vifs(i,:);
    idx = isnan(subvifs);
    subvifs(idx) = [];
    subfear = mfear;
    subfear(idx) = [];
    subdisgust = mdisgust;
    subdisgust(idx) = [];
    subarousal = marousal;
    subarousal(idx) = [];
    subangry = mangry;
    subangry(idx) = [];
    subvalence = mvalence;
    subvalence(idx) = [];
    subsadness = msadness;
    subsadness(idx) = [];
    corrs_fear(i, 1) = corr(subvifs', subfear');
    corrs_disgust(i, 1) = corr(subvifs', subdisgust');
    corrs_arousal(i, 1) = corr(subvifs', subarousal');
    corrs_angry(i, 1) = corr(subvifs', subangry');
    corrs_valence(i, 1) = corr(subvifs', subvalence');
    corrs_sadness(i, 1) = corr(subvifs', subsadness');
end
[h, p] = ttest(corrs_fear - corrs_disgust)
[h, p] = ttest(corrs_fear - corrs_angry)
[h, p] = ttest(corrs_fear - corrs_sadness)
[h, p] = ttest(corrs_fear - corrs_arousal)
[h, p] = ttest(corrs_fear - corrs_valence)