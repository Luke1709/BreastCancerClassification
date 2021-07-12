clear all 
load('FinalDatabases.mat')

X = CentralDatabase(:,2:31);
[idx,C] = kmeans(X,2);
labels = CentralDatabase(:,1);

A = C;

%the vector of values in each cluster
clusterData = [idx X labels];

cluster1 = clusterData(clusterData(:,1)==1,:);
cluster2 =  clusterData(clusterData(:,1)==2,:);
T = [length(cluster1(:,1)) length(cluster2(:,1))];
Sum = 0;
for i = 1
    for j=1:T(i)
        q = sqrt(sum((cluster1(j,2:31)-A(1,:)).^2));
        Sum = Sum + q;
    end
    S(i) = (1/T(i) * Sum)^(1/2);
end

Sum = 0;
for i = 2
    for j=1:T(i)
        q = sqrt(sum((cluster2(j,2:31)-A(2,:)).^2));
        Sum = Sum + q;
    end
    S(i) = (1/T(i) * Sum)^(1/2);
end

for i=1:2
    for j=1:2
        M(i,j) = norm(A(i,:)-A(j,:),2);
    end
end

%assign diagonals large so calculatations can be made
M = M + diag([10000;100000]);

for i=1:2
    for j=1:2
        R(i,j) = (S(i)+S(j))/M(i,j);
    end
end

for i=1:2
    D(i) = max(R(i,:));
end

DB = 1/2 * sum(D)



%need to project the data in each cluster using the principal components
coeff = pca(CentralDatabase(:,2:31));
pc1c1 = cluster1(:,2:31)*coeff(:,1);
pc1c2 = cluster2(:,2:31)*coeff(:,1);

pc2c1 = cluster1(:,2:31)*coeff(:,2);
pc2c2 = cluster2(:,2:31)*coeff(:,2);

figure(1)
scatter(pc1c1,pc2c1,'r.')
hold on
grid on
scatter(pc1c2,pc2c2)

%now to split clusters into M & B
%Malignant = 1 Benign = 2
cluster1M = cluster1(cluster1(:,32)==1,:);
cluster1B = cluster1(cluster1(:,32)==2,:);
cluster2M =  cluster2(cluster2(:,32)==1,:);
cluster2B =  cluster2(cluster2(:,32)==2,:);

%project each data into each principle axis
coeff = pca(CentralDatabase(:,2:31));
pc1Mc1 = cluster1M(:,2:31)*coeff(:,1);
pc1Bc1 = cluster1B(:,2:31)*coeff(:,1);
pc2Mc1 = cluster1M(:,2:31)*coeff(:,2);
pc2Bc1 = cluster1B(:,2:31)*coeff(:,2);

pc1Mc2 = cluster2M(:,2:31)*coeff(:,1);
pc1Bc2 = cluster2B(:,2:31)*coeff(:,1);
pc2Mc2 = cluster2M(:,2:31)*coeff(:,2);
pc2Bc2 = cluster2B(:,2:31)*coeff(:,2);


figure(2)
%malignant are circles, benign are triangles o ^
scatter(pc1Mc1,pc2Mc1,'o','.r')
hold on
grid on
scatter(pc1Bc1,pc2Bc1,'+','.r')
scatter(pc1Mc2,pc2Mc2,'o','g.')
scatter(pc1Bc2,pc2Bc2,'+','g.')



%purity calculation

%for cluster1 the majority is Benign
correctC1 = length(cluster1B(:,1));

%for cluster2 majority is Malignant
correctC2 = length(cluster2M(:,1));

Purity = (correctC1 + correctC2)/569





    