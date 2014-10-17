VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsSaveTagFields"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'-----------------------------------------------------------------
' Copyright © National Research Corporation
'
' Routine Name:
'
' Created By:       CGA
'         Date:     00-00-0000
'
' Description:
'
' Parameters:
'       Name        Type        Description
'
' Required References:
'       Microsoft ActiveX Data Objects 2.5 Library
'       OLE Automation
'       DBTagFields
'       MetaDataView
'
' Revisions:
'       Date        By      Description
'       09-28-2002  SH      Changed from Microsoft ActiveX Data
'                           Objects 1.5 Library to 2.5.
'       10-03-2002  SH      Recompiled with VB6.0 and moved DLL to
'                           \components\QualiSysDLLs\.
'       01-17-2006  DC      Removed all code that displays the status
'                           dialog because it crashes when called from
'                           a .NET application
'-----------------------------------------------------------------

Option Explicit

Dim SurveyId

Public Sub Go(ByVal lngStudyId As Long, ByVal lngSurveyId As Long, Optional bolEditMode As Boolean)
    
    On Error Resume Next
    
    frmMain.lngStudyId = lngStudyId
    frmMain.lngSurveyId = lngSurveyId
    frmMain.bolEditable = bolEditMode
    frmMain.Show vbModal

End Sub

Public Function GetCommandLine(Optional MaxArgs) As Long
    
    'Declare variables.
    Dim C, CmdLine, CmdLnLen, InArg, I, NumArgs
    
    NumArgs = 0: InArg = False
    
    'Make array of the correct size.
    ReDim ArgArray(MaxArgs)
    
    'Get command line arguments.
    CmdLine = Command()
    CmdLnLen = Len(CmdLine)
    
    'Go thru command line one character
    'at a time.
    For I = 1 To CmdLnLen
        C = Mid(CmdLine, I, 1)

        'Test for space or tab.
        If (C <> " " And C <> vbTab) Then
            'Neither space nor tab.
            'Test if already in argument.
            If Not InArg Then
                'New argument begins.
                'Test for too many arguments.
                If NumArgs = MaxArgs Then Exit For
                NumArgs = NumArgs + 1
                InArg = True
            End If
            'Concatenate character to current argument.
            ArgArray(NumArgs) = ArgArray(NumArgs) & C
        Else
            'Found a space or tab.
            'Set InArg flag to False.
            InArg = False
        End If
    Next I
    
    'Resize array just enough to hold arguments.
    ReDim Preserve ArgArray(NumArgs)
    
    'Return Array in Function name.
    GetCommandLine = ArgArray(0)
    
End Function

Public Sub SaveTagLocations(ByVal lngSurveyId As Long)
    
    Dim dbTagConnection As New DBTagFields.clsTagFields
    Dim varQuestions As Variant
    Dim X As Long
    
    SurveyId = lngSurveyId
    dbTagConnection.DelSurveyLocations SurveyId
    varQuestions = dbTagConnection.SelQuestions(lngSurveyId)
    
    If Not IsEmpty(varQuestions) Then
        For X = 0 To UBound(varQuestions, 2)
            ParseQuestion IIf(IsNull(varQuestions(1, X)), " ", varQuestions(1, X)), varQuestions(0, X), varQuestions(2, X)
        Next X
    End If

End Sub

' This is used to location all the tags and there
' positions within the text
Private Function ParseQuestion(ByVal strQuestion As String, ByVal lngQuestionId As Long, ByVal lngLangID As Long) As Long
    
    Dim dbTagConnection As DBTagFields.clsTagFields
    Dim lngCountTags As Long: lngCountTags = 0
    Dim lngQuestionCount As Long: lngQuestionCount = 0
    Dim lngLocation As Long: lngLocation = 1
    Dim lngLength As Long: lngLength = 0
    Dim Y As Long: Y = 0
    Dim X As Long: X = 0
    Dim strTmp As String
    Dim strDescription As Variant
    Dim varCodeLocations As Variant
    Dim strCodeTextTag As Variant

    On Error GoTo Skip
    
    Set dbTagConnection = CreateObject("DBTagFields.clsTagFields")
    
    ' This will loop through all the numeric codes in this
    ' one question which will be held in the CodesQstns Table
    While lngLocation <> 0 And lngLocation <> -1
        lngLocation = InStr(lngLocation, strQuestion, "\{")
        If lngLocation <> 0 Then
            lngLength = InStr(lngLocation, strQuestion, "\}")
            If lngLength = 0 Then
                lngLocation = -1
            Else
                dbTagConnection.lngTagid = Mid(strQuestion, lngLocation + 2, lngLength - lngLocation - 2)
                Set strDescription = dbTagConnection.TagDescriptions(dbTagConnection.lngTagid, frmMain.lngSurveyId)
                ' This will loop through all the Tags found for
                ' one code in this one question
                For Y = 1 To strDescription.Count
                    dbTagConnection.SaveQstnsCodeLoc lngQuestionId, SurveyId, dbTagConnection.lngTagid, lngLocation + 2, lngLength - lngLocation - 2, lngLangID
                    lngCountTags = lngCountTags + 1
                Next Y
                lngLocation = lngLength
            End If
        End If
    Wend
    
    ParseQuestion = lngCountTags
    Set dbTagConnection = Nothing
    Exit Function
    
Skip:
    ParseQuestion = -1
    Set dbTagConnection = Nothing

End Function
