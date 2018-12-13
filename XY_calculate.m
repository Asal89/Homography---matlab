function [ XY ] = XY_calculate( fx, fy, s ,cx, cy, xy, Z )
% "XY_calculate" returns [X, Y] world coordinates, centered on camera.
% fx, fy, s ,cx, cy - camera intrisic parameters
% Z - in world coordinates, centered on camera (in camera intrinsic units).
% XY - X and Y coordinates in camrea plane (each row is a couple)
% xy - pixel's matrix (each row is a couple)
% for calculation detailes - search "XY_calculate" on inbox

xy(1,:) = xy(1,:) - cx;
xy(2,:) = xy(2,:) - cy;
xy = Z*xy;
A = [fx, s ; 0, fy];

XY = inv(A) * xy;


end

