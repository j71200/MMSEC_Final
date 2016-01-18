clear('all');
clc

result = java.math.BigDecimal(1);
for ix = 1:300
    result = result.multiply(java.math.BigDecimal(ix));
end
disp(result)