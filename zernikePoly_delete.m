function zernikepoly = zernikePoly(n, m, x, y)

rho = (x^2 + y^2)^0.5;
theta = atan( y / x );

radialPoly = 0;

plusHalf = ( n + abs(m) ) / 2;
subtractHalf = ( n - abs(m) ) / 2;

for s = 0:subtractHalf
	numerator = (-1)^s * factorial(n-s) * rho^(n-2*s);
	denominator = factorial(s) * factorial( plusHalf - s ) * factorial( subtractHalf - s );
	radialPoly = radialPoly + numerator / denominator;
end

zernikepoly = radialPoly * exp(1i*m*theta);


