clear total_dag 
clear all
close all 
tidsserie = 1 ; %input('input time series');
data2 = readmatrix('data2xcl.xlsx');
total_dag = zeros(1,round(height(data2)/(24*tidsserie)));
date = zeros(1,round((height(data2)/(24*tidsserie))));

A_ = zeros(24,700);

dygn = 1;
i = 0;
tot = 0;
for day = 1 : height(data2)/(24 * tidsserie)
        for timme = 1 : 24*tidsserie
            tot = data2(timme + i,3) + tot;
        end
    total_dag(dygn) = tot;
    tot = 0;
    i = i + (24*tidsserie) ;
    dygn = dygn + 1 ;
end

c = 1;

for b = 1 : 700-1
    for a = 1 : 24
        A_(a,b) = data2(c,3);
    c = c + 1;
    end
end

HOUR_SUM = zeros(24,1);
for j=1:24
    HOUR_SUM(j,1) = sum(A_(j,:));
end

%month_SUM = zeros(round(700/30),1);

% nedan är mitt försök att göra summa för varje månad
%%%%%%%%%%%%%%%%%%%%% = 
month_SUM = zeros(1,23);
d = 1;
e = 0;
for k= 1:round(700 / 30)
    for month = 1 : 30 
        tot = sum(A_(:,month + e)) + tot;
    end
    month_SUM(d) = tot;
    tot = 0;
    d = d + 1;
    e = e + 30;
end
%%%%%%%%%%%%%%%%%%%%%

t1 = datetime(2019,11,15,1,0,0);
t2 = datetime(2021,10,14,24,0,0);
t = t1:caldays(tidsserie):t2;
t_ = t1:caldays(31):t2;
%t_(24)=[];

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

HOUR_SUM1 = zeros(24,1);
for j=1:24
    HOUR_SUM1(j,1) = sum(A_1(j,:));
end

figure(6)
plot(abs(HOUR_SUM1)/731)
ylabel('Förbrukning Wh')
xlabel('Timme på dygnet')

figure(2)
bar(t,total_dag)
ylabel('Förbrukning Wh')
xlabel('Datum')

figure(3)
plot(t_,month_SUM)
ylabel('Förbrukning Wh')
xlabel('Datum')

figure
subplot(2,1,1)
plot(abs(HOUR_SUM1/731))
xlabel('Tid');
ylabel('Användning Uppsala');

subplot(2,1,2)
plot(HOUR_SUM/700)
xlabel('TID PÅ DYGNET');
ylabel('Användning Studenternas');