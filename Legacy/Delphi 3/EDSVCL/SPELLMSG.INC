{TLanguages is defined in SpellGbl.PAS}

const
  SpellTitle      : array[TLanguages] of string[30] = (
{$IFDEF SupportEnglish}
     {lgEnglish} 'Spell Checker'    {not usually used}
{$ENDIF}

{$IFDEF SupportSpanish}
     {lgSpanish},'Verificaci�n de Ortograf�a.'
{$ENDIF}

{$IFDEF SupportBritish}
     {lgBritish},'Spell Checker'    {not usually used}
{$ENDIF}

{$IFDEF SupportItalian}
     {lgItalian},'Controllo Ortografico'
{$ENDIF}

{$IFDEF SupportFrench}
     {lgFrench}, 'V�rification de l''orthographe'
{$ENDIF}

{$IFDEF SupportGerman}
     {lgGerman}, 'Rechtschreibpr�fung'
{$ENDIF}

{$IFDEF SupportDutch}
     {lgDutch}  ,'Spellingcontrole'
{$ENDIF}
     );
  FoundPhrase     : array[TLanguages] of string[15] = (
{$IFDEF SupportEnglish}
     {lgEnglish} 'Word found:'
{$ENDIF}

{$IFDEF SupportSpanish}
     {lgSpanish},'Se encontr�:'
{$ENDIF}

{$IFDEF SupportBritish}
     {lgBritish},'Word found:'
{$ENDIF}

{$IFDEF SupportItalian}
     {lgItalian},'Parola trovata'
{$ENDIF}

{$IFDEF SupportFrench}
     {lgFrench}, 'Mot trouv�'
{$ENDIF}

{$IFDEF SupportGerman}
     {lgGerman}, 'Gefundenes Wort'
{$ENDIF}

{$IFDEF SupportDutch}
     {lgDutch}  ,'Gevonden:'
{$ENDIF}
     );
  NotFoundPhrase  : array[TLanguages] of string[15] = (
{$IFDEF SupportEnglish}
     {lgEnglish} 'Not found:'
{$ENDIF}

{$IFDEF SupportSpanish}
     {lgSpanish},'No se encontr�:'
{$ENDIF}

{$IFDEF SupportBritish}
     {lgBritish},'Not found:'
{$ENDIF}

{$IFDEF SupportItalian}
     {lgItalian},'Non trovata'
{$ENDIF}

{$IFDEF SupportFrench}
     {lgFrench}, 'Pas dans le dictionaire'
{$ENDIF}

{$IFDEF SupportGerman}
     {lgGerman}, 'Nicht Gefunden'
{$ENDIF}

{$IFDEF SupportDutch}
     {lgDutch}  ,'Niet gevonden:'
{$ENDIF}
     );
  NoErrorsMesg    : array[TLanguages] of string = (
{$IFDEF SupportEnglish}
     {lgEnglish} 'No errors found. Spell checking complete...'
{$ENDIF}

{$IFDEF SupportSpanish}
    {lgSpanish},'Se termin� de verificar la ortograf�a.' + #13 +
                 'No se encontraron errores...'
{$ENDIF}

{$IFDEF SupportBritish}
     {lgBritish},'No errors found. Spell checking complete...'
{$ENDIF}

{$IFDEF SupportItalian}
     {lgItalian},'Controllo ortografico completato. Nessun errore...'
{$ENDIF}

{$IFDEF SupportFrench}
     {lgFrench}, 'Pas d''erreurs. V�rification de l''orthographe termin�e.'
{$ENDIF}

{$IFDEF SupportGerman}
     {lgGerman}, 'Keine Fehler gefunden. Rechtschreibpr�fung vollst�ndig.'
{$ENDIF}

{$IFDEF SupportDutch}
     {lgDutch}   ,'Geen spelfouten. Spellingcontrole voltooid...'
{$ENDIF}
     );
  AbortedMesg     : array[TLanguages] of string = (
{$IFDEF SupportEnglish}
     {lgEnglish} 'Spell checking aborted.'
{$ENDIF}

{$IFDEF SupportSpanish}
     {lgSpanish},'Se detuvo la verificaci�n de ortograf�a.'
{$ENDIF}

{$IFDEF SupportBritish}
     {lgBritish},'Spell checking aborted.'
{$ENDIF}

{$IFDEF SupportItalian}
     {lgItalian},'Controllo ortografico interrotto.'
{$ENDIF}

{$IFDEF SupportFrench}
     {lgFrench}, 'V�rification de l''orthographe interrompue.'
{$ENDIF}

{$IFDEF SupportGerman}
     {lgGerman}, ' Rechtschreibpr�fung  abgebrochen.'
{$ENDIF}

{$IFDEF SupportDutch}
     {lgDutch}  ,'Spellingcontrole onderbroken...'
{$ENDIF}
     );
  CompleteMesg    : array[TLanguages] of string = (
{$IFDEF SupportEnglish}
     {lgEnglish} 'Spell checking complete.'
{$ENDIF}

{$IFDEF SupportSpanish}
     {lgSpanish},'Se termin� de verificar la ortograf�a.'
{$ENDIF}

{$IFDEF SupportBritish}
     {lgBritish},'Spell checking complete.'
{$ENDIF}

{$IFDEF SupportItalian}
     {lgItalian},'Controllo ortografico completato.'
{$ENDIF}

{$IFDEF SupportFrench}
     {lgFrench}, 'V�rification de l''orthographe termin�e.'
{$ENDIF}

{$IFDEF SupportGerman}
     {lgGerman}, 'Rechtschreibpr�fung vollst�ndig.'
{$ENDIF}

{$IFDEF SupportDutch}
     {lgDutch}  ,'Spellingcontrole voltooid...'
{$ENDIF}
     );
  AddMesg      : array[TLanguages] of string[30] = (
{$IFDEF SupportEnglish}
     {lgEnglish} 'Add "%s" to dictionary?'
{$ENDIF}

{$IFDEF SupportSpanish}
     {lgSpanish},'�Quiere a�adir "%s" al diccionario?'
{$ENDIF}

{$IFDEF SupportBritish}
     {lgBritish},'Add "%s" to dictionary?'
{$ENDIF}

{$IFDEF SupportItalian}
     {lgItalian},'�Quiere a�adir "%s" al diccionario?'
{$ENDIF}

{$IFDEF SupportFrench}
     {lgFrench}, 'Ajouter "%s" au dictionaire?'
{$ENDIF}

{$IFDEF SupportGerman}
     {lgGerman}, '"%s" in W�rterbuch einf�gen?'
{$ENDIF}

{$IFDEF SupportDutch}
     {lgDutch}  ,'Add "%s" to dictionary?'
{$ENDIF}
     );
  AddedMesg    : array[TLanguages] of string[30] = (
{$IFDEF SupportEnglish}
     {lgEnglish} '"%s" already in dictionary.'
{$ENDIF}

{$IFDEF SupportSpanish}
     {lgSpanish},'"%s" ya est� en el diccionario.'
{$ENDIF}

{$IFDEF SupportBritish}
     {lgBritish},'"%s" already in dictionary.'
{$ENDIF}

{$IFDEF SupportItalian}
     {lgItalian},'"%s" ya esta en el diccionario.'
{$ENDIF}

{$IFDEF SupportFrench}
     {lgFrench}, '"%s" d�j� dans le dictionare.'
{$ENDIF}

{$IFDEF SupportGerman}
     {lgGerman}, '"%s" ist schon im W�rterbuch'
{$ENDIF}

{$IFDEF SupportDutch}
     {lgDutch}  ,'"%s" already in dictionary.'
{$ENDIF}
     );

