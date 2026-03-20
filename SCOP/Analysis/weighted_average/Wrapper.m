clear;


%% this is a script for calculating stats on all subclasses of enzymes for all
%% experiments ran

data_dir = '../../DATA/';
out_dir = 'prs/';
fdir = [data_dir 'PREDS/'];


load([data_dir 'TESTING_LABEL.mat']);
load([data_dir 'FOLDS.mat']);
load([data_dir 'SCOP_TOP']);

% load([data_dir 'TESTING_LABEL_SC.mat']);
% load([data_dir 'FOLDS_EZ.mat']);
% load([data_dir 'Tested_Functions']);
% load([data_dir 'Testing_Points_SC']);

LABEL = full(LABEL);

%% Window sizes to try
Ns = [1 2 4 8 16 32];

%% Number of Centroids
Ms = [1 4 16 64 256 1024 4096];



%% we also predict enzyme vs non, and the different enzyme subclasses (6)
%% for go, remains '' for scop
classes = {''};

%% properties
%properties = {'BFactor', 'Helix', 'Hydro', 'Loop', 'PDBDisorder', 'Sheet', 'VSL2B'};
properties = {'Alpha','Kappa', 'Phi', 'Psi', 'SolAcc','BFactor', 'Helix', 'Hydro', 'Loop', 'PDBDisorder', 'Sheet', 'VSL2B'};

%% type of encodings
%encoding_types = {'', 'Additive_', 'Spectral_'};
encoding_types = {'Spectral_'};

%% alphas for spectral encoding
Alphas = [1 4 16 64];

%% determine datapoints used in testing
all_dp = [];
for i = 1:length(FOLDS)
    all_dp = union(all_dp, FOLDS{i});
end

%% get tested classes
tested_classes = SCOP_TOP(1:4);


%% keep track of skipped predictions
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
                    if ~strcmp(encoding_types{ii}, 'Spectral_')
                        total = total +1;
                        fname = [fdir properties{i} '_M_' num2str(Ms(j)) '_N_' num2str(Ns(k)) '_' encoding_types{ii} classes{iii} 'PRED.mat'];
                        outfile = [out_dir properties{i} '_M_' num2str(Ms(j)) '_N_' num2str(Ns(k)) '_' encoding_types{ii} classes{iii} 'PRS.mat'];
                        if isempty(dir(fname))
                            fprintf(1,'%s\n', fname);
                            missed = missed + 1;
                            continue;
                        end
                        if ~isempty(dir(outfile))
                            continue;
                        end
                        fprintf(1,'%s\n', fname);
                        calculate_stats_wrapper(fname, LABEL, all_dp, tested_classes, outfile)
                        
                        
                        
                    else
                        %% deal with alphas
                        for l = 1:length(Alphas)
                            total = total +1;
                            
                            fname = [fdir properties{i} '_Alpha_' num2str(Alphas(l)) '_M_' num2str(Ms(j)) '_N_' num2str(Ns(k)) '_' encoding_types{ii} classes{iii} 'PRED.mat'];
                            outfile = [out_dir properties{i} '_Alpha_' num2str(Alphas(l)) '_M_' num2str(Ms(j)) '_N_' num2str(Ns(k)) '_' encoding_types{ii} classes{iii} 'PRS.mat'];
                            if isempty(dir(fname))
                                fprintf(1,'%s\n', fname);
                                missed = missed + 1;
                                continue;
                            end
                            if ~isempty(dir(outfile))
                                continue;
                            end
                            calculate_stats_wrapper(fname, LABEL, all_dp, tested_classes, outfile)
                        end
                    end
                    
                    
                    
                end
                
            end
            
        end
        
    end
end







