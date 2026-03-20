clear
file_dir = '../../GO/DATA/SimilarityMatrices/';
out_dir = '/Volumes/MODATA/VQ_DATA/SCOP/Features/';
feature_dir = '../DATA/Features/';

Feat_Type = 'Spectral';
%properties

%properties
%properties = {'BFactor', 'Helix', 'Hydro', 'Loop', 'PDBDisorder', 'Sheet', 'VSL2B'};
properties = {'Hydro'};

%Window sizes to try
Ns = [1 2 4 8 16 32];


%Number of Centroids
Ms = [4 16 64 256 1024 4096];



%Values of Alpha
%Alphas = [1 4 16 64];
Alphas = [512, 1024];


for i = 1:length(properties)
    property = properties{i};
    
    for j = 1:length(Ns)
        N = Ns(j);
        
        for k = 1:length(Ms)
            M = Ms(k);
            
            propfile = [feature_dir property '_M_' num2str(M) '_N_' num2str(N) '.mat'];
            if isempty(dir(propfile))
                
                fprintf(1,'%s\n', propfile);
                
            else
                
                load([feature_dir property '_M_' num2str(M) '_N_' num2str(N) '.mat']);
                SEO = SE; clear SE;
                %SEO ./ repmat(sum(SEO,2), 1, size(SEO,2));
                
                for l = 1:length(Alphas)
                    alpha = Alphas(l);
                    
                    
                    filename = [file_dir property '_Alpha_' num2str(alpha)  '_M_' num2str(M) '_N_' num2str(N) '.mat'];
                    load(filename)
                    
                    SE = SEO * S;
                    
                    outfile = [out_dir property '_Alpha_' num2str(alpha)  '_M_' num2str(M) '_N_' num2str(N) '_' Feat_Type '.mat'];
                    fprintf(1,'%s\n', outfile);
                    save(outfile, 'SE');
                    clear S SE;
                end
                
                clear SEO;
            end
        end
        
    end
end
