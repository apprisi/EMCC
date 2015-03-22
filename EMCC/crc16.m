function s = crc16(c)
% generate CRC16 check sum for message
n = 2.^(15:-1:0)';
gen = crc.generator('Polynomial', '0x8005', 'ReflectInput', false, 'ReflectRemainder', true);
MSG = de2bi(c);
cs= generate(gen, MSG(:));
s = cs(end-15:end)' * n;
