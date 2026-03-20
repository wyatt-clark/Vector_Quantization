clear;
close 'all'

data_dir = '../../DATA/';
out_dir = 'prs/';
fdir = [data_dir 'PREDS/'];

load([data_dir 'TESTING_LABEL.mat']);
load([data_dir 'FOLDS.mat']);
load([data_dir 'SCOP_TOP']);



%% Window sizes to try
Ns = [1 2 4 8 16 32];

%% Number of Centroids
Ms = [1 4 16 64 256 1024 4096];



%% we also predict enzyme vs non, and the different enzyme subclasses (6)
%% for go, remains '' for scop
classes = {''};

%% properties
properties = {'Alpha','Kappa', 'Phi', 'Psi', 'SolAcc','BFactor', 'Helix', 'Hydro', 'Loop', 'PDBDisorder', 'Sheet', 'VSL2B'};

%% type of encodings
%encoding_types = {'', 'Additive_', 'Spectral_'};
encoding_types = {'', 'Additive_'};

%% alphas for spectral encoding
Alphas = [1 4 16 64];

%% determine datapoints used in testing
all_dp = [];
for i = 1:length(FOLDS)
    all_dp = union(all_dp, FOLDS{i});
end

%% get tested classes
tested_classes = SCOP_TOP(1:4);

%% keep track of skipped predictions
total = 0;
missed = 0;


%% plotting stuff
scrsz = get(0,'ScreenSize');
%figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)*2])
plot_index = 1;

 legend_labels = cell(length(Ns),1);
 for j = 1:length(Ns)
     
     legend_labels{j} = ['windowsize ' num2str(Ns(j))];
     
 end
 xlabels = cell(length(Ms),1);
 for j = 1:length(Ms)
    xlabels{j} = num2str(Ms(j)); 
 end

%%


for iii = 1:length(classes)
    
    %% different encoding types
    for ii = 1:length(encoding_types)
        
        
        
        %% different properties
        for i = 1:length(properties)
            
            %% I guess we'll have to make a container for AUCS and F-maxes right here (plot by property?)
            %% not sure how we'll group things
            if ii < 3
            
            AUCS = zeros(length(Ms), length(Ns));
            FS = zeros(length(Ms), length(Ns));
            
            else
               
                %% do something else for the spectral kernel
            end
            
            %% num centroids
            for j = 1:length(Ms)
                
                %% num window sizes
                for k = 1:length(Ns)
                    
                    %% if not the spectral kernel ignore alphas
                    if ii < 3
                        
                        outfile = [out_dir properties{i} '_M_' num2str(Ms(j)) '_N_' num2str(Ns(k)) '_' encoding_types{ii} classes{iii} 'PRS.mat'];
                        if isempty(dir(outfile))
                            %fprintf(1,'%s\n', fname);
                            missed = missed + 1;
                            continue;
                        end
                        load(outfile)
                        AUCS(j,k) = auc;
                        FS(j,k) = f_max;
                         clear auc f_max
                        
                        
                    else
                        %% deal with alphas
                        for l = 1:length(Alphas)

                            
                            outfile = [out_dir properties{i} '_Aplha_' num2str(Alphas(l)) '_M_' num2str(Ms(j)) '_N_' num2str(Ns(k)) '_' encoding_types{ii} classes{iii} 'PRS.mat'];
                            if isempty(dir(foutfile))
                                fprintf(1,'%s\n', fname);
                                missed = missed + 1;
                                continue;
                            end
                            
                            
                            
                        end
                    end
                    
                    
                    
                end
                
                
            end
            
            %% plot AUC
            
            %h1 = mysubplot(length(properties),1,plot_index)
            plot_index = plot_index +1;
        
            hold all
            
            bar(AUCS','grouped')
            
            xlabel('Number Centroids')%, 'fontsize',12,'fontname','Helvetica');
            ylabel('AUC')%,'fontsize',12,'fontname','Helvetica');
            
            set(gca,'XTickLabel',xlabels)
            ylim([0,1]);
            title([classes{iii} encoding_types{ii} properties{i}]); 
            legend(legend_labels, 'Location', 'SouthEast');
            close
            %set(h1, 'XScale','log');
            %legend(h1,legend_labels,'Location', 'SouthEast');
            
            %axis(h1, 'square');
            
            %% Plot F-max
%             
%             h2 = mysubplot(length(properties),2,plot_index)
%             plot_index = plot_index +1;
%         
%             hold all
%             
%             bar(FS','grouped')
%             
%             xlabel('Number Centroids')%, 'fontsize',12,'fontname','Helvetica');
%             ylabel('Fmax')%,'fontsize',12,'fontname','Helvetica');
%             
%             set(gca,'XTickLabel',xlabels)
%             ylim([0,1]);
%             title([classes{iii} encoding_types{ii} properties{i}]); 
            %set(h1, 'XScale','log');
            %legend(h1,legend_labels,'Location', 'SouthEast');
            %legend(h1,legend_labels);
            %axis(h1, 'square');
            
            
        end
        
    end
    
    
end







