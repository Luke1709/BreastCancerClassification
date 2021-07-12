
clear all 
load('FinalDatabases.mat')

X = CentralDatabase(:,2:31);
[idx,C] = kmeans(X,3);
labels = CentralDatabase(:,1);

A = C;

%the vector of values in each cluster
clusterData = [idx X labels];

cluster1 = clusterData(clusterData(:,1)==1,:);
cluster2 =  clusterData(clusterData(:,1)==2,:);
cluster3 =  clusterData(clusterData(:,1)==3,:);
T = [length(cluster1(:,1)) length(cluster2(:,1)) length(cluster3(:,1))];
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

Sum = 0;
for i = 3
    for j=1:T(i)
        q = sqrt(sum((cluster3(j,2:31)-A(3,:)).^2));
        Sum = Sum + q;
    end
    S(i) = (1/T(i) * Sum)^(1/2);
end

for i=1:3
    for j=1:3
        M(i,j) = norm(A(i,:)-A(j,:),2);
    end
end

%assign diagonals large so calculatations can be made
M = M + diag([10000;100000;10000]);

for i=1:3
    for j=1:3
        R(i,j) = (S(i)+S(j))/M(i,j);
    end
end

for i=1:3
    D(i) = max(R(i,:));
end

DB = 1/3 * sum(D)

%need to project the data in each cluster using the principal components
coeff = pca(CentralDatabase(:,2:31));
pc1c1 = cluster1(:,2:31)*coeff(:,1);
pc1c2 = cluster2(:,2:31)*coeff(:,1);
pc1c3 = cluster3(:,2:31)*coeff(:,1);

pc2c1 = cluster1(:,2:31)*coeff(:,2);
pc2c2 = cluster2(:,2:31)*coeff(:,2);
pc2c3 = cluster3(:,2:31)*coeff(:,2);

figure(1)
scatter(pc1c1,pc2c1,'r.')
hold on
grid on
scatter(pc1c2,pc2c2,'b.')
scatter(pc1c3,pc2c3,'g.')

%now to split clusters into M & B
%Malignant = 1 Benign = 2
cluster1M = cluster1(cluster1(:,32)==1,:);
cluster1B = cluster1(cluster1(:,32)==2,:);
cluster2M =  cluster2(cluster2(:,32)==1,:);
cluster2B =  cluster2(cluster2(:,32)==2,:);
cluster3M =  cluster3(cluster3(:,32)==1,:);
cluster3B =  cluster3(cluster3(:,32)==2,:);

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

pc1Mc3 = cluster3M(:,2:31)*coeff(:,1);
pc1Bc3 = cluster3B(:,2:31)*coeff(:,1);
pc2Mc3 = cluster3M(:,2:31)*coeff(:,2);
pc2Bc3 = cluster3B(:,2:31)*coeff(:,2);

figure(2)
%malignant are circles, benign are triangles o ^
scatter(pc1Mc1,pc2Mc1,'o','.r')
hold on
grid on
scatter(pc1Bc1,pc2Bc1,'+','.r')
scatter(pc1Mc2,pc2Mc2,'o','g.')
scatter(pc1Bc2,pc2Bc2,'+','g.')
scatter(pc1Mc3,pc2Mc3,'o','y.')
scatter(pc1Bc3,pc2Bc3,'+','y.')

%purity calculation

%for cluster1 the majority is Malignant
correctC1 = length(cluster1M(:,1));

%for cluster2 majority is Benign
correctC2 = length(cluster2B(:,1));

%for cluster3 majority is Malignant
correctC3 = length(cluster3M(:,1));

Purity = (correctC1 + correctC2 + correctC3)/569









