function GPL_struct = GPL_sparse(matrix,label,k,GPL_struct);

index=find(matrix);
values=matrix(index);
peak=max(values);siz=size(matrix);
ivalues=uint16(round(values/peak*(2^16-1)));
index=uint16(index);

eval(strcat('GPL_struct(k).',label,'.values=ivalues;'));
eval(strcat('GPL_struct(k).',label,'.index=index;'));
eval(strcat('GPL_struct(k).',label,'.scale=peak;'));
eval(strcat('GPL_struct(k).',label,'.size=siz;'));


