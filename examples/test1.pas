PROGRAM test;
VAR
   number   : INTEGER;
   i,x : INTEGER;
BEGIN
  { A comment }
  i:=0;
  x:=10;
  WHILE x>0 DO
  BEGIN
    i:=i+2;
    x:=x-1;
    IF i=10 THEN writeln(10);
  END
  IF i<10 THEN
  BEGIN
    writeln(888);
  END
  ELSE writeln(999);
  writeln(x);
  writeln(i);
END.
