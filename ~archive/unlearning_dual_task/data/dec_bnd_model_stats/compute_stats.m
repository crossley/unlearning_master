clc; close all; clear all

% [t, df] = tdb_within(r1,r2,n)
% [t, df]= tdb_between(r1,r2,n1,n2)

A_1_II = 14;
A_1_RB = 8;
A_1_G = 0;
R_1_II = 11;
R_1_RB = 5;
R_1_G = 6;
n = 22;
[t, df] = tdb_between(14,11,22,22)
P = 1 - tcdf(t,df)

A_2_II = 13;
A_2_RB = 6;
A_2_G = 0;
R_2_II = 8;
R_2_RB = 6;
R_2_G = 5;
n = 19;
[t, df] = tdb_between(13,8,19,19)
P = 1 - tcdf(t,df)

A_3_II = 15;
A_3_RB = 6;
A_3_G = 0;
R_3_II = 10;
R_3_RB = 6;
R_3_G = 5;
n = 21;
[t, df] = tdb_between(15,10,21,21)
P = 1 - tcdf(t,df)

A_4_II = 13;
A_4_RB = 5;
A_4_G = 0;
R_4_II = 7;
R_4_RB = 10;
R_4_G = 1;
n= 18;
[t, df] = tdb_between(13,7,18,18)
P = 1 - tcdf(t,df)

% 1-2
[t, df] = tdb_between(14,13,22,19)
P = 1 - tcdf(t,df)

% 1-3
[t, df] = tdb_between()
P = 1 - tcdf(t,df)

% 1-4
[t, df] = tdb_between()
P = 1 - tcdf(t,df)

% 2-3
[t, df] = tdb_between()
P = 1 - tcdf(t,df)

% 2-4
[t, df] = tdb_between()
P = 1 - tcdf(t,df)

% 3-4
[t, df] = tdb_between()
P = 1 - tcdf(t,df)