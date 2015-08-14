VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CQuestionaire"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Attribute VB_Ext_KEY = "Member0" ,"CTXTFile"
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ File Name:      CQuestionaire
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This file contains the object definition used to
'\\                 contain a single questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-19-00    JJF     Modified for new way of creating the
'\\                         minimal files.
'\\                       * Added properties for verifying the image
'\\                         counts per questionaire.
'\\     12-20-00    JJF     Added KeepMultiReturns property.
'\\     10-17-01    JJF   * Added code to add a comment box next to the
'\\                         barcode on page one of a survey that can be
'\\                         used for attached comments.
'\\                       * Added the mbIncludeComments property.
'\\     03-07-02    JJF     Added the mlSurveyID property.
'\\     04-03-02    JJF     Added the mdtDateReturned and the
'\\                         mdtDateUndeliverable properties.
'\\     01-06-03    JJF     Removed the attached comment box from the
'\\                         bottom of page one.
'\\     08-25-04    JJF     Added the DateExpired property.
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\     08-18-06    JJF     Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Option Explicit
    
    'local variable(s) to hold property value(s)
    Private msBarcode               As String
    Private msLithoCode             As String
    Private mlSentMailID            As Long
    Private mlQuestionFormID        As Long
    Private mbReScan                As Boolean
    Private mbReturnAfterExpire     As Boolean
    Private msErrorString           As String
    Private msKey                   As String
    Private moTXTFile               As CTXTFile
    Private manImages()             As Integer
    Private mlImagesRequired        As Long
    Private mbKeepMultiReturns      As Boolean
    Private mbIncludeComments       As Boolean
    Private mlSurveyID              As Long
    Private mdtDateReturned         As Date
    Private mdtDateUndeliverable    As Date
    Private mdtDateExpired          As Date
    Private meWhereIsIt             As eCountryCodeConstants
    Private mlLithoCode As Long  '** Added 07-14-2015 CJB
    
    
    
    
    
    
    
    
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  WhereIsIt
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   05-27-2005
'\\
'\\ Description:    Sets/Returns the country code for where this survey
'\\                 is located.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get WhereIsIt() As eCountryCodeConstants
    
    WhereIsIt = meWhereIsIt
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  WhereIsIt
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   05-27-2005
'\\
'\\ Description:    Sets/Returns the country code for where this survey
'\\                 is located.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Friend Property Let WhereIsIt(eData As eCountryCodeConstants)
    
    meWhereIsIt = eData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   AddHandwrittenResponses
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   02-13-2004
'\\
'\\ Description:    This routine creates all of the Handwritten Response
'\\                 lines for the TXT file and adds them to the TXTFile
'\\                 collection.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub AddHandwrittenResponses()
    
    Dim sSql            As String
    Dim sRange          As String
    Dim sHandResponse   As String
    Dim oHandRespRs     As ADODB.Recordset
    Dim oHandRespCm     As ADODB.Command
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Setup the Handwritten Response command
    Set oHandRespCm = New ADODB.Command
    With oHandRespCm
        .CommandText = "sp_SI_HandwrittenEntryLocation"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = goScanConn
        .Parameters.Append .CreateParameter("SurveyID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("QuestionFormID", adInteger, adParamInput)
        .Parameters("SurveyID") = mlSurveyID
        .Parameters("QuestionFormID") = mlQuestionFormID
    End With 'oHandRespCm
    Set oHandRespRs = oHandRespCm.Execute()
    
    With oHandRespRs
        Do Until .EOF
            'Build the range string
            Select Case "" & !strFieldDataType
                Case "S"    'String
                    sRange = "~" & String(!intFieldLength, "$")
                    
                Case "D"    'Date
                    sRange = "~" & String(25, "$")
                    
                Case "I"    'Integer
                    sRange = "1-2000000000"
                    
            End Select
            
            'Build the handwritten entry string
            sHandResponse = "HE" & Trim(Str(!QstnCore)) & "," & _
                            Trim(Str(!Item)) & "," & _
                            Trim(Str(!Line_id)) & "," & _
                            Trim(Str(!intPage_Num)) & "," & _
                            Trim(Str(!SampleUnit_id)) & "," & _
                            "1," & _
                            Trim(Str(!intOCRType)) & "," & _
                            Trim(Str(!intOCRPreProc)) & "," & _
                            sRange & ",1," & _
                            "{" & Trim(Str(!X1)) & "," & Trim(Str(!Y1)) & "}," & _
                            "{" & Trim(Str(!X2)) & "," & Trim(Str(!Y1)) & "}," & _
                            "{" & Trim(Str(!X2)) & "," & Trim(Str(!Y2)) & "}," & _
                            "{" & Trim(Str(!X1)) & "," & Trim(Str(!Y2)) & "}"
            
            'Add the handwritten entry string
            moTXTFile.Add sLine:=sHandResponse
            
            'Prepare for next pass
            .MoveNext
        Loop
    End With
    
    'Cleanup
    oHandRespRs.Close: Set oHandRespRs = Nothing
    Set oHandRespCm = Nothing
    
Exit Sub


ErrorHandler:
    Err.Raise Number:=iecErrorAddHandwrittenResonsesFailed, _
              Source:="CQuestionaire::AddHandwrittenResponses", _
              Description:="Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  IncludeComments
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-17-2001
'\\
'\\ Description:    Sets/Returns a boolean flag indicating whether or
'\\                 not to include comments for this questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let IncludeComments(ByVal bData As Boolean)
    
    mbIncludeComments = bData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  IncludeComments
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-17-2001
'\\
'\\ Description:    Sets/Returns a boolean flag indicating whether or
'\\                 not to include comments for this questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get IncludeComments() As Boolean
    
    IncludeComments = mbIncludeComments
    
End Property



    
    
    
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ImagesRequired
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   08-18-2000
'\\
'\\ Description:    Sets/Returns the quantity of images required for
'\\                 this questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let ImagesRequired(ByVal lData As Long)
    
    mlImagesRequired = lData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ImagesRequired
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   08-18-2000
'\\
'\\ Description:    Sets/Returns the quantity of images required for
'\\                 this questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get ImagesRequired() As Long
    
    ImagesRequired = mlImagesRequired
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   IncrementImageCount
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   08-18-2000
'\\
'\\ Description:    This routine increments the quantity of images
'\\                 found for the specified page of the survey.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\     nPageNo     Integer     The page number to be incremented.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub IncrementImageCount(ByVal nPageNo As Integer)
    
    'Resize the array if necessary
    If nPageNo > UBound(manImages) Then
        ReDim Preserve manImages(nPageNo) As Integer
    End If
    
    'Set the value
    manImages(nPageNo) = manImages(nPageNo) + 1
    
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   GetCommentCopyType
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine returns the comment copy type for this
'\\                 questionaire.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Return Value:
'\\     Type        Description
'\\     String      The comment copy type for this questionaire.
'\\                 NONE - if empty or an error occures.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     08-18-06    JJF     Changed to always return 'NONE'
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Function GetCommentCopyType() As String

'    Dim oTempRs     As ADODB.Recordset
'    Dim oCopyTypeCm As ADODB.Command
'
'    'Set the error trap
'    On Error GoTo ErrorHandler
'
'    'Setup the copy type command
'    Set oCopyTypeCm = New ADODB.Command
'    With oCopyTypeCm
'        .CommandText = "sp_SI_CDFGetCommentCopyType"
'        .CommandType = adCmdStoredProc
'        .CommandTimeout = 0
'        .ActiveConnection = goConn
'        .Parameters.Append .CreateParameter("QuestionFormID", adInteger, adParamInput)
'    End With 'oCopyTypeCm
'
'    'Get the copy type from the database
'    oCopyTypeCm.Parameters("QuestionFormID") = mlQuestionFormID
'    Set oTempRs = oCopyTypeCm.Execute
'
'    'Set the copy type based on the results
'    If Trim(oTempRs!strCmntCopyType) = "" Then
'        GetCommentCopyType = "NONE"
'    Else
'        GetCommentCopyType = Trim(oTempRs!strCmntCopyType)
'    End If
'
'    'Cleanup
'    oTempRs.Close: Set oTempRs = Nothing
'    Set oCopyTypeCm = Nothing
'
'Exit Function
'
'
'ErrorHandler:
'    GetCommentCopyType = "NONE"
'    oTempRs.Close: Set oTempRs = Nothing
'    Set oCopyTypeCm = Nothing
'    Exit Function
    
    'Changed to just return "NONE" as this data is not used by FAQSS and QualiSys no longer
    '  allows the user to specify.
    GetCommentCopyType = "NONE"
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   BuildTXTFile
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine actually assembles the TXT file for
'\\                 this questionaire.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\     bMinimal    Boolean     Specifies whether or not this is to be
'\\                             a minimal file configuration.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     05-10-00    JJF     Added the multiple response level command
'\\                         line parameter.
'\\     06-19-00    JJF     Modified for the new way of creating the
'\\                         minimal file.
'\\     08-18-00    JJF     Added the new TMP tag to the file that
'\\                         specifies the template name to be used for
'\\                         this questionaire.
'\\     02-13-04    JJF     Added code to deal with Handwritten
'\\                         responces.
'\\     08-18-06    JJF     Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub BuildTXTFile(Optional ByVal bMinimal As Boolean = False)
    
    Dim sTemp As String
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Add the template name tag
    sTemp = "TMP=" & GetTemplateLine
    moTXTFile.Add sLine:=sTemp
    
    'Add the response shape string
    sTemp = "RESPONSE SHAPE=" & GetResponseShape
    moTXTFile.Add sLine:=sTemp
    
    'Add the reg points string
    sTemp = GetRegString
    moTXTFile.Add sLine:=sTemp
    
    'Add the bar code lines
    AddBarCodeLines
    
    'If we are creating a minimal file then we are finished
    If bMinimal Then Exit Sub
    
    'Add any comment boxes
    If geMultipleResponseLevel = mrcProcessAllQuestions And mbIncludeComments Then
        AddCommentBoxes
    End If
    
    'Add any handwritten responces
    If geMultipleResponseLevel = mrcProcessAllQuestions Then
        AddHandwrittenResponses
    End If
    
    'Add any question lines
    AddQuestionLines
    
Exit Sub


ErrorHandler:
    Err.Raise Number:=iecErrorBuildTXTFileFailed, _
              Source:="CQuestionaire::BuildTXTFile", _
              Description:="Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   AddQuestionLines
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine creates all of the QUESTION lines for
'\\                 the TXT file and adds them to the TXTFile collection.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     05-10-00    JJF     Added the multiple response level command
'\\                         line parameter.
'\\     06-19-00    JJF     Added CommandTimeout to the ADO.Command
'\\                         objects.
'\\     03-07-02    JJF     Changed the connection object to the one
'\\                         that points to the QP_Scan database.
'\\     08-18-06    JJF   * Removed revision notes.
'\\                       * Changed to use stored procedures.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub AddQuestionLines()
    
    Dim sQuestion       As String
    Dim lSeqNo          As Long
    Dim sReturnValue    As String
    Dim oQuestionsRs    As ADODB.Recordset
    Dim oQuestionsCm    As ADODB.Command
    Dim oXYsAndValuesRs As ADODB.Recordset
    Dim oXYsAndValuesCm As ADODB.Command
    
    Const ksAvailableCharacters As String = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Setup the questions command
    Set oQuestionsCm = New ADODB.Command
    With oQuestionsCm
        .CommandText = "sp_SI_CDFGetQuestions"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = goScanConn
        .Parameters.Append .CreateParameter("QuestionFormID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("QuestionType", adInteger, adParamInput)
    End With 'oQuestionsCm
    
    'Get the questions from the database
    oQuestionsCm.Parameters("QuestionFormID") = mlQuestionFormID
    oQuestionsCm.Parameters("QuestionType") = geMultipleResponseLevel
    Set oQuestionsRs = oQuestionsCm.Execute
    
    'Setup the X, Y, and Value command object
    Set oXYsAndValuesCm = New ADODB.Command
    With oXYsAndValuesCm
        .CommandText = "sp_SI_CDFGetResponses"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = goScanConn
        .Parameters.Append .CreateParameter("QuestionFormID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("PageNo", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("SampleUnitID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("QstnCore", adInteger, adParamInput)
    End With 'oXYsAndValuesCm
    
    'Loop through all of the questions
    lSeqNo = 0
    With oQuestionsRs
        Do Until .EOF
            lSeqNo = lSeqNo + 1
            sQuestion = Format(lSeqNo, "000") & "," & _
                        Trim(Str(!QstnCore)) & "," & _
                        Trim(Str(!intBegColumn)) & "," & _
                        Trim(Str(!NumberOfBubbles)) & "," & _
                        Trim(Str(!ReadMethod_Id)) & "," & _
                        Trim(Str(!intPage_Num)) & ","
            
            'Get the Xs, Ys, and Values for this question
            oXYsAndValuesCm.Parameters("QuestionFormID") = !QuestionForm_Id
            oXYsAndValuesCm.Parameters("PageNo") = !intPage_Num
            oXYsAndValuesCm.Parameters("SampleUnitID") = !SampleUnit_id
            oXYsAndValuesCm.Parameters("QstnCore") = !QstnCore
            Set oXYsAndValuesRs = oXYsAndValuesCm.Execute
            
            'Add the Xs, Ys, and Values to the string
            Do Until oXYsAndValuesRs.EOF
                'Determine the value to be used for this question
                If !ReadMethod_Id = 1 Then
                    'This is a multiple response question so we are going to use
                    '  the Item instead of the Val and we are going to force it to
                    '  a single digit by converting everything above 9 into an alpha
                    sReturnValue = Mid(ksAvailableCharacters, oXYsAndValuesRs!Item, 1)
                Else
                    'This is not a multiple response question so convert the Val
                    If oXYsAndValuesRs!Val < 0 Then
                        sReturnValue = "-" & Format(Abs(oXYsAndValuesRs!Val), String(!intRespCol - 1, "0"))
                    
                    Else
                        sReturnValue = Format(oXYsAndValuesRs!Val, String(!intRespCol, "0"))
                    End If
                End If
                
                'Add this response value to the question
                sQuestion = sQuestion & "{" & _
                            Trim(Str(oXYsAndValuesRs!x_pos)) & "," & _
                            Trim(Str(oXYsAndValuesRs!y_pos)) & "," & _
                            sReturnValue & "}"
                
                'Prepare for the next pass
                oXYsAndValuesRs.MoveNext
            Loop
            
            'Close the X, Y, and Value recordset
            oXYsAndValuesRs.Close: Set oXYsAndValuesRs = Nothing
            
            'Add this question to the file
            moTXTFile.Add sLine:=sQuestion
            
            'Prepare for next pass
            .MoveNext
        Loop
    End With 'oQuestionsRs
    
    'Cleanup
    oQuestionsRs.Close: Set oQuestionsRs = Nothing
    Set oXYsAndValuesCm = Nothing
    Set oQuestionsCm = Nothing
    
Exit Sub


ErrorHandler:
    Err.Raise Number:=iecErrorAddQuestionLinesFailed, _
              Source:="CQuestionaire::AddQuestionLines", _
              Description:="Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   AddCommentBoxes
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine creates all of the COMMENT BOX lines for
'\\                 the TXT file and adds them to the TXTFile collection.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     10-11-01    JJF     Added the gklCmntBoxIDOffset variable to the
'\\                         CmntBox_id to distinguish comment boxes from
'\\                         Hand-Written responses.
'\\     10-17-01    JJF   * Added code to place a comment box beside the
'\\                         barcode to be used for attached comments.
'\\     01-08-02    JJF     Moved the left side of the attached comment
'\\                         box over 0.3125 inches to accomodate for the
'\\                         new larger font used for the LithoCode.
'\\     03-07-02    JJF     Changed to use a stored procedure on the
'\\                         new QP_Scan database.
'\\     01-06-03    JJF     Removed the attached comment box from the
'\\                         bottom of page one.
'\\     08-18-06    JJF     Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub AddCommentBoxes()
    
    Dim sSql            As String
    Dim sBox            As String
    Dim oBoxesRs        As ADODB.Recordset
    Dim oCommentBoxCm   As ADODB.Command
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Setup the CommentBox command
    Set oCommentBoxCm = New ADODB.Command
    With oCommentBoxCm
        .CommandText = "sp_SI_CommentBox"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = goScanConn
        .Parameters.Append .CreateParameter("QuestionFormID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("intDODSurvey", adInteger, adParamInput)
        .Parameters("QuestionFormID") = mlQuestionFormID
        .Parameters("intDODSurvey") = IsDODSurvey()
    End With 'oCommentBoxCm
    
    'Open the boxes recordset
    Set oBoxesRs = oCommentBoxCm.Execute()
    
    With oBoxesRs
        Do Until .EOF
            'Build the box string
            sBox = "BX" & Trim(Str(!CmntBox_Id + gklCmntBoxIDOffset)) & "," & _
                   Trim(!intPage_Num) & "," & _
                   Trim(Str(!NumLines)) & "," & _
                   "{" & Trim(Str(!X1)) & "," & Trim(Str(!Y1)) & "}," & _
                   "{" & Trim(Str(!X2)) & "," & Trim(Str(!Y1)) & "}," & _
                   "{" & Trim(Str(!X2)) & "," & Trim(Str(!Y2)) & "}," & _
                   "{" & Trim(Str(!X1)) & "," & Trim(Str(!Y2)) & "}," & _
                   GetCommentCopyType
                        
            'Add the box string
            moTXTFile.Add sLine:=sBox
            
            'Add the box lines for this box
            AddCommentBoxLines lPageNo:=!intPage_Num, lCmntBoxID:=!CmntBox_Id
            
            'Prepare for next pass
            .MoveNext
        Loop
    End With
    
    'Cleanup
    oBoxesRs.Close: Set oBoxesRs = Nothing
    Set oCommentBoxCm = Nothing
    
Exit Sub


ErrorHandler:
    Err.Raise Number:=iecErrorAddCommentBoxesFailed, _
              Source:="CQuestionaire::AddCommentBoxes", _
              Description:="Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   AddCommentBoxLines
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine creates all of the COMMENT BOX LINES for
'\\                 the specified comment box and adds them to the TXTFile
'\\                 collection.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\     lPageNo     Long        The page number of the questionaire that
'\\                             the comment box is located on.
'\\     lCmntBoxID  Long        The comment box ID for which we are to
'\\                             add the line definitions.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     03-07-02    JJF     Changed to use a stored procedure on the
'\\                         new QP_Scan database.
'\\     08-18-06    JJF     Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub AddCommentBoxLines(ByVal lPageNo As Long, ByVal lCmntBoxID As Long)
    
    Dim sSql            As String
    Dim sLine           As String
    Dim oLinesRs        As ADODB.Recordset
    Dim oCommentBoxCm   As ADODB.Command
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Setup the CommentBox command
    Set oCommentBoxCm = New ADODB.Command
    With oCommentBoxCm
        .CommandText = "sp_SI_CommentBoxLine"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = goScanConn
        .Parameters.Append .CreateParameter("QuestionFormID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("PageNo", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("CmntBoxID", adInteger, adParamInput)
        .Parameters.Append .CreateParameter("intDODSurvey", adInteger, adParamInput)
        .Parameters("QuestionFormID") = mlQuestionFormID
        .Parameters("PageNo") = lPageNo
        .Parameters("CmntBoxID") = lCmntBoxID
        .Parameters("intDODSurvey") = IsDODSurvey()
    End With 'oCommentBoxCm
    
    'Open the lines record set
    Set oLinesRs = oCommentBoxCm.Execute()
    
    With oLinesRs
        Do Until .EOF
            'Build the line string
            sLine = "LN" & Trim(Str(!intLine_Num)) & "," & _
                    "{" & Trim(Str(!X1)) & "," & Trim(Str(!Y1)) & "}," & _
                    "{" & Trim(Str(!X2)) & "," & Trim(Str(!Y1)) & "}," & _
                    "{" & Trim(Str(!X2)) & "," & Trim(Str(!Y2)) & "}," & _
                    "{" & Trim(Str(!X1)) & "," & Trim(Str(!Y2)) & "}"
            
            'Add the line string
            moTXTFile.Add sLine:=sLine
            
            'Prepare for next pass
            .MoveNext
        Loop
    End With
    
    'Cleanup
    oLinesRs.Close: Set oLinesRs = Nothing
    Set oCommentBoxCm = Nothing
    
Exit Sub


ErrorHandler:
    Err.Raise Number:=iecErrorAddCmntBoxLinesFailed, _
              Source:="CQuestionaire::AddCommentBoxLines", _
              Description:="Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   AddBarCodeLines
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine creates all of the BAR CODE lines for
'\\                 the TXT file and adds them to the TXTFile collection.
'\\
'\\ Parameters:
'\\     Name            Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-19-00    JJF     Modified for the new way of creating a
'\\                         minimal file.
'\\     08-18-00    JJF     Added code to set the new ImagesRequired
'\\                         property to the number of images for this
'\\                         questionaire.
'\\     10-17-01    JJF     Added code to get the coordinates for the
'\\                         attached comment box that is placed next to
'\\                         the barcode.
'\\     01-06-03    JJF     Removed the attached comment box from the
'\\                         bottom of page one.
'\\     08-18-06    JJF   * Removed revision notes.
'\\                       * Changed to use stored procedures.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub AddBarCodeLines()
    
    Dim sBarCodeLine    As String
    Dim sPageNo         As String
    Dim sPageBarCode    As String
    Dim lPageNo         As Long
    Dim lCnt            As Long
    Dim lQtyImages      As Long
    Dim oTempRs         As ADODB.Recordset
    Dim oLinesCm        As ADODB.Command
    
    Const ksLookUpTable As String = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Setup the lines command
    Set oLinesCm = New ADODB.Command
    With oLinesCm
        .CommandText = "sp_SI_CDFGetBarCodeLines"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("SentMailID", adInteger, adParamInput)
    End With 'oLinesCm
    
    'Get the barcode lines from the database
    oLinesCm.Parameters("SentMailID") = mlSentMailID
    Set oTempRs = oLinesCm.Execute
    
    With oTempRs
        'Loop though all bar codes
        lQtyImages = 0
        Do Until .EOF
            'Check through all 35 possibilities for the page numbers
            '  available in this bar code record
            For lCnt = 1 To Len(ksLookUpTable)
                lPageNo = -1
                Select Case lCnt
                    Case !intPA
                        lPageNo = !intPA
                        sPageBarCode = !strBarCodeA
                    Case !intPB
                        lPageNo = !intPB
                         sPageBarCode = !strBarCodeB
                    Case !intPC
                        lPageNo = !intPC
                        sPageBarCode = !strBarCodeC
                    Case !intPD
                        lPageNo = !intPD
                        sPageBarCode = !strBarCodeD
                End Select
                
                If lPageNo <> -1 And lPageNo <> 0 And sPageBarCode <> "0" Then
                    'Assemble the BC string
                    sPageNo = Mid(ksLookUpTable, lPageNo, 1)
                    sBarCodeLine = "BC" & sPageNo & "," & sPageBarCode
                    
                    'Add it to the collection
                    moTXTFile.Add sLine:=sBarCodeLine
                    
                    'Increment the quantity of images
                    lQtyImages = lQtyImages + 1
                End If
            Next lCnt
            
            'Prepare for next pass
            .MoveNext
        Loop
    End With 'oTempRs
    
    'Set the quantity of images required
    ImagesRequired = lQtyImages
    
    'Cleanup
    oTempRs.Close: Set oTempRs = Nothing
    Set oLinesCm = Nothing
    
Exit Sub


ErrorHandler:
    Err.Raise Number:=iecErrorAddBarCodeLinesFailed, _
              Source:="CQuestionaire::AddBarCodeLines", _
              Description:="Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   GetRegString
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine builds the REGISTRATION POINTS string
'\\                 for the TXT file.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Return Value:
'\\     Type        Description
'\\     String      The registration points string required for this
'\\                 questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     08-18-06    JJF     Changed to use stored procedures.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Function GetRegString() As String
    
    Dim sRegString      As String
    Dim oTempRs         As ADODB.Recordset
    Dim oRegStringCm    As ADODB.Command
    
    sRegString = "REG"
    
    'Setup the reg string command
    Set oRegStringCm = New ADODB.Command
    With oRegStringCm
        .CommandText = "sp_SI_CDFGetRegString"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("SentMailID", adInteger, adParamInput)
    End With 'oRegStringCm
    
    'Get the reg string from the database
    oRegStringCm.Parameters("SentMailID") = mlSentMailID
    Set oTempRs = oRegStringCm.Execute
    
    With oTempRs
        Do Until .EOF
            If Trim(!strRegPoints) <> "" Then
                'Append this reg point to the string
                sRegString = sRegString & "," & Trim(!strRegPoints)
            Else
                'If there is a blank strRegPoints then we are in trouble
                Err.Raise Number:=iecErrorGetRegStringFailed, _
                          Source:="CQuestionaire::GetRegString", _
                          Description:="Blank strRegPoints Encountered"
                Exit Function
            End If
            
            'Prepare for next pass
            .MoveNext
        Loop
    End With
    
    'Cleanup
    GetRegString = sRegString
    oTempRs.Close: Set oTempRs = Nothing
    Set oRegStringCm = Nothing
    
End Function


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   GetTemplateLine
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   08-18-2000
'\\
'\\ Description:    This routine builds the Template string for
'\\                 the TXT file.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Return Value:
'\\     Type        Description
'\\     String      The template string required for this
'\\                 questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     02-17-03    JJF     Added LangID to the Template line to
'\\                         separate out the diffent languages into
'\\                         different batches.
'\\     08-18-06    JJF   * Removed revision notes.
'\\                       * Changed to use stored procedures.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Function GetTemplateLine() As String
    
    Dim sTempCode   As String
    Dim sTempName   As String
    Dim oTempRs     As ADODB.Recordset
    Dim oLineCm     As ADODB.Command
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Setup the line command
    Set oLineCm = New ADODB.Command
    With oLineCm
        .CommandText = "sp_SI_CDFGetTemplateLine"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("SentMailID", adInteger, adParamInput)
    End With 'oLineCm
    
    'Get the template line from the database
    oLineCm.Parameters("SentMailID") = mlSentMailID
    Set oTempRs = oLineCm.Execute
    
    'Determine the template code and name
    With oTempRs
        sTempCode = "" & !Survey_id & !strTemplateCode & IIf(IsNull(!LangID), "", Format(!LangID, "00"))
        sTempName = sTempCode & " " & Trim(!strSurvey_nm) & " " & Trim(!strClient_nm)
    End With
    
    'Build the return string
    GetTemplateLine = sTempCode & "," & Left(sTempName, 30)
    
    'Cleanup
    oTempRs.Close: Set oTempRs = Nothing
    Set oLineCm = Nothing
    
Exit Function


ErrorHandler:
    If oTempRs.State <> adStateClosed Then oTempRs.Close
    Set oTempRs = Nothing
    Set oLineCm = Nothing
    Err.Raise Number:=iecErrorGetTemplateLineFailed, _
              Source:="CQuestionaire::GetTemplateLine", _
              Description:="Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    Exit Function
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   GetResponseShape
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine builds the RESPONSE SHAPE string for
'\\                 the TXT file.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Return Value:
'\\     Type        Description
'\\     String      The response shape string required for this
'\\                 questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Function GetResponseShape() As String
    
    Dim sSql    As String
    Dim oTempRs As ADODB.Recordset
    Dim oTempCm As ADODB.Command
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Setup the info command
    Set oTempCm = New ADODB.Command
    With oTempCm
        .CommandText = "sp_SI_CDFGetResponseShape"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("SentMailID", adInteger, adParamInput)
    End With 'oTempCm
    
    'Get the remaining info from the database
    oTempCm.Parameters("SentMailID") = mlSentMailID
    Set oTempRs = oTempCm.Execute
    
    'If the field is NULL then default to 1
    GetResponseShape = IIf(IsNull(oTempRs!intResponseShape), "1", Trim(Str(oTempRs!intResponseShape)))
    
    'Cleanup
    oTempRs.Close: Set oTempRs = Nothing
    Set oTempCm = Nothing
    
Exit Function


ErrorHandler:
    GetResponseShape = "1"
    oTempRs.Close: Set oTempRs = Nothing
    Set oTempCm = Nothing
    Exit Function
    
End Function


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   IsDODSurvey
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   03-07-2002
'\\
'\\ Description:    This function determines if this is a DOD survey.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Return Value:
'\\     Type        Description
'\\     Long        0 = This is not a DOD survey.
'\\                 1 = This is a DOD survey.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Function IsDODSurvey() As Long
    
    Dim sTemp As String
    
    sTemp = "," & mlSurveyID & ","
    
    If InStr(gsDODSurveys, sTemp) > 0 Then
        IsDODSurvey = 1
    Else
        IsDODSurvey = 0
    End If
    
End Function


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  TXTFile
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns a reference to the CTXTFile object
'\\                 that is used to store the TXT file during its
'\\                 creation.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get TXTFile() As CTXTFile
    
    Set TXTFile = moTXTFile
    
End Property


Public Function ValidateImages(sMessage As String) As Boolean
    
    Dim lCnt As Long
    
    'Initialize the message string
    sMessage = ""
    
    'Initialize return value
    ValidateImages = False
    
    'Check bounds
    If UBound(manImages) < mlImagesRequired Then
        'Redim the array so it is as large as it is supposed to be
        ReDim Preserve manImages(mlImagesRequired) As Integer
    End If
    
    'Check to see if we have to many images
    If UBound(manImages) > mlImagesRequired Then
        sMessage = "Image found for page " & UBound(manImages) & " but survey has only " & mlImagesRequired & " page(s)"
        Exit Function
    End If
    
    'Check for missing and duplicate images
    For lCnt = 1 To mlImagesRequired
        If manImages(lCnt) <> 1 Then
            sMessage = IIf(Len(sMessage) = 0, "", ", ") & manImages(lCnt) & " images for page " & lCnt
        End If
    Next lCnt
    If Len(sMessage) > 0 Then
        sMessage = "Invalid image counts: " & sMessage
        Exit Function
    End If
    
    'If we made it to here then all is well
    ValidateImages = True
    sMessage = ""
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   WriteERRFile
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   08-18-2000
'\\
'\\ Description:    This routine is called when the TXT file creation
'\\                 cannot be completed.  Here we create a dummy file
'\\                 that instructs FAQSS to move the images to the
'\\                 BAD IMAGE location and ignore them during the
'\\                 creation of the batch.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\     sFilePath   String      The fully qualified path specification
'\\                             where the ERR file is to be created.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub WriteERRFile(ByVal sFilePath As String)
    
    Dim lCnt        As Long
    Dim lFileHandle As Long
    Dim sFileName   As String
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Open the file
    sFileName = sFilePath & LithoToBarcode(lLithoCode:=msLithoCode) & ".txt"
    lFileHandle = FreeFile
    Open sFileName For Output As #lFileHandle
    
    'Write the file to disk
    Print #lFileHandle, "ERR=" & msErrorString
    
    'Close the file
    Close #lFileHandle
    
Exit Sub


ErrorHandler:
    Err.Raise Number:=iecErrorWriteERRFileFailed, _
              Source:="CQuestionaire::WriteERRFile", _
              Description:="Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    Close #lFileHandle
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   WriteTXTFile
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine is called when the TXT file creation
'\\                 is complete and it is time to write the file to
'\\                 it's final destination.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\     sFilePath   String      The fully qualified path specification
'\\                             where the TXT file is to be created.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     08-18-00    JJF     Added Close to the error handler.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub WriteTXTFile(ByVal sFilePath As String)
    
    Dim lCnt        As Long
    Dim lFileHandle As Long
    Dim sFileName   As String
    
    'Set the error trap
    On Error GoTo ErrorHandler
    
    'Open the file
    sFileName = sFilePath & LithoToBarcode(lLithoCode:=msLithoCode) & ".txt"
    lFileHandle = FreeFile
    Open sFileName For Output As #lFileHandle
    
    'Write the file to disk
    For lCnt = 1 To moTXTFile.Count
        Print #lFileHandle, moTXTFile.Item(lCnt)
    Next lCnt
    
    'Close the file
    Close #lFileHandle
    
Exit Sub


ErrorHandler:
    Err.Raise Number:=iecErrorWriteTXTFileFailed, _
              Source:="CQuestionaire::WriteTXTFile", _
              Description:="Source: " & Err.Source & " - Error #" & Err.Number & ": " & Err.Description
    Close #lFileHandle
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Class_Terminate
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine is called by the VB runtime upon
'\\                 termination of an instance of this class.  This
'\\                 is where we cleanup the collection object.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     08-18-00    JJF     Added cleanup for the new variables.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub Class_Terminate()

    Set moTXTFile = Nothing
    Erase manImages
    
End Sub



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ReturnAfterExpire
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Returns a boolean flag indicating whether or not
'\\                 this questionaire was returned and scanned after
'\\                 it had already expired.
'\\                 TRUE  - The questionaire is expired.
'\\                 FALSE - The questionaire is OK for processing.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     08-25-04    JJF     Modified to use the datExpire field in the
'\\                         SentMailing table instead of counting
'\\                         records in the BubblePos table.
'\\     08-18-06    JJF     Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get ReturnAfterExpire() As Boolean
    
    If Now < mdtDateExpired Then
        'This survey has not expired yet
        ReturnAfterExpire = False
    Else
        'This survey has expired
        ReturnAfterExpire = True
    End If
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  OtherStepReturned
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Returns a boolean flag indicating whether or not
'\\                 and earlier step for this questionaire has already
'\\                 been returned and scanned.
'\\                 TRUE  - An earlier step has already been processed.
'\\                 FALSE - The questionaire is OK for processing.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     08-18-06    JJF     Changed to use stored procedures.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get OtherStepReturned() As Boolean
    
    Dim sSql    As String
    Dim oTempRs As ADODB.Recordset
    Dim oTempCm As ADODB.Command
        
    'Setup the command
    Set oTempCm = New ADODB.Command
    With oTempCm
        .CommandText = "sp_SI_CDFGetQtyOtherStepsReturned"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 0
        .ActiveConnection = goConn
        .Parameters.Append .CreateParameter("QuestionFormID", adInteger, adParamInput)
    End With 'oTempCm
    
    'Get the info from the database
    oTempCm.Parameters("QuestionFormID") = QuestionFormID
    Set oTempRs = oTempCm.Execute

    'Determine if a previous mailing step has been returned
    If oTempRs!QtyRec > 0 Then
        OtherStepReturned = True
    Else
        OtherStepReturned = False
    End If
    
    'Cleanup
    oTempRs.Close: Set oTempRs = Nothing
    Set oTempCm = Nothing
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  KeepMultiReturns
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   12-20-2000
'\\
'\\ Description:    Sets/Returns a boolean flag indicating whether or
'\\                 not this Survey allows for keeping multiple returns.
'\\                 TRUE  - The results are kept for all returns.
'\\                 FALSE - The results are kept for only the first
'\\                         return received.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let KeepMultiReturns(ByVal bData As Boolean)
    
    mbKeepMultiReturns = bData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ReScan
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns a boolean flag indicating whether or
'\\                 not this particular questionaire has already been
'\\                 scanned.
'\\                 TRUE  - The questionaire has already been processed.
'\\                 FALSE - The questionaire is OK for processing.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let ReScan(ByVal bData As Boolean)
    
    mbReScan = bData
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  KeepMultiReturns
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   12-20-2000
'\\
'\\ Description:    Sets/Returns a boolean flag indicating whether or
'\\                 not this Survey allows for keeping multiple returns.
'\\                 TRUE  - The results are kept for all returns.
'\\                 FALSE - The results are kept for only the first
'\\                         return received.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get KeepMultiReturns() As Boolean
    
    KeepMultiReturns = mbKeepMultiReturns
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ReScan
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns a boolean flag indicating whether or
'\\                 not this particular questionaire has already been
'\\                 scanned.
'\\                 TRUE  - The questionaire has already been processed.
'\\                 FALSE - The questionaire is OK for processing.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get ReScan() As Boolean
    
    ReScan = mbReScan
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ErrorString
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns any error conditions encountered while
'\\                 processing this questionaire.  Later used to create
'\\                 the INCOMPLETE file if any errors exist.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let ErrorString(ByVal sData As String)
    
    msErrorString = sData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ErrorString
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns any error conditions encountered while
'\\                 processing this questionaire.  Later used to create
'\\                 the INCOMPLETE file if any errors exist.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get ErrorString() As String
    
    ErrorString = msErrorString
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Key
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the KEY for this questionaire used to
'\\                 keep the collection unique.  It is "LC" & msLithoCode
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let Key(ByVal sData As String)
    
    msKey = sData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Key
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the KEY for this questionaire used to
'\\                 keep the collection unique.  It is "LC" & msLithoCode
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Key() As String
    
    Key = msKey
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   IsBarcodeValid
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine returns a flag indicating whether or
'\\                 not the check digit of the barcode is valid.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Return Value:
'\\     Type        Description
'\\     Boolean     TRUE  - The check digit is valid.
'\\                 FALSE - The check digit failed the validation.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function IsBarcodeValid() As Boolean
    
    IsBarcodeValid = IsCheckDigitValid(sBarCode:=msBarcode)
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Barcode
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the barcode used to identify this
'\\                 questionaire.  The LITHO CODE is also generated
'\\                 at this time by UnCrunching the barcode.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     05-27-05    JJF     Modified to work with Canadian generated
'\\                         surveys.
'\\     08-18-06    JJF     Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let Barcode(ByVal sData As String)
    
    'Save the barcode
    msBarcode = sData
    
    'Determine the lithocode
    msLithoCode = BarcodeToLitho(sBarCode:=Left(msBarcode, 6))
    
''Determine where this survey lives
'If msLithoCode >= goCALithoRange.sMinLitho And _
'   msLithoCode <= goCALithoRange.sMaxLitho Then
'    meWhereIsIt = cccCanada
'Else
'    meWhereIsIt = cccUS
'End If
    
'INC0045985 ref INC0044335 Chris Burkholder 07-14-2015  convert litho values to long to allow proper comparison below
    mlLithoCode = CLng(msLithoCode)

Dim lMinLitho As Long
Dim lMaxLitho As Long
    lMinLitho = CLng(goCALithoRange.sMinLitho)
    lMaxLitho = CLng(goCALithoRange.sMaxLitho)

'Determine where this survey lives

'INC0045985 ref INC0044335 Chris Burkholder 07-14-2015  changed compare to use Long instead of string
    If mlLithoCode >= lMinLitho And _
       mlLithoCode <= lMaxLitho Then
        meWhereIsIt = cccCanada
    Else
        meWhereIsIt = cccUS
    End If

End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Barcode
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the barcode used to identify this
'\\                 questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Barcode() As String
    
    Barcode = msBarcode
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  LithoCode
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Returns the LITHO CODE for this questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get LithoCode() As String
    
    LithoCode = msLithoCode
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  SentMailID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the SentMail_id for this questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let SentMailID(ByVal lData As Long)
    
    mlSentMailID = lData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  SentMailID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the SentMail_id for this questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get SentMailID() As Long
    
    SentMailID = mlSentMailID
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  SurveyID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   03-07-2002
'\\
'\\ Description:    Sets/Returns the Survey_id for this questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let SurveyID(ByVal lData As Long)
    
    mlSurveyID = lData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  DateUndeliverable
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-03-2002
'\\
'\\ Description:    Sets/Returns the datUndeliverable for this questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let DateUndeliverable(ByVal dtData As Date)
    
    mdtDateUndeliverable = dtData
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  DateExpired
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   08-25-2004
'\\
'\\ Description:    Sets/Returns the datExpire for this questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let DateExpired(ByVal dtData As Date)
    
    mdtDateExpired = dtData
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  DateReturned
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-03-2002
'\\
'\\ Description:    Sets/Returns the datReturned for this questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let DateReturned(ByVal dtData As Date)
    
    mdtDateReturned = dtData
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  QuestionFormID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the QuestionForm_id for this questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let QuestionFormID(ByVal lData As Long)
    
    mlQuestionFormID = lData
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  SurveyID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   03-07-2002
'\\
'\\ Description:    Sets/Returns the Survey_id for this questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get SurveyID() As Long
    
    SurveyID = mlSurveyID
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  DateUndeliverable
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-03-2002
'\\
'\\ Description:    Sets/Returns the datUndeliverable for this questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get DateUndeliverable() As Date
    
    DateUndeliverable = mdtDateUndeliverable
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  DateExpired
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   08-25-2004
'\\
'\\ Description:    Sets/Returns the datExpire for this questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get DateExpired() As Date
    
    DateExpired = mdtDateExpired
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  DateReturned
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-03-2002
'\\
'\\ Description:    Sets/Returns the datReturned for this questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get DateReturned() As Date
    
    DateReturned = mdtDateReturned
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  QuestionFormID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the QuestionForm_id for this questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get QuestionFormID() As Long
    
    QuestionFormID = mlQuestionFormID
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Class_Initialize
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine is called by the VB runtime upon
'\\                 initialization of an instance of this class.  This
'\\                 is where we create the new collection object and
'\\                 set any required variables to thier default values.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     06-19-00    JJF     Modified for new way of creating the
'\\                         minimal files.
'\\     08-18-00    JJF     Added initialization for the new variables.
'\\     08-18-06    JJF     Removed revision notes.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub Class_Initialize()
    
    mlSentMailID = -1
    mlQuestionFormID = -1
    mbReScan = False
    mbReturnAfterExpire = False
    Set moTXTFile = New CTXTFile
    ReDim manImages(0) As Integer
    
End Sub



