{TLanguages is defined in SpellGbl.PAS}

const
  SpellTitle      : array[TLanguages] of string[30] = (
{$IFDEF SupportEnglish}
     {lgEnglish} 'Spell Checker'    {not usually used}
{$ENDIF}

{$IFDEF SupportSpanish}
     {lgSpanish},'Verificación de Ortografía.'
{$ENDIF}

{$IFDEF SupportBritish}
     {lgBritish},'Spell Checker'    {not usually used}
{$ENDIF}

{$IFDEF SupportItalian}
     {lgItalian},'Controllo Ortografico'
{$ENDIF}

{$IFDEF SupportFrench}
     {lgFrench}, 'Vérification de l''orthographe'
{$ENDIF}

{$IFDEF SupportGerman}
     {lgGerman}, 'Rechtschreibprüfung'
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
     {lgSpanish},'Se encontró:'
{$ENDIF}

{$IFDEF SupportBritish}
     {lgBritish},'Word found:'
{$ENDIF}

{$IFDEF SupportItalian}
     {lgItalian},'Parola trovata'
{$ENDIF}

{$IFDEF SupportFrench}
     {lgFrench}, 'Mot trouvé'
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
     {lgSpanish},'No se encontró:'
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
    {lgSpanish},'Se terminó de verificar la ortografía.' + #13 +
                 'No se encontraron errores...'
{$ENDIF}

{$IFDEF SupportBritish}
     {lgBritish},'No errors found. Spell checking complete...'
{$ENDIF}

{$IFDEF SupportItalian}
     {lgItalian},'Controllo ortografico completato. Nessun errore...'
{$ENDIF}

{$IFDEF SupportFrench}
     {lgFrench}, 'Pas d''erreurs. Vérification de l''orthographe terminée.'
{$ENDIF}

{$IFDEF SupportGerman}
     {lgGerman}, 'Keine Fehler gefunden. Rechtschreibprüfung vollständig.'
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
     {lgSpanish},'Se detuvo la verificación de ortografía.'
{$ENDIF}

{$IFDEF SupportBritish}
     {lgBritish},'Spell checking aborted.'
{$ENDIF}

{$IFDEF SupportItalian}
     {lgItalian},'Controllo ortografico interrotto.'
{$ENDIF}

{$IFDEF SupportFrench}
     {lgFrench}, 'Vérification de l''orthographe interrompue.'
{$ENDIF}

{$IFDEF SupportGerman}
     {lgGerman}, ' Rechtschreibprüfung  abgebrochen.'
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
     {lgSpanish},'Se terminó de verificar la ortografía.'
{$ENDIF}

{$IFDEF SupportBritish}
     {lgBritish},'Spell checking complete.'
{$ENDIF}

{$IFDEF SupportItalian}
     {lgItalian},'Controllo ortografico completato.'
{$ENDIF}

{$IFDEF SupportFrench}
     {lgFrench}, 'Vérification de l''orthographe terminée.'
{$ENDIF}

{$IFDEF SupportGerman}
     {lgGerman}, 'Rechtschreibprüfung vollständig.'
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
     {lgSpanish},'¿Quiere añadir "%s" al diccionario?'
{$ENDIF}

{$IFDEF SupportBritish}
     {lgBritish},'Add "%s" to dictionary?'
{$ENDIF}

{$IFDEF SupportItalian}
     {lgItalian},'¿Quiere añadir "%s" al diccionario?'
{$ENDIF}

{$IFDEF SupportFrench}
     {lgFrench}, 'Ajouter "%s" au dictionaire?'
{$ENDIF}

{$IFDEF SupportGerman}
     {lgGerman}, '"%s" in Wörterbuch einfügen?'
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
     {lgSpanish},'"%s" ya está en el diccionario.'
{$ENDIF}

{$IFDEF SupportBritish}
     {lgBritish},'"%s" already in dictionary.'
{$ENDIF}

{$IFDEF SupportItalian}
     {lgItalian},'"%s" ya esta en el diccionario.'
{$ENDIF}

{$IFDEF SupportFrench}
     {lgFrench}, '"%s" déjà dans le dictionare.'
{$ENDIF}

{$IFDEF SupportGerman}
     {lgGerman}, '"%s" ist schon im Wörterbuch'
{$ENDIF}

{$IFDEF SupportDutch}
     {lgDutch}  ,'"%s" already in dictionary.'
{$ENDIF}
     );

