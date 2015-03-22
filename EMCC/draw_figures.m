%02DB1 m=128
figure
ComputePerformance('Scores/MatchScore_02DB1_(128,30).mat','-ro');
ComputePerformance('Scores/MatchScore_02DB1_(128,40).mat','-g*');
ComputePerformance('Scores/MatchScore_02DB1_(128,50).mat','-bs');
subplot(1,2,1);
legend('m=128,n=30','m=128,n=40','m=128,n=50')
title('FVC2002 DB1')
subplot(1,2,2);
legend('m=128,n=30','m=128,n=40','m=128,n=50')
title('FVC2002 DB1')

%02DB1 m=256
figure
ComputePerformance('Scores/MatchScore_02DB1_(256,60).mat','-ro');
ComputePerformance('Scores/MatchScore_02DB1_(256,80).mat','-g*');
ComputePerformance('Scores/MatchScore_02DB1_(256,100).mat','-bs');
subplot(1,2,1);
legend('m=256,n=60','m=256,n=80','m=256,n=100')
title('FVC2002 DB1')
subplot(1,2,2);
legend('m=256,n=60','m=256,n=80','m=256,n=100')
title('FVC2002 DB1')

%02DB2 m=128
figure
ComputePerformance('Scores/MatchScore_02DB2_(128,30).mat','-ro');
ComputePerformance('Scores/MatchScore_02DB2_(128,40).mat','-g*');
ComputePerformance('Scores/MatchScore_02DB2_(128,50).mat','-bs');
subplot(1,2,1);
legend('m=128,n=30','m=128,n=40','m=128,n=50')
title('FVC2002 DB2')
subplot(1,2,2);
legend('m=128,n=30','m=128,n=40','m=128,n=50')
title('FVC2002 DB2')

%02DB2 m=256
figure
ComputePerformance('Scores/MatchScore_02DB2_(256,60).mat','-ro');
ComputePerformance('Scores/MatchScore_02DB2_(256,80).mat','-g*');
ComputePerformance('Scores/MatchScore_02DB2_(256,100).mat','-bs');
subplot(1,2,1);
title('FVC2002 DB2')
legend('m=256,n=60','m=256,n=80','m=256,n=100')
subplot(1,2,2);
legend('m=256,n=60','m=256,n=80','m=256,n=100')
title('FVC2002 DB2')

%04DB1 m=128
figure
ComputePerformance('Scores/MatchScore_04DB1_(128,30).mat','-ro');
ComputePerformance('Scores/MatchScore_04DB1_(128,40).mat','-g*');
ComputePerformance('Scores/MatchScore_04DB1_(128,50).mat','-bs');
subplot(1,2,1);
legend('m=128,n=30','m=128,n=40','m=128,n=50')
title('FVC2004 DB1')
subplot(1,2,2);
legend('m=128,n=30','m=128,n=40','m=128,n=50')
title('FVC2004 DB1')

%04DB1 m=256
figure
ComputePerformance('Scores/MatchScore_04DB1_(256,60).mat','-ro');
ComputePerformance('Scores/MatchScore_04DB1_(256,80).mat','-g*');
ComputePerformance('Scores/MatchScore_04DB1_(256,100).mat','-bs');
subplot(1,2,1);
legend('m=256,n=60','m=256,n=80','m=256,n=100')
title('FVC2004 DB1')
subplot(1,2,2);
legend('m=256,n=60','m=256,n=80','m=256,n=100')
title('FVC2004 DB1')
