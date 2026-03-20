clear;


feat_dir = '../DATA/Features/';

data_set = 'SCOP';

%Window sizes to try
Ns = [16 16 16 16 16 16 16];

%Number of Centroids

Ms = [64 64 64 64 64 64 64];


%properties
properties = {'BFactor', 'Helix', 'Hydro', 'Loop', 'PDBDisorder', 'Sheet', 'VSL2B'};


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


featname = '../DATA/Features/SCOP_Properties_Combined'
these_jobs{1,1} = featname;
save(featname,'SE');
save SCOP_Properties_Combined/these_jobs these_jobs

