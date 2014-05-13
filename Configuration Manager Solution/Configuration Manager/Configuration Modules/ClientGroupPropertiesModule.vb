Imports Nrc.QualiSys.Library

Public Class ClientGroupPropertiesModule
    Inherits ConfigurationModule

#Region " Private Members "

    Private mClientGroup As Library.ClientGroup
    Private mIsNew As Boolean
    Private mIsEditable As Boolean = True
    Private mInformation As String
    Private mIsLocked As Boolean

    Private mEndConfigCallBack As EndConfigCallBackMethod

#End Region

#Region " Public Properties "

    Public Property ClientGroup() As Library.ClientGroup
        Get
            Return mClientGroup
        End Get
        Protected Set(ByVal value As Library.ClientGroup)
            mClientGroup = value
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
            Return "Client Group Properties"
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

        Dim clientGroupId As Integer = selectedClientGroup.Id
        Dim lockCategory As ConcurrencyLockCategory = ConcurrencyLockCategory.ClientGroup

        mEndConfigCallBack = endConfigCallback

        mClientGroup = selectedClientGroup.GetClientGroup

        If ConcurrencyManager.AcquireLock(lockCategory, clientGroupId, CurrentUser.UserName, Environment.MachineName, Process.GetCurrentProcess.ProcessName) Then
            ConcurrencyManager.ReleaseLock(lockCategory, clientGroupId)
        Else
            Dim lock As ConcurrencyLock = ConcurrencyManager.ViewLock(lockCategory, clientGroupId)
            Dim lockCategoryName As String = System.Enum.GetName(lock.LockCategory.GetType, lockCategory)
            Information = String.Format("{0} Locked by {1}; process={2}; machineID={3}", lockCategoryName, lock.UserName, lock.ProcessName, lock.MachineName)
        End If

        ConfigPanel.Controls.Clear()
        Dim ctrl As ClientGroupSection = New ClientGroupSection(Me, New EndConfigCallBackMethod(AddressOf EndConfig))
        ctrl.Dock = DockStyle.Fill
        ConfigPanel.Controls.Add(ctrl)

    End Sub

    Public Overrides Function IsEnabled(ByVal selectedClientGroup As Navigation.ClientGroupNavNode, ByVal selectedStudy As Library.Navigation.StudyNavNode, ByVal selectedSurvey As Library.Navigation.SurveyNavNode, ByVal btn As ToolStripButton) As Boolean
        If selectedClientGroup IsNot Nothing Then
            If selectedClientGroup.Id = -1 And btn.Text = "Client Group Properties" Then
                Return False
            End If
        End If
        Return True
    End Function
#End Region

#Region " Protected Methods "

    Protected Overridable Sub EndConfig(ByVal action As ConfigResultActions, ByVal data As Object)

        Try
            If IsEditable AndAlso action = ConfigResultActions.ClientGroupRefresh Then
                ClientGroup.Update()
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
            ConcurrencyManager.ReleaseLock(ConcurrencyLockCategory.ClientGroup, mClientGroup.Id)
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
        mClientGroup = Nothing
        mIsNew = False
        mIsEditable = True
        mInformation = Nothing

    End Sub

#End Region

End Class
