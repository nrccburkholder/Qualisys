Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class ServiceAlertEmailLog
	Inherits BusinessBase(Of ServiceAlertEmailLog)
	Implements IServiceAlertEmailLog

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mLogId As Integer
    Private mOccurred As Date
    Private mMessage As String = String.Empty
    Private mQtyToSend As Integer
    Private mQtySuccessful As Integer
    Private mQtyError As Integer
    Private mException As String = String.Empty

#End Region

#Region " Public Properties "

    Public Property LogId() As Integer Implements IServiceAlertEmailLog.LogId
        Get
            Return mLogId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mLogId Then
                mLogId = value
                PropertyHasChanged("LogId")
            End If
        End Set
    End Property

    Public Property Occurred() As Date
        Get
            Return mOccurred
        End Get
        Set(ByVal value As Date)
            If Not value = mOccurred Then
                mOccurred = value
                PropertyHasChanged("Occurred")
            End If
        End Set
    End Property

    Public Property Message() As String
        Get
            Return mMessage
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMessage Then
                mMessage = value
                PropertyHasChanged("Message")
            End If
        End Set
    End Property

    Public Property QtyToSend() As Integer
        Get
            Return mQtyToSend
        End Get
        Set(ByVal value As Integer)
            If Not value = mQtyToSend Then
                mQtyToSend = value
                PropertyHasChanged("QtyToSend")
            End If
        End Set
    End Property

    Public Property QtySuccessful() As Integer
        Get
            Return mQtySuccessful
        End Get
        Set(ByVal value As Integer)
            If Not value = mQtySuccessful Then
                mQtySuccessful = value
                PropertyHasChanged("QtySuccessful")
            End If
        End Set
    End Property

    Public Property QtyError() As Integer
        Get
            Return mQtyError
        End Get
        Set(ByVal value As Integer)
            If Not value = mQtyError Then
                mQtyError = value
                PropertyHasChanged("QtyError")
            End If
        End Set
    End Property

    Public Property Exception() As String
        Get
            Return mException
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mException Then
                mException = value
                PropertyHasChanged("Exception")
            End If
        End Set
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewServiceAlertEmailLog() As ServiceAlertEmailLog

        Return New ServiceAlertEmailLog

    End Function

    Public Shared Function GetAll() As ServiceAlertEmailLogCollection

        Return ServiceAlertEmailLogProvider.Instance.SelectAllServiceAlertEmailLogs()

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mLogId
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

        LogId = ServiceAlertEmailLogProvider.Instance.InsertServiceAlertEmailLog(Me)

    End Sub

    Protected Overrides Sub Update()

        ServiceAlertEmailLogProvider.Instance.UpdateServiceAlertEmailLog(Me)

    End Sub

#End Region

#Region " Public Methods "

    Public Shared Sub InsertLogEntryStart()

        Dim entry As ServiceAlertEmailLog = ServiceAlertEmailLog.NewServiceAlertEmailLog

        With entry
            .Occurred = Now
            .Message = "Service Alert Emails Started"
            .QtyToSend = 0
            .QtySuccessful = 0
            .QtyError = 0
            .Exception = String.Empty
        End With

        entry.Save()

    End Sub

    Public Shared Sub InsertLogEntryQtyToSend(ByVal qtyToSend As Integer)

        Dim entry As ServiceAlertEmailLog = ServiceAlertEmailLog.NewServiceAlertEmailLog

        With entry
            .Occurred = Now
            .Message = "Service Alert Emails to Send"
            .QtyToSend = qtyToSend
            .QtySuccessful = 0
            .QtyError = 0
            .Exception = String.Empty
        End With

        entry.Save()

    End Sub

    Public Shared Sub InsertLogEntryEnd(ByVal qtyToSend As Integer, ByVal qtySuccessful As Integer, ByVal qtyError As Integer)

        Dim entry As ServiceAlertEmailLog = ServiceAlertEmailLog.NewServiceAlertEmailLog

        With entry
            .Occurred = Now
            .Message = "Service Alert Emails Ended.  Refer to table ServiceAlertEmailsAttempted for error conditions."
            .QtyToSend = qtyToSend
            .QtySuccessful = qtySuccessful
            .QtyError = qtyError
            .Exception = String.Empty
        End With

        entry.Save()

    End Sub

    Public Shared Sub InsertLogEntryException(ByVal qtyToSend As Integer, ByVal qtySuccessful As Integer, ByVal qtyError As Integer, ByVal ex As Exception)

        Dim entry As ServiceAlertEmailLog = ServiceAlertEmailLog.NewServiceAlertEmailLog

        With entry
            .Occurred = Now
            .Message = "Service Alert Emails has encountered an Exception"
            .QtyToSend = qtyToSend
            .QtySuccessful = qtySuccessful
            .QtyError = qtyError
            .Exception = String.Format("Source: {1}{0}{0}Message: {2}{0}{0}Stack Trace:{0}{3}{0}{0}Inner Exception Source: {4}{0}{0}Inner Exception Message: {5}{0}{0}Inner Exception Stack Trace:{0}{6}", vbCrLf, ex.Source, ex.Message, ex.StackTrace, ex.InnerException.Source, ex.InnerException.Message, ex.InnerException.StackTrace)
        End With

        entry.Save()

    End Sub

#End Region

End Class


