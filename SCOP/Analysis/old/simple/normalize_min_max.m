function X = normalize_min_max(X)




for i = 1:size(X, 2)
    xdiff = max(X(:,i)) - min(X(:,i));
   X(:,i) =  (X(:,i) - min(X(:,i))) ./ xdiff; 
    
end