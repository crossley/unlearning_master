function [t, df]= tdb_between(r1,r2,n1,n2)

% Null hypothesis - p1 = p2
% r1 - the number of participants best fit by a model in one condition
% r2 - the number of participants best fit by a model in another condition
% n - the total number of participants
% Note that this statistic assumes between-condition comparisons which is
% why there are 2 different n terms

p = (r1/n1 + r2/n2)/2;

t = ((r1-r2)-(n1-n2))/sqrt((n1+n2)*(p*(1-p)));

df = n1+n2-2;