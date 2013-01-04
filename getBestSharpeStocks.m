function [indBestStocks] =  getBestSharpeStocks(hist_data, Rf,maxBestStocks)
    %-------------- Sharpe ----------------------------
     sharpeRatio = sharpe(hist_data',Rf);
     %--------------------------------------------------------------------
     [valSortedSharpe indSortedSharpe] = sort(sharpeRatio,2,'descend') ;
     indBestStocks = indSortedSharpe(1:maxBestStocks);
     