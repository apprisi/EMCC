function GAR_FAR=ComputePerformance(filename, style)
load(filename)
%GScore = GScore(1:28:end);
N = 50;
GAR = zeros(N,1);
FAR = zeros(N,1);
for i=1:N
    GAR(i) = sum(GScore>=i)/length(GScore)*100;
    FAR(i) = sum(IScore>=i)/length(IScore)*100;
end
GAR_FAR = [GAR FAR];

%plotyy(1:N,FAR, 1:N,GAR)

if 1==0
subplot(1,2,1);hold on
plot(1:N, GAR,style);
xlabel('N')
ylabel('GAR (%)')
subplot(1,2,2);hold on
plot(1:N,FAR,style);
xlabel('N')
ylabel('FAR (%)')
end