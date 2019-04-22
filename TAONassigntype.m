function master = TAONassigntype(master, FSIZE)

for i = 1:FSIZE
    if ~master{i,5}
        master(i,7) = {'DEBIT'};
    else
        master(i,7) = {'CREDIT'};
    end
end

end