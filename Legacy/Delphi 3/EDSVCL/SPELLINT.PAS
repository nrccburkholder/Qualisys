(* SPELLINT.PAS - Copyright (c) 1995-1996, Eminent Domain Software *)

unit SpellInt;
 {-interface unit for SPELLER.DLL}
 {version 2.0 no longer uses the DLL}
 {This file is provided for backward compatibility for users who}
 {accessed version 1.0 DLL directly}

{$I SPELLDEF.PAS}

interface
uses
{$IFDEF Win32}
  LexDCT32,
{$ELSE}
  LexDCT,
{$ENDIF}
  SysUtils, Classes;

function dllOpenDictionary(FileName : string) : Boolean;
  {-Opens the specified dictionary; Returns TRUE if successful}
function dllInDictionary(AWord: String) : Boolean;
  {-Returns TRUE if AWord is in the dictionary}
function dllAddWord(AWord : String) : Boolean;
  {-Adds AWord to User Dictionary; Returns TRUE if successful}
function  dllSuggestWords(AWord: String; NumSuggest: byte): TStringList;
  {-Suggests words; Returns nil if unsuccessful}
procedure dllDeleteUserWords;
  {-Deletes all word in User Dictionary}
procedure dllCloseDictionary;
  {-Closes the currently open dictionary}

implementation

function dllOpenDictionary(FileName : string) : Boolean;
  {-Opens the specified dictionary; Returns TRUE if successful}
begin
  if DCT = nil then
    DCT := TDictionary.Create;
  Result := DCT.OpenDictionary (Filename, 'USERDCT.TXT');
end;  { dllOpenDictionary }

function dllInDictionary(AWord: String) : Boolean;
  {-Returns TRUE if AWord is in the dictionary}
begin
  Result := DCT.InDictionary (AWord);
end;  { dllInDictionary }

function dllAddWord(AWord : String) : Boolean;
  {-Adds AWord to User Dictionary; Returns TRUE if successful}
begin
  Result := DCT.AddWord (AWord);
end;  { dllAddWord }

function dllSuggestWords(AWord: String; NumSuggest: byte): TStringList;
  {-Suggests words; Returns nil if unsuccessful}
begin
  Result := DCT.SuggestWords (AWord, NumSuggest);
end;  { dllSuggestWords }

procedure dllDeleteUserWords;
  {-Deletes all word in User Dictionary}
var
  F: File;
begin
  DCT.AddedWords.Clear;
  Assign (F, ExtractFilePath (DCT.DictFile) + DCT.UserDict);
  Erase (F);
end;  { dllDeleteUserWords }

procedure dllCloseDictionary;
  {-Closes the currently open dictionary}
begin
  DCT.Destroy;
end;  { dllCloseDictionary }

end.  { SpellInt }
