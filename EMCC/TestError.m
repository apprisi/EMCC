function Pro = TestError(M,N,type)
Pro = zeros(length(0:0.01:1),1);
ind = 0;
for r = 0:0.01:1
    ind = ind + 1;
    for k=1:20
        % number of perturbations
        T = round(r*M);

        % coding matrix
        G = randn(M,N);

        % source word
        %x = randn(N,1);
        x = randi(2,[N,1])-1;

        % code word
        c = G*x;

        % channel: perturb T randomly chosen entries
        q = randperm(M);
        y = c;
        y(q(1:T)) = -y(q(1:T));%flip the sign

        % recover
        pinvG = inv(G'*G)*G';
        %disp(i)
        x0 = pinvG*y;
        xp = l1decode_pd(x0, G, [], y, 1e-3, 20);
        if sum(round(xp)~=x)==0
            Pro(ind) = Pro(ind) + 1;
        end
    end
end

Pro = Pro/20.;

plot(0:0.01:1,Pro,type,'linewidth',2);
xlabel('Fraction of errors')
ylabel('Frequency of successful decoding')
hold on
