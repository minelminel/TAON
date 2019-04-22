function FILENAME = TAONgetfilename(defaultAnswer, opts, filetype, filetypeUPPER, DefaultTestFile)
% function FILENAME = TAONgetfile()
% if a filename str is included as argument, it will automatically
% force that file to be read and bypass the user input stage.
% To gather input from user, call the function with no input arguments.
%%       IMPORT DATA, READ RAW FILE TO TABLE
% global defaultAnswer opts filetype filetypeUPPER;
switch nargin
    case 5
          DefaultTestFile = 'mtbtemp.csv';
%         DefaultTestFile ='momdad2.CSV';
%         DefaultTestFolder = fileparts(which(DefaultTestFile));
        %     FILENAME = strcat(DefaultTestFolder,'/',DefaultTestFile);
%         FILENAME = 'momdad2.csv';
        FILENAME = DefaultTestFile;
%         fprintf('Reading from %s\n',DefaultTestFile);
        
    case 4
        while 1
            splashmessage = {'Input file name [.csv]:'};
            imstr = inputdlg(splashmessage,'Finance Wizard',[1 50],defaultAnswer,opts);
            
            if isempty(imstr)    % EXIT CASE
                FILENAME = {''};
                break
                % return
            end     % 3 OPTIONS: EXISTS AS original, cat(filetype), cat(filetypeUPPER)
            userfile = imstr{:};   % filename exactly as entered by user
            LoadFilePath = {''};
            % Check if file contains .csv, .CSV
            if contains(userfile,filetype) || contains(userfile,filetypeUPPER) % userfile has '.csv' OR '.CSV'
                % Check if file exists as typed
                FileExistance = which(userfile);
                if ~isempty(FileExistance) % File must exist as typed
                    LoadFilePath = which(userfile);
                else
                    uiwait(warndlg('File not found. Make sure your file is a CSV','Error','help'));
                end
                % At this point, if both above statements are false, try concat .csv & .CSV
            elseif ~isempty(fileparts(which(strcat(userfile,filetype))))
                LoadFilePath = which(strcat(userfile,filetype));
            elseif ~isempty(fileparts(which(strcat(userfile,filetypeUPPER))))
                LoadFilePath = which(strcat(userfile,filetypeUPPER));
            else    % File cannot logically exist
                uiwait(warndlg('File not found. Make sure your file is a CSV','Error','help'));
                continue
            end
            if ~isempty(LoadFilePath)
                FILENAME = LoadFilePath;
                break
            else
                continue
            end
        end  
end

