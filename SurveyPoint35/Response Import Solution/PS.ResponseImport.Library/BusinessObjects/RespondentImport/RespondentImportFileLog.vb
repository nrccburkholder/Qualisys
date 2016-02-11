Imports PS.Framework.BusinessLogic
Public Interface IRespondentImportFileLog
    Property RespondentImportFileLogID() As Integer
End Interface

Public Class RespondentImportFileLog
    Inherits BusinessBase(Of RespondentImportFileLog)
    Implements IRespondentImportFileLog
#Region " Field Definitions "
    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mRespondentImportFileLogID As Integer = 0
    Private mRespondentImportFileID As String = String.Empty
    Private mFileName As String = String.Empty
    Private mProcessDirectory As String = String.Empty
    Private mRowsToProcess As Integer = 0
    Private mDateCreated As DateTime = Nothing
    Private mDateCompleted As Nullable(Of DateTime)
    Private mNotes As String = String.Empty
    Private mSurveySystemType As SurveySystemType = Nothing
    Private mRespondentImportFileLineLogs As RespondentImportFileLineLogs = Nothing
#End Region
#Region " Properties "
    Public Property RespondentImportFileLogID() As Integer Implements IRespondentImportFileLog.RespondentImportFileLogID
        Get
            Return Me.mRespondentImportFileLogID
        End Get
        Protected Set(ByVal value As Integer)
            Me.mRespondentImportFileLogID = value
        End Set
    End Property
    Public Property RespondentImportFileID() As String
        Get
            Return Me.mRespondentImportFileID
        End Get
        Set(ByVal value As String)
            If Not (Me.mRespondentImportFileID = value) Then
                Me.mRespondentImportFileID = value
                PropertyHasChanged("RespondentImportFileID")
            End If
        End Set
    End Property
    Public Property FileName() As String
        Get
            Return Me.mFileName
        End Get
        Set(ByVal value As String)
            If Not (Me.mFileName = value) Then
                Me.mFileName = value
                PropertyHasChanged("FileName")
            End If
        End Set
    End Property
    Public Property ProcessDirectory() As String
        Get
            Return Me.mProcessDirectory
        End Get
        Set(ByVal value As String)
            If Not (Me.mProcessDirectory = value) Then
                Me.mProcessDirectory = value
                PropertyHasChanged("ProcessDirectory")
            End If
        End Set
    End Property
    Public Property RowsToProcess() As Integer
        Get
            Return Me.mRowsToProcess
        End Get
        Set(ByVal value As Integer)
            If Not (Me.mRowsToProcess = value) Then
                Me.mRowsToProcess = value
                PropertyHasChanged("RowsToProcess")
            End If
        End Set
    End Property
    Public Property DateCreated() As DateTime
        Get
            Return Me.mDateCreated
        End Get
        Set(ByVal value As DateTime)
            If Not (Me.mDateCreated = value) Then
                Me.mDateCreated = value
                PropertyHasChanged("DateCreated")
            End If
        End Set
    End Property
    Public Property DateCompleted() As Nullable(Of DateTime)
        Get
            Return Me.mDateCompleted
        End Get
        Set(ByVal value As Nullable(Of DateTime))
            Me.mDateCompleted = value
            PropertyHasChanged("DateCompleted")
        End Set
    End Property
    Public Property Notes() As String
        Get
            Return Me.mNotes
        End Get
        Set(ByVal value As String)
            If Not (Me.mNotes = value) Then
                Me.mNotes = value
                PropertyHasChanged("Notes")
            End If
        End Set
    End Property
    Public Property SurveySystemType() As SurveySystemType
        Get
            Return Me.mSurveySystemType
        End Get
        Set(ByVal value As SurveySystemType)
            If Not (Me.mSurveySystemType = value) Then
                Me.mSurveySystemType = value
                PropertyHasChanged("SurveySystemType")
            End If
        End Set
    End Property
    Public ReadOnly Property RespondentImportFileLineLogs() As RespondentImportFileLineLogs
        Get
            If Not Me.mRespondentImportFileLineLogs Is Nothing Then
                Me.mRespondentImportFileLineLogs = RespondentImportFileLineLog.GetRespondentImportFileLineLogsByImportFileID(Me.mRespondentImportFileID)
            End If
            Return Me.mRespondentImportFileLineLogs
        End Get        
    End Property
#End Region
#Region " Constructors "
    Public Sub New()
        Me.CreateNew()
    End Sub
#End Region
#Region " Factory Calls "
    Public Shared Function NewRespondentImportFileLog() As RespondentImportFileLog
        Return New RespondentImportFileLog
    End Function
    Public Shared Function GetRespondentImportFileLogsByDate(ByVal startDate As DateTime, ByVal endDate As DateTime) As RespondentImportFileLogs
        Return RespondentImportFileLogProvider.Instance.GetRespondentImportFileLogsByDate(startDate, endDate)
    End Function
    Public Shared Function GetByRespImportFileID(ByVal respImportFileID As String) As RespondentImportFileLog
        Return RespondentImportFileLogProvider.Instance.GetByRespImportFileID(respImportFileID)
    End Function
    Public Shared Sub AddLogEntry(ByVal respImportFileID As String, ByVal severity As LogSeverity, ByVal fileName As String, ByVal processDirectory As String, ByVal rowsToProcess As Integer, ByVal dateCompleted As Nullable(Of DateTime), ByVal notes As String, ByVal surveySysType As SurveySystemType)        
        RespondentImportFileLogProvider.Instance.AddLogEntry(respImportFileID, fileName, processDirectory, rowsToProcess, dateCompleted, notes, surveySysType)
    End Sub    
#End Region
#Region " Data Access "
    Protected Overrides Sub Delete()
        Throw New NotImplementedException()
        'RespondentImportFileLogProvider.Instance.DeleteRespondentImportFileLog(Me)
    End Sub
    Protected Overrides Sub Insert()
        Throw New NotImplementedException()
        'RespondentImportFileLogProvider.Instance.InsertRespondentImportFileLog(Me)
    End Sub
    Protected Overrides Sub Update()
        Throw New NotImplementedException()
        'RespondentImportFileLogProvider.Instance.UpdateRespondentImportFileLog(Me)
    End Sub
#End Region
#Region " Validation "

#End Region
End Class
Public Class RespondentImportFileLogs
    Inherits BusinessListBase(Of RespondentImportFileLog)

End Class
Public MustInherit Class RespondentImportFileLogProvider
#Region " Singleton Implementation "
    Private Shared mInstance As RespondentImportFileLogProvider
    Private Const mProviderName As String = "RespondentImportFileLogProvider"
    ''' <summary>Retrieves the instance of the Data provider class that will implement the abstract methods.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property Instance() As RespondentImportFileLogProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of RespondentImportFileLogProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region
#Region "Constructors "
    Protected Sub New()
    End Sub
#End Region
#Region " Abstract Methods "
    Public MustOverride Function GetRespondentImportFileLogsByDate(ByVal startDate As DateTime, ByVal endDate As DateTime) As RespondentImportFileLogs
    Public MustOverride Function GetByRespImportFileID(ByVal respImportFileID As String) As RespondentImportFileLog
    Public MustOverride Sub AddLogEntry(ByVal respImportFileID As String, ByVal fileName As String, ByVal processDirectory As String, ByVal rowsToProcess As Integer, ByVal dateCompleted As Nullable(Of DateTime), ByVal notes As String, ByVal surveySysType As SurveySystemType)
#End Region
End Class