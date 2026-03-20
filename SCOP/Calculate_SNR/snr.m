function my_snr = snr (D, D1)

% function x = snr (signal, noise)
% Calculates signal to noise ratio in dB for the given signal and noise vectors.
%
% Input:
%        signal = vactor of real numbers
%        noise = vector of
%
% Predrag Radivojac
% Indiana University
% Bloomington, IN 47408
% September 2009

my_snr = zeros(length(D),1);

for i = 1:length(D)
    
    signal = D{i};
    encoded = D1{i};
    
    %fprintf(1,'%d\t%d\t%d\n', i,length(signal), length(encoded));
    signal = signal(1:length(encoded));
    noise = signal-encoded;
  
    % the actual formula uses power of signal over the power of noise;
    % however we use energy as a more general case
    x = 10 * log10(sum(signal .^ 2) / sum(noise .^ 2));
    my_snr(i) = x;
end
return
