Attribute VB_Name = "clsSaveTagField"
'-----------------------------------------------------------------
' Copyright © National Research Corporation
'
' Required References:
'       OLE Automation
'       DBTagFields
'
' Revisions:
'       Date        By  Description
'       09-26-220   SH  Added Language ID to ParseQuestion.
'       10-05-2002  SH  Recompiled with VB6.0 and moved EXE to
'                       \components\QualiSysEXEs\.
'-----------------------------------------------------------------

Option Explicit

Dim SurveyId As Long

Public Sub Main()

    SurveyId = GetCommandLine(1)
    If SurveyId = 0 Then
        MsgBox "You typed in " & SurveyId & " as your Survey Id!" & Chr(10) & "That is not a valid survey Id!", vbCritical, "Save Tag Field Error Message"
    Else
        SaveTagLocations SurveyId
    End If
    End

End Sub

Public Function GetCommandLine(Optional MaxArgs) As Long
    
    On Error Resume Next
    
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
    GetCommandLine = ArgArray(1)
    
End Function

Public Sub SaveTagLocations(ByVal lngSurveyId As Long)
    
    Dim dbTagConnection As DBTagFields.clsTagFields
    Dim varQuestions As Variant
    Dim X As Long
    
    SurveyId = lngSurveyId
    frmStatus.MousePointer = vbHourglass
    frmStatus.Show
    frmStatus.SetFocus
    Set dbTagConnection = CreateObject("DBTagFields.clsTagFields")
    dbTagConnection.DelSurveyLocations SurveyId
    varQuestions = dbTagConnection.SelQuestions(lngSurveyId)
    
    If Not IsNull(varQuestions) Then
        frmStatus.ProgressBar1.Max = UBound(varQuestions, 2) + 1
        frmStatus.txtMax = frmStatus.ProgressBar1.Max
        frmStatus.txtValue = 0
        frmStatus.ProgressBar1.Value = 0
        frmStatus.Caption = "Saving Personalization Locations for Questions..."
        For X = 0 To UBound(varQuestions, 2)
            DoEvents
            'ParseQuestion IIf(IsNull(varQuestions(1, X)), " ", varQuestions(1, X)), varQuestions(0, X)
            ' 09-26-2002 Added LangID
            ParseQuestion IIf(IsNull(varQuestions(1, X)), " ", varQuestions(1, X)), varQuestions(0, X), varQuestions(2, X)
            frmStatus.ProgressBar1.Value = X
            frmStatus.txtValue = frmStatus.ProgressBar1.Value
        Next X
    End If
    
    varQuestions = dbTagConnection.SelScales(SurveyId)
    
    If Not IsNull(varQuestions) Then
        frmStatus.ProgressBar1.Max = UBound(varQuestions, 2) + 1
        frmStatus.txtMax = frmStatus.ProgressBar1.Max
        frmStatus.txtValue = 0
        frmStatus.ProgressBar1.Value = 0
        frmStatus.Caption = "Saving Personalization Locations for Scales..."
        For X = 0 To UBound(varQuestions, 2)
            DoEvents
            ' 09-26-2002 SH
            ' Added language ID.
            'ParseScales IIf(IsNull(varQuestions(1, X)), " ", varQuestions(1, X)), varQuestions(0, X)
            ParseScales IIf(IsNull(varQuestions(3, X)), " ", varQuestions(3, X)), varQuestions(0, X), varQuestions(1, X), varQuestions(2, X)
            frmStatus.ProgressBar1.Value = X
            frmStatus.txtValue = frmStatus.ProgressBar1.Value
        Next X
    End If
    
    varQuestions = dbTagConnection.SelTextBoxes(SurveyId)
    
    If Not IsNull(varQuestions) Then
        frmStatus.ProgressBar1.Max = UBound(varQuestions, 2) + 1
        frmStatus.txtMax = frmStatus.ProgressBar1.Max
        frmStatus.txtValue = 0
        frmStatus.ProgressBar1.Value = 0
        frmStatus.Caption = "Saving Personalization Locations for Text Boxes..."
        For X = 0 To UBound(varQuestions, 2)
            DoEvents
            ' 09-26-2002 SH
            ' Added the language ID.
            'ParseTextBox IIf(IsNull(varQuestions(1, X)), " ", varQuestions(1, X)), varQuestions(0, X)
            ParseTextBox IIf(IsNull(varQuestions(1, X)), " ", varQuestions(1, X)), varQuestions(0, X), varQuestions(2, X)
            frmStatus.ProgressBar1.Value = X
            frmStatus.txtValue = frmStatus.ProgressBar1.Value
        Next X
    End If
    
    frmStatus.MousePointer = vbNormal
    frmStatus.Hide

End Sub

' This is used to location all the tags and there
' positions within the text
' 09-26-2002 SH
' Added lngLangID parameter to ParseQuestion
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

    'On Error GoTo Skip
    
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
                strDescription = dbTagConnection.TagDescriptions(Mid(strQuestion, lngLocation + 2, lngLength - lngLocation - 2), SurveyId)
                ' This will loop through all the Tags found for
                ' one code in this one question
                If Not IsNull(strDescription) Then
                    If InStr(1, strDescription(0), "---1") > 0 Then
                        MsgBox "Your Survey is not validated: " & Chr(10) & strDescription(0)
                        ParseQuestion = -1
                        Exit Function
                    End If
                    For Y = 1 To UBound(strDescription)
                        dbTagConnection.SaveQstnsCodeLoc lngQuestionId, SurveyId, Mid(strQuestion, lngLocation + 2, lngLength - lngLocation - 2), lngLocation + 2, lngLength - lngLocation - 2, lngLangID
                        lngCountTags = lngCountTags + 1
                    Next Y
                End If
                lngLocation = lngLength
            End If
            DoEvents
        End If
    Wend
    
    ParseQuestion = lngCountTags
    Set dbTagConnection = Nothing
    
    Exit Function

Skip:
    MsgBox "You had an error while parsing the questions!", vbCritical, "Save Tags - ParseQuestion Error"
    ParseQuestion = -1
    Set dbTagConnection = Nothing

End Function

' This is used to location all the tags and there
' positions within the text
' 09-26-2002 SH
' Added lngItem and lngLangID to ParseScales function.
Private Function ParseScales(ByVal strQuestion As String, ByVal lngQuestionId As Long, ByVal lngItem As Long, ByVal lngLangID As Long) As Long
    
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

    'On Error GoTo Skip
    
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
                strDescription = dbTagConnection.TagDescriptions(dbTagConnection.lngTagid, SurveyId)
                ' This will loop through all the Tags found for
                ' one code in this one question
                If Not IsNull(strDescription) Then
                    If InStr(1, strDescription(0), "---1") > 0 Then
                        MsgBox "Your Survey is not validated: " & Chr(10) & strDescription(0)
                        ParseScales = -1
                        Exit Function
                    End If
                    For Y = 1 To UBound(strDescription)
                        ' 09-26-2002 SH
                        ' Modified the parameters.
                        'dbTagConnection.SaveSclsCodeLoc lngQuestionId, SurveyId, Mid(strQuestion, lngLocation + 2, lngLength - lngLocation - 2), lngLocation + 2, lngLength - lngLocation - 2
                        dbTagConnection.SaveSclsCodeLoc lngQuestionId, SurveyId, lngItem, lngLangID, Mid(strQuestion, lngLocation + 2, lngLength - lngLocation - 2), lngLocation + 2, lngLength - lngLocation - 2
                        lngCountTags = lngCountTags + 1
                    Next Y
                End If
                lngLocation = lngLength
            End If
            DoEvents
        End If
    Wend
    
    ParseScales = lngCountTags
    Set dbTagConnection = Nothing
    
    Exit Function

Skip:
    MsgBox "You had an error while parsing the questions!", vbCritical, "Save Tags - ParseQuestion Error"
    ParseScales = -1
    Set dbTagConnection = Nothing

End Function

' This is used to location all the tags and there
' positions within the text
' 09-26-2002 SH
' Added lngLangID to the function.
Private Function ParseTextBox(ByVal strQuestion As String, ByVal lngQuestionId As Long, ByVal lngLangID As Long) As Long
    
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

    'On Error GoTo Skip
    
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
                strDescription = dbTagConnection.TagDescriptions(dbTagConnection.lngTagid, SurveyId)
                ' This will loop through all the Tags found for
                ' one code in this one question
                If Not IsNull(strDescription) Then
                    If InStr(1, strDescription(0), "---1") > 0 Then
                        MsgBox "Your Survey is not validated: " & Chr(10) & strDescription(0)
                        ParseTextBox = -1
                        Exit Function
                    End If
                    For Y = 1 To UBound(strDescription)
                        ' 09-26-2002 SH
                        ' Added lngLangID.
                        'dbTagConnection.SaveTxtBoxCodeLoc lngQuestionId, SurveyId, Mid(strQuestion, lngLocation + 2, lngLength - lngLocation - 2), lngLocation + 2, lngLength - lngLocation - 2
                        dbTagConnection.SaveTxtBoxCodeLoc lngQuestionId, SurveyId, Mid(strQuestion, lngLocation + 2, lngLength - lngLocation - 2), lngLocation + 2, lngLength - lngLocation - 2, lngLangID
                        lngCountTags = lngCountTags + 1
                    Next Y
                End If
                lngLocation = lngLength
            End If
            DoEvents
        End If
    Wend
    
    ParseTextBox = lngCountTags
    Set dbTagConnection = Nothing
    
    Exit Function

Skip:
    MsgBox "You had an error while parsing the questions!", vbCritical, "Save Tags - ParseQuestion Error"
    ParseTextBox = -1
    Set dbTagConnection = Nothing

End Function
