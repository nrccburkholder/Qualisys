INFOPOWER 3 - 6/27/97
----------------------

TABLE OF CONTENTS
-----------------
 1. What's New in InfoPower 3
 2. Compatibility issues between InfoPower 2 and InfoPower 3
 3. Installing InfoPower 3


1. WHAT'S NEW IN INFOPOWER 3
----------------------------

  NEW DEMO APPLICATIONS
  PACKAGE SUPPORT
  INFOPOWER 3 ENHANCEMENTS
  

  NEW DEMO APPLICATIONS
  ---------------------
  Main demonstration program updated to show new functionality.
  This demo is located at \ip3\demos\maindemo\prjdemo.dpr.  We
  recommend you run the demo so you can see some of the new
  functionality in action.


  PACKAGE SUPPORT
  ---------------
  Packages are special dynamic-link libraries used by Delphi
  applications, the Delphi IDE, or both. They allow code-sharing
  among applications, reducing executable size and conserving
  system resources. IP3 supports both design time and runtime
  packaging options.


  INFOPOWER 3 ENHANCEMENTS
  ------------------------
 
     TwwDBRichEdit - New Component
     -----------------------------
     RichEdit allows your end-users to enter formatted text, such as
     boldface, italics, etc.  Woll2Woll's has greatly enhanced the
     native RichEdit in Delphi by providing both data-aware and
     non data-aware versions with the following capabilities.

     - Customizable printer margins

     - End-user can automatically explode the rich edit into a
       full WordPad like view, including a Toolbar, Formatbar, etc.

     - Paragraph indentation dialogs

     - Tab settings dialog

     - Page Layout dialog

     - Find/Replace dialog support

     - Extensive pop-up menu support

     - When unbound, you can dbl-click the richedit in design mode
       to store your richedit text into the actual component.
       Delphi's version cannot store formatted text into the control
       during design time.


     TwwStoredProc - New Component
     -----------------------------
     A new non-visual component that is inherited from Delphi's
     TStoredProc component, all standard properties and functionality
     is available.  Just like the Table, Query, and QBE you can attach
     the results to a grid and embed components and use picture masks.


     TwwClientDataSet - New Component
     --------------------------------
     A new non-visual component that is inherited from Delphi's
     TClientDataSet component, all standard properties and functionality
     is available.  Just like the Table, Query, and QBE you can attach
     the results to a grid and embed components and use picture masks.


     TwwRecordViewDialog - New Component
     -----------------------------------
     InfoPower 3's TwwRecordViewDialog provides a convenient way to view 
     or edit a record's contents.  

     The component dynamically creates a form based on  your DataSet's field 
     properties.  This component removes the necessity of building custom 
     record editing forms for each table.  InfoPower's RecordView supports 
     embedded controls, picture masks, horizontal or vertical display, custom 
     menus, modal or non-modal display, grid integration, and detailed display 
     options.


     TwwTable, TwwQBE, TwwQuery, and TwwStoredProc
     ---------------------------------------------
     Additional filtering options including the display of
     an hourglass while the filter is being applied, enabling
     the end-user to cancel the filter, and support for
     filtering on lookup fields.


     TwwTable
     --------
     property NarrowSearchUpperChar
	When NarrowSearch is True, incremental searching restricts
	the result set to only show records that match the typed
	in value.  InfoPower implements this by setting a lower
	and upper range on the table.  The upperrange is computed
	by adding a char(255) to the typed in value.  This works
	well for most back-ends.  However some back-ends such as
	Microsoft SQL Server do not recognize characters with
	high ascii values.  If using SQL-Server set this property
	to the ascii value for 'z', which is 122.



     TwwDBGrid
     ---------     
     - property MultiSelectOptions
       msoAutoUnselect
	  When True this property will unselect all records when
	  a user clicks on a different record without the Ctrl
	  key being pressed.  In addition it will automatically
	  select the current record.
 
       msoShiftSelect
	  When set to True this property allows the ability 
	  to select multiple contiguous records with the mouse
	  while the shift key is pressed.  
 
     - property EditCalculated
       When set to true it allows you to edit a calculated or lookup
       field.   As a result you will be able to edit calculated 
       linked fields or lookup fields in a grid with a single line
       of code.

     - Continous color support in OnCalcCellColors.  Now you can have
       unlimited colors in the Grid.  Previously you were restricted
       to just the basic Windows color palette.

     - By embedding our TwwDBEdit in the grid you can edit your memos
       in the grid's cell directly without requiring a pop-up window
       as in previous versions of InfoPower.
	   
     - Ability to have the grid use the Table's TField's settings or
       the Grid's selected settings.  This allows you to use one
       dataset with multiple grids, and allow each grid to display
       different sets of fields.

     - ColWidthsPixels runtime property to allow precise pixel
       control of a column's width during runtime.

     - property IndicatorButton.  Attach your own code to the
       top-left column of the grid.  Convenient for
       invoking TwwRecordViewDialog

     Added methods

	Added SelectAll and UnselectAll methods for the grid.
	SelectAll selects all records in a grid for multi-selection.
	UnselectAll will deselect all previously selected records.
 
	Added SetActiveRow method to set the active Row of the grid.
	This method changes the active row in a currently displayed
	grid.  The grid will not scroll.

     Added events

	OnMultiSelectRecord
	   This event executes before a record is selected or
	   unselected in a TwwDBGrid.  Use this event to perform
	   some custom action based on a user selecting a record.

	   Example:  (Prevent user from selecting more than 3 records)

	   procedure TForm1.wwDBGrid1MultiSelectRecord(
	      Grid: TwwDBGrid;
	      Selecting: Boolean; var Accept: Boolean);  
	   begin
	      if (Selecting) and
		 (Grid.Selectedlist.count >=3) then
		 Accept := False;
	   end;   
 
	   Note:  Not to be used in conjunction with shift select 
		  MultiSelectOption | msoShiftSelect.


     TwwDBSpinEdit
     -------------

     - Added support for TTimeFields in TwwDBSpinEdit

     - Added unbound support for TwwDBSpinEdit for use with
       datetimes, dates, and times.
 
       property UnboundDataType;       
	  Now you can use the TwwDBSpinEdit on dates without 
	  it being bound to a field in a database.  Just set the 
	  UnboundDataType and the SpinEdit will treat the data as
	  if it is a DateTime, Time, Date, or Integer field.

	  Valid values: wwDefault,wwEdtDateTime,wwEdtTime,wwEdtDate

     - Now the spinedit will highlight the text that is changing 
       while spinning, so the user will visually see what is changing


     TwwDBEdit, TwwDBComboBox, TwwDBComboDlg
     ---------------------------------------
     UnboundDataType has also been added to support the
     AutoFillDate property when the component is not tied to a
     DataField.  So a user can use the AutoFill of a Time, Date, or 
     DateTime in our TwwDBEdit.


     TwwFilterDialog
     ---------------
     New functionality in tihs component includes
     and/or/null support on a single field basis,  
     display of nonmatching records, filtering on lookup fields,
     and even some filter optimizations that allow the
     TwwFilterDialog to take greater advantage of indexes.
    	

     TwwDBLookupCombo
     ----------------
     The LookupTable property now also accepts TwwQuery, TwwQBE,
     TwwClientDataSet, allowing use of parameterized queries
     during lookups and multi-tier database lookups.

     property AllowClearKey
	When the ComboBox style is set to csDropDownList, the user
	is not able to clear the selection.  The AllowClearKey
	property when set to true, gives the user a convenient way
	to clear the combos current selection simply by entering
	either the <DEL> or <BACKSPACE> character.

     property ShowMatchText
	Quicken Style incremental searching.   Now incremental
	searching with ShowMatchText set to True will behave
	just like quicken and highlight the text that is the
	closest match.
   
     property Grid (Runtime only)
	Developer has control over drop-down list properties,
	such as color, font, etc, through the new public
	property Grid.  For instance if you want to change the
	color of the drop-down list to be yellow you can place
	the following code in the control's onDropDown event.

	WwDBLookupCombo1.Grid.color:= clYellow;

     - We have improved support for lookup up on detail tables,
       removing the requirement for multifield indexes.



     TwwDBComboBox
     ----------------------------------
     Quicken Style incremental searching.   Now incremental searching 
     with ShowMatchText set to True will behave just like quicken and 
     highlight the text that is the closest match.


     TwwIntl
     -------
     property DialogFontStyle
	Use this property to choose the style of the fonts that
	appear in InfoPower’s dialogs.

     property CheckboxInGridStyle
	Use this property to choose the style of the checkboxes
	that appear in all the grids.  

	cbStyleAuto       Style of checkbox is dependant on
			  operating system.
	cbStyleCheckmark  Checkmark style of checkbox.
	cbStyleXmark      X style of checkbox. 




2. COMPATIBILITY ISSUES BETWEEN INFOPOWER 2 AND INFOPOWER 3
-----------------------------------------------------------
   Please see the IP30.HLP file under the index entry
   "Compatibility issues with InfoPower"


3. INSTALLING INFOPOWER 3
-----------------------------------------
   Please see the IP30.HLP file under the index entry
   "Installation Steps for InfoPower"


 Unless otherwise noted, all materials provided in this release
 are Copyright 1995-1997 by Woll2Woll Software

---------------------------End----------------------------------
