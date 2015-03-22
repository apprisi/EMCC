function DecodeMsg(file_X, file_mcc, file_G, file_msg_recon, N)
X = load(file_X);
Mcc = loadmcc(file_mcc);
load(file_G);
[Msg,Pairs] = Decode(X, Mcc, G, N);
Msg = Msg';

MsgBit = zeros(size(Msg,2), 2*size(G,2));
for i=1:size(Msg,2)
    MSG = de2bi(Msg(:,i));
    MsgBit(i,:) = MSG(:);
end

save_msgbit(file_msg_recon, MsgBit, Pairs(:,1)-1);