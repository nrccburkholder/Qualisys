Imports Nrc.DataMart.Library

Public Class ClientStudySurveyNavigator

    Public Enum ScheduledFilesViewMode
        ShowAllFiles = 1
        FilterByClientStudySurvey = 2
    End Enum

    Private mIsHcahps As Boolean
    Private mIsHHcahps As Boolean
    Private mIsACOcahps As Boolean
    Private mIsCHART As Boolean
    Private mAllowMultiSelect As Boolean
    Public Event SelectionChanged As EventHandler
    Public Event SelectedFilterButtonChanged As EventHandler
    Private mSurveyIndex As New Dictionary(Of Integer, Survey)
    Private mUnitIndex As New Dictionary(Of Integer, SampleUnit)


#Region " Private Instance Fields "
    Private mSelectedClients As New Collection(Of Client)
    Private mSelectedStudies As New Collection(Of Study)
    Private mSelectedSurveys As New Collection(Of Survey)
    Private mSelectedUnits As New Collection(Of SampleUnit)
    Private mSelectedClientIds As New List(Of Integer)
    Private mSelectedStudyIds As New List(Of Integer)
    Private mSelectedSurveyIds As New List(Of Integer)
    Private mSelectedUnitIds As New List(Of Integer)

#End Region

#Region " Public Properties "
    Public ReadOnly Property SelectedClients() As Collection(Of Client)
        Get
            Return Me.mSelectedClients
        End Get
    End Property

    Public ReadOnly Property SelectedStudies() As Collection(Of Study)
        Get
            Return Me.mSelectedStudies
        End Get
    End Property

    Public ReadOnly Property SelectedSurveys() As Collection(Of Survey)
        Get
            Return Me.mSelectedSurveys
        End Get
    End Property

    Public ReadOnly Property SelectedUnits() As Collection(Of SampleUnit)
        Get
            Return Me.mSelectedUnits
        End Get
    End Property

    Public ReadOnly Property SelectedClientIds() As List(Of Integer)
        Get
            Return Me.mSelectedClientIds
        End Get
    End Property

    Public ReadOnly Property SelectedStudyIds() As List(Of Integer)
        Get
            Return Me.mSelectedStudyIds
        End Get
    End Property

    Public ReadOnly Property SelectedSurveyIds() As List(Of Integer)
        Get
            Return Me.mSelectedSurveyIds
        End Get
    End Property

    Public ReadOnly Property SelectedUnitIds() As List(Of Integer)
        Get
            Return Me.mSelectedUnitIds
        End Get
    End Property

    Public ReadOnly Property ShowAllFiles() As Boolean
        Get
            Return Me.ShowAllFilesButton.Checked
        End Get
    End Property
#End Region

#Region " Constructors "
    Public Sub New()
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mIsHcahps = False
        mIsHHcahps = False
        mIsCHART = False
        mIsACOcahps = False
        mAllowMultiSelect = False
        Me.FilterToolStrip.Visible = False
        Me.SelectHeaderStrip.Visible = True
    End Sub

    Public Sub New(ByVal exportType As ExportSetType, ByVal allowMultiSelect As Boolean)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Select Case exportType
            Case ExportSetType.CmsHcahps
                mIsHcahps = True
                mIsHHcahps = False
                mIsCHART = False
                mIsACOcahps = False
            Case ExportSetType.CmsHHcahps
                mIsHcahps = False
                mIsHHcahps = True
                mIsCHART = False
                mIsACOcahps = False
            Case ExportSetType.CmsChart
                mIsHcahps = False
                mIsHHcahps = False
                mIsCHART = True
                mIsACOcahps = False
            Case ExportSetType.CmsChart
                mIsHcahps = False
                mIsHHcahps = False
                mIsCHART = False
                mIsACOcahps = True
        End Select
        mAllowMultiSelect = allowMultiSelect
        Me.FilterToolStrip.Visible = False
        Me.SelectHeaderStrip.Visible = True
    End Sub

    Public Sub New(ByVal showScheduledFilesFilters As Boolean, ByVal isHcahps As Boolean, ByVal allowMultiSelect As Boolean)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mIsHcahps = isHcahps
        mIsHHcahps = isHcahps
        mIsCHART = isHcahps
        mAllowMultiSelect = allowMultiSelect
        Me.FilterToolStrip.Visible = showScheduledFilesFilters
        Me.ClientStudySurveyTree.Enabled = (Not showScheduledFilesFilters)
        Me.SelectHeaderStrip.Visible = (Not showScheduledFilesFilters)
    End Sub
#End Region

    Private Sub ClientStudySurveyNavigator_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim clientList As Collection(Of Client)

        If mIsHcahps Then
            Dim unitList As New Collection(Of SampleUnit)
            clientList = Client.GetHcahpsClientsByUser(Environment.UserName, unitList)
            Me.PopulateTree(clientList, unitList)
        ElseIf mIsHHcahps Then
            Dim unitList As New Collection(Of SampleUnit)
            clientList = Client.GetHHcahpsClientsByUser(Environment.UserName, unitList)
            Me.PopulateTree(clientList, unitList)
        ElseIf mIsCHART Then
            Dim unitList As New Collection(Of SampleUnit)
            clientList = Client.GetCHARTClientsByUser(Environment.UserName, unitList)
            Me.PopulateTree(clientList, unitList)
        Else
            clientList = Client.GetClientsByUser(Environment.UserName, Client.PopulateDepth.Survey)
            Me.PopulateTree(clientList)
        End If
    End Sub

    Private Sub PopulateTree(ByVal clientList As Collection(Of Client))
        Me.PopulateTree(clientList, Nothing)
    End Sub

    Private Sub PopulateTree(ByVal clientList As Collection(Of Client), ByVal unitList As Collection(Of SampleUnit))
        Dim clientNodes As New List(Of TreeNode)
        Dim newClientNode As TreeNode

        Dim surveyUnitList As New Dictionary(Of Integer, List(Of SampleUnit))

        'Build the list of units by survey if neccessary
        If mIsHcahps OrElse mIsHHcahps OrElse mIsCHART Then
            For Each unit As SampleUnit In unitList
                If Not surveyUnitList.ContainsKey(unit.SurveyId) Then
                    surveyUnitList.Add(unit.SurveyId, New List(Of SampleUnit))
                End If
                surveyUnitList(unit.SurveyId).Add(unit)
            Next
        End If

        'Create all the root nodes
        For Each clnt As Client In clientList
            newClientNode = New TreeNode(clnt.DisplayLabel)
            newClientNode.Tag = clnt

            Dim newStudyNode As TreeNode
            For Each stdy As Study In clnt.Studies
                newStudyNode = New TreeNode(stdy.DisplayLabel)
                newStudyNode.Tag = stdy
                newClientNode.Nodes.Add(newStudyNode)

                Dim newSurveyNode As TreeNode
                For Each srvy As Survey In stdy.Surveys
                    newSurveyNode = New TreeNode(srvy.DisplayLabel)
                    newSurveyNode.Tag = srvy
                    newStudyNode.Nodes.Add(newSurveyNode)
                    Me.mSurveyIndex.Add(srvy.Id, srvy)

                    Dim newUnitNode As TreeNode
                    'Build the unit nodes if needed
                    If mIsHcahps OrElse mIsHHcahps OrElse mIsCHART Then
                        If surveyUnitList.ContainsKey(srvy.Id) Then
                            For Each unit As SampleUnit In surveyUnitList(srvy.Id)
                                newUnitNode = New TreeNode(unit.DisplayLabel)
                                newUnitNode.Tag = unit
                                newSurveyNode.Nodes.Add(newUnitNode)
                                Me.mUnitIndex.Add(unit.Id, unit)
                            Next
                        End If
                    End If
                Next
            Next

            clientNodes.Add(newClientNode)
        Next

        'Me.Controls.Remove(Me.ClientStudySurveyTree)
        Me.ClientStudySurveyTree.BeginUpdate()
        Dim nodes() As TreeNode = clientNodes.ToArray
        Me.ClientStudySurveyTree.Nodes.AddRange(nodes)
        Me.ClientStudySurveyTree.EndUpdate()
        'Me.Controls.Add(Me.ClientStudySurveyTree)
    End Sub

    Private Sub ClearLists()
        Me.mSelectedClients.Clear()
        Me.mSelectedClientIds.Clear()
        Me.mSelectedStudies.Clear()
        Me.mSelectedStudyIds.Clear()
        Me.mSelectedSurveys.Clear()
        Me.mSelectedSurveyIds.Clear()
        Me.mSelectedUnits.Clear()
        Me.mSelectedUnitIds.Clear()
    End Sub

    Private Sub ViewMode(ByVal viewMode As ScheduledFilesViewMode)
        Me.ClientStudySurveyTree.Enabled = (viewMode = ScheduledFilesViewMode.FilterByClientStudySurvey)
        Me.ShowAllFilesButton.Checked = (viewMode = ScheduledFilesViewMode.ShowAllFiles)
        Me.FilterButton.Checked = (viewMode = ScheduledFilesViewMode.FilterByClientStudySurvey)
    End Sub

    Private Sub BuildSelectionLists()
        Dim node As TreeNode

        ClearLists()
        For Each node In Me.ClientStudySurveyTree.SelectedNodes
            If TypeOf (node.Tag) Is Client Then
                Dim clnt As Client = DirectCast(node.Tag, Client)
                Me.mSelectedClients.Add(clnt)
                Me.mSelectedClientIds.Add(clnt.Id)
            ElseIf TypeOf (node.Tag) Is Study Then
                Dim stdy As Study = DirectCast(node.Tag, Study)
                Me.mSelectedStudies.Add(stdy)
                Me.mSelectedStudyIds.Add(stdy.Id)
            ElseIf TypeOf (node.Tag) Is Survey Then
                Dim srvy As Survey = DirectCast(node.Tag, Survey)
                Me.mSelectedSurveys.Add(srvy)
                Me.mSelectedSurveyIds.Add(srvy.Id)
            ElseIf TypeOf (node.Tag) Is SampleUnit Then
                Dim unit As SampleUnit = DirectCast(node.Tag, SampleUnit)
                Me.mSelectedUnits.Add(unit)
                Me.mSelectedUnitIds.Add(unit.Id)
            End If
        Next
    End Sub

    Private Sub ClientStudySurveyTree_BeforeSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewCancelEventArgs) Handles ClientStudySurveyTree.BeforeSelect
        If Not mAllowMultiSelect Then
            If e.Action = TreeViewAction.ByMouse OrElse e.Action = TreeViewAction.ByKeyboard Then
                If ((ModifierKeys And Keys.Control) = Keys.Control) OrElse ((ModifierKeys And Keys.Shift) = Keys.Shift) Then
                    Dim initialClient As Integer
                    Dim nodeClientId As Integer
                    Dim node As TreeNode

                    'Get the client ID for the node being selected
                    node = e.Node
                    If TypeOf (node.Tag) Is Client Then
                        initialClient = DirectCast(node.Tag, Client).Id
                    ElseIf TypeOf (node.Tag) Is Study Then
                        initialClient = DirectCast(node.Tag, Study).ClientId
                    ElseIf TypeOf (node.Tag) Is Survey Then
                        initialClient = DirectCast(node.Tag, Survey).Study.ClientId
                    ElseIf TypeOf (node.Tag) Is SampleUnit Then
                        initialClient = DirectCast(node.Parent.Tag, Survey).Study.ClientId
                    End If

                    For Each node In Me.ClientStudySurveyTree.SelectedNodes
                        If TypeOf (node.Tag) Is Client Then
                            Dim clnt As Client = DirectCast(node.Tag, Client)
                            nodeClientId = clnt.Id
                        ElseIf TypeOf (node.Tag) Is Study Then
                            Dim stdy As Study = DirectCast(node.Tag, Study)
                            nodeClientId = stdy.ClientId
                        ElseIf TypeOf (node.Tag) Is Survey Then
                            Dim srvy As Survey = DirectCast(node.Tag, Survey)
                            nodeClientId = srvy.Study.ClientId
                        ElseIf TypeOf (node.Tag) Is SampleUnit Then
                            nodeClientId = DirectCast(node.Parent.Tag, Survey).Study.ClientId
                        End If

                        'Check to see if this client is different than the node being selected.  If it is different,
                        'then cancel
                        If initialClient <> nodeClientId Then
                            e.Cancel = True
                        End If
                    Next
                End If
            End If
        End If
    End Sub

    Private Sub ClientStudySurveyTree_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ClientStudySurveyTree.SelectionChanged
        Me.BuildSelectionLists()
        RaiseEvent SelectionChanged(Me, EventArgs.Empty)
    End Sub

    Private Sub ShowAllFilesButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ShowAllFilesButton.Click
        ViewMode(ScheduledFilesViewMode.ShowAllFiles)
        RaiseEvent SelectedFilterButtonChanged(Me, EventArgs.Empty)
    End Sub

    Private Sub FilterButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FilterButton.Click
        ViewMode(ScheduledFilesViewMode.FilterByClientStudySurvey)
        RaiseEvent SelectedFilterButtonChanged(Me, EventArgs.Empty)
    End Sub

    Public Function FindSurvey(ByVal surveyId As Integer) As Survey
        Dim srvy As Survey = Nothing
        Me.mSurveyIndex.TryGetValue(surveyId, srvy)
        Return srvy
    End Function

    Public Function FindUnit(ByVal sampleUnitId As Integer) As SampleUnit
        Dim unit As SampleUnit = Nothing
        Me.mUnitIndex.TryGetValue(sampleUnitId, unit)
        Return unit
    End Function

End Class
