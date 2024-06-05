image = imread('face1.jpg');

[width height] = size(image);
if(width > 400)
    image = imresize(image,[400 NaN]);
end 


face_Detector = vision.CascadeObjectDetector();

location = step(face_Detector,image);

detected  = insertShape(image,'rectangle',location);

figure;
imshow(detected);
title('Detected Face');

