SUB='sub-cort011';
SES='ses-post';
OUTPUT=sprintf('./tractography/%s/%s_%s_aparc2009matrix.csv', SUB,SUB,SES);
connmatrix=readmatrix(OUTPUT);
figure;
%colormap(hot(32))
imagesc(connmatrix)

%max connectivity for R.Hippo
[CR, IR]=max(connmatrix(87,:));
%max connectivity for L Hippo
[CL, IL]=max(connmatrix(80,:));

%sorted 
[SCR SIR] = sort(connmatrix(87,:),'descend');
[SCL SIL] = sort(connmatrix(80,:),'descend');

%%
SUB='sub-cort012';
SES='ses-post';
OUTPUT=sprintf('./tractography/%s/%s_%s_aparc2009matrix.csv', SUB,SUB,SES);
connmatrix=readmatrix(OUTPUT);
figure;
%colormap(hot(32))
imagesc(connmatrix)

%max connectivity for R.Hippo
[BCR, BIR]=max(connmatrix(87,:));
%max connectivity for L Hippo
[BCL, BIL]=max(connmatrix(80,:));

%sorted 
[BSCR BSIR] = sort(connmatrix(87,:),'descend');
[BSCL BSIL] = sort(connmatrix(80,:),'descend');

%%
N=20;
disp('left hippo')
LVAL=intersect(BSIL(1:N),SIL(1:N))

disp('right hippo')
RVAL=intersect(BSIR(1:N),SIR(1:N))

