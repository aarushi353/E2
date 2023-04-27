clc;
clear all;

Variables = {'x_1','x_2','s_1','s_2','sol'};
New_Variables = {'x1','x2','s1','s2','A1','A2','sol'};

c = [-3 -5 0 0 -1 -1 0];
a = [1 3 -1 0 1 0; 1 1 0 -1 0 1];
b = [3;2];
A = [a b];
c1 = [0 0 0 0 -1 -1 0];

Art_Var = [5 6];
bv = [5 6];
ZjCj = c1(bv)*A - c1;

simplex_table = [ZjCj;A]; array2table(simplex_table,'VariableNames',New_Variables); RUN = true;

while RUN
    if any(ZjCj(1:end-1)<0)
        Zc = ZjCj(1:end-1);
        [Enter_val, pvt_col] = min(Zc);
        if all(A(:,pvt_col)<=0)
            fprintf('LPP is unbounded');
        else
            sol = A(:,end);
            col = A(:,pvt_col);
            for i=1:size(A,1)
                if(col(i)>0)
                    ratio(i) = sol(i)./col(i);
                else
                    ratio(i) = inf;
                end
            end
            [Leaving_val, pvt_row] = min(ratio);
        end
        bv(pvt_row) = pvt_col;
        pvt_key = A(pvt_row,pvt_col);
        A(pvt_row,:) = A(pvt_row,:)./pvt_key;
        for i=1:size(A,1)
            if i~=pvt_row
                A(i,:) = A(i,:) - A(i,pvt_col).*A(pvt_row,:);
            end
        end
        ZjCj = c1(bv)*A - c1;
        next_table = [ZjCj;A];
        table = array2table(next_table,'VariableNames',New_Variables); 
    else
        RUN = false;
        if any(bv==Art_Var(1)) || any(bv==Art_Var(2))
            error('Infeasible Solution');
        else
            fprintf('Optimal table of phase-1 achieved\n');
        end
    end
end

A(:,Art_Var) = [];
c(:,Art_Var) = [];
c1 = c;

ZjCj = c1(bv)*A - c1;

simplex_table = [ZjCj;A]; array2table(simplex_table,'VariableNames',Variables);
RUN = true;

while RUN
    if any(ZjCj(1:end-1)<0)
        Zc = ZjCj(1:end-1);
        [Enter_val, pvt_col] = min(Zc);
        if all(A(:,pvt_col)<=0)
            fprintf('LPP is unbounded');
        else
            sol = A(:,end);
            col = A(:,pvt_col);
            for i=1:size(A,1)
                if(col(i)>0)
                    ratio(i) = sol(i)./col(i);
                else
                    ratio(i) = inf;
                end
            end
            [Leaving_val, pvt_row] = min(ratio); 
        end
        bv(pvt_row) = pvt_col;
        pvt_key = A(pvt_row,pvt_col);
        A(pvt_row,:) = A(pvt_row,:)./pvt_key;
        for i=1:size(A,1)
            if i~=pvt_row
                A(i,:) = A(i,:) - A(i,pvt_col).*A(pvt_row,:);
            end
        end
        ZjCj = c1(bv)*A - c1;
        next_table = [ZjCj;A];
        table = array2table(next_table,'VariableNames',Variables); 
    else
        RUN = false;
        fprintf('Current BFS is optimal\n');
        Obj_Val = ZjCj(end);
        fprintf('Final optimal value = %f',Obj_Val);
    end
end