unit DBRichEdit;
{$D-}
{$L-}

interface

uses
  Windows, SysUtils, Messages, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  Menus, ComCtrls, DBCtrls, DBTables, DB, RichEdit, CDK_Comp, Buttons, Clipbrd;

const
  cAge = 1;
  cSex = 2;
  cDoc = 3;
  cText = 4;
  cBtnSize = 20;
  cBtnSpace = 3;
//  leftCode = '‹';
//  rightCode = '›';
  leftCode = '{';
  rightCode = '}';
  leftConstant = '«';
  rightConstant = '»';

var
  vAsText : Boolean;
  vAge, vSex, vDoc : string;

type
  EInvalidFieldType = class( Exception );
  EInvalidBlobFormat = class( Exception );
  EInvalidCodeEmbed = class( Exception );
  ECorruptedCode = class( Exception );
  EInvalidConstant = class( Exception );
  EMissingCodeTable = class( Exception );
  EInvalidTableStructure = class( Exception );

  TclDBRichEdit = class( TCustomRichEdit )
  private
    FDataLink: TFieldDataLink;
    FAutoDisplay : Boolean;
    FTextLoaded : Boolean;
    {FPaintControl : TPaintControl;}
    FAllowChange : Boolean;
    procedure DataChange(Sender: TObject); virtual;
    procedure EditingChange( Sender : TObject ); virtual;
    procedure UpdateData(Sender: TObject); virtual;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetReadOnly : Boolean;
    function GetField : TBlobField;
    procedure SetDataField(const newFieldName: string);
    procedure SetDataSource(newSource: TDataSource); virtual;
    procedure SetReadOnly( Value : Boolean );
    procedure SetAutoDisplay( Value : Boolean );
    procedure CheckFieldType( const Value : string );
    procedure WMCut( var Message : TMessage ); message WM_CUT;
    procedure WMPaste( var Message : TMessage ); message WM_PASTE;
    procedure WMLButtonDblClick( var Message : TWMLButtonDblClk ); message WM_LBUTTONDBLCLK;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure CMGetDataLink( var Message : TMessage ); message CM_GETDATALINK;
    procedure CNNotify( var Message : TWMNotify ); message CN_NOTIFY;
  protected
    procedure Notification( vComponent : TComponent; vOperation : TOperation ); override;
    procedure Change; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress( var Key : Char ); override;
{    procedure WndProc( var Message : TMessage ); override;}
    function ProtectChange(StartPos, EndPos: Integer): Boolean; virtual;
    function SaveClipboard(NumObj, NumChars: Integer): Boolean;
  public
    constructor Create( vOwner : TComponent ); override;
    destructor Destroy; override;
    procedure LoadText; virtual;
    procedure SaveText; virtual;
    property Field : TBlobField read GetField;
    property AllowChange : Boolean read FAllowChange write FAllowChange default False;
  published
    property Align;
    property Alignment;
    property AutoDisplay : Boolean read FAutoDisplay write SetAutoDisplay default True;
    property BorderStyle;
    property Color;
    property Ctl3D;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property HideScrollBars;
    property Lines;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property PlainText;
    property PopupMenu;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property WantReturns;
    property WantTabs;
    property WordWrap;
    property OnChange;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResizeRequest;
    property OnSelectionChange;
    property OnStartDrag;
    property OnProtectChange;
    property OnSaveClipboard;
  end;

  TclDBRichCode = class( TclDBRichEdit )
  private
    FMultiRecord : Boolean;
    FUpdating : Boolean;
    FCodeList : TStringList;
    FConstants : TDataSet;
    FCodes : TDataSet;
    procedure ReplaceConst( var vText : string );
    procedure UpdateList( const vText : string; vInsert : Boolean );
    procedure ChangeText;
    procedure SetMultiRecord( vValue : Boolean );
    function GetHaveCodeData : Boolean;
    procedure SetCodeData( vData : TDataSet );
    procedure SetConstData( vData : TDataSet );
    procedure SetDataSource( newSource: TDataSource ); override;
    procedure DataChange( Sender: TObject ); override;
    {procedure EditingChange( Sender : TObject ); override;}
    procedure UpdateData( Sender: TObject ); override;
    procedure NoCodeDataMessage;
    procedure CheckForValue;
    procedure CMExit(var Message: TCMExit);
    procedure WMCut( var Message : TMessage );
    procedure WMPaste( var Message : TMessage );
  protected
    procedure Change; override;
    procedure Notification( vComponent : TComponent; vOperation : TOperation ); override;
  public
    procedure ShowAsText;
    procedure ShowAsCode;
    constructor Create( vOwner : TComponent ); override;
    destructor Destroy; override;
    procedure LoadText; override;
    procedure SaveText; override;
    procedure EmbedCode( const vCode : string );
    procedure RemoveCode;
    procedure UpdateRichText( vButton : Byte );
    function GetPCL : TStrings;
    property CodeList : TStringList read FCodeList write FCodeList;
    property HaveCodeData : Boolean read GetHaveCodeData;
  published
    property MultiRecord : Boolean read FMultiRecord write SetMultiRecord default False;
    property CodeData : TDataSet read FCodes write SetCodeData;
    property ConstData : TDataSet read FConstants write SetConstData;
  end;

  TclDBRichCodeBtn = class( TclDBRichCode )
  private
    FBold : TSpeedButton;
    FItalic : TSpeedButton;
    FUnderline: TSpeedButton;
    procedure WMMove(var Msg: TWMMove); message WM_MOVE;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure SelectionChange; override;
    procedure DoEnter; override;
    procedure DoExit; override;
  protected
    procedure BoldClickHandler(Sender: TObject); virtual;
    procedure ItalicClickHandler(Sender: TObject); virtual;
    procedure UnderlineClickHandler(Sender: TObject); virtual;
    procedure SetParent(AParent: TWinControl); override;
    procedure AdjustPosition(newX, newY: Integer); virtual;
  public
    constructor Create( vOwner : TComponent ); override;
    destructor Destroy; override;
    procedure DoBold;
    procedure DoItalic;
    procedure DoUnderline;
  published
    property Height default 60;
  end;

  TclCodeToggle = class( TCompoundComponentPanel )
    Doc : TSpeedButton;
    Sex : TSpeedButton;
    Age : TSpeedButton;
    Text : TSpeedButton;
  private
    FOnDoc_Click : TNotifyEvent;
    FOnSex_Click : TNotifyEvent;
    FOnAge_Click : TNotifyEvent;
    FOnText_Click : TNotifyEvent;
    FButtonEnabled : Boolean;
    procedure SetEnabled( Value : Boolean );
    procedure FixDown( vButton : TSpeedButton );
    procedure Doc_ClickTransfer( Sender : TObject );
    procedure Sex_ClickTransfer( Sender : TObject );
    procedure Age_ClickTransfer( Sender : TObject );
  protected
    procedure CreateWindowHandle( const Params : TCreateParams ); override;
    procedure SendToRichEdit( vButton : Word );
  public
    constructor Create( vOwner : TComponent ); override;
    procedure Text_ClickTransfer( Sender : TObject );
  published
    property Enabled : Boolean read FButtonEnabled write SetEnabled default True;
    property OnDoc_Click : TNotifyEvent read FOnDoc_Click write FOnDoc_Click;
    property OnSex_Click : TNotifyEvent read FOnSex_Click write FOnSex_Click;
    property OnAge_Click : TNotifyEvent read FOnAge_Click write FOnAge_Click;
    property OnText_Click : TNotifyEvent read FOnText_Click write FOnText_Click;
  end;

procedure Register;

implementation

{ DBRichEdit }

constructor TclDBRichEdit.Create( vOwner : TComponent );
begin
  inherited Create( vOwner );
  inherited ReadOnly := False;
  ScrollBars := ssVertical;
  FAllowChange := False;
  FAutoDisplay := True;
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  {FPaintControl := TPaintControl.Create( Self, 'EDIT' );}
end;

destructor TclDBRichEdit.Destroy;
begin
{  FPaintControl.Free;}
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TclDBRichEdit.Notification( vComponent : TComponent; vOperation : TOperation );
begin
  inherited Notification( vComponent, vOperation );
  if ( vOperation = opRemove ) and
     ( FDataLink <> nil ) and
     ( vComponent = DataSource ) then
    DataSource := nil;
end;

procedure TclDBRichEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if FTextLoaded then
  begin
    if (( Key = VK_DELETE ) or (( Key = VK_INSERT ) and ( ssShift in Shift ))) or
       ( Key = VK_BACK ) then FDataLink.Edit;
  end
  else
    Key := 0;
end;

procedure TclDBRichEdit.KeyPress( var Key : Char );
begin
  inherited KeyPress( Key );
  if FTextLoaded then
  begin
    if ( Key in [ #32 .. #255 ] ) and
       ( FDataLink.Field <> nil ) and
      not FDataLink.Field.IsValidChar( Key ) then
    begin
      MessageBeep( 0 );
      Key := #0;
    end;
    case Key of
      ^I, ^J, ^M, ^V, ^X, #32 .. #255 : FDataLink.Edit;
      #27 : FDataLink.Reset;
    end;
  end
  else
  begin
    if Key = #13 then
    begin
      LoadText;
      FTextLoaded := False;
    end
    else
      inherited;
    Key := #0;
  end;
end;

procedure TclDBRichEdit.Change;
begin
  if FTextLoaded then FDataLink.Modified;
  FTextLoaded := True;
  inherited Change;
end;

function TclDBRichEdit.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

function TclDBRichEdit.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TclDBRichEdit.SetDataField(const newFieldName: string);
begin
  CheckFieldType( newFieldName );
  FDataLink.FieldName := newFieldName;
end;

procedure TclDBRichEdit.SetDataSource(newSource: TDataSource);
begin
  FDataLink.DataSource := newSource;
  if newSource <> nil then newSource.FreeNotification( Self );
end;

function TclDBRichEdit.GetReadOnly : Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TclDBRichEdit.SetReadOnly( Value : Boolean );
begin
  FDataLink.ReadOnly := Value;
end;

function TclDBRichEdit.GetField : TBlobField;
begin
  Result := ( FDataLink.Field as TBlobField );
end;

procedure TclDBRichEdit.CheckFieldType( const Value : string );
begin
  if ( Value <> '' ) and
     ( FDataLink <> nil ) and
     ( FDataLink.DataSet <> nil ) and
     ( FDataLink.DataSet.Active ) then
    if not ( FDataLink.DataSet.FieldByName( Value ).DataType in [ ftBlob, ftMemo, ftFmtMemo ] ) then
      raise EInvalidFieldType.Create( 'The DBRichEdit component can only be ' +
          'connected to Blob or Formatted Memo fields' );
end;

procedure TclDBRichEdit.LoadText;
begin
  if not FTextLoaded then
  try
    FAllowChange := True;
    if Field <> nil then Lines.Assign( Field );
    FAllowChange := False;
    FTextLoaded := True;
    EditingChange( Self );
  except
    on EStreamError do
      raise EInvalidBlobFormat.Create( 'Blob field format is incompatible with rich text' );
  end;
end;

procedure TclDBRichEdit.DataChange(Sender: TObject);
begin
  if ( FDataLink.Field <> nil ) and FDataLink.Active then
    if FAutoDisplay then
    begin
      if not FDataLink.Editing then
      begin
        FTextLoaded := False;
        LoadText;
      end;
    end
    else
    begin
      Lines.Text := '(BLOB)';
      FTextLoaded := False;
    end
  else
  begin
    if csDesigning in ComponentState then
      Lines.Text := Name
    else
      Lines.Text := '';
    FTextLoaded := False;
  end;
end;

procedure TclDBRichEdit.EditingChange( Sender : TObject );
begin
  inherited ReadOnly := not ( FDataLink.Editing and FTextLoaded );
end;

procedure TclDBRichEdit.UpdateData(Sender: TObject);
begin
  SaveText;  {crashes here}
end;

procedure TclDBRichEdit.SaveText;
begin
  { cancel by raising an exception here }
  try
    Field.Assign( Lines );
  except

  end;
end;

procedure TclDBRichEdit.SetAutoDisplay( Value : Boolean );
begin
  if FAutoDisplay <> Value then
  begin
    FAutoDisplay := Value;
    DataChange( nil );
  end;
end;

procedure TclDBRichEdit.CNNotify( var Message : TWMNotify );
begin
  with Message.NMHdr^ do
    case code of
      EN_SELCHANGE: SelectionChange;
      EN_REQUESTRESIZE: RequestSize(PReqSize(Pointer(Message.NMHdr))^.rc);
      EN_SAVECLIPBOARD:
        with PENSaveClipboard(Pointer(Message.NMHdr))^ do
          if not SaveClipboard(cObjectCount, cch) then Message.Result := 1;
      EN_PROTECTED:
        with PENProtected(Pointer(Message.NMHdr))^.chrg do
          if not ( ProtectChange(cpMin, cpMax) or FAllowChange ) then
            Message.Result := 1;
    end;
end;

function TclDBRichEdit.SaveClipboard(NumObj, NumChars: Integer): Boolean;
begin
  Result := True;
  if Assigned(OnSaveClipboard) then OnSaveClipboard(Self, NumObj, NumChars, Result);
end;

function TclDBRichEdit.ProtectChange(StartPos, EndPos: Integer): Boolean;
begin
  Result := False;
  if Assigned(OnProtectChange) then OnProtectChange(Self, StartPos, EndPos, Result);
end;

{procedure TclDBRichEdit.WndProc( var Message : TMessage );
begin
  with Message do
    if ( Msg = WM_CREATE ) or
       ( Msg = WM_WINDOWPOSCHANGED ) or
       ( Msg = CM_FONTCHANGED ) then
      FPaintControl.DestroyHandle;
  inherited;
end;}

procedure TclDBRichEdit.CMExit(var Message: TCMExit);
begin
  try
    FDataLink.UpdateRecord;
  except
    SetFocus;
    raise;
  end;
  inherited;
end;

procedure TclDBRichEdit.WMLButtonDblClick( var Message : TWMLButtonDblClk );
begin
  if not FTextLoaded then
  begin
    LoadText;
    FTextLoaded := False;
  end
  else
    inherited;
end;

procedure TclDBRichEdit.WMCut( var Message : TMessage );
begin
  FDataLink.Edit;
  inherited;
end;

procedure TclDBRichEdit.WMPaste( var Message : TMessage );
begin
  FDataLink.Edit;
  inherited;
end;

procedure TclDBRichEdit.CMGetDataLink( var Message : TMessage );
begin
  Message.Result := Integer( FDataLink );
end;

{ DBRichCode }

constructor TclDBRichCode.Create( vOwner : TComponent );
begin
  inherited Create( vOwner );
  FUpdating := False;
  FMultiRecord := False;
  FCodeList := TStringList.Create;
end;

destructor TclDBRichCode.Destroy;
begin
  FCodeList.Free;
  inherited Destroy;
end;

procedure TclDBRichCode.Notification( vComponent : TComponent; vOperation : TOperation );
begin
  inherited Notification( vComponent, vOperation );
  if vOperation = opRemove then
  begin
    if vComponent = FCodes then CodeData := nil;
    if vComponent = FConstants then ConstData := nil;
  end;
end;

procedure TclDBRichCode.SetMultiRecord( vValue : Boolean );
begin
  if FMultiRecord <> vValue then
  begin
    if vValue then CheckForValue;
    FMultiRecord := vValue;
    DataChange( nil );
    ReadOnly := vValue;
  end;
end;

procedure TclDBRichCode.CheckForValue;
var
  vFields : TStringList;
begin
  if FDataLink.DataSource = nil then Exit;
  vFields := TStringList.Create;
  try
    FDataLink.DataSource.DataSet.GetFieldNames( vFields );
    if vFields.IndexOf( 'Item' ) = -1 then
      raise EInvalidTableStructure.Create( 'DataSet has no "Item" field' );
  finally
    vFields.Free;
  end;
end;

function TclDBRichCode.GetHaveCodeData : Boolean;
begin
  Result := Assigned( FCodes ) and FCodes.Active and Assigned( FConstants ) and FConstants.Active ;
end;

procedure TclDBRichCode.SetCodeData( vData : TDataSet );
begin
  if FCodes <> vData then
  begin
    FCodes := vData;
    DataChange( nil );
  end;
end;

procedure TclDBRichCode.SetConstData( vData : TDataSet );
begin
  if FConstants <> vData then
  begin
    FConstants := vData;
    DataChange( nil );
  end;
end;

procedure TclDBRichCode.SetDataSource( newSource: TDataSource );
begin
  if FMultiRecord then
    CheckForValue;
  inherited;
end;

function TclDBRichCode.GetPCL : TStrings;
begin
  { output rich text as PCL }
	result := nil;  
end;

(*procedure TclDBRichCode.EditingChange( Sender : TObject );
begin
  if FMultiRecord or ( vAsText and not HaveCodeData ) then
    ReadOnly := True  {  }
  else
    inherited;
end;  *)

procedure TclDBRichCode.UpdateData(Sender: TObject);
begin
  if not FMultiRecord then inherited;
end;

procedure TclDBRichCode.LoadText;
var
  i : Byte;
  vRTF : TRichEdit;
  vRTFLen,MultiLen : integer;
begin
  Lines.BeginUpdate;
  try
    if FMultiRecord then begin
      FAllowChange := True;
      ReadOnly := False;
      FTextLoaded := True;
      FDataLink.Edit;
      FUpdating := True;
      Clear;
      with FDataLink.DataSet do
        if RecordCount > 0 then begin
          DisableControls;
          try
            vRTF := TRichEdit.Create( nil );
            try
              vRTF.Parent := Self;
              vRTF.Visible := False;
              if not BOF then First;
              try
                while not eof do begin
                  if fDataLink.Dataset.fieldbyname('Item').value <> null then begin
                    vRTF.Lines.Assign( GetField );
                    lines.add(vRTF.lines[0]);
                    vRTF.SelectAll;
                    vRTFLen := vRTF.selLength;
                    selectall;
                    multiLen := selLength;
                    for i := 0 to vRTFLen-1 do begin
                      VRTF.SelStart := i;
                      vRTF.SelLength := 1;
                      selStart := multiLen-vRTFLen+i-2;
                      selLength := 1;
                      SelAttributes := vRTF.SelAttributes;
                    end;
                  end;
                  (*
                  vRTF.SelectAll;
                  vRTF.CopyToClipboard;
                  SelText := {FieldByName( 'Item' ).AsString +} '> ';
                  PasteFromClipboard;
                  *)
                  Next;
                end;
              except
                on EStreamError do begin
                  raise EInvalidBlobFormat.Create( 'Blob field format is incompatible with rich text' );
                  FTextLoaded := False;
                end;
              end;
              Clipboard.Clear;
              if not BOF then First;
            finally
              vRTF.Free;
            end;
          finally
            EnableControls;
          end;
          FAllowChange := False;
          ReadOnly := True;
          FTextLoaded := True;
          FUpdating := False;
        end;
    end else
      inherited;
    if vAsText then ShowAsText;
  finally
    Lines.EndUpdate;
  end;
end;

procedure TclDBRichCode.SaveText;
begin
  if not ( FMultiRecord or not FTextLoaded ) then
  begin
    Lines.BeginUpdate;
    try
      if not HaveCodeData then Exit;
      if vAsText then ShowAsCode;
      datasource.dataset.edit;
      inherited;
      if vAsText then ShowAsText;
{      datasource.dataset.post;}
    finally
      Lines.EndUpdate;
    end;
  end;
end;

procedure TclDBRichCode.Change;
begin
  if not FMultiRecord then inherited Change;
end;

procedure TclDBRichCode.DataChange(Sender: TObject);
begin
  if not FUpdating then inherited;
end;

procedure TclDBRichCode.CMExit(var Message: TCMExit);
begin
  if not FMultiRecord then
  try
    FDataLink.UpdateRecord;
  except
    SetFocus;
    raise;
  end;
  inherited;
end;

procedure TclDBRichCode.WMCut( var Message : TMessage );
begin
  if not FMultiRecord and HaveCodeData then FDataLink.Edit;
  inherited;
end;

procedure TclDBRichCode.WMPaste( var Message : TMessage );
begin
  if not FMultiRecord and HaveCodeData then FDataLink.Edit;
  inherited;
end;


procedure TclDBRichCode.EmbedCode( const vCode : string );
var
  vText : string;
begin
  if not FMultiRecord and HaveCodeData then begin
    if SelAttributes.Protected then
      raise EInvalidCodeEmbed.Create( 'A code can not be embeded inside of another code' );
    if vAsText then begin
      vText := CodeData.FieldByName( 'Text' ).Value;
      if Pos( leftConstant, vText ) > 0 then ReplaceConst( vText );
      UpdateList( vCode + '=' + vText, True );
    end else
      vText := leftCode + vCode + rightCode;
    with SelAttributes do begin
      Color := clGreen;
      Protected := True;
    end;
    FDataLink{.DataSource}.Edit;
    AllowChange := True;
    SelText := vText;
    AllowChange := False;
  end; { if no code table?? }
end;

procedure TclDBRichCode.RemoveCode;
var
  vStart, vEnd : Integer;
begin
  if not FMultiRecord then
  begin
    Lines.BeginUpdate;
    vEnd := SelStart + SelLength;
    while (SelAttributes.Protected) and (SelStart>0) do SelStart := Pred( SelStart );
    vStart := SelStart;
    SelStart := vEnd;
    while (SelAttributes.Protected) and (SelStart<length(lines[0])) do SelStart := Succ( SelStart );
    if SelStart>=length(lines[0])-1 then
      vEnd := 1 + Selstart - vStart
    else
      vEnd := SelStart - vStart;
    SelStart := vStart;
    SelLength := vEnd;
    FDataLink{.DataSource}.Edit;
    AllowChange := True;
    SelText := '';
    AllowChange := False;
    if vAsText then UpdateList( '', False );
    Lines.EndUpdate;
  end;
end;

procedure TclDBRichCode.UpdateRichText( vButton : Byte );
begin
  case vButton of
    1..3 : ChangeText;
    4 : if vAsText then ShowAsText else ShowAsCode;
  end;
end;

procedure TclDBRichCode.UpdateList( const vText : string; vInsert : Boolean );
var
  i, vItem, vOrigin : Word;
  vSwitch : Boolean;
begin
  vItem := 0;
  if CodeList.Count > 0 then
  begin
    Lines.BeginUpdate;
    try
      vOrigin := SelStart;
      vSwitch := True;
      for i := 1 to vOrigin do
      begin
        SelStart := i;
        if vSwitch then
        begin
          if SelAttributes.Protected then
          begin
            Inc( vItem );
            vSwitch := False;
          end;
        end
        else if not SelAttributes.Protected then vSwitch := True;
      end;
      SelStart := vOrigin;
    finally
      Lines.EndUpdate;
    end;
  end;
  if vInsert then
    CodeList.Insert( vItem, vText )
  else
    CodeList.Delete( vItem );
end;

procedure TclDBRichCode.ShowAsText;
var
  vCode, vTest : Integer;
  vText : string;
  vModified : Boolean;
begin
  vModified := Modified;
  CodeList.Clear;
  vText := Lines.Text;
  AllowChange := True;
  Lines.BeginUpdate;
  if HaveCodeData then
    try
      while Pos( leftCode, vText ) > 0 do begin
        SelStart := FindText( leftCode, 0, GetTextLen, [ ] );
        SelLength := Succ( FindText( rightCode, SelStart, 5, [ ] ) - SelStart );
        Val( Copy( SelText, 2, SelLength - 2 ), vCode, vTest );
        if ( vTest <> 0 ) and ( MessageDlg( 'Embedded code has been corrupted',
            mtError, [mbOk], 0 ) = mrOK ) then
          Break   { what action here ? }
        else begin               
          if CodeData.locate('Code',vCode, []) then
            vText := CodeData.fieldbyname('Text').text
          else
            if CodeData.locate('Code',vCode, []) then
              vText := CodeData.fieldbyname('Text').text
            else begin
              vText := '[Code '+inttostr(vCode)+' not found!]';
              {form2.label1.caption := vSex;
              form2.label2.caption := vAge;
              form2.label3.caption := vDoc;
              form2.label4.caption := inttostr(vCode);
              form2.showmodal;}
            end;
          {vText := CodeData.Lookup( 'Code', vCode, 'Text' ); }
        end;
        if Pos( leftConstant, vText ) > 0 then ReplaceConst( vText );
        SelText := vText;
        CodeList.Append( IntToStr( vCode ) + '=' + vText );
        vText := Lines.Text;
      end;
    finally
      AllowChange := False;
      SelStart :=0;
      Lines.EndUpdate;
    end
  else
    try
      NoCodeDataMessage;
    finally
      AllowChange := False;
      SelStart := 0;
      Lines.EndUpdate;
    end;
  Modified := vModified;
end;

procedure TclDBRichCode.ReplaceConst( var vText : string );
var
  vStart, vEnd : Integer;
  vConst : string;
  vPosses : Boolean;
begin
  if HaveCodeData then
    while Pos( leftConstant, vText ) > 0 do begin
      vPosses := False;
      vStart := Pos( leftConstant, vText );
      vEnd := Pos( rightConstant, vText );
      vConst := Copy( vText, Succ( vStart ), Pred( vEnd - vStart ));
      Delete( vText, vStart, Succ( vEnd - vStart ));
      if Pos( '_''s', vConst ) > 0 then begin
        Delete( vConst, Length( vConst ) - 2, 3 );
        vPosses := True;
      end;
      if ConstData.Locate( 'Constant', vConst, [ ] ) then begin
        vConst := ConstData.FieldByName( 'Value' ).Value;
        if vPosses then
          if vConst[ Length( vConst ) ] in [ 's', 'z' ] then
            vConst := vConst + ''''
          else
            vConst := vConst + '''s';
        Insert( vConst, vText, vStart );
      end else
        if MessageDlg( 'Invalid Constant: ' + vConst, mtError, [ mbOK ], 0 ) = mrOK then
            Insert( 'Invalid Constant', vText, vStart ); { what action here? }
    end
  else
    NoCodeDataMessage;
end;

procedure TclDBRichCode.NoCodeDataMessage;
begin
  AllowChange := True;
  Lines.Clear;
  SelAttributes.Color := clRed;
  SelAttributes.Protected := True;
  SelText := 'The Code Table is not available to make substitutions.';
  FTextLoaded := False;
  AllowChange := False;
end;

procedure TclDBRichCode.ChangeText;
var
  i, vCode,ss,sl : Integer;
  vText : string;
  vModified : Boolean;
begin
  with CodeList do begin
    vModified := Modified;
    Lines.BeginUpdate;
    if HaveCodeData then
      try
        codedata.refresh;
        SS := 0;
        for i := 0 to Pred( Count ) do begin
          vText := Strings[ i ];
          vText := Copy( vText, Succ( Pos( '=', vText )), Length( vText ) );
          SL := length( vText );
          repeat
            SS := FindText(  vText, SS, GetTextLen, [ stMatchCase ] );
            if ss = -1 then break;
            SelStart := SS;
            SelLength := SL;
            if SelAttributes.Protected then break;
            SS := succ(SS);
          until false;
          vCode := StrToInt( Names[ i ] );
          if CodeData.locate('Code',vCode, []) then
            vText := CodeData.fieldbyname('Text').text
          else
            if CodeData.locate('Code',vCode, []) then
              vText := CodeData.fieldbyname('Text').text
            else begin
              vText := '[Code '+inttostr(vCode)+' not found!]';
              {form2.label1.caption := vSex;
              form2.label2.caption := vAge;
              form2.label3.caption := vDoc;
              form2.label4.caption := inttostr(vCode);
              form2.showmodal;}
            end;
          {vText := CodeData.Lookup( 'Code', vCode, 'Text' );}
          if Pos( leftConstant, vText ) > 0 then ReplaceConst( vText );
          AllowChange := True;
          SelText := vText;
          AllowChange := False;
          Strings[ i ] := ( IntToStr( vCode ) + '=' + vText );
        end;
      finally
        SelStart := 0;
        Lines.EndUpdate;
      end
    else
      try
        NoCodeDataMessage;
      finally
        SelStart := 0;
        Lines.EndUpdate;
      end;
    Modified := vModified;
  end;
end;

procedure TclDBRichCode.ShowAsCode;
var
  i,ss,sl : Integer;
  vCode, vText : string;
  vModified : Boolean;
begin
  if HaveCodeData then
    with CodeList do
    begin
      vModified := Modified;
      Lines.BeginUpdate;
      try
        SS := 0;
        for i := 0 to Pred( Count ) do
        begin
          vText := Strings[ i ];
          vText := Copy( vText, Succ( Pos( '=', vText )), Length( vText ) );
          sl := length(vtext);
          repeat
            SS := FindText(  vText, SS, GetTextLen, [ stMatchCase ] );
            if ss = -1 then break;
            SelStart := ss;
            SelLength := sl;
            if SelAttributes.Protected then break;
            SS := succ(SS);
          until false;
          vCode := Names[ i ];
          AllowChange := True;
          SelText := leftCode + vCode + rightCode;
          AllowChange := False;
        end;
      finally
        SelStart := 0;
        Lines.EndUpdate;
      end;
      Modified := vModified;
    end
  else
    LoadText;
  CodeList.Clear;
end;

{ BDRichCodeBtn }

procedure TclDBRichCodeBtn.BoldClickHandler(Sender: TObject);
begin
  if SelLength > 0 then
    with SelAttributes do if FBold.Down then
      Style := Style + [ fsBold ]
    else
      Style := Style - [ fsBold ]
  else
    FBold.Down := not FBold.Down;
end;

procedure TclDBRichCodeBtn.ItalicClickHandler(Sender: TObject);
begin
  if SelLength > 0 then
    with SelAttributes do if FItalic.Down then
      Style := Style + [ fsItalic ]
    else
      Style := Style - [ fsItalic ]
  else
    FItalic.Down := not FItalic.Down;
end;

procedure TclDBRichCodeBtn.UnderlineClickHandler(Sender: TObject);
begin
  if SelLength > 0 then
    with SelAttributes do if FUnderline.Down then
      Style := Style + [ fsUnderline ]
    else
      Style := Style - [ fsUnderline ]
  else
    FUnderline.Down := not FUnderline.Down;
end;

procedure TclDBRichCodeBtn.DoBold;
begin
  FBold.Down := not FBold.Down;
  BoldClickHandler( nil );
end;

procedure TclDBRichCodeBtn.DoItalic;
begin
  FItalic.Down := not FItalic.Down;
  ItalicClickHandler( nil );
end;

procedure TclDBRichCodeBtn.DoUnderline;
begin
  FUnderline.Down := not FUnderline.Down;
  UnderlineClickHandler( nil );
end;

procedure TclDBRichCodeBtn.SetParent( AParent : TWinControl );
begin
  if ( Owner = nil ) or not ( csDestroying in Owner.ComponentState ) then
  begin
    FBold.Parent := AParent;
    FItalic.Parent := AParent;
    FUnderline.Parent := AParent;
  end;
  inherited SetParent( AParent );
end;

procedure TclDBRichCodeBtn.AdjustPosition( newX, newY: Integer );
begin
  if FBold <> nil then
  begin
    FBold.SetBounds( newX + Width + cBtnSpace, newY, cBtnSize, cBtnSize);
    FItalic.SetBounds( FBold.Left, newY + cBtnSize, cBtnSize, cBtnSize );
    FUnderline.SetBounds( FBold.Left, newY + 2 * cBtnSize, cBtnSize, cBtnSize );
  end;
end;

procedure TclDBRichCodeBtn.WMMove( var Msg : TWMMove );
begin
  inherited;
  AdjustPosition( Msg.XPos - 2, Msg.YPos - 2 );
end;

procedure TclDBRichCodeBtn.WMSize( var Msg : TWMSize );
begin
  inherited;
  AdjustPosition( Left, Top );
end;

destructor TclDBRichCodeBtn.Destroy;
begin
  if ( FBold <> nil ) and ( FBold.Parent = nil ) then
  begin
    FBold.Free;
    FItalic.Free;
    FUnderline.Free;
  end;
  inherited Destroy;
end;

constructor TclDBRichCodeBtn.Create( vOwner : TComponent );
begin
  inherited Create( vOwner );
  Height := 60;
  FBold := TSpeedButton.Create( nil );
  FItalic := TSpeedButton.Create( nil );
  FUnderline := TSpeedButton.Create( nil );
  with FBold do
  begin
    AllowAllUp := True;
    Caption := 'B';
    Enabled := False;
    Font.Name := 'Times New Roman';
    Font.Size := 10;
    Font.Style := [ fsBold ];
    GroupIndex := 1;
    Height := cBtnSize;
    Hint := 'Bold|Toggles selected text between bold and normal';
    Width := cBtnSize;
    OnClick := BoldClickHandler;
  end;
  with FItalic do
  begin
    AllowAllUp := True;
    Caption := 'I';
    Enabled := False;
    Font.Name := 'Times New Roman';
    Font.Size := 10;
    Font.Style := [ fsItalic ];
    GroupIndex := 2;
    Height := cBtnSize;
    Hint := 'Italic|Toggles selected text between italic and normal';
    Width := cBtnSize;
    OnClick := ItalicClickHandler;
  end;
  with FUnderline do
  begin
    AllowAllUp := True;
    Caption := 'U';
    Enabled := False;
    Font.Name := 'Times New Roman';
    Font.Size := 10;
    Font.Style := [ fsUnderline ];
    GroupIndex := 3;
    Height := cBtnSize;
    Hint := 'Underline|Toggles selected text between underline and normal';
    Width := cBtnSize;
    OnClick := UnderlineClickHandler;
  end;
end;

procedure TclDBRichCodeBtn.SelectionChange;
begin
  FBold.Down := fsBold in SelAttributes.Style;
  FItalic.Down := fsItalic in SelAttributes.Style;
  FUnderline.Down := fsUnderline in SelAttributes.Style;
  inherited;
end;

procedure TclDBRichCodeBtn.DoEnter;
begin
  FBold.Enabled := True;
  FItalic.Enabled := True;
  FUnderline.Enabled := True;
  inherited;
end;

procedure TclDBRichCodeBtn.DoExit;
begin
  FBold.Enabled := False;
  FItalic.Enabled := False;
  FUnderline.Enabled := False;
  inherited;
end;

{ CodeToggle }

constructor TclCodeToggle.Create( vOwner : TComponent );
begin
  inherited Create( vOwner );
  Width := 100;
  Height := 25;
{  BevelOuter := bvNone;}
  FButtonEnabled := True;
  LockWidth := True;
  LockHeight := True;
  OutsideBorderTop := 0;
  OutsideBorderLeft := 0;
  OutsideBorderBottom := 0;
  OutsideBorderRight := 0;
  ParentShowHint := False;
  ShowHint := True;
  TabOrder := 0;

  Doc := TSpeedButton.Create( Self );
  Doc.Parent := Self;

  Sex := TSpeedButton.Create( Self );
  Sex.Parent := Self;

  Age := TSpeedButton.Create( Self );
  Age.Parent := Self;

  Text := TSpeedButton.Create( Self );
  Text.Parent := Self;
end;

procedure TclCodeToggle.CreateWindowHandle( const Params : TCreateParams );
begin
  inherited CreateWindowHandle( Params );
  with Doc do
  begin
    Tag := 4;
    Left := 75;
    Top := 0;
    Width := 25;
    Height := 25;
    Hint := 'Doctor Toggle';
    Caption := 'doc';
    AllowAllUp := True;
    GroupIndex := 4;
    Down := ( vDoc = 'Group' );
    OnClick := Doc_ClickTransfer;
  end;
  with Sex do
  begin
    Tag := 3;
    Left := 50;
    Top := 0;
    Width := 25;
    Height := 25;
    Hint := 'Gender Toggle';
    Caption := 'sex';
    AllowAllUp := True;
    GroupIndex := 3;
    Down := ( vSex = 'Female' );
    OnClick := Sex_ClickTransfer;
  end;
  with Age do
  begin
    Tag := 2;
    Left := 25;
    Top := 0;
    Width := 25;
    Height := 25;
    Hint := 'Age Toggle';
    Caption := 'age';
    AllowAllUp := True;
    GroupIndex := 2;
    Down := ( vAge = 'Minor' );
    OnClick := Age_ClickTransfer;
  end;
  with Text do
  begin
    Tag := 1;
    Left := 0;
    Top := 0;
    Width := 25;
    Height := 25;
    Hint := 'Code Toggle';
    Caption := 'text';
    AllowAllUp := True;
    GroupIndex := 1;
    Down := not vAsText;
    OnClick := Text_ClickTransfer;
  end;
end;

procedure TclCodeToggle.SetEnabled( Value : Boolean );
begin
  if Value <> FButtonEnabled then
  begin
    FButtonEnabled := Value;
    Doc.Enabled := Value;
    Age.Enabled := Value;
    Sex.Enabled := Value;
    Text.Enabled := Value;
    if Value then
    begin
      FixDown( Doc );
      FixDown( Age );
      FixDown( Sex );
      FixDown( Text );
    end;
  end;
end;

procedure TclCodeToggle.FixDown( vButton : TSpeedButton );
begin
  if vButton.Down then
  begin
    vButton.Down := False;
    vButton.Down := True;
  end;
end;

procedure TclCodeToggle.SendToRichEdit( vButton : Word );
var
  i, j : Integer;
begin
  with Screen do
    for i := 0 to Pred( FormCount ) do
      for j := 0 to Pred( Forms[ i ].ComponentCount ) do
        if Forms[ i ].Components[ j ] is TclDBRichCode then
          TclDBRichCode( Forms[ i ].Components[ j ] ).UpdateRichText( vButton );

       { case Forms[ i ].Components[ j ].Tag of
          27 : TclDBRichEditor( Forms[ i ].Components[ j ] ).UpdateRichText( vButton );
          28 : TclDBRichViewer( Forms[ i ].Components[ j ] ).UpdateRichText( vButton );
        end; }
end;

procedure TclCodeToggle.Doc_ClickTransfer( Sender : TObject );
begin
  if ( Sender as TSpeedButton ).Down then vDoc := 'Group' else vDoc := 'Doctor';
  if vAsText then SendToRichEdit( cDoc );
  if ( Assigned( FOnDoc_Click ) ) then FOnDoc_Click( Self );
end;

procedure TclCodeToggle.Sex_ClickTransfer( Sender : TObject );
begin
  if ( Sender as TSpeedButton ).Down then vSex := 'Female' else vSex := 'Male';
  if vAsText then SendToRichEdit( cSex );
  if ( Assigned( FOnSex_Click ) ) then FOnSex_Click( Self );
end;

procedure TclCodeToggle.Age_ClickTransfer( Sender : TObject );
begin
  if ( Sender as TSpeedButton ).Down then vAge := 'Minor' else vAge := 'Adult';
  if vAsText then SendToRichEdit( cAge );
  if ( Assigned( FOnAge_Click ) ) then FOnAge_Click( Self );
end;

procedure TclCodeToggle.Text_ClickTransfer( Sender : TObject );
begin
  vAsText := ( not( Sender as TSpeedButton ).Down );
  SendToRichEdit( cText );
  if ( Assigned( FOnText_Click ) ) then FOnText_Click( Self );
end;

{ Register }

procedure Register;
begin
  RegisterClass( TSpeedButton );
  RegisterComponents( 'NRC', [ TclDBRichEdit, TclDBRichCode, TclDBRichCodeBtn, TclCodeToggle ] );
end;

initialization
  vAge := 'Adult';
  vSex := 'Male';
  vDoc := 'Doctor';
  vAsText := False;

end.
