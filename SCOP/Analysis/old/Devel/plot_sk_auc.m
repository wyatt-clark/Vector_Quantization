clear
close

results_dir = 'precision_recall/';
out_dir = 'figures/';

properties = {'SK'};

load ../../DATA/SCOP.mat name

for i = 1:length(properties)
    
    load([results_dir properties{i} '_AUC_FS.mat']);
    
    these_names = name(tested_classes);
    
    h1 = subplot(1,2,1)
    hold all
    for jj = 1:length(tested_classes)
        
        plot(Ns, AUCS(:,jj),'--.');
        
    end
    ylim([0,1]);
    xlabel('Window Size', 'fontsize',12,'fontname','Helvetica');
    ylabel('AUC','fontsize',12,'fontname','Helvetica');
    legend(h1,these_names,'Location','SouthWest');
    
    
    h2 = subplot(1,2,2);
    hold all
    for jj = 1:length(tested_classes)
        
        plot(Ns, Fs(:,jj),'--.');
        
    end
    ylim([0,1]);
    xlabel('Window Size', 'fontsize',12,'fontname','Helvetica');
    ylabel('F-max','fontsize',12,'fontname','Helvetica');
    legend(h2, these_names,'Location','SouthWest');
    
    axis([h1 h2],'square')
    
    %suptitle(properties{i});
    
    %saveas(gcf,[out_dir properties{i} '_' these_names{jj} '_AUC'],'tif')
    %saveas(gcf,[out_dir properties{i} '_AUC'],'epsc')
    %saveas(gcf, ['precision_recall_' num2str(top_what) '_convex.fig'])
    %saveas(gcf, ['precision_recall_' num2str(top_what) '_convex'],'epsc')
    %saveas(gcf, ['precision_recall_' num2str(top_what) '_convex'],'tif')
    
    close;
    
end
clear AUCS Fs;



