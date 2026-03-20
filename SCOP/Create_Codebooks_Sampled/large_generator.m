clear
%% Don't forget to write a description

%data directory, properties should be in "Properites/" directory
data_dir = '../DATA/';
prop_dir = '../DATA/Properties/';
outdir = '../DATA/Centroids/';
data_type = 'SCOP';


N_samples = 10^6;
maxIters = 500;

%Window sizes to try
Ns = [2 4 8 16 32];

%Number of Centroids
%Ms = [1 4 16 64 256 1024 4096];
Ms = [1024 4096];


%properties
properties = {'Alpha','Kappa', 'Phi', 'Psi', 'SolAcc'};



for i = 1:length(properties)
    
   load([prop_dir properties{i}]);
   
   eval(['D = ' properties{i} ';']);
   
   for j = 1:length(Ms)
       for k = 1:length(Ns)
           
           
           outfile = [outdir properties{i} '_M_' num2str(Ms(j)) '_N_' num2str(Ns(k)) '_' data_type];
           if isempty(dir([outfile '.mat']))
           		fprintf(1,'%s\n',outfile);
           		create_code_book(D, Ms(j), Ns(k), N_samples, outfile, maxIters);
            end
            
       end
   end
   
   
    
end