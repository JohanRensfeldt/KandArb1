function dis= discharge(cap,n,diff,c)
if n > 1
    if diff < 150 
        dis = cap - 1;
    else
        if n == 1
            dis = cap - 7;
        elseif n == 2
            dis = cap - 10;
        else
            dis = cap - 11;
        end
    end
elseif n == 1
    if c == 16
        dis = cap - 4;
    else
        if n == 1
            dis = cap - 7;
        elseif n == 2
            dis = cap - 10;
        else
            dis = cap - 11;
        end
    end
else
    if n == 1
        dis = cap - 7;
    elseif n == 2
        dis = cap - 10;
    else
        dis = cap - 11;
    end
end

