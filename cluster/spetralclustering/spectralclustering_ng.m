clear;
pkg load statistics; %load statistics package in octave, no need in matlab
load inputdata.mat;

NUM_DATA=size(X,1);
SIGMA=1;
NN_K=5; %num of nearest neighbours
CLUSTER_K=2;%num of clusters
square_dist=zeros(NUM_DATA);
for i=1:NUM_DATA
	for j=1:(i-1)
		square_dist(i,j)=sum((X(i,:)-X(j,:)).^2,2);
	end
end
square_dist=square_dist+square_dist';
[~,neighbours]=sort(square_dist,2,'ascend');

%----------plot nearest neighbours graph------------------------------------
figure;
hold on; 
plot(X(1:100,1),X(1:100,2),'rx');
plot(X(101:200,1),X(101:200,2),'g*');
for i=1:NUM_DATA
	for j=1:NN_K
		if i<101
			plot(X([i neighbours(i,j)],1),X([i neighbours(i,j)],2),'r');
		else
			plot(X([i neighbours(i,j)],1),X([i neighbours(i,j)],2),'g');
		end
	end
end
title('weight graph','FontSize',15.0);
hold off;
%-------------------------------------------------------

accu=[];
%for SIGMA=1:10
W=zeros(NUM_DATA);
for i=1:NUM_DATA
	for j=2:NN_K+1
		W(i,neighbours(i,j))=exp(-square_dist(i,neighbours(i,j))/(2*SIGMA^2));
	end
end
W=(W'+W)/2;
D=diag(sum(W,2));
L=D-W;
L_sym=D^(-0.5)*L*D^(-0.5)+0.01*eye(NUM_DATA);	%add Regularization term to avoid sigular
[U, LAMBDA]=eigs(L_sym,2,'sm');
U=U(:,1:2);
T=zeros(size(U));
for i=1:NUM_DATA
T(i,:)=U(i,:)/norm(U(i,:));
end
try
clu_idx=kmeans(T,CLUSTER_K);
catch err
disp(NN_K);
end

figure;
hold on;
plot(X(find(clu_idx==1),1),X(find(clu_idx==1),2),'rx');
plot(X(find(clu_idx==2),1),X(find(clu_idx==2),2),'g*');
title('Cluster Result','FontSize',15.0);
hold off;

[~,n1]=mode(clu_idx(1:100));
[~,n2]=mode(clu_idx(101:200));
accu=[accu (n1+n2)/NUM_DATA];
%end
