function X = loadmcc(filename)
%filename = '/Users/eryunliu/Documents/Research/Database/FVC2002/DB1/Verifinger7/pmcc_1.0_0.0/1_1.txt';
fid = fopen(filename);
num = fscanf(fid, '%d');
X = zeros(num,1024);
for i=1:num
   str = fgetl(fid);
   mcc = double(str(6:2:end))-'0';
   X(i,:) = mcc;
end
fclose(fid);