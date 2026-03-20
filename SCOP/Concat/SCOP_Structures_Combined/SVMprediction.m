
function [pred_labels] = SVMprediction (bigtrain, bigtest, info)

%% perhaps set this varriable in the main function
fprintf(1,'do not limit the number of features\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MAX_FEATS = 1000;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% get the labels off of big train
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
labels_train = full(bigtrain(:, size(bigtrain,2)));
bigtrain = bigtrain(:,1:size(bigtrain,2)-1);

labels_test = full(bigtest(:, size(bigtest,2)));
bigtest = bigtest(:,1:size(bigtest,2)-1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% determine number of features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_features = size(bigtrain, 2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







% determine cost ratio for the SVM toolbox (we want to adjust learning for
% good balanced accuracy)
labels_train(labels_train == 0) = -1;
ratio = length(find(labels_train == -1)) / length(find(labels_train == 1));
%options = svmlopt('Regression', 0, 'Kernel', info.kernel, 'KernelParam', info.parameter, 'CostFactor', ratio * info.pos_weight);
options = svmlopt('Regression', 0, 'Kernel', info.kernel, 'KernelParam', info.parameter, 'CostFactor', ratio * info.pos_weight, 'ExecPath', info.SVMlightpath);
% train SVM - warning is turned off since toolbox outputs some "errors"
% which are not important

warning off

my_prefix = num2str(ceil(rand * 10000));


svmlwrite([my_prefix 'file1'], bigtrain(:, 1 : n_features), labels_train);
pause(0.2);
status = svm_learn(options, [my_prefix 'file1'], [my_prefix 'file2']);
if status ~= 0
    error('SVMlight svm_learn did not work properly');
end
pause(0.2);
svmlwrite([my_prefix 'file3'], bigtest(:, 1 : n_features));
status = svm_classify(svmlopt(options), [my_prefix 'file3'], [my_prefix 'file2'], [my_prefix 'file4']);
if status ~= 0
    error('SVMlight svm_classify did not work properly');
end
pause(0.2);
pred_labels = svmlread([my_prefix 'file4']);
warning on
delete([my_prefix 'file4']);

delete([my_prefix 'file1']);

delete([my_prefix 'file2']);

delete([my_prefix 'file3']);
