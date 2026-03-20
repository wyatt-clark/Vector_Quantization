clear;


%% this is a script for calculating stats on all subclasses of enzymes for all
%% experiments ran

data_dir = '../../DATA/';
out_dir = 'prs/';
fdir = [data_dir 'PREDS/'];


load([data_dir 'TESTING_LABEL.mat']);
load([data_dir 'FOLDS.mat']);
load([data_dir 'SCOP_TOP']);


LABEL = full(LABEL);

%% Window sizes to try
Ns = 1:9;

%% determine datapoints used in testing
all_dp = [];
for i = 1:length(FOLDS)
    all_dp = union(all_dp, FOLDS{i});
end

%% get tested classes
tested_classes = SCOP_TOP(1:4);

for i = 1:length(Ns)
    fname = [fdir 'SK_' num2str(Ns(i)) '_PRED.mat'];
    outfile = [out_dir 'SK_' num2str(Ns(i)) '_PRS.mat'];
    
    fprintf(1,'%s\n', fname);
    calculate_stats_wrapper(fname, LABEL, all_dp, tested_classes, outfile)
end

