% IOWA STATE UNIVERSITY

%   Developed by Seyed Vahid Mirnezami September 27, 2018 -
%   vahid@iastate.edu - vahid.gvg@gmail.com
    
%   Copyright 2017-2018 Prof. Baskar Ganapathysubramanian -
%   baskarg@iastate.edu 


% PanicleMainPath function is used to calculate the boundary of the panicle and its path form the bottom to the top.

% Inputs: Standard RGB image.
% Output: panicle path, boundaries, and skeleton indices

function [path_top, right_boundary, left_boundary, xskeBW, yskeBW]=panicleMainPath(IMG)

% segment the image using color-based K-mean clustering
LB1KNN = knnRB(IMG,2);
temp=LB1KNN(:,:,1);

% take the biggest component of the image
CC = bwconncomp(temp);
numPixels = cellfun(@numel,CC.PixelIdxList);
temp = zeros(size(temp));
[~,idx] = max(numPixels);
temp(CC.PixelIdxList{idx}) = 1;

% blur the images
Blur = imgaussfilt(temp,10);
count=1;

% find the boundary of the blur image
for j=1:size(Blur,1)
    checkB = Blur(j,:);
    [~, c] = find(checkB);
    if ~isempty(c)
        left_boundary(count,1:2) = [j min(c)];
        right_boundary(count,1:2) = [j max(c)];
        Blur(j,min(c):max(c))=1;
        count = count + 1;
    end
end
% skeletonize the image
skeBW = bwmorph(Blur,'thin',inf);
skeBW(1,:)=0;
skeBW(end,:)=0;
skeBW(:,1)=0;
skeBW(:,end)=0;

% apply morphological operation to find the endpoints
nn=bwmorph(skeBW,'endpoints');
[vv, ww]=find(nn);
Endpoints = [vv ww];
sortedEndpoints = sortrows(Endpoints);
[yskeBW, xskeBW]=find(skeBW);

% convert the skeleton image into graph mode
[DistMat]=skelToGraph(skeBW);

% the bottom of the image is the starting point of the tassel
Istart=find(xskeBW==sortedEndpoints(end,2) & yskeBW==sortedEndpoints(end,1));

% the top of the image is the starting point of the tassel
linearIndEndTop=find(xskeBW==sortedEndpoints(1,2) & yskeBW==sortedEndpoints(1,1));

% track the shortest path from the starting point to the tip of the panicle
[~, path_top, ~]=graphshortestpath(DistMat,Istart,linearIndEndTop);

end
