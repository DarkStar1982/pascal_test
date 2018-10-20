PROGRAM Test;
VAR
   number     : INTEGER;
   a, b, c, x : INTEGER;
   y          : REAL;
BEGIN
  number := 2;
  a := number;
  b := 10 * a + 10 * number / 4;
  c := a - b
  x := 11*(a+b+c);
  y := 20 / 7 + 3.14*x;
  writeln(y);
END.
