PROGRAM test;
VAR
   number     : INTEGER;
   a, b, c, x : INTEGER;
BEGIN
  number := 2;
  a := number;
  b := 10 * a + 10 * number / 4;
  c := a - b;
  x := 11*(a+b+c);
  writeln(a);
  writeln(b);
  writeln(c);
  writeln(x);
END.
