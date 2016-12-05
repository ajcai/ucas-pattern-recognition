clear;
load kmeans_data.mat;
NUM_CLUSTERS=5;	%number of clusters
NUM_DATA=size(X,1);	%number of data
NUM_DIM=size(X,2);	%dimation of data
PLOT_STYLE={'r*','g+','bx','kx','m.','y.'};
%class_ind=randi(NUM_CLUSTERS,NUM_DATA,1); %randomly initilize 
m=zeros(NUM_CLUSTERS,NUM_DIM);%means of each cluster
mu=rand(NUM_DATA,NUM_CLUSTERS);
mu=mu./repmat(sum(mu,2),1,NUM_CLUSTERS);
b=2;
for r=1:100
	%compute mean of each cluster
	for i=1:NUM_CLUSTERS
		m(i,:)=sum(repmat(mu(:,i).^b,1,NUM_DIM).*X,1)/sum(mu(:,i).^b,1);
	end
	%classify samples
	squared_dist=zeros(NUM_DATA,NUM_CLUSTERS);  
	for j=1:NUM_DATA
		for i=1:NUM_CLUSTERS
			squared_dist(j,i)=sum((X(j,:)-m(i,:)).^2,2);
		end
	end
	mu_mid_var=(1./squared_dist).^(1/(b-1));
	for j=1:NUM_DATA
		for i=1:NUM_CLUSTERS
			mu(j,i)=mu_mid_var(j,i)/sum(mu_mid_var(j,:));
		end
	end
end

%draw samples according to most likely cluster
[~,class_ind]=max(mu,[],2);

figure;
hold on;
for k=1:NUM_CLUSTERS
	ind_k=find(class_ind==k);
	data_k=X(ind_k,:);
	plot(data_k(:,1),data_k(:,2),PLOT_STYLE{k});
end
