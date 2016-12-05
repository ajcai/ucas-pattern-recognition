clear;
load kmeans_data.mat;
NUM_CLUSTERS=5;	%number of clusters
NUM_DATA=size(X,1);	%number of data
NUM_DIM=size(X,2);	%dimation of data
PLOT_STYLE={'r*','g+','bx','kx','m.','y.'};
class_ind=randi(NUM_CLUSTERS,NUM_DATA,1); %randomly initilize 
m=zeros(NUM_CLUSTERS,NUM_DIM);%means of each cluster
change_flag=true;
while change_flag
	change_flag=false;
	%compute mean of each cluster
	for k=1:NUM_CLUSTERS
		ind_k=find(class_ind==k);
		data_k=X(ind_k,:);
		m(k,:)=mean(data_k,1);
	end
	%classify samples according to nearest mean of clusters
	for t=1:NUM_DATA
		square_dist=sum((repmat(X(t,:),NUM_CLUSTERS,1)-m).^2,2);
		[~,nearest_cluster]=min(square_dist);
		if class_ind(t) ~= nearest_cluster
			change_flag=true;
			class_ind(t)=nearest_cluster;
		end
	end
end



figure;
hold on;
for k=1:NUM_CLUSTERS
	ind_k=find(class_ind==k);
	data_k=X(ind_k,:);
	plot(data_k(:,1),data_k(:,2),PLOT_STYLE{k});
end
