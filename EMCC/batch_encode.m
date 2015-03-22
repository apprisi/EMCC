% set the path to pmcc folder
path = '../Data/02DB1/pmcc/*.txt';
files = dir(path);

% code length
m = 256;

% message length
n = 60;

database = '02DB1';
savepath = sprintf('%s_(%d,%d)',database,m,n);
if exist(savepath)==0
    mkdir(savepath);
end

% generating the coding matrix
G = randn(m,n);
save(sprintf('%s/G.mat',savepath), 'G');

%
for k=1:size(files)
   filefrom = sprintf('%s/%s', path(1:end-5), files(k).name);
   fileto = sprintf('%s/%s', savepath, files(k).name);
   filemsg = sprintf('%s/m%s', savepath, files(k).name);
   disp(filefrom)
   EncodeMcc(filefrom, fileto, filemsg, G);
end