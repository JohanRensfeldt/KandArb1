clear all 
data1 = readtable('20211015-20220405');
data2 = readmatrix('data2xcl.xlsx');
data1.Properties.VariableNames =  {'Date','kWh'};


var2 = data1{:,'kWh'};
var3 = data1{:,'Date'};
figre(1)
bar(var3,var2)


total_dag = zeros(1,round(height(data2)/24));
date = zeros(1,round((height(data2)/24)));

dygn = 1;
i = 0;
tot = 0;
for day = 1 : height(data2)/24
        for timme = 1 : 24
            tot = data2(timme + i,3) + tot;
        end
    total_dag(dygn) = tot;
    tot = 0;
    i = i + 24 ;
    dygn = dygn + 1 ;
end

figure(2)
bar(total_dag)

    