function TAONinitialize()
%%       INITIALIZE WORKSPACE, SET DEFAULTS

% set(0,'defaultfigureposition',[360   278   560   420])  % SYSTEM DEFAULT
% clear; clc;
% clearvars -global
% global formatOut CERT ledgername filetype filetypeUPPER UIControl_FontSize_bak defaultAnswer checkmark;

close all
format long;
formatOut = 'mm/dd/yy'; % DATE FORMAT ***
CERT = 0.49;
ledgername = 'ledger.csv';
filetype = '.csv';
filetypeUPPER = '.CSV';
UIControl_FontSize_bak = get(0, 'DefaultUIControlFontSize');
set(0, 'DefaultUIControlFontSize', 10);   % MENU font size
set(0,'defaultfigureposition',[100   100   1300   800])   % default figure position
opts.Interpreter = 'tex';
opts.Resize = 'on';
defaultAnswer = {''};
checkmark = imread('checkmarkclipart2.png','BackgroundColor',[1 1 1]);
% phrase = ' ';
% replace = '_';
% Fontsize = 10;
set(0,'defaultfigureposition',[360   278   560   420])

end