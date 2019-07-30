clear;
clc;

% Script to process datasets - save processed data and 
% laplacians of its row and column graphs.

% dataset = 'Blakeley'; % 30 x 1000
% dataset = 'Kolodziejczyk'; % 704 x 1000
% dataset = 'Quake'; % 461 x 1000
% dataset = 'Usoskin'; % 622 x 1000
% dataset = 'Zeisel'; % 3005 x 1000
% dataset = 'Preimplantation'; % 317 x 1000
dataset = 'Jurkat'; % 3388 x 1000

data_dir = ['/home/harish/Monsoon2018/CF/Project/datasets/processed_data/' dataset '_dataset/'];
data = load([data_dir dataset '_processed_data.mat']);

X = data.processed_data;

% Computing Wr -- weights of row graph of X
Wr = similarity(X, 'cosine');
% Computing Wc -- weights of column graph of X
Wc = similarity(X.', 'cosine');

%Dr = diag(sum(Wr, 2));
%Dc = diag(sum(Wc, 2));

% Laplacian of the row graph of X
%Lr = Dr - Wr;
% Laplacian of the column graph of X
%Lc = Dc - Wc;

save([dataset '.mat'], 'X', 'Wr', 'Wc');
