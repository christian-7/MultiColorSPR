function [bin] = segmentFromWF(PrimaryWF);
   
level       = graythresh(imadjust(PrimaryWF));
bin         = im2bw(imadjust(PrimaryWF),level);

figure('Position',[600 10 500 500],'name','Otsu segmentation'), imshow(bin,'InitialMagnification','fit');

end


