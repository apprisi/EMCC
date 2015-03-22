function save_msgbit(file, msgbit, index)
fid = fopen(file,'w');
for k=1:size(msgbit,1)
    fprintf(fid,'%d [', index(k));
    for i=1:size(msgbit,2)
       fprintf(fid, '%d ', msgbit(k,i)); 
    end
    fprintf(fid,']\n');
end
fclose(fid);