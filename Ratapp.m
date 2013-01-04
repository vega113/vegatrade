
function yapp = Ratapp1(y); % Rational Regression.

% clc
%tic
%7.1.7; 11.00 h. 12.1.2007; 23.6.07; 17 45 h;
% Here   1 <= a < b < + Inf; X \in (a,b);
% x,y are given arrays; size(x) = size(y);

% This program calculated the  Rational approximation for 
% a function Y = f(X) using the dates y(i) = f(x(i)) + epsilon(i).
% {x(i)}  is arbitrary, but  xx(i) \in [a,b].; This is a complete new
% algorithm. 
% "P0' is a polynomial of Nominator;
% "Q0" is a polynomial  of Denominator.
% "x" is a time;

% INPUT:  a = lowb ( = low boundary), uppb (upper boundary), "x" and "y"
% are  arrays, such that  y \approx f(x), x \in (a,b).
% "dg" is a degree of app.; = 4; in nom. and denom.
% "tau" is the time of prediction. Integer, positive.


% OUTPUT:
% "Rat" = Rational Approximation (ARRAY);
% mn = min(y).

% The tries, for verification.
% %YY = 0; % Only for initialisation.
% 
 dg = 4; % EG.
% tau = 1; % e.g. = tauprediction?
% 
% %----------------------------------------------------------------------
% % Only Initialisation.
  
 %    NNN =100; % for example.
 %      x = [1:NNN];
% % %  
% % %===============================
% %  % Norming.
% 
       NNN = length(y);

       x = 1:NNN;
      % NNN = length(x); % Le ma?
% % %   
     
 
%===============================
 % Norming.





 
 mn = min(y);
 amn = abs(mn) + 1; % always calculate?

 %if (  mn < 0.00001 )     % 21.11.2006;
    ysh = y + amn; % In such a case. % 21.11.2006

  



[AAA  BBB] = size(y);
if (AAA > BBB)
   ysh = ysh';
end % AA BB

AB = BBB;



 J=0; % Puring.




 y0=y;



 PolR0 = polyfit(x,y0, dg); % Polynomial approximation;
 ValPolR0 = polyval(PolR0,x); % Polynomial approximation;





zz = ValPolR0./y0;

PolQ0 = polyfit(x,zz, dg);

ValpolQ0 = polyval(PolQ0,x);







  lVal = length(ValpolQ0);

 for JL = 1:lVal
    
     if ( abs(ValpolQ0(JL)) < 0.00001) 
         if ((JL ~=1) && (JL ~=lVal))
             ValpolQ0(JL) = 0.5*(Valpol(JL-1) + Valpol(JL + 1) );
         elseif (JL == 1 )
             ValpolQ0(1) = ValpolQ0(2);
         elseif ( JL == lVal )           
           ValpolQ0(lVal)= Valpol(lVal-1);
         end % ifelseif
     end % if 
 end % for IL=...    
   

ValpolR0 = ValPolR0;
Rat0 = ValpolR0./ValpolQ0;


 ERRat0 = max(abs(y(1:end) - Rat0(1:end) ));
 ERRAT0_L2 = norm(y(1:end) - Rat0(1:end));


% %======================================
  % The second iteration;
  % Again
  y1 = y - Rat0; % The difference between...

 mn1 = min(y1); 
 amn1 = abs(mn1) + 1; % always calculate?
  
 ysh1 = y1 + amn1; % In such a case. % 21.11.2006

PolR1 = polyfit(x,ysh1, dg);
ValPolR1 = polyval(PolR1,x);
 ERPolR1 = max(abs(ValPolR1(1:end) - ysh1(1:end) ));

zz1 = ValPolR1./ysh1;

PolQ1 = polyfit(x,zz1, dg);

ValPolQ1 = polyval(PolQ1,x);
%lv = length(ValPolQ1);
Rat1 = ValPolR1./ValPolQ1;   % Array!

%nom =   polyval(PolR1,xpred);
%denom = polyval(PolQ1,xpred);

Rat1 = Rat1 - amn1; % \approx y1 =y - Rat0;

Rat01 = Rat0 + Rat1;
%lrat=length(Rat01);

  %ERRat1 = max(abs(y1 - Rat1));

  ERRat01 = max(abs(y(1:end) - Rat01(1:end)));
  ERRAT01_L2 = norm(y(1:end) - Rat01(1:end));

if ( (ERRat0 <  ERRat01) ) %|( abs(denom)< 0.0001) ) 
  
    yapp = Rat0;
        
else 
    %    denom = sign(denom)*max(abs(denom),0.0001);
    %    yapp = nom/denom -amn1; 
     yapp = Rat01;
end % if sofit;

  return







