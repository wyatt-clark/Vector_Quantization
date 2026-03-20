clear

%% Determine Fold
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(1,'jobs to run should be in a file named these_jobs\n');
load these_jobs.mat
%my_dir = pwd;
%s2 = regexp(my_dir, '/','split');
%file_root = s2{length(s2)};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


%----------------------------------------------------------------------
% the learning parameters are within structure 'info'
info.kernel = 1;               % degree of polynomial kernel SVM
info.pos_weight = 1;           % if weight is 1 then the machine is adjusted for balanced accuracy
info.parameter = 1;
info.SVMlightpath = './';
%----------------------------------------------------------------------
%----------------------------------------------------------------------
% the work starts here, no changes are necessary below this point



data_dir = '../DATA/';
out_dir = [data_dir 'PREDS/'];
feature_dir = [data_dir 'Features/'];

load([data_dir 'TSM.mat']);
load([data_dir 'SCOP.mat'],'name');
load([data_dir 'SCOP_TOP']);
load([data_dir 'FOLDS']);


%test top 4 classes
tested_classes = SCOP_TOP(1:4);

%% we aren't using all classes, so reduce used data-points
all_dp = [];
for i = 1:length(FOLDS)
    all_dp = union(all_dp, FOLDS{i});
end

for ii = 1:length(these_jobs)
    %load infile
    infile = these_jobs{ii};
    fprintf(1,'%s\n',infile);
    
    
    
    s2 = regexp(these_jobs{ii}, '/','split');
    file_root = s2{length(s2)};
    outfile = [out_dir file_root '_PRED.mat'];
    
    
    if ~isempty(dir([outfile '.mat']))
       fprintf(1,'%s already generated\n', file_root); 
        continue;
    end
    load(infile);
    
    D = SE; clear SE;
    %eval(['D = ' file_root ';clear ' file_root ';']);
    
    %name outfile
    
    
    
    %fprintf(1,'consider removing empty features in perl when you write the sparse matrix representation\m');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf(1,'checking for empty features\n');
    keeper = [];
    for i = 1:size(D, 2)
        if length(unique(D(:,i))) > 1
            keeper = [keeper, i];
        end
    end
    fprintf(1,'before: %d\tafter%d\n',size(D, 2),length(keeper));
    D = D(:,keeper);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    fprintf(1,'\n\n');
    PRED = zeros(size(D,1), length(tested_classes));
    
    
    for f = 1:10
        
        fprintf(1,'FOLD %d\n\n', f);
        test = FOLDS{f};
        train = setdiff(all_dp, test);
        f_PRED = zeros(length(test), length(tested_classes));
        
        
        for i = 1:length(tested_classes)
            
            fprintf(1,'%d\n',i);
            this_class = tested_classes(i);
            Y = TSM(:,this_class);
            
            this_D = [D Y];
            test_D = this_D(test,:);
            train_D = this_D(train, :); clear this_D;
            
            
            this_pred = SVMprediction(train_D, test_D, info);
            PRED(test, i) = this_pred;
            
            auc = get_auc_quick([this_pred Y(test)]);
            fprintf(1, '\n   [%s]', name{this_class});
            [f_measure, precision, recall, accuracy, spec, b_acc] = calculate_stats(this_pred, Y(test), 0);
            fprintf(1,'\n\tAUC: %.1f%%\tF-measure: %.3f\tPR %.3f\tRC: %.3f\tSP: %.3f\tBACC: %.3f\tACC: %.3f\n\n',100 * auc,100 * f_measure, 100 * precision, 100 * recall, 100 * spec, 100 * b_acc, 100 * accuracy);
            
            
            
        end
        
        
    end
    
    save(outfile, 'PRED','tested_classes', '-v7.3');
end

