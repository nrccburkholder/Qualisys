Imports PS.Framework.BusinessLogic
Public Interface IRespondentImportFileLineLog
    Property RespondentImportFileLineLogID() As Integer
End Interface

Public Class RespondentImportFileLineLog
    Inherits BusinessBase(Of RespondentImportFileLineLog)
    Implements IRespondentImportFileLineLog
#Region " Field Definitions "
    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mRespondentImportFileLineLogID As Integer = 0
    Private mRespondentImportFileID As String = String.Empty
    Private mRespondentImportFileLineID As String = String.Empty
    Private mFileIndex As Integer = 0
    Private mSurveyID As Integer = 0
    Private mClientID As Integer = 0
    Private mSurveyInstanceID As Integer = 0
    Private mTemplateID As Integer = 0
    Private mFileDefID As Integer = 0
    Private mBatchID As String = String.Empty
    Private mDateCreated As DateTime = Nothing
    Private mDateCompleted As Nullable(Of DateTime)
    Private mNotes As String = String.Empty    
#End Region
#Region " Properties "
    Public Property RespondentImportFileLineLogID() As Integer Implements IRespondentImportFileLineLog.RespondentImportFileLineLogID
        Get
            Return Me.mRespondentImportFileLineLogID
        End Get
        Protected Set(ByVal value As Integer)
            Me.mRespondentImportFileLineLogID = value
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
    Public Property RespondentImportFileLineID() As String
        Get
            Return Me.mRespondentImportFileLineID
        End Get
        Set(ByVal value As String)
            If Not (Me.mRespondentImportFileLineID = value) Then
                Me.mRespondentImportFileLineID = value
                PropertyHasChanged("RespondentImportFileLineID")
            End If
        End Set
    End Property
    Public Property FileIndex() As Integer
        Get
            Return Me.mFileIndex
        End Get
        Set(ByVal value As Integer)
            If Not (Me.mFileIndex = value) Then
                Me.mFileIndex = value
                PropertyHasChanged("FileIndex")
            End If
        End Set
    End Property
    Public Property SurveyID() As Integer
        Get
            Return Me.mSurveyID
        End Get
        Set(ByVal value As Integer)
            If Not (Me.mSurveyID = value) Then
                Me.mSurveyID = value
                PropertyHasChanged("SurveyID")
            End If
        End Set
    End Property
    Public Property ClientID() As Integer
        Get
            Return Me.mClientID
        End Get
        Set(ByVal value As Integer)
            If Not (Me.mClientID = value) Then
                Me.mClientID = value
                PropertyHasChanged("ClientID")
            End If
        End Set
    End Property
    Public Property SurveyInstanceID() As Integer
        Get
            Return Me.mSurveyInstanceID
        End Get
        Set(ByVal value As Integer)
            If Not (Me.mSurveyInstanceID = value) Then
                Me.mSurveyInstanceID = value
                PropertyHasChanged("SurveyInstanceID")
            End If
        End Set
    End Property
    Public Property TemplateID() As Integer
        Get
            Return Me.mTemplateID
        End Get
        Set(ByVal value As Integer)
            If Not (Me.mTemplateID = value) Then
                Me.mTemplateID = value
                PropertyHasChanged("TemplateID")
            End If
        End Set
    End Property
    Public Property FileDefID() As Integer
        Get
            Return Me.mFileDefID
        End Get
        Set(ByVal value As Integer)
            If Not (Me.mFileDefID = value) Then
                Me.mFileDefID = value
                PropertyHasChanged("FileDefID")
            End If
        End Set
    End Property
    Public Property BatchID() As String
        Get
            Return Me.mBatchID
        End Get
        Set(ByVal value As String)
            If Not (Me.mBatchID = value) Then
                Me.mBatchID = value
                PropertyHasChanged("BatchID")
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
#End Region
#Region " Constructors "
    Public Sub New()
        Me.CreateNew()
    End Sub
#End Region
#Region " Factory Calls "
    Public Shared Function NewRespondentImportFileLineLog() As RespondentImportFileLineLog
        Return New RespondentImportFileLineLog
    End Function
    Public Shared Function GetRespondentImportFileLineLogsByImportFileID(ByVal respImportFileID As String) As RespondentImportFileLineLogs
        Return RespondentImportFileLineLogProvider.Instance.GetRespondentImportFileLineLogsByImportFileID(respImportFileID)
    End Function
    Public Shared Sub AddToLog(ByVal respImportFileID As String, ByVal respImportFileLineID As String, ByVal fileIndex As Integer, _
                      ByVal surveyID As Integer, ByVal clientID As Integer, ByVal surveyInstanceID As Integer, ByVal templateID As Integer, _
                      ByVal fileDefID As Integer, ByVal batchID As String, ByVal dateCompleted As Nullable(Of DateTime), ByVal notes As String, _
                      ByVal severity As LogSeverity)
        RespondentImportFileLineLogProvider.Instance.AddToLog(respImportFileID, respImportFileLineID, fileIndex, _
                                                              surveyID, clientID, surveyInstanceID, templateID, _
                                                              fileDefID, batchID, dateCompleted, notes, severity)
    End Sub
#End Region
#Region " Data Access "
    Protected Overrides Sub Delete()
        Throw New NotImplementedException()
        'RespondentImportFileLineLogProvider.Instance.DeleteRespondentImportFileLineLog(Me)
    End Sub
    Protected Overrides Sub Insert()
        Throw New NotImplementedException()
        'RespondentImportFileLineLogProvider.Instance.InsertRespondentImportFileLineLog(Me)
    End Sub
    Protected Overrides Sub Update()
        Throw New NotImplementedException()
        'RespondentImportFileLineLogProvider.Instance.UpdateRespondentImportFileLineLog(Me)
    End Sub
#End Region
#Region " Validation "

#End Region
End Class
Public Class RespondentImportFileLineLogs
    Inherits BusinessListBase(Of RespondentImportFileLineLog)

End Class
Public MustInherit Class RespondentImportFileLineLogProvider
#Region " Singleton Implementation "
    Private Shared mInstance As RespondentImportFileLineLogProvider
    Private Const mProviderName As String = "RespondentImportFileLineLogProvider"
    ''' <summary>Retrieves the instance of the Data provider class that will implement the abstract methods.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property Instance() As RespondentImportFileLineLogProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of RespondentImportFileLineLogProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region
    Protected Sub New()
    End Sub
#Region " Abstract Methods "
    Public MustOverride Function GetRespondentImportFileLineLogsByImportFileID(ByVal respImportFileID As String) As RespondentImportFileLineLogs
    Public MustOverride Sub AddToLog(ByVal respImportFileID As String, ByVal respImportFileLineID As String, ByVal fileIndex As Integer, _
                      ByVal surveyID As Integer, ByVal clientID As Integer, ByVal surveyInstanceID As Integer, ByVal templateID As Integer, _
                      ByVal fileDefID As Integer, ByVal batchID As String, ByVal dateCompleted As Nullable(Of DateTime), ByVal notes As String, _
                      ByVal severity As LogSeverity)
#End Region
End Class