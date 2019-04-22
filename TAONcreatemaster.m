function [master FSIZE] = TAONcreatemaster(FILENAME, formatOut)
% Creates a master cell array by reading the file specified by user
% FSIZE = number of entries (rows)
%%       READ DATA INTO ARRAYS, CREATE CELL ARRAY 'master'

Raw = readtable(FILENAME);
A = table2cell(Raw);
Ce = A(~any(cellfun(@isempty, A),2), :);
FSIZE = length(Ce);
% rTable = cell2table(Ce);

numentries = sprintf('Accessing %d entries...',FSIZE);
% if Neon; waitbar(0.1,f,numentries); end

fTRANS = Ce(:,1);
fDATE = num2cell(datenum(string(Ce(:,2))));
fVEND = Ce(:,3);
fDEBIT = Ce(:,4);
fCREDIT = Ce(:,5);
fBAL = Ce(:,6);
fTYPE = repmat({''},FSIZE,1);
fCAT = repmat({''},FSIZE,1);
fSERIAL = repmat({''},FSIZE,1);
fDATEstr = cellstr(datestr(string(Ce(:,2)),formatOut));

fDEBIT(cellfun(@(x)all(x~=x), fDEBIT)) = {0};
fCREDIT(cellfun(@(x)all(x~=x), fCREDIT)) = {0};
fBAL(cellfun(@(x)all(x~=x), fBAL)) = {0};


%%       master { CELL ARRAY } CREATION

master = {[fTRANS fDATE fVEND fDEBIT fCREDIT fBAL fTYPE fCAT fSERIAL fDATEstr]};
master = master{:};
master;

end