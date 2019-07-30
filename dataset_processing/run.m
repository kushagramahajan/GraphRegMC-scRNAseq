%change processed data part in deepMc--was done for data2
clear;  clc;
tic

global data_dir;
data_dir='/home/harish/Monsoon2018/CF/Project/datasets/';

% addpath(genpath('..\Dependencies')); 
% addpath(genpath([ data_dir 'scripts2read']));

dataname='Jurkat' %'Blakeley' %'Zeisel' %'Kolodziejczyk' %'Jurkat'%'Preimplantation'%'Kolodziejczyk'
%'Quake' %'Usoskin' 
                         %'Preimplantation' %'Jurkat 
mkdir(['RecMatrices/' dataname]); 

%name=strcat(strcat(['RecMatrices/']))
sample_dir = [data_dir 'raw_data/' dataname '_dataset/hg19'];
pro_dir=[data_dir 'processed_data/'];

gene_names=[]; gene_ids=[];
 
%% Data read
if(strcmp(dataname, 'Preimplantation') | strcmp(dataname, 'Jurkat') )
    [data, gene_names, gene_ids, cells] = read_raw_10x( strcmp(dataname,'Preimplantation') ,sample_dir);% 0 for jurkat,1 for zygote
elseif (strcmp(dataname,'Trapnell'))
    % do pro=0; in process.m
    load('D:/AanchalMongia_phdClg/Phd/R_workspace/dropOutHandlingExperiment/data2_processed_allCelltypesNGenes.mat')
    data=good_pseudo_count;
else
    data=csvread([data_dir 'raw_data/' dataname '_dataset/'  dataname '_raw_data.csv'],1,1)' ;

    %read gene names/ids
    ncells=size(data,1); 
    temp=readtable([data_dir 'raw_data/' dataname '_dataset/'  dataname '_raw_data.csv'],'Format',['%s' repmat('%f',[1 ncells]) '%[^\n\r]']); 
    gene_names=table2cell(temp(:,1));
end

rng(0);

% Process the dataset.
[processed_data, gene_names, gene_ids] = process(data, dataname, gene_names, gene_ids);
pro_dir = [data_dir 'processed_data/' dataname '_dataset'];
mkdir(pro_dir);
save([pro_dir '/' dataname '_processed_data.mat'], 'processed_data');
save([pro_dir '/' dataname '_top_100_genes.mat'], 'gene_names');

%% CALL DeepMC
%nlayers=1; rank=10;%jurkat rank=5; %pre rank=13; 14 gave best on 1k genes
%[Xrec,~,~,~,genes_pruned]=call_deepMc(data,nlayers,rank,'dataname',dataname,'gene_names',gene_names);

%nlayers=2; rank=[10 5];%jurkat rank=[10 6]; %pre rank=[13 11]; %13
%[Xrec]=call_deepMc(data,nlayers,rank,'dataname',dataname);

%nlayers=3; rank=[10 5 2];% jurkat rank=[5 3 2];%pre rank=[13 12 11]; %13
%[Xrec]=call_deepMc(data,nlayers,rank,'dataname',dataname);

%time_taken=toc 
%{
actual_labels=eval(['get_numeric_labels_' dataname '(  )']) ;

list_ni=[]; list_dmc=[];
for (i=1:100) 
loc=randperm(length(actual_labels),length(unique(actual_labels)));
load([pro_dir]); 
ari_ni=call_kmeans(processed_data,'PCA', loc ,actual_labels); list_ni=[list_ni ari_ni]; 
ari_dmc=call_kmeans(data_recovered,'PCA', loc ,actual_labels); list_dmc=[list_dmc ari_dmc]; 
end 
avg_ari_ni=mean(list_ni)
avg_ari_mc=mean(list_dmc)
%}