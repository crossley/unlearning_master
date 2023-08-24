function [t, df] = tdb_within(r1,r2,n)

% Null hypothesis - p1 = p2
% r1 - the number of participants best fit by a model in one condition
% r2 - the number of participants best fit by a model in another condition
% n - the total number of participants
% Note that this statistic assumes within-condition comparisons which is
% why there is only one n term

t = (r1-r2)/sqrt((r1+r2)*(1-(r1+r2)/2*n));

df = 2*n-2;