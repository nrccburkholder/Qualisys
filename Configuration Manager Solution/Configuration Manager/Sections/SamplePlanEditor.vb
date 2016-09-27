Imports Nrc.Qualisys.Library
Imports Nrc.Framework.BusinessLogic.Configuration


Public Class SamplePlanEditor

    Public Event PrioritierViewModeChanged(ByVal sender As Object, ByVal eventArgs As PrioritierViewModeChangedEventArgs)

#Region " Private Fields "

    Private mEndConfigCallBack As EndConfigCallBackMethod
    Private mModule As SamplePlanModule
    Private mSelectedSampleUnit As SampleUnit
    Private mNeedCheck As Boolean = True
    Private tvWalkerFirst As TreeViewWalker
    Private tvWalkerNext As TreeViewWalker
    Private tvWalkerPrev As TreeViewWalker
    Private matchingNode As TreeNode
    Private processedSelectedNode As Boolean
    Private isMatch As Boolean

#End Region

#Region " Public Properties "

    Public Property PrioritizerViewMode() As SampleUnitPrioritizer.DataViewMode
        Get
            Return Me.UnitPrioritizer.ViewMode
        End Get
        Set(ByVal value As SampleUnitPrioritizer.DataViewMode)
            Me.UnitPrioritizer.ViewMode = value
        End Set
    End Property

#End Region

#Region " Private Properties "

    Private ReadOnly Property Title() As String
        Get
            Return "Sample Plan Editor"
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal endConfigCallBack As EndConfigCallBackMethod, ByVal configModule As SamplePlanModule)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        AddHandler Application.Idle, AddressOf IdleEvent

        ' Add any initialization after the InitializeComponent() call.
        Me.mEndConfigCallBack = endConfigCallBack
        Me.mModule = configModule
    End Sub

#End Region

#Region " Event Handlers "

    Private Sub SamplePlanEditor_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Me.Cursor = Cursors.WaitCursor
            Initialize()

        Catch ex As Exception
            Globals.ReportException(ex)

        Finally
            Me.Cursor = Cursors.Default
        End Try
    End Sub

    Private Sub WorkTabControl_Deselecting(ByVal sender As Object, ByVal e As System.Windows.Forms.TabControlCancelEventArgs) Handles WorkTabControl.Deselecting
        Try
            If (e.TabPage Is PropertyTabPage) Then
                If (Not CheckValues()) Then
                    e.Cancel = True
                    Return
                End If
                SaveValues()
            End If

        Catch ex As Exception
            Globals.ReportException(ex)
        End Try
    End Sub

    Private Sub WorkTabControl_Selected(ByVal sender As Object, ByVal e As System.Windows.Forms.TabControlEventArgs) Handles WorkTabControl.Selected
        Try
            Me.Cursor = Cursors.WaitCursor

            If (e.TabPage Is PropertyTabPage) Then
                'refresh priority
                PriorityTextBox.Text = Me.mSelectedSampleUnit.Priority.ToString
            ElseIf (e.TabPage Is PriorityTabPage) Then
                If (UnitPrioritizer.SampleUnits Is Nothing) Then
                    UnitPrioritizer.SampleUnits = Me.mModule.SampleUnits
                Else
                    'refresh unit prioritizer control based on current sample units info
                    Me.UnitPrioritizer.RefreshContent()
                End If
            End If

        Catch ex As Exception
            Globals.ReportException(ex)

        Finally
            Me.Cursor = Cursors.Default
        End Try

    End Sub

    Private Sub ApplyButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ApplyButton.Click
        Try
            Me.Cursor = Cursors.WaitCursor

            If (Not CheckValues()) Then Return
            SaveValues()

            Me.mEndConfigCallBack(ConfigResultActions.SampleUnitApply, Nothing)

            'The criteria object gets a new reference in the sampleunit object after
            'an insert, so we need to make sure the criteria Editor control has a 
            'reference to the new criteria object.
            Me.CriteriaEditorControl.CriteriaStmt = mSelectedSampleUnit.Criteria

        Catch ex As Exception
            Globals.ReportException(ex)

        Finally
            Me.Cursor = Cursors.Default
        End Try

    End Sub

    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OkButton.Click
        Try
            Me.Cursor = Cursors.WaitCursor

            If (Not CheckValues()) Then Return
            SaveValues()

            Me.mEndConfigCallBack(ConfigResultActions.SampleUnitRefresh, Nothing)
            Me.mEndConfigCallBack = Nothing

        Catch ex As Exception
            Globals.ReportException(ex)

        Finally
            Me.Cursor = Cursors.Default
        End Try
    End Sub

    Private Sub CnclButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CnclButton.Click
        Try
            Me.Cursor = Cursors.WaitCursor

            Me.mEndConfigCallBack(ConfigResultActions.None, Nothing)

            Me.mEndConfigCallBack = Nothing
        Catch ex As Exception
            Globals.ReportException(ex)

        Finally
            Me.Cursor = Cursors.Default
        End Try
    End Sub

#Region " Event Handlers for Property Tab Page "

    Private Sub SampleUnitTreeView_BeforeSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewCancelEventArgs) Handles SampleUnitTreeView.BeforeSelect
        Try
            If (mSelectedSampleUnit Is Nothing) Then Return
            If (Not CheckValues()) Then
                e.Cancel = True
                Return
            End If
            SaveValues()
            UpdateTreeNodeText(SampleUnitTreeView.SelectedNode)

        Catch ex As Exception
            Globals.ReportException(ex)
        End Try
    End Sub

    Private Sub SampleUnitTreeView_AfterSelect(ByVal sender As System.Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles SampleUnitTreeView.AfterSelect
        Try
            Dim selectedSampleUnit As SampleUnit = TryCast(Me.SampleUnitTreeView.SelectedNode.Tag, SampleUnit)
            If (selectedSampleUnit Is Nothing) Then Return
            mSelectedSampleUnit = selectedSampleUnit
            If Me.mModule.IsEditable Then
                AddUnitButton.Enabled = selectedSampleUnit.CanHaveChildUnit
                DeleteUnitButton.Enabled = selectedSampleUnit.IsDeletable
            Else
                AddUnitButton.Enabled = False
                DeleteUnitButton.Enabled = False
            End If
            DisplayUnit()

        Catch ex As Exception
            Globals.ReportException(ex)
        End Try
    End Sub

    Private Sub AddUnitButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddUnitButton.Click
        AddUnit()
    End Sub

    Private Sub DeleteUnitButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteUnitButton.Click
        DeleteUnit()
    End Sub

    Private Sub SampleSelectionTypeComboBox_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SampleSelectionTypeComboBox.SelectedIndexChanged
        Dim callbackMethod As SchedulerCallBackMethod = AddressOf SetFocus

        'Get new selection type
        Dim selectionType As SampleSelectionType = CType(SampleSelectionTypeComboBox.SelectedValue, SampleSelectionType)

        'Unit type of "Exclusive" or "Minor Module" can not have child units
        If (Me.mSelectedSampleUnit IsNot Nothing AndAlso _
            Me.mSelectedSampleUnit.ChildUnits IsNot Nothing AndAlso _
            Me.mSelectedSampleUnit.ChildUnits.Count > 0 AndAlso _
            (selectionType = SampleSelectionType.NonExclusive OrElse _
             selectionType = SampleSelectionType.MinorModule)) Then
            Dim msg As String
            msg = "Sample unit with child units can not switch to type ""Non-Exclusive"" or ""Minor Module""." & vbCrLf & _
                  "Delete the child sample units before switch the sample selection type."
            MessageBox.Show(msg, Me.Title, MessageBoxButtons.OK, MessageBoxIcon.Information)
            SampleSelectionTypeComboBox.SelectedValue = SampleSelectionType.Exclusive
            SchedulerControl.ScheduleTask(10, callbackMethod, SampleSelectionTypeComboBox)
            Return
        End If

        'If it's a Minor Module we don't want to allow them to add a Target
        If (selectionType = SampleSelectionType.MinorModule) Then
            TargetReturnNumeric.Value = 0
            TargetReturnNumeric.Enabled = False
        Else
            'JJF TargetReturnNumeric.Enabled = True
            Dim survey As New Survey()
            survey.SurveyType = CType(CAHPSTypeComboBox.SelectedValue, SurveyTypes)

            If mSelectedSampleUnit IsNot Nothing AndAlso survey.CompliesWithSwitchToPropSamplingDate Then
                TargetReturnNumeric.Enabled = False
            Else
                TargetReturnNumeric.Enabled = True
            End If
        End If

        'Enable/disable "Add Unit" button
        If (Me.mSelectedSampleUnit IsNot Nothing) Then
            Me.mSelectedSampleUnit.SelectionType = selectionType
            If Me.mModule.IsEditable Then
                AddUnitButton.Enabled = Me.mSelectedSampleUnit.CanHaveChildUnit
            Else
                AddUnitButton.Enabled = False
            End If
        End If
    End Sub

    Private Sub FacilityComboBox_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FacilityComboBox.SelectedIndexChanged
        Try
            If (FacilityComboBox.SelectedIndex < 0) Then Return
            Dim fac As Facility = TryCast(FacilityComboBox.SelectedItem, Facility)
            If (fac IsNot Nothing) Then
                'AhaIdTextBox.Text = fac.AhaId.ToString  'S46 US11 TSB 04/05/2016
                StateTextBox.Text = fac.State

                If fac.MedicareNumber Is Nothing Then
                    MedicareIdTextBox.Text = ""
                Else
                    MedicareIdTextBox.Text = fac.MedicareNumber.MedicareNumber
                End If
            Else
                'AhaIdTextBox.Text = "" 'S46 US11 TSB 04/05/2016
                MedicareIdTextBox.Text = ""
                StateTextBox.Text = ""
            End If

        Catch ex As Exception
            Globals.ReportException(ex)
        End Try
    End Sub

    Private Sub ServiceTypeComboBox_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ServiceTypeComboBox.SelectedIndexChanged
        Try
            If (ServiceTypeComboBox.SelectedIndex < 0) Then
                ServiceSubtypeListBox.Items.Clear()
                ApplyServiceLinkLabel.Enabled = False
                Return
            End If
            ApplyServiceLinkLabel.Enabled = True
            Dim parentServiceType As SampleUnitServiceType = TryCast(ServiceTypeComboBox.SelectedItem, SampleUnitServiceType)
            If (parentServiceType Is Nothing) Then Return
            Dim checked As Boolean
            ServiceSubtypeListBox.BeginUpdate()
            ServiceSubtypeListBox.Items.Clear()
            For Each service As SampleUnitServiceType In parentServiceType.ChildServices
                If (Me.mSelectedSampleUnit IsNot Nothing AndAlso _
                    Me.mSelectedSampleUnit.Service IsNot Nothing) Then
                    checked = SampleUnitServiceType.ServiceCollectionContains(Me.mSelectedSampleUnit.Service.ChildServices, service)
                Else
                    checked = False
                End If
                ServiceSubtypeListBox.Items.Add(service, checked)
            Next
            ServiceSubtypeListBox.EndUpdate()

        Catch ex As Exception
            Globals.ReportException(ex)
        End Try
    End Sub

    Private Sub CAHPSTypeComboBox_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles CAHPSTypeComboBox.SelectedIndexChanged

        'If (CType(CAHPSTypeComboBox.SelectedValue, CAHPSType) = CAHPSType.HCAHPS OrElse CType(CAHPSTypeComboBox.SelectedValue, CAHPSType) = CAHPSType.CHART) AndAlso _ 'CJB removed CHART 6/18/2014
        Dim survey As New Survey()
        survey.SurveyType = CType(CAHPSTypeComboBox.SelectedValue, SurveyTypes)

        If survey.CompliesWithSwitchToPropSamplingDate AndAlso _
                mModule.Survey.ActiveSamplePeriod IsNot Nothing AndAlso _
                mModule.Survey.ActiveSamplePeriod.ExpectedStartDate.HasValue AndAlso _
                mModule.Survey.ActiveSamplePeriod.ExpectedStartDate.Value >= AppConfig.Params("SwitchToPropSamplingDate").DateValue Then

            'Target return
            With TargetReturnNumeric
                .Value = 0
                .Enabled = False
            End With

            'Initial Response Rate
            With InitRespRateNumeric
                .Value = 0
                .Enabled = False
            End With
        Else
            If Me.mSelectedSampleUnit IsNot Nothing Then
                'Target return
                With TargetReturnNumeric
                    .Value = mSelectedSampleUnit.Target
                    .Enabled = True
                End With

                'Initial Response Rate
                With InitRespRateNumeric
                    .Value = mSelectedSampleUnit.InitialResponseRate
                    .Enabled = True
                End With
            End If
        End If

    End Sub

    Private Sub ApplyServiceLinkLabel_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles ApplyServiceLinkLabel.LinkClicked
        Try
            If (ServiceTypeComboBox.SelectedIndex < 0) Then
                MessageBox.Show("You must select a service type!", Title, MessageBoxButtons.OK, MessageBoxIcon.Information)
                Dim callbackMethod As SchedulerCallBackMethod = AddressOf SetFocus
                SchedulerControl.ScheduleTask(10, callbackMethod, ServiceTypeComboBox)
                Return
            End If

            Me.Cursor = Cursors.WaitCursor
            Dim servce As SampleUnitServiceType = Me.SaveServiceType
            Me.mSelectedSampleUnit.Service = servce
            ApplyServiceToChild(Me.mSelectedSampleUnit.ChildUnits, servce)

        Catch ex As Exception
            Globals.ReportException(ex)

        Finally
            Me.Cursor = Cursors.Default
        End Try
    End Sub

    Private Sub UnitTreeContextMenu_Opening(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles UnitTreeContextMenu.Opening
        Try
            Dim clickedNode As TreeNode

            'Check which tree node is clicked. If not click on node, do nothing
            Dim pt As Point = Me.SampleUnitTreeView.PointToClient(System.Windows.Forms.Cursor.Position)
            clickedNode = SampleUnitTreeView.GetNodeAt(pt)
            If (clickedNode Is Nothing) Then
                e.Cancel = True
                Return
            End If

            Dim unit As SampleUnit = TryCast(clickedNode.Tag, SampleUnit)
            If unit Is Nothing Then
                e.Cancel = True
                Return
            End If

            'Check if clicked node is selected node.
            'If not, do CheckValues
            If (clickedNode IsNot SampleUnitTreeView.SelectedNode) Then
                If (Not CheckValues()) Then
                    e.Cancel = True
                    Return
                End If
                SaveValues()
                SampleUnitTreeView.SelectedNode = clickedNode
            End If

            'Disable/enable add & delete menu item
            AddUnitMenuItem.Enabled = unit.CanHaveChildUnit
            DeleteUnitMenuItem.Enabled = unit.IsDeletable

        Catch ex As Exception
            Globals.ReportException(ex)

        End Try
    End Sub

    Private Sub AddUnitMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddUnitMenuItem.Click
        AddUnit()
    End Sub

    Private Sub DeleteUnitMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteUnitMenuItem.Click
        DeleteUnit()
    End Sub

    Private Sub TextBox_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles SampleUnitNameTextBox.GotFocus, _
                                                                                              MedicareIdTextBox.GotFocus, StateTextBox.GotFocus
        Dim ctrl As TextBox = TryCast(sender, TextBox)
        If ctrl IsNot Nothing Then ctrl.SelectAll()
    End Sub

    Private Sub btnFindNext_Click(sender As Object, e As EventArgs) Handles btnFindNext.Click
        processedSelectedNode = False     
        ProcessTree()
    End Sub

    Private Sub btnFindPrev_Click(sender As Object, e As EventArgs) Handles btnFindPrev.Click
        matchingNode = Nothing
        ProcessTree()
    End Sub

    Private Sub btnClearSearch_Click(sender As Object, e As EventArgs) Handles btnClearSearch.Click
        txtSearchText.Clear()
    End Sub

    Private Sub txtSearchText_TextChanged(sender As Object, e As EventArgs) Handles txtSearchText.TextChanged

    End Sub

    Public Sub IdleEvent(ByVal sender As System.Object, ByVal e As System.EventArgs)

        Dim isRootNodeSelected As Boolean = False

        If SampleUnitTreeView.Nodes.Count > 0 Then
            isRootNodeSelected = SampleUnitTreeView.Nodes(0).IsSelected
        End If

        btnFindNext.Enabled = SampleUnitTreeView.SelectedNode IsNot Nothing AndAlso txtSearchText.Text.Length > 0
        btnFindPrev.Enabled = SampleUnitTreeView.SelectedNode IsNot Nothing AndAlso processedSelectedNode AndAlso txtSearchText.Text.Length > 0


    End Sub

#End Region

#Region " Event Handlers for Priority Tab Page "

    Private Sub UnitPrioritizer_ViewModeChanged(ByVal sender As Object, ByVal e As PrioritierViewModeChangedEventArgs) Handles UnitPrioritizer.ViewModeChanged
        RaiseEvent PrioritierViewModeChanged(Me, e)
    End Sub

#End Region

#End Region

#Region " Public Methods "

    Public Sub RefreshAfterApply()
        'Refresh property tab
        SampleUnitTreeView.BeginUpdate()
        For Each node As TreeNode In SampleUnitTreeView.Nodes
            RefreshUnitTreeNode(node)
        Next
        SampleUnitTreeView.EndUpdate()

        Me.SampleUnitTreeView.SelectedNode = Me.SampleUnitTreeView.SelectedNode

        'Refresh priority tab
        InitializePriorityTab()
    End Sub

#End Region

#Region " Private Methods "

    Private Sub Initialize()
        'Information bar
        Me.InformationBar.Information = Me.mModule.Information

        'Initialize property tab page
        InitializePropertyTab()

        'Initialize priority tab page
        InitializePriorityTab()

        'Initialize other controls
        InitializeOther()

        InitializeTreeViewWalker()

    End Sub

    Private Sub InitializeOther()
        Me.ApplyButton.Enabled = Me.mModule.IsEditable
        Me.OkButton.Enabled = Me.mModule.IsEditable
    End Sub


#Region " Private Methods for Property Tab Page"

    Private Sub InitializePropertyTab()
        'Populate unit tree
        PopulateUnitTree()

        'Initialize property controls
        InitalizePropertyControls()

        'Select the first unit
        SampleUnitTreeView.SelectedNode = SampleUnitTreeView.Nodes(0)

        'Disable all the fields when viewing properties
        Me.PropertySplitContainer.Panel2.Enabled = Me.mModule.IsEditable



    End Sub



    Private Sub InitializeTreeViewWalker()

        processedSelectedNode = False

        tvWalkerNext = New TreeViewWalker(SampleUnitTreeView)
        tvWalkerPrev = New TreeViewWalker(SampleUnitTreeView)

        AddHandler tvWalkerNext.ProcessNode, AddressOf tvWalkerNext_ProcessNode
        AddHandler tvWalkerPrev.ProcessNode, AddressOf tvWalkerPrev_ProcessNode

        isMatch = False

    End Sub

    Private Sub PopulateUnitTree()
        Dim sampleUnits As Collection(Of SampleUnit) = Me.mModule.SampleUnits

        SampleUnitTreeView.BeginUpdate()
        SampleUnitTreeView.Nodes.Clear()
        For Each unit As SampleUnit In sampleUnits
            If unit.NeedsDelete Then Continue For
            'Detemine the root unit
            If unit.ParentUnit Is Nothing Then
                Dim rootNode As New TreeNode
                rootNode.Tag = unit
                rootNode.Text = unit.DisplayLabel
                Me.SampleUnitTreeView.Nodes.Add(rootNode)
                PopulateChildTreeNodes(rootNode)
            End If
        Next
        SampleUnitTreeView.ExpandAll()
        SampleUnitTreeView.EndUpdate()

    End Sub

    Private Sub PopulateChildTreeNodes(ByVal parentTreeNode As TreeNode)
        If (parentTreeNode Is Nothing) Then Return
        Dim parentUnit As SampleUnit = TryCast(parentTreeNode.Tag, SampleUnit)
        If (parentUnit Is Nothing OrElse parentUnit.ChildUnits Is Nothing) Then Return

        For Each childUnit As SampleUnit In parentUnit.ChildUnits
            If childUnit.NeedsDelete Then Continue For
            Dim childNode As New TreeNode
            childNode.Tag = childUnit
            childNode.Text = childUnit.DisplayLabel
            parentTreeNode.Nodes.Add(childNode)
            Me.PopulateChildTreeNodes(childNode)
        Next

    End Sub

    Private Sub InitalizePropertyControls()
        'Sample selection type
        SampleSelectionTypeComboBox.DataSource = SamplePlanModule.GetSampleSelectionTypes
        'Facilities
        FacilityComboBox.DataSource = Me.mModule.FacilityList
        'Service Types
        ServiceTypeComboBox.DataSource = SampleUnitServiceType.GetAllServiceTypes
        'CAHPS Types
        CAHPSTypeComboBox.DataSource = SamplePlanModule.GetCAHPSTypes(Me.mModule.Survey)
    End Sub

    Private Sub DisplayUnit()
        'Sample Unit name/ID
        SampleUnitNameTextBox.Text = mSelectedSampleUnit.Name

        If (mSelectedSampleUnit.IsNew) Then
            SampleUnitIdTextBox.Text = "New"
        Else
            SampleUnitIdTextBox.Text = mSelectedSampleUnit.Id.ToString
        End If

        'Sample selection type
        SampleSelectionTypeComboBox.SelectedValue = mSelectedSampleUnit.SelectionType
        If (SampleSelectionTypeComboBox.SelectedIndex < 0) Then
            SampleSelectionTypeComboBox.SelectedValue = SampleSelectionType.Exclusive
        End If
        If (Me.mModule.Survey.SamplingAlgorithm <> SamplingAlgorithm.StaticPlus) Then
            SampleSelectionTypeComboBox.Enabled = False
        End If

        'Sample Method
        'If (mModule.Survey.ActiveSamplePeriod Is Nothing) Then
        '    SampleMethodTextBox.Text = SampleSet.SamplingMethodLabel(SampleSet.SamplingMethod.None)
        'Else
        '    SampleMethodTextBox.Text = mModule.Survey.ActiveSamplePeriod.SamplingMethodLabel
        'End If

        Dim samplingMethod As SampleSet.SamplingMethod
        If (mModule.Survey.ActiveSamplePeriod Is Nothing) Then
            samplingMethod = SampleSet.SamplingMethod.SpecifyTargets
        Else
            samplingMethod = mModule.Survey.ActiveSamplePeriod.SamplingMethod
        End If

        SampleMethodTextBox.Text = SampleSet.SamplingMethodLabel(samplingMethod)

        Select Case samplingMethod
            Case SampleSet.SamplingMethod.Census
                TargetTypeLabel.Text = "Projected Outgo:"
                TargetReturnNumeric.Visible = False
                InitRespRateNumeric.Visible = False
                InitRespRatePercentLabel.Visible = False
                RespRateTextBox.Visible = False
                RespRatePercentLabel.Visible = False
            Case SampleSet.SamplingMethod.SpecifyOutgo
                TargetTypeLabel.Text = "Target Outgo:"
                TargetReturnNumeric.Visible = True
                InitRespRateNumeric.Visible = False
                InitRespRatePercentLabel.Visible = False
                RespRateTextBox.Visible = False
                RespRatePercentLabel.Visible = False
            Case Else
                TargetTypeLabel.Text = "Target Return:"
                TargetReturnNumeric.Visible = True
                InitRespRateNumeric.Visible = True
                InitRespRatePercentLabel.Visible = True
                RespRateTextBox.Visible = True
                RespRatePercentLabel.Visible = True
        End Select

        'Facility
        For Each fac As Facility In FacilityComboBox.Items
            If fac.Id = mSelectedSampleUnit.FacilityId Then
                FacilityComboBox.SelectedItem = fac
                Exit For
            End If
        Next
        If (FacilityComboBox.SelectedIndex < 0) Then FacilityComboBox.SelectedIndex = 0

        'JJF 'Target return
        'JJF TargetReturnNumeric.Value = mSelectedSampleUnit.Target

        'JJF 'Initial Response Rate
        'JJF InitRespRateNumeric.Value = mSelectedSampleUnit.InitialResponseRate

        'JJF - Added this to replace above
        Dim survey As New Survey()
        survey.SurveyType = CType(CAHPSTypeComboBox.SelectedValue, SurveyTypes)

        If survey.CompliesWithSwitchToPropSamplingDate AndAlso mModule.Survey.ActiveSamplePeriod IsNot Nothing AndAlso _
           mModule.Survey.ActiveSamplePeriod.ExpectedStartDate.HasValue AndAlso _
           mModule.Survey.ActiveSamplePeriod.ExpectedStartDate.Value >= AppConfig.Params("SwitchToPropSamplingDate").DateValue Then
            'Target return
            With TargetReturnNumeric
                .Value = 0
                .Enabled = False
            End With

            'Initial Response Rate
            With InitRespRateNumeric
                .Value = 0
                .Enabled = False
            End With
        Else
            'Target return
            With TargetReturnNumeric
                .Value = mSelectedSampleUnit.Target
                .Enabled = True
            End With

            'Initial Response Rate
            With InitRespRateNumeric
                .Value = mSelectedSampleUnit.InitialResponseRate
                .Enabled = True
            End With
        End If
        'JJF - End of add

        'Response Rate
        RespRateTextBox.Text = mSelectedSampleUnit.HistoricalResponseRate.ToString

        'CAHPS Type
        CAHPSTypeComboBox.SelectedValue = mSelectedSampleUnit.CAHPSType
        If CAHPSTypeComboBox.SelectedValue Is Nothing Then
            CAHPSTypeComboBox.SelectedValue = CAHPSType.None
        End If

        If Not mModule.Survey.IsCAHPS Then
            CAHPSTypeComboBox.SelectedValue = CAHPSType.None
            CAHPSTypeComboBox.Enabled = False
        End If

        'Don't sample option should be available only when it's staticplus
        Dim isStaticPlus As Boolean = (mModule.Survey.SamplingAlgorithm = SamplingAlgorithm.StaticPlus)
        DontSampleCheckBox.Visible = isStaticPlus
        DontSampleCheckBox.Checked = mSelectedSampleUnit.DontSampleUnit

        'Is suppressed in eReport?
        SuppressReportCheckBox.Checked = mSelectedSampleUnit.IsSuppressed

        LowVolumeUnitCheckBox.Checked = mSelectedSampleUnit.IsLowVolumeUnit

        'Priority
        PriorityTextBox.Text = mSelectedSampleUnit.Priority.ToString

        'Service Type & SubTypes
        ServiceTypeComboBox.SelectedIndex = -1
        If (mSelectedSampleUnit.Service IsNot Nothing) Then
            For Each service As SampleUnitServiceType In ServiceTypeComboBox.Items
                If (service.Id = mSelectedSampleUnit.Service.Id) Then
                    ServiceTypeComboBox.SelectedItem = service
                    Exit For
                End If
            Next
        Else
            ' S46 US11  if there was no servicetype selected, default to N/A because user were tired of having to do this TSB 04/05/2016
            For Each service As SampleUnitServiceType In ServiceTypeComboBox.Items
                If (service.Name = "N/A") Then
                    ServiceTypeComboBox.SelectedItem = service
                    Exit For
                End If
            Next
        End If

        'Criteria editor
        Me.CriteriaEditorControl.CriteriaStmt = mSelectedSampleUnit.Criteria

        'Set focus
        SampleUnitNameTextBox.Select()

    End Sub

    Private Sub SetFocus(ByVal obj As Object)
        Dim ctrl As Windows.Forms.Control = TryCast(obj, Windows.Forms.Control)
        If (ctrl IsNot Nothing) Then ctrl.Focus()
    End Sub

    Private Function CheckValues() As Boolean
        If (Not Me.mNeedCheck) Then Return True
        Dim callbackMethod As SchedulerCallBackMethod = AddressOf SetFocus

        'Sample Unit Name
        SampleUnitNameTextBox.Text = SampleUnitNameTextBox.Text.Trim
        If (SampleUnitNameTextBox.Text = "") Then
            MessageBox.Show("Sample unit name is required!", Title, MessageBoxButtons.OK, MessageBoxIcon.Information)
            SchedulerControl.ScheduleTask(10, callbackMethod, SampleUnitNameTextBox)
            Return False
        End If

        'Sample selection type
        If (SampleSelectionTypeComboBox.SelectedIndex < 0 OrElse _
            CType(SampleSelectionTypeComboBox.SelectedValue, SampleSelectionType) = SampleSelectionType.None) Then
            MessageBox.Show("You must select a sample selection type!", Title, MessageBoxButtons.OK, MessageBoxIcon.Information)
            SchedulerControl.ScheduleTask(10, callbackMethod, SampleSelectionTypeComboBox)
            Return False
        End If

        Dim selectionType As SampleSelectionType = CType(SampleSelectionTypeComboBox.SelectedValue, SampleSelectionType)

        If (Me.mSelectedSampleUnit IsNot Nothing AndAlso _
            Me.mSelectedSampleUnit.ChildUnits IsNot Nothing AndAlso _
            Me.mSelectedSampleUnit.ChildUnits.Count > 0 AndAlso _
            (selectionType = SampleSelectionType.NonExclusive OrElse _
             selectionType = SampleSelectionType.MinorModule)) Then
            Dim msg As String
            msg = "Sample unit with child units can not switch to type ""Non-Exclusive"" or ""Minor Module""." & vbCrLf & _
                  "Delete the child sample units before switch the sample selection type."
            MessageBox.Show(msg, Me.Title, MessageBoxButtons.OK, MessageBoxIcon.Information)
            SampleSelectionTypeComboBox.SelectedValue = SampleSelectionType.Exclusive
            SchedulerControl.ScheduleTask(10, callbackMethod, SampleSelectionTypeComboBox)
            Return False
        End If

        'Initial Response Rate
        Dim samplingMethod As SampleSet.SamplingMethod
        If (mModule.Survey.ActiveSamplePeriod Is Nothing) Then
            samplingMethod = SampleSet.SamplingMethod.SpecifyTargets
        Else
            samplingMethod = mModule.Survey.ActiveSamplePeriod.SamplingMethod
        End If

        Dim survey As New Survey()
        survey.SurveyType = CType(CAHPSTypeComboBox.SelectedValue, SurveyTypes)

        Select Case samplingMethod
            Case SampleSet.SamplingMethod.Census, SampleSet.SamplingMethod.SpecifyOutgo
                'force init RR to 100%
                'JJF If (InitRespRateNumeric.Value <> 100) Then
                'If (InitRespRateNumeric.Value <> 100 AndAlso Not (CType(CAHPSTypeComboBox.SelectedValue, CAHPSType) = CAHPSType.HCAHPS OrElse CType(CAHPSTypeComboBox.SelectedValue, CAHPSType) = CAHPSType.CHART)) Then 'CJB removed CHART 6/18/2014
                If (InitRespRateNumeric.Value <> 100 AndAlso Not survey.BypassInitRespRateNumericEnforcement) Then
                    InitRespRateNumeric.Value = 100
                End If
            Case Else
                'JJF If (InitRespRateNumeric.Value = 0) Then
                'If (InitRespRateNumeric.Value = 0 AndAlso Not (CType(CAHPSTypeComboBox.SelectedValue, CAHPSType) = CAHPSType.HCAHPS OrElse CType(CAHPSTypeComboBox.SelectedValue, CAHPSType) = CAHPSType.CHART)) Then 'CJB removed CHART 6/18/2014
                If (InitRespRateNumeric.Value = 0 AndAlso Not survey.BypassInitRespRateNumericEnforcement) Then
                    MessageBox.Show("Initial response rate must be larger than 0%", Me.Title, MessageBoxButtons.OK, MessageBoxIcon.Information)
                    SchedulerControl.ScheduleTask(10, callbackMethod, InitRespRateNumeric)
                    Return False
                End If
        End Select

        'Medicare ID
        MedicareIdTextBox.Text = MedicareIdTextBox.Text.Trim
        'If ((Not CType(CAHPSTypeComboBox.SelectedValue, CAHPSType) = CAHPSType.None AndAlso Not CType(CAHPSTypeComboBox.SelectedValue, CAHPSType) = CAHPSType.MNCM AndAlso Not CType(CAHPSTypeComboBox.SelectedValue, CAHPSType) = CAHPSType.ACOCAHPS) AndAlso MedicareIdTextBox.Text = "") Then
        If (Not CType(CAHPSTypeComboBox.SelectedValue, CAHPSType) = CAHPSType.None AndAlso Not survey.MedicareIdTextMayBeBlank AndAlso MedicareIdTextBox.Text = "") Then
            MessageBox.Show("You must select a facility with a valid Medicare ID!", Title, MessageBoxButtons.OK, MessageBoxIcon.Information)
            SchedulerControl.ScheduleTask(10, callbackMethod, FacilityComboBox)
            Return False
        End If

        'Service type
        If (ServiceTypeComboBox.SelectedIndex < 0) Then
            MessageBox.Show("You must select a service type!", Title, MessageBoxButtons.OK, MessageBoxIcon.Information)
            SchedulerControl.ScheduleTask(10, callbackMethod, ServiceTypeComboBox)
            Return False
        End If

        'Criteria editor
        If (Not CriteriaEditorControl.IsValid OrElse Not Me.CriteriaEditorControl.CriteriaStmt.IsValid) Then
            MessageBox.Show("Criteria statement is not valid!", Title, MessageBoxButtons.OK, MessageBoxIcon.Information)
            SchedulerControl.ScheduleTask(10, callbackMethod, CriteriaEditorControl)
            Return False
        End If

        Return True
    End Function

    Private Sub SaveValues()
        With Me.mSelectedSampleUnit
            .Name = SampleUnitNameTextBox.Text
            .SelectionType = CType(SampleSelectionTypeComboBox.SelectedValue, SampleSelectionType)
            If (FacilityComboBox.SelectedIndex >= 0) Then
                Dim fac As Facility = TryCast(FacilityComboBox.SelectedItem, Facility)
                .FacilityId = fac.Id
            End If

            .Target = CInt(TargetReturnNumeric.Value)
            .InitialResponseRate = CInt(InitRespRateNumeric.Value)
            .CAHPSType = CType(CAHPSTypeComboBox.SelectedValue, CAHPSType)
            .DontSampleUnit = DontSampleCheckBox.Checked
            .IsSuppressed = SuppressReportCheckBox.Checked
            .Service = SaveServiceType()
            .IsLowVolumeUnit = LowVolumeUnitCheckBox.Checked
        End With
    End Sub

    Private Function SaveServiceType() As SampleUnitServiceType
        If (ServiceTypeComboBox.SelectedIndex < 0) Then Return Nothing
        Dim selectedParentService As SampleUnitServiceType = TryCast(ServiceTypeComboBox.SelectedItem, SampleUnitServiceType)
        If (selectedParentService Is Nothing) Then Return Nothing
        Dim parentService As New SampleUnitServiceType(selectedParentService.Id, selectedParentService.Name)
        For Each item As SampleUnitServiceType In ServiceSubtypeListBox.CheckedItems
            parentService.ChildServices.Add(item)
        Next
        Return parentService
    End Function

    Private Sub AddUnit()
        Try
            'Check & save for current sample unit
            If (Not CheckValues()) Then Return
            SaveValues()

            'Check if there is a unit selected
            If (Me.mSelectedSampleUnit Is Nothing OrElse Me.SampleUnitTreeView.SelectedNode Is Nothing) Then
                MessageBox.Show("Select a sample unit before adding new sample unit", "Sample Unit Property Editor", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            'Check if child unit is allowed
            If (Not Me.mSelectedSampleUnit.CanHaveChildUnit) Then
                Dim msg As String = ""
                For Each str As String In Me.mSelectedSampleUnit.CannotAddChildUnitReasons
                    msg &= str & vbCrLf
                Next
                MessageBox.Show(msg, Me.Title, MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            'Add new unit
            Dim childNode As TreeNode = AddTreeNode(Me.SampleUnitTreeView.SelectedNode)
            If (childNode IsNot Nothing) Then Me.SampleUnitTreeView.SelectedNode = childNode

        Catch ex As Exception
            Globals.ReportException(ex)
        End Try
    End Sub

    Private Function AddTreeNode(ByVal parentTreeNode As TreeNode) As TreeNode
        If (parentTreeNode Is Nothing) Then Return Nothing
        Dim parentUnit As SampleUnit = TryCast(parentTreeNode.Tag, SampleUnit)
        If (parentUnit Is Nothing) Then Return Nothing
        Dim unit As SampleUnit = Me.mModule.NewSampleUnit(parentUnit)

        Dim childNode As New TreeNode
        childNode.Tag = unit
        childNode.Text = unit.DisplayLabel

        SampleUnitTreeView.BeginUpdate()
        parentTreeNode.Nodes.Add(childNode)
        SampleUnitTreeView.EndUpdate()
        Return childNode
    End Function

    Private Sub DeleteUnit()
        Try
            'Check if there is a unit selected
            If (Me.mSelectedSampleUnit Is Nothing OrElse Me.SampleUnitTreeView.SelectedNode Is Nothing) Then
                MessageBox.Show("Select a sample unit to delete", "Sample Unit Property Editor", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            'Check if selected unit is deletable
            If (Not Me.mSelectedSampleUnit.IsDeletable) Then
                Dim msg As String = ""
                For Each str As String In Me.mSelectedSampleUnit.UndeletableReasons
                    msg &= str & vbCrLf
                Next
                MessageBox.Show(msg, Me.Title, MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            'Delete the selected unit
            Me.mNeedCheck = False
            Dim parentNode As TreeNode = DeleteTreeNode(Me.SampleUnitTreeView.SelectedNode)

            'Set deleted unit's parent unit to be selected
            If (parentNode IsNot Nothing) Then Me.SampleUnitTreeView.SelectedNode = parentNode

        Catch ex As Exception
            Globals.ReportException(ex)

        Finally
            Me.mNeedCheck = True
        End Try
    End Sub

    Private Function DeleteTreeNode(ByVal node As TreeNode) As TreeNode
        If (node Is Nothing) Then Return Nothing
        Dim unit As SampleUnit = TryCast(node.Tag, SampleUnit)
        If (unit Is Nothing) Then Return Nothing
        unit.Delete()

        Dim parentNode As TreeNode = node.Parent
        SampleUnitTreeView.BeginUpdate()
        node.Remove()
        SampleUnitTreeView.EndUpdate()
        Return parentNode

    End Function

    Private Sub UpdateTreeNodeText(ByVal node As TreeNode)
        If (node Is Nothing) Then Return
        Dim unit As SampleUnit = TryCast(node.Tag, SampleUnit)
        If (unit Is Nothing) Then Return
        node.Text = unit.DisplayLabel
    End Sub

    Private Sub ApplyServiceToChild(ByVal units As Collection(Of SampleUnit), ByVal service As SampleUnitServiceType)
        If (units Is Nothing) Then Return
        For Each unit As SampleUnit In units
            unit.Service = service
            ApplyServiceToChild(unit.ChildUnits, service)
        Next
    End Sub

    Private Sub RefreshUnitTreeNode(ByVal node As TreeNode)
        If (node Is Nothing) Then Return
        Dim unit As SampleUnit = TryCast(node.Tag, SampleUnit)
        If (unit Is Nothing) Then Return
        node.Text = unit.DisplayLabel
        For Each childNode As TreeNode In node.Nodes
            RefreshUnitTreeNode(childNode)
        Next
    End Sub


#Region "TreeViewWalker"

    Private Sub ProcessTree()
        isMatch = False
        tvWalkerNext.ProcessTree()
        If isMatch = False Then
            Dim msg As String
            If SampleUnitTreeView.SelectedNode.Text.ToLower().Contains(txtSearchText.Text.ToLower()) Then
                msg = "No additional matches found for specified text: {0} {1} {2}"
            Else
                msg = "Could not find matches for specified text: {0} {1} {2}"
            End If
            MessageBox.Show(String.Format(msg, vbCrLf, vbCrLf, txtSearchText.Text), "Sample Unit Tree Search", MessageBoxButtons.OK, MessageBoxIcon.None)
        End If
    End Sub

    Private Sub tvWalkerNext_ProcessNode(ByVal sender As Object, ByVal e As ProcessNodeEventArgs)


        If Not SampleUnitTreeView.SelectedNode.Text.ToLower().Contains(txtSearchText.Text.ToLower()) Then
            'This is a new search.  Just find the first match.
            If ContainsSearchText(e.Node) Then
                SampleUnitTreeView.SelectedNode = e.Node
                e.StopProcessing = True
                isMatch = True
                Exit Sub
            End If

        End If

        ' subsequent search for same text continues here
        If e.Node.Handle = SampleUnitTreeView.SelectedNode.Handle Then
            processedSelectedNode = True
        End If


        ' If we have already processed the selected node and the current node 
        ' matches the search text, then we have found the "next" node and it
        ' should be selected.
        If processedSelectedNode AndAlso e.Node.Handle <> SampleUnitTreeView.SelectedNode.Handle AndAlso ContainsSearchText(e.Node) Then
            SampleUnitTreeView.SelectedNode = e.Node
            e.StopProcessing = True
            isMatch = True
            Exit Sub
        End If

    End Sub

    Private Sub tvWalkerPrev_ProcessNode(ByVal sender As Object, ByVal e As ProcessNodeEventArgs)

        If e.Node Is SampleUnitTreeView.SelectedNode Then
            If matchingNode IsNot Nothing Then
                SampleUnitTreeView.SelectedNode = matchingNode
                e.StopProcessing = True
                isMatch = True
                Exit Sub
            End If
        End If

        ' If we have walked all the way down to the selected node then the
        ' most recently discovered matching node is the "previous" node, 
        ' and it should be selected.
        If ContainsSearchText(e.Node) Then
            matchingNode = e.Node
        End If


    End Sub


    Private Function ContainsSearchText(ByVal node As TreeNode) As Boolean
        If node Is Nothing Or node.Text Is Nothing Then
            Return False
        End If

        Return node.Text.ToLower().Contains(txtSearchText.Text.ToLower())

    End Function


#End Region

#End Region

#Region " Private Methods for Priority Tab Page "

    Private Sub InitializePriorityTab()
        If (Me.mModule.Survey.SamplingAlgorithm = SamplingAlgorithm.StaticPlus) Then
            If (Not WorkTabControl.Controls.Contains(PriorityTabPage)) Then
                WorkTabControl.Controls.Add(PriorityTabPage)
            End If
        Else
            If (WorkTabControl.Controls.Contains(PriorityTabPage)) Then
                WorkTabControl.Controls.Remove(PriorityTabPage)
            End If
        End If

        Me.UnitPrioritizer.Enable = Me.mModule.IsEditable
    End Sub

#End Region

#End Region



End Class
