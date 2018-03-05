%%Ganesh
%%Basics of Signals 
clc; 
clear; 
close all; 
a=1;
b=1;
t = -2:0.01:2;
x1 = sin(1*pi*t);
n = -2:0.1:2;
x2 = sin(1*pi*n); 
unitstep = t>=0;
impulse= t==0;
ramp = t.*unitstep;
quad = t.^2.*unitstep;
ed = exp(-a*t);
er = exp(b*t);
xt = tripuls(t,20);
xr = rectpuls(t,2);
xs = sin(1*pi*t); 
xc = cos(1*pi*t); 
ers = exp(b*t).*sin(6*pi*t);
eds = exp(-b*t).*sin(6*pi*t);
figure(1)
subplot(3,2,1)
plot(t,x1,'r');
xlabel('t in sec');
ylabel('x(t)');
grid on;
title('Continious Signal sin(\pi t)');
subplot(3,2,2)
Hs = stem(n,x2,'r','filled');
set(Hs,'markersize',2);
xlabel('n'); ylabel('x(n)');
grid on;
title('Discrete Signal sin(\pi n)');
subplot(3,2,3)
plot(t,unitstep,'r');
xlabel('t in sec');
ylabel('x(t)');
grid on;
title('Unit Step Signal');
subplot(3,2,4)
plot(t,impulse,'r');
xlabel('t in sec');
ylabel('x(t)');
grid on;
title('Impulse Signal');
subplot(3,2,5)
plot(t,ramp,'r');
xlabel('t in sec');
ylabel('x(t)');
grid on;
title('Ramp Signal');

subplot(3,2,6)
plot(t,quad,'r');
xlabel('t in sec');
ylabel('x(t)');
grid on;
title('Parabolic Signal');

figure(2)
subplot(3,2,1)
plot(t,ed,'r');
xlabel('t in sec');
ylabel('x(t)');
grid on;
title('Exponentially Decaying Signal');

subplot(3,2,2)
plot(t,er,'r');
xlabel('t in sec');
ylabel('x(t)');
grid on;
title('Exponentially Rising Signal');

subplot(3,2,3)
plot(t,xt,'r');
xlabel('t in sec');
ylabel('x(t)');
grid on;
title('Triangular Pulse Signal');

subplot(3,2,4)
plot(t,xr,'r');
xlabel('t in sec');
ylabel('x(t)');
grid on;
title('Rectangular Pulse Signal');

subplot(3,2,5)
plot(t,xs,'r');
xlabel('t in sec');
ylabel('x(t)');
grid on;
title('Sinusoidal Signal sin(\pi t)');
subplot(3,2,6)
plot(t,xc,'r');
xlabel('t in sec');
ylabel('x(t)');
grid on;
title('Cosinusoidal Signal cos(\pi t)');

figure(3)
subplot(3,2,1)
plot(t,ers,'r');
xlabel('t in sec');
ylabel('x(t)');
grid on;
title('Exponentially Rising Sinusoidal Signal');

subplot(3,2,2)
plot(t,eds,'r');
xlabel('t in sec');
ylabel('x(t)');
grid on;
title('Exponentially Decaying Sinusoidal Signal');
