function calculate_stats_wrapper(infile, LABEL, all_dp, tested_classes, outfile)

%% for now we are only concerned with calculating stats for all classes
%% together.  This function should facilitated adding in individual classes later
%% refer to individual class wrapper for code for calculating for one class at a time

load(infile);
PRED = PRED(all_dp,:);

PRED = normalize_min_max(PRED);

[precisions, recalls, specificities] = calculate_stats_multiclass(PRED, LABEL);
f_max = max(((precisions .* recalls) ./ (precisions + recalls)) .*2);
specc = 1-specificities;

auc = -trapz([specc; 0], [recalls; 0]);
save(outfile, 'precisions', 'recalls', 'specificities','f_max','auc');      

% [M,N] = size(PRED);
% PRED = reshape(PRED,M*N,1);
% LABEL = reshape(LABEL,M*N,1);
% auc2 = get_auc_quick([PRED LABEL]);
                
