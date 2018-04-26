%In the next path we select the camera to get the fingerprint.
%In the next block we copare the fingerprint with other cameras. Finally a
%matrix of rows is generated in the variable cameras.

image_dir = 'C:\Users\Gabriel Ceron\Desktop\Semestre_Loc\Multimedia\1stlab\dresden\Dresden\flatfield\Canon_Ixus70_1\';
Im = dir([image_dir,'\*.jpg']);

% estimate fingerprint (3 channels)
addpath(image_dir)
RP = getFingerprintCrop(Im,[1 1],[1024 1024]);

% obtain actual PRNU
RP = rgb2gray1(RP);
% optional: remove periodic artifacts through Wiener filtering of DFT
% sigmaRP = std2(RP);
% Fingerprint = WienerInDFT(RP,sigmaRP);

%% Comparing with all the other cameras

dirs=dir('C:\Users\Gabriel Ceron\Desktop\Semestre_Loc\Multimedia\1stlab\dresden\Dresden\natural');
dirsCrop={dirs(:).name};
siz=size(dirsCrop);
dirsCropP=dirsCrop(3:siz(2)) %leaving out the first 2 names 
siz=size(dirsCropP);

ncameras=siz;
nimages=5;

rhos=zeros(siz(2),5); %initialice arrays

for i=1:1:siz(2)
    path1=strcat('C:\Users\Gabriel Ceron\Desktop\Semestre_Loc\Multimedia\1stlab\dresden\Dresden\natural\',dirsCropP(i));
    
    dirs2=dir(path1{ 1});
    dirsCrop2={dirs2(:).name};
    siz2=size(dirsCrop2);
    dirsCropP2=dirsCrop2(3:siz2(2)); %leaving out the first 2 names
    path2=strcat(path1,'\');
    path3=strcat(path2,dirsCropP2(i));
    
    
    disp(i)
    disp('of')
    disp(siz(2))
    
    for j=1:1:1

% extract noise residual
 
    image_name = path3{1};
    Noisex = NoiseExtractFromImageCrop(image_name,2,[1 1],[1024 1024]);
    % optional: remove artifacts
    Noisex = WienerInDFT(Noisex,std2(Noisex));
    % read and convert image in grayscale
    Ix = double(rgb2gray(imread(image_name)));
    % normalized correlation
    C = corrcoef(Noisex, Ix(1:1024,1:1024).*RP);
    rho = C(1,2);
    rhos(i,j);
    % PCE. try "help PCE" for info on PCE output
    C = crosscorr(Noisex, Ix(1:1024,1:1024).*RP);
    Out = PCE(C);
    metric = Out.PCE;
    end
end
