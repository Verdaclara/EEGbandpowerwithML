clc
clear all

% Cargar datos
mat1=load('Sz1.mat'); % Supongamos que tienes un archivo de datos llamado data.mat

datos_eeg=mat1.EEG;
fs=512;

% Visualización de nuestra señal Sz1.mat
%Separem
numMostres = length(datos_eeg);
duracio = numMostres/fs;
tMin = 1/fs;
tDelta = 1/fs;
tMax = numMostres/fs;
t = (tMin:tDelta:tMax)';
tDisplay = 2;
numSteps = 10*duracio/tDisplay;
figure(1)
plot(t,datos_eeg)
title('EEG'); xlabel('t(s)'); ylabel('(V)')
off=47*max(datos_eeg);
plot(t,datos_eeg+1.5*off,t,datos_eeg+1.3*off,t,datos_eeg+1.1*off) %CONTINUAR
axis tight

% Supongamos que datos_eeg es una matriz de dimensiones N x M, donde N es el número de muestras y M es el número de canales
[N, M] = size(datos_eeg);

% Por ejemplo, seleccionemos los primeros 20 canales
canales_seleccionados = datos_eeg(:, 1:20);
canales_seleccionados2 = datos_eeg(:, 20:40);

% Duración total de tus datos EEG en segundos
duracion_total_segundos = size(datos_eeg, 1) / fs; % fs es la frecuencia de muestreo

% Duración preictal y postictal
duracion_preictal_segundos = 180;  % 3 minutos antes de la convulsión
duracion_postictal_segundos = 180; % 3 minutos después de la convulsión

% Supongamos que tienes los índices de inicio y fin para cada fase
inicio_preictal = 1;
fin_preictal = duracion_preictal_segundos * fs; % Duración preictal en número de muestras

inicio_postictal = size(datos_eeg, 1) - duracion_postictal_segundos * fs + 1;
fin_postictal = size(datos_eeg, 1);

% Duración de la fase ictal (la duración restante)
duracion_ictal = duracion_total_segundos - duracion_preictal_segundos - duracion_postictal_segundos;

% Separar las señales en partes preictales, ictales y postictales
%preictal_data = datos_eeg(inicio_preictal:fin_preictal, :);
%ictal_data = datos_eeg(inicio_ictal:fin_ictal, :);
%postictal_data = datos_eeg(inicio_postictal:fin_postictal, :);

% Separar las señales en partes preictales, ictales y postictales
preictal_data = canales_seleccionados(inicio_preictal:fin_preictal, 1);
ictal_data = canales_seleccionados(fin_preictal + 2: fin_preictal + duracion_ictal * fs, 1);
postictal_data = canales_seleccionados(inicio_postictal:fin_postictal, 1);

% Crear vectores de tiempo para cada fase
t_preictal = (0:1/fs:(duracion_preictal_segundos - 1/fs))';
t_ictal = ((duracion_preictal_segundos + 1/fs):1/fs:(duracion_preictal_segundos + duracion_ictal - 1/fs))';
t_postictal = ((duracion_total_segundos - duracion_postictal_segundos):1/fs:(duracion_total_segundos - 1/fs))';

figure(2);

% Graficar los datos preictales
subplot(3,1,1);
plot(t_preictal, preictal_data, 'r'); % 'r' para color rojo
title('Segmento Preictal');
xlabel('Tiempo (s)'); % Ajustar la etiqueta de la unidad
ylabel('Amplitud (µV)'); % Ajustar la etiqueta de la unidad
ylim([-500, 500]); % Establecer límites en el eje y de -400 a 400 µV
axis tight

% Graficar los datos ictales
subplot(3,1,2);
plot(t_ictal, ictal_data, 'g'); % 'g' para color verde
title('Segmento Ictal');
xlabel('Tiempo (s)'); % Ajustar la etiqueta de la unidad
ylabel('Amplitud (µV)'); % Ajustar la etiqueta de la unidad
ylim([-500, 500]); % Establecer límites en el eje y de -400 a 400 µV
axis tight

% Graficar los datos postictales
subplot(3,1,3);
plot(t_postictal, postictal_data, 'b'); % 'b' para color azul
title('Segmento Postictal');
xlabel('Tiempo (s)'); % Ajustar la etiqueta de la unidad
ylabel('Amplitud (µV)'); % Ajustar la etiqueta de la unidad
ylim([-500, 500]); % Establecer límites en el eje y de -400 a 400 µV
axis tight
% Separar las señales en partes preictales, ictales y postictales
preictal_data2 = canales_seleccionados2(inicio_preictal:fin_preictal, 1);
ictal_data2 = canales_seleccionados2(fin_preictal + 2: fin_preictal + duracion_ictal * fs, 1);
postictal_data2 = canales_seleccionados2(inicio_postictal:fin_postictal, 1);

% Crear vectores de tiempo para cada fase
t_preictal = (0:1/fs:(duracion_preictal_segundos - 1/fs))';
t_ictal = ((duracion_preictal_segundos + 1/fs):1/fs:(duracion_preictal_segundos + duracion_ictal - 1/fs))';
t_postictal = ((duracion_total_segundos - duracion_postictal_segundos):1/fs:(duracion_total_segundos - 1/fs))';

% Cambiar el color de las líneas y ajustar las unidades de las etiquetas

figure(3);

% Graficar los datos preictales
subplot(3,1,1);
plot(t_preictal, preictal_data2, 'r'); % 'r' para color rojo
title('Segmento Preictal');
xlabel('Tiempo (s)'); % Ajustar la etiqueta de la unidad
ylabel('Amplitud (µV)'); % Ajustar la etiqueta de la unidad
ylim([-500, 500]); % Establecer límites en el eje y de -400 a 400 µV
axis tight
% Graficar los datos ictales
subplot(3,1,2);
plot(t_ictal, ictal_data2, 'g'); % 'g' para color verde
title('Segmento Ictal');
xlabel('Tiempo (s)'); % Ajustar la etiqueta de la unidad
ylabel('Amplitud (µV)'); % Ajustar la etiqueta de la unidad
ylim([-500, 500]); % Establecer límites en el eje y de -400 a 400 µV
axis tight
% Graficar los datos postictales
subplot(3,1,3);
plot(t_postictal, postictal_data2, 'b'); % 'b' para color azul
title('Segmento Postictal');
xlabel('Tiempo (s)'); % Ajustar la etiqueta de la unidad
ylabel('Amplitud (µV)'); % Ajustar la etiqueta de la unidad
ylim([-500, 500]); % Establecer límites en el eje y de -400 a 400 µV
axis tight
%% normalización

normEEG = detrend(canales_seleccionados, 'constant') / std(canales_seleccionados);
normEEG2 = detrend(canales_seleccionados2, 'constant') / std(canales_seleccionados2);

% Separar las señales en partes preictales, ictales y postictales
preictal_datanorm = normEEG(inicio_preictal:fin_preictal, 1);
ictal_datanorm = normEEG(fin_preictal + 2: fin_preictal + duracion_ictal * fs, 1);
postictal_datanorm = normEEG(inicio_postictal:fin_postictal, 1);

% Crear vectores de tiempo para cada fase
t_preictal = (0:1/fs:(duracion_preictal_segundos - 1/fs))';
t_ictal = ((duracion_preictal_segundos + 1/fs):1/fs:(duracion_preictal_segundos + duracion_ictal - 1/fs))';
t_postictal = ((duracion_total_segundos - duracion_postictal_segundos):1/fs:(duracion_total_segundos - 1/fs))';

% Graficar los datos preictales
figure(4);
subplot(3,1,1);
plot(t_preictal, preictal_datanorm);
title('Segmento Preictal');
xlabel('Tiempo (s)');
ylabel('Amplitud(µV)');
ylim([-3, 3]); % Establecer límites en el eje y de -400 a 400 µV
axis tight
% Graficar los datos ictales
subplot(3,1,2);
plot(t_ictal, ictal_datanorm);
title('Segmento Ictal');
xlabel('Tiempo (s)');
ylabel('Amplitud(µV)');
ylim([-3, 3]); % Establecer límites en el eje y de -400 a 400 µV
axis tight
% Graficar los datos postictales
subplot(3,1,3);
plot(t_postictal, postictal_datanorm);
title('Segmento Postictal');
xlabel('Tiempo (s)');
ylabel('Amplitud(µV)');
ylim([-3, 3]); % Establecer límites en el eje y de -400 a 400 µV
axis tight
% Separar las señales en partes preictales, ictales y postictales
preictal_datanorm2 = normEEG2(inicio_preictal:fin_preictal, 1);
ictal_datanorm2 = normEEG2(fin_preictal + 2: fin_preictal + duracion_ictal * fs, 1);
postictal_datanorm2 = normEEG2(inicio_postictal:fin_postictal, 1);

% Crear vectores de tiempo para cada fase
t_preictal = (0:1/fs:(duracion_preictal_segundos - 1/fs))';
t_ictal = ((duracion_preictal_segundos + 1/fs):1/fs:(duracion_preictal_segundos + duracion_ictal - 1/fs))';
t_postictal = ((duracion_total_segundos - duracion_postictal_segundos):1/fs:(duracion_total_segundos - 1/fs))';

% Graficar los datos preictales
figure(5);
subplot(3,1,1);
plot(t_preictal, preictal_datanorm2);
title('Segmento Preictal');
xlabel('Tiempo (s)');
ylabel('Amplitud(µV)');
ylim([-3, 3]); % Establecer límites en el eje y de -400 a 400 µV
axis tight

% Graficar los datos ictales
subplot(3,1,2);
plot(t_ictal, ictal_datanorm2);
title('Segmento Ictal');
xlabel('Tiempo (s)');
ylabel('Amplitud(µV)');
ylim([-3, 3]); % Establecer límites en el eje y de -400 a 400 µV
axis tight

% Graficar los datos postictales
subplot(3,1,3);
plot(t_postictal, postictal_datanorm2);
title('Segmento Postictal');
xlabel('Tiempo (s)');
ylabel('Amplitud(µV)');
ylim([-3, 3]); % Establecer límites en el eje y de -400 a 400 µV
axis tight
%% FILTRADO
% Frecuencia de corte del filtro Butterworth (en Hz)
fc = 30;  % Por ejemplo, 30 Hz

% Orden del filtro
orden = 4; % Por ejemplo, un filtro de cuarto orden

% Filtro Butterworth
[b, a] = butter(orden, fc / (fs / 2), 'low');

% Filtrar las señales normalizadas
preictal_datanorm_filtered = filtfilt(b, a, preictal_datanorm);
ictal_datanorm_filtered = filtfilt(b, a, ictal_datanorm);
postictal_datanorm_filtered = filtfilt(b, a, postictal_datanorm);

preictal_datanorm2_filtered = filtfilt(b, a, preictal_datanorm2);
ictal_datanorm2_filtered = filtfilt(b, a, ictal_datanorm2);
postictal_datanorm2_filtered = filtfilt(b, a, postictal_datanorm2);

% Crear vectores de tiempo para cada fase
t_preictal = (0:1/fs:(duracion_preictal_segundos - 1/fs))';
t_ictal = ((duracion_preictal_segundos + 1/fs):1/fs:(duracion_preictal_segundos + duracion_ictal - 1/fs))';
t_postictal = ((duracion_total_segundos - duracion_postictal_segundos):1/fs:(duracion_total_segundos - 1/fs))';

% Graficar los datos preictales
figure(6);
subplot(3,1,1);
plot(t_preictal, preictal_datanorm_filtered,'r');
title('Segmento Preictal - Señal Filtrada');
xlabel('Tiempo (s)');
ylabel('Amplitud(µV)');
ylim([-3, 3]); % Establecer límites en el eje y de -400 a 400 µV
axis tight

% Graficar los datos ictales
subplot(3,1,2);
plot(t_ictal, ictal_datanorm_filtered,'g');
title('Segmento Ictal - Señal Filtrada');
xlabel('Tiempo (s)');
ylabel('Amplitud(µV)');
ylim([-2, 2]); % Establecer límites en el eje y de -400 a 400 µV
axis tight

% Graficar los datos postictales
subplot(3,1,3);
plot(t_postictal, postictal_datanorm_filtered,'b');
title('Segmento Postictal - Señal Filtrada');
xlabel('Tiempo (s)');
ylabel('Amplitud(µV)');
ylim([-2, 2]); % Establecer límites en el eje y de -400 a 400 µV
axis tight


% Crear vectores de tiempo para cada fase (segunda serie)
t_preictal2 = (0:1/fs:(duracion_preictal_segundos - 1/fs))';
t_ictal2 = ((duracion_preictal_segundos + 1/fs):1/fs:(duracion_preictal_segundos + duracion_ictal - 1/fs))';
t_postictal2 = ((duracion_total_segundos - duracion_postictal_segundos):1/fs:(duracion_total_segundos - 1/fs))';

% Graficar los datos preictales (segunda serie)
figure(7);
subplot(3,1,1);
plot(t_preictal2, preictal_datanorm2_filtered,'r');
title('Segmento Preictal 2 - Señal Filtrada');
xlabel('Tiempo (s)');
ylabel('Amplitud(µV)');
ylim([-2, 2]); % Establecer límites en el eje y de -400 a 400 µV


% Graficar los datos ictales (segunda serie)
subplot(3,1,2);
plot(t_ictal2, ictal_datanorm2_filtered,'g');
title('Segmento Ictal 2 - Señal Filtrada');
xlabel('Tiempo (s)');
ylabel('Amplitud(µV)');
ylim([-2, 2]); % Establecer límites en el eje y de -400 a 400 µV
axis tight

% Graficar los datos postictales (segunda serie)
subplot(3,1,3);
plot(t_postictal2, postictal_datanorm2_filtered,'b');
title('Segmento Postictal 2 - Señal Filtrada');
xlabel('Tiempo (s)');
ylabel('Amplitud(µV)')
ylim([-2, 2]); % Establecer límites en el eje y de -400 a 400 µV
axis tight
%% SEGUNDA PARTE - Transformada de Fourier
fs = 512;

Npreictal1= size(preictal_datanorm_filtered,1);
tpreictal1 = (0:Npreictal1/2-1) / fs; % Vector de tiempo en segundos
%Frecuencia de muestreo (en Hz)
nfftpreictal1 = 2.^nextpow2(Npreictal1); % Número de puntos en la FFT
Ypreictal1 = fft(preictal_datanorm_filtered, nfftpreictal1); % Aplicar la transformada de Fourier

Nictal1= size(ictal_datanorm_filtered,1);
tictal1 = (0:Nictal1/2-1) / fs; % Vector de tiempo en segundos
 % Frecuencia de muestreo (en Hz)
nfftictal1 = 2.^nextpow2(Nictal1); % Número de puntos en la FFT
Yictal1 = fft(ictal_datanorm_filtered, nfftictal1); % Aplicar la transformada de Fourier

Npostictal1= size(postictal_datanorm_filtered,1);
tpostictal1 = (0:Npostictal1/2-1) / fs; % Vector de tiempo en segundos
 % Frecuencia de muestreo (en Hz)
nfftpostictal1 = 2.^nextpow2(Npostictal1); % Número de puntos en la FFT
Ypostictal1 = fft(postictal_datanorm_filtered, nfftpostictal1); % Aplicar la transformada de Fourier


% CANALES SELECCIONADOS 2
Npreictal2= size(preictal_datanorm2_filtered,1);
tpreictal2 = (0:Npreictal2/2-1) / fs; % Vector de tiempo en segundos
 % Frecuencia de muestreo (en Hz)
nfftpreictal2 = 2.^nextpow2(Npreictal2); % Número de puntos en la FFT
Ypreictal2 = fft(preictal_datanorm2_filtered, nfftpreictal2); % Aplicar la transformada de Fourier

Nictal2= size(ictal_datanorm2_filtered,1);
tictal2 = (0:Nictal2/2-1) / fs; % Vector de tiempo en segundos
 % Frecuencia de muestreo (en Hz)
nfftictal2 = 2.^nextpow2(Nictal2); % Número de puntos en la FFT
Yictal2 = fft(ictal_datanorm2_filtered, nfftictal2); % Aplicar la transformada de Fourier

Npostictal2= size(postictal_datanorm2_filtered,1);
tpostictal2 = (0:Npostictal2/2-1) / fs; % Vector de tiempo en segundos
 % Frecuencia de muestreo (en Hz)
nfftpostictal2 = 2.^nextpow2(Npostictal2); % Número de puntos en la FFT
Ypostictal2 = fft(postictal_datanorm2_filtered, nfftpostictal2); % Aplicar la transformada de Fourier

f1=(0:nfftpreictal1/2-1)*fs/nfftpreictal1;
f2=(0:nfftictal1/2-1)*fs/nfftictal1;
f3=(0:nfftpostictal1/2-1)*fs/nfftpostictal1;
% Graficar el espectro de frecuencia
figure(8);
subplot(3,1,1);
plot(f1, 2*abs(Ypreictal1(1:nfftpreictal1/2))); % Solo graficar la mitad positiva del espectro
title('Espectro de Frecuencia PreIctal');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud(µV^2)');

subplot(3,1,2);
plot(f2, 2*abs(Yictal1(1:nfftictal1/2))); % Solo graficar la mitad positiva del espectro
title('Espectro de Frecuencia Ictal');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud(µV^2)');

subplot(3,1,3);
plot(f3, 2*abs(Ypostictal1(1:nfftpostictal1/2))); % Solo graficar la mitad positiva del espectro
title('Espectro de Frecuencia Ictal');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud(µV^2)');

f11=(0:nfftpreictal2/2-1)*fs/nfftpreictal2;
f21=(0:nfftictal2/2-1)*fs/nfftictal2;
f31=(0:nfftpostictal2/2-1)*fs/nfftpostictal2;
% Graficar el espectro de frecuencia
figure(9);
subplot(3,1,1);
plot(f11, 2*abs(Ypreictal2(1:nfftpreictal2/2))); % Solo graficar la mitad positiva del espectro
title('Espectro de Frecuencia PreIctal');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud(µV^2)');

subplot(3,1,2);
plot(f21, 2*abs(Yictal2(1:nfftictal2/2))); % Solo graficar la mitad positiva del espectro
title('Espectro de Frecuencia Ictal');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud(µV^2)');

subplot(3,1,3);
plot(f31, 2*abs(Ypostictal2(1:nfftpostictal2/2))); % Solo graficar la mitad positiva del espectro
title('Espectro de Frecuencia Ictal');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud(µV^2)');

% Graficar el espectro de frecuencia de las señales preictales, ictales y postictales para ambos conjuntos de canales
figure(16);

% Graficar la FFT de las señales preictales del primer conjunto de canales
plot(f1, 2*abs(Ypreictal1(1:nfftpreictal1/2)), 'r'); % Canal 1, preictal
hold on;
plot(f2, 2*abs(Yictal1(1:nfftictal1/2)), 'g'); % Canal 1, ictal
plot(f3, 2*abs(Ypostictal1(1:nfftpostictal1/2)), 'b'); % Canal 1, postictal
plot(f11, 2*abs(Ypreictal2(1:nfftpreictal2/2)), 'r'); % Canal 2, preictal
plot(f21, 2*abs(Yictal2(1:nfftictal2/2)), 'g'); % Canal 2, ictal
plot(f31, 2*abs(Ypostictal2(1:nfftpostictal2/2)), 'b'); % Canal 2, postictal

% Ajustar los límites del eje X de 0 a 40 Hz
xlim([0 40]);


title('Espectro de Frecuencia en todas las fases');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud(µV^2)');
legend('Color rojo-PreIctal', 'Color verde-Ictal', 'Color azul-Postictal');
hold off;
%% 3. Calcula la potencia en cada banda de frecuencia
%f = fs/2*linspace(0,1,nfft/2+1); % Vector de frecuencias
%f = (0:nfft-1)*(fs/nfft);
delta_band = [0.5 4]; % Banda de frecuencias delta
theta_band = [4 8]; % Banda de frecuencias theta
alpha_band = [8 13]; % Banda de frecuencias alpha
beta_band = [13 30]; % Banda de frecuencias beta
gamma_band = [30 200/2]; % Banda de frecuencias gamma

% Calcula la potencia en cada banda de frecuencia
delta_powerpre = bandpower(Ypreictal1, fs, delta_band);
theta_powerpre = bandpower(Ypreictal1, fs, theta_band);
alpha_powerpre = bandpower(Ypreictal1, fs, alpha_band);
beta_powerpre = bandpower(Ypreictal1, fs, beta_band);
gamma_powerpre = bandpower(Ypreictal1, fs, gamma_band);

delta_power = bandpower(Yictal1, fs, delta_band);
theta_power = bandpower(Yictal1, fs, theta_band);
alpha_power = bandpower(Yictal1, fs, alpha_band);
beta_power = bandpower(Yictal1, fs, beta_band);
gamma_power = bandpower(Yictal1, fs, gamma_band);

delta_powerpost = bandpower(Ypostictal1, fs, delta_band);
theta_powerpost = bandpower(Ypostictal1, fs, theta_band);
alpha_powerpost = bandpower(Ypostictal1, fs, alpha_band);
beta_powerpost = bandpower(Ypostictal1, fs, beta_band);
gamma_powerpost = bandpower(Ypostictal1, fs, gamma_band);

% Calcula la potencia en cada banda de frecuencia
delta_powerpre2 = bandpower(Ypreictal2, fs, delta_band);
theta_powerpre2 = bandpower(Ypreictal2, fs, theta_band);
alpha_powerpre2 = bandpower(Ypreictal2, fs, alpha_band);
beta_powerpre2 = bandpower(Ypreictal2, fs, beta_band);
gamma_powerpre2 = bandpower(Ypreictal2, fs, gamma_band);

delta_power2 = bandpower(Yictal2, fs, delta_band);
theta_power2 = bandpower(Yictal2, fs, theta_band);
alpha_power2 = bandpower(Yictal2, fs, alpha_band);
beta_power2 = bandpower(Yictal2, fs, beta_band);
gamma_power2 = bandpower(Yictal2, fs, gamma_band);

delta_powerpost2 = bandpower(Ypostictal2, fs, delta_band);
theta_powerpost2 = bandpower(Ypostictal2, fs, theta_band);
alpha_powerpost2 = bandpower(Ypostictal2, fs, alpha_band);
beta_powerpost2 = bandpower(Ypostictal2, fs, beta_band);
gamma_powerpost2 = bandpower(Ypostictal2, fs, gamma_band);

% Define las etiquetas para las bandas de frecuencia
band_labels = {'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma'};
% Define los valores de potencia para cada banda de frecuencia
power_values1 = [delta_powerpre, theta_powerpre, alpha_powerpre, beta_powerpre, gamma_powerpre];
power_values2 = [delta_power, theta_power, alpha_power, beta_power, gamma_power];
power_values3 = [delta_powerpost, theta_powerpost, alpha_powerpost, beta_powerpost, gamma_powerpost];

power_values11 = [delta_powerpre2, theta_powerpre2, alpha_powerpre2, beta_powerpre2, gamma_powerpre2];
power_values21 = [delta_power2, theta_power2, alpha_power2, beta_power2, gamma_power2];
power_values31 = [delta_powerpost2, theta_powerpost2, alpha_powerpost2, beta_powerpost2, gamma_powerpost2];

% Graficar las potencias en las bandas de frecuencia
figure(10)
bar(power_values1);
title('Potencia en Bandas de Frecuencia PRE');
xlabel('Banda de Frecuencia');
ylabel('Potencia');
set(gca, 'xticklabel', band_labels);

figure(11);
bar(power_values2);
title('Potencia en Bandas de Frecuencia DURANTE');
xlabel('Banda de Frecuencia');
ylabel('Potencia');
set(gca, 'xticklabel', band_labels);

figure(12);
bar(power_values3);
title('Potencia en Bandas de Frecuencia POST');
xlabel('Banda de Frecuencia');
ylabel('Potencia');
set(gca, 'xticklabel', band_labels);

figure(13)
bar(power_values11);
title('Potencia en Bandas de Frecuencia PRE');
xlabel('Banda de Frecuencia');
ylabel('Potencia');
set(gca, 'xticklabel', band_labels);

figure(14);
bar(power_values21);
title('Potencia en Bandas de Frecuencia DURANTE');
xlabel('Banda de Frecuencia');
ylabel('Potencia');
set(gca, 'xticklabel', band_labels);

figure(15);
bar(power_values31);
title('Potencia en Bandas de Frecuencia POST');
xlabel('Banda de Frecuencia');
ylabel('Potencia');
set(gca, 'xticklabel', band_labels);

% Ahora delta_power, theta_power, alpha_power, beta_power, gamma_power contienen
% la potencia relativa en cada banda de frecuencia para cada canal de EEG.