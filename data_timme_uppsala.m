clear all
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

%figure(6)
%plot(abs(HOUR_SUM)/731)

num_cars = [30 40 20 33 20 12 45 36 72 89 83 64 73  25 84 95 74 36 85 04 74 37 74 95 36 164];

for i = num_cars
    battery_cap3(i) = 
end



batteri = normrnd(50,15);


num_car = zeros(1,24);
num_car2 = zeros(1,24);
battery_cap = zeros(1,24);
battery_cap2 = zeros(1,24);
tot_energy = zeros(1,24);
energy_covered = zeros(24,731);

A_2 = zeros(24,713);

%for i = 1 : 24
%    num_car(i) = randi(200);
%    battery_cap(i) = normrnd(50,15) * num_car(i);
%end

for i = 1 : randi(200)
    battery_cap2(i) = normrnd(50,15);
end
n = 1;
for i = 1 : 731
    for h = 1 : 24
        num_car(i) = randi(200);
        battery_cap(i) = normrnd(50,15) * num_car(i);
        A_2(h,i) = normrnd(50,15) * cars;
        n = n + 1 ;
    end
end
%plot(tot_energy)





