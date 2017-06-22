function [displayedCorr] = DisplayCorr(image1, image2, matches, dist_vals, x)
image3 = appendimages(image1,image2);

image1Width = size(image1,2);
hold on;
imshow(image3);
[vals,indx] = sort(dist_vals);

for i = 1 : min([size(vals,1) x])
    currentIndex = indx(i);
    text(matches(currentIndex,1),matches(currentIndex,2),num2str(i), 'FontSize', 15, 'Color', 'Red', 'HorizontalAlignment', 'center');
    text(image1Width + matches(currentIndex,3),matches(currentIndex,4),num2str(i), 'FontSize', 15, 'Color', 'Red', 'HorizontalAlignment', 'center');
end
hold off;
