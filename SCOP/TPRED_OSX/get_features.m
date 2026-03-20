load all_jobs.mat
indir = '/Volumes/MODATA/VQ_DATA/SCOP/Features/';
prefix = '../DATA/Features/';
outdir = '/Volumes/MODATA/temp/SCOP/Features/';

for i = 1:length(all_jobs)
    in = all_jobs{i};
    in = regexprep(in, prefix, indir);
    out = regexprep(in, indir, outdir);
    eval(['!cp ' in '.mat ' out '.mat']);
end
