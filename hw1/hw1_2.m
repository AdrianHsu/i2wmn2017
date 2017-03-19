T = 27;
bw = 10000000;
p_bs_dbm = 33;
gt_db = 14;
gr_db = 14;
h_bs = 51.5;
h_md = 1.5;
scale = 2000;
std_db = 6;

pt = 10.^((p_bs_dbm - 30) / 10); %pt: transmit power
gt = 10.^(gt_db / 10); %gt: transmit antenna gain
gr = 10.^(gr_db / 10); %gr: receive antenna gain
ht = h_bs; %ht: transmit antenna height
hr = h_md; %hr: receive antenna height
d = 1:1:scale; %d: reference distance, the distance between the BS and the mobile device (in meter) as the x-axis.
pl = (ht*hr)^2 * (1./d).^4; %pl: path loss
pl_db = 10*log10(pl);

s_norm = normrnd(0,std_db,1,scale); % normrnd(mu,sigma,m,n)
%pr: receive power, the received power of the mobile device (in dB) as the y-axis 
pr_db = (p_bs_dbm - 30) + gt_db + gr_db + pl_db + s_norm;

%2-1
plot(d, pr_db);
xlabel('the distance (in meter) between the BS and the mobile device'); ylabel('the received power of the mobile device (in dB)');
title('2-1, Modelling of two-ray ground reflection model'); 
h = legend('two-ray Model',1);

%2-2
% sinr: (signal power)/(interference power+noise power), SINR = S/(I+N)
k = 1.38 * 10^(-23); % Boltzmans constant
n = k * (T + 273.13) * bw; % Thermal noise power
pr = 10.^(pr_db / 10);
inter = 0;
sinr = 10*log10( pr / (inter + n) );

figure;
plot(d, sinr);
xlabel('the distance (in meter) between the BS and the mobile device'); ylabel('SINR of the mobile device (in dB)');
title('2-2, Modelling of two-ray ground reflection model');
h = legend('two-ray Model',1);