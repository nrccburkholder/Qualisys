Imports Nrc.DataMart.MySolutions.Library
Imports Nrc.NRCAuthLib.FormsAuth

Public NotInheritable Class SessionInfo
    Private Enum SessionKeys
        EToolKitServer
        SelectedUnitValuePath
        SelectedViewName
        SelectedDimensionId
        SelectedDimensionName
        SelectedQuestionId
        EditingQuestionContent
        LastException
        FeaturedExpertKey
        LastDocDownload

        CollapseSelectionTreeMenu
        CollapseSupportMenu
        CollapseToolBoxMenu
        CollapseMemberResources
        CollapseActionPlansMenu
    End Enum

    Private Sub New()
    End Sub

#Region " Item Get/Set "
    Private Shared Function GetItem(ByVal key As SessionKeys) As Object
        Return HttpContext.Current.Session(key.ToString)
    End Function

    Private Shared Function GetItem(Of T)(ByVal key As SessionKeys) As T
        Return CType(GetItem(key), T)
    End Function

    Private Shared Sub SetItem(ByVal key As SessionKeys, ByVal value As Object)
        HttpContext.Current.Session(key.ToString) = value
    End Sub
#End Region

#Region " Session Properties "
    Public Shared Property EToolKitServer() As Legacy.ToolkitServer
        Get
            Return GetItem(Of Legacy.ToolkitServer)(SessionKeys.EToolKitServer)
        End Get
        Private Set(ByVal value As Legacy.ToolkitServer)
            SetItem(SessionKeys.EToolKitServer, value)
        End Set
    End Property

    Public Shared Property SelectedUnitValuePath() As String
        Get
            Return GetItem(Of String)(SessionKeys.SelectedUnitValuePath)
        End Get
        Set(ByVal value As String)
            SetItem(SessionKeys.SelectedUnitValuePath, value)
        End Set
    End Property

    Public Shared ReadOnly Property IsAppInitialized(ByVal app As ApplicationEnum) As Boolean
        Get
            Return (EToolKitServer IsNot Nothing AndAlso CurrentUser.Principal.IsInitialized(app))
        End Get
    End Property

    Public Shared Property SelectedViewName() As String
        Get
            Return GetItem(Of String)(SessionKeys.SelectedViewName)
        End Get
        Set(ByVal value As String)
            SetItem(SessionKeys.SelectedViewName, value)
        End Set
    End Property

    Public Shared Property SelectedDimensionId() As Integer
        Get
            Return GetItem(Of Integer)(SessionKeys.SelectedDimensionId)
        End Get
        Set(ByVal value As Integer)
            SetItem(SessionKeys.SelectedDimensionId, value)
        End Set
    End Property

    Public Shared Property SelectedDimensionName() As String
        Get
            Return GetItem(Of String)(SessionKeys.SelectedDimensionName)
        End Get
        Set(ByVal value As String)
            SetItem(SessionKeys.SelectedDimensionName, value)
        End Set
    End Property

    Public Shared Property SelectedQuestionId() As Integer
        Get
            Return GetItem(Of Integer)(SessionKeys.SelectedQuestionId)
        End Get
        Set(ByVal value As Integer)
            SetItem(SessionKeys.SelectedQuestionId, value)
        End Set
    End Property

    Public Shared Property EditingQuestionContent() As QuestionContent
        Get
            Return GetItem(Of QuestionContent)(SessionKeys.EditingQuestionContent)
        End Get
        Set(ByVal value As QuestionContent)
            SetItem(SessionKeys.EditingQuestionContent, value)
        End Set
    End Property

    Public Shared Property LastException() As Exception
        Get
            Return GetItem(Of Exception)(SessionKeys.LastException)
        End Get
        Set(ByVal value As Exception)
            SetItem(SessionKeys.LastException, value)
        End Set
    End Property

    Public Shared Property FeaturedExpertKey() As String
        Get
            Return GetItem(Of String)(SessionKeys.FeaturedExpertKey)
        End Get
        Set(ByVal value As String)
            SetItem(SessionKeys.FeaturedExpertKey, value)
        End Set
    End Property

    Public Shared Property LastDocumentDownload() As Integer
        Get
            Return GetItem(Of Integer)(SessionKeys.LastDocDownload)
        End Get
        Set(ByVal value As Integer)
            SetItem(SessionKeys.LastDocDownload, value)
        End Set
    End Property

    Public Shared Property CollapseSelectionTreeMenu() As Boolean
        Get
            Return GetItem(Of Boolean)(SessionKeys.CollapseSelectionTreeMenu)
        End Get
        Set(ByVal value As Boolean)
            SetItem(SessionKeys.CollapseSelectionTreeMenu, value)
        End Set
    End Property

    Public Shared Property CollapseSupportMenu() As Boolean
        Get
            Return GetItem(Of Boolean)(SessionKeys.CollapseSupportMenu)
        End Get
        Set(ByVal value As Boolean)
            SetItem(SessionKeys.CollapseSupportMenu, value)
        End Set
    End Property

    Public Shared Property CollapseToolBoxMenu() As Boolean
        Get
            Return GetItem(Of Boolean)(SessionKeys.CollapseToolBoxMenu)
        End Get
        Set(ByVal value As Boolean)
            SetItem(SessionKeys.CollapseToolBoxMenu, value)
        End Set
    End Property

    Public Shared Property CollapseMemberResources() As Boolean
        Get
            Return GetItem(Of Boolean)(SessionKeys.CollapseMemberResources)
        End Get
        Set(ByVal value As Boolean)
            SetItem(SessionKeys.CollapseMemberResources, value)
        End Set
    End Property

    Public Shared Property CollapseActionPlansMenu() As Boolean
        Get
            Return GetItem(Of Boolean)(SessionKeys.CollapseActionPlansMenu)
        End Get
        Set(ByVal value As Boolean)
            SetItem(SessionKeys.CollapseActionPlansMenu, value)
        End Set
    End Property

#End Region

    'Public Shared Sub ResetAppInitialization()
    '    InitializationFlags = MySolutionsApps.None
    '    SessionInfo.EToolKitServer = Nothing
    'End Sub

    Public Shared Sub InitializeApp(ByVal app As ApplicationEnum)
        'Set the flag
        CurrentUser.Principal.InitializeApplication(app)

        'Perform initialization of session info
        Select Case app
            Case ApplicationEnum.eReports
            Case ApplicationEnum.eComments
            Case ApplicationEnum.eToolKit
                SessionInfo.EToolKitServer = New Legacy.ToolkitServer(CurrentUser.Member.MemberId, CurrentUser.SelectedGroup.GroupId)
                SessionInfo.SelectedViewName = ""
                SessionInfo.SelectedDimensionId = 0
                SessionInfo.SelectedDimensionName = ""
                SessionInfo.SelectedQuestionId = 0
        End Select
    End Sub


End Class
