
function[Doh]=BSImprovYuri(deep,TA,days,sum_money,B );
% 17.11.07; 19.11.00, 16 - 25.1.008; %% 23.2.08; 1.3.08;
% %8.3.2008;%15.3.08;

dgg=6;  %% Degree of polynomial
dg = 4; % The degree of ratiopnal approximation;
%
%dg = dgg - 2;
TA=1; %% Time of prediction
tau = TA; % Switch;
sob = 7; % Amount of eigen numbers and vectors;
distr = [0.7 0.1 0.1 0.1 0.0]; % The distribution of the best companies;


sum_money=1000; %% Source money

coef = 0.0075;
aug = 0.0045;

kf = 0.0055; % 18.3.08


%WORK.
UU = zeros(1,days);
ld = length(distr);

income(1) = sum_money;
III=1; % The start point;
I=1; % After;

[AA CC]=size(B); %  = 14  \times 1004; eg.
% SDCC = min(CC, SD + TA);

% Puring;
JJJJ=0;
for(BM=1:AA)
    for(DD=1:CC)
        if( (abs(B(BM,DD))<0.0001)& (DD > 1.23)   )
            B(BM,DD)= max( B(BM,DD-1), 0.0001);
            if( abs(B(BM,DD))<0.0001)
                JJJJ=JJJJ+1;
            end
        end
    end
end

[AAA CCC]=size(B); % 14  \times 1004; eg;


[SD FD] = size(B);  

NomCom = 1:SD;
income(1)=sum_money;
% The main loop;



    lowb =FD - deep-1;
    uppb= FD;
    BOUND=uppb-lowb+1; %deep+1
    
    ADBOUND = BOUND + TA;
    for KKK = 1:SD
        CHECKBI(KKK)= B(KKK, ADBOUND);
        LASTVAL(KKK) = B(KKK, BOUND); % The last value;
        NEXTVAL(KKK) = B(KKK, ADBOUND); % The next value.
        enpoin(IDA) = LASTVAL(KKK);
    end % for KKK= 1:SD

    BI = B(:, lowb:uppb);
    [aBI  bBI] = size(BI); %% = 33 \times 101;
    ltr = fix(aBI/3);
    ltr = min(ltr,length(distr));
    distr = distr(1:ltr);           %%min(ld,sob));
    if(min(distr) < 0)
        dm = abs(min(distr)); % + distr
        distr = distr + dm;
    end % if min;

    sm = sum(abs(distr));
    distr = distr/sm ; % Norming;
    Z=7;
    [DF GF]= size(BI);  % = 12 \times 101;
    for RR = 1:DF
        % for RR = 1:SD
        for QQQ = 1:GF

            zz(QQQ) = BI(RR,QQQ); % Row "RR";

        end  % for QQQ

        ZR = Ratapp(zz);
        lzr = length(ZR);

        [AA BV] = size(BI);
        DF = min(BV,DF);
        %% DF
        for QQR = 1:DF % Instead CF
            RR = min(RR,DF);

            BIC(QQR, RR) = BI(QQR, RR) - ZR(RR);

        end
    end %for RR

    for IIJ = 1:DF
        for JJI = 1:DF

            ar  = BIC(:, IIJ); % Array;
            br = BIC(:, JJI);  % Array;
            KOV(IIJ, JJI) = xcorr(ar, br, 0,'unbiased');

        end % for JJI
    end % for IIJ
    [aKV bKV] = size(KOV);
    [bBI aBI] = size(BIC); % =  21 \times 101;

    [UU VV] = eigs(KOV);
    UU = real(UU);
    VV = real(VV);
    
    
     Gvul = max(round(SD/10),sob); % EG;
     Gvul = min(Gvul,SD);  % In such a case;


    for KK = 1:Gvul   % The number of important component;
        for ll = 1:SD     % Amount of companies;

            [aUU  bUU] = size(UU);

            ll = min(ll,aUU);
            SDKK = min(bUU, SD - KK + 1);
            EgU(ll,KK) = UU(ll,SDKK);

        end % for ll = 1:SD = amount of companies;

    end % for KK = 1:Gvul;

    [BB aa] = size(BIC);

    [as  bs] = size(EgU);
    [bia  bib] = size(BI);

    aas = min(as,bia);

    EgU = EgU(1:aas,:);
    BI = BI(1:aas,:);

    MT = EgU'*BI;

    for KKKL = 1:Gvul
        CHECKETA(KKKL)=0;
        for JJ = 1:BOUND
            eta(KKKL,JJ) = 0;

        end % for JJ
    end % for KKKL = 1:Gvul  

    eta = MT;
    [aet  bet] = size(eta);
    
    for IJJ = 1:aet

        for KL = 1:bet
            tt(KL) = KL;
            xa(KL) = eta(IJJ,KL);
        end % for KL

        [xtau(IJJ), come(IJJ)]=Mododpred(xa, 4, TA); % The main component prediction;
       
    end % for IJJ=1:aet
    Hiz = xtau*EgU';
    % Z=7;

    lhiz = length(Hiz);
    lLAS = length(LASTVAL);
    lNEX = length(NEXTVAL);

    lgen = min( min(lhiz,lLAS),lNEX);

    Hiz = Hiz(1:lgen);
    LASTVAL = LASTVAL(1:lgen);
    NEXTVAL = NEXTVAL(1:lgen);


    Prir = Hiz- LASTVAL;
    RePrir = Hiz - NEXTVAL;

    lPrir = length(Prir); % = 11, eg;
    spis = 1:lPrir;

    
    [sPrir, num] = tds(Prir, spis);
  

    ldis = length(distr);
    lPr = length(sPrir);
    for IJK = 1:ldis
        vc(IJK) = sPrir(lPr - IJK +1);
        wc(IJK) = -sPrir(IJK);
    end % for IJK
  

    cruc(IDA) = sum(vc.*distr);
    crucm(IDA) = sum(wc.*distr);

    cruc(IDA)= max(cruc(IDA), crucm(IDA));
    umm(IDA) = cruc(IDA);
    VV0(IDA) = income(IDA);

    VV1 = LASTVAL(num(end));
    VV1m = LASTVAL(num(1));

    nmv(IDA) = VV1;
    WW1 = NEXTVAL(num(end));
    WW1m = NEXTVAL(num(1));

    mnw(IDA) = WW1;
    IDAm1 = max(IDA-1,1);
    Dif = income(IDA) - income(IDAm1);

    if (cruc(IDA) >= kf*crucm(IDA) )

        if( (cruc(IDA) > coef*VV0(IDA))& (cruc(IDAm1) > aug*VV0(IDAm1) ) )
            income(IDA+1) = income(IDA)*WW1/VV1;
        else
            income(IDA + 1) = income(IDA);
        end % if

    else

        if( (crucm(IDA) > coef*VV0(IDA))& (crucm(IDAm1) > aug*VV0(IDAm1) ) )
            income(IDA+1) = income(IDA)*WW1m/VV1m;
        else
            income(IDA + 1) = income(IDA);
        end % if

    end  %(if cruc >= crucm))
   

%  income

Lin = length(income);
tme = 1:Lin;

Doh= income(1)*(income(end)/income(1))^(250/days);
income(end)

figure
plot(tme,income); grid on;

return




