function F=myfun(a,x)

F = 100./(1+exp(-a(1)*(x-a(2))));
% a = [beta(slope)  mu(threshold)]

% F = 100*(1-a(3))./(1+exp(-a(1)*(x-a(2))));
% a = [beta(slope)  mu(threshold)   lamda(1-upperbound)]

% F = 100*(a(4)+(1-a(3)-a(4))./(1+exp(-a(1)*(x-a(2)))));
% a = [beta(slope)  mu(threshold)   lamda(1-upperbound) gamma(lowerbound)]

% x=[-12 -8 -4 0];
% y=[3.31197 18.69658 47.32906 70.94017];
% L=length(x);
% F=0;
% for i=1:L
%     F(i)=y(i)-1/(1+exp(-a(1)*(x(i)-a(2))));
% end;
%在外面程序[aa,resnorm] = lsqnonlin(@myfun,[2,10])
%y用所给数据代替