function [ P ] = create_proj_mat( K, R, t )
%create_proj_mat returns thr projection matrix when
%rotation (3x3), translation(3x1) and K (3x3) are input arguments
%given in matlab format and P is in regular format.
K = K';
R = R';
t = t'; %TODO: check dimension of t 
P = K * horzcat(R,t);
end


