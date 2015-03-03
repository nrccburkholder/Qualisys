
{type definitions for 16/32 bit OSs}
type
{$IFDEF Win32}
  Int16 = SmallInt;
{$ELSE}
  Int16 = Integer;
{$ENDIF}

