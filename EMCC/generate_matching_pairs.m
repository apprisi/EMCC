fid = fopen('genuine_file_pairs.txt','w');
for k=1:100
   for i=1:8
       str1 = sprintf('%d_%d.txt',k,i);
      for j=i+1:8
          str2 = sprintf('%d_%d.txt',k,j);
          fprintf(fid,'%s %s\n',str1,str2);
      end
   end
end
fclose(fid);


fid = fopen('impostor_file_pairs.txt','w');
for k=1:100
   for i=k+1:100
      str1 = sprintf('%d_1.txt',k);
      str2 = sprintf('%d_1.txt',i);
      fprintf(fid,'%s %s\n',str1,str2);
   end
end
fclose(fid);