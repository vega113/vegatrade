function [data symbs]  = cutHistData(start_pos,end_pos, hist_data, symbols)
data=hist_data(start_pos:end_pos,:);
symbs=symbols(start_pos:end_pos);
