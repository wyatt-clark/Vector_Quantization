clear;

%% EXP Variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fdir = '../DATA/PREDS/';

%Window sizes to try
Ns = [1 2 4 8 16 32];

%Number of Centroids
%Ms = [1 4 16 64 256 1024 4096];
Ms = [4 16 64 256 1024 4096];



%SCOP only has one class
classes = {''};

%properties
%properties = {'Alpha','Kappa', 'Phi', 'Psi', 'SolAcc','BFactor', 'Helix', 'Hydro', 'Loop', 'PDBDisorder', 'Sheet', 'VSL2B'};
properties = {'Hydro'};

%encoding_types = {'', '_Additive', '_Spectral'};
encoding_types = {'_Spectral'};

%Alphas = [1 4 16 64];
Alphas = [512, 1024];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% JOB Variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

feat_dir = '../DATA/Features/';
splits = 144;
data_set = 'SCOP';
pred_prefix = [ '_Fold_Hydro'] ;
all_jobs = {};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Determine what has been ran
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
                    if ~strcmp(encoding_types{ii}, '_Spectral')
                        total = total +1;
                        fname = [fdir properties{i} '_M_' num2str(Ms(j)) '_N_' num2str(Ns(k)) encoding_types{ii} classes{iii} '_PRED.mat'];
                        if isempty(dir(fname))
                            fprintf(1,'%s\n', fname);
                            missed = missed + 1;
                            jobname = [feat_dir properties{i} '_M_' num2str(Ms(j)) '_N_' num2str(Ns(k))  encoding_types{ii}];
                            all_jobs{missed,1} = jobname;
                        end
                        
                        
                    else
                        %% deal with alphas
                        for l = 1:length(Alphas)
                            total = total +1;
                            
                            fname = [fdir properties{i} '_Alpha_' num2str(Alphas(l)) '_M_' num2str(Ms(j)) '_N_' num2str(Ns(k))  encoding_types{ii} classes{iii} '_PRED.mat'];
                            if isempty(dir(fname))
                                fprintf(1,'%s\n', fname);
                                missed = missed + 1;
                                jobname = [feat_dir properties{i} '_Alpha_' num2str(Alphas(l)) '_M_' num2str(Ms(j)) '_N_' num2str(Ns(k)) encoding_types{ii}  ];
                                all_jobs{missed,1} = jobname;
                            end
                        end
                    end
                    
                    
                    
                end
                
            end
            
        end
        
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


save all_jobs all_jobs


%% Create Job Folders
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

per_job = ceil(length(all_jobs) / splits);


for i = 1:splits
    i
    start =  ((i-1) * per_job)+1
    stop = min([(start + per_job -1) length(all_jobs)])
    
    if stop >= start
        these_jobs = all_jobs(start:stop);
        mkdir([data_set pred_prefix '_PRED' num2str(i)]);
        save([data_set pred_prefix '_PRED' num2str(i) '/these_jobs.mat'], 'these_jobs');
        copyfile('TPRED_LINUX/*', [data_set pred_prefix '_PRED' num2str(i) '/']);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




