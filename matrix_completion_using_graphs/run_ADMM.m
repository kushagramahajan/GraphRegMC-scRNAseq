% dataset_mat - Name of the dataset matrix
% train_split - What fraction of observed entries we want for training.
%               1 - train_split fraction of entries will be used for validation

function [X, X_MC_graphs, X_MC_low_rank] = run_ADMM(dataset_mat, Wr_thresh, Wc_thresh, train_split, maxit, verbose, gamma_n, gamma_r, gamma_c, rho_ADMM)
%% Load the dataset.
load(dataset_mat, 'X', 'Wr', 'Wc');

%% Compute Laplacian of the row and column graphs of the dataset.
Wr = Wr > Wr_thresh;
Wc = Wc > Wc_thresh;

Dr = diag(sum(Wr, 2));
Dc = diag(sum(Wc, 2));

% Laplacian of the row graph of X
Lr = Dr - Wr;
% Laplacian of the column graph of X
Lc = Dc - Wc;

%% Train, validation, and test split.
[y_train, mask_train, y_val, mask_val, y_test, mask_test] = split_observed(X, [train_split, 1-train_split, 0]);

params.size_X = size(X);

%% Normalize data to zero mean and keep the linear transformation details
y_lims_init = [min(y_train), max(y_train)];

mean_train = mean(y_train);
y_train = y_train - mean_train;
y_val = y_val - mean_train;

y_lims_scaled = [min(y_train), max(y_train)];

%% PREPARE PROBLEM PARAMS
% GRAPHS: (normalized)
prob_params.Lr = Lr / max(Lr(:));
prob_params.Lc = Lc / max(Lc(:));

% DATASETS and masks:
prob_params.size_X = params.size_X;
prob_params.mask_val = mask_val;
prob_params.mask_test = mask_test;
prob_params.A_op = @(x) sample_sparse(x, mask_train);
prob_params.At_op = @(x) sample_sparse_t(x, mask_train);
prob_params.AtA_op = @(x) sample_sparse_AtA(x, mask_train);

%% SOLVER PARAMETERS
% TODO: Code to set these values using grid search.

solver_params.maxit = maxit;
solver_params.verbose = verbose;

solver_params.tol_abs = 2e-6;
solver_params.tol_rel = 1e-5;

% need the scaling used for preprocessing to calculate error correctly
solver_params.y_lims_init = y_lims_init;
solver_params.y_lims_scaled = y_lims_scaled;

% for small matrices use false!
solver_params.svds = false;

%% Solve the problem using graphs
% TODO: Code to set these values using grid search.
prob_params.gamma_n = gamma_n;
prob_params.gamma_r = gamma_r;
prob_params.gamma_c = gamma_c;
solver_params.rho_ADMM = rho_ADMM;

[X_MC_graphs, stat_MC_graphs] = MC_solve_ADMM(y_train, y_val, y_test, prob_params, solver_params);
min_idx = find(stat_MC_graphs.rmse_val == min(stat_MC_graphs.rmse_val));

% RMSE value is minimum for min_idx th iteration.
if min_idx ~= maxit
    solver_params.maxit = min_idx;
    [X_MC_graphs, stat_MC_graphs] = MC_solve_ADMM(y_train, y_val, y_test, prob_params, solver_params);
end

%% Solve without graphs, just low rank information
% TODO: Code to set these values using grid search.
prob_params.gamma_n = 3;
prob_params.gamma_r = 0;
prob_params.gamma_c = 0;
solver_params.rho_ADMM = .15;
solver_params.maxit = 100;

% Now ADMM is equivalent to forward backward algorithm!
[X_MC_low_rank, stat_MC_low_rank] = MC_solve_ADMM(y_train, y_val, y_test, prob_params, solver_params);

%%
%figure;
%plot(stat_MC_low_rank.rmse_val);
%disp(stat_MC_low_rank.rmse_val(end))
%hold all
%plot(stat_MC_graphs.rmse_val);
%disp(stat_MC_graphs.rmse_val(end));
%legend('low rank', 'low rank + graphs')
%title('Validation error of different models')
%xlabel('iteration')
%ylabel('RMSE')

end
