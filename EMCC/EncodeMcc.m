function EncodeMcc(filename, savefile, savemsg, G)
mcc = loadmcc(filename);
Num = size(mcc,1);
[M,N] = size(G);
Msg = randi(4,[N, Num])-1;
X = G * Msg;
X = X';

MsgBit = zeros(Num, N*2);

% generate CRC check sum for message
checksum = zeros(size(Msg,2),1);
n = 2.^(15:-1:0)';
gen = crc.generator('Polynomial', '0x8005', 'ReflectInput', false, 'ReflectRemainder', true);

for i=1:size(Msg,2)
    MSG = de2bi(Msg(:,i));
    cs= generate(gen, MSG(:));
    checksum(i) = cs(end-15:end)' * n;
    MsgBit(i,:) = MSG(:);
end

% corrupt with mcc
X = X.* sign(mcc(:,1:M)-0.5);
X = [X checksum];

% save secure template to file
savetemplate(savefile,X);

% save bit message
% dlmwrite(savemsg, MsgBit,' ');
save_msgbit(savemsg, MsgBit, 0:size(MsgBit,1)-1);

