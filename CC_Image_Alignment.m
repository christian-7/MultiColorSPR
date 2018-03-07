%% Rotate the image and compare it with the reference

clear, clc, close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

folder      = 'test_data_9_fold';
data_name   = 'Particles_Ch1';
mode        = 0;  % 0 = min; 1 = max;
maxIter     = 5;  % number of iterations 
maxPart     = 20; % number of particles/images
usfac       = 10; % Upsampling factor (integer). Images will be registered to 
                  % within 1/usfac of a pixel. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Image_CC = {};

% Load the first reference image, i.e. the sum of all input images
 
cd(folder); ref_im = im2double(imread('reference_9Fold_Sim.tif')); cd ..

emptyRef  = zeros(round(max(size(ref_im,1))*1.5),round(max(size(ref_im,1))*1.5));

for iteration = 1:maxIter; % For all iterations
    
    if iteration == 1;

size_DC = size(emptyRef); center = round(size_DC(2)/2);
emptyRef(round(center-size(ref_im,1)/2):(round(center-size(ref_im,1)/2))+size(ref_im,1)-1,... 
         round(center-size(ref_im,1)/2):(round(center-size(ref_im,1)/2))+size(ref_im,1)-1) = ref_im;
     
    else
        
 newRef = Image_CC{1,iteration-1};
 
 for k=2:size(Image_CC,1)
     newRef = imadd(newRef,Image_CC{k,iteration-1});
 end
        
emptyRef  = zeros(round(max(size(ref_im,1))*1.5),round(max(size(ref_im,1))*1.5));
size_DC = size(emptyRef); center = round(size_DC(2)/2);
emptyRef(round(center-size(newRef,1)/2):(round(center-size(newRef,1)/2))+size(newRef,1)-1,... 
         round(center-size(newRef,1)/2):(round(center-size(newRef,1)/2))+size(newRef,1)-1) = newRef;

    end 
        

for j = 1:maxPart; % For all Particles
    
if iteration == 1; 
    
% Construct the file name

if (0<j) && (j<10);
image_name = [[data_name '_00'] num2str(j) '.tif'];   
elseif (10<=j) && (j<100);
image_name = [[data_name '_0'] num2str(j) '.tif'];
else
image_name = [[data_name '_'] num2str(j) '.tif'];
end

cd(folder); Im2 = im2double(imread(image_name)); cd ..

else
    
    Im2 = Image_CC{j,iteration-1};

end
    
empty2    = zeros(round(max(size(Im2,1))*1.5),round(max(size(Im2,1))*1.5));

rot_reg = [];
rot_reg = zeros(360,5);
rot_reg(:,1) = 1:1:360;

% Rotate the image and put in into a black space

for i=1:length(rot_reg);
    
Im2_rot = imrotate(Im2, rot_reg(i,1));

empty3 = empty2;
size_empty3 = size(empty3); center = round(size_empty3(2)/2);
empty3(round(center-size(Im2_rot,1)/2):(round(center-size(Im2_rot,1)/2))+size(Im2_rot,1)-1,round(center-size(Im2_rot,1)/2):(round(center-size(Im2_rot,1)/2))+size(Im2_rot,1)-1) = Im2_rot;

try
    
[output, Greg] = dftregistration(fft2(emptyRef),fft2(empty3),usfac);

catch
    rot_reg(i,2:5) = 0;
continue
end

rot_reg(i,2:5) = output; %  output of dftregistration =  [error,diffphase,net_row_shift,net_col_shift]

end

% Find the minimum/maximum error

if mode == 0;
   
    target = find(rot_reg(:,2)==min(rot_reg(:,2)));
else
    target = find(rot_reg(:,2)==max(rot_reg(:,2)));
end

if length(target)>1;
    target = target(1);
else end

% Apply the corresponding rotation (Step 1)

Im2_rot = imrotate(Im2, rot_reg(target,1));

% Find and apply translation (Step 2)

% Put the rotated image in a black space

empty3 = empty2;
size_empty3 = size(empty3); center = round(size_empty3(2)/2);
empty3(round(center-size(Im2_rot,1)/2):(round(center-size(Im2_rot,1)/2))+size(Im2_rot,1)-1,round(center-size(Im2_rot,1)/2):(round(center-size(Im2_rot,1)/2))+size(Im2_rot,1)-1) = Im2_rot;
    
[output, Greg] = dftregistration(fft2(emptyRef),fft2(empty3),usfac);

empty3 = abs(ifft2(Greg));

% Crop around the center to prevent size increase

[p3, p4] = size(empty3);
q1       = 63;                  % size of the crop box
i3_start = floor((p3-q1)/2);    % or round instead of floor; using neither gives warning
i3_stop  = i3_start + q1;

Im2_crop = empty3(i3_start:i3_stop, i3_start:i3_stop, :);
empty3   = Im2_crop;

Image_CC{j,iteration} = empty3;

clc;
disp(['Particle ID - ' num2str(j) '/' num2str(maxPart) ' Iteration - ' num2str(iteration) '/' num2str(maxIter)]);

end

end

%% Show the averaged images (optional)

close all

AveragedIm = Image_CC{1,maxIter};
 
 for k=2:size(Image_CC,1)
     AveragedIm = imadd(AveragedIm,Image_CC{k,maxIter});
     
 end
 
figure('Position',[700 100 300 300],'Name','result after final iteration'); imagesc(AveragedIm); 
axis square
colormap hot

figure('Position',[100 100 600 600],'Name','result after each iteration'); 
num_Images = ceil(sqrt(maxIter));
for i = 1:maxIter;

     AveragedIm = Image_CC{1,i};
 
 for k=2:size(Image_CC,1)
     
     AveragedIm = imadd(AveragedIm,Image_CC{k,i});
     
 end 
 
subplot(num_Images,num_Images,i);
imagesc(AveragedIm);
title(['Iteration ',num2str(i),' / ',num2str(maxIter),])
  axis square
  colormap hot  
end
    
%% Save the final averaged image (optional)

% 16-bit

savename =['Averaged_Image_' num2str(maxPart) '_Part_' num2str(maxPart) '_Iter_' num2str(iteration)];
imwrite(AveragedIm, [savename '.tiff']);

% 32-bit

I32     = [];
I32     = uint32(AveragedIm);

t = Tiff([savename '_32bit.tiff'],'w');

tagstruct.ImageLength     = size(I32,1);
tagstruct.ImageWidth      = size(I32,2);
tagstruct.Photometric     = Tiff.Photometric.MinIsBlack;
tagstruct.BitsPerSample   = 32;
tagstruct.SamplesPerPixel = 1;
tagstruct.RowsPerStrip    = 16;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct.Software        = 'MATLAB';
t.setTag(tagstruct)

t.write(I32);
t.close()

