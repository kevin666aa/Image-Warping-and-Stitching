function [t1, t2] = getPoints(im1, im2, n)
    i1 = imread(im1);
    i2 = imread(im2);
    
    x1_range = size(i1, 2);
    y1_range = size(i1, 1);
    x2_range = size(i2, 2);
    y2_range = size(i2, 1);
    
    figure(1);
    imshow(i1);

    figure(2);
    imshow(i2);
    
    figure(1);
    t1 = ginput(n);
    t1(:, 1) = t1(:, 1);
    t1(:, 2) = t1(:, 2);
    
    figure(2);
    t2 = ginput(n);
    t2(:, 1) = t2(:, 1);
    t2(:, 2) = t2(:, 2);
    
    t1 = t1';
    t2 = t2';
    close(1);
    close(2);