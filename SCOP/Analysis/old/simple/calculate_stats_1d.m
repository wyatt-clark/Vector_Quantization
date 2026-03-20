function[precisions, recalls, specificitys] = calculate_stats_1d(N_PRED, LABEL)


%% create thresholds, and containers for precisiona and recall values
thresholds = 0:.01:.99;


precisions = zeros(length(thresholds),1);
recalls = zeros(length(thresholds),1);
specificitys = zeros(length(thresholds),1);

space = 1:length(LABEL);

negatives = find(LABEL == 0);
positives = find(LABEL == 1);


for i = 1:length(thresholds)
    
    
    returned_positives = find(N_PRED >= thresholds(i));
    returned_negatives = setdiff(space, returned_positives);
    %fprintf(1,'%d\n', length(returned_positives));
    
    if ~isempty(returned_positives)
        precisions(i) = length(intersect(positives, returned_positives)) / length(returned_positives);
    else
        precisions(i) = NaN;
    end
    
    
    
    recalls(i) = length(intersect(positives, returned_positives)) / length(positives);
    
    
    specificitys(i) = length(intersect(returned_negatives, negatives)) / length(negatives);
    
    
end



