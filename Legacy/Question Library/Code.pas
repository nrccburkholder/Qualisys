unit Code;

{*******************************************************************************
Description: a non-modal dialog box used for inserting codes into heading, question, and scale text 

Modifications:
--------------------------------------------------------------------------------
Date        UserID   Description
--------------------------------------------------------------------------------
04-07-2006  GN01     Making sure the translate richedit control has the active
                     focus to avoid the invalid typecast error                                                                

05-02-2006  GN02     Bookmark the current Language                                                                
                     
*******************************************************************************}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Clipbrd,
  DBCGrids, StdCtrls, DBCtrls, ExtCtrls, Grids, DBGrids, Buttons, ComCtrls, DBRichEdit;

type
  TfrmCode = class(TForm)
    Panel2: TPanel;
    DBNavigator1: TDBNavigator;
    btnClose: TSpeedButton;
    btnNext: TSpeedButton;
    btnInsertCode: TSpeedButton;
    btnFind: TSpeedButton;
    DBGrid1: TDBGrid;
    procedure CloseClick(Sender: TObject);
    procedure InsertClick(Sender: TObject);
    procedure FindClick(Sender: TObject);
    procedure NextClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    vForm : TForm;
    selectedLanguage : integer;
  end;

var
  frmCode: TfrmCode;

implementation

uses Data, Support
{$IFDEF cdLibrary}
, Edit, Common, Browse
{$ENDIF}
;

{$R *.DFM}

{ ACTIVATION SECTION }

{ sets the button states each time the form is activated }

procedure TfrmCode.FormActivate(Sender: TObject);
begin
  btnInsertCode.Enabled := ( vForm.ActiveControl is TclDBRichEdit ) and
      not TclDBRichEdit( vForm.ActiveControl ).ReadOnly;
  if modSupport.dlgLocate.DataSource <> modLibrary.srcCode then btnNext.Enabled := False;

  //GN01: Refresh the code data on this screen when the user changes the language in the Translation form
  modLibrary.tblCode.Refresh ;
  Caption := 'Code Selection: ' +  IntToStr(modLibrary.tblCode.RecordCount);

end;

{ BUTTON SECTION }

{ calls the DBRichEdit's embed method, passing in the currently selected code }

procedure TfrmCode.InsertClick(Sender: TObject);
//var fieldedcode:string;
var
   i : integer;
begin
  //GN01: Make sure the active control is the RichEdit or else it would lead to
  //typecast error if the user has other control as the active focus.
  //For example, if the language dropdown has the active focus in the translation form
  if Trim(modLibrary.tblCodeCode.AsString) <> ''  then
  begin
       {
     if not (vForm.ActiveControl is  TclDBRichCodeBtn) then
     begin
        for i := 0 to  vForm.ComponentCount - 1 do
        begin
           if (vForm.Components[i] is TclDBRichCodeBtn) and ((vForm.Components[i]).Tag = 1) then
           begin
              vForm.Show;
              vForm.ActiveControl := (vForm.Components[i] As TWinControl);
              Break;
           end;
        end;
     end;}
     vForm.Show;

     //Edit Question
     if (vForm.Name= 'frmEdit') and (vForm.FindComponent( 'pclEdit' ) is TPageControl) then
     begin
        vForm.ActiveControl := (vForm.FindComponent( 'rtfText' ) as TclDBRichCodeBtn );
        ( vForm.ActiveControl as TclDBRichCodeBtn ).EmbedCode( modLibrary.tblCodeCode.AsString );
     end
     //new scale
     else if (vForm.Name= 'frmNewScale') and (vForm.FindComponent( 'PageControl') is TPageControl) then
     begin
        vForm.ActiveControl := (vForm.FindComponent( 'clDBRichCodeBtn' ) as TclDBRichCodeBtn );
        ( vForm.ActiveControl as TclDBRichCodeBtn ).EmbedCode( modLibrary.tblCodeCode.AsString );
     end
     //Edit Translation
     else if (vForm.Name= 'frmTranslate') and (vForm.FindComponent( 'pclPage' ) is TPageControl) then
     begin
        case (vForm.FindComponent( 'pclPage' ) as TPageControl).ActivePage.PageIndex of
         0 : vForm.ActiveControl := (vForm.FindComponent( 'rtfTrHead' ) as TclDBRichCodeBtn );
         1 : vForm.ActiveControl := (vForm.FindComponent( 'rtfTrText' ) as TclDBRichCodeBtn );
         2 : vForm.ActiveControl := (vForm.FindComponent( 'rtfTrScale' ) as TclDBRichCodeBtn );
        end;

        //Now the typecast should be safe
        if (vForm.FindComponent( 'pclPage' ) as TPageControl).ActivePage.PageIndex <= 2 then
           ( vForm.ActiveControl as TclDBRichCodeBtn ).EmbedCode( modLibrary.tblCodeCode.AsString );
     end
     else
        ( vForm.ActiveControl as TclDBRichCode ).EmbedCode( modLibrary.tblCodeCode.AsString );
     
     //fieldedcode := '';
     with modlibrary do
       if tblcodefielded.value <> 1 then
       begin
         tblcode.edit;
         tblcodefielded.value := 1;
         tblcode.post;
         //fieldedcode := tblcodefielded.asstring;
       end;
  end;
  (*
  if fieldedcode <> '' then
    with modlibrary.ww_Query do begin
      close;
      databasename := '_QualPro';
      sql.clear;
      sql.add('Update codes set fielded=1 where code='+fieldedcode);
      execsql;
    end;
  *)
end;

procedure TfrmCode.FindClick(Sender: TObject);
begin
  with modSupport.dlgLocate do
  begin
    Caption := 'Locate Code';
    DataSource := modLibrary.srcCode;
    SearchField := 'Description';
    btnNext.Enabled := Execute;
  end;
end;

procedure TfrmCode.NextClick(Sender: TObject);
begin
  btnNext.Enabled := modSupport.dlgLocate.FindNext;
end;

procedure TfrmCode.CloseClick(Sender: TObject);
begin
  Close;
end;

{ FINALIZATION SECTION }

{ resets the calling form on close:
    1. repositions calling form to the center of the screen
    2. pops up the code button on the calling form }

procedure TfrmCode.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Hide;
  with vForm do
  begin
    Position := poScreenCenter;
    ( FindComponent( 'btnCode' ) as TSpeedButton ).Down := False;
    //Translation
    if FindComponent( 'cmbLanguage' ) is TComboBox then
    ( FindComponent( 'cmbLanguage' ) as TComboBox ).ItemIndex := selectedLanguage; //GN02
  end;
  Action := caFree;
  frmCode := nil;
end;

end.
