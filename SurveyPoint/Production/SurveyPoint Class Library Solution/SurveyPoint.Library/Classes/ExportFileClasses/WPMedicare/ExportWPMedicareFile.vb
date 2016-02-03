Imports Nrc.Framework.BusinessLogic
Imports Nrc.Framework.BusinessLogic.Validation
Imports Nrc.SurveyPoint.Library.DataProviders
Imports System.IO

Public Interface IExportWPMedicareFileID
    Property ExportWPMedicareFileID() As Integer
End Interface

''' <summary>This is the primary business object for an export an export group.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class ExportWPMedicareFile
    Inherits BusinessBase(Of ExportWPMedicareFile)
    Implements IExportWPMedicareFileID
#Region " Public Events "
    Public Event NewMessage As EventHandler(Of ExportMessageArgs)
    Public Event ExportProgress As EventHandler(Of ExportFileProgress)
#End Region
#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid

    Private mQuestionFileController As ExportWPMedicareQFileController
    Private mResultFileController As ExportWPMedicareRFileController
    Private mExportWPMedicareFileID As Integer
    Private mExportLogFile As ExportFileLog
    Private mOriginalLogFileID As Integer
    Private mExportGroup As ExportGroup
    Private mRerunUsingLogDates As Boolean = False
    Private mActiveOnly As Boolean = False
#End Region

#Region " Public Properties "

    ''' <summary>Key field for and Export File (Export group that you are exporting.</summary>
    ''' <value>Integer</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ExportWPMedicareFileID() As Integer Implements IExportWPMedicareFileID.ExportWPMedicareFileID
        Get
            Return Me.mExportWPMedicareFileID
        End Get
        Protected Set(ByVal value As Integer)
            If Not value = mExportWPMedicareFileID Then
                mExportWPMedicareFileID = value
                PropertyHasChanged("ExportWPMedicareFileID")
            End If
        End Set
    End Property
    Public Property ActiveOnly() As Boolean
        Get
            Return Me.mActiveOnly
        End Get
        Set(ByVal value As Boolean)
            Me.mActiveOnly = value
        End Set
    End Property
    Public ReadOnly Property MyExportFileLog() As ExportFileLog
        Get
            Return Me.mExportLogFile
        End Get
    End Property
    Public ReadOnly Property MeExportGroup() As ExportGroup
        Get
            Return Me.mExportGroup
        End Get
    End Property
    ''' <summary>Represents the object that exports the question file.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Property QuestionFileController() As ExportWPMedicareQFileController
        Get
            If Me.mQuestionFileController Is Nothing Then
                Me.mQuestionFileController = ExportWPMedicareQFileController.NewExportWPMedicareQFileController(Me, Me.mExportLogFile.ExportGroupID, Me.mExportLogFile.QuestionFileName)
            End If
            Return Me.mQuestionFileController
        End Get
        'Set should only be used for memory release.
        Private Set(ByVal value As ExportWPMedicareQFileController)
            Me.mQuestionFileController = value
        End Set
    End Property
    ''' <summary>Represents the object that exports the reusult file.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Property ResultFileController() As ExportWPMedicareRFileController
        Get
            If Me.mResultFileController Is Nothing Then
                Me.mResultFileController = ExportWPMedicareRFileController.NewExportWPMedicareRFileController(Me, Me.mExportLogFile.ExportLogFileID, Me.mOriginalLogFileID, Me.mExportLogFile.ExportGroupID, Me.mExportLogFile.MarkSubmitted, Me.mRerunUsingLogDates, Me.mExportGroup.RerunCodeStartDate, Me.mExportGroup.RerunCodeEndDate, Me.mExportLogFile.AnswerFileName, Me.mActiveOnly)
            End If
            Return Me.mResultFileController
        End Get
        'Set should only be used for memory release.
        Private Set(ByVal value As ExportWPMedicareRFileController)
            Me.mResultFileController = value
        End Set
    End Property
#End Region

#Region " Constructors "
    Protected Sub New()
        Me.CreateNew()
    End Sub
    ''' <summary>Overload to prepopulate object.  When you have an export Group (non-rerun) that you wish to create a file on, you use this constructor.</summary>
    ''' <param name="eg"></param>    
    ''' <param name="userID"></param>
    ''' <param name="userName"></param>
    ''' <param name="markSubmitted"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Sub New(ByVal eg As ExportGroup, ByVal userID As Integer, ByVal userName As String, _
            ByVal markSubmitted As Boolean, ByVal pActiveOnly As Boolean)
        Me.mExportGroup = eg
        Dim logFileID As Integer = ExportFileLog.CreateLogFileEntry(eg.ExportGroupID, userID, userName, True, markSubmitted)
        Me.mExportLogFile = ExportFileLog.Get(logFileID)
        Me.mExportLogFile.QuestionFileName = ReplaceFileNameChars(eg.QuestionFileName)
        Me.mExportLogFile.AnswerFileName = ReplaceFileNameChars(eg.ResultFileName)
        Me.mActiveOnly = pActiveOnly
        Me.CreateNew()
    End Sub
    ''' <summary>Constructor used when doing a rerun.</summary>
    ''' <param name="logfileid"></param>
    ''' <param name="userID"></param>
    ''' <param name="userName"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Sub New(ByVal logfileid As Integer, ByVal userID As Integer, ByVal userName As String, ByVal markSubitted As Boolean, ByVal start2401Date As Nullable(Of Date), ByVal end2401Date As Nullable(Of Date), ByVal pActiveOnly As Boolean)
        'Retrieve values from the previous log file.
        Dim origLog As ExportFileLog = ExportFileLog.Get(logfileid)
        Me.mOriginalLogFileID = origLog.ExportLogFileID
        If origLog.MarkSubmitted Then
            mRerunUsingLogDates = True
        End If
        'Get The export group.
        Dim egID As Integer = origLog.ExportGroupID
        Me.mExportGroup = ExportGroup.Get(egID)
        Me.mExportGroup.RerunCodeStartDate = start2401Date
        Me.mExportGroup.RerunCodeEndDate = end2401Date
        'Create the new log file
        Dim newLogID As Integer = ExportFileLog.CreateLogFileEntry(Me.mExportGroup.ExportGroupID, userID, userName, True, markSubitted)
        Me.mExportLogFile = ExportFileLog.Get(newLogID)
        Me.mExportLogFile.QuestionFileName = ReplaceFileNameChars(Me.mExportGroup.QuestionFileName)
        Me.mExportLogFile.AnswerFileName = ReplaceFileNameChars(Me.mExportGroup.ResultFileName)
        Me.mActiveOnly = pActiveOnly
        origLog = Nothing
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    ''' <summary>Required factory for population in the DAL</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function NewExportWPMedicareFile() As ExportWPMedicareFile
        Return New ExportWPMedicareFile
    End Function
    ''' <summary>Factory overload to load properties of new object</summary>
    ''' <param name="exportGroupID"></param>
    ''' <param name="startDate"></param>
    ''' <param name="endDate"></param>
    ''' <param name="userID"></param>
    ''' <param name="userName"></param>
    ''' <param name="markSubmitted"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function NewExportWPMedicareFile(ByVal eg As ExportGroup, ByVal userID As Integer, ByVal userName As String, ByVal markSubmitted As Boolean, ByVal ActiveOnly As Boolean) As ExportWPMedicareFile
        Dim newObject As ExportWPMedicareFile = New ExportWPMedicareFile(eg, userID, userName, markSubmitted, ActiveOnly)
        Return newObject
    End Function
    ''' <summary>Create a new export file object (to create files) from a rerun.</summary>
    ''' <param name="logFileID"></param>
    ''' <param name="userID"></param>
    ''' <param name="userName"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function NewExportWPMedicareFileFromRerun(ByVal logFileID As Integer, ByVal userID As Integer, ByVal userName As String, ByVal markSubmitted As Boolean, ByVal start2401Date As Nullable(Of Date), ByVal end2401Date As Nullable(Of Date), ByVal ActiveOnly As Boolean) As ExportWPMedicareFile
        Dim newObject As ExportWPMedicareFile = New ExportWPMedicareFile(logFileID, userID, userName, markSubmitted, start2401Date, end2401Date, ActiveOnly)
        Return newObject
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
            Return Me.mExportWPMedicareFileID
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
        Throw New NotImplementedException("This object does not require a save.")
    End Sub
    ''' <summary>If mark submitted, then after successfully creating the files.  Mark the respondents of the answer file with a 2401 event code.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub Mark2401EventForLogFile()
        If Me.mExportLogFile.MarkSubmitted Then
            ExportWPMedicareFileProvider.Instance.Mark2401ForLog(Me.mExportLogFile.ExportLogFileID)
        End If
    End Sub
#End Region

#Region " Public Methods "
    ''' <summary>Controls the creation of the answer and question files.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20080414 - Tony Piccoli</term>
    ''' <description>Implemented the save functionality</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public Sub ExportFiles()
        Dim blnError As Boolean = False
        'bubble events to the UI.
        RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "File Export has begun.", Nothing, Nothing, "File Export"))
        RaiseProgressMessage(0, "File export started.", False)
        Try
            Me.mExportLogFile.QuestionFileRecordsExported = Me.QuestionFileController.PrintFile()
            Me.mExportLogFile.AnswerFileRecordsExported = Me.ResultFileController.PrintFile()
            RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Files Exported.", Nothing, Nothing, "File Export"))
            RaiseProgressMessage(99, "File exported.", False)
        Catch ex As Exception
            blnError = True
            Me.mExportLogFile.errorMessage = ex.Message
            Me.mExportLogFile.StackTrace = ex.StackTrace
            RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportError, "File Export has encountered and error.", Nothing, Nothing, "File Export"))
            RaiseProgressMessage(99, "File export errored.", False)
        Finally
            Try
                Me.QuestionFileController = Nothing
                Me.ResultFileController = Nothing
                ExportFileLog.FinishLogFileEntry(Me.mExportLogFile)
                If Me.mExportLogFile.MarkSubmitted AndAlso Not blnError AndAlso Me.mExportLogFile.ExportLogFileID > 0 Then
                    Me.Mark2401EventForLogFile()
                End If
                RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "File Export logged.  Export has finished.", Nothing, Nothing, "File Export"))
                RaiseProgressMessage(100, "File export logged.  Export has finished.", True)
            Catch ex As Exception
                Throw ex
            End Try
        End Try
    End Sub
    ''' <summary>Bubbles events from child objects back to the UI</summary>
    ''' <param name="exportMessage"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub RaiseMessageEvent(ByVal exportMessage As ExportObjectMessage)
        RaiseEvent NewMessage(Me, New ExportMessageArgs(exportMessage))
    End Sub
    ''' <summary>Bubbles progress event from child objects back to the UI.</summary>
    ''' <param name="percentComplete"></param>
    ''' <param name="progressMessage"></param>
    ''' <param name="abort"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub RaiseProgressMessage(ByVal percentComplete As Integer, ByVal progressMessage As String, ByVal abort As Boolean)
        RaiseEvent ExportProgress(Me, New ExportFileProgress(percentComplete, progressMessage, abort))
    End Sub
#End Region
#Region " Private Methods "
    ''' <summary>Helper method to replace %d with date and %t with time in a string.</summary>
    ''' <param name="name"></param>
    ''' <returns>The passed in string with date and time added in if %d or %t exists in the string.</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function ReplaceFileNameChars(ByVal name As String) As String
        Dim retVal As String = name
        If name.IndexOf("%d", 0) > 0 OrElse name.IndexOf("%D", 0) > 0 OrElse name.IndexOf("%t", 0) > 0 OrElse name.IndexOf("%T", 0) > 0 Then
            Dim dt As Date = Date.Now
            Dim d As String = Format(dt, "yyyyMMdd")
            Dim t As String = Format(dt, "hhmmss")
            retVal = Replace(retVal, "%d", d)
            retVal = Replace(retVal, "%D", d)
            retVal = Replace(retVal, "%t", t)
            retVal = Replace(retVal, "%T", t)
        End If
        Return retVal
    End Function
#End Region


End Class
