function pattern = fast_haufe(data,weights,Nbricks)
% FAST_HAUFE conducts the Haufe transform on model weights to
% generate an encoding (forward) model from a decoding (backward)
% model.
%
%   [pattern] = FAST_HAUFE(data,weights,Nbricks)
%
%   ARGUMENTS 
%     data = data on which the model was computed
%
%     weights = model parameters (e.g., SVM hyperplane)
%
%     Nbricks = number of groups of data to operate on 
%               in batch.  size(data)/Nbricks determines
%               the memory load of the Haufe transform.
%               More bricks should be computationally 
%               faster as linear algebra loops conducted
%               in C rather than Matlab script.
%
%   OUPUTS
%     pattern = forward model
%
%   REFERENCES
%     Haufe, 2014
%     TDT Toolbox, 2015

    %data = data(cfg.design.train(:, i_model) > 0, :);
    [n_samples n_dim] = size(data);
    
    scale_param = cov(weights'*data');
    pattern_unscaled = zeros(n_dim,1);
    for i = 1:n_dim % remove mean columnwise
        data(:,i) = data(:,i) - mean(data(:,i));
    end
    
    %%Note, doing it columnwise b/c too big to fit in memory 
    %%using data'*data (Ndim x Ndim matrix)
    % fprintf(repmat(' ',1,20))
    % backstr = repmat('\b',1,20);

    %%
    %% Set-up bricks
    %%
    Nbricks = min(Nbricks,n_dim);
    brick_n=floor(n_dim./Nbricks);
    index=1;

    %% Randomly assign TRs into one of Nfolds
    for n=1:Nbricks
        
        %%Select id group
        if n<Nbricks
            ids = ((n-1)*brick_n+1):(n*brick_n);
        elseif n==Nbricks %%stick TRs (not evenly divisible) last fold
            ids = ((n-1)*brick_n+1):n_dim;
        end

        %%Generate unscaled forward models values
        data_cov = (data(:,ids)'*data)/(n_samples-1);
        pattern_unscaled(ids,1) = data_cov * weights;

        disp(['  -Haufe transform chunk: ',num2str(n)]);
        % %%Progress report
        % backstr = repmat('\b',1,20);
        % fprintf([backstr '%03.0f percent finished'],100*(max(ids)/n_dim))

    end
    
    % fprintf('\ndone.\n')
    pattern = pattern_unscaled / scale_param; % like cov(X)*W * inv(W'*X')
       
 end