%% Clear
clear all; close all; clc;
format longg;
format compact;
%% Loading
CellIDS = imageDatastore('C:\Users\che7oz\Desktop\CellQuant','FileExtensions','.jpg', 'LabelSource', 'foldernames','IncludeSubfolders', 1)
%%
for i=1:length(CellIDS.Files);
			 CellI = readDatastoreImage(CellIDS.Files{i,1});
    CellI = CellI(:,:,1);
    CellIraw = CellI;
				figure, imshow(CellI); title('Base Image'); %Base Image
%%
CellI = imcomplement(CellI); % Inverts bw img
    figure, imshow(CellI); title('Complement')

		bw = imbinarize(CellI, 'Adaptive','ForegroundPolarity','bright','Sensitivity',0.5);
		figure, imshow(bw)
% 	bw2 = edge(bw,'canny');
% 	figure, imshow(bw2)
	
	
%%
% 	[N,M] = bwlabel(bw,4)
% 	stats = regionprops(bw, 'all')
% 	CellBlobs = [stats.FilledArea]
%%
% 	figure, plot(CellBlobs)
	
% 	CellBlobs = sort(CellBlobs)
% 	figure, plot(CellBlobs)
	
% 	figure, hist(WingArea, 100)
% 	%%
% 					[CellID] = CellBlobs>180
% 					[CellSize] = CellID.*CellBlobs
% 					N(find(N~=CellID))=0;
% 				NN = (N~=0);
% 				bw3 = bw.*NN;
% 				figure, imshow(bw3)
%%


%  bw = bwmorph(bw, 'fill');
	bw = imfill(bw,'holes')
	bw = bwmorph(bw, 'fill');
	figure, imshow(bw)
	[N,M] = bwlabel(bw,4);
	stats = regionprops(N,'all');
	%%
	[CellArea] = [stats.FilledArea]
	
	N2 = bwareaopen(N, 180)
	
	
	stats2 = regionprops(N2,'all');
	
	
	CellBlobs = [stats2.FilledArea];
	%%
	figure, hist(CellBlobs,10);
	
	sortBlobs = sort(CellBlobs);
	[SsortBlobs] = sortBlobs(1:length(sortBlobs)/2)';
	[LsortBlobs] = sortBlobs(length(sortBlobs)/2:length(sortBlobs))';
	Smean = mean(SsortBlobs);
	Sstd = std(SsortBlobs);
	Lmean = mean(LsortBlobs);
	Lstd = std(LsortBlobs);
	
	
	figure,
  plotSpread(SsortBlobs);
  h = findobj(gca,'Type','line');
  x=get(h,'Xdata');
  y=get(h,'Ydata');
  Ssortx = x'


	figure,
	 plotSpread(LsortBlobs);
		h = findobj(gca,'Type','line');
  x=get(h,'Xdata');
  y=get(h,'Ydata');
  Lsortx = x'
	
	[h,p] = ttest2(SsortBlobs, LsortBlobs)
	%%
	figure, 
		xticks([1 2])
		scatter(Ssortx, SsortBlobs); hold on;
		scatter(Lsortx+1, LsortBlobs);hold on;
		scatter(0.5, mean(SsortBlobs), 50, 'k', 'filled'); hold on;
		scatter(1.5, mean(LsortBlobs), 50, 'k', 'filled'); hold on;
		errorbar(0.5,mean(SsortBlobs),Sstd, 'k', 'LineWidth', 1); hold on;
		errorbar(1.5,mean(LsortBlobs),Lstd, 'k', 'LineWidth', 1); hold off;
		xlim([0 3]);
		box on;
		ylabel('Cell Size (pix)')


% 				[WingArea] = [stats.FilledArea>180]
% 				[WingID] = [1:length(stats)]
% % 				
% % 				N = N(
% 				
% 				
% % 				[WingSize, WingID] = max(WingArea);
% 				N(find(N~=WingID))=0;
% 				NN = (N~=0);
% 				bw2 = bw.*NN;
% 				BW = edge(bw2,'canny');
% 				figure, imshow(BW)
				
end
