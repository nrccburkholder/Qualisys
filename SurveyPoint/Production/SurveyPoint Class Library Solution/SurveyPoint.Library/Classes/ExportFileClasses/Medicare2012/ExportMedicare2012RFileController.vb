Imports Nrc.Framework.BusinessLogic
Imports Nrc.Framework.BusinessLogic.Validation
Imports Nrc.SurveyPoint.Library.DataProviders
Imports System.Data
Imports System.IO
Imports System.Text

Public Interface IExportMedicare2012RFileControllerID
    Property ExportMedicare2012RFileControllerID() As Integer
End Interface

''' <summary>This is the primary business object for an export an export group.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class ExportMedicare2012RFileController
    Inherits BusinessBase(Of ExportMedicare2012RFileController)
    Implements IExportMedicare2012RFileControllerID

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid

    Private mExportMedicare2012RFileCollection As ExportMedicare2012RFileCollection
    Private mResultFileExported As Boolean = False
    Private mMarkSubmitted As Boolean
    Private mExportMedicare2012RFileControllerID As Integer
    Private mLogFileID As Integer
    Private mResultTable As DataTable
    'Private mResultView As DataView
    ''' <summary>This Data set contains the following result sets:  RespondentAnswers, RespondentModel, RespondentProperties, ExportGroupData, ClientInformation, ScriptInformation, RespondentMaxEventDate</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private mResultConntroller As DataSet
    Private mExportGroupID As Integer
    Private mResultFilePath As String

    Private mOrigLogFileID As Integer
    Private mRerunUsingLogDates As Boolean = False
    Private m2401StartDate As Nullable(Of Date) = Nothing
    Private m2401EndDate As Nullable(Of Date) = Nothing

    'TP 20080502
    'These collections are used as storage for validation warning checks.
    Private mcolClientIDs As List(Of String) = New List(Of String)
    Private mcolScriptIDs As List(Of String) = New List(Of String)
    Private mcolExportGroupIDs As List(Of String) = New List(Of String)

    Private mParent As ExportMedicare2012File

    Private mActiveOnly As Boolean = False
#End Region

#Region " Public Properties "

    ''' <summary>Uniquely IDs this class</summary>
    ''' <value>Integer</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ExportMedicare2012RFileControllerID() As Integer Implements IExportMedicare2012RFileControllerID.ExportMedicare2012RFileControllerID
        Get
            Return Me.mExportMedicare2012RFileControllerID
        End Get
        Protected Set(ByVal value As Integer)
            If Not value = mExportMedicare2012RFileControllerID Then
                mExportMedicare2012RFileControllerID = value
                PropertyHasChanged("ExportMedicare2012RFileControllerID")
            End If
        End Set
    End Property
    ''' <summary>Tells whether the file has been exported.</summary>
    ''' <value>Integer</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property ResultFileExported() As Boolean
        Get
            Return Me.mResultFileExported
        End Get
    End Property
    Public Property ActiveOnly() As Boolean
        Get
            Return Me.mActiveOnly
        End Get
        Set(ByVal value As Boolean)
            Me.mActiveOnly = value
        End Set
    End Property
    ''' <summary>This is set in the constructor and is only read only with this object.</summary>
    ''' <value>Boolean</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property MarkSubmitted() As Boolean
        Get
            Return Me.mMarkSubmitted
        End Get
    End Property
    ''' <summary>Collection should be accessed in a read only manner as</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property ResultFileCollection() As ExportMedicare2012RFileCollection
        Get
            Return Me.mExportMedicare2012RFileCollection
        End Get
    End Property
    ''' <summary>The ID of the Export file generating the export</summary>
    ''' <value>Log File ID as integer</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property LogFileID() As Integer
        Get
            Return Me.mLogFileID
        End Get
    End Property
    ''' <summary>The ID of the export group for whom you are exporting.</summary>
    ''' <value>Integer</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property ExportGroupID() As Integer
        Get
            Return Me.mExportGroupID
        End Get
    End Property
    ''' <summary>The path to write to for this export.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ResultFilePath() As String
        Get
            Return Me.mResultFilePath
        End Get
        Set(ByVal value As String)
            If Not Me.mResultFilePath = value Then
                Me.mResultFilePath = value
                PropertyHasChanged("ResultFilePath")
            End If
        End Set
    End Property
    ''' <summary>reference to parent object used to bubble progress and message events back to the UI.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property ParentExportFile() As ExportMedicare2012File
        Get
            Return Me.mParent
        End Get
    End Property
#End Region

#Region " Constructors "
    ''' <summary>Default constructor is not allowed as you need the log and export
    ''' IDs.</summary>
    ''' <param name="parent"></param>
    ''' <param name="ExportLogFileID"></param>
    ''' <param name="origLogFileID"></param>
    ''' <param name="exportGroupID"></param>
    ''' <param name="markSubmitted"></param>
    ''' <param name="rerunUsingLogDates"></param>
    ''' <param name="startDate2401"></param>
    ''' <param name="endDate2401"></param>
    ''' <param name="resultFilePath"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20080425 - Tony Piccoli</term>
    ''' <description>Need to set the number of respondent exported as it is now saved in
    ''' the log file.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Protected Sub New(ByVal parent As ExportMedicare2012File, ByVal ExportLogFileID As Integer, ByVal origLogFileID As Integer, ByVal exportGroupID As Integer, _
    ByVal markSubmitted As Boolean, ByVal rerunUsingLogDates As Boolean, _
    ByVal startDate2401 As Nullable(Of Date), ByVal endDate2401 As Nullable(Of Date), _
    ByVal resultFilePath As String, ByVal pActiveOnly As Boolean)
        Me.CreateNew()
        Me.mParent = parent
        Me.mLogFileID = ExportLogFileID
        Me.mExportGroupID = exportGroupID
        Me.mMarkSubmitted = markSubmitted
        Me.mRerunUsingLogDates = rerunUsingLogDates
        Me.m2401StartDate = startDate2401
        Me.m2401EndDate = endDate2401
        Me.mResultFilePath = resultFilePath
        Me.mOrigLogFileID = origLogFileID
        'Notify events
        Me.mParent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Result File Data Loading.", Nothing, "", "Result File Loading"))
        Me.mParent.RaiseProgressMessage(17, "Result File Data Loading", False)
        LoadControllerDataSet()
        'TP 20080425
        Me.ParentExportFile.MyExportFileLog.RespondentsExported = Me.mResultConntroller.Tables("RespondentModel").Rows.Count
        'Notify events
        Me.mParent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Result File Data Loaded.", Nothing, "", "Result File Loaded"))
        Me.mParent.RaiseProgressMessage(50, "Result File Data Loaded", False)
        'TP 20080605  For performance reasons, have moved to reading the result one at a time while printing the file.
        'CreateResultTableSchema()
        ''Notify events
        'Me.mParent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Result File Data Population.", Nothing, "", "Result File Population"))
        'Me.mParent.RaiseProgressMessage(51, "Result File Data Population", False)
        'PopulateResultTable()
        ''Notify events
        'Me.mParent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Result File Data Populated.", Nothing, "", "Result File Populated"))
        'Me.mParent.RaiseProgressMessage(75, "Result Data Populated", False)
        ''Notify events
        'Me.mParent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Load Response Collection.", Nothing, "", "Load Response Collection"))
        'Me.mParent.RaiseProgressMessage(76, "Load Response Collection", False)
        'LoadResultResponseCollection()
        ''Notify events
        'Me.mParent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Response Collection Loaded.", Nothing, "", "Response Collection Loaded"))
        'Me.mParent.RaiseProgressMessage(80, "Response Collection Loaded", False)
    End Sub
#End Region

#Region " Factory Methods "
    ''' <summary>Factory to create a new result file controller</summary>
    ''' <returns>ExportMedicare2012RFileController</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function NewExportMedicare2012RFileController(ByVal parent As ExportMedicare2012File, ByVal exportFileID As Integer, _
    ByVal origLogFileID As Integer, _
    ByVal exportGroupID As Integer, ByVal markSubmitted As Boolean, ByVal rerunUserLogdates As Boolean, _
    ByVal startDate2401 As Nullable(Of Date), ByVal endDate2401 As Nullable(Of Date), ByVal resultFilePath As String, ByVal activeOnly As Boolean) As ExportMedicare2012RFileController
        Dim totalRespondents As Long = ExportMedicare2012RFileController.GetNumberOfRespondentsByExportGroup(exportGroupID, exportFileID, origLogFileID, markSubmitted, rerunUserLogdates, startDate2401, endDate2401, activeOnly)
        If totalRespondents > Config.MaxNumberOfRespondentsPerExport Then
            Throw New ExportGroupMaxRespondentException("This export has exceeded the maximum number of respondents (" & Config.MaxNumberOfRespondentsPerExport.ToString & ")")
        End If
        Dim resultController As ExportMedicare2012RFileController = New ExportMedicare2012RFileController(parent, exportFileID, origLogFileID, exportGroupID, markSubmitted, rerunUserLogdates, startDate2401, endDate2401, resultFilePath, activeOnly)

        Return resultController
    End Function
    ''' <summary>Returns the number of responses for an export group.</summary>
    ''' <returns>number of respondents for export group</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetNumberOfRespondentsByExportGroup(ByVal exportGroupID As Integer, ByVal logFileID As Integer, ByVal origLogFileID As Integer, ByVal markSubmitted As Boolean, ByVal rerunUsingLogDates As Boolean, ByVal startDate2401 As Nullable(Of Date), ByVal endDate As Nullable(Of Date), ByVal activeOnly As Boolean) As Long
        Return ExportMedicare2012RFileControllerProvider.Instance.GetNumberOfRespondentsForExportGroup(exportGroupID, logFileID, origLogFileID, markSubmitted, rerunUsingLogDates, startDate2401, endDate, activeOnly)
    End Function
#End Region

#Region " Basic Overrides "
    ''' <summary>Set-gets the key identifier for the business object.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mExportGroupID
        End If
    End Function

#End Region

#Region " Validation "
    ''' <summary>Wires validation rules to the properties of the business object.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...

    End Sub
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        'ValidationRules.CheckRules()        
    End Sub

    Public Overrides Sub Save()
        'MyBase.Save()
        Throw New NotImplementedException("Result File Controller does not support saving.")
    End Sub

#End Region

#Region " Public Methods "
    ''' <summary>This method iterates through the result file collection to print the result file.</summary>
    ''' <param name="fileNameAndPath"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function PrintFile() As Integer
        'Notify events
        Me.mParent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Result File Printing.", Nothing, "", "Result File Printing"))
        Me.mParent.RaiseProgressMessage(90, "Result File Printing", False)
        Me.mResultFileExported = False
        Dim tw As StreamWriter = Nothing
        Try
            Dim counter As Long = 0
            Dim startTick As Long = Environment.TickCount
            Dim endTick As Long = 0
            tw = New StreamWriter(Me.mResultFilePath, False, System.Text.Encoding.ASCII)
            tw.AutoFlush = False
            Dim sbTrailer As StringBuilder = New StringBuilder(1300)
            Dim blnFlag As Boolean = False
            'TP 20080604 Loop through DS records to build an export file one at a time.
            'This is done for memory and performance reasons.
            Dim fileRecord As ExportMedicare2012RFile
            Dim currentRespondentID As Integer = 0
            Dim currentClientID As Integer = 0
            Dim currentScriptID As Integer = 0

            'Respondent Fields
            Dim respondentDataRow As System.Data.DataRow
            Dim firstName As String = String.Empty
            Dim lastName As String = String.Empty
            Dim dob As Date
            Dim clientRespID As Long
            Dim surveyInstanceID As Integer

            'Respondent Properties 
            Dim respProperties As System.Data.DataView
            Dim respPropString As StringBuilder
            Dim propString As String = ""
            Dim respPropHash As Dictionary(Of String, String) = Nothing

            'script (Properties)
            Dim scMiscChar1 As String = String.Empty
            Dim scMiscChar2 As String = String.Empty
            Dim scMiscChar3 As String = String.Empty
            Dim scMiscChar4 As String = String.Empty
            Dim scMiscChar5 As String = String.Empty
            Dim scMiscChar6 As String = String.Empty
            Dim scMiscNum1 As Nullable(Of Decimal) = Nothing
            Dim scMiscNum2 As Nullable(Of Decimal) = Nothing
            Dim scMiscNum3 As Nullable(Of Decimal) = Nothing
            Dim scMiscDate1 As Nullable(Of Date) = Nothing
            Dim scMiscDate2 As Nullable(Of Date) = Nothing
            Dim scMiscDate3 As Nullable(Of Date) = Nothing
            Dim scriptRow As System.Data.DataRow

            'Client(Properties)
            Dim clientRow As System.Data.DataRow
            Dim clMiscChar1 As String = String.Empty
            Dim clMiscChar2 As String = String.Empty
            Dim clMiscChar3 As String = String.Empty
            Dim clMiscChar4 As String = String.Empty
            Dim clMiscChar5 As String = String.Empty
            Dim clMiscChar6 As String = String.Empty
            Dim clMiscNum1 As Nullable(Of Decimal) = Nothing
            Dim clMiscNum2 As Nullable(Of Decimal) = Nothing
            Dim clMiscNum3 As Nullable(Of Decimal) = Nothing
            Dim clMiscDate1 As Nullable(Of Date) = Nothing
            Dim clMiscDate2 As Nullable(Of Date) = Nothing
            Dim clMiscDate3 As Nullable(Of Date) = Nothing

            'Export Group Variables
            Dim egTable As Data.DataTable = Me.mResultConntroller.Tables("ExportGroupData")
            Dim exportGroupID As Integer = CInt(egTable.Rows(0)("ExportGroupID"))
            Dim removeHTMLAndEncoding As Boolean = CBool(egTable.Rows(0)("RemoveHTMLAndEncoding"))
            Dim eGMiscChar1 As String = CStr(egTable.Rows(0)("MiscChar1"))
            Dim eGMiscChar2 As String = CStr(egTable.Rows(0)("MiscChar2"))
            Dim eGMiscChar3 As String = CStr(egTable.Rows(0)("MiscChar3"))
            Dim eGMiscChar4 As String = CStr(egTable.Rows(0)("MiscChar4"))
            Dim eGMiscChar5 As String = CStr(egTable.Rows(0)("MiscChar5"))
            Dim eGMiscChar6 As String = CStr(egTable.Rows(0)("MiscChar6"))
            Dim eGMiscNum1 As Nullable(Of Decimal) = NullDec(egTable.Rows(0)("MiscNum1"))
            Dim eGMiscNum2 As Nullable(Of Decimal) = NullDec(egTable.Rows(0)("MiscNum2"))
            Dim eGMiscNum3 As Nullable(Of Decimal) = NullDec(egTable.Rows(0)("MiscNum3"))
            Dim eGMiscDate1 As Nullable(Of Date) = NullDate(egTable.Rows(0)("MiscDate1"))
            Dim eGMiscDate2 As Nullable(Of Date) = NullDate(egTable.Rows(0)("MiscDate2"))
            Dim eGMiscDate3 As Nullable(Of Date) = NullDate(egTable.Rows(0)("MiscDate3"))

            Dim maxDate As Nullable(Of Date) = Nothing

            Dim totalRecordCount As Integer = Me.mResultConntroller.Tables("RespondentAnswers").Rows.Count

            For Each row As Data.DataRow In Me.mResultConntroller.Tables("RespondentAnswers").Rows
                Dim respondentID, clientID, answerCatID, responseID, surveyQuestID, scriptID, answerCatTypeID As Integer
                Dim userID As Nullable(Of Integer) = Nothing
                Dim respText, answerText As String
                Dim answerVal, questionID, itemOrder, surveyID As Integer
                respondentID = CInt(row("RespondentID"))
                clientID = CInt(row("ClientID"))
                scriptID = CInt(row("ScriptID"))
                answerCatID = CInt(row("AnswerCategoryID"))
                responseID = CInt(row("ResponseID"))
                surveyQuestID = CInt(row("QuestionID"))
                userID = NullInt(row("UserID"))
                answerCatTypeID = CInt(row("AnswerCategoryTypeID"))
                respText = CStr(row("ResponseText"))
                answerText = CStr(row("AnswerText"))
                answerVal = CInt(row("AnswerValue"))
                questionID = CInt(row("QuestionID"))
                itemOrder = CInt(row("ItemOrder"))
                surveyID = CInt(row("SurveyID"))
                'Load the values specific to a respondent one time.
                If currentRespondentID = 0 OrElse respondentID <> currentRespondentID Then
                    'Set Respondent Values.
                    respondentDataRow = row.GetParentRow("RespondentAnswersToModel")
                    firstName = CStr(respondentDataRow("FirstName"))
                    lastName = CStr(respondentDataRow("LastName"))
                    dob = CDate(respondentDataRow("DOB"))
                    Dim tempClientRespID As String = Replace(CStr(respondentDataRow("ClientRespondentID")), "-", "")
                    If tempClientRespID.Length > 9 Then
                        tempClientRespID = tempClientRespID.Substring(0, 9)
                    End If
                    clientRespID = CLng(tempClientRespID)
                    surveyInstanceID = CInt(respondentDataRow("SurveyInstanceID"))
                    'Set Respondent property values.
                    respProperties = New DataView(Me.mResultConntroller.Tables("RespondentProperties"), "RespondentID = " & respondentID.ToString, "RespondentID", DataViewRowState.CurrentRows)
                    respPropString = New StringBuilder(1000)
                    For Each propviewRow As Data.DataRowView In respProperties
                        respPropString.Append(CStr(propviewRow("PropertyName")))
                        respPropString.Append("*")
                        respPropString.Append(CStr(propviewRow("PropertyValue")))
                        respPropString.Append("|")
                    Next
                    propString = respPropString.ToString
                    respPropString = Nothing ' Remove from memory
                    If Not propString = "" Then propString = propString.Substring(0, propString.Length - 2)
                    respPropHash = New Dictionary(Of String, String)
                    Dim pipeArray As String() = propString.Split("|"c)
                    propString = "" 'Remove from memory
                    For Each val As String In pipeArray
                        Dim valArray As String() = val.Split("*"c)
                        respPropHash.Add(valArray(0), valArray(1))
                    Next
                    pipeArray = Nothing 'Remove from memory
                    'Set Max Date values.
                    maxDate = Nothing   'ReInit
                    'Dim maxDateView As Data.DataView = New DataView(Me.mResultConntroller.Tables("RespondentMaxEventDate"), "RespondentID = " & respID.ToString, "RespondentID", DataViewRowState.CurrentRows)
                    Dim maxDateRow As Data.DataRow = row.GetParentRow("RespondentAnswersToMaxEventDate")
                    If Not maxDate.HasValue OrElse CDate(maxDateRow("MaxEventDate")).CompareTo(maxDate) = 1 Then
                        maxDate = CDate(maxDateRow("MaxEventDate"))
                    End If
                    maxDateRow = Nothing 'Remove from memory

                    currentRespondentID = respondentID
                End If
                'Load the values specific to a client only when the client changes.
                If currentClientID = 0 OrElse clientID <> currentClientID Then
                    clientRow = row.GetParentRow("RespondentAnswersToClientInfo")
                    clMiscChar1 = CStr(clientRow("MiscChar1"))
                    clMiscChar2 = CStr(clientRow("MiscChar2"))
                    clMiscChar3 = CStr(clientRow("MiscChar3"))
                    clMiscChar4 = CStr(clientRow("MiscChar4"))
                    clMiscChar5 = CStr(clientRow("MiscChar5"))
                    clMiscChar6 = CStr(clientRow("MiscChar6"))
                    clMiscNum1 = NullDec(clientRow("MiscNum1"))
                    clMiscNum2 = NullDec(clientRow("MiscNum2"))
                    clMiscNum3 = NullDec(clientRow("MiscNum3"))
                    clMiscDate1 = NullDate(clientRow("MiscDate1"))
                    clMiscDate2 = NullDate(clientRow("MiscDate2"))
                    clMiscDate3 = NullDate(clientRow("MiscDate3"))
                    currentClientID = clientID
                End If
                'Load the values specific to a script only when the script changes.
                If currentScriptID = 0 OrElse scriptID <> currentScriptID Then
                    scriptRow = row.GetParentRow("RespondentAnswersToScriptInfo")
                    scMiscChar1 = CStr(scriptRow("MiscChar1"))
                    scMiscChar2 = CStr(scriptRow("MiscChar2"))
                    scMiscChar3 = CStr(scriptRow("MiscChar3"))
                    scMiscChar4 = CStr(scriptRow("MiscChar4"))
                    scMiscChar5 = CStr(scriptRow("MiscChar5"))
                    scMiscChar6 = CStr(scriptRow("MiscChar6"))
                    scMiscNum1 = NullDec(scriptRow("MiscNum1"))
                    scMiscNum2 = NullDec(scriptRow("MiscNum2"))
                    scMiscNum3 = NullDec(scriptRow("MiscNum3"))
                    scMiscDate1 = NullDate(scriptRow("MiscDate1"))
                    scMiscDate2 = NullDate(scriptRow("MiscDate2"))
                    scMiscDate3 = NullDate(scriptRow("MiscDate3"))
                    currentScriptID = scriptID
                End If
                'Now, we've got all the data.  Put into BO and print the line.
                fileRecord = ExportMedicare2012RFile.NewExportMedicare2012RFile(Me, totalRecordCount)
                With fileRecord
                    .BeginPopulate()
                    .RespondentID = respondentID
                    .ClientID = clientID
                    .AnswerCategoryID = answerCatID
                    .AnswerValue = answerVal
                    .ResponseID = responseID
                    .ResponseText = respText
                    .SurveyQuestionID = surveyQuestID
                    .UserID = userID
                    .ScriptID = scriptID
                    .AnswerCategoryTypeID = answerCatTypeID
                    .AnswerText = answerText
                    .QuestionID = questionID
                    .ItemOrder = itemOrder
                    .SurveyInstanceID = surveyInstanceID
                    .FirstName = firstName
                    .LastName = lastName
                    .DOB = dob
                    .SurveyID = surveyID
                    .ClientResponseID = clientRespID
                    .MaxEventDate = maxDate
                    .RespondentProperties = respPropHash
                    .ExportGroupID = exportGroupID
                    .RemoveHTMLAndEncoding = removeHTMLAndEncoding
                    .EGMiscChar1 = eGMiscChar1
                    .EGMiscChar2 = eGMiscChar2
                    .EGMiscChar3 = eGMiscChar3
                    .EGMiscChar4 = eGMiscChar4
                    .EGMiscChar5 = eGMiscChar5
                    .EGMiscChar6 = eGMiscChar6
                    .EGMiscNum1 = eGMiscNum1
                    .EGMiscNum2 = eGMiscNum2
                    .EGMiscNum3 = eGMiscNum3
                    .EGMiscDate1 = eGMiscDate1
                    .EGMiscDate2 = eGMiscDate2
                    .EGMiscDate3 = eGMiscDate3
                    .CLMiscChar1 = clMiscChar1
                    .CLMiscChar2 = clMiscChar2
                    .CLMiscChar3 = clMiscChar3
                    .CLMiscChar4 = clMiscChar4
                    .CLMiscChar5 = clMiscChar5
                    .CLMiscChar6 = clMiscChar6
                    .CLMiscNum1 = clMiscNum1
                    .CLMiscNum2 = clMiscNum2
                    .CLMiscNum3 = clMiscNum3
                    .CLMiscDate1 = clMiscDate1
                    .CLMiscDate2 = clMiscDate2
                    .CLMiscDate3 = clMiscDate3
                    .SCMiscChar1 = scMiscChar1
                    .SCMiscChar2 = scMiscChar2
                    .SCMiscChar3 = scMiscChar3
                    .SCMiscChar4 = scMiscChar4
                    .SCMiscChar5 = scMiscChar5
                    .SCMiscChar6 = scMiscChar6
                    .SCMiscNum1 = scMiscNum1
                    .SCMiscNum2 = scMiscNum2
                    .SCMiscNum3 = scMiscNum3
                    .SCMiscDate1 = scMiscDate1
                    .SCMiscDate2 = scMiscDate2
                    .SCMiscDate3 = scMiscDate3
                    .EndPopulate()
                End With
                'You've populated the object (record), now print it.
                tw.WriteLine(fileRecord.PrintLine.ToString)
                ValidateUserInputFields(fileRecord)
                If Not blnFlag Then
                    sbTrailer.Append(fileRecord.PrintTrailerLine())
                    blnFlag = True
                End If
                counter += 1
                If counter Mod 1000 = 0 Then
                    tw.Flush()
                End If
                If counter Mod 10000 = 0 Then
                    Me.mParent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, counter.ToString & " records printed.", Nothing, "", "Result File Printing"))
                End If
            Next
            'End TP 20080604
            'For Each row As ExportMedicare2012RFile In Me.mExportMedicare2012RFileCollection
            '    tw.WriteLine(row.PrintLine().ToString)
            '    ValidateUserInputFields(row)
            '    If Not blnFlag Then
            '        sbTrailer.Append(row.PrintTrailerLine())
            '        blnFlag = True
            '    End If
            'Next
            tw.WriteLine(sbTrailer.ToString())
            tw.Flush()
            Me.mResultFileExported = True
            'Notify events
            Me.mParent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Result File Printed.", Nothing, "", "Result File Printed"))
            Me.mParent.RaiseProgressMessage(99, "Result File Printed", False)
            endTick = Environment.TickCount
            Debug.Print((endTick - startTick).ToString())
            Return totalRecordCount
        Catch ex As Exception
            'Notify events
            Me.mParent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportError, "Result File Print Error.", Nothing, "", "Result File Print Error"))
            Me.mParent.RaiseProgressMessage(100, "Result File Print Error", False)
            Me.mResultFileExported = False
            Throw ex
        Finally
            If Not tw Is Nothing Then
                tw.Close()
            End If
        End Try
    End Function
#End Region

#Region " Private and Protected Methods "
    ''' <summary>Validation for User input data in the result file (Misc Fields) is done here as any record applies to all records and we only want to validate once.</summary>
    ''' <param name="resultRecord"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ValidateUserInputFields(ByVal resultRecord As ExportMedicare2012RFile)
        If Not ClientOrScriptUsedInValidation(CStr(resultRecord.ExportGroupID) & "MiscChar1", "exportgroup") Then
            If resultRecord.EGMiscChar1 = "" Then
                Me.mParent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportWarning, "Export Group MiscChar 1 has no value.", Nothing, "", "Validation Warning"))
            End If
        End If
        If Not ClientOrScriptUsedInValidation(CStr(resultRecord.ExportGroupID) & "MiscChar2", "exportgroup") Then
            If resultRecord.EGMiscChar2 = "" Then
                Me.mParent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportWarning, "Export Group MiscChar 2 has no value.", Nothing, "", "Validation Warning"))
            End If
        End If
        If Not ClientOrScriptUsedInValidation(CStr(resultRecord.ExportGroupID) & "MiscChar3", "exportgroup") Then
            If resultRecord.EGMiscChar3 = "" Then
                Me.mParent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportWarning, "Export Group MiscChar 3 has no value.", Nothing, "", "Validation Warning"))
            End If
        End If
        If Not resultRecord.SCMiscDate1.HasValue Then
            If Not ClientOrScriptUsedInValidation(CStr(resultRecord.ScriptID), "script") Then
                Me.mParent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportWarning, "Script " & resultRecord.ScriptID & " Date 1 has no value.", Nothing, "", "Validation Warning"))
            End If
        End If
        If resultRecord.CLMiscChar1 = "" Then
            If Not ClientOrScriptUsedInValidation(CStr(resultRecord.ClientID), "client") Then
                Me.mParent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportWarning, "Client " & resultRecord.ClientID & " MiscChar 1 has no value.", Nothing, "", "Validation Warning"))
            End If
        End If
        If resultRecord.SCMiscChar1 = "" Then
            If Not ClientOrScriptUsedInValidation(CStr(resultRecord.ScriptID), "script") Then
                Me.mParent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportWarning, "Script " & resultRecord.ScriptID & " MiscChar 1 has no value.", Nothing, "", "Validation Warning"))
            End If
        End If
    End Sub
    ''' <summary>For this file type, certain extensions are validated to show a warning message if they don't exist.  This method makes sure we only do this once for clients and scripts.</summary>
    ''' <param name="id"></param>
    ''' <param name="type"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function ClientOrScriptUsedInValidation(ByVal id As String, ByVal type As String) As Boolean
        Dim retVal As Boolean = False
        Dim blnFound As Boolean = False
        If type.ToLower = "script" Then
            For Each val As String In Me.mcolScriptIDs
                If val = id Then
                    retVal = True
                    Exit For
                End If
            Next
            If Not blnFound Then Me.mcolScriptIDs.Add(id)
        ElseIf type.ToLower = "client" Then
            For Each val As String In Me.mcolClientIDs
                If val = id Then
                    retVal = True
                    Exit For
                End If
            Next
            If Not blnFound Then Me.mcolClientIDs.Add(id)
        ElseIf type.ToLower = "exportgroup" Then
            For Each val As String In Me.mcolExportGroupIDs
                If val = id Then
                    retVal = True
                    Exit For
                End If
            Next
            If Not blnFound Then Me.mcolExportGroupIDs.Add(id)
        End If
        Return retVal
    End Function
    ''' <summary>This method iterates through the result table creating a collectionof
    ''' result file object.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20080414 - Tony Piccoli</term>
    ''' <description>Added new field removeHTMLAndEncoding.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Private Sub LoadResultResponseCollection()
        'Dim totalRecordCount As Integer = Me.mResultTable.Rows.Count
        'Me.mExportMedicare2012RFileCollection = New ExportMedicare2012RFileCollection
        ''TODO:  Switch bake to datatable once sort is in the DB.
        'For Each row As DataRow In Me.mResultTable.Rows
        '    Dim exportResultFile As ExportMedicare2012RFile = ExportMedicare2012RFile.NewExportMedicare2012RFile(Me, totalRecordCount)
        '    With exportResultFile
        '        .BeginPopulate()
        '        .RespondentID = CInt(row("RespondentID"))
        '        .ClientID = CInt(row("ClientID"))
        '        .AnswerCategoryID = CInt(row("AnswerCategoryID"))
        '        .AnswerValue = CInt(row("AnswerValue"))
        '        .ResponseID = CInt(row("ResponseID"))
        '        .ResponseText = CStr(row("ResponseText"))
        '        .SurveyQuestionID = CInt(row("SurveyQuestionID"))
        '        .UserID = NullInt(row("UserID"))
        '        .ScriptID = CInt(row("ScriptID"))
        '        .AnswerCategoryTypeID = CInt(row("AnswerCategoryTypeID"))
        '        .AnswerText = CStr(row("AnswerText"))
        '        .QuestionID = CInt(row("QuestionID"))
        '        .ItemOrder = CInt(row("ItemOrder"))
        '        .SurveyInstanceID = CInt(row("SurveyInstanceID"))
        '        .FirstName = CStr(row("FirstName"))
        '        .LastName = CStr(row("LastName"))
        '        .DOB = CDate(row("DOB"))
        '        .SurveyID = CInt(row("SurveyID"))
        '        .ClientResponseID = CLng(row("ClientResponseID"))
        '        If IsDate(row("MaxEventDate")) Then
        '            .MaxEventDate = CDate(row("MaxEventDate"))
        '        Else
        '            .MaxEventDate = Nothing
        '        End If
        '        Dim tempHash As Hashtable = New Hashtable()
        '        Dim pipeArray As String() = CStr(row("PropertyString")).Split("|"c)
        '        For Each val As String In pipeArray
        '            Dim valArray As String() = val.Split("*"c)
        '            tempHash.Add(valArray(0), valArray(1))
        '        Next
        '        .RespondentProperties = tempHash
        '        .ExportGroupID = CInt(row("ExportGroupID"))
        '        .RemoveHTMLAndEncoding = CBool(row("RemoveHTMLAndEncoding"))
        '        .EGMiscChar1 = CStr(row("EGMiscChar1"))
        '        .EGMiscChar2 = CStr(row("EGMiscChar2"))
        '        .EGMiscChar3 = CStr(row("EGMiscChar3"))
        '        .EGMiscChar4 = CStr(row("EGMiscChar4"))
        '        .EGMiscChar5 = CStr(row("EGMiscChar5"))
        '        .EGMiscChar6 = CStr(row("EGMiscChar6"))
        '        .EGMiscNum1 = NullDec(row("EGMiscNum1"))
        '        .EGMiscNum2 = NullDec(row("EGMiscNum2"))
        '        .EGMiscNum3 = NullDec(row("EGMiscNum3"))
        '        .EGMiscDate1 = NullDate(row("EGMiscDate1"))
        '        .EGMiscDate2 = NullDate(row("EGMiscDate2"))
        '        .EGMiscDate3 = NullDate(row("EGMiscDate3"))
        '        .CLMiscChar1 = CStr(row("CLMiscChar1"))
        '        .CLMiscChar2 = CStr(row("CLMiscChar2"))
        '        .CLMiscChar3 = CStr(row("CLMiscChar3"))
        '        .CLMiscChar4 = CStr(row("CLMiscChar4"))
        '        .CLMiscChar5 = CStr(row("CLMiscChar5"))
        '        .CLMiscChar6 = CStr(row("CLMiscChar6"))
        '        .CLMiscNum1 = NullDec(row("CLMiscNum1"))
        '        .CLMiscNum2 = NullDec(row("CLMiscNum2"))
        '        .CLMiscNum3 = NullDec(row("CLMiscNum3"))
        '        .CLMiscDate1 = NullDate(row("CLMiscDate1"))
        '        .CLMiscDate2 = NullDate(row("CLMiscDate2"))
        '        .CLMiscDate3 = NullDate(row("CLMiscDate3"))
        '        .SCMiscChar1 = CStr(row("SCMiscChar1"))
        '        .SCMiscChar2 = CStr(row("SCMiscChar2"))
        '        .SCMiscChar3 = CStr(row("SCMiscChar3"))
        '        .SCMiscChar4 = CStr(row("SCMiscChar4"))
        '        .SCMiscChar5 = CStr(row("SCMiscChar5"))
        '        .SCMiscChar6 = CStr(row("SCMiscChar6"))
        '        .SCMiscNum1 = NullDec(row("SCMiscNum1"))
        '        .SCMiscNum2 = NullDec(row("SCMiscNum2"))
        '        .SCMiscNum3 = NullDec(row("SCMiscNum3"))
        '        .SCMiscDate1 = NullDate(row("SCMiscDate1"))
        '        .SCMiscDate2 = NullDate(row("SCMiscDate2"))
        '        .SCMiscDate3 = NullDate(row("SCMiscDate3"))
        '        .EndPopulate()
        '    End With
        '    Me.mExportMedicare2012RFileCollection.Add(exportResultFile)
        'Next
    End Sub
    ''' <summary>This method will create the datatable used to populate the result file
    ''' collection</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20080414 - Tony Piccoli</term>
    ''' <description>added new removeHTMLAndEncoding field.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Private Sub CreateResultTableSchema()
        'Me.mResultTable = New DataTable("ResultTable")
        'Dim colString As String = "RespondentID|ClientID|AnswerCategoryID|ResponseID|ResponseText|SurveyQuestionID|"
        'colString += "UserID|ScriptID|AnswerCategoryTypeID|AnswerText|AnswerValue|QuestionID|ItemOrder|SurveyInstanceID|"
        'colString += "FirstName|LastName|DOB|ClientResponseID|PropertyString|SurveyID|ExportGroupID|RemoveHTMLAndEncoding|EGMiscChar1|"
        'colString += "EGMiscChar2|EGMiscChar3|EGMiscChar4|EGMiscChar5|EGMiscChar6|EGMiscNum1|EGMiscNum2|"
        'colString += "EGMiscNum3|EGMiscDate1|EGMiscDate2|EGMiscDate3|CLMiscChar1|CLMiscChar2|CLMiscChar3|CLMiscChar4|"
        'colString += "CLMiscChar5|CLMiscChar6|CLMiscNum1|CLMiscNum2|CLMiscNum3|CLMiscDate1|CLMiscDate2|CLMiscDate3|"
        'colString += "SCMiscChar1|SCMiscChar2|SCMiscChar3|SCMiscChar4|SCMiscChar5|SCMiscChar6|SCMiscNum1|"
        'colString += "SCMiscNum2|SCMiscNum3|SCMiscDate1|SCMiscDate2|SCMiscDate3|MaxEventDate"
        'Dim colArray As String() = colString.Split("|"c)
        'Dim column As Data.DataColumn
        'For Each col As String In colArray
        '    column = New Data.DataColumn(col)
        '    Me.mResultTable.Columns.Add(column)
        'Next
    End Sub
    ''' <summary>Loop through the data sets to build out the result table used to build
    ''' the result file objects</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term> TP 20080411 - Tony Piccoli</term>
    ''' <description>Changed all  PK - FK tables to link by relations rather than using
    ''' view filters for performance reasons.</description></item>
    ''' <item>
    ''' <term>20080414 - Tony Piccoli</term>
    ''' <description>Added new removeHTMLAndEncoding
    ''' field.</description></item></list></RevisionList>
    Private Sub PopulateResultTable()
        'Me.mExportMedicare2012RFileCollection = New ExportMedicare2012RFileCollection
        'If Me.mResultConntroller.Tables("RespondentAnswers").Rows.Count > 200000 Then
        '    Me.mParent.RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportError, "Result File exceeds 200000 records and has been truncated.", Nothing, "", "Max records exceeded."))
        '    Throw New FileTooLargeToProcessException("Respondent answers has exceeded 200000 records.")
        'End If
        'For Each row As Data.DataRow In Me.mResultConntroller.Tables("RespondentAnswers").Rows
        '    'Result fields            
        '    Dim respID, clientID, answerCatID, responseID, surveyQuestID, scriptID, answerCatTypeID As Integer
        '    Dim userID As Nullable(Of Integer) = Nothing
        '    Dim respText, answerText As String
        '    Dim answerVal, questionID, itemOrder, surveyID As Integer

        '    'Respondent Fields
        '    Dim firstName, lastName As String
        '    Dim dob As Date
        '    Dim clientRespID As Long
        '    Dim surveyInstanceID As Integer

        '    'RespondentProperties
        '    Dim respHash As System.Collections.Hashtable = New Hashtable()
        '    Dim propString As String = String.Empty

        '    'Export Group Properties
        '    Dim exportGroupID As Integer
        '    Dim removeHTMLAndEncoding As Boolean = False
        '    Dim eGMiscChar1 As String = String.Empty
        '    Dim eGMiscChar2 As String = String.Empty
        '    Dim eGMiscChar3 As String = String.Empty
        '    Dim eGMiscChar4 As String = String.Empty
        '    Dim eGMiscChar5 As String = String.Empty
        '    Dim eGMiscChar6 As String = String.Empty
        '    Dim eGMiscNum1 As Nullable(Of Decimal)
        '    Dim eGMiscNum2 As Nullable(Of Decimal)
        '    Dim eGMiscNum3 As Nullable(Of Decimal)
        '    Dim eGMiscDate1 As Nullable(Of Date)
        '    Dim eGMiscDate2 As Nullable(Of Date)
        '    Dim eGMiscDate3 As Nullable(Of Date)

        '    'Client(Properties)
        '    Dim clMiscChar1, clMiscChar2, clMiscChar3, clMiscChar4, clMiscChar5, clMiscChar6 As String
        '    Dim clMiscNum1, clMiscNum2, clMiscNum3 As Nullable(Of Decimal)
        '    Dim clMiscDate1, clMisDate2, clMiscDate3 As Nullable(Of Date)

        '    'script (Properties)
        '    Dim scMiscChar1, scMiscChar2, scMiscChar3, scMiscChar4, scMiscChar5, scMiscChar6 As String
        '    Dim scMiscNum1, scMiscNum2, scMiscNum3 As Nullable(Of Decimal)
        '    Dim scMiscDate1, scMisDate2, scMiscDate3 As Nullable(Of Date)

        '    'Max Event Date
        '    Dim maxDate As Nullable(Of Date)

        '    'TODO:  Handle DB Null, do we have a safe data set?
        '    respID = CInt(row("RespondentID"))
        '    clientID = CInt(row("ClientID"))
        '    answerCatID = CInt(row("AnswerCategoryID"))
        '    responseID = CInt(row("ResponseID"))
        '    surveyQuestID = CInt(row("QuestionID"))
        '    userID = NullInt(row("UserID"))
        '    scriptID = CInt(row("ScriptID"))
        '    answerCatTypeID = CInt(row("AnswerCategoryTypeID"))
        '    respText = CStr(row("ResponseText"))
        '    answerText = CStr(row("AnswerText"))
        '    answerVal = CInt(row("AnswerValue"))
        '    questionID = CInt(row("QuestionID"))
        '    itemOrder = CInt(row("ItemOrder"))
        '    surveyID = CInt(row("SurveyID"))
        '    'Respondent Data.
        '    'Dim respDataView As Data.DataView = New DataView(Me.mResultConntroller.Tables("RespondentModel"), "RespondentID = " & respID.ToString, "RespondentID", DataViewRowState.CurrentRows)

        '    Dim respDataRow As Data.DataRow = row.GetParentRow("RespondentAnswersToModel")
        '    firstName = CStr(respDataRow("FirstName"))
        '    lastName = CStr(respDataRow("LastName"))
        '    dob = CDate(respDataRow("DOB"))
        '    clientRespID = CLng(Replace(CStr(respDataRow("ClientRespondentID")), "-", ""))
        '    surveyInstanceID = CInt(respDataRow("SurveyInstanceID"))
        '    'Next
        '    'Respondent Properties.
        '    Dim propView As Data.DataView = New DataView(Me.mResultConntroller.Tables("RespondentProperties"), "RespondentID = " & respID.ToString, "RespondentID", DataViewRowState.CurrentRows)
        '    For Each propviewRow As Data.DataRowView In propView
        '        'respHash.Add(CStr(propviewRow("PropertyName")), CStr(propviewRow("PropertyValue")))
        '        propString += CStr(propviewRow("PropertyName")) & "*" & CStr(propviewRow("PropertyValue")) & "|"
        '    Next
        '    If Not propString = "" Then propString = propString.Substring(0, propString.Length - 2)

        '    'Export Group Properties
        '    Dim egTable As Data.DataTable = Me.mResultConntroller.Tables("ExportGroupData")
        '    exportGroupID = CInt(egTable.Rows(0)("ExportGroupID"))
        '    removeHTMLAndEncoding = CBool(egTable.Rows(0)("RemoveHTMLAndEncoding"))
        '    eGMiscChar1 = CStr(egTable.Rows(0)("MiscChar1"))
        '    eGMiscChar2 = CStr(egTable.Rows(0)("MiscChar2"))
        '    eGMiscChar3 = CStr(egTable.Rows(0)("MiscChar3"))
        '    eGMiscChar4 = CStr(egTable.Rows(0)("MiscChar4"))
        '    eGMiscChar5 = CStr(egTable.Rows(0)("MiscChar5"))
        '    eGMiscChar6 = CStr(egTable.Rows(0)("MiscChar6"))
        '    eGMiscNum1 = NullDec(egTable.Rows(0)("MiscNum1"))
        '    eGMiscNum2 = NullDec(egTable.Rows(0)("MiscNum2"))
        '    eGMiscNum3 = NullDec(egTable.Rows(0)("MiscNum3"))
        '    eGMiscDate1 = NullDate(egTable.Rows(0)("MiscDate1"))
        '    eGMiscDate2 = NullDate(egTable.Rows(0)("MiscDate2"))
        '    eGMiscDate3 = NullDate(egTable.Rows(0)("MiscDate3"))

        '    'Client Properites
        '    'Dim clientView As Data.DataView = New DataView(Me.mResultConntroller.Tables("ClientInformation"), "ClientID = " & clientID.ToString, "ClientID", DataViewRowState.CurrentRows)
        '    'For Each clientRow As Data.DataRowView In clientView
        '    Dim clientRow As DataRow = row.GetParentRow("RespondentAnswersToClientInfo")
        '    clMiscChar1 = CStr(clientRow("MiscChar1"))
        '    clMiscChar2 = CStr(clientRow("MiscChar2"))
        '    clMiscChar3 = CStr(clientRow("MiscChar3"))
        '    clMiscChar4 = CStr(clientRow("MiscChar4"))
        '    clMiscChar5 = CStr(clientRow("MiscChar5"))
        '    clMiscChar6 = CStr(clientRow("MiscChar6"))
        '    clMiscNum1 = NullDec(clientRow("MiscNum1"))
        '    clMiscNum2 = NullDec(clientRow("MiscNum2"))
        '    clMiscNum3 = NullDec(clientRow("MiscNum3"))
        '    clMiscDate1 = NullDate(clientRow("MiscDate1"))
        '    clMisDate2 = NullDate(clientRow("MiscDate2"))
        '    clMiscDate3 = NullDate(clientRow("MiscDate3"))
        '    'Next
        '    'Script Properites
        '    'Dim scriptView As Data.DataView = New DataView(Me.mResultConntroller.Tables("ScriptInformation"), "ScriptID = " & scriptID.ToString, "ScriptID", DataViewRowState.CurrentRows)
        '    'For Each scriptrow As Data.DataRowView In scriptView
        '    Dim scriptRow As DataRow = row.GetParentRow("RespondentAnswersToScriptInfo")
        '    scMiscChar1 = CStr(scriptRow("MiscChar1"))
        '    scMiscChar2 = CStr(scriptRow("MiscChar2"))
        '    scMiscChar3 = CStr(scriptRow("MiscChar3"))
        '    scMiscChar4 = CStr(scriptRow("MiscChar4"))
        '    scMiscChar5 = CStr(scriptRow("MiscChar5"))
        '    scMiscChar6 = CStr(scriptRow("MiscChar6"))
        '    scMiscNum1 = NullDec(scriptRow("MiscNum1"))
        '    scMiscNum2 = NullDec(scriptRow("MiscNum2"))
        '    scMiscNum3 = NullDec(scriptRow("MiscNum3"))
        '    scMiscDate1 = NullDate(scriptRow("MiscDate1"))
        '    scMisDate2 = NullDate(scriptRow("MiscDate2"))
        '    scMiscDate3 = NullDate(scriptRow("MiscDate3"))
        '    'Next

        '    maxDate = Nothing   'ReInit
        '    'Dim maxDateView As Data.DataView = New DataView(Me.mResultConntroller.Tables("RespondentMaxEventDate"), "RespondentID = " & respID.ToString, "RespondentID", DataViewRowState.CurrentRows)
        '    Dim maxDateRow As Data.DataRow = row.GetParentRow("RespondentAnswersToMaxEventDate")
        '    If Not maxDate.HasValue OrElse CDate(maxDateRow("MaxEventDate")).CompareTo(maxDate) = 1 Then
        '        maxDate = CDate(maxDateRow("MaxEventDate"))
        '    End If
        '    'Next
        '    'You have now gathered all the required data, so create the record in the result table that will be used to create the resultfile collection.
        '    Me.mResultTable.Rows.Add(respID, clientID, answerCatID, responseID, respText, surveyQuestID, userID, scriptID, answerCatTypeID, answerText, answerVal, questionID, itemOrder, surveyInstanceID, firstName, lastName, dob, clientRespID, propString, surveyID, exportGroupID, removeHTMLAndEncoding, eGMiscChar1, eGMiscChar2, eGMiscChar3, eGMiscChar4, eGMiscChar5, eGMiscChar6, eGMiscNum1, eGMiscNum2, eGMiscNum3, eGMiscDate1, eGMiscDate2, eGMiscDate3, clMiscChar1, clMiscChar2, clMiscChar3, clMiscChar4, clMiscChar5, clMiscChar6, clMiscNum1, clMiscNum2, clMiscNum3, clMiscDate1, clMisDate2, clMiscDate3, scMiscChar1, scMiscChar2, scMiscChar3, scMiscChar4, scMiscChar5, scMiscChar6, scMiscNum1, scMiscNum2, scMiscNum3, scMiscDate1, scMisDate2, scMiscDate3, maxDate)
        'Next
        ''Mark the object for release from memory.
        'mResultConntroller = Nothing
    End Sub
    ''' <summary>Loads a dataset with tables used to create the export file.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Sub LoadControllerDataSet()
        'Tables (ResultSets) in the data set are named as follows.
        'ds.Tables(0).TableName = "RespondentAnswers"
        'ds.Tables(1).TableName = "RespondentModel"
        'ds.Tables(2).TableName = "RespondentProperties"
        'ds.Tables(3).TableName = "ExportGroupData"
        'ds.Tables(4).TableName = "ClientInformation"
        'ds.Tables(5).TableName = "ScriptInformation"
        'ds.Tables(6).TableName = "RespondentMaxEventDate"
        Me.mResultConntroller = ExportMedicare2012RFileControllerProvider.Instance.GetResultFileDataSet(Me.mExportGroupID, Me.mLogFileID, Me.mOrigLogFileID, Me.MarkSubmitted, Me.mRerunUsingLogDates, Me.m2401StartDate, Me.m2401EndDate, Me.mActiveOnly)
    End Sub
    ''' <summary>Helper method to convert db null in a data row for integer types.</summary>
    ''' <param name="obj"></param>
    ''' <returns>nothing of int value</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function NullDec(ByVal obj As Object) As Nullable(Of Decimal)
        Dim retVal As Nullable(Of Decimal) = Nothing
        If Not IsDBNull(obj) Then
            If IsNumeric(obj) Then
                retVal = CDec(obj)
            End If
        End If
        Return retVal
    End Function
    ''' <summary>Helper method to convert db null in a data row for integer types.</summary>
    ''' <param name="obj"></param>
    ''' <returns>nothing of int value</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function NullInt(ByVal obj As Object) As Nullable(Of Integer)
        Dim retVal As Nullable(Of Integer) = Nothing
        If Not IsDBNull(obj) Then
            If IsNumeric(obj) Then
                retVal = CInt(obj)
            End If
        End If
        Return retVal
    End Function
    ''' <summary>Helper method to conver db nulls in a datarow to date types</summary>
    ''' <param name="obj"></param>
    ''' <returns>nothing or date</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function NullDate(ByVal obj As Object) As Nullable(Of Date)
        Dim retval As Nullable(Of Date) = Nothing
        If Not IsDBNull(obj) Then
            If IsDate(obj) Then
                retval = CDate(obj)
            End If
        End If
        Return retval
    End Function
#End Region

End Class
