PROGRAM test;
VAR
   number     : INTEGER;
   a, b, c, x: INTEGER;
BEGIN
  number := 2;
  a := number;
  b := 10 * a + 10 * number / 4;
  c := a - b;
  x := 11*(a+b+c);
  IF x<0 THEN
  BEGIN
    writeln(number);
    writeln(a);
    writeln(b);
  END
  ELSE BEGIN
    writeln(c);
    writeln(x);
  END
END.
