clear


%data directory, properties should be in "Properites/" directory
data_dir = '../DATA/';
% origignal signals
prop_dir = '../DATA/Properties/';

% where the codebooks are
codebook_dir = '../../GO/DATA/Centroids/';
data_type = 'GOsm';

%Window sizes to try
Ns = [1 2 4 8 16 32];

%Number of Centroids
Ms = [1 4 16 64 256 1024 4096];


%properties
%properties = {'Alpha','Kappa', 'Phi', 'Psi', 'SolAcc','BFactor', 'Helix', 'Hydro', 'Loop', 'PDBDisorder', 'Sheet', 'VSL2B'};
%properties = {'BFactor', 'Helix', 'Hydro', 'Loop', 'PDBDisorder', 'Sheet', 'VSL2B'};
properties = {'Hydro'};

for i = 1:length(properties)
    
   load([prop_dir properties{i}]);
   
   eval(['D = ' properties{i} ';']);
   
   
   SNR_avg = zeros(length(Ms), length(Ns));
   SNR_std = zeros(length(Ms), length(Ns));
   SNRS = cell(length(Ms), length(Ns));
   
   for j = 2:length(Ms)
       for k = 2:length(Ns)
           
           
           
           codebook = [codebook_dir properties{i} '_M_' num2str(Ms(j)) '_N_' num2str(Ns(k)) '_' data_type];
           load(codebook)
           
           D_norm = cell(length(D), 1);
           for l = 1:length(D)
               [~,~,D_norm{l}] = normalize(D{l}', means, stds); 
               D_norm{l} = D_norm{l}';
           end
           clear means stds;
           
           if ~isempty(dir([codebook '.mat'])) 
               fprintf(1,'%s\n',codebook);
               D1 = encode_end_to_end(D_norm, CENTROIDS, Ms(j), Ns(k));
               
               my_snr = snr(D_norm,D1);
               SNRS{j,k} = my_snr;
               SNR_avg(j,k) = mean(my_snr);
               SNR_std(j,k) = std(my_snr);
               
           else
               
               fprintf(1,'%s n=%d %m=%dcouldnt test snr\n', properties{i}, Ns(k), Ms(j));
                   
           end
           
       end
   end
   
   save([properties{i} '_SNR.mat'],'SNR_avg','SNR_std','SNRS');
   
end
