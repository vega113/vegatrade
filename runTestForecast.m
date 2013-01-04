
%hist_data        input
clear predHiz  signM  varP retPerDayPerCompany averageRetPerDay signM1
MAX_RUN_DAYS  = 50;
initWinSize    = 60; %
maxWinSize       = 1;
stepWinSize     = 5; % should be >0 since we divide by it.
stepStart          = 50;
TA=1;
indDelayStart = 0;
for winInd = 1:maxWinSize

    WINDOW_SIZE = initWinSize +(winInd - 1)*stepWinSize;

    for runDay = 1:MAX_RUN_DAYS

         sim_start_index = indDelayStart + runDay;
        sim_end_index       = sim_start_index-1+ WINDOW_SIZE;

        % cut time seroes data, create sim data to work with
        sim_hist_data = hist_data(:,sim_start_index:sim_end_index);

         Hiz = ForecastStocks(WINDOW_SIZE, TA, sim_hist_data );
         predHiz{winInd} ( :,runDay) = Hiz';
         cprintf('blue','%d ',runDay);
         if mod(50,runDay ) == 0
             sprintf('\n');
         end
    end
    
    signM1{winInd} =  sign( predHiz{winInd}  -  hist_data(:,  WINDOW_SIZE:WINDOW_SIZE+MAX_RUN_DAYS-1) ) .*  ...
                        sign( hist_data(:,  WINDOW_SIZE+1:WINDOW_SIZE+MAX_RUN_DAYS)  -  hist_data(:,  WINDOW_SIZE:WINDOW_SIZE+MAX_RUN_DAYS-1) );
    retDif{winInd} =  (  predHiz{winInd}   -  hist_data(:,  WINDOW_SIZE +1 :WINDOW_SIZE+MAX_RUN_DAYS)  )./hist_data(:,  WINDOW_SIZE:WINDOW_SIZE+MAX_RUN_DAYS-1) ;
    varP (winInd,:)  =    var(   ( predHiz{winInd}   -  hist_data(:,  WINDOW_SIZE +1 :WINDOW_SIZE+MAX_RUN_DAYS)  )./ hist_data(:,  WINDOW_SIZE +1 :WINDOW_SIZE+MAX_RUN_DAYS)   ,0,2  )  ;
    
    retPredVs2day = (predHiz{winInd}  -  hist_data(:,  WINDOW_SIZE:WINDOW_SIZE+MAX_RUN_DAYS-1))./ hist_data(:,  WINDOW_SIZE:WINDOW_SIZE+MAX_RUN_DAYS-1);
    retNextVs2day = ( hist_data(:,  WINDOW_SIZE+1:WINDOW_SIZE+MAX_RUN_DAYS)  -  hist_data(:,  WINDOW_SIZE:WINDOW_SIZE+MAX_RUN_DAYS-1));
    
    signM{winInd} =  sign(retPredVs2day) .*   sign( retNextVs2day);
    retPerDayPerCompany{winInd} = signM{winInd} .* abs(retNextVs2day);
    
    averageRetPerDay{winInd}= mean(signM{winInd} .* abs(retNextVs2day));    
    
    for ii = 1:MAX_RUN_DAYS
            posit(ii) = 2*length(    find  (   retPerDayPerCompany{winInd}(:,ii) >0)  )    - size(hist_data,1)     ;
    end
    
    signM1{winInd} == signM{winInd};

 x = [1:size(hist_data,1)];
 y = [1:MAX_RUN_DAYS];
[xx,yy] = meshgrid(x,y);
%figure, plot3(xx,yy,retPerDayPerCompany{winInd}','.'),xlabel('Companies'),ylabel('Days'),xlabel('mean return'),title('Plot of returns differences VS. forecast direction prediction');
figure, subplot(2,1,1),
plot(yy,averageRetPerDay{winInd},'.'),xlabel('Time'),ylabel('Mean return'),title('Plot of mean returns differences');
subplot(2,1,2), plot(posit, '.')  
 if sum(averageRetPerDay{winInd}) < 0
     cprintf('red', ' mean number of correct direction predictions %4.2f\n', sum(averageRetPerDay{winInd}))
 else
     cprintf('green',  ' mean number of correct direction predictions: %4.2f\n', sum(averageRetPerDay{winInd}))
 end
 
  if sum(mean(signM{winInd})) < 0
     cprintf('red', 'average per day: %4.2f\n', sum(mean(signM{winInd})))
 else
     cprintf('green', 'average per day: %4.2f\n', sum(mean(signM{winInd})))
 end
end
 

