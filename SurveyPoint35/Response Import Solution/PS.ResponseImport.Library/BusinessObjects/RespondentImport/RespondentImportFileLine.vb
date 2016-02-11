Imports System.IO
Imports System.Text
Imports System.Text.RegularExpressions
Imports System.Data
''' <summary>
''' This class processes a line in the responent import file.  Each line is representative of 1 respondents with
''' their corresponding answers.
''' </summary>
''' <remarks></remarks>
Public Class RespondentImportFileLine
#Region " Private Fields "
    Dim mRespLineID As String = Guid.NewGuid().ToString
    Dim mRespFileID As String = String.Empty
    Dim mFileLine As String = String.Empty
    Dim mFileIndex As Long = 0
    Dim mClientID As Integer = 0
    Dim mSurveyID As Integer = 0
    Dim mSurveyInstanceID As Integer = 0
    Dim mRespondentID As Integer = 0
    Dim mUserID As Integer = 1
    Dim mSurveySystemType As SurveySystemType = Nothing
    Dim mFileDefID As Integer = 0
    Dim mTemplateID As Integer = 0
    Dim mScriptID As Integer = 0
    Dim mFileDefTypeID As Integer = 0
    Dim mFileTypeID As Integer = 0
    Dim mBatchID As String = String.Empty
    Dim mFileDefDataTable As DataTable = Nothing
    Dim mRespondentHasResponses As Boolean = False    
#End Region
#Region " Constructors "
    ''' <summary>
    ''' Notice there is not default constructor.  The parameters for this constructor are absolutely 
    ''' required!!!
    ''' </summary>
    ''' <param name="strLine"></param>
    ''' <param name="fileIndex"></param>
    ''' <param name="fileGUID"></param>
    ''' <remarks></remarks>
    Public Sub New(ByVal strLine As String, ByVal fileIndex As Long, ByVal fileGUID As String, ByVal surveySystemType As SurveySystemType)
        Me.mFileLine = strLine
        Me.mFileIndex = fileIndex
        Me.mTemplateID = GetTemplateIDFromLine(strLine)
        Me.mRespFileID = fileGUID
        Me.mSurveySystemType = surveySystemType
    End Sub
#End Region
#Region " Private Methods "
    ''' <summary>
    ''' Retrieves the template ID from the string.  This values allows us to derive the client, script, and file def used for the line.
    ''' </summary>
    ''' <param name="strLine"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function GetTemplateIDFromLine(ByVal strLine As String) As Integer
        Dim retVal As Integer = 0
        Dim rx As New Regex("^.{18}([\d\s]{5})")
        'TODO:  Document what this regex does.
        If rx.IsMatch(strLine) Then
            Dim m As Match = rx.Match(strLine)
            retVal = CInt(m.Groups(1).Value)
        End If
        Return retVal
    End Function
    ''' <summary>
    ''' This method retrieves variables for the data store based on the template id. 
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub SetFileDefVars()
        Try
            Dim defTable As DataTable = RespondentImportFileLineProvider.Instance.GetFileDefVarsByTemplateID(Me.mTemplateID)
            Me.mClientID = CInt(defTable.Rows(0)("ClientID"))
            Me.mScriptID = CInt(defTable.Rows(0)("ScriptID"))
            Me.mFileDefID = CInt(defTable.Rows(0)("FileDefID"))
            Me.mSurveyID = CInt(defTable.Rows(0)("SurveyID"))
            Me.mFileDefTypeID = CInt(defTable.Rows(0)("FileDefTypeID"))
            Me.mFileTypeID = CInt(defTable.Rows(0)("FileTypeID"))
            If Me.mTemplateID <= 0 OrElse Me.mClientID <= 0 OrElse Me.mScriptID <= 0 OrElse Me.mFileDefID <= 0 OrElse Me.mSurveyID <= 0 OrElse Me.mFileDefTypeID <= 0 Then
                RespondentImportFileLineLog.AddToLog(Me.mRespFileID, Me.mRespLineID, Me.mFileIndex, Me.mSurveyID, Me.mClientID, Me.mSurveyInstanceID, Me.mTemplateID, Me.mFileDefID, Me.mBatchID, Nothing, "Invalid Field Definition Variable", LogSeverity.Error)
                Throw New AppException("Invalid Template Variables.")
            ElseIf Me.mFileDefTypeID <> 3 And Me.mFileDefTypeID <> 1 Then
                RespondentImportFileLineLog.AddToLog(Me.mRespFileID, Me.mRespLineID, Me.mFileIndex, Me.mSurveyID, Me.mClientID, Me.mSurveyInstanceID, Me.mTemplateID, Me.mFileDefID, Me.mBatchID, Nothing, "Invalid File Def Type", LogSeverity.Error)
                Throw New AppException("Invalid Template Variables.")
            ElseIf Me.mFileTypeID <> 4 Then
                RespondentImportFileLineLog.AddToLog(Me.mRespFileID, Me.mRespLineID, Me.mFileIndex, Me.mSurveyID, Me.mClientID, Me.mSurveyInstanceID, Me.mTemplateID, Me.mFileDefID, Me.mBatchID, Nothing, "Invalid File Type ID", LogSeverity.Error)
                Throw New AppException("Invalid Template Variables.")
            End If
        Catch ex As Exception
            RespondentImportFileLineLog.AddToLog(Me.mRespFileID, Me.mRespLineID, Me.mFileIndex, Me.mSurveyID, Me.mClientID, Me.mSurveyInstanceID, Me.mTemplateID, Me.mFileDefID, Me.mBatchID, Nothing, "Error retrieving file def variables: " & ex.Message & " ST: " & Left(ex.StackTrace, 7000), LogSeverity.Error)
            Throw ex
        End Try
    End Sub
    ''' <summary>
    ''' Retrieves a value from the given line based off of the position in the file definition.
    ''' </summary>
    ''' <param name="startIndex"></param>
    ''' <param name="width"></param>
    ''' <param name="line"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function GetDataFromLine(ByVal startIndex As Integer, ByVal width As Integer, ByVal line As String) As String
        Dim retVal As String = ""        
        retVal = Trim(line.Substring(startIndex, width))
        Return retVal
    End Function
    ''' <summary>
    ''' Q1.0 DESC: will always have a Q1.0: counterpart. this is really one answer.  We need
    ''' to move the answervalue to the rows containing the answer text and flag (by setting the answer value to 0)
    ''' the other row so we only insert 1 record for this answers.
    ''' Also, if the answre was not checked, don't report the answer.
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub CleanQuestions()
        For i As Integer = 0 To Me.mFileDefDataTable.Rows.Count - 1
            Dim row As DataRow = Me.mFileDefDataTable.Rows(i)
            If CStr(row("FieldType")) = RespondentImportFieldType.Answer.ToString() Then
                'Set the DFAnswerValue for Descriptions that have an answer Value of 0.
                'These are set from AnswerValues of their non-Desc counterparts.
                'For example.  Q1.0 DESC: will always have a Q1.0: counterpart.
                If CBool(row("ContainsDESC")) Then
                    If CInt(row("DFAnswerValue")) = 0 Then
                        'We don't want to load blank descriptions
                        If Trim(CStr(row("DFAnswerText"))) <> "" Then
                            'Here is a description that needs a corresponding answer value.
                            Dim tempSurveyQuestionItemOrder As Integer = CInt(row("SurveyQuestionItemOrder"))
                            For j As Integer = 0 To Me.mFileDefDataTable.Rows.Count - 1
                                Dim innerRow As DataRow = Me.mFileDefDataTable.Rows(j)
                                If CStr(innerRow("FieldType")) = RespondentImportFieldType.Answer.ToString() Then
                                    If CInt(innerRow("SurveyQuestionItemOrder")) = tempSurveyQuestionItemOrder AndAlso CBool(innerRow("ContainsDESC")) = False Then
                                        If CInt(Val(innerRow("DFAnswerValue"))) > 0 Then
                                            row("DFAnswerValue") = innerRow("DFAnswerValue")
                                            'Set the inner row answer value to 0 as you don't need it.
                                            innerRow("DFAnswerValue") = "0"
                                            Exit For
                                        End If
                                    End If
                                End If
                            Next
                        End If
                    ElseIf Trim(CStr(row("DFAnswerText"))) = "" Then
                        'We don't want to load blank descriptions
                        row("DFAnswerValue") = "0"
                    End If
                End If
            End If
        Next
    End Sub
    ''' <summary>
    ''' Flag each row in the FileDef table for the following:
    ''' SurveyQuestionItemOrder
    ''' Flag as an answer.
    ''' Flag the type of answer (Single or mult select - open end or answer cat value).
    ''' Flag the AnswerCategoryID 
    ''' </summary>
    ''' <param name="row"></param>
    ''' <remarks></remarks>
    Private Sub ParseQuestionAnswers(ByRef row As DataRow)
        'This assumes IsAsnwer method has run and the Column Name is in Valide format (Q#.#[ DESC]:)
        Dim colName As String = CStr(row("ColumnName"))
        Dim tempSurveyQuestionItemOrder As String = colName.Substring(1, colName.IndexOf("."c) - 1)
        row("SurveyQuestionItemOrder") = tempSurveyQuestionItemOrder
        row("FieldType") = RespondentImportFieldType.Answer
        Dim tempSurveyAnswerCategory As String = colName.Substring(colName.IndexOf("."c) + 1, colName.IndexOf(":"c) - colName.IndexOf("."c) - 1)
        Dim descFlag As Boolean = False
        If (tempSurveyAnswerCategory.Length > 4 And Right(tempSurveyAnswerCategory, 5) = " DESC") Then
            tempSurveyAnswerCategory = Left(tempSurveyAnswerCategory, tempSurveyAnswerCategory.Length - 5)
            descFlag = True
        End If
        row("ContainsDESC") = "false" 'Default
        If descFlag AndAlso CInt(tempSurveyAnswerCategory) = 0 Then
            row("DFAnswerValue") = "0"
            row("DFAnswerText") = row("TextValue")
            row("ContainsDESC") = "true"
        ElseIf descFlag AndAlso CInt(tempSurveyAnswerCategory) > 0 Then            
            row("DFAnswerValue") = CStr(tempSurveyAnswerCategory)
            row("DFAnswerText") = CStr(row("TextValue"))
            row("ContainsDESC") = "true"
        ElseIf CInt(tempSurveyAnswerCategory) = 0 Then            
            row("DFAnswerValue") = CStr(Val(row("TextValue"))) 'Keep string becauuse empty strings denote a null vaule.
            row("DFAnswerText") = ""
        Else            
            row("DFAnswerText") = ""
            If Trim(CStr(row("TextValue"))) = "1" Then
                row("DFAnswerValue") = CStr(tempSurveyAnswerCategory)
            Else
                row("DFAnswerValue") = "0"
            End If
        End If
    End Sub
    ''' <summary>
    ''' This method determines if the FileDef Column is relates to an answer in the data file.
    ''' File Def column name is in the following format Q#.#[ DESC] for an answer
    ''' </summary>
    ''' <param name="colName"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function IsAnswer(ByVal colName As String) As Boolean
        Dim retVal As Boolean = False
        If Left(colName, 1) = "Q" Then
            If colName.IndexOf("."c) > 1 Then
                Dim tempSurveyQuestionItemOrder As String = colName.Substring(1, colName.IndexOf("."c) - 1)
                If IsNumeric(tempSurveyQuestionItemOrder) Then
                    Dim tempSurveyAnswerCategory As String = colName.Substring(colName.IndexOf("."c), colName.IndexOf(":"c) - colName.IndexOf("."c))
                    If (tempSurveyAnswerCategory.Length > 4 And Right(tempSurveyAnswerCategory, 5) = " DESC") OrElse IsNumeric(tempSurveyAnswerCategory) Then
                        retVal = True
                    End If
                End If
            End If
        End If
        Return retVal
    End Function
    ''' <summary>
    ''' This method validates that the information for this line passes all validation possibly without data access prior to importing.
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub PreDBValidate()
        Dim validationMessages As New List(Of String)
        If Me.mRespondentID <= 0 Then
            validationMessages.Add("An invalid RespondentID was given at index " & Me.mFileIndex)
        End If
        If Me.mClientID <= 0 Then
            validationMessages.Add("An invalid ClientID was derived at index " & Me.mFileIndex)
        End If
        If Me.mSurveyID <= 0 Then
            validationMessages.Add("An invalid SurveyID was derived at index " & Me.mFileIndex)
        End If
        If Me.mSurveyInstanceID <= 0 Then
            validationMessages.Add("An invalid SurveyInstance ID was derived as index " & Me.mFileIndex)
        End If
        If Me.mFileDefID <= 0 Then
            validationMessages.Add("An invalid FileDefID was derived at index " & Me.mFileIndex)
        End If
        If Me.mFileDefTypeID <= 0 Then
            validationMessages.Add("An invalid  FileDefTypeID was derived at index " & Me.mFileIndex)
        End If
        For i As Integer = 0 To Me.mFileDefDataTable.Rows.Count - 1
            Dim row As DataRow = Me.mFileDefDataTable(i)
            If row("FieldType") = RespondentImportFieldType.Answer.ToString() Then
                If Not (IsNumeric(row("SurveyQuestionItemOrder"))) Then
                    validationMessages.Add("An invalid  survey question item order was found at " & Me.mFileIndex)
                    Exit For
                End If
            End If
        Next
        If validationMessages.Count <> 0 Then
            Dim valMsgs As New StringBuilder()
            For Each msg As String In validationMessages
                valMsgs.AppendLine(msg)
            Next
            RespondentImportFileLineLog.AddToLog(Me.mRespFileID, Me.mRespLineID, Me.mFileIndex, Me.mSurveyID, Me.mClientID, Me.mSurveyInstanceID, Me.mTemplateID, Me.mFileDefID, Me.mBatchID, Nothing, "Pre-DB Validation encountered errors.", LogSeverity.Error)
            Throw New ApplicationException("Pre DB validation Error")
        End If
    End Sub
    ''' <summary>
    ''' This method loads the answers into a staging table and call a proc to import the responses.
    ''' Once completed, it removes the responses from the staging table.
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub ImportResponses()
        For i As Integer = 0 To Me.mFileDefDataTable.Rows.Count - 1
            Dim myRow As DataRow = Me.mFileDefDataTable.Rows(i)
            If CStr(myRow("FieldType")) = RespondentImportFieldType.Answer.ToString() Then
                'Only add questions that were answered.
                If Val(myRow("DFAnswerValue")) > 0 Then
                    'Add RespondentID and Template ID.  This is redundant, but it makes the table more valuable if you need to debug.
                    RespondentImportFileLineProvider.Instance.ImportResponseToStaging(Me.mRespondentID, Me.mTemplateID, CInt(myRow("SurveyQuestionItemOrder")), CInt(myRow("DFAnswerValue")), _
                                                                                    CStr(myRow("DFAnswerText")), Me.mRespFileID, Me.mRespLineID)
                End If
            End If
        Next
        RespondentImportFileLineLog.AddToLog(Me.mRespFileID, Me.mRespLineID.ToString, Me.mFileIndex, Me.mSurveyID, Me.mClientID, Me.mSurveyInstanceID, Me.mTemplateID, Me.mFileDefID, Me.mBatchID, Nothing, "Responses Loaded", LogSeverity.Informational)
        Dim DT As DataTable = RespondentImportFileLineProvider.Instance.ImportResponses(Me.mRespLineID, Me.mRespFileID, Me.mClientID, Me.mSurveyID, _
                                                                                        Me.mSurveyInstanceID, Me.mRespondentID, Me.mTemplateID, Me.mFileDefID, _
                                                                                        1, Me.mBatchID, Me.mScriptID, Me.mSurveySystemType)
        If DT.Rows.Count > 0 Then
            Dim lst As New List(Of String)
            Dim sb As New StringBuilder()
            For Each row As DataRow In DT.Rows
                lst.Add(CStr(row("ErrDescription")))
                sb.Append(CStr(row("ErrDescription")))
                sb.Append(", ")
            Next
            RespondentImportFileLineLog.AddToLog(Me.mRespFileID, Me.mRespLineID, Me.mFileIndex, Me.mSurveyID, Me.mClientID, Me.mSurveyInstanceID, Me.mTemplateID, Me.mFileDefID, Me.mBatchID, Nothing, "Import Errors: " & Left(sb.ToString, 7000), LogSeverity.Error)
            Throw New AppException(lst)
        End If
        RespondentImportFileLineLog.AddToLog(Me.mRespFileID, Me.mRespLineID.ToString, Me.mFileIndex, Me.mSurveyID, Me.mClientID, Me.mSurveyInstanceID, Me.mTemplateID, Me.mFileDefID, Me.mBatchID, Nothing, "Responses Imported", LogSeverity.Informational)
        RespondentImportFileLineProvider.Instance.RemoveImportResponses(Me.mRespFileID, Me.mRespLineID)
        RespondentImportFileLineLog.AddToLog(Me.mRespFileID, Me.mRespLineID.ToString, Me.mFileIndex, Me.mSurveyID, Me.mClientID, Me.mSurveyInstanceID, Me.mTemplateID, Me.mFileDefID, Me.mBatchID, Nothing, "Responses Staging Cleared", LogSeverity.Informational)
    End Sub
    ''' <summary>
    ''' Helper method to debug table values.
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function FileDefTableToString() As String
        Dim sb As New StringBuilder
        Dim tempString As String = String.Empty
        For i As Integer = 0 To Me.mFileDefDataTable.Columns.Count - 1
            tempString += Me.mFileDefDataTable.Columns(i).ColumnName & ","
        Next
        tempString = tempString.Substring(0, tempString.Length - 1)
        sb.AppendLine(tempString)
        For Each row As DataRow In Me.mFileDefDataTable.Rows
            tempString = ""
            For i As Integer = 0 To Me.mFileDefDataTable.Columns.Count - 1
                tempString += Replace(StringHelpers.NullString(row(i)), ",", "COMMA") & ","
            Next
            tempString = tempString.Substring(0, tempString.Length - 1)
            sb.AppendLine(tempString)
        Next
        Return sb.ToString
    End Function
#End Region
#Region " Public Methods "
    ''' <summary>
    ''' This is the publicly exposed method which parses the line, validates the respondent and responses
    ''' and loads the responses into the datastore.
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub LoadLine()        
        Me.mTemplateID = GetTemplateIDFromLine(Me.mFileLine)
        RespondentImportFileLineLog.AddToLog(Me.mRespFileID, Me.mRespLineID, Me.mFileIndex, Me.mSurveyID, Me.mClientID, Me.mSurveyInstanceID, Me.mTemplateID, Me.mFileDefID, Me.mBatchID, Nothing, "Retrieved Template ID", LogSeverity.Informational)
        SetFileDefVars()
        RespondentImportFileLineLog.AddToLog(Me.mRespFileID, Me.mRespLineID, Me.mFileIndex, Me.mSurveyID, Me.mClientID, Me.mSurveyInstanceID, Me.mTemplateID, Me.mFileDefID, Me.mBatchID, Nothing, "Retrieved Field Definition Variables", LogSeverity.Informational)
        'This must be at the line level as their may be files with multiple file def ids in .
        'These are the columns that will return (FileDefColumnID, FileDefID, ColumnName, Width, FileDefItemOrder)  The rest (below) you must populate.
        'ColumnName, Width, TextValue, AnswerCategoryID, FileDefItemOrder, SurveyQuestionItemOrder, QuestionID, AnswerParseType, FieldType
        'FileDefColumnID, FileDefID, ColumnName, Width, AnswerValue, AnswerText, SurveyQuestionItemOrder, FileDefItemOrder, FileType
        'Can now derive:  QuestionID, SurveyQuestionID, AnswerCategoryID, AnswerCategoryTypeID, QuestionTypeID
        Me.mFileDefDataTable = RespondentImportFileLineProvider.Instance.GetFileDefTableByFileDefID(Me.mFileDefID)
        RespondentImportFileLineLog.AddToLog(Me.mRespFileID, Me.mRespLineID, Me.mFileIndex, Me.mSurveyID, Me.mClientID, Me.mSurveyInstanceID, Me.mTemplateID, Me.mFileDefID, Me.mBatchID, Nothing, "Retrieved File Defintion", LogSeverity.Informational)
        Dim startIndex As Integer = 0
        For i As Integer = 0 To Me.mFileDefDataTable.Rows.Count - 1
            Dim width As Integer = CInt(Me.mFileDefDataTable.Rows(i)("Width"))
            Me.mFileDefDataTable.Rows(i)("TextValue") = GetDataFromLine(startIndex, width, Me.mFileLine)
            startIndex += width
            If Left(Me.mFileDefDataTable.Rows(i)("ColumnName"), 10) = "Skip Field" Then
                Me.mFileDefDataTable.Rows(i)("FieldType") = RespondentImportFieldType.SkipField
            ElseIf UCase(Left(Me.mFileDefDataTable.Rows(i)("ColumnName"), 11)) = "RESPONDENT:" Then
                Me.mFileDefDataTable.Rows(i)("FieldType") = RespondentImportFieldType.RespondentValue
                If UCase(Trim(CStr(Me.mFileDefDataTable.Rows(i)("ColumnName")))) = "RESPONDENT: BATCHID" Then
                    Me.mBatchID = CStr(Me.mFileDefDataTable.Rows(i)("TextValue"))
                End If
                If UCase(Trim(CStr(Me.mFileDefDataTable.Rows(i)("ColumnName")))) = "RESPONDENT: RESPONDENTID" Then
                    If Not IsNumeric(Me.mFileDefDataTable.Rows(i)("TextValue")) Then
                        RespondentImportFileLineLog.AddToLog(Me.mRespFileID, Me.mRespLineID, Me.mFileIndex, Me.mSurveyID, Me.mClientID, Me.mSurveyInstanceID, Me.mTemplateID, Me.mFileDefID, Me.mBatchID, Nothing, "RespondentID is not valid", LogSeverity.Error)
                        Throw New ApplicationException("RespondentID not numeric.")
                    Else
                        Me.mRespondentID = CInt(Me.mFileDefDataTable.Rows(i)("TextValue"))
                    End If
                End If
            ElseIf UCase(Left(Me.mFileDefDataTable.Rows(i)("ColumnName"), 9)) = "PROPERTY:" Then
                Me.mFileDefDataTable.Rows(i)("FieldType") = RespondentImportFieldType.RespondentPropValue
            ElseIf IsAnswer(CStr(Me.mFileDefDataTable.Rows(i)("ColumnName"))) Then
                ParseQuestionAnswers(Me.mFileDefDataTable.Rows(i))
            End If
        Next
        CleanQuestions()
        'TODO:  Here we may still want to:
        '1.  Append the Question Answer Text to the appropriate Answer Value Ex.  Q34.0: - Q34.0 DESC.
        '2.  Do we want to remove answers that are not valid for the script???
        RespondentImportFileLineLog.AddToLog(Me.mRespFileID, Me.mRespLineID, Me.mFileIndex, Me.mSurveyID, Me.mClientID, Me.mSurveyInstanceID, Me.mTemplateID, Me.mFileDefID, Me.mBatchID, Nothing, "Responses Loaded to memory.", LogSeverity.Informational)
        Me.mSurveyInstanceID = RespondentImportFileLineProvider.Instance.GetSurveyInstanceID(Me.mRespondentID, Me.mClientID, Me.mSurveyID)
        PreDBValidate()
        RespondentImportFileLineLog.AddToLog(Me.mRespFileID, Me.mRespLineID, Me.mFileIndex, Me.mSurveyID, Me.mClientID, Me.mSurveyInstanceID, Me.mTemplateID, Me.mFileDefID, Me.mBatchID, Nothing, "Pre Database Validation preformed.", LogSeverity.Informational)
        'TP 20090625
        If RespondentImportFileLineProvider.Instance.HasCompleteCode(Me.mRespondentID) Then
            'Don't process this line.
            RespondentImportFileLineLog.AddToLog(Me.mRespFileID, Me.mRespLineID, Me.mFileIndex, Me.mSurveyID, Me.mClientID, Me.mSurveyInstanceID, Me.mTemplateID, Me.mFileDefID, Me.mBatchID, Nothing, "Respondent not processed - Already has a complete code.", LogSeverity.Informational)
        Else
            ImportResponses()
        End If              
        'TODO, are their cases where we shouldn't allow partial responses.     
        'TODO, Don't forget about batching events.
    End Sub
#End Region
End Class
Public MustInherit Class RespondentImportFileLineProvider
#Region " Singleton Implementation "
    Private Shared mInstance As RespondentImportFileLineProvider
    Private Const mProviderName As String = "RespondentImportFileLineProvider"
    ''' <summary>Retrieves the instance of the Data provider class that will implement the abstract methods.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property Instance() As RespondentImportFileLineProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of RespondentImportFileLineProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region
#Region " Constructors "
    Protected Sub New()
    End Sub
#End Region
#Region " Abstract Methods "
    Public MustOverride Function GetFileDefVarsByTemplateID(ByVal templateID As Integer) As DataTable
    Public MustOverride Function GetFileDefTableByFileDefID(ByVal fileDefID As Integer) As DataTable
    Public MustOverride Function GetSurveyInstanceID(ByVal respID As Integer, ByVal clientID As Integer, ByVal surveyID As Integer) As Integer
    Public MustOverride Function HasResponses(ByVal respID As Integer) As Boolean
    Public MustOverride Sub ImportResponseToStaging(ByVal respondentid As Integer, ByVal templateid As Integer, ByVal surveyQuestionItemOrder As Integer, _
                                                ByVal answerValue As Integer, ByVal answerText As String, _
                                                ByVal fileGuid As String, ByVal lineGuid As String)
    Public MustOverride Function ImportResponses(ByVal lineGuid As String, ByVal fileGuid As String, ByVal clientID As Integer, _
                                                    ByVal surveyID As Integer, ByVal surveyInstanceID As Integer, ByVal respondentID As Integer, _
                                                    ByVal templateID As Integer, ByVal fileDefID As Integer, ByVal userID As Integer, _
                                                    ByVal batchID As String, ByVal scriptID As Integer, ByVal surveySystemType As SurveySystemType) As DataTable
    Public MustOverride Sub RemoveImportResponses(ByVal fileGuid As String, ByVal lineGuid As String)
    Public MustOverride Function HasCompleteCode(ByVal respondentID As Integer) As Boolean
#End Region
End Class