

function [meanv,stdv,datanew]=normalize_matrix(data)
data_vector = reshape(data,size(data,1)*size(data,2),1);

a=size(data);
e=ones(a(1),1);

meanv=mean(data_vector);
stdv=std(data_vector);

%NOT SURE ABOUT THIS LINE, has been in normalization code forever
if stdv<0.000000001
    stdv=1000;
end

for i=1:a(2)
    x=data(:,i)-e*meanv;
    datanew(:,i)=x/stdv;
end

return;