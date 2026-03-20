function[f_measure, precision, recall, accuracy, spec, b_acc] = calculate_stats(N_PRED, LABEL,T)



negatives = find(LABEL == 0);
positives = find(LABEL == 1);
returned_positives = find(N_PRED > T);
returned_negatives = find(N_PRED <= T);

fprintf(1,'\tneg: %d pos %d rn %d rp %d\n', length(negatives), length(positives), length(returned_negatives), length(returned_positives)); 

if length(returned_positives) > 0
    precision = length(intersect(positives, returned_positives)) / length(returned_positives);
else
    precision = NaN;
end
if length(positives) > 0
    recall = length(intersect(positives, returned_positives)) / length(positives);
else
    %fprintf(1, 'sequence %d has no functions odd...\n', i);
    recall = NaN;
end

accuracy = (length(intersect(positives, returned_positives)) + length(intersect(negatives, returned_negatives))) / (length(LABEL));
spec = length(intersect(returned_negatives, negatives)) / (length(intersect(returned_positives, negatives)) + length(intersect(returned_negatives, negatives)));
correct = length(intersect(positives, returned_positives)) / length(positives) + length(intersect(negatives, returned_negatives)) / length(negatives);
b_acc = correct / 2;


if precision > 0 && recall > 0
    f_measure = (2*(precision*recall))/(precision+ recall);
else
    f_measure = nan;
end





