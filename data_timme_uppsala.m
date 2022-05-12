clear all
close all
data = readmatrix('ForbrukningsProfiler.xlsx');

tot_hours = length(data);

A_1 = zeros(24,713);

c = 1;
for b = 1 : tot_hours-1
    if c < tot_hours
        for a = 1 : 24
            A_1(a,b) = data(c,2);
            c = c + 1;
        end
    end
end

HOUR_SUM = zeros(24,1);
for j=1:24
    HOUR_SUM(j,1) = sum(A_1(j,:));
end

Hour_sum = abs(HOUR_SUM)./731;

figure(6)
plot(abs(HOUR_SUM)/731)
ylabel('El användning Wh')
xlabel('Tid på dygnet')
batteri = normrnd(50,15);


num_car = zeros(1,24);
num_car2 = zeros(1,24);
battery_cap = zeros(1,24);
battery_cap2 = zeros(1,24);
tot_energy = zeros(1,24);
energy_covered = zeros(24,731);

A_2 = zeros(24,713);







