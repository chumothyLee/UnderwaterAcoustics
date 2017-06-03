function [matrix] = GPL_full(label,k,GPL_struct);

eval(strcat('values=double(GPL_struct(k).',label,'.values);'));
eval(strcat('index=double(GPL_struct(k).',label,'.index);'));
eval(strcat('peak=GPL_struct(k).',label,'.scale;'));
eval(strcat('siz=GPL_struct(k).',label,'.size;'));

matrix=zeros(siz(1),siz(2));
matrix(index)=values*peak/(2^16-1);

