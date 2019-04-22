function master = TAONassigncategories(master, CERT)
%%       CHECK IF CATEGORY HAS BEEN ASSIGNED YET, SEARCH & ASSIGN IF NEEDED, SKIP ROWS IF FILLED

Loading = waitbar(0,'Classifying transactions...','Name','Categorization Engine');
preCHECK = string(master(:,8));
needCAT = find(cellfun(@isempty,preCHECK)); % returns vector of cells w/o CATEGORY
for i = 1:length(needCAT)
    j = needCAT(i);
    QUERY = master(j,3);
    COST = sum(cell2mat(master(j,4:5)));
    defi = wordsearch(QUERY);   % IF NO ENTRY FOUND, RETURNS '' (empty string)
    if isempty(cell2mat(defi)) == 1
        user_term = partialmatch(QUERY,CERT,COST);
        dummy = newentryfrom(user_term,QUERY); % added 2nd input
        master{j,8} = char(dummy);
        
    else
        master{j,8} = char(defi);
    end
    
    waitbar(i/length(needCAT),Loading)
end
if isvalid(Loading); delete(Loading); end
end