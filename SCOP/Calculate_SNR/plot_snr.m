clear

close
%data directory, properties should be in "Properites/" directory
data_dir = '../DATA/';
% origignal signals
prop_dir = '../DATA/Properties/';

% where the codebooks are
codebook_dir = '../DATA/Centroids/';
data_type = 'SCOPsm';

%Window sizes to try
Ns = [1 2 4 8 16 32];

%Number of Centroids
Ms = [1 4 16 64 256 1024 4096];


%properties
properties = {'Alpha','Kappa', 'Phi', 'Psi', 'SolAcc'};

for i = 1:length(properties)
    
    load([properties{i} '_SNR.mat']);
    
    
    h1 = subplot(1,2,1)
    hold all
    legend_labels = cell(length(Ns),1);
    for j = 1:length(Ns)
        plot(Ms, SNR_avg(:,j),'--.');
        legend_labels{j} = [num2str(Ns(j)) ' window'];
    end
    
    xlabel('Number Centroids', 'fontsize',12,'fontname','Helvetica');
    ylabel('SNR','fontsize',12,'fontname','Helvetica');
    legend(h1,legend_labels);
    
    
    h2 = subplot(1,2,2);
    hold all
    legend_labels2 = cell(length(Ms),1);
    for j = 1:length(Ms)
        plot(Ns, SNR_avg(j,:),'--.');
        legend_labels2{j} = [num2str(Ms(j)) ' centroids'];
    end
    
    xlabel('Window Size', 'fontsize',12,'fontname','Helvetica');
    ylabel('SNR','fontsize',12,'fontname','Helvetica');
    legend(h2, legend_labels2);
    
    
    axis([h1 h2],'square')
    
    
    
    %suptitle(properties{i});
    
    saveas(gcf,[properties{i} '_SNR'],'tif')
    saveas(gcf,[properties{i} '_SNR'],'epsc')
    %saveas(gcf, ['precision_recall_' num2str(top_what) '_convex.fig'])
    %saveas(gcf, ['precision_recall_' num2str(top_what) '_convex'],'epsc')
    %saveas(gcf, ['precision_recall_' num2str(top_what) '_convex'],'tif')

    close;
    clear SNR_avg SNR_std SNRS;
    
end


