Img1FileName = 'newYorkLeft.pgm';
Img2FileName = 'newYorkRight.pgm';

H_Origin=[1 .2 0; .1 1 0; 0.5 0.2 1];


%create Transformed image
Image1 = imread(Img1FileName);
[TransformImage] = ComputeProjective(Image1, H_Origin);
%TransformImage = imgaussfilt(TransformImage,0.5); %make gaussian to image.
imwrite(TransformImage,Img2FileName,'pgm'); %write image to file.

%read the images!
Image1 = imread(Img1FileName);
Image2 = imread(Img2FileName);

[num_matches, matches, dist_vals] = match(Img1FileName, Img2FileName, 0.3);

[displayedCorr] = DisplayCorr(imread(Img1FileName), imread(Img2FileName), matches, dist_vals, 10);
figure, imshow(displayedCorr);

%Constants for text:
fontSize = 35;
fontColor = 'White';

%Ransac:
[H_RANSAC] = RANSAC_Wrapper(matches, @DLT, ...
    @getHomographicDist, @(x) 0, 4, 0.0002);

ImageRANSAC = ComputeProjective(Image1, H_RANSAC);

ceneterLoaction = [0.5*(size(ImageRANSAC,1)) , 0.5*(size(ImageRANSAC,2))];

[pnts_gt,pnts_computed] = ComputeTestPoints(H_Origin, H_RANSAC);
[error] = ComputeError(pnts_gt,pnts_computed);
text = sprintf('Ransac: Error - %0.5f', error);

ImageRANSAC = insertText(ImageRANSAC,ceneterLoaction,...
    text ,'FontSize', fontSize, 'TextColor', fontColor, 'AnchorPoint', 'Center', 'BoxOpacity',0);

%DLT:
[H_DLT] = DLT(matches);

ImageDLT = ComputeProjective(Image1, H_DLT);

ceneterLoaction = [0.5*(size(ImageDLT,1)) , 0.5*(size(ImageDLT,2))];

[pnts_gt,pnts_computed] = ComputeTestPoints(H_Origin, H_DLT);
[error] = ComputeError(pnts_gt,pnts_computed);
text = sprintf('DLT: Error - %0.5f', error);

ImageDLT = insertText(ImageDLT,ceneterLoaction,...
    text ,'FontSize', fontSize, 'TextColor', fontColor, 'AnchorPoint', 'Center', 'BoxOpacity',0);


%Original
ImageOrigin = Image2;

ceneterLoaction = [0.5*(size(ImageOrigin,1)) , 0.5*(size(ImageOrigin,2))];
text = 'original';

displayedCorr = insertText(ImageOrigin,ceneterLoaction,...
    text ,'FontSize', fontSize, 'TextColor', fontColor, 'AnchorPoint', 'Center', 'BoxOpacity',0);

imageSummery = appendimages(rgb2gray(ImageDLT), ImageOrigin);
imageSummery = appendimages(imageSummery, rgb2gray(ImageRANSAC));
% imwrite(imageSummery, 'Ransac_BAD.jpg', 'jpg'); %write image to file.
figure, imshow(imageSummery);