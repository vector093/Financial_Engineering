%Calculating returns of all the stocks that were imported into MATLAB
for i=2:85
    returns(1,i-1)= (SPY(i,1)/SPY(i-1,1))-1;
end
for i=2:85
    returns(2,i-1)= (GOVT(i,1)/GOVT(i-1,1))-1;
end
for i=2:85
    returns(3,i-1)= (EEMV(i,1)/EEMV(i-1,1))-1;
end
for i=2:85
    returns(4,i-1)= (CME(i,1)/CME(i-1,1))-1;
end
for i=2:85
    returns(5,i-1)= (BR(i,1)/BR(i-1,1))-1;
end
for i=2:85
    returns(6,i-1)= (CBOE(i,1)/CBOE(i-1,1))-1;
end
for i=2:85
    returns(7,i-1)= (ICE(i,1)/ICE(i-1,1))-1;
end
for i=2:85
    returns(8,i-1)= (ACN(i,1)/ACN(i-1,1))-1;
end

%Calculate arthimatic mean of returns
for i=1:8
    mean_returns(i) =sum(returns(i,:))/84;
end

%Calculate expected returns
for i=1:8
    geo_mean_returns(i) =((prod(returns(i,:)+1))^(1/84))-1;
end

%Calculate covarience matrix
for i=1:8
    for j=1:8
        COV(i,j)=sum((returns(i,:)-mean_returns(i)).*(returns(j,:)-mean_returns(j)))/84;
    end
end
COV

%Setting bounds and restricting conditions for the optimization including
%short selling
Aiq=-[0,0,0,0,0,0,0,0];
Biq=-[0];
RN=0;
aeq=[1 1 1 1 1 1 1 1; geo_mean_returns];
Beq=[1; RN];
Ub=[inf,inf,inf,inf,inf,inf,inf,inf];
Lb=[-inf, -inf, -inf,-inf, -inf, -inf,-inf, -inf];
F=[0 0 0 0 0 0 0 0]';

% Creating the optimized table with the Expected return, Standard
% Deviation, and weights of all assets
i=1;
for RN =0.0025:0.00077:0.0179
    Beq=[1; RN];
    K(i,1)=RN;
    [x,fval]=quadprog(COV,F,Aiq,Biq,aeq,Beq, Lb, Ub);
    K(i,2)=fval;
    K(i,3)=x(1);
    K(i,4)=x(2);
    K(i,5)=x(3);
    K(i,6)=x(4);
    K(i,7)=x(5);
    K(i,8)=x(6);
    K(i,9)=x(7);
    K(i,10)=x(8);
    i=i+1;
end
K(:,2)=sqrt(K(:,2));

%Plotting the Efficient Frontier
figure;
plot(K(:,2),K(:,1))
title('Efficient Frontier with Short Selling');

%Modifing bounds and restricting conditions for the optimization without
%short selling
Lb=[0, 0, 0, 0, 0, 0, 0, 0];

%creating the optimized table again
i=1;
for RN =0.0025:0.00077:0.0179
    Beq=[1; RN];
    K(i,1)=RN;
    [x,fval]=quadprog(COV,F,Aiq,Biq,aeq,Beq, Lb, Ub);
    K(i,2)=fval;
    K(i,3)=x(1);
    K(i,4)=x(2);
    K(i,5)=x(3);
    K(i,6)=x(4);
    K(i,7)=x(5);
    K(i,8)=x(6);
    K(i,9)=x(7);
    K(i,10)=x(8);
    i=i+1;
end
K(:,2)=sqrt(K(:,2));
%Plotting the Efficient Frontier
figure;
plot(K(:,2),K(:,1))
title('Efficient Frontier without Short Selling');



