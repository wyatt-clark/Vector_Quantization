clear;


feat_dir = '../DATA/Features/';

data_set = 'SCOP';

%Window sizes to try
Ns = [32 32 32 32 32];

%Number of Centroids

Ms = [4096 4096 4096 4096 4096];


%properties
properties = {'Alpha','Kappa', 'Phi', 'Psi', 'SolAcc'};


%encoding_types = {'', '_Additive', '_Spectral'};
encoding_type = '';



%% concatenate features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SET = [];
SET = sparse(SET);
for i = 1:length(properties)
    
        featname = [feat_dir properties{i} '_M_' num2str(Ms(i)) '_N_' num2str(Ns(i)) encoding_type  ];
        fprintf(1,'%s\n', featname);
        load(featname);
        
        %% different properties
        SET = [SET SE];
end
SE = SET; clear SET;

data_dir = '../DATA/Features/'
featname = 'SCOP_Structures_Combined'
these_jobs{1,1} = [data_dir featname];
save(featname,'SE');
save SCOP_Structures_Combined/these_jobs these_jobs

