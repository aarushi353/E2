clc;
clear all;

cost = [6 4 1 5;8 9 2 7;4 6 3 4];
demand = [7 5 3 2];
supply = [6 1 10]; 
if(sum(supply)==sum(demand)) 
    fprintf('Problem is Balanced\n');
else
    if(sum(supply)<sum(demand))
        cost(end+1,:) = zeros(1,length(demand)); 
        supply(end+1) = sum(demand) - sum(supply); 
    else
        cost(:,end+1) = zeros(1,length(supply)); 
        demand(end+1) = sum(suppy) - sum(demand); 
    end
end

m = size(cost,1);
n = size(cost,2);
X = zeros(m,n);

Init_Cost = cost;
for i=1:m
    for j=1:n
        cpq = min(cost(:));
        if (cpq == inf)
            break;
        end
        [p1 q1] = find(cpq == cost);
        xpq = min(supply(p1),demand(q1));
        [X1,ind] = max(xpq);
        p = p1(ind);
        q = q1(ind);
        X(p,q) = min(supply(p),demand(q));
        if X(p,q) == supply(p)
            supply(p) = supply(p) - X(p,q);
            demand(q) = demand(q) - supply(p);
            cost(p,:) = inf;
        else
            supply(p) = supply(p) - demand(q);
            demand(q) = 0;
            cost(:,q) = inf;
        end
    end
end

Z = 0;
for i=1:m
    for j=1:n
        Z = Z + Init_Cost(i,j)*X(i,j);
    end
end

Z