function D1 = encode_end_to_end(D, C, M, N)



%number of clusters
M1 = size(C, 1);
%window size
N1 = size(C,2);

if M1 ~= M || N1 ~= N
    fprintf(1,'error m and n do not match clusters\n');
end

D1 = cell(length(D),1);

for i = 1:length(D)
    
    V = D{i};
    

    V = V(1: floor(length(V)/N)*N);
    
    
    V = reshape(V',N,length(V)/N)';
    EV = zeros(size(V,1), size(V,2));
    
    for j = 1:size(V,1)
        distances = sum((repmat(V(j,:), M,1) - C) .^2, 2);
        
        [distance, enc] = min(distances); %#ok<ASGLU>
        EV(j,:) = C(enc,:);
        
        
    end
    
    
    
    
    
    EV = reshape(EV', 1, size(EV,1) * size(EV,2));
    D1{i} = EV;
    
end