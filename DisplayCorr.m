function [displayedCorr] = DisplayCorr(image1, image2, matches, dist_vals, numberOfPointToShow)
fontSize = 35;
fontColor = 'Red';

displayedCorr = appendimages(image1,image2);

image1Width = size(image1,2);
[vals,indx] = sort(dist_vals);

for i = 1 : min([size(vals,1) numberOfPointToShow])
    currentIndex = indx(i);
    displayedCorr = insertText(displayedCorr,[matches(currentIndex,1),matches(currentIndex,2)],...
        num2str(i),'FontSize',fontSize,'TextColor',fontColor, 'AnchorPoint','Center','BoxOpacity',0);
    displayedCorr = insertText(displayedCorr,[image1Width + matches(currentIndex,3),matches(currentIndex,4)],...
        num2str(i),'FontSize',fontSize,'TextColor',fontColor, 'AnchorPoint','Center','BoxOpacity',0);
end
