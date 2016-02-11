Imports Nrc.Framework.BusinessLogic
Imports Nrc.SurveyPoint.Library.DataProviders

Public Interface IExportFileLog
    Property ExportLogFileID() As Integer
End Interface

<Serializable()> _
Public Class ExportFileLog
    Inherits BusinessBase(Of ExportFileLog)
    Implements IExportFileLog

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mExportLogFileID As Integer
    Private mExportGroupID As Integer
    Private mExportGroupName As String
    'TP 20080414 Make dates nullable
    Private mStartDate As Nullable(Of Date)
    Private mEndDate As Nullable(Of Date)
    Private mUserID As Integer
    Private mUserName As String = String.Empty
    Private mIsActive As Boolean
    Private mQuestionFileRecordsExported As Integer
    Private mAnswerFileRecordsExported As Integer
    Private merrorMessage As String = String.Empty
    Private mStackTrace As String = String.Empty
    Private mMarkSubmitted As Boolean
    Private mQuestionFileName As String = String.Empty
    Private mAnswerFileName As String = String.Empty
    'TP 20080416
    Private mMark2401RangeStartDate As Nullable(Of Date)
    Private mMark2401RangeEndDate As Nullable(Of Date)
    'SK 20080425
    Private mRespondentsExported As Integer
#End Region

#Region " Public Properties "
    Public Property ExportLogFileID() As Integer Implements IExportFileLog.ExportLogFileID
        Get
            Return mExportLogFileID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mExportLogFileID Then
                mExportLogFileID = value
                PropertyHasChanged("ExportLogFileID")
            End If
        End Set
    End Property
    Public Property ExportGroupID() As Integer
        Get
            Return mExportGroupID
        End Get
        Set(ByVal value As Integer)
            If Not value = mExportGroupID Then
                mExportGroupID = value
                PropertyHasChanged("ExportGroupID")
            End If
        End Set
    End Property
    Public Property ExportGroupName() As String
        Get
            Return mExportGroupName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mExportGroupName Then
                mExportGroupName = value
                PropertyHasChanged("Name")
            End If
        End Set
    End Property
    Public Property QuestionFileName() As String
        Get
            Return mQuestionFileName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mQuestionFileName Then
                mQuestionFileName = value
                PropertyHasChanged("QuestionFileName")
            End If
        End Set
    End Property
    Public Property AnswerFileName() As String
        Get
            Return mAnswerFileName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mAnswerFileName Then
                mAnswerFileName = value
                PropertyHasChanged("mAnswerFileName")
            End If
        End Set
    End Property

    ''' <summary>Date in which the exported respondents were marked for 2401.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property StartDate() As Nullable(Of Date)
        Get
            Return mStartDate
        End Get
        Set(ByVal value As Nullable(Of Date))            
            mStartDate = value
            PropertyHasChanged("StartDate")            
        End Set
    End Property
    ''' <summary>Date in which the exported respondents were finished with a 2401 update.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property EndDate() As Nullable(Of Date)
        Get
            Return mEndDate
        End Get
        Set(ByVal value As Nullable(Of Date))            
            mEndDate = value
            PropertyHasChanged("EndDate")            
        End Set
    End Property
    ''' <summary>This field is representative of when the start of marking respondents with a 2401 event code started. (during an export)</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Mark2401RangeStartDate() As Nullable(Of Date)
        Get
            Return Me.mMark2401RangeStartDate
        End Get
        Set(ByVal value As Nullable(Of Date))
            Me.mMark2401RangeStartDate = value
            PropertyHasChanged("Mark2401RangeStartDate")
        End Set
    End Property
    ''' <summary>This field is representative of when the end of marking respondents with a 2401 event code (during an export)</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Mark2401RangeEndDate() As Nullable(Of Date)
        Get
            Return Me.mMark2401RangeEndDate
        End Get
        Set(ByVal value As Nullable(Of Date))
            Me.mMark2401RangeEndDate = value
            PropertyHasChanged("Mark2401RangeEndDate")
        End Set
    End Property
    Public Property UserID() As Integer
        Get
            Return mUserID
        End Get
        Set(ByVal value As Integer)
            If Not value = mUserID Then
                mUserID = value
                PropertyHasChanged("UserID")
            End If
        End Set
    End Property
    Public Property UserName() As String
        Get
            Return mUserName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mUserName Then
                mUserName = value
                PropertyHasChanged("UserName")
            End If
        End Set
    End Property
    Public Property IsActive() As Boolean
        Get
            Return mIsActive
        End Get
        Set(ByVal value As Boolean)
            If Not value = mIsActive Then
                mIsActive = value
                PropertyHasChanged("IsActive")
            End If
        End Set
    End Property
    Public Property QuestionFileRecordsExported() As Integer
        Get
            Return mQuestionFileRecordsExported
        End Get
        Set(ByVal value As Integer)
            If Not value = mQuestionFileRecordsExported Then
                mQuestionFileRecordsExported = value
                PropertyHasChanged("QuestionFileRecordsExported")
            End If
        End Set
    End Property
    Public Property AnswerFileRecordsExported() As Integer
        Get
            Return mAnswerFileRecordsExported
        End Get
        Set(ByVal value As Integer)
            If Not value = mAnswerFileRecordsExported Then
                mAnswerFileRecordsExported = value
                PropertyHasChanged("AnswerFileRecordsExported")
            End If
        End Set
    End Property
    Public Property errorMessage() As String
        Get
            Return merrorMessage
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = merrorMessage Then
                merrorMessage = value
                PropertyHasChanged("errorMessage")
            End If
        End Set
    End Property
    Public Property StackTrace() As String
        Get
            Return mStackTrace
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mStackTrace Then
                mStackTrace = value
                PropertyHasChanged("StackTrace")
            End If
        End Set
    End Property
    ''' <summary></summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20080414 - Tony Piccoli</term>
    ''' <description>Switche from short to boolean type.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public Property MarkSubmitted() As Boolean
        Get
            Return mMarkSubmitted
        End Get
        Set(ByVal value As Boolean)
            If Not value = mMarkSubmitted Then
                mMarkSubmitted = value
                PropertyHasChanged("MarkSubmitted")
            End If
        End Set
    End Property

    Public Property RespondentsExported() As Integer
        Get
            Return mRespondentsExported
        End Get
        Set(ByVal value As Integer)
            If Not value = mRespondentsExported Then
                mRespondentsExported = value
                PropertyHasChanged("RespondentsExported")
            End If
        End Set
    End Property

#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewExportFileLog() As ExportFileLog
        Return New ExportFileLog
    End Function

    Public Shared Function [Get](ByVal exportLogFileID As Integer) As ExportFileLog
        Return ExportFileLogProvider.Instance.SelectExportFileLog(exportLogFileID)
    End Function

    Public Shared Function GetAll(ByVal StartDate As Date, ByVal EndDate As Date) As ExportFileLogCollection
        Return ExportFileLogProvider.Instance.SelectAllExportFileLogs(StartDate, EndDate)
    End Function
    Public Shared Function GetByExportGroupID(ByVal ExportGroupID As Integer, ByVal StartDate As Date, ByVal EndDate As Date) As ExportFileLogCollection
        Return ExportFileLogProvider.Instance.SelectExportFileLogByExportGroupID(ExportGroupID, StartDate, EndDate)
    End Function
    Public Shared Sub DeleteFileLog(ByVal FileLog As ExportFileLog)
        If FileLog IsNot Nothing Then
            ExportFileLogProvider.Instance.DeleteExportFileLog(FileLog.ExportLogFileID)
        End If
    End Sub
    Public Shared Function CreateLogFileEntry(ByVal exportGroupID As Integer, ByVal userID As Integer, ByVal userName As String, ByVal isActive As Boolean, ByVal markSubmitted As Boolean) As Integer
        Return ExportFileLogProvider.Instance.CreateFileLog(exportGroupID, userID, userName, isActive, markSubmitted)
    End Function
    Public Shared Sub FinishLogFileEntry(ByVal logFile As ExportFileLog)
        ExportFileLogProvider.Instance.FinishLogFileEntry(logFile)
    End Sub


    Public Shared Sub MarkExportFileLogInActive(ByVal exportGroupId As Integer)

        ExportFileLogProvider.Instance.MarkExportFileLogInActive(exportGroupId)


    End Sub


#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mExportLogFileID
        End If
    End Function

#End Region

#Region " Validation "
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...
    End Sub
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub
    ''' <summary>This object uses customized crud and as a result, the object should update via factory methods rather than through the dot save method.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Sub Save()
        'MyBase.Save()
        Throw New NotImplementedException("Inserts and updates of this object should only be done through its factory methods.")
    End Sub
    Protected Overrides Sub Insert()
        ExportLogFileID = ExportFileLogProvider.Instance.InsertExportFileLog(Me)
    End Sub

    Protected Overrides Sub Update()
        ExportFileLogProvider.Instance.UpdateExportFileLog(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        ExportFileLogProvider.Instance.DeleteExportFileLog(mExportLogFileID)
    End Sub

#End Region

#Region " Public Methods "




#End Region

End Class



