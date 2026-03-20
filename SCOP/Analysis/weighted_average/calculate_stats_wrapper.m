function calculate_stats_wrapper(infile, LABEL, all_dp, tested_classes, outfile)

%% for now we are only concerned with calculating stats for all classes
%% together.  This function should facilitated adding in individual classes later
%% refer to individual class wrapper for code for calculating for one class at a time



load(infile);
PRED = PRED(all_dp,:);


precisions = zeros(100,size(PRED,2));
recalls = zeros(100,size(PRED,2));
specificities = zeros(100,size(PRED,2));

aucs = zeros(1,size(PRED,2));
f_maxs = zeros(1,size(PRED,2));

PRED = normalize_min_max(PRED);

Npos = zeros(length(tested_classes), 1);

% %% Remove these two lines later!!!
% LABEL = LABEL(:,6);
% PRED = PRED(:,6);

for i = 1:size(PRED,2)
    Npos(i) = length(find(LABEL(:,i) == 1));
    
    [precision, recall, specificity] = calculate_stats_multiclass(PRED(:,i), LABEL(:,i));
    f_max = max(((precision .* recall) ./ (precision + recall)) .*2);
    specc = 1-specificity;

    auc = -trapz([specc; 0], [recall; 0]);

    recalls(:,i) = recall;
    precisions(:,i) = precision;
    specificities(:,i) = specificity;
    aucs(i) = auc;
    f_maxs(i) = f_max;
    
    fprintf(1,'N: %d\tAUC: %.3f\tFmax: %.3f\tnans: %d\n', Npos(i),auc, f_max, length(find(isnan(precisions))) ); 
end
weighted_auc = (aucs * Npos) / sum(Npos);
weighted_fmax = (f_maxs * Npos) / sum(Npos);
fprintf(1,'WAUC: %.3f\t WFMAX: %.3f\n', weighted_auc, weighted_fmax);
fprintf(1,'\n\n');
save(outfile, 'precisions', 'recalls', 'specificities','f_maxs','aucs', 'weighted_auc', 'weighted_fmax','Npos');      


                
