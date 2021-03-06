T = 27;
bw = 10000000;
p_bs_dbm = 33;
gt_db = 14;
gr_db = 14;
h_bs = 51.5;
h_md = 1.5;
scale = 2000;

pt = 10.^((p_bs_dbm - 30) / 10); %pt: transmit power
gt = 10.^(gt_db / 10); %gt: transmit antenna gain
gr = 10.^(gr_db / 10); %gr: receive antenna gain
ht = h_bs; %ht: transmit antenna height
hr = h_md; %hr: receive antenna height
d = 1:1:scale; %d: reference distance, the distance between the BS and the mobile device (in meter) as the x-axis.
pl = zeros(1,scale);
pr = zeros(1,scale);
pl = (ht*hr)^2 * (1./d).^4; %pl: path loss
%pr: receive power, the received power of the mobile device (in dB) as the y-axis 
pr = pl * pt * gt * gr;
pr_db = 10*log10(pr);

%1-1
figure;
plot(d, pr_db);
xlabel('the distance (in meter) between the BS and the mobile device'); ylabel('the received power of the mobile device (in dB) ');
title('1-1, Modelling of two-ray ground reflection model');
h = legend('two-ray Model',1);

%1-2
% sinr: (signal power)/(interference power+noise power), SINR = S/(I+N)
k = 1.38 * 10^(-23); % Boltzmans constant
n = k * (T + 273.15) * bw; % Thermal noise power
inter = 0;
sinr = 10*log10( pr / (inter + n) );
figure;
plot(d, sinr);
xlabel('the distance (in meter) between the BS and the mobile device'); ylabel('SINR of the mobile device (in dB)');
title('1-2, Modelling of two-ray ground reflection model');
h = legend('two-ray Model',1);