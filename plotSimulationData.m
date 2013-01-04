
function [currStrtgRetSeries RetSeriesStocks meanRetSeries] =  plotSimulationData(MAX_RUN_DAYS,START_CAPITAL,WINDOW_SIZE, stratgs_handles, symbols, cash_history, sim_hist_data,isShowPlot)



stratgs_num = length(stratgs_handles);
xx = 1:MAX_RUN_DAYS;
COMP_NUM =size(sim_hist_data,1);
currStrtgRetSeries = zeros(1,MAX_RUN_DAYS);
legendSymbols = '';
for ss = 1:stratgs_num
    curr_strg_profits = cash_history{ss};
    %add to legend current strategy name
    % symbols = strvcat(char(stratgs_handles{stratgs_num - ss+ 1}), char(symbols)) ;
    legendSymbols = strvcat(char(stratgs_handles{stratgs_num - ss+ 1}),legendSymbols) ;
    currStrtgRetSeries(ss,:)  = (curr_strg_profits - START_CAPITAL)./START_CAPITAL;
   % plot(xx,currStrtgRetSeries, '*-' ),hold on,

end

stocks_sim_start_index = WINDOW_SIZE+1;
stocksSimStartPrices = sim_hist_data(:,stocks_sim_start_index);

for cc =  1:COMP_NUM
    RetSeriesStocks(cc,:) = (sim_hist_data(cc,stocks_sim_start_index :end) - stocksSimStartPrices(cc))./stocksSimStartPrices(cc);
end

% create benchmark - mean of all assets
meanRetSeries = mean(RetSeriesStocks,1);

if isShowPlot == 1
legendSymbols = strvcat( char(legendSymbols),'mean') ;
saveDataFileName = strcat('./saved_data/d_',num2str(MAX_RUN_DAYS),'_c_',num2str(START_CAPITAL),'_w_',num2str(WINDOW_SIZE),'_', DATESTR(NOW));
    hFig = figure;
    %hPlot = plot(xx,currStrtgRetSeries', '*-' ,xx, RetSeriesStocks' ,'o-',xx,meanRetSeries,'x--');
    hPlot = plot(xx,currStrtgRetSeries', '.-' ,xx,meanRetSeries,'x--');
    title(['Income, starting capital:' num2str(START_CAPITAL) ]), legend( legendSymbols,'Location','NorthWest');      
    if exist('./saved_data','dir') ~=7
        mkdir('saved_data');
    end
    saveDataFileName = regexprep(saveDataFileName, ':', '_');
    saveDataFileNamepdf = strcat(saveDataFileName,'.pdf');
    saveas(hFig,saveDataFileNamepdf);
    saveDataFileNamefig = strcat(saveDataFileName,'.fig');
    saveas(hFig,saveDataFileNamefig);
     sendGMail(saveDataFileNamepdf,[]);
     close(hFig);
     
    delete(saveDataFileNamepdf);


 
 
 
save (saveDataFileName,  'xx', 'currStrtgRetSeries', 'RetSeriesStocks', 'symbols') ;
end
