%This function displays info for various VaRs
%deviation=AnalyseVaRExceptions(VaR,data,clevel,method_name)
function [f isVaRAcceptedLRuc]=AnalyseVaRExceptions(VaR,data,clevel,method_name)
isTextOn = 0;
T=length(data); %number of observations
p=1-clevel;
d=diff(data);
N=length(d(d<=-VaR)); %exceptions
percentile =N/T;
f=((percentile-p)/p)*100;
z=( N*p*T)/(sqrt(p*(1-p)*T));
alpha=0.95;
isVaRAcceptedLRuc =  LRuc(T,N,clevel);
msg1 = ['Observed number of exceptions: ' num2str(N) ...
    '. Expected number of exceptions: ' ...
    num2str((p)*T) '.' '  N=' ...
    num2str(T)];
msg2 = ['Percentage of exceptions: ' num2str(percentile*100) ...
    '%. Expected percentage of exceptions: ' num2str(p*100) '%.' ];
msg3 = ['Kupiec Ratio      :   ' num2str(f) '.'];
  msg5=['VaR Backtest :'];
if(isVaRAcceptedLRuc == 0)
    msg5=[msg5 ' LRuc test - REJECTED! '];
else
    msg5 = [msg5 ' LRuc test - not rejected! '];
end
msg5 = [ msg5 ' Confidence level = ' num2str(5) '%.'];
msg4=['VaR=' num2str(VaR) '. Confidence level='...
    num2str(clevel*100) '%.'];
if isTextOn
    disp('********************************************************');
    disp(['Method: ' method_name]);
    disp(msg4);
    disp(msg1);
    disp(msg2);
    disp(msg3);
    disp(msg5);
end