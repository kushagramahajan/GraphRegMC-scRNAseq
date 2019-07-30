clear;
clc;

% dataset_mat = 'Blakeley.mat'; % Blakeley, Quake, Usoskin
% Wr_thresh = 0.90;
% Wc_thresh = 0.99;
% train_split = 0.2;
% maxit = 100;
% verbose = 1;
% gamma_n = 0.01;
% gamma_r = 0.003;
% gamma_c = 0.003;
% rho_ADMM = 0.009;

dataset_mat = 'Preimplantation.mat'; % Kolodziejczyk, Zeisel, Preimplantation, Jurkat
Wr_thresh = 0.93;
Wc_thresh = 0.99;
train_split = 0.5;
maxit = 40;
verbose = 1;
gamma_n = 5;
gamma_r = 0.003;
gamma_c = 0.003;
rho_ADMM = 0.01;

% X - matrix that we want to complete
% X_MC_graphs - matrix completed using graph based approach
% X_MC_low_rank - matrix completed using nuclear norm minimization approach
[X, X_MC_graphs, X_MC_low_rank] = run_ADMM(dataset_mat, Wr_thresh, Wc_thresh, train_split, maxit, verbose, gamma_n, gamma_r, gamma_c, rho_ADMM);
