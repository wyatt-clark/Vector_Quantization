clear;

fdir = '../../DATA/PREDS/';

%Window sizes to try
Ns = [1 2 4 8 16 32];

%Number of Centroids
%Ms = [1 4 16 64 256 1024 4096];
Ms = [4 16 64 256 1024 4096];


% we also predict enzyme vs non, and the different enzyme subclasses (6)
classes = {''};
%classes = {'SC_'};

%properties
properties = {'Alpha','Kappa', 'Phi', 'Psi', 'SolAcc','BFactor', 'Helix', 'Hydro', 'Loop', 'PDBDisorder', 'Sheet', 'VSL2B'};


%encoding_types = {'', 'Additive_', 'Spectral_'};
encoding_types = {''};

Alphas = [1 4 16 64];
total = 0;
missed = 0;
for iii = 1:length(classes)
    
    %% different encoding types
    for ii = 1:length(encoding_types)
        
        
        
        %% different properties
        for i = 1:length(properties)
            
            %% num centroids
            for j = 1:length(Ms)
                
                %% num window sizes
                for k = 1:length(Ns)
                    
                    %% if not the spectral kernel ignore alphas
                    if ii < 3
                        total = total +1;
                        fname = [fdir properties{i} '_M_' num2str(Ms(j)) '_N_' num2str(Ns(k)) '_' encoding_types{ii} classes{iii} 'PRED.mat'];
                        if isempty(dir(fname))
                            fprintf(1,'%s\n', fname);
                            missed = missed + 1;
                        end
                        
                        
                    else
                        %% deal with alphas
                        for l = 1:length(Alphas)
                            total = total +1;
                            
                            fname = [fdir properties{i} '_Aplha_' num2str(Alphas(l)) '_M_' num2str(Ms(j)) '_N_' num2str(Ns(k)) '_' encoding_types{ii} classes{iii} 'PRED.mat'];
                            if isempty(dir(fname))
                                fprintf(1,'%s\n', fname);
                                missed = missed + 1;
                            end
                        end
                    end
                    
                    
                    
                end
                
            end
            
        end
        
    end
end







