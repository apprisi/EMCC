function batch_decode

addpath l1_magic
addpath l1_magic/Optimization

% set the path to emcc templates folder
BaseDir1 = '02DB1_(256,60)';

% set the path to pmcc templates folder
BaseDir2 = '../Data/02DB1/pmcc/';

% set the path to save match scores
SaveFile = sprintf('Scores/MatchScore_%s.mat', BaseDir1);

% load coding matrix
load(sprintf('%s/G.mat', BaseDir1));

% load the pairs of fingerprint
[GList1,GList2]=load_match_pairs('genuine_file_pairs.txt');
[IList1,IList2]=load_match_pairs('impostor_file_pairs.txt');

% do genuine matching
GScore = BatchDecode(BaseDir1,BaseDir2,GList1,GList2,G);

% do impostor matching
IScore = BatchDecode(BaseDir1,BaseDir2,IList1,IList2,G);

% save genuine and impostor scores
save(SaveFile, 'GScore','IScore')

function Score = BatchDecode(BaseDir1,BaseDir2,List1,List2,G)
Score = zeros(length(List1),1);
time1 = tic;
for k = 1:length(List1)
    file1 = sprintf('%s/%s',BaseDir1, List1{k});
    file2 = sprintf('%s/%s',BaseDir2, List2{k});
    if exist(file1)==0 || exist(file2)==0
        Score(k) = 0;
        continue;
    end
    X = load(file1);
    Mcc = loadmcc(file2);
    [Msg,Pairs] = Decode(X, Mcc, G);
    
    MsgBit = zeros(size(Msg,1), 2*size(G,2));
    for i=1:size(Msg,1)
        MSG = de2bi(Msg(:,i));
        MsgBit(i,:) = MSG(:);
    end
    
    Score(k) = size(Pairs,1);
    
    % display information
    time2 = toc(time1);
    time_avg = time2/k;
    time_left = time_avg * (length(List1)-k)/3600.;
    disp(sprintf('[%d] %s - %s: #pairs = %d, average time:%fs, time left: %fh',...
        k, List1{k},List2{k}, size(Pairs,1), time_avg, time_left))
end




function [List1,List2]=load_match_pairs(filename)
fid = fopen(filename);
List1 = {};
List2 = {};
c = 0;
while true
   s = fgetl(fid);
   if s==-1,break;end
   s = regexp(s, ' ', 'split');
   c = c+1;
   List1{c} = s{1};
   List2{c} = s{2};
end
fclose(fid);






function save_pairs(pairs, filename)
fid = fopen(filename,'w');
for i=1:size(pairs,1)
   fprintf(fid, '%d %d\n', pairs(i,1)-1, pairs(i,2)-1); 
end
fclose(fid);