clear all 

num_cars = [31 30 40 20 33 20 12 45 36 72 89 83 64 73  78 84 95 74 68 85 59 74 69 74];

battery_cap3= zeros(1,24);
battery_timme = zeros(1,24);


b = 1;
for a = 1 : length(num_cars)
    for i = 1 : num_cars(a)
        battery_cap3(i) = normrnd(50,15);
    end
    battery_timme(b) = sum(battery_cap3);
    battery_cap3 = 0;
    b = b + 1;
end

plot(battery_timme)