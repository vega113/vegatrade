
function[income, Yytau, Sxyz]=MultiPred(BI, lowb, uppb, dgg, BOUND, TA, sum_money,firstNum)

%clc

% size(B)
% lowb = lowb + 55;
% uppb = uppb + 55;
% dgg 
% BOUND
% TA 
% sum_money = sum_money;

%clc;
TA = 1;%only;
tau=TA;
dgg = 6;
dg=dgg;
see_count_company=2;
%sum_money = 1000;
per_company=sum_money/see_count_company;

 income=0;
% dgg = 6;
% dg = dgg;  %6;
% % e.g.
% TA = 1; % Zman of (max). prediction
% tau= TA; % E.G., time of prediction.
% BOUND = 100; % The radius  (length) of history;

% [F1,mes1]=fopen('d:\Prog1\Prog1\alex_name_comp.txt','rt');
% 
% I=1;
% while feof(F1)==0
%     line1=fgetl(F1);
%     x=sscanf(line1,'%s');
%     S = strcat('d:\Prog\Prog1\',x);
%   
%     [F,mes]=fopen(S,'rt');
%     J=1;
%     while feof(F)==0
%         line = fgetl(F);
%         B(I,J)=sscanf(line,'%f');
%         J=J+1;
%     end
%     fclose(F);
%     
%     I=I+1;
% end
% fclose(F1);
% %size(B);

% preparing array 2 of indices of companies
[F,mes]=fopen('c:\Prog\Prog2\count_firm.txt','rt');
I=1;
while feof(F)==0
    line1=fgetl(F);
    xxx(I)=sscanf(line1,'%i');
    I=I+1;
end
%%firstNum = 111;  %% ONLY HERE!
CheckNum=firstNum-1;
[ui,sizeLen]=size(xxx);
for IJ=1:sizeLen
    xxx(IJ)=xxx(IJ)-CheckNum;
end
%xxx;
fclose(F);
%end of preparing array2 

%B(1:5,1:6);
% "xxx" are numbers of choosing companies;

[A D]=size(BI);
%RY = B(1,1);

BOUND = min(BOUND,D);

 for ii = 1:A
  for jj = 1:BOUND
     AR(ii,jj) = BI(ii,  D - BOUND + jj); % The truncation of array;
     ypred(ii) = BI(ii, min(D - BOUND + jj + tau,D) ); %The real  values;
  end % for jj
 end % for ii = 1:A

[aa bbbb] = size(AR);
%RZ = AR(1,1);
% aa = round(aa/7); % in time; 23.2.2007;

 %lowb % = 1;
 % uppb % = bb;

bb =uppb - lowb + 1;
x = 1:bb; % Times array;
%x = x/bb;

 XE = x(end); % =1!
% xpred = min(XE + tau,D);
 xpred = XE + tau;
% [ea ef] = size(AR); % = 23*101;
% aa  % = 23, eg.
   for m = 1:aa
  % m = 1;      
    for F = 1:bb

         YY(F) = AR(m,F); % One row;
       %  ypred(m) = B(m,xpred);      
     % length(YY)
     %   [meanpred(F), onedimpred(F)] = Ratappred(lowb, uppb,x,YY,dg,tau); % Rational Regression.
          
%  Odrpr(m) = Ratappred(lowb, uppb,x,YY,dg,tau); % Rational Regression.
    end % for F
    
      valend(m) = YY(end);
     [yapp(m), meanpred(m), onedimpred(m)] = Ratappred(lowb, uppb,x,YY,dg,tau); % Rational Regression.
 
% [Yprd MM  cRL YY  Tau  ESig  ENois  ErYY] = AdLegRegPred(lowb, uppb,x,YY,tau); % Adaptive Legendre Regression.
     % Yprd(m) = Yprd0/(1-0.136546);
     
    % lF = length(YY);
 end % for m = 1:aa;
%DLT = max(abs(meanpred- onedimpred));
 %length(meanpred)
 % ypred
%Odrpr
% tau
%valend
 % Yytau =  meanpred;  % onedimpred; % The hizui; 19.5.07;
  %Yytau = Yprd;
  Yytau = onedimpred;
%onedimpred

% Z=7;
[AB CD]=size(BI);

 for Ie=1:AB % Comprison on the last value;
  DC(Ie) = BI(Ie,CD);

  if( abs(DC(Ie)) < 0.00001)
  DC(Ie) = 0.000001;
  end % if
 
 end;%for Ie=1:AB
 Del = 100*(Yytau - DC)./DC;
% Led = 100*(Zztau - DC)./DC;

%DDel = 100*(Yytau - ypred)./ypred  % Exactness of forecasting;
%LLed = 100*(Zztau - DC)./DC;

 Ld = length(Del);
% MeaEr = mean(abs(Del));
% AemEr = mean(abs(Led))
 Myabs = (Yytau - DC); %The revach
%DDe = sort(Del);
%Df = DDe((AB - 10):AB)

[SYytau,Sxxx]= tds(Myabs, xxx);

% SYytau;% Uparrow.
%Sxxx;
 n_array3=length(SYytau); % General amount of choosed companies; %  = 23,eg.
 Sxyz = Sxxx( (n_array3-see_count_company + 1):n_array3);  % The list of  best companies;

% Sxyz = Sxxx(1:see_count_company); % The list of bad companies;

lS = length(Sxyz); % = 5, eg.
n_array3=length(Myabs);
% Sxyz; % array!
% for MM = 1:lS

% Predval(MM) = meanpred(Sxyz(MM));
     
% end % for MM

% Predval;
% Z=7;
% for IT=1:see_count_company
%     but_ar(IT)=SYytau(IT);
%     but_Sxxx(IT)=Sxyz(IT);  % button 5 bad commpanies (ID)
% end  %for IT=1:see_count_company

% but_ar;
% Sxyz;
% but_Sxxx = Sxyz;

%SYytau;
P=0;
ERROR_P=0;
%ZVB=0;
  for I=1:see_count_company  % foresee the case P=0 
   % ZVB=ZVB+1;
    if(SYytau(n_array3-I+1)>0)
        P=P+1;
        top_ar(P)=SYytau(n_array3-I+1);
        top_Sxxx(P)=Sxxx(n_array3-I+1);% top 5 better commpanies (ID)
        
        [F,mes]=fopen('c:\Prog\Prog2\array_name_comp.txt','rt');
        I=1;
        for  II=1:(top_Sxxx(P)+firstNum)
            line1=fgetl(F);
        end % for
        fclose(F);
        S = strcat('c:\Prog\Prog2\',line1);
        S1=strcat(S,'.tx');
        [F1,mes1]=fopen(S1,'rt');
        Z=1;
        while feof(F1)==0
              line12=fgetl(F1);
              xxx12(Z)=sscanf(line12,'%f');
              Z=Z+1;
        end
        
        fclose(F1);
        x_prev_day=xxx12(uppb);
        x_TA_day=xxx12(uppb+TA);
        pr=x_TA_day*100/x_prev_day;
        income=income+(per_company*pr/100);


    else
        ERROR_P=ERROR_P+1 ;    
    end%if
    
       
end %for I=1:see_count_company
%income=sum(pr);

          %top_ar;
          %top_Sxxx;  % top 5 better commpanies (ID)


income=income+(ERROR_P*per_company);
% Yytau;
% Print result
%  but_ar
%  but_Sxxx
%  top_ar;
 % top_Sxxx;
%  total_sum;
  



return
% function  meanpred = Ratappred(lowb, uppb,x,y,dg,tau); % Rational Regression.



% Multidimensional prognoz; popytka.
MMM=length(x); % General Length
KK = MMM/NN; %The amount of companies.
% NN amount of days.
for k = 1:KK % 12, e.g.
 for J = 1:NN % 311,e,g.
   
     a(k,J) = x(NN*(k-1) +J);
     
     %    nn(k) = fix(MMM/KK); % the number of firm.
 end %for J = 1:NN
end % for k=1:KK
a=a';
[r,b] = size(a); % r=311; b=1,% To day  b=1.
%AA=a(1:13,1:8);
%return
fclose(F);
n=length(x);

% for tau = 1:TA;

 tau= 1; % = TA; % E.G., time of prediction.

nta=n-tau;

if (nta <12)
disp('non-correctness');
return    
end % if     

XX = x(1:nta); % Truncation of array.
%LL = length(XX);

%x;
%XX(end); % Non-normed.
%Z=7;
t= 1:(nta);
tt = t/nta;  % May be without;
%tx = t/(nta); % x = tt; 

y = XX;
%y(end);

% Rap = Ratappred(0, 1,x,y,dgg,TA) % Rational Regression.
%x(end)

%Z=7;

%function [ Rap,  mn] = Ratappred(lowb, uppb,x,y,dg,tau); % Rational Regression.

% plot(t,x); grid on;
% Z=7;
 
 QQ = polyfit(tt,XX,4);

 VVV= polyval(QQ,tt);
 lVV =length(VVV);
 lta = length(tt);
% % 
%  VVVta = VVV(1:nta);
%   figure
%  plot(tt,VVVta,tt,XX); grid on;

%k=0;


xx0 = XX - VVV;
%nta =length(xx0);
%n;
%nta

XXtay(tau) = polyval(QQ,1+ TA/nta);  % Is the deterministic value of prediction.
XX_true=XX(end);

RelEr(tau)= 100*(XXtay(tau) - XX_true)/XX_true;

%Z=7;
%Dl = length(VVV) - length(XX);
%XXX=mean(x);
% 
% lowb=0; uppb= n;
% [MM  cRL YY  Tau  ESig  ENois  ErYY] = AdLegReg(lowb, uppb,tt,x); % Adaptive Legendre Regression.
% % 
% MM
% cRL
% 
% figure
% plot(tt,VVV,tt,XX); grid on;
 %plot(t,x);grid on;

[rr, M, Argm]=Kroscov(xx0,xx0,0);

%M
%rr
% 
% for K=1:(M+1)
% for L = 1:(M+1)
% [cv(K,L), M, Argm]=Kroscov(xx0,xx0, abs(K-L));
% %cv(K) =      
% end %for K
% end  %for L


for K=1:(M+1)
%for L = 1:(M+1)
[cov(K), M, Argm]=Kroscov(xx0,xx0, abs(K));
%cv(K) =      
end %for K
%end  %for L


if (tau >M)
xtau(tau) = xtay(tau);
disp('only trend prediction')    

RelEr= 100*(xtau(tau) - x_true)/x_true;

return
end  

[c0, M, Argm]=Kroscov(xx0,xx0, 0);

for K=1:(M+2)
[c(K), M, Argm]=Kroscov(xx0,xx0, abs(K));
%cv(K) =      
end %for K

%Cc=length(c)

%forming of matrix of system of equation.
for K=1:(M-tau)
for L = 1:(M-tau)
 if(K ~=L)   
 cv(K,L)=c(abs(K-L));
 else
  cv(K,L)=c0;   
 end
end %for K
end  %for L

CNN = cond(cv);

if(CNN > 1000000)
for KK = 1:(M+1)
    
cv(KK,KK) = cv(KK,KK)*1.02;    
    
end % for KK =1...    
end % if

for r=1:(M-tau)
b(r)=c(abs(tau+r-1));
end

%lb=length(b);
%solving of linear system

y = b/cv;

for k=1:(M-tau)
zz(k)=xx0(nta-k+1);
end

ranpred(tau) = sum(zz.*y);

%time_pred=tau;
xtay(tau)= ranpred(tau) + XXtay(tau)
%XX_true;
RelErPerCent(tau) = 100*(xtay(tau) - XX_true)/XX_true

% end  % for tau
xtrue=x(end)
xtay;
RelErPerCent; % = ? 

ytau;

% connect of two arrays

return