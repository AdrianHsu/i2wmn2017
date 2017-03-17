% x = (10:1000:125010)';
% y = lognpdf(x,log(20000),1.0);
% 
% figure;
% plot(x,y);

sigma_db = 6; % ie. std_db
sigma = 10.^(sigma_db / 10);

T = 27;
bw = 10000000;
p_bs_dbm = 33;
gt_db = 14;
gr_db = 14;
h_bs = 51.5;
h_md = 1.5;
scale = 1000000;

pt = 10.^((p_bs_dbm - 30) / 10); %pt: transmit power
gt = 10.^(gt_db / 10); %gt: transmit antenna gain
gr = 10.^(gr_db / 10); %gr: receive antenna gain
ht = h_bs; %ht: transmit antenna height
hr = h_md; %hr: receive antenna height
d = 0.01:0.01:10000; %d: reference distance, the distance between the BS and the mobile device (in meter) as the x-axis.
pl = zeros(1,scale);
pr = zeros(1,scale);


