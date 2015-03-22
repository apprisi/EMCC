function [Msg,pairs] = Decode(X,Mcc,G, N)
M = size(G,1);
Num1 = size(X,1);
Num2 = size(Mcc,1);
pinvG = inv(G'*G)*G';
checksum = int32(X(:,end));
X = X(:,1:end-1);
pairs = [];
Msg = [];
for i=1:Num1
   for j=1:Num2
      y = X(i,:) .* sign(Mcc(j,1:M)-0.5);
      y = y';
      x0 = pinvG * y;
      xp = l1decode_pd(x0, G, [], y, 1e-3, 20);
      xp = round(xp');
      if sum(xp<0)==0 && crc16(xp)==checksum(i)
        pairs = [pairs;[i j]];
        Msg = [Msg;xp];
        if N>0 && size(pairs,1)==N
            return;
        end
      end
   end
end