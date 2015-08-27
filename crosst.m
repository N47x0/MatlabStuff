function wc = crosst(mag, w)

wc_res = [];
wc_exact = 10e-10;
for (i=2:numel(w))
    if (sign(mag(i)) ~= sign(mag(i-1)))
        wc_res = [wc_res w(i-1)+(w(i)-w(i-1))*(mag(i-1))/abs(mag(i)-mag(i-1))];
        break;
    end
    if (mag(i) == 0)
        wc_exact = w(i);
        break;
    end
end

if (wc_exact ~= 10e-10)
    res = wc_exact;
else
    res = max(wc_res);
end
wc = res;