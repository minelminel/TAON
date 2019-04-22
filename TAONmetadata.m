function [fMETA, meta] = TAONmetadata(book)
%%       CALCULATE METADATA VALUES

%         DETERMINE METADATA VARIABLES, POPULATE TABLE WITH VALUES
%  > calculate start date, DAYSTART
DAYSTART = book{1,2};
STARTstr = book{1,10};
%  > calculate end date, DAYEND
DAYEND = book{end,2};
ENDstr = book{end,10};
%  > calculate number of days covered, DAYRANGE = DAYEND - DAYSTART
DAYRANGE = DAYEND - DAYSTART;
%  > assign starting balance, S_BAL
ST_BAL = book{1,6};
%  > assign ending balance, E_BAL
EN_BAL = book{end,6};
%  > calculate sum of debit, DEBITSUM
DEBITSUM = sum(cellfun(@double,book(:,4)));
%  > calculate sum of credit, CREDITSUM
CREDITSUM = sum(cellfun(@double,book(:,5)));
%  > calculate cash flow, CASHFLOW = DEBITSUM + CREDITSUM
CASHFLOW = DEBITSUM + CREDITSUM;
%  > calculate avg daily spending AVGSPE = DEBITSUM / DAYRANGE
AVGSPE = DEBITSUM / DAYRANGE;
%  > calculate avg daily earning AVGEAR = CREDITSUM / DAYRANGE
AVGEAR = CREDITSUM / DAYRANGE;
%  > calculate net change, NETDIFF = E_BAL - S_BAL
NETDIFF = EN_BAL - ST_BAL;
%  > calculate avg daily cash flow AVGDAYFLOW
AVGDAYFLOW = NETDIFF / DAYRANGE;
%  > calculate percent growth, NETPER = (E_BAL - S_BAL) / S_BAL
NETPER = ((EN_BAL - ST_BAL) / ST_BAL) * 100;

%       meta CELL ARRAY CREATION & TABLE VARIABLE NAME ASSIGNMENT
meta = {STARTstr,ENDstr,DAYRANGE,ST_BAL,EN_BAL,...
    DEBITSUM,CREDITSUM,CASHFLOW,AVGSPE,AVGEAR,AVGDAYFLOW,...
    NETDIFF,NETPER};
fMETA = cell2table(meta);
fMETA.Properties.VariableNames{'meta1'} = 'Start_Date';
fMETA.Properties.VariableNames{'meta2'} = 'End_Date';
fMETA.Properties.VariableNames{'meta3'} = 'Days';
fMETA.Properties.VariableNames{'meta4'} = 'Initial_Balance';
fMETA.Properties.VariableNames{'meta5'} = 'Ending_Balance';
fMETA.Properties.VariableNames{'meta6'} = 'Spent';
fMETA.Properties.VariableNames{'meta7'} = 'Earned';
fMETA.Properties.VariableNames{'meta8'} = 'Cash_Flow';
fMETA.Properties.VariableNames{'meta9'} = 'Daily_Spending';
fMETA.Properties.VariableNames{'meta10'} = 'Daily_Earning';
fMETA.Properties.VariableNames{'meta11'} = 'Daily_Flow';
fMETA.Properties.VariableNames{'meta12'} = 'Net_Change';
fMETA.Properties.VariableNames{'meta13'} = 'Percent_Change';
fMETA;
end
