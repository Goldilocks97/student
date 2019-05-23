const
  n = 30;
{------------------------Раздел описания типов-------------------------------------------}
type
  func = function(x: word): word;
  
  m = record 
    x: word;y: real end;
  
  mas = array [1..n] of m;
{-------------------------Раздел описания переменных------------------------------------------} 
var
  
  mass: mas; 
  max_iters, preserved_high_positions, preserved_low_positions, select, i: integer;
  variability: real;
{Выполнение алгоритмом априорно заданного числа итераций max_iters}
{Выполнение алгоритмом априорно заданного числа итераций без улучшения качества по-пуляции при заданном quality_epsilon }
{Достижение некоторого априорно заданного значения целевой функции enough_function_value}
{-----------------------------------Сама функция---------------------------------} 

function f(x: real): real;
begin
  f := (x - 3) * (x - 2) * (x - 0.001) * (x - 0.001) * (x - 0.001) * (x - 0.001) * (x - 3.99) * (x - 3.99) * (x - 3.99) * (x - 3.99) * (1 - exp(x - 1.5)) * sin(x / 3 + 0.2); 
end;

{------------------------Генерация первой популяции--------------------------------------------}
procedure firstpop(var mass: mas);
begin
  for var i := 1 to n do mass[i].x := random(65537);
end;
{------------------------вычисление значения функции и сортировка-------------------------------}
procedure sorting(var mass: mas);
var
  z: m;
begin
  for var i := 1 to n do mass[i].y := f((mass[i].x) / 16384); 
  for var i := 1 to n - 1 do 
  begin
    for var j := i + 1 to n do 
    begin
      if mass[j].y > mass[i].y then 
      begin
        z := mass[j];
        mass[j] := mass[i]; 
        mass[i] := z; 
      end;
    end;
  end;
end;
{---------------------------Проверка условия остановки------------------------------------------} 
function finish(var mass: mas; n: integer): boolean;
begin
  finish := (n >= max_iters)
end;
{------------------------------------Cелекция---------------------------------------------------}
procedure selection(var mass: mas);
var
  q: integer;
begin
  select := random(1, n - preserved_high_positions - preserved_low_positions) + 8; 
  for var i := 1 to select do 
  begin
    q := (random(preserved_high_positions + 1, n - preserved_low_positions));
    mass[q].x := 0; 
    mass[q].y := 0;
  end; 
end;
{------------------------------------Скрещивание--------------------------------------------------}
                                     {Одноточечное}
procedure single_point(var mass: mas);
var
  a1, a2: word;
  bit: integer;
  procedure SwapBits(var a, b: Word; n: integer);
  var
    m, t: Word;
  begin
    m := 1 shl n - 1;t := a;
    a := a and not m or b and m;
    b := b and not m or t and m;
  end;

begin
  for var i := 1 to select do 
  begin
    a1 := mass[random(1, preserved_high_positions)].x;
    a2 := mass[random(n - preserved_low_positions, n)].x; 
    bit := random(1, 16); 
    SwapBits(a1, a2, bit); 
    mass[random(preserved_high_positions, n - preserved_low_positions)].x := a1;
    mass[random(preserved_high_positions, n - preserved_low_positions)].x := a2;
  end; 
end;

{------------------------------------------Мутация----------------------------------------------------------}

{изменение случайно выбраного бита}

procedure change_bit(var mass: mas);
var
  a: integer;
begin
  for var i := 1 to round(variability * n) do 
  begin
    a := random(preserved_high_positions, n);
    mass[a].x := (mass[a].x) xor (1 shl random(1, 16));
  end;
end;


{-----------------------------------------Тело программы-----------------------------------------------------}
begin
  
  {Константы}
  max_iters := 40;
  preserved_high_positions := 10;
  preserved_low_positions := 10;
  variability := 0.5; 
  firstpop(mass);
  sorting(mass);
  {Итерация}
  i:=0;
  while not finish(mass, i) do 
  begin
    i := i + 1;
    selection(mass);{+}
    single_point(mass);{+}
    change_bit(mass);{+}
    sorting(mass);{+}
  end;
  {Вывод популяции}
  writeln('Количестко итераций: ', i);
  writeln;
  writeln('Максимальное значение: ', 'x= ', mass[1].x / 16384, '   y= ', mass[1].y);

end.