Imports Nrc.Framework.BusinessLogic

Public Interface ISPTI_ExportDefinitionLog
    Property LogID() As Integer
End Interface

<Serializable()> _
Public Class SPTI_ExportDefinitionLog
    Inherits BusinessBase(Of SPTI_ExportDefinitionLog)
    Implements ISPTI_ExportDefinitionLog

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mLogID As Integer
    Private mExportDefinitionID As Integer
    Private mDateCreated As Date
    Private mDateCompleted As Nullable(Of Date)
    Private mNumberFileDupsRemoved As Nullable(Of Integer)
    Private mErrorMessage As String = String.Empty
    Private mStackTrace As String = String.Empty
    Private mNumberQMSDeDupsRemoved As String = String.Empty
#End Region

#Region " Public Properties "
    Public Property LogID() As Integer Implements ISPTI_ExportDefinitionLog.LogID
        Get
            Return mLogID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mLogID Then
                mLogID = value
                PropertyHasChanged("LogID")
            End If
        End Set
    End Property
    Public Property ExportDefinitionID() As Integer
        Get
            Return mExportDefinitionID
        End Get
        Set(ByVal value As Integer)
            If Not value = mExportDefinitionID Then
                mExportDefinitionID = value
                PropertyHasChanged("ExportDefinitionID")
            End If
        End Set
    End Property
    Public Property DateCreated() As Date
        Get
            Return mDateCreated
        End Get
        Set(ByVal value As Date)
            If Not value = mDateCreated Then
                mDateCreated = value
                PropertyHasChanged("DateCreated")
            End If
        End Set
    End Property
    Public Property DateCompleted() As Nullable(Of Date)
        Get
            Return mDateCompleted
        End Get
        Set(ByVal value As Nullable(Of Date))            
            mDateCompleted = value                        
        End Set
    End Property
    Public Property NumberFileDupsRemoved() As Nullable(Of Integer)
        Get
            Return mNumberFileDupsRemoved
        End Get
        Set(ByVal value As Nullable(Of Integer))            
            mNumberFileDupsRemoved = value                        
        End Set
    End Property
    Public Property ErrorMessage() As String
        Get
            Return mErrorMessage
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mErrorMessage Then
                mErrorMessage = value
                PropertyHasChanged("ErrorMessage")
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
    Public Property NumberQMSDeDupsRemoved() As String
        Get
            Return Me.mNumberQMSDeDupsRemoved
        End Get
        Set(ByVal value As String)
            If Not value = Me.mNumberQMSDeDupsRemoved Then
                Me.mNumberQMSDeDupsRemoved = value
                PropertyHasChanged("NumberQMSDeDupsRemoved")
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
    Public Shared Function NewSPTI_ExportDefinitionLog() As SPTI_ExportDefinitionLog
        Return New SPTI_ExportDefinitionLog
    End Function

    Public Shared Function [Get](ByVal logID As Integer) As SPTI_ExportDefinitionLog
        Return DataProviders.SPTI_ExportDefinitionLogProvider.Instance.SelectSPTI_ExportDefinitionLog(logID)
    End Function

    Public Shared Function GetAll() As SPTI_ExportDefinitionLogCollection
        Return DataProviders.SPTI_ExportDefinitionLogProvider.Instance.SelectAllSPTI_ExportDefinitionLogs()
    End Function
#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mLogID
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

    Protected Overrides Sub Insert()
        Throw New NotImplementedException("This method has not been implemented.")
        'LogID = SPTI_ExportDefinitionFileProvider.Instance.InsertSPTI_ExportDefinitionLog(Me)
    End Sub

    Protected Overrides Sub Update()
        Throw New NotImplementedException("This method has not been implemented.")
        'SPTI_ExportDefinitionFileProvider.Instance.UpdateSPTI_ExportDefinitionLog(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        Throw New NotImplementedException("This method has not been implemented.")
        'SPTI_ExportDefinitionFileProvider.Instance.DeleteSPTI_ExportDefinitionLog(mLogID)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class
