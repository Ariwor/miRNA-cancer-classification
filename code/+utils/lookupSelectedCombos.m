function miRdata= lookupSelectedCombos(miRcombos,comboCoverage,comboSat,updownSat, ...
  pvals,all_miRnames,primtumor,normal,regulation)
% Integrate relevant information for the specified up/down-regulated miRNA combo

upmir= miRcombos(:,1); downmir= miRcombos(:,2);
upsat= updownSat{1}; downsat= updownSat{2};

Upregulated_miR= all_miRnames(upmir);
Downregulated_miR= all_miRnames(downmir);

Significance= cell(size(upmir,1),1);
for i=1:size(upmir,1)
  if max([pvals(upmir(i)),pvals(downmir(i))]) < 0.001
    Significance{i}= '<0.001';
  elseif max([pvals(upmir(i)),pvals(downmir(i))]) < 0.01
    Significance{i}= '<0.01';
  elseif max([pvals(upmir(i)),pvals(downmir(i))]) < 0.05
    Significance{i}= '<0.05';
  end
end
Coverage= round(sum(comboSat,2)./size(comboSat,2)*100,1);
Inc_Coverage= round(comboCoverage./size(comboSat,2)*100,1);

Mean_Fold_change_Up= exp(mean(regulation(upmir,:),2));
Mean_Tumor_Normreads_Up= arrayfun(@(mir) mean(primtumor{mir,upsat(mir,:)},2), upmir);
Mean_Normal_Normreads_Up= mean(normal{upmir,:},2);

Mean_Fold_change_Down= 1./exp(mean(regulation(downmir,:),2));
Mean_Tumor_Normreads_Down= arrayfun(@(mir) mean(primtumor{mir,downsat(mir,:)},2), downmir);
Mean_Normal_Normreads_Down= mean(normal{downmir,:},2);

miRdata= table(Upregulated_miR,Downregulated_miR, Significance,Coverage,Inc_Coverage, ...
  Mean_Fold_change_Up,Mean_Tumor_Normreads_Up,Mean_Normal_Normreads_Up, ...
  Mean_Fold_change_Down,Mean_Tumor_Normreads_Down,Mean_Normal_Normreads_Down);
