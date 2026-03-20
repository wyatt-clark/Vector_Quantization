clear;
close 'all'

data_dir = '../../../DATA/';
out_dir = '../prs/';



%% Window sizes to try
Ns = [1 2 4 8 16 32];

%% Number of Centroids
%Ms = [1 4 16 64 256 1024 4096];
Ms = [4 16 64 256 1024 4096];


%% we also predict enzyme vs non, and the different enzyme subclasses (6)
%% for go, remains '' for scop
classes = {''};

%% properties
properties = {'Alpha','Kappa', 'Phi', 'Psi', 'SolAcc','BFactor', 'Helix', 'Hydro', 'Loop', 'PDBDisorder', 'Sheet', 'VSL2B'};

aucmaxs = zeros(length(properties),3);
fmsmaxs = zeros(length(properties),3);

%% type of encodings
%encoding_types = {'', 'Additive_', 'Spectral_'};
encoding_types = {'', 'Additive_'};

%% alphas for spectral encoding
Alphas = [1 4 16 64];



%% keep track of skipped predictions
total = 0;
missed = 0;


%% plotting stuff
scrsz = get(0,'ScreenSize');
% figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)*2])
% plot_index = 1;

legend_labels = cell(length(Ns),1);
for j = 1:length(Ns)
    
    legend_labels{j} = ['windowsize ' num2str(Ns(j))];
    
end
xlabels = cell(length(Ms)+2,1);
xlabels{1} = '';
xlabels{length(Ms) +1} = '';
for j = 1:length(Ms)
    xlabels{j+1} = num2str(Ms(j));
end

%%


for iii = 1:length(classes)
    
    %% different encoding types
    for ii = 1:length(encoding_types)
        
        figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)*2])
        plot_index = 1;
        
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
                            %fprintf(1,'%s\n', outfile);
                            missed = missed + 1;
                            AUCS(j,k) = .0001;
                            FS(j,k) = .0001;
                            continue;
                        end
                        load(outfile)
                        AUCS(j,k) = weighted_auc;
                        FS(j,k) = weighted_fmax;
                        clear weighted_auc weighted_fmax
                        
                        
                    else
                        %% deal with alphas
                        for l = 1:length(Alphas)
                            
                            
                            outfile = [out_dir properties{i} '_Aplha_' num2str(Alphas(l)) '_M_' num2str(Ms(j)) '_N_' num2str(Ns(k)) '_' encoding_types{ii} classes{iii} 'PRS.mat'];
                            if isempty(dir(outfile))
                                %fprintf(1,'%s\n', fname);
                                missed = missed + 1;
                                continue;
                            end
                            
                            
                            
                        end
                    end
                    
                    
                    
                end
                
                
            end
            
          
            
            
            %% plot AUC
            
            h1 = mysubplot(length(properties),2,plot_index)
            plot_index = plot_index +1;
            
            hold all
            
            bar(AUCS,'grouped')
            
            xlabel('Number Centroids')%, 'fontsize',12,'fontname','Helvetica');
            ylabel('AUC')%,'fontsize',12,'fontname','Helvetica');
            
            set(gca,'XTickLabel',xlabels)
            ylim([.5,1]);
            
            mytitle = [classes{iii} encoding_types{ii} properties{i}];
            mytitle = regexprep(mytitle, '_', ' ');
            
            title(mytitle);
            %          legend(legend_labels, 'Location', 'SouthEast');
            %    close
            %            set(h1, 'XScale','log');
            %legend(h1,legend_labels,'Location', 'SouthEast');
            
            %axis(h1, 'square');
            
            % Plot F-max
            
            h2 = mysubplot(length(properties),2,plot_index)
            plot_index = plot_index +1;
            
            hold all
            
            bar(FS,'grouped')
            
            xlabel('Number Centroids')%, 'fontsize',12,'fontname','Helvetica');
            ylabel('Fmax')%,'fontsize',12,'fontname','Helvetica');
            
            set(gca,'XTickLabel',xlabels)
            ylim([.25,.8]);
            mytitle = [classes{iii} encoding_types{ii} properties{i}];
            mytitle = regexprep(mytitle, '_', ' ');
            
            title(mytitle);
            
              [V, I1] = max(AUCS); % gives me max M
            [V, I2] = max(V); %gives me max N
            auc_max_M = I1(I2);
            auc_max_N = I2;
            
            [V, I1] = max(FS); % gives me max M
            [V, I2] = max(V); %gives me max N
            fs_max_M = I1(I2);
            fs_max_N = I2;
            
            fprintf(1,'%s\nAUC N: %d M: %d\nFMS N: %d M: %d\n', mytitle, Ns(auc_max_N), Ms(auc_max_M), Ns(fs_max_N), Ms(fs_max_M));
            aucmaxs(i,:) = [Ns(auc_max_N), Ms(auc_max_M) AUCS(auc_max_M, auc_max_N)];
            fmsmaxs(i,:) = [Ns(fs_max_N), Ms(fs_max_M) FS(fs_max_M, fs_max_N)];
            
%             if (i == length(properties))
%                 legend(h2,legend_labels,'Location', 'SouthWest');
%             end
            
            
        end
        WritePlot(['SCOP_' encoding_types{ii} 'Fold.eps'])
        %saveas(gcf, ['GO_' encoding_types{ii} 'Enzyme_Subclass'],'epsc')
        close
        
    end
    
    
end







