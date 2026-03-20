function create_code_book(D, M, N, size_V, outfile, maxIters)

%THIS VERSION NORMALIZES ALL FEATURES AND CREATES SAMPLED VECTORS BY
%RANDOMLY SAMPLING

%D = cell array of features for each sequence
%M = Number of clusters
%N = Window size for each feature (each vector will be length P*N)


%different features should be accross rows in each cell of D
%P is the number of features
P = size(D{1}, 1);



%Since we are going to have a large number of vectors lets determine the
%ammount of memory needed

%size_V is number of rows in our vector container
% size_V = 0;
% for i = 1:length(D)
%     
%     size_V = size_V + floor(size(D{i},2)/N);
% 
% end


%create a empty container for our vectors, letting V grow to a large size
%inside a loop will greatly slow down the program

V = zeros(size_V, N*P);


signal_lengths = zeros(length(D),1);
for i = 1:length(D)
    signal_lengths(i) = size(D{i},2);
end
    
%randomly sample vectors
random_sequences = ceil(rand(size_V,1) .* length(D));

for i = 1:size_V
    my_rand = rand;
    start = ceil(my_rand * ( signal_lengths(random_sequences(i)) - (N-1)) );
    stop = start + (N -1);
    signal_lengths(random_sequences(i))
    if start == 0 || stop == 0
        %fprintf(1,'randnum %.4f start %d stop %d sequence %d length %d\n', my_rand, start, stop, random_sequences(i), signal_lengths(i));
        fprintf(1,'start %d stop %d sequence %d length %d\n', start, stop, random_sequences(i), signal_lengths(random_sequences(i)));
        fprintf(1,'%.3f\n', my_rand);
    end
    V(i,:) = reshape( D{random_sequences(i)}(:,start:stop)', 1,  N*P);
    
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
options = statset('MaxIter',maxIters);
[CLUST_ID, CENTROIDS] = kmeans(V, M,'emptyaction', 'drop','display','iter', 'options', options); %#ok<ASGLU,NASGU>

%use this method for large values for M
%[CENTROIDS, CLUST_ID, err] = som_kmeans('seq',V, M, 1, 3);


%[CENTROIDS, means, stds, CLUST_ID] outfile


save(outfile, 'CENTROIDS', 'means', 'stds');
%save([outfile '_other'], 'V', 'CLUST_ID', '-v7.3');




