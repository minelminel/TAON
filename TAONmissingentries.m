function master = TAONmissingentries(master, defaultAnswer, opts)
% Function to correct any entries missing data
%%       MISSING DATA DETECTION & CORRECTION

if any(~cell2mat(master(:,6)))
    ReferenceIndex = find(~cell2mat(master(:,6))==0);
    ReferenceArray = cell2mat(master(ReferenceIndex,6));
    [ClarifyIndex NumMissing NumFixed] = TAONrectifyindex(master);
    % ClarifyIndex = [] rows to correct
    if ~isempty(ClarifyIndex)
        fprintf('%d entries require clarification.',NumMissing-NumFixed);
        for i = 1:numel(ClarifyIndex)
            while 1
                index = ClarifyIndex(i);
                burndate = master(index,10);
                burnvend = master(index,3);
                burnmsg = sprintf(...
                    'Transaction requires further clarification.\n\n%s\t%s\n\n...Enter transaction amount:',...
                    string(burndate),string(burnvend));
                burnstr = inputdlg(burnmsg,'Action Required',[1 70],defaultAnswer,opts);
                if ~isempty(burnstr)
                    burnstr = strrep(burnstr{:},'$','');
                    burnnum = str2double(burnstr);
                    switch sign(burnnum)
                        case 1
                            master{index,5} = burnnum;
                            break
                        case -1
                            master{index,4} = burnnum;
                            break
                        case 0
                            % prompt for re-entry, reloop
                    end
                end
            end
        end
    else
%         fprintf('\nAll values computable, no action required.\n');
    end
    master = TAONrectifyvalues(master);
    CheckArray = cell2mat(master(ReferenceIndex,6));
    % NumMissing
    % NumFixed
    Proofread = ReferenceArray == CheckArray;
    if any(~(ReferenceArray == CheckArray)) % any(~Proofread)
        uiwait(errordlg('Error(s) made in automatic balance correction'));
        return
end
end

master;
end
% *** FIGURE OUT WAY TO ALLOW USER TO CORRECT ENTRIES IF ERROR FOUND