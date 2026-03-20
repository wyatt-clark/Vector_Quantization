clear
%data directory, properties should be in "Properites/" directory
data_dir = '../../DATA/';
prop_dir = '../../DATA/Properties/';
codebook_dir = 'codebooks/';
outdir = 'encodings/';
%properties
properties = {'Phi', 'Psi', 'BFactor', 'Hydro', 'VSL2B', 'SolAcc','Helix', 'Loop', 'Strand'};


%Window sizes to try
Ns = [1 2 4 8 16 32];

%Number of Centroids
%Ms = [4 64 256 1024];
%Ms = [1024];
Ms = [1 4 16 64 256 1024 4096];






for i = 1:length(properties)
    property = properties{i};
    load([prop_dir property]);
   
   eval(['D = ' property ';']);
    
    for j = 1:length(Ns)
        N = Ns(j);
    
        for k = 1:length(Ms)
            M = Ms(k);
            
            filename = [codebook_dir property '_M_' num2str(M) '_N_' num2str(N) '.mat'];
            
            if isempty(dir(filename))
                fprintf(1,'Cannot find %s\n', filename);
            else
                
                
                
                outfile = [outdir property '_M_' num2str(M) '_N_' num2str(N)];
                
                if isempty(dir([outfile '.mat']))
                    infile = [codebook_dir property '_M_' num2str(M) '_N_' num2str(N)];
                    fprintf(1,'Running %s\n',outfile);
                    encode(D,M, N, infile, outfile);
                end
            end
            
        end
    end
end