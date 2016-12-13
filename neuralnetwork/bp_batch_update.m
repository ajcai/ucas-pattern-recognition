clear;
load data.mat
samples=[samples ones(size(samples,1),1)];
nn=size(samples,1);	%number of samples
ni=size(samples,2);	%number of input layer nodes
nh=8;	%number of hidden layer nodes
nj=3;	%number of output layer nodes
eta=0.4;	%learning rate
theta=0.0001;	%criterion threshold
Jw=[0]; %errors of traning
wih=rand(ni,nh)-0.5;
whj=rand(nh,nj)-0.5;
%load weight.mat
for r=0:10000
  delta_wih=zeros(ni,nh);
  delta_whj=zeros(nh,nj);
  [~,k_ind]=sort(rand(1,nn));%random sequence
  for k=1:nn
    xi=samples(k_ind(k),:);  %kth sample
    tj=labels(k_ind(k),:);   %expected output
    neth=xi*wih;  %hidden layer net
    yh=tanh(neth);  %hidden layer out and activation function is tanh
    netj=yh*whj;  %output lay net
    zj=sigmoid(netj); %output layer out and activation function is sigmoid
    delta_j=(sigmoid(netj).*(1-sigmoid(netj))).*(tj-zj);
    delta_h=(1-tanh(neth).^2).*(delta_j*whj');
    delta_whj+=eta*yh'*delta_j;
		delta_wih+=eta*xi'*delta_h;
  end
  whj=whj+delta_whj;
  wih=wih+delta_wih;
  result=sigmoid(tanh(samples*wih)*whj);
  Jw=[Jw sum(sum((labels-result).^2))];
  delta_Jw=abs(Jw(end)-Jw(end-1));
  if delta_Jw<theta  break; end
end
figure;
plot(Jw(2:end));
