function [DAYNORM, scrub, h, NORMBAL] = TAONnormalizedbalance(book)
%%       DETERMINE NUMBER OF UNIQUE DAYS & FREQUENCY OF OCCURRANCES, CREATE TABLE

%  > convert fDATE to string, fDATESTR
fDATESTR = book(:,10);
%  > generate string array of unique dates, day_un
day_un = unique(fDATESTR);
%  > determine number of unique days, d_no
d_no = length(day_un);
%  > generate categorical array of ALL dates, day_ct
day_ct = categorical(fDATESTR);
%  > generate cell array of unique days, day_serial
day_serial = categories(day_ct);
%  > generate array of corresponding occurrances of unique days
day_freq = countcats(day_ct);
dTABLE = table(day_serial, day_freq);


%%       NORMALIZED DAILY BALANCE
DATESTRING = fDATESTR;
BALANCE = cell2mat(book(:,6));   % BALANCE = cell2mat(fBAL); % ***** changed to book from MASTER (1/23/19)
T = table(DATESTRING, BALANCE);
STATS = grpstats(T(:,1:2),'DATESTRING','sum');
NORMBAL = table(zeros(height(STATS),1));
CONCAT = [STATS NORMBAL];
CONCATdb = CONCAT(:,2:end);
CONCATarr = table2array(CONCATdb);
DAYNORM = CONCATarr(:,2) ./ CONCATarr(:,1);
scrub = STATS(:,1);
DATESCR = table2array(scrub);
DAYNORM;



h = figure('visible','off');
%       DISPLAY GRAPH OF NORMBAL
%       KEEP FLAG = 1

%     figure;
subplot(2,3,4:6);
hold on
yMAX = 1.25 * max([book{:,6}]);     %  MAX. Y-axis value
NORMBAL = plot(datetime(DATESCR),DAYNORM,'--gs',... % added 'h =' assignment
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5]);
title('NORMALIZED DAILY BALANCE');
xlabel('DATE');
ylabel('DOLLARS $');
ylim([0 yMAX]);

end