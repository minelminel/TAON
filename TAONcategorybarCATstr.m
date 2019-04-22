function CATbar = TAONcategorybarCATstr, CATsum)
%%       DISPLAY CATEGORICAL EXPENSES, BAR GRAPH

CATSTRING = CATstr;
AMOUNT = CATsum;
TTT = table(CATSTRING, AMOUNT);
STATS = grpstats(TTT,'CATSTRING','sum');
barCAT = STATS(:,[1,3]);
barX = categorical(table2array(barCAT(:,1)));
barY = table2array(barCAT(:,2));
subplot(2,3,1:2);
CATbar = bar(CATstr,CATsum,...
    'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.5);
title('CASH FLOW BY CATEGORY');
ylabel('$');
CATbar;

end