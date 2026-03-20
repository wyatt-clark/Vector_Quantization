clear
%% Don't forget to write a description

%data directory, properties should be in "Properites/" directory
data_dir = '../DATA/';
prop_dir = '../DATA/Uniref50_Properties/';
outdir = '../DATA/Centroids/';


%Window sizes to try
Ns = [1 2 4 8 16 32];

%Number of Centroids
Ms = [1 4 16 64 256 1024 4096];




%properties
properties = {'Alpha','BFactor', 'Helix', 'Hydro', 'Loop', 'PDBDisorder', 'Phi', 'Psi', 'Sheet', 'SolAcc', 'VSL2B'};


for i = 1:length(properties)
    
   load([prop_dir properties{i}]);
   
   eval(['D = ' properties{i} ';']);
   
   for j = 1:length(Ms)
       for k = 1:length(Ns)
           
           
           outfile = [outdir properties{i} '_M_' num2str(Ms(j)) '_N_' num2str(Ns(k))];
           if isempty(dir([outfile '.mat']))
           		fprintf(1,'%s\n',outfile);
           		create_code_book(D, Ms(j), Ns(k), outfile);
            end
            
       end
   end
   
   
    
end