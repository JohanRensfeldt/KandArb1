function dis= discharge(cap,n)
    if n == 1
        dis = cap - 10;
    elseif n == 2
        dis = cap - 12;
    else
        dis = cap - 14;
    end
end
