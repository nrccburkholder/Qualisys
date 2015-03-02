(* SPELLDEF.PAS - Copyright (c) 1995-1997, Eminent Domain Software *)

(* Defines for EDSSpell.PAS and AbsBuff.PAS *)
(* You must recompile the component palette after changing ANY of these defines *)

{.$DEFINE Shareware}       {-add period to enable commercial version}
  (* You must have purchased the commercial version to enable this,  *)
  (* otherwise you will not have the appropriate files necessary and *)
  (* the component will not compile.                                 *)

(* Remove period in front of languages you would like supported          *)
(* NOTE: These defines need only be enabled if you would like the spell  *)
(*       dialog's buttons and labels to change language.   If you would  *)
(*       simply like to add support for spell checking a particular      *)
(*       language, you need only include the appropriate DCT file, there *)
(*       is no need to enable the defines below.                         *)

{$DEFINE SupportEnglish}     {must support English (do not change!!!)}
{.$DEFINE SupportSpanish}
{.$DEFINE SupportBritish}
{.$DEFINE SupportItalian}
{.$DEFINE SupportFrench}
{.$DEFINE SupportGerman}
{.$DEFINE SupportDutch}


