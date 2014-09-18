unit fSectProperties;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TfrmSectProperties = class(TForm)
    CancelBtn: TButton;
    OKbtn: TButton;
    lblName: TLabel;
    editName: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSectProperties: TfrmSectProperties;

implementation

{$R *.DFM}

procedure TfrmSectProperties.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if (modalresult=mrOK) and (trim(editName.text) = '') then begin
    messagedlg('Section Name cannot be blank.',mterror,[mbok],0);
    Action := caNone;
  end else
    Action := caHide;
end;

end.
