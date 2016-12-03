clear;
load kmeans_data.mat;
NUM_CLUSTERS=5;	%number of clusters
NUM_DATA=size(X,1);	%number of data
NUM_DIM=size(X,2);	%dimation of data
PLOT_STYLE={'r*','g+','bx','kx','m.','y.'};
class_ind=randi(NUM_CLUSTERS,NUM_DATA,1); %randomly initilize 
m=zeros(NUM_CLUSTERS,NUM_DIM);%means of each cluster
for k=1:NUM_CLUSTERS
	ind_k=find(class_ind==k);
	data_k=X(ind_k,:);
	m(k,:)=mean(data_k);
end
for t=1:10000
	r_ind=randi(NUM_DATA);
	rx=X(r_ind,:);
	[~,i]=min(sum((m-repmat(rx,NUM_CLUSTERS,1)).^2,2));
	rho=zeros(NUM_CLUSTERS,1);
	for j=1:NUM_CLUSTERS
		ind_j=find(class_ind==j);
		nj=size(ind_j,1);
		rho(j)=nj/(nj+1)*norm(rx-m(j,:));
		if j==i
			rho(j)=nj/(nj-1)*norm(rx-m(j,:));
		end
	end 
	[~,k]=min(rho);
	class_ind(r_ind)=k;
	m(k,:)=mean(X(find(class_ind==k),:));
	m(i,:)=mean(X(find(class_ind==i),:));
end

figure;
hold on;
for k=1:NUM_CLUSTERS
	ind_k=find(class_ind==k);
	data_k=X(ind_k,:);
	plot(data_k(:,1),data_k(:,2),PLOT_STYLE{k});
end
