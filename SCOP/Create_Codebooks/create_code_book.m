function create_code_book(D,M,N, outfile)

%THIS VERSION NORMALIZES ALL FEATURES AND CREATES SAMPLED VECTORS USING
%NON_OVERLAPPING SAMPLES!!!

%D = cell array of features for each sequence
%M = Number of clusters
%N = Window size for each feature (each vector will be length P*N)


%different features should be accross rows in each cell of D
%P is the number of features
P = size(D{1}, 1);



%Since we are going to have a large number of vectors lets determine the
%ammount of memory needed

%size_V is number of rows in our vector container
size_V = 0;
for i = 1:length(D)
    
    size_V = size_V + floor(size(D{i},2)/N);

end


%create a empty container for our vectors, letting V grow to a large size
%inside a loop will greatly slow down the program

V = zeros(size_V, N*P);
V_counter = 1;


%loop through and save each vector for each sequence
for i = 1:length(D)
    this_D = D{i};
    for j = 0:floor(size(this_D,2)/N)-1

        start = (j * N)+1;
        stop = start + (N -1);
        V(V_counter,:) = reshape( this_D(:,start:stop)', 1,  N*P);
        V_counter = V_counter + 1;
    end
  
end


%create a container for our means and standard deviations
means = zeros(1,P);
stds = zeros(1,P);

%go through each feature (row in a cell of D) and normalize its VQ, treats each feature block as
%a long vector
for i = 0:P-1

    start = (i*N)+1;
    stop = start + (N-1);
    [means(i+1),stds(i+1),V(:,start:stop)] = normalize_matrix(V(:,start:stop));
end


%create clusters using k-means
fprintf(1,'starting to cluster\n');

[CLUST_ID, CENTROIDS] = kmeans(V, M,'emptyaction', 'drop','display','iter'); %#ok<ASGLU,NASGU>

%use this method for large values for M
%[CENTROIDS, CLUST_ID, err] = som_kmeans('seq',V, M, 1, 3);


%[CENTROIDS, means, stds, CLUST_ID] outfile


save(outfile, 'CENTROIDS', 'means', 'stds');
save([outfile '_other'], 'V', 'CLUST_ID', '-v7.3');




