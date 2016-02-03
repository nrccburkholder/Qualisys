Imports System.IO
Imports System.Text
Imports System.Text.RegularExpressions
Imports System.Data
Public Class IU_ImportUpdate
#Region " Private Variables "
    Private mImportFilePath As String = String.Empty
    Private mImportLog As New List(Of String)
    Private mTemplateID As Integer = 0
    Private mClientID As Integer = 0
    Private mScriptID As Integer = 0
    Private mFileDefID As Integer = 0
    Private mFileDefTypeID As Integer = 0
    Private mSurveyID As Integer = 0
    Private mFileTypeID As Integer = 0
    Private mFileDefTable As DataTable = Nothing
    Private mRespondentID As Integer = 0
    Private mSurveyInstanceID As Integer = 0
    Private mResponsesExist As Boolean = False
    Private mRespondentQuestions As New List(Of RespondentQuestion)
    'Private mRespondentFieldUpdates As New List(Of RespondentFieldUpdate)
#End Region
#Region " Constructors "
    Public Sub New(ByVal filePath As String)
        Me.mImportFilePath = filePath
    End Sub
#End Region
#Region " Private Methods "
    Private Function ValidateStringFile() As Boolean
        Try
            If Me.mImportFilePath.Length = 0 Then
                AddToLog("No path was given for the import file.")
                Return False
            End If
            If Not System.IO.File.Exists(Me.mImportFilePath) Then
                AddToLog("An Invalid file path was given.")
                Return False
            End If
            AddToLog("Begin import of " & Me.mImportFilePath)
            Dim cnt As Long = GetFileCount()
            AddToLog("Import File contains " & cnt & " records to be processed.")
            Return True
        Catch ex As System.Exception
            AddToLog(ex.Message)
            Return False
        End Try
    End Function
    Private Function GetTemplateIDFromLine(ByVal strLine As String) As Integer
        Dim retVal As Integer = 0
        Dim rx As New Regex("^.{18}([\\d\\s]{5}")
        If rx.IsMatch(strLine) Then
            Dim m As Match = rx.Match(strLine)
            retVal = CInt(m.Groups(1).Value)
        End If
        Return retVal
    End Function
    Private Sub SetFileDefVars()
        Try
            Dim defTable As DataTable = DataProviders.IU_ImportUpdateProvider.Instance.GetFileDefReaderByTemplateID(Me.mTemplateID)
            Me.mClientID = CInt(defTable.Rows(0)("ClientID"))
            Me.mScriptID = CInt(defTable.Rows(0)("ScriptID"))
            Me.mFileDefID = CInt(defTable.Rows(0)("FileDefID"))
            Me.mSurveyID = CInt(defTable.Rows(0)("SurveyID"))
            Me.mFileDefTypeID = CInt(defTable.Rows(0)("FileDefTypeID"))
            Me.mFileTypeID = CInt(defTable.Rows(0)("FileTypeID"))
            If Me.mTemplateID <= 0 OrElse Me.mClientID <= 0 OrElse Me.mScriptID <= 0 OrElse Me.mFileDefID <= 0 OrElse Me.mSurveyID <= 0 OrElse Me.mFileDefTypeID <= 0 Then
                AddToLog("An invalid value was returned from template variables.")
                Throw New System.Exception("Invalid Template Variables.")
            ElseIf Me.mFileDefTypeID <> 3 And Me.mFileDefTypeID <> 1 Then
                AddToLog("File Type Definition must be a 1 or 3.  It is currently " & Me.mFileDefTypeID)
                Throw New System.Exception("Invalid Template Variables.")
            ElseIf Me.mFileTypeID <> 4 Then
                AddToLog("File Type must be fixed width.")
                Throw New System.Exception("Invalid Template Variables.")
            Else
                AddToLog("Template ID: " & Me.mTemplateID & " ClientID: " & Me.mClientID & " Script ID: " & Me.mScriptID & " File Def ID: " & Me.mFileDefID)
            End If
        Catch ex As Exception
            AddToLog("Error in retrieving template variables.")
        End Try
    End Sub
    Private Sub ExtractDataFromLine(ByVal line As String)        
        Me.mFileDefTable = DataProviders.IU_ImportUpdateProvider.Instance.GetFileDefByFileDefID(Me.mFileDefID)
        Dim startIndex As Integer = 0
        For i As Integer = 0 To Me.mFileDefTable.Rows.Count
            Dim width As Integer = CInt(Me.mFileDefTable.Rows(i)("Width"))
            Me.mFileDefTable.Rows(i)("TextValue") = GetDataFromLine(startIndex, width, line)
            startIndex += width
        Next
    End Sub
    Private Sub SetRespondentAndSurveyInstanceValues()
        For Each row As DataRow In Me.mFileDefTable.Rows
            If CStr(row("ColumnName")) = "Respondent: RESPONDENTID" Then
                If IsDBNull(row("TextValue")) Then
                    AddToLog("No valid respondent ID was given for this record.")
                    Throw (New System.Exception("Invalid Respondent ID"))
                ElseIf Not IsNumeric(row("TextValue")) Then
                    AddToLog("RespondentID is not numberic.")
                    Throw (New System.Exception("Invalid Respondent ID"))
                Else
                    Me.mRespondentID = CInt(row("TextValue"))
                End If
                Exit For
            End If
        Next
        If Me.mRespondentID <= 0 Then
            AddToLog("RespondentID is not valid.")
            Throw (New System.Exception("Invalid Respondent ID"))
        Else
            Me.mSurveyInstanceID = DataProviders.IU_ImportUpdateProvider.Instance.GetSurveyInstaceID(Me.mRespondentID, Me.mClientID, Me.mSurveyID)
            If Me.mSurveyInstanceID <= 0 Then
                AddToLog("A valid survey instance was not found.")
                Throw New System.Exception("Invalid Survey Instance.")
            End If
        End If
    End Sub
    Private Function GetDataFromLine(ByVal startIndex As Integer, ByVal width As Integer, ByVal line As String) As String
        Dim retVal As String = ""
        retVal = Trim(line.Substring(startIndex, width))        
        Return retVal
    End Function
    Private Sub ClearModVars()
        Me.mTemplateID = 0
        Me.mClientID = 0
        Me.mScriptID = 0
        Me.mFileDefID = 0
        Me.mFileDefTypeID = 0
        Me.mSurveyID = 0
        Me.mFileTypeID = 0
        Me.mRespondentID = 0
        Me.mSurveyInstanceID = 0
        mResponsesExist = False
        mFileDefTable = Nothing
        mRespondentQuestions = Nothing
        'mRespondentFieldUpdates = New List(Of RespondentFieldUpdate)
    End Sub
    
    Private Sub ParseQuestionAnswers()
        Me.mRespondentQuestions = New List(Of RespondentQuestion)
        'TODO:  Make this a regular expression lookup.
        For iCnt As Integer = 0 To Me.mFileDefTable.Rows.Count
            Dim colName As String = CStr(mFileDefTable.Rows(iCnt)("ColumnName"))
            If colName.Substring(0, 1) = "Q" AndAlso colName.IndexOf("."c) > 0 AndAlso colName.IndexOf(":"c) > 0 Then 'May have a question
                colName = Trim(colName.Substring(1, colName.IndexOf(":"c) - 1))
                Dim blnDescField As Boolean = False
                If colName.IndexOf("DESC") > 0 Then
                    blnDescField = True
                    colName.Replace("DESC", "")
                End If
                Dim blnPastQuestion As Boolean = False
                Dim itemOrder As String = ""
                Dim answerDescriptor As String = ""
                For Each c As Char In colName
                    If blnPastQuestion = False Then
                        If IsNumeric(c) Then
                            itemOrder += c
                        End If
                        If c = "."c Then
                            blnPastQuestion = True
                        End If
                    Else
                        If IsNumeric(c) Then
                            answerDescriptor += c
                        End If
                    End If
                Next
                Dim quest As New RespondentQuestion(Me.mRespondentID, CInt(itemOrder), Me.mSurveyID)
                'Q#.X DESC:
                'X = 0, then ac is in the string file.
                'X = #, then string file is 0/1 telling whether it's been chosen."
                'DESC:  Open answer and text value is in the string file.
                'TODO:  Continue Here:  Proc line 850
            End If
        Next
    End Sub
#End Region
#Region " Public Methods "
    Public Sub ProcessFile()
        If ValidateStringFile() Then
            Dim sr As StreamReader = Nothing
            Try
                sr = New StreamReader(Me.mImportFilePath, System.Text.Encoding.ASCII)
                Dim counter As Long = 0
                Do While sr.Peek >= 0
                    counter += 1
                    AddToLog("Processing Record Number: " & counter)
                    Dim strLine As String = sr.ReadLine()
                    mTemplateID = GetTemplateIDFromLine(strLine)
                    'Set the Client, Script and FileDefID
                    SetFileDefVars()
                    'Extract Data from line
                    ExtractDataFromLine(strLine)
                    'Get the Survey Instance and make sure it aligns with the survey, client, and respondent.
                    SetRespondentAndSurveyInstanceValues()
                    'Check for Responses
                    If DataProviders.IU_ImportUpdateProvider.Instance.GetResponseCount(Me.mRespondentID) <= 0 Then
                        AddToLog("No Responses exist for Respondent " & Me.mRespondentID)
                        Me.mResponsesExist = False
                    Else
                        AddToLog("Responses exist is qms for Respondent " & Me.mRespondentID)
                        Me.mResponsesExist = True
                    End If
                    'TODO:  We should care about updating resp fields or properties?????
                    'AddToLog("Begin set of respondent fields for respondent: " & Me.mRespondentID)
                    'SetRespondentFieldUpdates()
                    'TODO:  Find out where and how Batch ID is derived under every circumstance.  Line 624 of stored proc.
                    ParseQuestionAnswers()  'TODO:  Prod Line 727
                    'Clean up class variables for processing of next line.
                    ClearModVars()
                Loop
            Catch ex As Exception
                AddToLog(ex.Message)
            Finally
                If Not sr Is Nothing Then
                    sr.Close()
                    sr = Nothing
                End If
            End Try
        End If
    End Sub
    Public Function GetFileCount() As Long
        Dim sr As StreamReader = Nothing
        Dim counter As Long = 0
        Try
            sr = New StreamReader(Me.mImportFilePath)
            Do While sr.Peek >= 0
                sr.ReadLine()
                counter += 1
            Loop
            Return counter
        Catch ex As Exception
            Return 0
        Finally
            If Not sr Is Nothing Then
                sr.Close()
            End If
        End Try
    End Function
    Public Sub AddToLog(ByVal value As String)
        Me.mImportLog.Add(value)
    End Sub
    Public Function ReadLog() As String
        Dim retVal As New StringBuilder()
        For Each item As String In Me.mImportLog
            retVal.AppendLine(item)
        Next
        Return retVal.ToString
    End Function
#End Region
End Class
'TODO:  Should not need this class.  Check if we need to worry about updating respondent fields or properties.
'Public Class RespondentFieldUpdate
'    Private mRespondentID As Integer
'    Private mColumnName As String
'    Private mValue As String
'    Public Sub New(ByVal respondentID As Integer, ByVal columnName As String, ByVal value As String)
'        Me.mRespondentID = respondentID
'        Me.mColumnName = columnName
'        Me.mValue = value
'    End Sub
'    Public ReadOnly Property RespondentID() As Integer
'        Get
'            Return Me.mRespondentID
'        End Get
'    End Property
'    Public ReadOnly Property ColumnName() As String
'        Get
'            Return Me.mColumnName
'        End Get
'    End Property
'    Public ReadOnly Property Value() As String
'        Get
'            Return Me.mValue
'        End Get
'    End Property
'End Class
Public Class RespondentQuestion
    Private mRespondentID As Integer
    Private mQuestionID As Integer
    Private mSurveyQuestionID As Integer
    Private mItemOrder As Integer
    Private mQuestionName As String
    Private mQuestionTypeID As Integer
    Private mSurveyID As Integer

    Public Sub New(ByVal respondentID As Integer, ByVal itemOrder As Integer, ByVal surveyID As Integer)
        Me.mRespondentID = respondentID
        Me.mItemOrder = itemOrder
        Me.mSurveyID = surveyID
        SetInternalFields()
    End Sub

    Private Sub SetInternalFields()
        Dim surveyQuestTable As DataTable = DataProviders.IU_ImportUpdateProvider.Instance.GetSurveyQuestionValues(Me.mItemOrder, Me.mSurveyID)
        Me.mSurveyQuestionID = CInt(surveyQuestTable.Rows(0)("SurveyQuestionID"))
        Me.mQuestionID = CInt(surveyQuestTable.Rows(0)("QuestionID"))
        Dim questTable As DataTable = DataProviders.IU_ImportUpdateProvider.Instance.GetQuestionValues(Me.mQuestionID)
        Me.mQuestionName = CStr(questTable.Rows(0)("QuestionName"))
        Me.mQuestionTypeID = CInt(questTable.Rows(0)("QuestionTypeID"))
    End Sub
End Class
Public Class RespondentAnswerValue
    Private mAnswerCategoryID As Integer
    Private mQuestionID As Integer
    Private mAnswerValue As Integer
    Private mAnswerText As String
    Private mAnswerCategoryTypeID As Integer
    Private mAnswerDescriptor As String
    Private mblnDescField As Boolean = False
    Public Sub New(ByVal questionID As Integer, ByVal answerDescriptor As String, ByVal answerText As String, ByVal descField As Boolean)
        Me.mQuestionID = questionID
        Me.mAnswerDescriptor = answerDescriptor
        Me.mAnswerText = answerText
        Me.mblnDescField = descField
    End Sub
End Class