clear all
close all

data = readmatrix('2001410297_UPP735999100016201944_20220418-20220418A.xlsx');

t1 = datetime(2022,04,18,00,0,0);
t2 = datetime(2022,04,18,23,0,0);
time = t1:hours:t2;

battery_size_mean = [100 160 200];
battery_size_div = [15 20 25];
parking_size = [80 100 140];


tot = zeros(1,24);
diff = zeros(1,24);

for choice = 1 : 3
    A = zeros(parking_size(choice)/2,25);
    for i = 1 : parking_size(choice)  
        cap = normrnd(battery_size_mean(choice),battery_size_mean(choice));
        if cap > battery_size_mean(choice)/2 
            if i > parking_size(choice)/2
                for a = 18 : 22
                    cap = discharge(cap,choice);                
                    A(i,a) = cap; 
                end
            else
                for c = 13 : 17
                    cap = discharge(cap,choice);
                    A(i,c) = cap; 
                end
            end
        end
    end

    n = 1;
    for d = 1 : 24
        if sum(A(:,d)) == 0 && sum(A(:,d+1)) ~= 0
            tot(d) = sum(A(:,d)) - discharge(sum(A(:,d)),choice); 
            n = n + 1;
        elseif sum(A(1:parking_size(choice)/2,d+1)) == 0 && sum(A(:,d)) ~= 0
            tot(d) = sum(A(:,d)) - discharge(sum(A(:,d)),choice); 
            n = n + 1;
        %elseif A(parking_size/2,17) == 0 
         %   tot(d) = sum(A(:,17)) - discharge(sum(A(:,17)),choice);
        else
            tot(d) = sum(A(:,d)) - sum(A(:,d+1));
            n = n + 1;
        end
        if sum(A(:,d)) - sum(A(:,d+1)) == sum(A(:,d))
            tot(d) = sum(A(:,d));
            n = n + 1;
        end
    end

    diff = zeros(1,24);

    for c = 1 : 24
        if data(c) - tot(c) >= 0
            diff(c) = data(c) - tot(c);
        else
            diff(c) = data(c);
        end
    end
   
    %A = zeros(parking_size(choice)) ;
    figure(choice)
    %bar(tot)
    plot(time,data) 
    hold on
    %plot(time,tot,'r')
    %figure(2)
    plot(time,diff,'--')
    figure(choice + 3)
    bar(tot)
end

        

%bar(tot)
plot(time,data)
hold on
%plot(time,tot,'r')
%figure(2)
plot(time,diff,'--')