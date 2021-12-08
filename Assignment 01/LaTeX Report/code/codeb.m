T_b = 1;            % bit interval
h = 2;              % number of bits per symbol
T = h*T_b;          % symbol interval
binary_seq = [1 1 0 0 1 0 0 1 1 1 1 0 0 0 1 0];
num_of_Xks = length(binary_seq)/h;
resolution = 1000;  % number of data points for a smooth plot
t = linspace(0,T,resolution);

% genrating X_k s
X_ks = zeros(1,num_of_Xks);
k = 1;
for index = 1:h:length(binary_seq) %initVal:step:endVal
    if binary_seq(index) == 0 && binary_seq(index +1) == 0
        X_ks(k) = -3;
    elseif binary_seq(index) == 0 && binary_seq(index +1) == 1
        X_ks(k) = -1;
    elseif binary_seq(index) == 1 && binary_seq(index +1) == 1
        X_ks(k) = +1;
    elseif binary_seq(index) == 1 && binary_seq(index +1) == 0
        X_ks(k) = +3;
    end
    k = k +1;
end

phase = zeros(num_of_Xks, resolution);
for n = 0:(num_of_Xks-1)
    t = linspace(n*T, (n+1)*T, resolution);
    phase(n+1,:) = (pi/2)*sum(X_ks(1:n)) + (pi/2)*X_ks(n+1)*(t/T -n);
end
phase = reshape(phase',1,[]); % pre-processing for plotting
plot(linspace(0,num_of_Xks*T, length(phase)), phase, 'LineWidth',3);
grid on; xlabel('Time'); ylabel('Phase')
