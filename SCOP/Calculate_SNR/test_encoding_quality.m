clear

property = 'Phi';
load(['../../DATA/Properties/' property '.mat']);

%number of clusters
Ms = [4 16 64 256 1024];
%Ms = [1 2 4 8 16 32];

%window sizes to try
Ns = [4 8 10 13 16];
%Ns = [4];

Rsn = zeros(length(Ns), length(Ms));
Wsn = zeros(length(Ns), length(Ms));


for i = 1:length(Ns)
    N = Ns(i);
    for j = 1:length(Ms)
        M = Ms(j);


        filename = ['../../ENCODERS/VQ/codebooks/' property '_M_' num2str(M) '_N_' num2str(N) '.mat'];
        fprintf(1,'%s\n', filename);
        load(filename);
        
        
        
        eval(['LV = make_long_vector(' property ');']);
        
        %make even length
        LV = LV(1:floor(length(LV)/N)*N);
        
        
        [~,~,WLV] = normalize(LV', means, stds); clear means stds LV;
        WLV = WLV';
        
        
        
        fprintf(1,'\n\n');
        
        WELV = encode_non_overlapping(WLV, CENTROIDS);
        X = snr(WLV, WLV-WELV);
        Wsn(i,j) = X;
        fprintf(1,'Matlab %.3f\n', X);
        clear X;
        
        
        
        RC = make_random_codebook(max(WLV), min(WLV), M, N);
        RELV = encode_non_overlapping(WLV, RC);
        X = snr(WLV, WLV-RELV);
        Rsn(i,j) = X;
        fprintf(1,'Random %.3f\n', X);
        clear X;
        
    end
end










