image = imread('face1.jpg');

[width height] = size(image);
if(width > 600)
    image = imresize(image,[600 NaN]);
end 


face_Detector = vision.CascadeObjectDetector();

loc = step(face_Detector,image);

detected  = insertShape(image,'rectangle',loc);

figure;
imshow(detected);
title('Detected Face');

