unit tMapping;

{*******************************************************************************
Program Modifications:

-------------------------------------------------------------------------------
Date        ID     Description
-------------------------------------------------------------------------------
11/17/2014  CB01   class to hold Samplet Unit - Cover Letter - Artifact text box mappings
********************************************************************************}

interface

uses SysUtils;

type
  BasicMapping = record
    SampleUnit : integer;
    CoverLetterName : string;
    CoverLetterTextBox : string;
    ArtifactName : string;
    ArtifactTextBox : string;
  end;

  MappingSet = array[0..100] of BasicMapping;

  Function FormattedMapping(mapping : BasicMapping) : string;
  Function AssignBasicMapping(SUnit : integer; CLName, CLTextBox, AName, ATextBox : string) : BasicMapping;

implementation

  Function FormattedMapping(mapping : BasicMapping) : string;
  begin
    with mapping do
      result := IntToStr(SampleUnit) + '->' + CoverLetterName + '.' + CoverLetterTextBox + '<=' + ArtifactName + ArtifactTextBox + '! ';
  end;

  Function AssignBasicMapping(SUnit : integer; CLName, CLTextBox, AName, ATextBox : string) : BasicMapping;
  begin
    with result do begin
      SampleUnit := SUnit;
      CoverLetterName := CLName;
      CoverLetterTextBox := CLTextBox;
      ArtifactName := AName;
      ArtifactTextBox := ATextBox;
    end;
  end ;

end.
