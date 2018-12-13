function [H] = create_homography_mat(K_ref, K, R ,t, d ,n)
% this function creates the homography matrix 
% when K R t are given in matlab formulation, d is the distance
% of the plane, n is unit normal (3X1)
% K_ref - K of the reference camera (matlab formulation)
% and H is in regular format
K_ref = K_ref';
K = K';
R = R';
t = t';
H = K * (R - (1/d) * t * n') * inv(K_ref);

end

