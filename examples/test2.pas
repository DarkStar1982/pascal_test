PROGRAM test;
VAR
   number,number2   : INTEGER;
   a, b, c, x, i : INTEGER;
BEGIN
  { A comment }
  number := 2;
  a := number;
  b := 10 * a + 10 * number / 4;
  c := a - b;
  x := 11*(a+b+c);
  writeln(x);
  x :=0;
  IF x>0 THEN
  BEGIN
    writeln(x);
  END
  ELSE BEGIN
    writeln(c);
    writeln(x);
    number2 := 10;
    WHILE number2>0 DO number2:= number2-1;
    writeln(number2);
  END
  { a second comment }
  i:=0;
  x:=10;
  WHILE x>0 DO
  BEGIN
    i:=i+2;
    IF i=10 THEN writeln(i);
    x:=x-1;
  END
  writeln(x);
  writeln(i);
END.
