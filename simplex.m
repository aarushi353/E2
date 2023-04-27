clc
clear all
format short
%% To solve the LPP by Simplex Method
%Min z=x1-3x2+2x3
%Subject to 3x1-x2+2x3<=7
%-2x1+4x2<=12
%-4x1+3x2+8x3<=10
%x1,x2,x3>=0
%First to change the objective function from minimization to maximization
%Max z=-x1+3x2-2x3

%% To input parameters
C=[-1 3 -2];
Aa=[3 -1 2;-2 4 0;-4 3 8];
b=[7; 12; 10];
s=eye(size(Aa,1));
var=size(Aa,2);
A=[Aa s b]; 
Cost=zeros(1,size(A,2));
Cost(1:var)=C;
BV=var+1:size(A,2)-1; % eg. 4:6

%% To calculate Z-Row(Zj-Cj)
ZjCj=Cost(BV)*A-Cost;
%To print the table
ZCj=[ZjCj; A];
SimpTable=array2table(ZCj,'VariableNames',{'x_1','x_2','x_3','s_1','s_2','s_3','Sol'}) %make table

%% Simplex Table Starts
Run=true;
while Run
if any(ZjCj(1:end-1)<0) %To check any negative value is there
    fprintf('The current BFS is not optimal \n')
    fprintf('\n=========The next iteration continues========\n')
    disp('Old Basic Variable (BV)=')
    disp(BV)
    % To find entering Variable
    ZC=ZjCj(1:end-1);
    [EnterCol, Pvt_Col]=min(ZC); % [minval, minindex]
    fprintf('The most negative element in Z-Row is %d Corresponding to Column %d \n', EnterCol, Pvt_Col)
    fprintf('Entering Variable is %d \n', Pvt_Col)
    
    %To find the leaving variable
    sol=A(:,end);
    Column=A(:,Pvt_Col);
    if all(Column<=0)
        error('LPP has unbounded solution. All entries <= 0 in column %d', Pvt_Col)
    else

    % To check minimum ratio is with positive entering column entries
    for i=1:size(Column,1)
        if Column(i)>0
            ratio(i)=sol(i)./Column(i);
        else
            ratio(i)=inf;
        end
    end
        %To finding minimum ratio
        [MinRatio, Pvt_Row]=min(ratio);
        fprintf('Minimum ratio corresponding to pivot row is %d \n', Pvt_Row)
        fprintf('Leaving Variable is %d \n', BV(Pvt_Row))
    end
        BV(Pvt_Row)=Pvt_Col;
disp('New Basic Variables (BV) =')
disp(BV)

%Pivot Key
Pvt_Key=A(Pvt_Row,Pvt_Col);

%Update Table for next iteration
A(Pvt_Row,:)=A(Pvt_Row,:)./Pvt_Key;

for i=1:size(A,1)
    if i~=Pvt_Row
        A(i,:)=A(i,:)-A(i,Pvt_Col).*A(Pvt_Row,:);
    end
end
ZjCj=ZjCj-ZjCj(Pvt_Col).*A(Pvt_Row,:);
%To print the updated table
    ZCj=[ZjCj;A];
    SimpTable=array2table(ZCj,'VariableNames',{'x_1','x_2','x_3','s_1','s_2','s_3','Sol'})
    BFS=zeros(1,size(A,2));
    BFS(BV)=A(:,end);
    BFS(end)=sum(BFS.*Cost);
    CurrentBFS=array2table(BFS,'VariableNames',{'x_1','x_2','x_3','s_1','s_2','s_3','Sol'})
else
    Run=false
    fprintf('The current BFS is optimal and Optimality is reached \n')
end
end