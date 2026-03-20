function encode(D,M, N, infile, outfile)

load(infile);

SE = zeros(length(D), size(CENTROIDS, 1)); %#ok<NODEF>
P = size(D{1},1);
for dp = 1:length(D)
    
%     if rem(dp, 100) == 0
%         fprintf(1,'%d\t%d\n', dp, length(D));
%     end
    if ~isempty(D{dp})
        Pvect = D{dp};
        
        
        
        %don't for get to normalize!!!!
        
        if isempty(find(Pvect ~=0, 1))
            Pvect = repmat(means, 1, length(Pvect));
        else
            
            [~,~,Pvect] = normalize(Pvect', means, stds);
            Pvect = Pvect';
        end
        %before loop below
        
        %V_size = floor(size(Pvect,2)/N);
        %V = zeros(V_size, N*P);
        
        
        %encoding = zeros(1,floor(size(Pvect,2)/N));
       % spectral_encoding = zeros(1,size(CENTROIDS,1));
        
        for i = 1:size(Pvect,2) - (N-1)
            start = i;
            stop = i+(N-1);
            %fprintf(1,'%d\t%d\t%d\n', start, stop, length(Pvect));
            %we were storing all sampled vectors but that is not needed
            %V(i+1,:) = reshape( Pvect(:,start:stop)', 1,  N*P);
            
            %only need this line with multiple features
            %V = reshape( Pvect(:,start:stop)', 1,  N*P);
            V = Pvect(:,start:stop);
            
            %maybe find closest centroid here instead of making a data structure of
            %stored vectors
            %distances = zeros(1,size(CENTROIDS,1));
            distances = sum((repmat(V, M,1) - CENTROIDS) .^2, 2);
%             for j = 1:size(CENTROIDS,1)
%                 
%                 
%                 %sum((V(i+1)-CENTROIDS(j)) .^2)
%                 %distances(j) = euclidean(V(i+1), CENTROIDS(j));
%                 distances(j) = sum((V-CENTROIDS(j,:)) .^2);
%                 
%                 
%                 
%             end
            
            [distance, enc] = min(distances); %#ok<ASGLU>
            SE(dp,enc) = SE(dp,enc) + 1;
            %encoding(i+1) = enc;
            
            
        end
        %SE(dp,:) = spectral_encoding;
    end
end

save(outfile, 'SE');







