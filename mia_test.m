clear 
clc

%best 7 4

% general parameters 
fts = 12;
thre_lv = 1;
Ns = 1;
bgremove = 0;

% adjustable parameters
radius = 8;
%radius = final_radius;
obj_sz = 2*round(radius) + 1;
filt_sz = 4;

% read file
file_list = dir('171101_Xiaoyan');
file_list = file_list(3:end); 

for jj = 1:length(file_list)
    
image = imread(['171101_Xiaoyan/',file_list(jj).name]); 
fprintf([file_list(jj).name,'\n']);

trunc = 100;
image1 = image(trunc+1:end-trunc,trunc+1:end-trunc);
image = image1;

kk2 = 4;
file_list2 = dir('sample');
file_list2 = file_list2(3:end); 
image2 = imread(['sample/',file_list2(kk2).name]); 
%fprintf([file_list2(kk2).name,'\n']);
image = histeq(image,imhist(image2(:,:,1)));
%image3 = histeq(image,imhist(image2(:,:,1)));

%% Step 0 remove the dead
nrows = size(image,1);
ncols = size(image,2);
igr = mat2gray(double((image(:,:,1))));
lv = multithresh(igr,2); %three layer: cells and background, normal cell margin, and dead cell margin
im = im2bw(igr,lv(end));
imf = imfill(im,'holes');
lab = bwlabel(imf);
cc = tabulate(lab(:));
[st,id] = sort(cc(:,2),'descend');
cc = cc(id(2:end),:);

csize = sqrt(max(cc(:,2))/pi);

imo = imopen(imf,strel('disk',1));
[centers, radii] = imfindcircles(imo,[round(csize/2) round(csize)], 'ObjectPolarity','bright',...
    'Sensitivity',0.77,'method','twostage');

%make a dead cell mask
dmask = zeros(nrows,ncols);
for k = 1:size(centers,1)
    for i = 1:nrows
        for j = 1:ncols
            if sqrt ((j-centers(k,1))^2 + (i-centers(k,2))^2) < radii(k)
                dmask(i,j) = 1;
            end
        end
    end
end

%% Step 1 Denoising
im = 255-double(histeq(image(:,:,1)));  %all channels are the same
gim = mat2gray(im);
bp  = bpass(im,2,obj_sz); 

% Step 2 Histogram Equalization
gr = mat2gray(bp);
frame = size(gr);
hm = histeq(gr);
hm1 = hm(:);

% Step 3 Convert to binary using Otsu's method
target = gr;
level = multithresh(target,thre_lv);
bnr = im2bw(target,level(end)); %can't do on the original, bp has to be used.
%can compare the histogram of original and bp

% Step 4 Morphological opening or closing
se = strel('disk',filt_sz);
bo = imopen(bnr,se);
conn = bwconncomp(bo,4);

% Step 5 Counting connected components using flood-fill approach
mask = zeros(size(image,1),size(image,2));
final_size = 0;
kk = 0;
cutoff = pi*(radius - filt_sz/2)^2;
for i = 1:conn.NumObjects
        cluster = zeros(nrows,ncols);
        cluster(conn.PixelIdxList{i}) = 1;
        entclus(i) = entropy(gim(conn.PixelIdxList{i}));
        osize(i) = length(conn.PixelIdxList{i});
        if norm((cluster - cluster.*dmask),'fro') > 0 && osize(i) > cutoff
            kk = kk + 1;      
            mask(conn.PixelIdxList{i}) = 1;            
            final_size = final_size + length(conn.PixelIdxList{i});
        end
end
final_radius = (final_size/pi/kk)^0.5;
overlay = imoverlay(image(:,:,1), bwperim(mask), [0.8 0 0]);
count = floor((kk+length(radii))*(frame(1)*frame(2)/(frame(1)-2*obj_sz)/(frame(2)-2*obj_sz)));

counti(jj) = count;

end

countt = reshape(counti',4,18);
cellcount = mean(countt);
fn = cell(length(file_list),1);
for i = 1:length(file_list)
    filename = file_list(i).name;
    idx = regexp(filename,'_');
    fn{i} = filename(1:idx(3)-1);
end
unifn = fn(1:4:end)';
unifn = strrep(unifn,'#','No');
cellcount = array2table(cellcount);
cellcount.Properties.VariableNames = unifn;
writetable(cellcount,'171105_Xiaoyan.csv');