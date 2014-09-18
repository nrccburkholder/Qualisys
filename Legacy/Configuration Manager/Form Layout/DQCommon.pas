unit DQCommon;

interface

uses
  SysUtils, windows, Messages, Classes, Graphics, Controls,
  Forms, Menus, StdCtrls, DBCtrls, Dialogs;

type
{  TSection = class(TPersistent)
    protected
    LangID:		Integer;
    Section_ID:		Integer;
    TabOrder:		String[5];
    Description:	String[60];
    SampleType:		Integer;
    PageSize:		Integer;
    ScalePosition:	Integer;
    ScaleWidth:		Integer;
    ScaleHeight:	Integer;
  end;

  TSubsection = class(TPersistent)
    protected
    LangID:		Integer;
    Section_ID:		Integer;
    Subsection_ID:	Integer;
    Description:	String[60];
  end;}

  TQuestion = class(TPersistent)
    public
    Core:		String[3];
    Short:		String[60];
    Scale:		Integer;
    HeadID:		Integer;
    HShort:		String[60];
    QTextHeight:	Integer;
    PageSize:		Integer;
    ScalePosition:	Integer;
    ScaleWidth:		Integer;
    ScaleHeight:	Integer;
    Name:               String[15];
    Section:		Integer;
    Subsection:		Integer;
    Language:		Integer;
    Width:		Integer;
  end;

{  TResponse = class(TShape)
    public
    Shape:		String[60];
    Left:		String[60];
    Scale:		Integer;
    HeadID:		Integer;
    HShort:		String[60];
  end;}

implementation

end.
