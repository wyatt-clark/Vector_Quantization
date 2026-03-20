clear

%Window sizes to try
Ns = [1 2 4 8 16 32];

%Number of Centroids
Ms = [1 4 16 64 256 1024 4096];

properties = {'Alpha','Kappa', 'Phi', 'Psi', 'SolAcc','BFactor', 'Helix', 'Hydro', 'Loop', 'PDBDisorder', 'Sheet', 'VSL2B'};

data_dir = '../../DATA/';
out_dir = 'precision_recall/';
results_dir = [data_dir 'PREDS/'];

load([data_dir 'TSM.mat']);
load([data_dir 'FOLDS.mat']);
load([data_dir 'SCOP_TOP']);


tested_classes = SCOP_TOP(1:4);

all_dp = [];
for i = 1:length(FOLDS)
    all_dp = union(all_dp, FOLDS{i});
end

LABEL = TSM(all_dp, tested_classes);

for i = 1:length(properties)
    AUCS = zeros(length(Ms), length(Ns), length(tested_classes));
    Fs = zeros(length(Ms), length(Ns), length(tested_classes));

    for j = 1:length(Ms)
        for k = 1:length(Ns)
            
            
            infile = [results_dir properties{i} '_M_' num2str(Ms(j)) '_N_' num2str(Ns(k)) '_PRED.mat'];
            fprintf(1,'%s\n', infile);
            
            if isempty(dir(infile))
                fprintf(1,'not found\n\n');
                continue;
            end
            
            
            load(infile);
            PRED = PRED(all_dp,:);
            
            PRED = normalize_min_max(PRED);
            
            
            for l = 1:length(tested_classes)
               
                [precisions, recalls, specificities] = calculate_stats_1d(PRED(:,l), LABEL(:,l));
                f_measure = max(((precisions .* recalls) ./ (precisions + recalls)) .*2);
                specc = 1-specificities;
                auc = -trapz([specc; 0], [recalls; 0]);
                
                auc2 = get_auc_quick([PRED(:,l) LABEL(:,l)]);
                
                AUCS(j,k,l) = auc;
                Fs(j,k,l) = f_measure;
                
            end
            
        end
    end
    outfile = [out_dir properties{i} '_AUC_FS.mat'];
    save(outfile, 'AUCS', 'Fs', 'Ns', 'Ms', 'tested_classes');
end
