
function master = TAONrectifyvalues(master)
% 
% Updates master array through iterative calculation.
% master = TAONrectifyindex(master)
% 
% 00 case 3: T&B(i) missing...B(i) = B(i-1) - T(i-1)
% 01 case 2: T(i) missing...T(i) = B(i) - B(i+2)
% 10 case 1: B(i) missing... B(i) = B(i+1) + T(i)
% 11 continue

% clc; clear;
% format bank
% global master
x = cell2mat(master(:,[4:6]));
D = x(:,1); C = x(:,2); Bl = x(:,3); Tr = D + C;
tetris = [Tr Bl];
n = length(tetris);
% tic

% plato is a logical array representing presence of data, size(n,2)

% === REAL VALUES === %
plato = logical(tetris);
% === RANDOM INIT === %
% plato = logical(abs(sign(ceil(rand(n,2)*10)-9)));

% === ALGORITHM CASES === %
Case1 = logical([ 0 0; 1 0; 0 1 ]); % t(i)
Case2 = logical([ 0 0; 0 1; 0 1 ]); % b(i)I
Case3 = logical([ 1 1; 0 0; 0 0 ]); % b(i)II
Case4 = logical([ 1 1; 0 0 ]);      % b(end)
Case5 = logical([ 0 1; 0 1 ]);      % t(1)
Case6 = logical([ 1 0; 0 1 ]);      % b(1)
% ======================= %

t = plato(:,1);
b = plato(:,2);

Count = 0;
originalArray = [t b];

while (nnz(~[t b]) > 0) && (Count < nnz(~plato(:,:)))
    if t(1) && b(1)
        % skip loop
    else
        if xor(t(1),b(1)) % either of 1st missing
            bithead = [t(1:2) b(1:2)];
            Checkcase5 = isequal(Case5,bithead.*Case5); % t(1)
            Checkcase6 = isequal(Case6,bithead.*Case6); % b(1)
            Algos = [Checkcase5 Checkcase6];
            if ~sum(Algos) % no algorithms possible
                % skip loop
            elseif Algos(1)
                % t(1) = b(1) - b(2)
                t(1) = (b(1) && b(2));
                tetris(1,1) = tetris(1,1) - tetris(2,2);
            elseif Algos(2)
                % b(1) = b(2) + t(1)
                b(1) = (b(2) && t(1));
                tetris(1,2) = tetris(2,2) + tetris(1,1);
            else
                % catch-all
            end
        end
    end

    for i = 2:n-1
        %     gather 6-bit block of logicals, determine which algo's will work
        %     if no algo will work, pause and display error
        % bit is 3 x 2 array
%         disp(i);
        bit = [t(i-1), b(i-1); t(i), b(i); t(i+1), b(i+1)];
        if bit(2,1) && bit(2,2)
            % row is fine
            continue
        else
            Checkcase1 = isequal(Case1,bit.*Case1);
            Checkcase2 = isequal(Case2,bit.*Case2);
            Checkcase3 = isequal(Case3,bit.*Case3);
            Algos = [Checkcase1 Checkcase2 Checkcase3];
            if ~sum(Algos)
%                 disp('no algorithms possible');
                continue
            elseif Algos(1)
%                 disp('try repairing t(i)');
                % b(i) = b(i+1) + t(i)
                b(i) = (b(i+1) && t(i));
                tetris(i,2) = tetris(i+1,2) + tetris(i,1);
            elseif Algos(2)
%                 disp('try repairing b(i)');
                % t(i) = b(i) - b(i+1)
                t(i) = (b(i) && b(i+1));
                tetris(i,1) = tetris(i,2) - tetris(i+1,2);
            elseif Algos(3)
%                 disp('try repairing b(i) with (i-1) values');
                % b(i) = b(i-1) - t(i-1)
                b(i) = (b(i-1) && t(i-1));
                tetris(i,2) = tetris(i-1,2) - tetris(i-1,1);
            else % catch-all
                % errordlg('fatal error - catch-all');
                continue
            end
        end
    end
    
    if ~b(end)
        bittail = [t(end-1:end) b(end-1:end)];
        Checkcase4 = isequal(Case4,bittail.*Case4);
        if ~Checkcase4
            % no algorithms possible
        else
            % disp('try repairing b(end)');
            % b(end) = b(end-1) - t(end-1)
            b(end) = (b(end-1) && t(end-1));
            tetris(end,2) = tetris(end-1,2) - tetris(end-1,1);
        end
    end
    if t(1) && b(1)
        % skip loop
    else
        if xor(t(1),b(1)) % either of 1st missing
            bithead = [t(1:2) b(1:2)];
            Checkcase5 = isequal(Case5,bithead.*Case5);
            Checkcase6 = isequal(Case6,bithead.*Case6);
            Algos = [Checkcase5 Checkcase6];
            if ~sum(Algos) % no algorithms possible
                % skip loop
            elseif Algos(1)
                % t(1) = b(1) - b(2)
                t(1) = (b(1) && b(2));
                tetris(1,1) = tetris(1,2) - tetris(2,2);
            elseif Algos(2)
                % b(1) = b(2) + t(1)
                b(1) = (b(2) && t(1));
                tetris(1,2) = tetris(2,2) + tetris(1,1);
            else
                % catch-all
            end
        end
    end
    if (nnz(~t) == 1) && ~t(end) % if only 0 in array is t(end)...�
        Count = n;
    else
      Count = Count + 1;
    end
end


originalArray;
checkArray = [t b];
Count;
LogicArray = [originalArray checkArray];
NumFixed = nnz(~plato(:,:)) - nnz(~t);
% LOOP thru assigning to DEBIT or CREDIT and BALANCE

if nnz(~tetris)
    errordlg('Error in function: Values still missing','TAONrectifyvalues')
else
    for i = 1:n
        transFix = tetris(i,1);
        balFix = tetris(i,2);
        master{i,6} = balFix;
        switch sign(transFix)
            case 1
                master{i,5} = transFix;
            case -1
                master{i,4} = transFix;
        end
    end    
end
master;

end
% =============================================================
