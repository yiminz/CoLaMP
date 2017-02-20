%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A test wrapper for RobustPCA implementation using ADMM method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Data can also be arranged from the video frames 
% y = dir('*.bmp');
% 
% for i = 1:200
%     x = imread(y(i).name);
%     M(:,:,i) = rgb2gray(x);
% end

% For reproduciton of the result we have stored the data in a mat file
% loading airport video image sequence of first 200 frames
load('200frames.mat');

M = double(M);
s = size(M);

mu = 10^-3;
bdim = 10;
lambda = 1 / (bdim * sqrt(s(1)*s(2)));

[L,z, Y,x,v,history] = robustpca_l2sparsity_mxm_block(M, mu, lambda, bdim);

%  For warm start use this definition
% [L,z, Y,x,v,history] = robustpca_l2sparsity_mxm_block(M, mu, lambda, bdim);%,x,v,Y,z);

% reporting
K = length(history.objval);

h = figure;
subplot(3,1,1);
plot(1:K, history.objval, 'k', 'MarkerSize', 10, 'LineWidth', 2);
ylabel('f(x^k) + g(z^k)'); xlabel('iter (k)');

subplot(3,1,2);
semilogy(1:K, max(1e-8, history.r_norm), 'k', ...
    1:K, history.eps_pri, 'k--',  'LineWidth', 2);
ylabel('||r||_2');

subplot(3,1,3);
semilogy(1:K, max(1e-8, history.s_norm), 'k', ...
    1:K, history.eps_dual, 'k--', 'LineWidth', 2);
ylabel('||s||_2'); xlabel('iter (k)')

% Results from the paper
figure;
subplot(3,3,1);imshow(M(:,:,18),[]);
subplot(3,3,2);imshow(L(:,:,18),[]);
subplot(3,3,3);imshow(abs(z(:,:,18)),[]);
subplot(3,3,4);imshow(M(:,:,100),[]);
subplot(3,3,5);imshow(L(:,:,100),[]);
subplot(3,3,6);imshow(abs(z(:,:,100)),[]);
subplot(3,3,7);imshow(M(:,:,199),[]);
subplot(3,3,8);imshow(L(:,:,199),[]);
subplot(3,3,9);imshow(abs(z(:,:,199)),[]);