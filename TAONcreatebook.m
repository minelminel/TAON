function [book, booktab, VarNames] = TAONcreatebook(master)
%%       FLIP master{} UPSIDE DOWN, MOST RECENT LAST
book = flipud(master);
%%       booktab VARIABLE NAME ASSIGNMENT

booktab = cell2table(book);
booktab.Properties.VariableNames{'book1'} = 'Transaction';
booktab.Properties.VariableNames{'book2'} = 'Day';
booktab.Properties.VariableNames{'book3'} = 'Vendor';
booktab.Properties.VariableNames{'book4'} = 'Debit';
booktab.Properties.VariableNames{'book5'} = 'Credit';
booktab.Properties.VariableNames{'book6'} = 'Balance';
booktab.Properties.VariableNames{'book7'} = 'Type';
booktab.Properties.VariableNames{'book8'} = 'Category';
booktab.Properties.VariableNames{'book9'} = 'Serial';
booktab.Properties.VariableNames{'book10'} = 'Date';
VarNames = booktab.Properties.VariableNames;
booktab;

end