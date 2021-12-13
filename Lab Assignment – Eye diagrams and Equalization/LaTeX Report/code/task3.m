bit_seq_len = 10^4; % number of bits 
SNR_list = [0:10];  % snr from 0 to 10

for x1 = 1:length(SNR_list)

   % Transmitter
   bit_seq = randi([0 1],1 ,bit_seq_len);   % random bit sequence
   symbol= 2*bit_seq-1;                     %0 to -1 and 1 to 1
   h= [0.2 0.9 0.3];                        % channel response
   c_out = conv(symbol,h);  
   Eb=1;
   No=Eb/(10^(SNR_list(x1)/10));
   AWGN=No*randn(1,max(size(c_out)));
   
   % Noise addition
   y = c_out + AWGN; % additive white gaussian noise
   yAWGN=symbol+AWGN(1:bit_seq_len);%sybols + noise (no channel response)
   for x2 = 1:4
       hMat = toeplitz([h([2:end]) zeros(1,2*x2+1-length(h)+1)],...
           [ h([2:-1:1]) zeros(1,2*x2+1-length(h)+1) ]);
       b  = zeros(1,2*x2+1);
         
       b(x2+1) = 1;
       c  = [inv(hMat)*b.'].';% coefficient set
       yFilt = conv(y,c);
       yFilt = yFilt(x2+2:end);
       ySamp = yFilt(1:1:bit_seq_len); 
       size(ySamp);
    
       %decoding and calculating the number of errors
       ipHat = ySamp>0;
       yAWGN= yAWGN>0;
       nAWGN(1,x1)=size(find([bit_seq- yAWGN]),2);
       nErr(x2,x1) = size(find([bit_seq- ipHat]),2);
   end
end

simBer = nErr/bit_seq_len; % Bit error rate

% plot
figure; 
semilogy(SNR_list,simBer(1,:),'bs-'); hold on;
semilogy(SNR_list,simBer(2,:),'gd-');
semilogy(SNR_list,simBer(3,:),'ks-');
semilogy(SNR_list,simBer(4,:),'mx-');
semilogy(SNR_list,nAWGN/bit_seq_len,'r*-');
axis([0 10 10^-3 0.5]); grid on;
legend('3tap', '5tap','7tap','9tap','AWGN');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title('Bit error probability curve for BPSK in ISI with ZF equalizers');