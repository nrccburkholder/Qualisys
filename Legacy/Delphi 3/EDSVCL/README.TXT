Important Upgrade Instructions
EDSSpell v3.5

To avoid duplicating files on your disk, EDSSpell VCL should be
installed into the same directory as your previous version.  The
default directory for installation is C:\DELPHI\EDSVCL.  However, if
you intend to use EDSSpell with various versions of Delphi (1,2,and 3),
we strongly suggest that you have a separate directory for each Delphi
version.

When installing any component, it is a good idea to create a backup
of your COMPLIB.DCL (Delphi 1.x) or CMPLIB32.DCL (Delphi 2).  Eminent
Domain Software strongly recommends that you create a backup of your
DCL before installing/upgrading the EDSSpell VCL.

If you are upgrading from a previous version of EDSSpell you *MUST*
remove the old TSpellDlg from your Delphi Component Palette prior to
adding the new version to avoid possibly damaging your DCL.

To remove the old version in Delphi 1.x:

	1) Select Options|Install Component
	2) From the list of installed components select EDSSpell and
	   click on the Remove button.
	3) Click on Add and select SPELL16.PAS from the EDSVCL directory.

To do this in Delphi 2.x or Delphi 3:

	1) Select Component|Install...
	2) From the list of installed components select EDSSpell and click
	   on the Remove button.
	3) Click on Add and select SPELL32.PAS from the EDSVCL directory.

Installing on Delphi 3.0

	1) Select Component|Install...
        2) Select Into New Package
        3) Click on Browse and select SPELL32.PAS from the EDSVCL directory.
        4) On the package name type Domain.  (If it exists, choose to overwrite)
        5) Delphi will state that it requires VCL30; choose OK and compile.
        (You should also add the EDSDB.PAS and EDSUTIL.PAS to the same package.)


Installing on C++ Builder

	1) Select Component|Install...
        2) Click on Add and select SPELL32.OBJ from the EDSVCL directory.
        (You should also add the EDSDB.OBJ and EDSUTIL.OBJ at the same time.)

Using in C++ Builder

Using EDSSpell in C++ Builder is just as simple as in Delphi: one line of code!

	SpellDlg1->SpellCheck(Memo1);

Installing EDSHelp in Delphi 3.0

Make sure that Delphi 3.0 is not running.  Copy the EDSSPELL.HLP file
from the EDSVCL directory into the \delphi3\help directory.  Make a backup
of the DELPHI3.CNT file.  Edit the DELPHI3.CNT file and add the following
line at the end of the Index Section:

; Index section
;==============
:Index VCL Object and Component Reference=vcl3.hlp
:Index Object Pascal Reference =obpascl3.hlp
:Index EDSSpell=edsspell.hlp       <<============

There has to be a carriage return after the last line.


New Users

See EDSSpell.HLP for more information on this component.


Power Users

If you are interested in developing your own dictionaries, ask us about
the PRO version.  It enables you to create your own compressed dictionary
files, including languages that you may create yourself.  One requirement,
you may not use these products to create competing products.


All Users

EDSSpell Version 3.5 allows you to have more than one dictionary open at
the same time.  If you have a wordlist that you want made into a compressed
EDSSpell dictionary file, we will create the dictionary at no cost to you,
as long as we have use of the wordlist for our purposes.  This applies to
wordlists for specialty fields like chemistry, engineering, legal, oil-gas,
accounting, etc.

Note: If you are having problems using EDSSpell with NT, change the property
UserDictionary from CUSTOM.DIC to USERDCT.TXT or any other name.

Some developers want to turn off the "Completed" dialog.  To do this, in the
procedure where you call the spell checker, SpellDlg1.SpellCheck(Memo1);
you must use the following code:

SpellDlg1.Closewin := FALSE; // <<== turns off the completed dialog
SpellDlg1.Show;		     // <<== you are responsible to show
SpellDlg1.SpellCheck (Memo1); //<<== or the memo component you choose
SpellDlg1.Close;	     // <<== you are responsible to close


Making Your Own Dictionaries

We provide you with a file (MAKEDAWG.EXE) that enables you to make your own
compressed dictionaries from an ASCII txt file.  Just double click on it and
follow the instuctions.  The file can use any ASCII character (0-255), so
foreign characters are supported without any additional overhead.

We achieve great compression, but at a cost.  By necessity, this program is
a "memory hog" and seems slow.  We suggest that you run it overnight.


Updates

We are always trying to improve our products and to add useful tools to your
toolkit.  Visit our site at

        http://www.onedomain.com

periodically for free upgrades to our dictionary files and dictionaries
that work with EDSSpell as they are developed for other languages, as well as
new product announcements.

Thank you for your continued support of EDSSpell.

eds@onedomain.com

