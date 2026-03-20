clear;
close 'all'

data_dir = '../../../DATA/';
out_dir = '../prs/';


%% Window sizes to try
Ns = [1 2 4 8 16 32];

%% Number of Centroids
Ms = [1 4 16 64 256 1024 4096];



%% we also predict enzyme vs non, and the different enzyme subclasses (6)
%% for go, remains '' for scop
classes = {'SC_'};

%% properties
%properties = {'Alpha','Kappa', 'Phi', 'Psi', 'SolAcc','BFactor', 'Helix', 'Hydro', 'Loop', 'PDBDisorder', 'Sheet', 'VSL2B'};
properties = {'Hydro'};
%% type of encodings
%encoding_types = {'', 'Additive_', 'Spectral_'};
encoding_types = {'Spectral_'};

%% alphas for spectral encoding
Alphas = [1 4 16 64];



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
        
        for l = 1:length(Alphas)
            figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)*2])
            plot_index = 1;
            %% different properties
            for i = 1:length(properties)
                
                %% deal with alphas
                
                %% I guess we'll have to make a container for AUCS and F-maxes right here (plot by property?)
                %% not sure how we'll group things
                
                
                AUCS = zeros(length(Ms), length(Ns));
                FS = zeros(length(Ms), length(Ns));
                
                
                
                %% do something else for the spectral kernel
                
                
                %% num centroids
                for j = 1:length(Ms)
                    
                    %% num window sizes
                    for k = 1:length(Ns)
                        
                        
                        
                        
                        
                        outfile = [out_dir properties{i} '_Alpha_' num2str(Alphas(l)) '_M_' num2str(Ms(j)) '_N_' num2str(Ns(k)) '_' encoding_types{ii}  'PRS.mat'];
                        if isempty(dir(outfile))
                            
                            %                             missed = missed + 1;
                            continue;
                        end
                        fprintf(1,'%s\n', outfile);
                        load(outfile)
                        AUCS(j,k) = weighted_auc;
                        FS(j,k) = weighted_fmax;
                        clear weighted_auc weighted_fmax
                        
                        
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
                ylim([.5,.75]);
                
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
                ylim([.45,.55]);
                mytitle = [classes{iii} encoding_types{ii} properties{i}];
                mytitle = regexprep(mytitle, '_', ' ');
                
                title(mytitle);
                
%                 if (i == length(properties))
%                     legend(h2,legend_labels,'Location', 'SouthEast');
%                 end
                
            end
            
            WritePlot(['SCOP_Spectral_Alpha_' num2str(Alphas(l)) '.eps'])
            %saveas(gcf, ['GO_Enzyme_Subclass_Alpha_' num2str(Alphas(l))],'epsc')
            close
            
            
        end
        
        
        
    end
    
    
end







