clear all;


webcam = webcam();

webcam.Resolution = '1280x720';
video_Frame = snapshot(webcam);

player = vision.VideoPlayer('Position', [100 100 432 240])


face_detector = vision.CascadeObjectDetector();
point_Tracker = vision.PointTracker('MaxBidirectionalError',2);

run_loop = true;
number_of_points = 0;
frame_count = 0;

while run_loop && frame_count <400
    video_Frame = snapshot(webcam);
    gray_Frame = rgb2gray(video_Frame);
    fram_count = frame_count+1;

    if number_of_points < 10
        face_rectangle = face_detector.step(gray_Frame);
        if ~isempty(face_rectangle)
            points = detectMinEigenFeatures(gray_Frame,'ROI',face_rectangle(1, :))
            xy_points = points.Location;
            number_of_points = size(xy_points,1);
            release(point_Tracker);
            initialize(point_Tracker,xy_points,gray_Frame);

            previous_points = xy_points;

            rectangle = bbox2points(face_rectangle(1,:));
            face_polygon = reshape(rectangle',1,[]);

            video_Frame = insertShape(video_Frame,'polygon',face_polygon,'LineWidth',3);
            video_Frame = insertMarker(video_Frame,xy_points,'+','Color','white');



        end 
    else
        [xy_points isFound] = step(point_Tracker,gray_Frame);
        new_points = xy_points(isFound,:);
        old_points = previous_points(isFound,:);

        number_of_points = size(new_points,1);

        if number_of_points >=10
            [xform  old_points new_points] = estimateGeometricTransform(old_points,new_points,'similarity','MaxDistance',4);
            rectangle = transformPointsForward(xform,rectangle);

            face_Polygon = reshape(rectangle',1,[]);

            video_Frame = insertShape(video_Frame,'polygon',face_Polygon,'LineWidth',3);
            video_Frame = insertMarker(video_Frame,new_points,'+','Color','white');

            previous_points = new_points;
            setPoints(point_Tracker,previous_points);




        end 
    end 
    step(player,video_Frame);
    run_loop = isOpen(player);


end 

clear cam;
releae(player);
release(point_Tracker);
release(face_detector);
