Imports Nrc.Qualisys.Library
'Todo: Change code to show all sections that have not been mapped to every selected unit
Public Class SampleUnitSectionMappingEditor
#Region " Private Fields "
    Private mModule As SampleUnitMappingsModule
    Private mEndConfigCallBack As EndConfigCallBackMethod
    'Integer is the sectionID
    Private mAllQuestionSections As New Collection(Of QuestionSection)
    Private mAvailableQuestionSections As New Collection(Of SampleUnitSectionMapping)
    Private mMappedQuestionSections As New Collection(Of SampleUnitSectionMapping)
    Private mSelectedSampleUnits As New Collection(Of SampleUnit)
    Private mAllSampleUnits As Collection(Of SampleUnit)
#End Region

#Region " Constructors "
    Public Sub New(ByVal surveyModule As SampleUnitMappingsModule, ByVal endConfigCallBack As EndConfigCallBackMethod)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mModule = surveyModule
        Me.mEndConfigCallBack = endConfigCallBack
    End Sub
#End Region

#Region "Event Handlers"
    Private Sub SampleUnitSectionMappingEditor_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Initialize()
    End Sub

    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click
        If Not Me.mEndConfigCallBack Is Nothing Then
            SaveAllChanges()
            Me.mEndConfigCallBack(ConfigResultActions.None, Nothing)
            Me.mEndConfigCallBack = Nothing
        End If
    End Sub


    Private Sub ApplyButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles ApplyButton.Click
        SaveAllChanges()
    End Sub

    Private Sub CancelButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelButton.Click
        Me.mEndConfigCallBack(ConfigResultActions.None, Nothing)
        Me.mEndConfigCallBack = Nothing
    End Sub

    Private Sub SampleUnitTreeView_AfterSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles SampleUnitTreeView.AfterSelect
        UpdateSelectedSampleUnitsCollection()
    End Sub

    Private Sub AvailableGridView_SelectionChanged(ByVal sender As Object, ByVal e As DevExpress.Data.SelectionChangedEventArgs) Handles AvailableGridView.SelectionChanged
        ToggleAddButton()
    End Sub

    Private Sub AddMappedSectionButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddMappedSectionButton.Click
        AddMappedSections()
    End Sub

    Private Sub MapToolStripMenuItem_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles MapToolStripMenuItem.Click
        AddMappedSections()
    End Sub

    Private Sub DeleteMappedSectionButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteMappedSectionButton.Click
        DeleteMappedSections()
    End Sub

    Private Sub UnMapToolStripMenuItem_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles UnMapToolStripMenuItem.Click
        DeleteMappedSections()
    End Sub

    Private Sub MappedGridView_SelectionChanged(ByVal sender As Object, ByVal e As DevExpress.Data.SelectionChangedEventArgs) Handles MappedGridView.SelectionChanged
        ToggleDeleteButton()
    End Sub
#End Region

#Region " Private Methods "
    Private Sub Initialize()
        ' Information bar
        Me.InformationBar.Information = mModule.Information

        'Get a list of all sampleunits for this survey
        Me.mAllSampleUnits = SampleUnit.GetSampleUnitsBySurveyId(Me.mModule.Survey)

        'Get a list of all sections for this survey
        Me.mAllQuestionSections = QuestionSection.GetBySurveyId(Me.mModule.Survey.Id)

        'Set the Binding Source for mapped sections grid
        Me.MappedSectionsBindingSource.DataSource = mMappedQuestionSections

        'Set the binding source for the available sections grid
        Me.AvailableSectionsBindingSource.DataSource = Me.mAvailableQuestionSections

        'Set the Binding Source for the section lookup
        Me.QuestionSectionBindingSource.DataSource = Me.mAllQuestionSections

        'Set the binding source for the sampleunit lookup
        Me.SampleUnitBindingSource.DataSource = Me.mSelectedSampleUnits

        'Disable the add and delete buttons
        Me.ToggleAddButton()
        Me.ToggleDeleteButton()
        'Me.AddMappedSectionButton.Enabled = False
        'Me.DeleteMappedSectionButton.Enabled = False

        'Don't allow save if module is not editable
        Me.OKButton.Enabled = Me.mModule.IsEditable
        Me.ApplyButton.Enabled = Me.mModule.IsEditable

        'Populate unit tree
        PopulateUnitTree()
    End Sub

    Private Sub SaveAllChanges()
        Try
            Me.Cursor = System.Windows.Forms.Cursors.WaitCursor
            'calling update on the root unit will traverse the tree calling update on
            'child units
            For Each rootNode As TreeNode In SampleUnitTreeView.Nodes
                DirectCast(rootNode.Tag, SampleUnit).Update(CurrentUser.Employee.Id)
            Next
        Catch ex As Exception
            Throw
        Finally
            Me.Cursor = System.Windows.Forms.Cursors.Default
        End Try

    End Sub

    Private Sub UpdateSelectedSampleUnitsCollection()
        Me.mSelectedSampleUnits.Clear()
        For Each node As TreeNode In Me.SampleUnitTreeView.SelectedNodes
            Me.mSelectedSampleUnits.Add(DirectCast(node.Tag, SampleUnit))
        Next
        CategorizeSections()
        ToggleAddButton()
    End Sub

    Private Sub AddMappedSections()
        Dim unitNeedsSection As Boolean = True
        For Each unit As SampleUnit In Me.mSelectedSampleUnits
            For Each row As Integer In Me.AvailableGridView.GetSelectedRows
                unitNeedsSection = True
                Dim newMapping As SampleUnitSectionMapping = DirectCast(Me.AvailableGridView.GetRow(row), SampleUnitSectionMapping).Clone
                newMapping.SampleUnitId = unit.Id
                For Each section As SampleUnitSectionMapping In unit.QuestionSections
                    If section.QuestionSectionId = newMapping.QuestionSectionId Then
                        unitNeedsSection = False
                        Exit For
                    End If
                Next
                If unitNeedsSection Then unit.QuestionSections.Add(newMapping)
            Next
        Next
        CategorizeSections()
    End Sub
    Private Sub DeleteMappedSections()
        For Each row As Integer In Me.MappedGridView.GetSelectedRows
            Dim child As SampleUnitSectionMapping = DirectCast(Me.MappedGridView.GetRow(row), SampleUnitSectionMapping)
            child.Delete()
        Next
        CategorizeSections()
    End Sub

    Private Sub ToggleAddButton()
        Me.AddMappedSectionButton.Enabled = (Me.mModule.IsEditable AndAlso Me.SampleUnitTreeView.SelectedNodes.Count > 0 AndAlso Me.AvailableGridView.SelectedRowsCount > 0)
        Me.MapContextMenuStrip.Enabled = (Me.mModule.IsEditable AndAlso Me.SampleUnitTreeView.SelectedNodes.Count > 0 AndAlso Me.AvailableGridView.SelectedRowsCount > 0)
    End Sub

    Private Sub ToggleDeleteButton()
        Me.DeleteMappedSectionButton.Enabled = (Me.mModule.IsEditable AndAlso Me.MappedGridView.SelectedRowsCount > 0)
        Me.UnMapContextMenuStrip.Enabled = (Me.mModule.IsEditable AndAlso Me.MappedGridView.SelectedRowsCount > 0)
    End Sub

    Private Sub CategorizeSections()
        If Me.mSelectedSampleUnits IsNot Nothing Then
            Me.MappedSectionsBindingSource.RaiseListChangedEvents = False
            Me.AvailableSectionsBindingSource.RaiseListChangedEvents = False

            Me.mAvailableQuestionSections.Clear()
            Me.mMappedQuestionSections.Clear()

            'Add all mapped sections from all selected units
            For Each unit As SampleUnit In Me.mSelectedSampleUnits
                For Each section As SampleUnitSectionMapping In unit.QuestionSections
                    Me.mMappedQuestionSections.Add(section)
                Next
            Next

            'Add all available sections to the available section collection
            'The next step will remove sections from the available list if already mapped to all units
            For Each section As QuestionSection In mAllQuestionSections
                Dim newMapping As SampleUnitSectionMapping = SampleUnitSectionMapping.NewSampleUnitSectionMapping(Me.mModule.Survey.Id, 0, section.Id)
                Me.mAvailableQuestionSections.Add(newMapping)
            Next

            'the first item is the section ID, the second is the count of units with that section mapped
            Dim QuestionSectionCounter As New Dictionary(Of Integer, Integer)
            For Each mappedSection As SampleUnitSectionMapping In Me.mMappedQuestionSections
                For Each availableSection As SampleUnitSectionMapping In Me.mAvailableQuestionSections
                    If mappedSection.QuestionSectionId = availableSection.QuestionSectionId Then
                        If QuestionSectionCounter.ContainsKey(mappedSection.QuestionSectionId) Then
                            QuestionSectionCounter.Item(mappedSection.QuestionSectionId) += 1
                        Else
                            QuestionSectionCounter.Add(mappedSection.QuestionSectionId, 1)
                        End If
                    End If
                Next
            Next

            'Remove each section where all units have the section
            Dim unitCount As Integer = Me.mSelectedSampleUnits.Count
            For Each sectionId As Integer In QuestionSectionCounter.Keys
                If QuestionSectionCounter.Item(sectionId) = unitCount Then
                    For Each availableSection As SampleUnitSectionMapping In Me.mAvailableQuestionSections
                        If sectionId = availableSection.QuestionSectionId Then
                            Me.mAvailableQuestionSections.Remove(availableSection)
                            Exit For
                        End If
                    Next
                End If
            Next

            Me.MappedSectionsBindingSource.RaiseListChangedEvents = True
            Me.AvailableSectionsBindingSource.RaiseListChangedEvents = True
            Me.MappedGridView.RefreshData()
            Me.AvailableGridView.RefreshData()

            'Set the first row to selected and focused
            Me.AvailableGridView.ClearSelection()
            Me.MappedGridView.ClearSelection()
            If Me.MappedGridView.RowCount > 0 Then
                Me.MappedGridView.SelectRow(0)
                Me.MappedGridView.FocusedRowHandle = 0
            End If
            If Me.AvailableGridView.RowCount > 0 Then
                Me.AvailableGridView.SelectRow(0)
                Me.AvailableGridView.FocusedRowHandle = 0
            End If
        End If
    End Sub

    Private Sub PopulateUnitTree()
        SampleUnitTreeView.BeginUpdate()
        SampleUnitTreeView.Nodes.Clear()
        For Each unit As SampleUnit In mAllSampleUnits
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
        If SampleUnitTreeView.Nodes().Count > 0 Then
            SampleUnitTreeView.SelectedNode = SampleUnitTreeView.Nodes(0)
            SampleUnitTreeView.SelectedNodes.Add(SampleUnitTreeView.Nodes(0))
            UpdateSelectedSampleUnitsCollection()
        End If
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
#End Region

End Class
