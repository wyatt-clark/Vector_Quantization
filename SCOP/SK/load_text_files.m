clear
Ks = 1:9;

for i = 1:length(Ks)
    K = Ks(i);
    fprintf(1,'loading k=%d\n', K);
    infile = ['SK_' num2str(K) '.txt'];
    outfile = ['SK_' num2str(K) '.mat'];
    
    col_file = ['kept_columns_' num2str(K) '.txt'];
    varname = 'SE';
    
    eval([varname ' = spconvert(load(infile));']);
    
    kept_cols = load(col_file);
    
    eval([varname ' = ' varname '(:,kept_cols);']);
    save(outfile, varname);
    clear(varname, 'kept_cols');
end
    
    