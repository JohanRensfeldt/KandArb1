function dis= discharge(cap,n)
    if n == 1
        dis = cap - 5;
    elseif n == 2
        dis = cap - 10;
    else
        dis = cap - 15;
    end
end
