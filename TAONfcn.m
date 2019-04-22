
%%       MEMORY PREPARATION
clear;
clc;
global book booktab formatOut defaultAnswer opts filetype filetypeUPPER;
%%       ASCII GRAPHICS

for i = 1
    ln1 = '___________.___                                     __      __.__                         .___';
    ln2 = '\_   _____/|   | ____ _____    ____   ____  ____   /  \    /  \__|____________ _______  __| _/';
    ln3 = ' |    __)  |   |/    \\__  \  /    \_/ ___\/ __ \  \   \/\/   /  \___   /\__  \\_  __ \/ __ | ';
    ln4 = ' |     \   |   |   |  \/ __ \|   |  \  \__\  ___/   \        /|  |/    /  / __ \|  | \/ /_/ | ';
    ln5 = ' \___  /   |___|___|  (____  /___|  /\___  >___  >   \__/\  / |__/_____ \(____  /__|  \____ | ';
    ln6 = '     \/             \/     \/     \/     \/    \/         \/           \/     \/           \/ ';
    ln7 = 'Version 1.8';
    
    tic
    line1 ='     ********   T R A N S A C T I O N   **********';
    line2 ='     ****************  I M P O R T  ****************';
    line3 ='     ********************  B O T ********************';
    copyright ='     © 2019 MICHAEL LAWRENSON';
    line5 ='Input file name [.csv]: ';
end

pcolor(rand(200)); % cool

%%       INITIALIZE WORKSPACE, SET DEFAULTS @@@@@
% set(0,'defaultfigureposition',[360   278   560   420])  % SYSTEM DEFAULT
close all
format long;
formatOut = 'mm/dd/yy'; % DATE FORMAT ***
CERT = 0.49;
ledgername = 'ledger.csv';
filetype = '.csv';
filetypeUPPER = '.CSV';
UIControl_FontSize_bak = get(0, 'DefaultUIControlFontSize');
set(0, 'DefaultUIControlFontSize', 10);   % MENU font size
set(0,'defaultfigureposition',[200   150   1000   500])   % default figure position
opts.Interpreter = 'tex';
opts.Resize = 'on';
defaultAnswer = {''};
checkmark = imread('checkmarkclipart2.png','BackgroundColor',[1 1 1]);
Neon = true;
format bank
Splash = sprintf('\n%s\n%s\n%s\n%s\n%s\n%s\n\n\t\t\t\t%s\n\t\t\t\t\t    %s\n\n',...
    ln1,ln2,ln3,ln4,ln5,ln6,copyright,ln7);

% fprintf('%s',Splash);   % SPLASH BANNER ******

%%       IMPORT DATA, READ RAW FILE TO TABLE
FILENAME = TAONgetfilename(defaultAnswer, opts, filetype, filetypeUPPER);
if ~strlength(FILENAME)
    return
end

if Neon; f = waitbar(.0,'Accessing file data','Name','File Import'); end
%%       READ DATA INTO ARRAYS, CREATE CELL ARRAY 'master'
[master, FSIZE] = TAONcreatemaster(FILENAME, formatOut);


if Neon; waitbar(0.1,f,'Checking for missing transactions...'); end
%%       MISSING DATA DETECTION & CORRECTION
master = TAONmissingentries(master, defaultAnswer, opts);


if Neon; waitbar(0.5,f,'Assigning transaction type...'); end
%%       ASSIGN TYPE COLUMN
master = TAONassigntype(master, FSIZE);


if Neon; waitbar(0.6,f,'Scrubbing dictionary...'); end
%%       SCRUB DICTIONARY OF EMPTY/VOID ENTRIES
scrubdictionary;


if Neon; waitbar(0.7,f,'Categorizing transactions...'); end
%%       CHECK IF CATEGORY HAS BEEN ASSIGNED YET, SEARCH & ASSIGN IF NEEDED, SKIP ROWS IF FILLED
master = TAONassigncategories(master, CERT);


if Neon; waitbar(0.8,f,'Assigning serial numbers...'); end
%%       SERIAL NUMBER ASSIGNMENT
master = TAONassignserial(master, FSIZE);


%%       book & booktab CREATION
[book, booktab, VarNames] = TAONcreatebook(master);


%% ================ DATA FOR GUI ================ %


if Neon; waitbar(0.9,f,'Calculating metadata...'); end
%%       CALCULATE METADATA VALUES
[fMETA, meta] = TAONmetadata(book);


%% ============= these code segments can also be employed on LEDGER data
%% for GUI display ======================================================


%%       NORMALIZED DAILY BALANCE (1)
[DAYNORM, scrub, h, NORMBAL] = TAONnormalizedbalance(book);
% *** scrub table not outputting properly, only displaying 1st column

%%       FREQUENCY OF OCCURRANCE BY CATEGORY (2)
[CATstr, CATsum, CATEGORY, CATFREQ] = TAONcategorytotals(book, booktab);


%%       DISPLAY CATEGORICAL EXPENSES, BAR GRAPH (3)
CATbar = TAONcategorybar(CATstr, CATsum);


%%       CATEGORY PIE CHART
CATPIE = TAONcategorypie(book, CATFREQ, CATEGORY);


%%       FINISHING UP
if Neon; waitbar(1,f,'Finishing up...'); end
if Neon; isvalid(f); delete(f); end
% uiwait(msgbox('Import Complete','Finance Wizard','custom',checkmark));


%% ---------------- M A I N   M E N U ----------------

while 1
    menuchoices = {'Unabridged Data';'Metadata';'Summarized Table';...
        'Categorized Totals';'Figure Display';'Display Ledger';...
        'Export Current Dataset';'Append Ledger';'Export Ledger';...
        'CLEAR SCREEN';'QUIT'};
    menutitle = sprintf('FINANCE WIZARD');
    button = menu(menutitle, menuchoices); % Popup Menu
%     button = 5
    set(0, 'DefaultUIControlFontSize', UIControl_FontSize_bak);
    
    switch button
        case {0,11} % EXIT CASE
            %             clear;
            return
        case 1     %       DISPLAY UNABRIDGED TABLE
            %       DISPLAY UNABRIDGED TABLE
            % inplement UITABLE with defined behavior for closing the
            % window
            % uitable(booktab) %//does not work in current form
            
%             disp(booktab);
%             f = figure;
%             uit = uitable(f);

            close all
            set(0,'defaultfigureposition',[180   50   960   520]);   % default figure position
            varnames = booktab.Properties.VariableNames;
            f = figure;
            uit = uitable(f);
            uit.Data = book;
            uit.Position = [20 20 940 490];
            uit.ColumnName = varnames;
            uit.ColumnEditable = false;
            uit.ColumnFormat =  {'bank'};
            uit.ColumnWidth = {80,50,300,50,50,70,60,80,70,70};
            uit.FontSize = 12;

        case 2    %       DISPLAY METADATA TABLE
            
            %       DISPLAY METADATA TABLE
            format bank
            close all
            set(0,'defaultfigureposition',[180   400   1050   60]);   % default figure position
            varnames = fMETA.Properties.VariableNames;
            f = figure;
            uit = uitable(f);
            uit.Data = meta;
            uit.Position = [20 20 1050 40];
            uit.ColumnName = varnames;
            uit.ColumnEditable = false;
            uit.ColumnFormat =  {'bank'};
            uit.ColumnWidth = {70,70,40,90,90,60,60,80,80,80,80,80,100};
            uit.FontSize = 12;
            %{
            fprintf('\n')
            disp(fMETA(1,1:3));
            fprintf('\n')
            disp(fMETA(1,4:5));
            fprintf('\n')
            disp(fMETA(1,6:8));
            fprintf('\n')
            disp(fMETA(1,9:11));
            fprintf('\n')
            disp(fMETA(1,12:13));
            fprintf('\n')
            format long
            %}
        case 3    %         DISPLAY SUMMARIZED TABLE FROM IMPORT
            
            %         DISPLAY SUMMARIZED TABLE FROM IMPORT
            %{
            format bank
            pdate = booktab(:,10);
            pvend = booktab(:,3);
            pdeb = booktab(:,4);
            pcred = booktab(:,5);
            pbal = booktab(:,6);
            pcat = booktab(:,8);
            printtab = [pdate pvend pdeb pcred pbal pcat];
            disp(printtab);
            format long
            %}
            close all
            set(0,'defaultfigureposition',[270   50   750   520]);   % window position & size
            Summary = [booktab(:,10),booktab(:,3),booktab(:,4),...
                booktab(:,5),booktab(:,6),booktab(:,8)];
            varnames = Summary.Properties.VariableNames;
            f = figure;
            uit = uitable(f);
            uit.Data = table2cell(Summary);
            uit.Position = [20 20 940 490];
            uit.ColumnName = varnames;
            uit.ColumnEditable = false;
            uit.ColumnFormat =  {'bank'};
            uit.ColumnWidth = {70,290,60,60,100,100};
            uit.FontSize = 12;
            
            
        case 4    %         DISPLAY CATEGORIZED CASH FLOW TOTALS, % OF SPENDING
            
            %         DISPLAY CATEGORIZED CASH FLOW TOTALS, % OF SPENDING
            format bank
            %        CONVERT TABLE TO CELL ARRAY, REMOVE POSITIVE AMOUNT(S)
            C = table2cell(scrub);
            Cnegatives = cellfun(@(x) x(x<0), C(:,3), 'UniformOutput',false);
            Ctotal = sum(cell2mat(Cnegatives));
            %        CALCULATE PERCENTAGE BY CATEGORY
            Percents = C(:,3);
            Percents = cell2mat(Percents);
            Percents = Percents/Ctotal*100;
            Percents = table(Percents);
            %        CREATE TABLE FROM RESULTS
            PCX = scrub(:,3);
            Breakdown = [PCX Percents];
            Breakdown.Properties.VariableNames = {'AMOUNT','PERCENT'};
            disp(Breakdown);
            format long
            
        case 5    %         CONTROL FUNCTION FOR FIGURE DISPLAY
            
            %         CONTROL FUNCTION FOR FIGURE DISPLAY
            % place code for actual figure generation here, so it will
            % re-display once closed and update as needed
            set(h,'visible','on','CloseRequestFcn',@figDelete);
            h.Name = 'Qualitative';
            return
%             figure('DeleteFcn',@myrequestclose)
            
            
            % set(handlesname,'CloseRequestFcn',@myrequest)
            
            
            
            
            
            
            
        case 6    %         DISPLAY LEDGER
            %         DISPLAY LEDGER
            ledgerFile = which(ledgername);
            if ~isempty(ledgerFile)
               ledgerDisplay = readtable(ledgerFile);
               disp(ledgerDisplay);
            else
                uiwait(errordlg('No existing ledger found'));
            end
            
        case 7    %         FILE NAME GENERATION & EXPORT
            
            %         PREPARE DATA FOR EXPORT
            %         FILE NAME GENERATION & EXPORT
            username = inputdlg('Specify name for export file [.CSV]:','Export Data');
            username = string(username{:});
            username = strrep(username,' ','_');
            OkToWrite = 1;
            if isempty(char(username))
                OkToWrite = 0;
%                 uiwait(errordlg('Export cancelled.','Export'));
                continue
            elseif contains(username,filetype)
                exportname =  username;
            elseif contains(username,filetypeUPPER)
                exportname = strrep(username,filetypeUPPER,filetype);
            else
                exportname = strcat(username,filetype);
            end
            if OkToWrite
                booktabx = booktab;
                booktabx.Transaction=[];
                writetable(booktabx,exportname);
                if isfile(exportname)
                    uiwait(msgbox('File successfully exported.','Export','Custom',checkmark));
                else
                    uiwait(msgbox('File could not be created.','Export','error'));
                end
            end
            
        case 8    %         APPEND LEDGER
            %   PROMPT USER FOR CONFIRMATION
            confirmmsg = sprintf('Are you sure you want to append ledger data?');
            reply = questdlg(confirmmsg, 'Confirm Selection', 'Yes', 'No', 'Yes');
            if strcmpi(reply, 'No')
                uiwait(msgbox('Append cancelled','Abort','warn'));
            else
                %         PREPARE DATA FOR APPENDING LEDGER
                alttab = booktab;
                alttab.Transaction=[];
                % if ledger exists, add current data
                if isfile(ledgername)
                    ledger_load = readtable(ledgername);
                    ledger_app = [ledger_load; alttab];
                    VBNames = ledger_app.Properties.VariableNames; % table variable names array 'str'
                    ledcel = table2cell(ledger_app);
                    dupestr = string(ledcel);  % 2 3 9
                    prettyarr = categorical(dupestr);
                    cleanleg = unique(prettyarr,'rows');
%                     fprintf('\n>>>\tLedger Entries:  %d\n',FSIZE);
                    ledger = cellstr(cleanleg);
                    tableg = cell2table(ledger);
                    tableg.Properties.VariableNames = VBNames;
                    tableg;
                    writetable(tableg,ledgername);
                    uiwait(msgbox('Ledger updated','Ledger Append','Custom',checkmark));
                else
                    writetable(alttab,ledgername);
                    uiwait(msgbox({'No existing ledger found';'New ledger created'},...
                        'Ledger Append','Custom',checkmark));
                end
            end
            
        case 9    %       EXPORT CURRENT LEDGER
                %       EXPORT CURRENT LEDGER
            ledgerFile = fileparts(which(ledgername));
%             ledgerFile = strcat(ledgerPath,'/',ledgername);
            if ~isempty(ledgerFile)
                exportledgermsg = inputdlg('Specify name for export file [.CSV]','Export Ledger',[1 50]);
                username = string(exportledgermsg{:});
                username = strrep(username,' ','_');
                if isempty(char(username))
                    OkToWrite = 0;
                    continue
                elseif contains(username,filetype)
                    exportname =  username;
                elseif contains(username,filetypeUPPER)
                    exportname = strrep(username,filetypeUPPER,filetype);
                else
                    exportname = strcat(username,filetype);
                end
                if OkToWrite
                    ledger_load = readtable(ledgerFile);
                    writetable(ledger_load,exportname);
                    if isfile(exportname)
                        uiwait(msgbox('File created','Ledger Export','Custom',checkmark));
                    else
                        uiwait(errordlg('File could not be created','Error','error'));
                    end
                end
            else
                uiwait(errordlg('No existing ledger found','Error','error'));
            end
            
        case 10   %     CLEAR COMMAND WINDOW
            clc;
            
        otherwise       % CATCH-ALL CASE
            uiwait(errordlg('Invalid selection','Error','error'));
    end
end



%% NOTES, etc



% plotbrowser(...) is GREAT for the GUI figure display, allows multiple
%     plot lines to be toggled on/off


% prepare memory
% ascii graphics
% set defaults
% file name specification
% read file data into arrays
% create cell array MASTER
% check for missing credit, debit, & balance amounts
% check and correct 1st balance entry (most recent amount) based on
%   available data.
% check if user clarification is required for 1st balance
% use balance & transaction to calculate missing values
% MAKE SURE NO ERRORS WERE MADE
% assign TYPE column values
% scrub dictionary
% search, algorithm for categorization
% serial number assignment
% flip cell array upside down: BOOK
% some light housekeeping with table formatting & naming

% === START OF META ANALYSIS === %
% determine standard metadata values from callable variables
% calculate unique days
%   normalized daily balance
%   subplot of normal balance
% frequency of category occurrance
%   subplot transaction frequency pie chart
% categorical expenses subplot
% pie chart visibility control

% === MAIN MENU === %
% options 1-9



















%{
for i = 1:FSIZE
    if strcmp(master(i,8),'') == 1
        fprintf('\nPRESS ENTER TO SKIP\n\n');
        TERM = master(i,3);
        Wrdef = newentry(TERM);
        master(i,8) = {Wrdef};
        end
end


    
toc
%}
% ZZZ = cell2table(master)
%{
if cell2mat(master(1,6)) == 0
    tmp2 = master(ii,6)
    tmp1 = master(ii+1,6)
    amt = cellfun(@minus,tmp2,tmp1)
end
%}
























