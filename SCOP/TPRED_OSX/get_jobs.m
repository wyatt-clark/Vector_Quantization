clear

feat_dir = '../DATA/Features/';
pred_dir = '../DATA/PREDS/';
dinfo = dir([feat_dir '*.mat']);

pred_prefix = 'ADD_SCOP_';

keepers = zeros(length(dinfo),1);
these_jobs = cell(length(dinfo),1);
for i = 1:length(dinfo)
    jobbyjob = dinfo(i).name;
    jobbyjob = regexprep(jobbyjob, '.mat', '');
    
    these_jobs{i} = [feat_dir jobbyjob];
    
    if isempty(dir([pred_dir jobbyjob '_PRED.mat']))
        keepers(i) = 1;
    end
end

these_jobs = these_jobs(find(keepers == 1));


%%%%%

hits = regexp(these_jobs, '.*M_1_.*');

non_one = zeros(length(these_jobs),1);
for i = 1:length(hits)
 if isempty(hits{i})
     non_one(i) = 1;
 end
end

these_jobs = these_jobs(non_one == 1);
    
%save these_jobs these_jobs


all_jobs = these_jobs;
save all_jobs all_jobs

splits = 78;
per_job = ceil(length(all_jobs) / splits);


for i = 1:splits
    i
  start =  ((i-1) * per_job)+1
  stop = min([(start + per_job -1) length(all_jobs)])
    if start <= stop
    these_jobs = all_jobs(start:stop);
    mkdir([pred_prefix 'PRED' num2str(i)]);
    save([pred_prefix 'PRED' num2str(i) '/these_jobs.mat'], 'these_jobs'); 
    copyfile('TPRED_LINUX/*', [pred_prefix 'PRED' num2str(i) '/']); 
     end
end


% these_jobs = all_jobs(1:55);
% save these_jobs_1 these_jobs
% 
% these_jobs = all_jobs(56:110);
% save these_jobs_2 these_jobs
% 
% 
% these_jobs = all_jobs(111:164);
% save these_jobs_3 these_jobs
% 
% these_jobs = all_jobs(165:219);
% save these_jobs_4 these_jobs
