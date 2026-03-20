function S = calculate_similarity(V,  alpha)

V(isnan(V)) = 0;
e = 2.718281828459045235360287471352;

N = size(V,1);

%D is distance matrix
D = zeros(N,N);

%S is similarity matrix
%go ahead and put 1's accross the diaganol
S = diag(ones(N,1),0);




%fill in D first
for i = 1:N-1
   
    
        start = i+1;
        stop = N;
        
        this_V = V(i,:);
        distances = sum((repmat(this_V, (stop - start + 1),1) - V(start:stop,:)) .^2, 2);
        D(i,start:stop) =  distances';
        
end


d_max = max(max(D));
for i = 1:N-1;
    for j = i+1:N
        
        
        s = e^ ( -alpha * (D(i,j) / d_max));
        S(i,j) = s;
        S(j,i) = s;
        
    end
end

return
