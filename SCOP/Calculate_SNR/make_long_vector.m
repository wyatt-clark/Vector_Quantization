function LV = make_long_vector(D)


lv_length = 0;

for i = 1:length(D)
    lv_length = lv_length + length(D{i});
end

%LV is Long Vector
LV = zeros(1, lv_length);

start = 1;
for i = 1:length(D)
    stop = start + length(D{i}) - 1;
    LV(start:stop) = D{i};
    start = stop +1;
end