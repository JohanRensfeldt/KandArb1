% Johan Rensfeldt kandidatarbete 2022 VT. koden är skriven för att simulera
% tillförsen av el till Studenternas IP under ett evenemang.

clear all
close all

data = readmatrix('2001410297_UPP735999100016201944_20220418-20220418A.xlsx');

% tidsserier för att kunna plotta föbrukningsdatan som en funktion av tid
%t1 = datetime(2022,01,18,00,0,0);
%t2 = datetime(2022,01,18,23,0,0);
%time = t1:hours:t2;
time = linspace(1,24,24);
% nedan defineras alla parametrar för som vi kommera att undersöka
% dom defineras i en vektor för att vi ska kunna iterera över dom i loopen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
battery_size_mean = [24 40 80];
battery_size_div = [12 15 20];
parking_size = [82 100 140];
fraction_electric = [0.28 0.50 0.65];
SOC_limit = [0.6 0.5 0.4];
% det här är för att en bil inte ska kunna komma in med precis tillräckligt
% för V2G och ladda ur en gång för att sedan ha alldeles för lite batteri
% den ska alltså ha minst så att den klarar en urladdning utan att hanmna
% under gränsen
discharge_diff = [8 12 16];
%%%%%%%%%%%%%%%%%%%%%%%%%%

% antalet iterationer som man vill att den ska köra för att sedan ta
% ett medelvärde av alla iterationer
number_of_runs = 100;

% deklarera de olika vektiorerna    
diff = zeros(24,3); % för att spara diffen mellan förbrukning och V2G
% kommer att ändras med varje iteration
tot = zeros(24,3); % för att spara den totala V2G

% nedan är för att spara differanserna för de olika totala differanserna
diff1 = zeros(24,number_of_runs);
diff2 = zeros(24,number_of_runs);
diff3 = zeros(24,number_of_runs);
procent = zeros(1,3);
differans = zeros(1,3);
diff_topplast = zeros(1,3);
% för att spara det totala medelvärdet
avg = zeros(24,3);


for lap = 1:number_of_runs % loopar över antalet iterationer som vi deklarerat
    waitbar(lap*(1/number_of_runs))
    for choice = 1 : 3 % loopar över alla olika scenarion
        % definerar A matrisen som ska spara alla värden, nollställs vid
        % varje iteration
        A = zeros(parking_size(choice)/2,25);
        % loopar till dubbla storleken på parkeringen efter som att vi
        % antar att den är full under båda matcherna
        for i = 1 : parking_size(choice) * 2
            % slumpar batterikapaciteten ur normalfördelningen
            cap = normrnd(battery_size_mean(choice),battery_size_div(choice));
            % Om kapaciteten är negativ så defineras den istället som
            % medelvärdet
            if cap < 0 
                cap = battery_size_mean(choice);
            end
            % minus urladdningen under en timme efter som att den annars
            % kan komma in och ladda ur en gång och sedan ha en kapacitet
            % under den lägsta tillåtna för urladdning
            if cap - discharge_diff(choice) > battery_size_mean(choice)* SOC_limit(choice) 
                if i > parking_size(choice)
                    for a = 17 : 21 % avser att det är timme 17 till 21 
                        if cap - discharge_diff(choice) > battery_size_mean(choice) * SOC_limit(choice) && data(a) > 300
                            cap = discharge(cap,choice,diff(a,choice),c);                
                            A(i,a) = cap;
                           
                        else % om den inte har tillräcklig kapacitet för att
                            % ladda ur efter en viss tids urladdning så
                            % ska den inte göra någonting
                            A(i,a) = cap;
                        end
                    end
                else
                    for c = 13 : 17 % timme 13 till 21
                        if cap - discharge_diff(choice) > battery_size_mean(choice) * SOC_limit(choice) && data(c) > 300
                            cap = discharge(cap,choice,diff(c,choice),c);
                            A(i,c) = cap;
                        else               
                            A(i,c) = cap; 
                        end
                    end
                end
            else
                if i > parking_size(choice) % här är det nästa match vilket
                    % är varför parkeringen börjar om från full igen
                    for a = 17 : 21
                        % nedan defineras laddningen vilket max kan ske
                        % tills 70 % av batteriets totala kapacitet
                        if cap < battery_size_mean(choice) * 0.7 
                            cap = charge(cap,choice);                
                            A(i,a) = cap; 
                        else
                            % om den har nått 70 % så står den bara där sen
                            A(i,a) = cap; 
                        end
                    end
                else
                    for c = 13 : 17
                        if cap < battery_size_mean(choice) * 0.7
                            cap = charge(cap,choice);
                            A(i,c) = cap;
                        else            
                            A(i,c) = cap; 
                        end
                    end
                end
            end
        end

   % nedan är för att summera hur mycket som har laddats ur batterierna
        for d = 1 : 17 % summerar den första matchen timmar 1 till 17
            % om man är på en kolumn
            % som har en kolumn som är noll innan så är diffen noll
            if sum(A(:,d)) == 0 && sum(A(:,d+1)) ~= 0 
                tot(d+1,choice) = 0 ;
                % om man är på en kolumn
                % som har en kolumn som är noll efter så är diffen noll
            elseif sum(A(1:parking_size(choice),d)) ~= 0 && sum(A(1:parking_size(choice),d+1)) == 0
                % här är det summan av den första matchens parkeringar
                tot(d+1,choice) = 0 ; 
            else
                % annars så tar vi differansen mellan den nuvarande
                % nollskillda kolumnen och nästa nollskillda kolumn
                tot(d+1,choice) = sum(A(1:parking_size(choice),d)) - sum(A(1:parking_size(choice),d+1));          
            end
        end
% samma fast för match två med skillnaden att det är summan av den andra
% matchen som räknas
        for d = 18 : 24
            if sum(A(:,d)) == 0 && sum(A(:,d+1)) ~= 0
                tot(d+1,choice) = 0 ;        
            elseif sum(A(parking_size(choice):parking_size(choice)*2,d)) ~= 0 && sum(A(parking_size(choice):parking_size(choice)*2,d+1)) == 0
                tot(d+1,choice) = 0 ;
            else
                tot(d+1,choice) = sum(A(parking_size(choice):parking_size(choice)*2,d)) - sum(A(parking_size(choice):parking_size(choice)*2,d+1));           
            end
        end
%%%%%%%%%%%%%%%%%%%%%
        tot(18,choice) = mean(tot(14:21,choice)) + 100; % rad 17 blir ett problem men 
        %löses här genom att den helt enkelt är lika med medelvärdet av tot

% nedan är för att räkna ut differansen mellan tillförd och förbrukad el
% för dygnets alla timmar
        for c = 1 : 24
% om tillförseln är större än förbrukningen så är förbrukningen och diffen lika med 
% noll vi kan inte tillföra mer än vad som görs av med totalen kan inte vara negativ
            if data(c) > tot(c,choice) && tot(c,choice) ~= 0 % förbrukning större än tillförsel
                diff(c,choice) = data(c) - tot(c,choice);
            elseif tot(c,choice) == 0 % om tillförseln är noll är totalen oförändrad
                diff(c,choice) = data(c);
            elseif data(c) < tot(c,choice) && tot(c,choice) ~= 0 % förbrukning mindre än tillförsel
                diff(c,choice) = 0 ;
            else 
                diff(c,choice) = data(c);
            end
        end       
    end
%%%%%%%%%%%%%%
% nedan är för att räkna ihopp diffen för den här iterationen vilket kommer
% att vara en matris med 24 rader och tot iterationer kolumner
    for a = 1 : 24
        diff1(a,lap) = diff(a,1);
        diff2(a,lap) = diff(a,2);
        diff3(a,lap) = diff(a,3);
    end
%%%%%%%%%%%%%%    
end

% nedan räknar ut medelvärdet av alla iterationer som summan av en rad för
% alla kolumner vilket ger summan av en given timme för att körningar delat
% på det totala antalet körningar
for d = 1 : 24
    avg(d,1) = sum(diff1(d,:))/number_of_runs;
    avg(d,2) = sum(diff2(d,:))/number_of_runs;
    avg(d,3) = sum(diff3(d,:))/number_of_runs;
end
%%%%%%%%%%%%%%

% nedan är föra att plotta resultatet i tre enskillda grafer
for i  = 1:3
    figure(i)
    plot(time,data)
    hold on 
    plot(time,avg(:,i),'--')
    ylabel('kWh')
    xlabel('Tid på dygnet')
    legend('Förbrukning','Differans','Location','northwest')
end
hold off

% nedan plottar resultatet som stapeldiagram



for i  = 1:3
    %diff(1:13,i) = 0;
    %diff(21:24,i) = 0;
    figure(i+3)
    bar(time,data)
    hold on 
    bar(time,-tot(2:end,i))
    ylabel('kWh')
    xlabel('Tid på dygnet')
    legend('Förbrukning','Flöde V2G','Location','northwest')
end

for i = 1 : 3
    procent(i) = ((sum(data)/sum(avg(:,i)))-1) * 100;
    differans(i) = sum(data) - sum(avg(:,i));
    diff_topplast(i) = 100 - (max(data)\max(avg(:,i))) * 100;
    disp(differans(i))
    disp(diff_topplast(i))
    disp(procent(i))
end