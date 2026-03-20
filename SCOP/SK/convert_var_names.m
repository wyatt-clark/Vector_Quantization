clear
Ks = 1:9;

for i = 1:length(Ks)
    K = Ks(i);
    fprintf(1,'loading k=%d\n', K);
    infile = ['SK_' num2str(K) '.mat'];
    outfile = ['SK_' num2str(K) '.mat'];
    oldvarname = ['SK_' num2str(K)];
    varname = 'SE';
    load(infile);
    
    eval([varname ' = ' oldvarname ';']);
    
    save(outfile, varname);
    clear(varname, oldvarname);
end
    
    