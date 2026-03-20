clear
close

results_dir = 'precision_recall/';
out_dir = 'figures/';
properties = {'Alpha','Kappa', 'Phi', 'Psi', 'SolAcc','BFactor', 'Helix', 'Hydro', 'Loop', 'PDBDisorder', 'Sheet', 'VSL2B'};
load ../../DATA/SCOP.mat name

for i = 1:length(properties)
    
    load([results_dir properties{i} '_AUC_FS.mat']);
    
    these_names = name(tested_classes);
    
    
    %figure('Name',properties{i},'NumberTitle','off')
    scrsz = get(0,'ScreenSize');
    
    figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)])
    plot_index = 1;
    for jj = 1:length(tested_classes)
        these_AUCS = AUCS(:,:,jj);
        
        h1 = mysubplot(length(tested_classes),2,plot_index)
        plot_index = plot_index +1;
        
        hold all
        legend_labels = cell(length(Ns),1);
        for j = 1:length(Ns)
            plot(Ms, these_AUCS(:,j),'--.');
            legend_labels{j} = ['windowsize ' num2str(Ns(j))];
        end
        title(these_names{jj})
        set(h1, 'XScale','log');
        
        xlabel('Number Centroids')%, 'fontsize',12,'fontname','Helvetica');
        ylabel('AUC')%,'fontsize',12,'fontname','Helvetica');
        legend(h1,legend_labels,'Location', 'SouthEast');
        axis(h1, 'square');
        
        
        h2 = mysubplot(length(tested_classes),2,plot_index);
        plot_index = plot_index + 1;
        hold all
        legend_labels2 = cell(length(Ms),1);
        for j = 1:length(Ms)
            plot(Ns, these_AUCS(j,:),'--.');
            legend_labels2{j} = [num2str(Ms(j)) ' centroids'];
        end
        title(these_names{jj})
        
        xlabel('Window Size')%, 'fontsize',12,'fontname','Helvetica');
        ylabel('AUC')%,'fontsize',12,'fontname','Helvetica');
        legend(h2, legend_labels2,'Location', 'SouthEast');
        axis(h2,'square');
        
        %axis([h1 h2],'square')
        
        
        
        %suptitle(properties{i});
        
        
    end
    set(gcf,'PaperPositionMode','auto')
    saveas(gcf,[out_dir properties{i} '_AUC'],'tif');
    saveas(gcf,[out_dir properties{i} '_AUC'],'epsc');
    close;
    clear AUCS Fs;
end


