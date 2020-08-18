function H = computeH(t1, t2)
    n = size(t1,2);
    count = 1;
    for i = 1:n
        x1 = t1(1, i);
        y1 = t1(2, i);
        xn = t2(1, i);
        yn = t2(2, i);
        
        line = [x1 y1 1 0 0 0 -x1*xn -xn*y1 -xn];
        A(count, :) = line;
        count = count + 1;
        
        line = [0 0 0 x1 y1 1 -yn*x1 -yn*y1 -yn];
        A(count, :) = line;
        count = count + 1;
    end
    
    [V, D] = eig(A'*A);
    H = reshape(V(:, 1), [3, 3])';