%% @author: Gursimran Singh

%% Description:
%   Runs clustering analysis on the old and new matrices obtained by
%   running `main.m`

% Clean the working environment
clearvars;
% 
% Dataset name
dataset = 'Jurkat';
% 
% Load `X`, `X_MC_graphs` and `X_MC_low_rank`
completedMatrices_dirpath = '/Users/gursimransingh/Workspace/cse640-cf/course-project/workspace/datasets/completed_matrices/';
f__completedMatrices = [completedMatrices_dirpath dataset '_completedMatrices.mat'];
load(f__completedMatrices, 'X__original', 'X__MC_graphs', 'X__MC_lowRank');
disp(size(X__original));
disp(size(X__MC_graphs));
disp(size(X__MC_lowRank));
% 
% Annotation file for dataset
annotations_dirpath = '/Users/gursimransingh/Workspace/cse640-cf/course-project/workspace/datasets/mat_annotations/';
f__annotations = [annotations_dirpath dataset '_annotations.mat'];
load(f__annotations, 'anno');
disp(size(anno));
%
% Unique cluster ids
cluster_labels = unique(anno);
[K, ~] = size(cluster_labels);
% Change annotations to numerical
[N, ~] = size(anno);
anno_numerical = zeros(N, 1);
for n = 1:N
    for k = 1:K
        if strcmpi(anno{n}, cluster_labels{k}) == 1
            anno_numerical(n, 1) = k;
        end
    end
end
% 
% Run clustering algorithm
X__original__predictedClusters = kmeans(X__original, K);
X__MC_graphs__predictedClusters = kmeans(X__MC_graphs, K);
X__MC_lowRank__predictedClusters = kmeans(X__MC_lowRank, K);
% 
% Run PCA
[X__MC_graphs__pca_coeff, ...
    X__MC_graphs__pca_score, ...
    X__MC_graphs__pca_latent, ...
    X__MC_graphs__pca_tsquared,...
    X__MC_graphs__pca_explained, ...
    X__MC_graphs__pca_mu] = pca(X__MC_graphs);
[X__MC_lowRank__pca_coeff, ...
    X__MC_lowRank__pca_score, ...
    X__MC_lowRank__pca_latent, ...
    X__MC_lowRank__pca_tsquared,...
    X__MC_lowRank__pca_explained, ...
    X__MC_lowRank__pca_mu] = pca(X__MC_lowRank);
% 
% Eval: Rand Index
X__original__ri = rand_index(anno_numerical, X__original__predictedClusters)
X__MC_graphs__ri = rand_index(anno_numerical, X__MC_graphs__predictedClusters)
X__MC_lowRank__ri = rand_index(anno_numerical, X__MC_lowRank__predictedClusters)
% Eval: Adjusted Rand Index
X__original__ari = rand_index(anno_numerical, X__original__predictedClusters, 'adjusted')
X__MC_graphs__ari = rand_index(anno_numerical, X__MC_graphs__predictedClusters, 'adjusted')
X__MC_lowRank__ari = rand_index(anno_numerical, X__MC_lowRank__predictedClusters, 'adjusted')
% Eval: Adjusted Mutual Information
X__original__ami = ami(anno_numerical, X__original__predictedClusters)
X__MC_graphs__ami = ami(anno_numerical, X__MC_graphs__predictedClusters)
X__MC_lowRank__ami = ami(anno_numerical, X__MC_lowRank__predictedClusters)
% Eval: Normalized Mutual Information
X__original__nmi = nmi(anno_numerical, X__original__predictedClusters)
X__MC_graphs__nmi = nmi(anno_numerical, X__MC_graphs__predictedClusters)
X__MC_lowRank__nmi = nmi(anno_numerical, X__MC_lowRank__predictedClusters)