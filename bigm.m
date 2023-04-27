clc
clear all

%Big M Method
clc
clear all

M = 100000;
c=[-3 -5 0 0 -M -M 0];
a=[1 3 -1 0 1 0; 1 1 0 -1 0 1];
b=[3;2];

t = [0;-1;0];
A = [a b];

%basic = size(a,2)+1:1:size(A,2)-1;
basic = [5 6];

basic;

zjcj =  c(:,basic)*A(:,1:size(A,2))-c(:,:);

zcj = [zjcj;A];
array2table(zcj,"VariableNames",{'x1','x2','s2','A1','A2','S3','sol'})

while(min(zjcj(1,1:size(a,2))) < 0)
    
    [val,minIndexzjcj] = min(zjcj(1,1:size(a,2)));
    pivotColumn = A(:,minIndexzjcj);
    
    if(max(pivotColumn) <= 0)
        fprintf("Unbounded Solution");
        break;
    else
    
        pivotColumn = max(0,pivotColumn);
        
        [miVal,minRatioIndex] = min(b./pivotColumn);

        %update basic variables
        basic(minRatioIndex) = minIndexzjcj;

        %update A
        pvt_key = A(minRatioIndex,minIndexzjcj);
        
        A(minRatioIndex,:) = A(minRatioIndex,:)/pvt_key;
        for i=1:size(A,1)
            if i ~= minRatioIndex
              A(i,:) = A(i,:) - A(i,minIndexzjcj)*A(minRatioIndex,:);
            end
        end

        %update zjcj
        zjcj = zjcj-zjcj(1,minIndexzjcj)*A(minRatioIndex,:);

        %get solution
        if(min(zjcj(1,1:size(a,2))) >= 0)
            bfs = zeros(1,size(A,2)-1);
            bfs(basic) = c(basic);
            sol = zjcj(:,size(A,2));
            zcj1 = [zjcj;A];
            array2table(zcj1,"VariableNames",{'x1','x2','s2','A1','A2','S3','sol'})
            fprintf("Min = %f",-sol);
            break;
        end
    end
end


