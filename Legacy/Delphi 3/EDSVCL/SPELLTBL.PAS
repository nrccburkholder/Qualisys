(* SPELLTBL.PAS - Copyright (c) 1995-1996, Eminent Domain Software *)
unit SpellTbl;
  {-provides alternate scan table for spell checker}
  {-see EDSSpell.HLP file for more information}
interface
uses
{$IFDEF Win32}
  {$IFDEF Ver100}
  LexLstD3;
  {$ELSE}
  LexLst32;
  {$ENDIF}
{$ELSE}
  LexLst;
{$ENDIF}

const
  ScanMax = 26;
  ScanTable: array[0..ScanMax - 1] of ScanStr =
    ('A:ED',
     'B:PVN',
     'C:SXV',
     'D:SF',
     'E:AI',
     'F:DG',
     'G:JFH',
     'H:GJ',
     'I:EUO',
     'J:HK',
     'K:CJL',
     'L:MN',
     'M:N',
     'M:MB',
     'O:IP',
     'P:BO',
     'Q:CKW',
     'R:ET',
     'S:CAD',
     'T:RY',
     'U:YI',
     'V:BC',
     'W:UQE',
     'X:KZ',
     'Y:TU',
     'Z:XS');

implementation

end.   { SpellTbl }
 