Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class ServiceAlertEmailsAttempted
    Inherits BusinessBase(Of ServiceAlertEmailsAttempted)
    Implements IServiceAlertEmailsAttempted

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mLogId As Integer
    Private mClientUserId As Integer
    Private mLithoList As String = String.Empty
    Private mToList As String = String.Empty
    Private mDateSent As Date
    Private mEMailFormat As ServiceAlertEmailFormats
    Private mException As String = String.Empty

#End Region

#Region " Public Properties "

    Public Property LogId() As Integer Implements IServiceAlertEmailsAttempted.LogId
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

    Public Property ClientUserId() As Integer
        Get
            Return mClientUserId
        End Get
        Set(ByVal value As Integer)
            If Not value = mClientUserId Then
                mClientUserId = value
                PropertyHasChanged("ClientUserId")
            End If
        End Set
    End Property

    Public Property LithoList() As String
        Get
            Return mLithoList
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mLithoList Then
                mLithoList = value
                PropertyHasChanged("LithoList")
            End If
        End Set
    End Property

    Public Property ToList() As String
        Get
            Return mToList
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mToList Then
                mToList = value
                PropertyHasChanged("ToList")
            End If
        End Set
    End Property

    Public Property DateSent() As Date
        Get
            Return mDateSent
        End Get
        Set(ByVal value As Date)
            If Not value = mDateSent Then
                mDateSent = value
                PropertyHasChanged("DateSent")
            End If
        End Set
    End Property

    Public Property EMailFormat() As ServiceAlertEmailFormats
        Get
            Return mEMailFormat
        End Get
        Set(ByVal value As ServiceAlertEmailFormats)
            If Not value = mEMailFormat Then
                mEMailFormat = value
                PropertyHasChanged("EMailFormat")
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

    Public Shared Function NewServiceAlertEmailsAttempted() As ServiceAlertEmailsAttempted

        Return New ServiceAlertEmailsAttempted

    End Function

    Public Shared Function GetAll() As ServiceAlertEmailsAttemptedCollection

        Return ServiceAlertEmailsAttemptedProvider.Instance.SelectAllServiceAlertEmailsAttempted()

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

        LogId = ServiceAlertEmailsAttemptedProvider.Instance.InsertServiceAlertEmailsAttempted(Me)

    End Sub

    Protected Overrides Sub Update()

        ServiceAlertEmailsAttemptedProvider.Instance.UpdateServiceAlertEmailsAttempted(Me)

    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


