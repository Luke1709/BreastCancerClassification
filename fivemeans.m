clear all 
load('FinalDatabases.mat')

X = CentralDatabase(:,2:31);
[idx,C] = kmeans(X,5);
labels = CentralDatabase(:,1);

A = C;

%the vector of values in each cluster
clusterData = [idx X labels];

cluster1 = clusterData(clusterData(:,1)==1,:);
cluster2 =  clusterData(clusterData(:,1)==2,:);
cluster3 =  clusterData(clusterData(:,1)==3,:);
cluster4 =  clusterData(clusterData(:,1)==4,:);
cluster5 =  clusterData(clusterData(:,1)==5,:);
T = [length(cluster1(:,1)) length(cluster2(:,1)) length(cluster3(:,1)) length(cluster4(:,1)) length(cluster5(:,1))];
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

Sum = 0;
for i = 4
    for j=1:T(i)
        q = sqrt(sum((cluster4(j,2:31)-A(4,:)).^2));
        Sum = Sum + q;
    end
    S(i) = (1/T(i) * Sum)^(1/2);
end

Sum = 0;
for i = 5
    for j=1:T(i)
        q = sqrt(sum((cluster5(j,2:31)-A(5,:)).^2));
        Sum = Sum + q;
    end
    S(i) = (1/T(i) * Sum)^(1/2);
end

for i=1:5
    for j=1:5
        M(i,j) = norm(A(i,:)-A(j,:),2);
    end
end

%assign diagonals large so calculatations can be made
M = M + diag([10000;100000;10000;100000;100000]);

for i=1:5
    for j=1:5
        R(i,j) = (S(i)+S(j))/M(i,j);
    end
end

for i=1:5
    D(i) = max(R(i,:));
end

DB = 1/5 * sum(D)

%now to split clusters into M & B
%Malignant = 1 Benign = 2
cluster1M = cluster1(cluster1(:,32)==1,:);
cluster1B = cluster1(cluster1(:,32)==2,:);
cluster2M =  cluster2(cluster2(:,32)==1,:);
cluster2B =  cluster2(cluster2(:,32)==2,:);
cluster3M =  cluster3(cluster3(:,32)==1,:);
cluster3B =  cluster3(cluster3(:,32)==2,:);
cluster4M =  cluster4(cluster4(:,32)==1,:);
cluster4B =  cluster4(cluster4(:,32)==2,:);
cluster5M =  cluster5(cluster5(:,32)==1,:);
cluster5B =  cluster5(cluster5(:,32)==2,:);

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

pc1Mc4 = cluster4M(:,2:31)*coeff(:,1);
pc1Bc4 = cluster4B(:,2:31)*coeff(:,1);
pc2Mc4 = cluster4M(:,2:31)*coeff(:,2);
pc2Bc4 = cluster4B(:,2:31)*coeff(:,2);

pc1Mc5 = cluster5M(:,2:31)*coeff(:,1);
pc1Bc5 = cluster5B(:,2:31)*coeff(:,1);
pc2Mc5 = cluster5M(:,2:31)*coeff(:,2);
pc2Bc5 = cluster5B(:,2:31)*coeff(:,2);

figure(1)
%malignant are circles, benign are triangles o ^
scatter(pc1Mc1,pc2Mc1,'o','.r')
hold on
grid on
scatter(pc1Bc1,pc2Bc1,'+','.r')
scatter(pc1Mc2,pc2Mc2,'o','g.')
scatter(pc1Bc2,pc2Bc2,'+','g.')
scatter(pc1Mc3,pc2Mc3,'o','y.')
scatter(pc1Bc3,pc2Bc3,'+','y.')
scatter(pc1Mc4,pc2Mc4,'o','b.')
scatter(pc1Bc4,pc2Bc4,'+','b.')
scatter(pc1Mc5,pc2Mc5,'o','k.')
scatter(pc1Bc5,pc2Bc5,'+','k.')




%need to project the data in each cluster using the principal components
pc1c1 = cluster1(:,2:31)*coeff(:,1);
pc1c2 = cluster2(:,2:31)*coeff(:,1);
pc1c3 = cluster3(:,2:31)*coeff(:,1);
pc1c4 = cluster4(:,2:31)*coeff(:,1);
pc1c5 = cluster5(:,2:31)*coeff(:,1);

pc2c1 = cluster1(:,2:31)*coeff(:,2);
pc2c2 = cluster2(:,2:31)*coeff(:,2);
pc2c3 = cluster3(:,2:31)*coeff(:,2);
pc2c4 = cluster4(:,2:31)*coeff(:,2);
pc2c5 = cluster5(:,2:31)*coeff(:,2);

%figure(2)
%scatter(pc1c1,pc2c1,'r.')
%hold on
%grid on
%scatter(pc1c2,pc2c2,'b.')
%scatter(pc1c3,pc2c3,'g.')
%scatter(pc1c4,pc2c4,'y.')
%scatter(pc1c5,pc2c5,'k.')

%purity calculation

%for cluster1 the majority is Benign
correctC1 = length(cluster1B(:,1));

%for cluster2 majority is Malignant
correctC2 = length(cluster2M(:,1));

%for cluster3 majority is Malignant
correctC3 = length(cluster3M(:,1));

%for cluster4 majority is Benign
correctC4 = length(cluster4B(:,1));

%for cluster5 majority is Malignant
correctC5 = length(cluster5M(:,1));

Purity = (correctC1 + correctC2 + correctC3 + correctC4 + correctC5)/569


