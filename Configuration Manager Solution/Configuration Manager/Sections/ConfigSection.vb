Imports Nrc.QualiSys.Library
Imports Nrc.QualiSys.Library.Navigation

Public Class ConfigSection

#Region " Private Members "

    Private WithEvents mNavigator As ClientStudySurveyNavigator

    Private mClientGroupModules As New List(Of ConfigurationModule)
    Private mClientModules As New List(Of ConfigurationModule)
    Private mStudyModules As New List(Of ConfigurationModule)
    Private mSurveyModules As New List(Of ConfigurationModule)
    Private mEditHandler As EventHandler = New EventHandler(AddressOf EditModuleEventHandler)
    Private mAllowUnload As Boolean = True

    Private mToolStripButtons As New Dictionary(Of ConfigurationModule, ToolStripButton)
    Private mToolStripMenuItems As New Dictionary(Of ConfigurationModule, ToolStripMenuItem)

    Private Delegate Sub BeingConfigMethod(ByVal configMod As ConfigurationModule)
    Private mEndConfigCallBack As New EndConfigCallBackMethod(AddressOf EndConfig)

#End Region

#Region " Public Methods "

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        MyBase.RegisterNavControl(navCtrl)
        mNavigator = TryCast(navCtrl, ClientStudySurveyNavigator)
        If mNavigator Is Nothing Then
            Throw New Exception("The ConfigSection control expects a Navigator control of type ClientStudySurveyNavigator")
        End If

    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        Return mAllowUnload

    End Function

#End Region

#Region " Private Methods "

    Private Sub ConfigSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        mClientGroupModules.Add(New NewClientGroupModule(ConfigPanel))
        mClientGroupModules.Add(New ClientGroupPropertiesModule(ConfigPanel))

        mClientModules.Add(New NewClientModule(ConfigPanel))
        mClientModules.Add(New ClientPropertiesModule(ConfigPanel))
        mClientModules.Add(New NewStudyModule(ConfigPanel, mNavigator))

        mStudyModules.Add(New StudyPropertiesModule(ConfigPanel, mNavigator))
        mStudyModules.Add(New DataStructureModule(ConfigPanel))
        mStudyModules.Add(New NewSurveyModule(ConfigPanel))

        mSurveyModules.Add(New EditSurveyModule(ConfigPanel))
        mSurveyModules.Add(New BusinessRulesModule(ConfigPanel))
        mSurveyModules.Add(New SamplePeriodsModule(ConfigPanel))
        mSurveyModules.Add(New SamplePlanModule(ConfigPanel))
        mSurveyModules.Add(New FormLayoutModule(ConfigPanel))
        mSurveyModules.Add(New SampleUnitMappingsModule(ConfigPanel))
        mSurveyModules.Add(New MethodologyModule(ConfigPanel))
        mSurveyModules.Add(New ModeSectionMappingModule(ConfigPanel))
        mSurveyModules.Add(New SampleUnitCoverLetterMappingModule(ConfigPanel))
        mSurveyModules.Add(New PersonalizationModule(ConfigPanel))
        mSurveyModules.Add(New ValidationModule(ConfigPanel))
        mSurveyModules.Add(New TestPrintModule(ConfigPanel))

    End Sub

    Private Sub mNavigator_SelectionChanged(ByVal sender As Object, ByVal e As ClientStudySurveySelectionChangedEventArgs) Handles mNavigator.SelectionChanged

        LoadSelection(e.SelectionType)

    End Sub

    Private Sub LoadSelection(ByVal selectionType As Navigation.NavigationNodeType)

        SetPanelCaption()
        LoadToolStripItems(selectionType)

    End Sub

    Private Sub SetPanelCaption()

        SetPanelCaption("")

    End Sub

    Private Sub SetPanelCaption(ByVal title As String)

        Dim info As String = ""
        Dim finalTitle As String = ""

        If mNavigator.SelectedClientGroup IsNot Nothing Then
            finalTitle = "Client Group Configuration"
            info = mNavigator.SelectedClientGroup.DisplayLabel
        End If

        If mNavigator.SelectedClient IsNot Nothing Then
            finalTitle = "Client Configuration"
            info = mNavigator.SelectedClient.DisplayLabel
        End If

        If mNavigator.SelectedStudy IsNot Nothing Then
            finalTitle = "Study Configuration"
            info &= ":" & mNavigator.SelectedStudy.DisplayLabel
        End If

        If mNavigator.SelectedSurvey IsNot Nothing Then
            finalTitle = "Survey Configuration"
            info &= ":" & mNavigator.SelectedSurvey.DisplayLabel
        End If

        If Not String.IsNullOrEmpty(title) Then
            finalTitle = title
        End If

        MainPanel.Caption = String.Format("{0} - {1}", finalTitle, info)

    End Sub

    Private Sub LoadToolStripItems(ByVal selectionType As Navigation.NavigationNodeType)

        ConfigToolStrip.Items.Clear()
        mNavigator.ResetTreeMenuItems()

        Dim configModules As List(Of ConfigurationModule)

        ConfigToolStrip.LayoutStyle = ToolStripLayoutStyle.Flow
        ConfigToolStrip.Dock = DockStyle.Top

        Select Case selectionType
            Case Navigation.NavigationNodeType.ClientGroup
                configModules = mClientGroupModules

            Case Navigation.NavigationNodeType.Client
                configModules = mClientModules

            Case Navigation.NavigationNodeType.Study
                configModules = mStudyModules

            Case Navigation.NavigationNodeType.Survey
                configModules = mSurveyModules

            Case Else
                configModules = Nothing

        End Select

        If configModules IsNot Nothing Then
            For Each configModule As ConfigurationModule In configModules
                Dim btn As ToolStripButton
                Dim item As ToolStripMenuItem
                If mToolStripButtons.ContainsKey(configModule) Then
                    btn = mToolStripButtons(configModule)
                Else
                    btn = New ToolStripButton(configModule.Name, configModule.Image, mEditHandler)
                    btn.Tag = configModule
                    mToolStripButtons.Add(configModule, btn)
                End If
                If mToolStripMenuItems.ContainsKey(configModule) Then
                    item = mToolStripMenuItems(configModule)
                Else
                    item = New ToolStripMenuItem(configModule.Name, configModule.Image, mEditHandler)
                    item.Tag = configModule
                    mToolStripMenuItems.Add(configModule, item)
                End If
                btn.Enabled = configModule.IsEnabled(mNavigator.SelectedClientGroup, mNavigator.SelectedStudy, mNavigator.SelectedSurvey, btn)
                item.Enabled = btn.Enabled

                ConfigToolStrip.Items.Add(btn)
                mNavigator.TreeMenu.Items.Add(item)
            Next
        End If

    End Sub

    Private Sub EditModuleEventHandler(ByVal sender As Object, ByVal e As EventArgs)

        Dim configMod As ConfigurationModule = GetToolStripItemConfigModule(TryCast(sender, ToolStripItem))
        If configMod IsNot Nothing Then
            Dim configMethod As New BeingConfigMethod(AddressOf BeginConfig)
            configMethod.BeginInvoke(configMod, Nothing, Nothing)
        End If

    End Sub

    Private Function GetToolStripItemConfigModule(ByVal item As ToolStripItem) As ConfigurationModule

        If item Is Nothing Then
            Return Nothing
        End If

        Dim configMod As ConfigurationModule = TryCast(item.Tag, ConfigurationModule)

        Return configMod

    End Function

    Private Sub BeginConfig(ByVal configMod As ConfigurationModule)

        If InvokeRequired Then
            Dim del As New BeingConfigMethod(AddressOf BeginConfig)
            Invoke(del, configMod)
            Exit Sub
        End If

        mAllowUnload = False
        DisableToggleToolStripItems()
        SetPanelCaption(configMod.Name)

        Dim selectedGroup As Navigation.ClientGroupNavNode = mNavigator.SelectedClientGroup
        Dim selectedStudy As Navigation.StudyNavNode = mNavigator.SelectedStudy
        Dim selectedSurvey As Navigation.SurveyNavNode = mNavigator.SelectedSurvey
        Dim selectedClient As Navigation.ClientNavNode = mNavigator.SelectedClient

        mNavigator.Enabled = False
        Cursor = Cursors.WaitCursor

        Try
            configMod.BeginConfig(selectedGroup, selectedClient, selectedStudy, selectedSurvey, mEndConfigCallBack)

        Catch ex As Exception
            Globals.ReportException(ex)
            EndConfig(ConfigResultActions.None, Nothing)

        End Try

        Cursor = Cursors.Default

    End Sub

    Private Sub EndConfig(ByVal action As ConfigResultActions, ByVal data As Object)

        mNavigator.Enabled = True
        mAllowUnload = True
        EnableToggleToolStripItems()
        SetPanelCaption()

        Select Case action
            Case ConfigResultActions.ClientGroupRefresh
                mNavigator.RefreshClientGroupNode()

            Case ConfigResultActions.ClientRefresh
                mNavigator.RefreshClientNode()

            Case ConfigResultActions.StudyRefresh
                mNavigator.RefreshStudyNode()

            Case ConfigResultActions.SurveyRefresh
                mNavigator.RefreshSurveyNode()

            Case ConfigResultActions.ClientGroupAdded
                Dim clientGroup As ClientGroup = DirectCast(data, ClientGroup)
                mNavigator.AddClientGroup(clientGroup)

            Case ConfigResultActions.ClientAdded
                Dim client As Client = DirectCast(data, Client)
                mNavigator.AddClient(client)

            Case ConfigResultActions.StudyAdded
                Dim stdy As Study = DirectCast(data, Study)
                mNavigator.AddStudy(stdy)

            Case ConfigResultActions.SurveyAdded
                Dim svry As Survey = DirectCast(data, Survey)
                mNavigator.AddSurvey(svry)

            Case Else

        End Select

    End Sub

    Private Sub EnableToggleToolStripItems()

        For Each item As ToolStripItem In ConfigToolStrip.Items
            Dim config As ConfigurationModule = TryCast(item.Tag, ConfigurationModule)
            If config IsNot Nothing Then
                Dim btn As ToolStripButton = TryCast(item, ToolStripButton)
                item.Enabled = config.IsEnabled(mNavigator.SelectedClientGroup, mNavigator.SelectedStudy, mNavigator.SelectedSurvey, btn)
                mToolStripMenuItems(config).Enabled = item.Enabled
            End If
        Next

    End Sub

    Private Sub DisableToggleToolStripItems()

        For Each item As ToolStripItem In ConfigToolStrip.Items
            item.Enabled = False
        Next

    End Sub

#End Region

End Class
