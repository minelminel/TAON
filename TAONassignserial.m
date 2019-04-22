function master = TAONassignserial(master, FSIZE)
%%       SERIAL NUMBER ASSIGNMENT

for i = 1:FSIZE
    alg_i = abs((master{i,2} * abs(master{i,4} +...
        master{i,5}) * master{i,6}));
    alg_o = dec2hex(round(alg_i));
    master{i,9} = alg_o;
end
if length(unique(master(:,9))) ~= FSIZE
    uiwait(errordlg('Serial numbers are not unique'));
    %     disp('Serial numbers are not unique')
end
% IF SERIALS ARE NOT UNIQUE, BALANCE COLUMN CONTAINS "0" SOMEWHERE
end