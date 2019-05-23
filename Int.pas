type
func = function(x: real): real;

var
x1, x2, x3, sum: real;
{$F+}
function f1(x: real): real;begin f1 := exp(-x) + 3 end;

function f2(x: real): real;begin f2 := 2 * x - 2 end;

function f3(x: real): real;begin f3 := 1 / x end;

function f4(x: real): real;begin f4 := Power(x, 4) - 16 end;

function f5(x: real): real;begin f5 := 0 end;

function f6(x: real): real;begin f6 := x end;

function f7(x: real): real;begin f7 := exp(-x) + 3 - 1 / x end;

function f8(x: real): real;begin f8 := exp(-x) + 3 - 2 * x + 2 end;
{$F-}
procedure root(f, g: func; a, b, eps1: real; var x: real);
var
c: real;
begin
while (b - a) >= eps1 do
begin
c := (b + a) / 2;
if (f(a) - g(a)) * (f(c) - g(c)) < 0 then b := c
else a := c;
end;
x := (a + b) / 2;
end;

function integral(f: Func; a, b, eps2: real): real;
var
h: real; n, j: integer;

function I(n: integer): real;
var
s, h: real;j: integer;
begin
h := (b - a) / n;
s := 0;
for j := 0 to n - 1 do
s := s + h * f(a + (j + 0.5) * h);
I := s;
end;

begin
n := 20;
while (1 / 3) * abs(I(n) - I(2 * n)) >= eps2 do n := n * 2;
integral := I(n * 2);
end;

begin
root(f4, f5, 1.7, 2.4, 0.0001, x1);
writeln('Test root ', x1:5:10);
writeln('Test integral ', integral(f6, 0, 2, 0.001):5:10);
root(f3, f1, 0, 2, 0.0001, x1); //begin
writeln('Crossing point 1 ', x1:5:10);
root(f3, f2, 0, 2, 0.0001, x2);
writeln('Crossing point 2 ', x2:5:10);
root(f2, f1, 2, 4, 0.0001, x3);
writeln('Crossing point 3 ', x3:5:10);
sum := integral(f7, x1, x2, 0.0001) + integral(f8, x2, x3, 0.0001);
writeln('Sum ', sum:5:10);
Writeln
end.