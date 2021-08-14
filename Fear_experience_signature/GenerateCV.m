function CVindex = GenerateCV(nsub, nlevel, seed)
rng(seed)
nfold = 10;
CVO = cvpartition(nsub, 'KFold', nfold);
CVindex = zeros(nsub, 1);
for i = 1:nfold
    test = CVO.test(i);
    CVindex(test) = i;
end
CVindex = repmat(CVindex, 1, nlevel)';
CVindex = CVindex(:);
end