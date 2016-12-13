clear all
close all

X=load('inputdata.txt');
ND=size(X,1); %number of data
NCLUST=2;%num of clusters
dist=zeros(ND);
N=ND*(ND-1)/2;
xx=zeros(N,1);
for i=1:ND
    for j=1:(i-1)
        dist(i,j)=sum((X(i,:)-X(j,:)).^2,2);
		xx((i-1)*(i-2)/2+j,1)=sum((X(i,:)-X(j,:)).^2,2);
    end 
end
dist=dist+dist';

percent=5.0;
fprintf('average percentage of neighbours (hard coded): %5.6f\n', percent);

position=round(N*percent/100);
sda=sort(xx(:,1));
dc=sda(position);

fprintf('Computing Rho with gaussian kernel of radius: %12.6f\n', dc);


for i=1:ND
  rho(i)=0.;
end
%
% Gaussian kernel
%
for i=1:ND-1
  for j=i+1:ND
     rho(i)=rho(i)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
     rho(j)=rho(j)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
  end
end
%
% "Cut off" kernel
%
%for i=1:ND-1
%  for j=i+1:ND
%    if (dist(i,j)<dc)
%       rho(i)=rho(i)+1.;
%       rho(j)=rho(j)+1.;
%    end
%  end
%end

maxd=max(max(dist));

[rho_sorted,ordrho]=sort(rho,'descend');
delta(ordrho(1))=-1.;
nneigh(ordrho(1))=0;

for ii=2:ND
   delta(ordrho(ii))=maxd;
   for jj=1:ii-1
     if(dist(ordrho(ii),ordrho(jj))<delta(ordrho(ii)))
        delta(ordrho(ii))=dist(ordrho(ii),ordrho(jj));
        nneigh(ordrho(ii))=ordrho(jj);
     end
   end
end
delta(ordrho(1))=max(delta(:));

%disp('Generated file:DECISION GRAPH')
%disp('column 1:Density')
%disp('column 2:Delta')
%fid = fopen('DECISION_GRAPH', 'w');
%for i=1:ND
%   fprintf(fid, '%6.2f %6.2f\n', rho(i),delta(i));
%end

%for ii=1:ND
%	plot(rho(ii),delta(ii),'b.');
%end
%hold off;

%disp('Select a rectangle enclosing cluster centers')
%scrsz = get(0,'ScreenSize');
%figure('Position',[6 72 scrsz(3)/4. scrsz(4)/1.3]);
%for i=1:ND
%  ind(i)=i;
%  gamma(i)=rho(i)*delta(i);
%end
%subplot(2,1,1)
%tt=plot(rho(:),delta(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
%title ('Decision Graph','FontSize',15.0)
%xlabel ('\rho')
%ylabel ('\delta')


for ii=1:ND
	rdproduct(ii)=rho(ii)*delta(ii);
end
[~,prodno]=sort(rdproduct,'descend');
icl=prodno(1:NCLUST);
for i=1:ND
  cl(i)=-1;
end
cl(icl)=icl;
fprintf('NUMBER OF CLUSTERS: %i \n', NCLUST);
disp('Performing assignation')

%assignation
for i=1:ND
  if (cl(ordrho(i))==-1)
    cl(ordrho(i))=cl(nneigh(ordrho(i)));
  end
end

figure;
hold on;
cmap=colormap;
for i=1:NCLUST
   ic=int8((i*64.)/(NCLUST*1.));
   %plot(rho(icl(i)),delta(icl(i)),'o','MarkerSize',8,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
   plot(X(icl(i),1),X(icl(i),2),'o','MarkerSize',8,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
   plot(X(find(cl==icl(i)),1),X(find(cl==icl(i)),2),'.','MarkerSize',5,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
end
title('data cluster','FontSize',15.0);
xlabel('x');
ylabel('y');
hold off;
