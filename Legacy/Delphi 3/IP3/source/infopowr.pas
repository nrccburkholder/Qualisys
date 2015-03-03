unit Infopowr;
{
//
// Components : Registration for InfoPower
//
// Copyright (c) 1995, 1996, 1997 by Woll2Woll Software
//
}
interface
   uses Classes, dsgnintf,
        wwDBGrid, wwTable, wwmemo, wwdblook, wwidlg, wwdbdlg, wwprpedt, wwquery,
        wwkeycb, dbtables, wwdotdot, wwdatsrc, db, wwqbe, wwlocate, wwdbcomb,
        wwdbspin, wwdbedit, wwfltdlg, wwintl, wwstorep, wwprpds, wwdbigrd,
   {$ifdef win32}
        comctrls, wwriched,
   {$endif}
   {$ifdef ver100}
        wwclient,
   {$endif}
        wwrcdvw, buttons;
procedure Register;

implementation
{$ifdef win32}
{$R INFO32.RES}
{$else}
{$R INFO16.RES}
{$endif}

procedure Register;
begin
  RegisterComponents('InfoPower', [TwwDataSource]);
  RegisterComponents('InfoPower', [TwwTable]);
  RegisterComponents('InfoPower', [TwwQuery]);
  RegisterComponents('InfoPower', [TwwStoredProc]);
  {$ifdef ver100}
  RegisterComponents('InfoPower', [TwwClientDataSet]);
  {$endif}
  RegisterComponents('InfoPower', [TwwQBE]);
  RegisterComponents('InfoPower', [TwwDBGrid]);
  RegisterComponents('InfoPower', [TwwDBEdit]);
  RegisterComponents('InfoPower', [TwwDBComboBox]);
  RegisterComponents('InfoPower', [TwwDBSpinEdit]);
  RegisterComponents('InfoPower', [TwwDBComboDlg]);
  RegisterComponents('InfoPower', [TwwDBLookupCombo]);
  RegisterComponents('InfoPower', [TwwDBLookupComboDlg]);
  RegisterComponents('InfoPower', [TwwKeyCombo]);
  RegisterComponents('InfoPower', [TwwIncrementalSearch]);
  {$ifdef win32}
  RegisterComponents('InfoPower', [TwwDBRichEdit]);
  {$endif}

  RegisterComponents('IP Dialogs', [TwwMemoDialog]);
  RegisterComponents('IP Dialogs', [TwwSearchDialog]);
  RegisterComponents('IP Dialogs', [TwwLocateDialog]);
  RegisterComponents('IP Dialogs', [TwwLookupDialog]);
  RegisterComponents('IP Dialogs', [TwwFilterDialog]);
  RegisterComponents('IP Dialogs', [TwwRecordViewDialog]);
  RegisterComponents('IP Dialogs', [TwwIntl]);


  RegisterComponentEditor(TwwDBGrid, TwwDBGridComponentEditor);

  RegisterPropertyEditor(TypeInfo(TStrings),
                         TwwDBGrid, '', TSelectedFieldsProperty);
  RegisterPropertyEditor(TypeInfo(TwwDBPicture),
                         TwwCustomMaskEdit, '', TwwPictureProperty);
  RegisterPropertyEditor(TypeInfo(TStrings),
                         TwwDBCustomLookupCombo, '', TwwDBLookupDisplayProperty);
  RegisterPropertyEditor(TypeInfo(TStrings),
                         TwwRecordViewDialog, 'Selected', TwwDBLookupDisplayProperty);
  RegisterPropertyEditor(TypeInfo(TStrings),
                         TwwCustomLookupDialog, '', TwwDBLookupDisplayProperty);
  RegisterPropertyEditor(TypeInfo(TwwTableDisplayType),
                         TwwTable, 'LookupFields', TwwTableDisplayProperty);
  RegisterPropertyEditor(TypeInfo(TwwTableDisplayType),
                         TwwTable, 'LookupLinks', TwwTableDisplayProperty);
  RegisterPropertyEditor(TypeInfo(TwwTableDisplayType),
                         TwwTable, 'PictureMasks', TwwTableDisplayProperty);
  RegisterPropertyEditor(TypeInfo(TwwTableDisplayType),
                         TwwTable, 'ControlType', TwwTableDisplayProperty);
  RegisterPropertyEditor(TypeInfo(TwwTableDisplayType),
                         TwwQuery, 'LookupFields', TwwTableDisplayProperty);
  RegisterPropertyEditor(TypeInfo(TwwTableDisplayType),
                         TwwQuery, 'LookupLinks', TwwTableDisplayProperty);
  RegisterPropertyEditor(TypeInfo(TwwTableDisplayType),
                         TwwQuery, 'ControlType', TwwTableDisplayProperty);
  RegisterPropertyEditor(TypeInfo(TwwTableDisplayType),
                         TwwQuery, 'PictureMasks', TwwTableDisplayProperty);
  RegisterPropertyEditor(TypeInfo(TwwTableDisplayType),
                         TwwQBE, 'LookupFields', TwwTableDisplayProperty);
  RegisterPropertyEditor(TypeInfo(TwwTableDisplayType),
                         TwwQBE, 'LookupLinks', TwwTableDisplayProperty);
  RegisterPropertyEditor(TypeInfo(TwwTableDisplayType),
                         TwwQBE, 'ControlType', TwwTableDisplayProperty);
  RegisterPropertyEditor(TypeInfo(TwwTableDisplayType),
                         TwwQBE, 'PictureMasks', TwwTableDisplayProperty);
  RegisterPropertyEditor(TypeInfo(TwwTableDisplayType),
                         TwwStoredProc, 'LookupFields', TwwTableDisplayProperty);
  RegisterPropertyEditor(TypeInfo(TwwTableDisplayType),
                         TwwStoredProc, 'LookupLinks', TwwTableDisplayProperty);
  RegisterPropertyEditor(TypeInfo(TwwTableDisplayType),
                         TwwStoredProc, 'ControlType', TwwTableDisplayProperty);
  RegisterPropertyEditor(TypeInfo(TwwTableDisplayType),
                         TwwStoredProc, 'PictureMasks', TwwTableDisplayProperty);

  RegisterPropertyEditor(TypeInfo(TStrings),
                         TwwDBComboBox, 'Items', TwwComboItemsProperty);
  RegisterPropertyEditor(TypeInfo(TwwDBPicture),
                         TwwDBEdit, 'Picture', TwwPictureProperty);

  RegisterPropertyEditor(TypeInfo(String),
                         TwwDBLookupCombo, 'LookupField', TwwIndexFieldProperty);
  RegisterPropertyEditor(TypeInfo(String),
                         TwwDBLookupComboDlg, 'LookupField', TwwIndexFieldProperty);
  RegisterPropertyEditor(TypeInfo(String),
                         TwwLocateDialog, 'SearchField', TwwSearchFieldProperty);
  RegisterPropertyEditor(TypeInfo(String),
                         TwwFilterDialog, 'DefaultField', TwwSearchFieldProperty);
  RegisterPropertyEditor(TypeInfo(TDataSet),
                         TwwdBCustomLookupCombo, 'LookupTable', TwwDataSetProperty);
  RegisterPropertyEditor(TypeInfo(TwwTable),
                         TwwCustomLookupDialog, '', TwwTableProperty);

  RegisterPropertyEditor(TypeInfo(TDataSet),
                         TwwDataSource, 'DataSet', TwwDataSetProperty);
  RegisterPropertyEditor(TypeInfo(TStrings),
                         TwwFilterDialog, 'SelectedFields', TwwFilterFieldsProperty);
  {$ifdef win32}
  RegisterPropertyEditor(TypeInfo(TStrings),
                         TwwCustomRichEdit, 'Lines', TwwRichEditItemsProperty);
  {$endif}
  RegisterPropertyEditor(TypeInfo(TSpeedButton),
                         TwwDBGrid, 'IndicatorButton', TwwGridIndicatorProperty);

{  RegisterComponentEditor(TwwRecordViewDialog, TwwDBLookupDisplayComponentEditor);}
  RegisterComponentEditor(TwwDBLookupCombo, TwwDBLookupDisplayComponentEditor);
  RegisterComponentEditor(TwwDBLookupComboDlg, TwwDBLookupDisplayComponentEditor);
  RegisterComponentEditor(TwwLookupDialog, TwwDBLookupDisplayComponentEditor);
  RegisterComponentEditor(TwwSearchDialog, TwwDBLookupDisplayComponentEditor);
  {$ifdef win32}
  RegisterComponentEditor(TwwCustomRichEdit, TwwRichEditComponentEditor);
  {$endif}
  RegisterComponentEditor(TwwRecordViewDialog, TwwRecordViewComponentEditor);
  RegisterClass(TwwIButton);

end;

end.
