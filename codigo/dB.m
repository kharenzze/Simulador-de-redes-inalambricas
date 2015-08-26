%Transforma una unidad lineal a decibelios
function [y] = dB(x)
y=10.*log10(x);
end