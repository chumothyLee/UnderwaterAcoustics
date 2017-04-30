actual = xlsread('output.xlsx','A:A');
predicted = xlsread('output.xlsx','B:B');
%plotconfusion(actual,predicted);
[C,order] = confusionmat(actual,predicted);
order
filename = 'output.xlsx';
%A = {actual;predicted};
sheet = 1;
xlRange = 'E2';
%xlswrite(filename,C,sheet,xlRange)