

START_CAPITAL = 1000;
MAX_RUN_DAYS  = 5;
initWinSize    = 52; % 
maxWinSize     = 52;
stepWinSize    = 1; % should be >0 since we divide by it.
stepStart      = 1;

 [new_hist_data new_symbols] = addBondsToHistData(hist_data,symbols, bonds);
 
dateTimeStr = datestr(now);
dateTimeStr =  regexprep(dateTimeStr, ':', '_');

isShowPlot = 1;
symbols;
new_hist_data;


if exist('./saved_data','dir') ~=7
    mkdir('saved_data');
end

dateStr = date();
todayDirName = strcat('./saved_data/testData',dateStr);
if exist(todayDirName,'dir') ~=7
    mkdir(todayDirName);
end
testDataAllName = strcat(todayDirName,'/','testDataAll',dateTimeStr,'.txt');
testDataEndName = strcat(todayDirName,'/','testDataEnd',dateTimeStr,'.txt');
testDataRetsName = strcat(todayDirName,'/','testDataRets',dateTimeStr,'.txt');

fid1 = fopen(testDataAllName,'w+');
fid2 = fopen(testDataEndName,'w+');
fid3 = fopen(testDataRetsName,'w+');
stratgs_handles={@strtgyCAPMRA @strtgyCAPMRA2} ;
for testWinInd = 1:1:  fix((maxWinSize- initWinSize)/(stepWinSize))+1
    for testStartInd = 1:1
         
        tic
        WINDOW_SIZE   = initWinSize + (testWinInd-1)*stepWinSize
        START_INDEX   = (testStartInd-1)*stepStart
        
        historyLength  = MAX_RUN_DAYS + (START_INDEX + WINDOW_SIZE) ;
        
        if historyLength - size(new_hist_data,1)>0

            Rf            = 0;

            
            if ~exist('forecastHist','var')
                 [forecastHist] = generateForecasts(MAX_RUN_DAYS,WINDOW_SIZE,START_INDEX,new_hist_data);
                 todayStr = date();
                 forecastFileName = strcat('forecast_hist_d',num2str(MAX_RUN_DAYS), '_w', num2str(initWinSize) , '_todayStr');
                 save(forecastFileName, 'forecastHist');
            end
             
            [ cash_history portfolio_history currStrtgRetSeries RetSeriesStocks meanRetSeries] =  run_sim_stock_forecast(START_CAPITAL,MAX_RUN_DAYS,WINDOW_SIZE, START_INDEX, Rf,char(new_symbols), new_hist_data, stratgs_handles,isShowPlot,forecastHist);
            reportRetData{testWinInd}{1} = meanRetSeries;
            reportRetData{testWinInd}{2} = RetSeriesStocks;
            reportRetData{testWinInd}{3} = currStrtgRetSeries;
            saveRunResultFileName = strcat(todayDirName,'/','saveRunResult',num2str(testWinInd),'_',dateTimeStr);
            
            str1 = ' WINDOW_SIZE =';        str1 = [str1 num2str(WINDOW_SIZE)];
            str1 = [str1 ' START_INDEX =']; str1 = [str1 num2str(START_INDEX)];
            str1 = [str1 ' MAX_RUN_DAYS =']; str1 = [str1 num2str(MAX_RUN_DAYS) '\n'];

            fprintf(fid1, str1 );
            fprintf(fid2, str1 );


            fprintf(fid1, [num2str(cash_history{1}(1:end)) '\n'] );
            fprintf(fid1, [num2str(cash_history{2}(1:end)) '\n']);
            fprintf(fid1, [num2str( meanRetSeries*START_CAPITAL + START_CAPITAL) '\n']);

            fprintf(fid1, [num2str(currStrtgRetSeries(1,:)) '\n']);
            fprintf(fid1, [num2str(currStrtgRetSeries(2,:)) '\n'] );
            fprintf(fid1, [num2str(meanRetSeries) '\n']);
            %-------------------------------------------
%             fprintf(fid2, [' strtgyVaR: ' num2str(cash_history{1}(end)) ]);
%             fprintf(fid2, [' simpleStrg: ' num2str(cash_history{2}(end)) ] );
%             tmp = (meanRetSeries*START_CAPITAL+ START_CAPITAL);
%             fprintf(fid2, [' mean: ' num2str( tmp(end) )  ]);
%             fprintf(fid2,  '\n ');
% 
%             fprintf(fid2, [' ret strtgyVaR: ' num2str(currStrtgRetSeries(1,end)) ]);
%             fprintf(fid2,  [' ret simpleStrg: ' num2str(currStrtgRetSeries(2,end)) ] );
%             fprintf(fid2,'%s', [' ret mean: ' num2str(meanRetSeries(end))] );
%             fprintf(fid2,  '\n ');
            
            repStrtgRetSeries1(testWinInd,:) =  currStrtgRetSeries(1,end) ; 
            repStrtgRetSeries2(testWinInd,:) =  currStrtgRetSeries(2,end) ;
            repMeanRetSeries(testWinInd,:) =  meanRetSeries(end);
            repWinSize( testWinInd) =   WINDOW_SIZE;
            
          
        end
        % save data test result to file
        toc
    end
end
save(saveRunResultFileName,'cash_history','portfolio_history','currStrtgRetSeries','RetSeriesStocks','meanRetSeries','repStrtgRetSeries1','repStrtgRetSeries2','repMeanRetSeries','repWinSize','reportRetData','stratgs_handles');

  fprintf(fid3,  '%4.2f ', repStrtgRetSeries1);
 fprintf(fid3,  '\n ');
fprintf(fid3, '%4.2f ', repStrtgRetSeries2 );
fprintf(fid3,  '\n ');
fprintf(fid3, '%4.2f ',  repMeanRetSeries);
fclose(fid1);
fclose(fid2);
fclose(fid3);


