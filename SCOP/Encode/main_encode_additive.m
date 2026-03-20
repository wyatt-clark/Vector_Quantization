clear
%% Don't forget to write a description jackass

encoding_type = 'Additive';
%data directory, properties should be in "Properites/" directory
data_dir = '../DATA/';
prop_dir = '../DATA/Properties/';
outdir = '../DATA/Features/';
%codebook_dir = '../DATA/Centroids/';
%data_type = 'SCOPsm';

%% ENCODING USING GO FEATURES NOTE CODEBOOK DIRECTORY CHANGE!!
codebook_dir = '../../GO/DATA/Centroids/';
data_type = 'GOsm';
%%

%Window sizes to try
Ns = [1 2 4 8 16 32];

%Number of Centroids
Ms = [1 4 16 64 256 1024 4096];


%properties

%properties = {'Alpha','Kappa', 'Phi', 'Psi', 'SolAcc'};
properties = {'BFactor', 'Helix', 'Hydro', 'Loop', 'PDBDisorder', 'Sheet', 'VSL2B'};


for i = 1:length(properties)
    
   load([prop_dir properties{i}]);
   
   eval(['D = ' properties{i} ';']);
   matlabpool(3);
   parfor j = 1:length(Ms)
       
       for k = 1:length(Ns)
           
           
           outfile = [outdir properties{i} '_M_' num2str(Ms(j)) '_N_' num2str(Ns(k)) '_' encoding_type];
           infile = [codebook_dir properties{i} '_M_' num2str(Ms(j)) '_N_' num2str(Ns(k)) '_' data_type];
           
           if ~isempty(dir([infile '.mat'])) && isempty(dir([outfile '.mat']))
               fprintf(1,'%s\n',outfile);
               encode_additive(D,Ms(j), Ns(k), infile, outfile);
           else
               if isempty(dir([infile '.mat']))
               fprintf(1,'%s not found\n', infile);
               else
                   fprintf(1,'%s already made\n', infile);
               end
                   
           end
           
       end
       
   end
   matlabpool('close');
   
end

