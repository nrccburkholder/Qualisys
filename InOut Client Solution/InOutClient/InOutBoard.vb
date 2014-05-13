Imports nrc.InOutClient.InOutService

Public Class InOutBoard

    Private Shared mInstance As InOutBoard
    Private mService As InOutService.InOut
    Private mUserName As String
    Private mUserId As Integer
    Private mStatusList As StatusInfo()
    Private WithEvents mSchedule As Schedule

#Region " Public Properties "
    Public Shared ReadOnly Property Instance() As InOutBoard
        Get
            If mInstance Is Nothing Then
                mInstance = New InOutBoard
            End If
            Return mInstance
        End Get
    End Property

    Public ReadOnly Property StatusList() As StatusInfo()
        Get
            Return mStatusList
        End Get
    End Property

    Public ReadOnly Property UserName() As String
        Get
            Return mUserName
        End Get
    End Property
    Public ReadOnly Property UserId() As Integer
        Get
            Return mUserId
        End Get
    End Property

    Public Property Schedule() As Schedule
        Get
            Return mSchedule
        End Get
        Set(ByVal Value As Schedule)
            If Not Value Is mSchedule Then
                Dim isEnabled As Boolean = mSchedule.IsEnabled
                mSchedule.Dispose()
                mSchedule = Value
                mSchedule.IsEnabled = isEnabled
            End If
        End Set
    End Property

#End Region

    Private Sub New()
        mService = New InOutService.InOut
        mService.Credentials = System.Net.CredentialCache.DefaultCredentials

        mUserName = String.Format("NRC\{0}", Environment.UserName)
        mUserId = mService.GetUserId(mUserName)
        mStatusList = mService.GetStatusList

        mSchedule = InOutClient.Schedule.Deserialize
    End Sub

    Public Function GetStatusLabel(ByVal statusId As Integer) As String
        For Each stat As StatusInfo In mStatusList
            If stat.InOutStatusID = statusId Then
                Return stat.Status
            End If
        Next
        Return Nothing
    End Function

    Public Function GetStatusId(ByVal statusLabel As String) As Integer
        statusLabel = statusLabel.ToLower
        For Each stat As StatusInfo In mStatusList
            If stat.Status.ToLower = statusLabel Then
                Return stat.InOutStatusID
            End If
        Next
    End Function

    Public ReadOnly Property CurrentStatus() As InOutInfo
        Get
            Return mService.GetUserStatus(mUserId)
        End Get
    End Property

    Public Sub SetStatus(ByVal statusId As Integer)
        mService.SetUserStatus(mUserId, statusId)
    End Sub

    Private Sub mSchedule_StatusChanged(ByVal sender As Object, ByVal e As Schedule.StatusChangedEventArgs) Handles mSchedule.StatusChanged
        mService.SetUserStatus(mUserId, e.NewStatusId)
    End Sub
End Class
