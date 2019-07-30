function [processed_data, gene_names, gene_ids] = process(data,dataname, gene_names, gene_ids)


min_count=2; min_cells=3;

%% Removing BAD genes
cs= sum(data>min_count);
x_use_genes = find(cs>min_cells);

gene_filtered_data=data(:,x_use_genes);
if(length(gene_names)>0) 
    gene_names=gene_names(x_use_genes);
end
if(length(gene_ids)>0) 
   gene_ids=gene_ids(x_use_genes); 
end

%% Median normalization
libsize  = sum(gene_filtered_data,2);
    if (strcmp(dataname,'Mousebrain'))
        save(['Temp/' dataname '_mcimputeProcessing_libsize_' num2str(nlabels) 'labels.mat'],'libsize');
    else
        save(['Temp/' dataname '_mcimputeProcessing_libsize.mat'],'libsize');
    end
    geneFiltered_normed_data = bsxfun(@rdivide, gene_filtered_data, libsize) * median(libsize);

%OPTIONAL: select top 1000 most dispersed genes    
[geneFiltered_normed_featureSelected_data,topK_indices] = selectTopK_mostDispersedGenes(geneFiltered_normed_data, 1000);

if(length(gene_names)>0) 
    gene_names=gene_names(topK_indices);
end
if(length(gene_ids)>0) 
   gene_ids=gene_ids(topK_indices); 
end

%% Log transform
processed_data = log2(1 +geneFiltered_normed_featureSelected_data );

end

