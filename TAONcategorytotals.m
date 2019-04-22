function [CATstr, CATsum, CATEGORY, CATFREQ] = TAONcategorytotals(book, booktab)
%%       FREQUENCY OF OCCURRANCE BY CATEGORY
cats = string(book(:,8));        %  variable, table of CATEGORIES (:,8)
catsSTR = cellstr(cats);      % convert array to string cells
cat_un = unique(catsSTR);      %  column vector of unique categories
NUMint = length(cat_un);       %  integer size (no. of unique cats)
%     fprintf('\n\n\nUnique categories:  %d\n',NUMint)
catstr = catsSTR(:,:);        %  string array of categories
catg = categorical(catstr); %  categorical array, to be processed
CATEGORY = categories(catg); %  cell column, string array of unique categories
CATFREQ = countcats(catg);   %


%         TRANSACTION FREQUENCY, FOR PIE CHART

amtDEB = booktab(:,4);
amtCRED = booktab(:,5);
vecDEB = table2array(amtDEB);
vecCRED = table2array(amtCRED);
amtSUM = vecDEB + vecCRED;
amtCAT = categorical(string(book(:,8)));

TT = table(amtCAT, amtSUM);
scrub = grpstats(TT(:,1:2),'amtCAT','sum');
CATstr = table2array(scrub(:,1));
CATsum = table2array(scrub(:,3));

end