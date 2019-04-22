function CATPIE = TAONcategorypie(book, CATFREQ, CATEGORY)
%%       CATEGORY PIE CHART


subplot(2,3,3);
CATPIE = pie3(CATFREQ, CATEGORY);
pi1 = datestr(book{1,2});
pi2 = datestr(book{end,2});
pTitl = sprintf('TRANSACTION FREQUENCY');
title(pTitl);
CATPIE;

end