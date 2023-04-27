clc
clear all

M = 1000;
c=[-3 -1];
a=[1 1;-1 -2];
b=[1;-3];
s = eye(size(a,1));

A = [a s b];
c = [c zeros(1,size(a,1)) 0];

basic = size(a,2)+1:1:size(A,2)-1;
A
c
c(:,basic)
zjcj =  c(:,basic)*A(:,1:size(A,2))-c(:,:);
zjcj

zcj = [zjcj;A];
%array2table(zcj,"VariableNames",{'x1','x2','x3','s1','s2','s3','sol'})

while(min(zjcj(1,1:size(A,2)-1)) < 0)
    
    [val,minIndexzjcj] = min(zjcj(1,1:size(A,2)-1));
    pivotColumn = A(:,minIndexzjcj);
    pivotColumn

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
        if(min(zjcj(1,1:size(A,2)-1)) >= 0)
            bfs = zeros(1,size(A,2));
            bfs(basic) = c(basic);
            sol = zjcj(:,size(A,2));
            fprintf("Max = %f",sol);
            break;
        end
    end
end

if (min(A(:,size(A,2))) < 0)
      fprintf("Dual Simplex");
      while(min(A(:,size(A,2)))< 0 )
        [v,minIndexb] = min(A(:,size(A,2)));

        row = min(0,A(minIndexb,1:size(A,2)-1));

        [val,minIndexz] = min(abs(zjcj(:,1:size(zjcj,2)-1)./row));
        
        basic(minIndexb) = minIndexz;

        pvt_key1 = A(minIndexb,minIndexz);
        A
       
        pvt_key1
        minIndexb

        A(minIndexb,:)
        A(minIndexb,:) = A(minIndexb,:)/pvt_key1;


        for i = 1:size(A,1)
            if(i ~= minIndexb)
               A(i,:) = A(i,:)-A(minIndexb,:)*A(i,minIndexz); 
            end
        end

        A(:,size(A,2))

        zjcj = zjcj-zjcj(1,minIndexz)*A(minIndexb,:);
        
        if(min(A(:,size(A,2))) >= 0)
            bfs = zeros(1,size(A,2)-1);
            bfs(basic) = c(basic);
            sol = zjcj(:,size(A,2));
            zcj1 = [zjcj;A];
            array2table(zcj1,"VariableNames",{'x1','x2','s1','s2','sol'})
            fprintf("Max = %f",sol);
            break;
        end
       end

end

