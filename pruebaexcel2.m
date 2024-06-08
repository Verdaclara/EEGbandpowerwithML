clear all
clc

d = dir('*');

% Inicializar matrices para almacenar las ondas delta de cada fase y canal
delta_preictal = cell(1, 40);
delta_ictal = cell(1, 40);
delta_postictal = cell(1, 40);

for i = 1:length(d)
    na = d(i).name;
    TF = startsWith(na, 'Sz4');
    if TF == 1
        % Cargar datos EEG
        mat1 = load(na);
        datos_eeg = mat1.EEG;
        fs = 512;

        % Duración total de tus datos EEG en segundos
        duracion_total_segundos = size(datos_eeg, 1) / fs; % fs es la frecuencia de muestreo

        % Definir las duraciones de las fases preictal, ictal y postictal
        duracion_preictal_segundos = 180;  % 3 minutos antes de la convulsión
        duracion_postictal_segundos = 180; % 3 minutos después de la convulsión

        % Duración de la fase ictal (la duración restante)
        duracion_ictal_segundos = duracion_total_segundos - duracion_preictal_segundos - duracion_postictal_segundos;

        % Supongamos que tienes los índices de inicio y fin para cada fase
        inicio_preictal = 1;
        fin_preictal = duracion_preictal_segundos * fs; % Duración preictal en número de muestras

        inicio_postictal = size(datos_eeg, 1) - duracion_postictal_segundos * fs + 1;
        fin_postictal = size(datos_eeg, 1);

        % Calcular los índices de inicio y fin para cada fase
        inicio_ictal = fin_preictal + 1;
        fin_ictal = inicio_ictal + duracion_ictal_segundos * fs;

        % Crear vectores de tiempo para cada fase
        t_preictal = (0:1/fs:(duracion_preictal_segundos - 1/fs))';
        t_ictal = ((duracion_preictal_segundos + 1/fs):1/fs:(duracion_preictal_segundos + duracion_ictal_segundos - 1/fs))';
        t_postictal = ((duracion_total_segundos - duracion_postictal_segundos):1/fs:(duracion_total_segundos - 1/fs))';

        % Seleccionar los canales de interés
        for j = 1:40
            canal = datos_eeg(:, j);
            normEEG = detrend(canal, 'constant') / std(canal);

            % Separar las señales en partes preictales, ictales y postictales
            preictal_data = normEEG(inicio_preictal:fin_preictal);
            ictal_data = normEEG(fin_preictal + 1: fin_ictal);
            postictal_data = normEEG(inicio_postictal:fin_postictal);
            
            %Definir las frecuencias de corte de los filtros
            frecuencia_corte_bajo = 30; % Hz
            frecuencia_corte_alto = 0.5; % Hz

            % Orden del filtro
            orden = 4; % Puedes ajustar este valor según tus necesidades

            % Filtro pasa bajo
            [b_low, a_low] = butter(orden, frecuencia_corte_bajo / (fs / 2), 'low');

            % Filtro pasa alto
            [b_high, a_high] = butter(orden, frecuencia_corte_alto / (fs / 2), 'high');

            % Aplicar el filtro pasa bajo a cada canal
            canales_filtrados_lowpre = filtfilt(b_low, a_low, preictal_data);
            canales_filtrados_lowdur = filtfilt(b_low, a_low, ictal_data);
            canales_filtrados_lowpost = filtfilt(b_low, a_low, postictal_data);

            % Aplicar el filtro pasa alto a cada canal
            canales_filtrados_highpre = filtfilt(b_high, a_high, preictal_data);
            canales_filtrados_highdur = filtfilt(b_high, a_high,ictal_data);
            canales_filtrados_highpost = filtfilt(b_high, a_high, postictal_data);

            % Banda de frecuencias delta
            delta_band = [0.5 4]; % Hz

            % Calcular la potencia de la banda delta para cada fase
            delta_power_preictal_low = bandpower(canales_filtrados_lowpre, fs, delta_band);
            delta_power_preictal_high = bandpower(canales_filtrados_highpre, fs, delta_band);
            delta_power_ictal_low = bandpower(canales_filtrados_lowdur, fs, delta_band);
            delta_power_ictal_high = bandpower(canales_filtrados_highdur, fs, delta_band);
            delta_power_postictal_low = bandpower(canales_filtrados_lowpost, fs, delta_band);
            delta_power_postictal_high = bandpower(canales_filtrados_highpost, fs, delta_band);

            % Combinar las potencias de la banda delta de las señales filtradas
            delta_power_preictal = delta_power_preictal_low + delta_power_preictal_high;
            delta_power_ictal = delta_power_ictal_low + delta_power_ictal_high;
            delta_power_postictal = delta_power_postictal_low + delta_power_postictal_high;

            % Agregar los valores de delta a las matrices correspondientes
            delta_preictal{j} = [delta_preictal{j}, delta_power_preictal];
            delta_ictal{j} = [delta_ictal{j}, delta_power_ictal];
            delta_postictal{j} = [delta_postictal{j}, delta_power_postictal];
        end

        disp(['Processed file: ', na]);
    else
        disp('File does not match with any patient');
    end
end

% Convertir las celdas a matrices y luego transponerlas para obtener filas de valores
delta_preictal_row = cell2mat(delta_preictal)';
delta_ictal_row = cell2mat(delta_ictal)';
delta_postictal_row = cell2mat(delta_postictal)';

% Ahora puedes exportar estas filas de valores a un archivo de Excel o hacer cualquier otra operación que desees
% Exportar las matrices de ondas delta a archivos de Excel
xlswrite('delta_preictal.xlsx', delta_preictal_row);
xlswrite('delta_ictal.xlsx', delta_ictal_row);
xlswrite('delta_postictal.xlsx', delta_postictal_row);

disp('Data exported to delta_preictal.xlsx, delta_ictal.xlsx, and delta_postictal.xlsx');