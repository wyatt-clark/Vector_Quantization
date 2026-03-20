clear;
close 'all'


out_dir = '../prs/';



%% Window sizes to try
Ns = 1:9;


%% we also predict enzyme vs non, and the different enzyme subclasses (6)
%% for go, remains '' for scop
classes = {''};


AUCS = zeros(length(Ns),1);
FS = zeros(length(Ns),1);


%% plotting stuff
scrsz = get(0,'ScreenSize');
% figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)*2])
% plot_index = 1;

legend_labels = cell(length(Ns),1);
for j = 1:length(Ns)
    
    legend_labels{j} = num2str(Ns(j));
    
end

%%
for i = 1:length(Ns)
    
    outfile = [out_dir 'SK_' num2str(Ns(i))  '_PRS.mat'];
    if isempty(dir(outfile))
        fprintf(1,'%s\n', outfile);
       
        AUCS(i) = .0001;
        FS(i) = .0001;
        continue;
    end
    load(outfile)
    AUCS(i) = weighted_auc;
    FS(i) = weighted_fmax;
    clear weighted_auc weighted_fmax
    
end

%% plot AUC
figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2])

h1 = mysubplot(1,2,1)


hold all

bar(AUCS)

xlabel('Word Size')%, 'fontsize',12,'fontname','Helvetica');
ylabel('AUC')%,'fontsize',12,'fontname','Helvetica');

set(gca,'XTickLabel',legend_labels)
%ylim([.5,1]);


%          legend(legend_labels, 'Location', 'SouthEast');
%    close
%            set(h1, 'XScale','log');
%legend(h1,legend_labels,'Location', 'SouthEast');

%axis(h1, 'square');

% Plot F-max

h2 = mysubplot(1,2,2)

hold all

bar(FS)

xlabel('Word Size')%, 'fontsize',12,'fontname','Helvetica');
ylabel('Fmax')%,'fontsize',12,'fontname','Helvetica');

set(gca,'XTickLabel',legend_labels)
%ylim([.25,1]);


WritePlot(['SCOP_SK_Fold.eps'])
%saveas(gcf, ['GO_' encoding_types{ii} 'Enzyme'],'epsc')
close








