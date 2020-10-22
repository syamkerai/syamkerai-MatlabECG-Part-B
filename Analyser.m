fileName = 'analogData.mat';
Sec = 2;
 load(fileName);
 Loaded = load(fileName);
 fname = fieldnames(Loaded);
 x = eval(fname{1});
 % x = repmat(x(451:550),10,1);
 figure(1) 
 subplot(2,1,1) 
 t = linspace(0,Sec,length(x));
 plot(t,x,'b-') 
 title('Time domain');
 xlabel('Time');
 ylabel('Voltage');
L = length(x);
X = fft(x);
 X = X(1:L/4);
  % considering 1/4 length of X only;
 mx = abs(X);
   % Take the magnitude of fft of x 
   subplot(2,1,2);
 t2=0:1:length(X)-1;
 tt = t2/Sec;
 plot(tt,mx,'r-');
 ylim([0,10]);
 title('Frequency domain');
 xlabel('Frequency (Hz)');
 ylabel('Magnitude');

 [b, a] = butter(4, 0.12,'low');   fvtool(b,a);





plot(Data_filtered);