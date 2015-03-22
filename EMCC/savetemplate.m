function savetemplate(filename,X)
num = size(X,1);
fid = fopen(filename,'w');
for i=1:num
   for k=1:size(X,2)-1
      fprintf(fid, '%f ', X(i,k));
   end
   fprintf(fid,'%f\n',X(i,end));
end
fclose(fid);