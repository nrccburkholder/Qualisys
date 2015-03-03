(* SPELLGBL.PAS - Copyright (c) 1995-1996, Eminent Domain Software *)

unit SpellGbl;
  (*Constant and Type declarations for EDSSpell component*)
interface

{$I SpellDef.PAS}

type
  TLanguages       = (
{$IFDEF SupportEnglish}     lgEnglish      {$ENDIF}
{$IFDEF SupportSpanish}    ,lgSpanish      {$ENDIF}
{$IFDEF SupportBritish}    ,lgBritish      {$ENDIF}
{$IFDEF SupportItalian}    ,lgItalian      {$ENDIF}
{$IFDEF SupportFrench}     ,lgFrench       {$ENDIF}
{$IFDEF SupportGerman}     ,lgGerman       {$ENDIF}
{$IFDEF SupportDutch}      ,lgDutch        {$ENDIF});
  TDialogTypes     = (dtWordPerfect, dtMSWord, dtWordPro96);

const
  ValidChars: set of Char =        {valid characters used for parsing buffer}
    [#39{'}, '0'..'9', 'a'..'z', 'A'..'Z', #128{Ç}..#165{Ñ}];
  NumberSet:  set of Char =
    ['0'..'9'];
{$IFDEF Win32}
  MaxBuffer       = 2147483647;
{$ELSE}
  MaxBuffer       = 32767;
{$ENDIF}
  AddBufferSize   = 4096;  {maximum size of added buffer}
    (* the above constant defines the maximum number of added characters a buffer can hold  *)
    (* for example: if a user changes the word "tst" to "test", we have added one character *)
    (* if addbuffersize + sizeof the current buffer is greater than the maximum size the    *)
    (* buffer holds, the end characters are typically lost.  This is not due to the spell   *)
    (* component but rather the parent component (i.e. the memo)                            *)
  Dictionaries    : array[TLanguages] of string[8]  = (
{$IFDEF SupportEnglish}  'English'      {$ENDIF}
{$IFDEF SupportSpanish} ,'Spanish'      {$ENDIF}
{$IFDEF SupportBritish} ,'British'      {$ENDIF}
{$IFDEF SupportItalian} ,'Italian'      {$ENDIF}
{$IFDEF SupportFrench}  ,'French'       {$ENDIF}
{$IFDEF SupportGerman}  ,'German'       {$ENDIF}
{$IFDEF SupportDutch}   ,'Dutch'        {$ENDIF});
  Margin          = 10;            {margin for moving dialog}

type
  TBigBuffer = array[1..MaxBuffer] of Char;
  PBigBuffer = ^TBigBuffer;

{Language Message Constants for EDSSpell}
{$I SpellMsg.Inc}

implementation

end.  { SpellGbl }
