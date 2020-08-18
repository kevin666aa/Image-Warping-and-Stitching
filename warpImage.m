function [warpIm, mergeIm] = warpImage(inputIm, refIm, H)
    %% find the bounding box for warp img
    inputIm = double(inputIm);
    refIm = double(refIm);
    
    ul = H * [1 1 1]';                    ul = ul / ul(3,1);
    ur = H * [size(inputIm , 2) 1 1]';    ur = ur / ur(3,1);
    dl = H * [1 size(inputIm , 1) 1]';    dl = dl / dl(3,1);
    dr = H * [size(inputIm , 2) size(inputIm , 1) 1]';    dr = dr / dr(3,1);
    
    ymax = ceil(max(ul(1,1), max(ur(1,1), max(dl(1,1), dr(1,1)))));
    ymin = floor(min(ul(1,1), min(ur(1,1), min(dl(1,1), dr(1,1)))));
    xmax = ceil(max(ul(2,1), max(ur(2,1), max(dl(2,1), dr(2,1)))));
    xmin = floor(min(ul(2,1), min(ur(2,1), min(dl(2,1), dr(2,1)))));
  
  %disp([xmax, xmin, ymax, ymin]);
    
    %%  Inverse Warping
    xlen = xmax - xmin + 1;
    ylen = ymax - ymin + 1;
    disp([xlen, xmax, xmin]);
    disp([ylen, ymax, ymin]);
    
    warpIm = zeros([xlen ylen 3]);
    
    tempy = zeros([1 ylen]);
    one = ones([1 ylen]);
    for j = 1 : ylen
        tempy(1, j) =  j + ymin - 1;
    end
    
    for i = 1 : xlen
       tempx = (i + xmin - 1) * ones([1 ylen]);
       raw_ind = tempy;
       raw_ind(2,:) = tempx;
       raw_ind(3,:) = one;
       
       pp = H \ raw_ind;
       pp = pp ./ pp(3, :);

       
       r = interp2(inputIm(:,:,1), pp(1,:), pp(2,:));
       g= interp2(inputIm(:,:,2), pp(1,:), pp(2,:));
       b = interp2(inputIm(:,:,3), pp(1,:), pp(2,:));
       
       r((isnan(r))) = 0;
       g((isnan(g))) = 0;
       b((isnan(b))) = 0;
       warpIm(i, :, 1) = r;
       warpIm(i, :, 2) = g;
       warpIm(i, :, 3) = b;
       
    end
      
    disp("done");
    %% Merge image
    mergeXmax = max(xmax, size(refIm, 1));
    mergeXmin = min(xmin, 1);
    mergeYmax = max(ymax, size(refIm, 2));
    mergeYmin = min(ymin, 1);
    mergeXlen = mergeXmax - mergeXmin + 1;
    mergeYlen = mergeYmax - mergeYmin + 1;
    
    mergeIm = zeros([mergeXlen mergeYlen 3]);
    for i = 1 : xlen
        for j = 1 : ylen
           x = i + xmin - mergeXmin;
           y = j + ymin - mergeYmin;
           mergeIm(x, y, :) = warpIm(i, j, :);
        end 
    end
    disp([mergeXlen, mergeYlen, mergeXmin, mergeYmin])
    for i = 1 : size(refIm, 1)
        for j = 1 : size(refIm, 2)
           x = i - mergeXmin + 1;
           y = j - mergeYmin + 1;
           
           if mergeIm(x, y, 1) == 0
            mergeIm(x, y, :) = refIm(i, j, :);
           end
           
           if mergeIm(x, y, 1) ~= 0
            mergeIm(x, y, :) = 0.5 * refIm(i, j, :) + 0.5 *  mergeIm(x, y, :);
           end
        end
    end
    
    mergeIm = uint8(mergeIm);
    warpIm = uint8(warpIm);