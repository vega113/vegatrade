
function [new_hist_data symbols] = addBondsToHistData(hist_data,symbols, bond)
[k v] = size(hist_data);
new_hist_data(1:k,:) = hist_data;
new_hist_data(k+1,:) = bond(1:v);
symbols(k+1) = {'BONDS'};