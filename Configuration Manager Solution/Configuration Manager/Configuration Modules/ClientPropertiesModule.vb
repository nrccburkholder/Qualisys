Imports Nrc.QualiSys.Library

Public Class ClientPropertiesModule
    Inherits ConfigurationModule

#Region " Private Members "

    Private mClient As Library.Client
    Private mIsNew As Boolean
    Private mIsEditable As Boolean = True
    Private mInformation As String
    Private mIsLocked As Boolean

    Private mEndConfigCallBack As EndConfigCallBackMethod

#End Region

#Region " Public Properties "

    Public Property Client() As Library.Client
        Get
            Return mClient
        End Get
        Protected Set(ByVal value As Library.Client)
            mClient = value
        End Set
    End Property

    Public Property IsNew() As Boolean
        Get
            Return mIsNew
        End Get
        Protected Set(ByVal value As Boolean)
            mIsNew = value
        End Set
    End Property

    Public Property IsEditable() As Boolean
        Get
            Return mIsEditable
        End Get
        Protected Set(ByVal value As Boolean)
            mIsEditable = value
        End Set
    End Property

    Public Property Information() As String
        Get
            Return mInformation
        End Get
        Protected Set(ByVal value As String)
            mInformation = value
        End Set
    End Property

    Protected Property IsLocked() As Boolean
        Get
            Return mIsLocked
        End Get
        Set(ByVal value As Boolean)
            mIsLocked = value
        End Set
    End Property

#End Region

#Region " Public ReadOnly Properties "

    Public Overrides ReadOnly Property Image() As System.Drawing.Image
        Get
            Return My.Resources.Properties16
        End Get
    End Property

    Public Overrides ReadOnly Property Name() As String
        Get
            Return "Client Properties"
        End Get
    End Property

#End Region

#Region " Protected Properties "

    Protected Property EndConfigCallBack() As EndConfigCallBackMethod
        Get
            Return mEndConfigCallBack
        End Get
        Set(ByVal value As EndConfigCallBackMethod)
            mEndConfigCallBack = value
        End Set
    End Property

#End Region

#Region " Constructors "

    Sub New(ByVal configPanel As Panel)

        MyBase.New(configPanel)

    End Sub

#End Region

#Region " Public Methods "

    Public Overrides Sub BeginConfig(ByVal selectedClientGroup As Navigation.ClientGroupNavNode, ByVal selectedClient As Library.Navigation.ClientNavNode, ByVal selectedStudy As Library.Navigation.StudyNavNode, ByVal selectedSurvey As Library.Navigation.SurveyNavNode, ByVal endConfigCallback As EndConfigCallBackMethod)

        Reset()

        Dim clientId As Integer = selectedClient.Id
        Dim lockCategory As ConcurrencyLockCategory = ConcurrencyLockCategory.Client

        mEndConfigCallBack = endConfigCallback

        mClient = selectedClient.GetClient

        If ConcurrencyManager.AcquireLock(lockCategory, clientId, CurrentUser.UserName, Environment.MachineName, Process.GetCurrentProcess.ProcessName) Then
            ConcurrencyManager.ReleaseLock(lockCategory, clientId)
        Else
            Dim lock As ConcurrencyLock = ConcurrencyManager.ViewLock(lockCategory, clientId)
            Dim lockCategoryName As String = System.Enum.GetName(lock.LockCategory.GetType, lockCategory)
            Information = String.Format("{0} Locked by {1}; process={2}; machineID={3}", lockCategoryName, lock.UserName, lock.ProcessName, lock.MachineName)
        End If

        ConfigPanel.Controls.Clear()
        Dim ctrl As ClientSection = New ClientSection(Me, New EndConfigCallBackMethod(AddressOf EndConfig))
        ctrl.Dock = DockStyle.Fill
        ConfigPanel.Controls.Add(ctrl)

    End Sub

#End Region

#Region " Protected Methods "

    Protected Overridable Sub EndConfig(ByVal action As ConfigResultActions, ByVal data As Object)

        Try
            If IsEditable AndAlso action = ConfigResultActions.ClientRefresh Then
                Client.Update()
            End If

        Catch ex As Exception
            Globals.ReportException(ex)
            Cleanup(action)
            Return

        End Try

        Cleanup(action)

    End Sub

    Protected Overridable Sub Cleanup(ByVal action As ConfigResultActions)

        If IsLocked Then
            IsLocked = False
            ConcurrencyManager.ReleaseLock(ConcurrencyLockCategory.Client, mClient.Id)
        End If

        ConfigPanel.Controls.Clear()

        Dim callBack As EndConfigCallBackMethod = EndConfigCallBack
        If (callBack IsNot Nothing) Then
            callBack(action, Nothing)
            EndConfigCallBack = Nothing
        End If

    End Sub

    Protected Overridable Sub Reset()

        mEndConfigCallBack = Nothing
        mClient = Nothing
        mIsNew = False
        mIsEditable = True
        mInformation = Nothing

    End Sub

#End Region

End Class
