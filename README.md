# Imputation of Single Cell RNA Sequential Data using Graph Regularized Matrix Completion Model

Work done as part of final course project of Collaborative Filtering by -

1. Harish Fulara (harish14143@iiitd.ac.in)
2. Kushagra Mahajan (kushagra14055@iiitd.ac.in)
3. Gursimran Singh (gursimran14041@iiitd.ac.in)

### Drive Link 
https://drive.google.com/drive/folders/13ZS2S9FzWtVlJH_4icCGXZQKjx7iNKs9?usp=sharing

### Code Structure

1. `dataset_processing` directory contains the raw scRNA-seq datasets and the code to process them.
2. `matrix_completion_using_graphs` directory contains the code for graph regularized matrix completion model. Once we have processed the raw datasets, we pass them through this model for imputing missing values in gene-expression data.
3. `results` directory contains the results of our experiments to evaluate the performance of graph regularized matrix completion model against standard nuclear-norm based matrix completion model.

### References

1. Matrix Completion on Graphs - https://arxiv.org/pdf/1408.1717.pdf
2. McImpute: Matrix completion based imputation for single cell RNA-seq data - https://www.biorxiv.org/content/biorxiv/early/2018/07/14/361980.full.pdf
3. deepMc: deep Matrix Completion for imputation of single cell RNA-seq data - https://www.biorxiv.org/content/biorxiv/early/2018/08/09/387621.full.pdf
4. McImpute_scRNAseq - https://github.com/aanchalMongia/McImpute_scRNAseq
5. scRNA-seq-datasets - https://github.com/aanchalMongia/scRNA-seq-datasets
6. https://lts2.epfl.ch/research/reproducible-research/matrix-completion-on-graphs/
