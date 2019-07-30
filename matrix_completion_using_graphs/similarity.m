function [sim_mat] = similarity(X, sim_measure)
% Compute similarity between rows of the matrix X.
% 
% X - we need to compute similarity between rows of this matrix
% sim_measure - e.g. cosine

n_rows = size(X,1);
sim_mat = zeros(n_rows,n_rows);

for row1=1:n_rows
    X_row1 = X(row1,:);
    for row2=1:n_rows
        % Computing similarity between X_row1 and X_row2. Similarity is the 
        % measure of weight of the edge between X_row1 and X_row2 vertices
        X_row2 = X(row2,:);
        % Indices of the values which are present in both X_row1 and X_row2
        co_indices = X_row1.*X_row2 > 0;
        % Cosine similarity
        if size(X_row1(co_indices), 2) > 0
            cos_sim = 1 - pdist([X_row1(co_indices);X_row2(co_indices)], sim_measure);
        else
            cos_sim = 0;
        end
        sim_mat(row1,row2) = cos_sim;
    end
end

end

