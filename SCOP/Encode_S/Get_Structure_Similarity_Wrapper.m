file_dir = '../DATA/Centroids/';
out_dir = '../DATA/SimilarityMatrices/';
data_type = 'SCOPsm';

%properties
properties = {'Alpha','Kappa', 'Phi', 'Psi', 'SolAcc'};


%Window sizes to try
Ns = [1 2 4 8 16 32];

%Number of Centroids
Ms = [1 4 16 64 256 1024 4096];



%Values of Alpha
Alphas = [1 4 16 64];
%Alphas = [64];

for i = 1:length(properties)
    property = properties{i};
    
    for j = 1:length(Ns)
        N = Ns(j);
        
        for k = 1:length(Ms)
            M = Ms(k);
            
            filename = [file_dir property '_M_' num2str(M) '_N_' num2str(N) '_' data_type '.mat'];
            
            if isempty(dir(filename))
                
                fprintf(1,'%s\n', filename);
                
            else
                
                
                load(filename)
                
                for l = 1:length(Alphas)
                    
                    alpha = Alphas(l);
                    S = calculate_similarity(CENTROIDS, alpha);
                    
                    outfile = [out_dir property '_Alpha_' num2str(alpha)  '_M_' num2str(M) '_N_' num2str(N) '.mat'];
                    %fprintf(1,'%s\n', outfile);
                    
                    save(outfile, 'S');
                    
                end
                
            end
            
            clear CENTROIDS S
            
        end
    end
end