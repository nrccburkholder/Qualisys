Imports Nrc.QualiSys.Library


Public Class ModeSectionMappingEditor

#Region " Private Fields "
    Private mModule As ModeSectionMappingModule
    Private mEndConfigCallBack As EndConfigCallBackMethod
    'Integer is the sectionID
    Private mAllQuestionSections As New Collection(Of QuestionSection)
    Private mAvailableModes As New MailingStepMethodCollection
    Private mMappedQuestionSections As New List(Of ModeSectionMapping)
    Private mSelectedQuestionSection As New QuestionSection

#End Region

#Region " Constructors "
    Public Sub New(ByVal surveyModule As ModeSectionMappingModule, ByVal endConfigCallBack As EndConfigCallBackMethod)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mModule = surveyModule
        Me.mEndConfigCallBack = endConfigCallBack
    End Sub
#End Region

#Region "Event Handlers"

    Private Sub ModeSectionMappingEditor_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Initialize()
    End Sub

    Private Sub CancelButton_Click(sender As System.Object, e As System.EventArgs) Handles CancelButton.Click
        Me.mEndConfigCallBack(ConfigResultActions.None, Nothing)
        Me.mEndConfigCallBack = Nothing
    End Sub

    Private Sub OKButton_Click(sender As System.Object, e As System.EventArgs) Handles OKButton.Click
        If Not Me.mEndConfigCallBack Is Nothing Then
            SaveAllChanges()
            Me.mEndConfigCallBack(ConfigResultActions.None, Nothing)
            Me.mEndConfigCallBack = Nothing
        End If
    End Sub

    Private Sub ApplyButton_Click(sender As System.Object, e As System.EventArgs) Handles ApplyButton.Click
        SaveAllChanges()
        Initialize()
    End Sub

    Private Sub AvailableSectionsTreeView_AfterSelect(sender As System.Object, e As System.Windows.Forms.TreeViewEventArgs) Handles AvailableSectionsTreeView.AfterSelect
        'Dim idx As Integer = Me.AvailableSectionsTreeView.SelectedNodes.Count
        UpdateAvailableModesCollection()
    End Sub

    Private Sub AddMappedSectionButton_Click(sender As System.Object, e As System.EventArgs) Handles AddMappedSectionButton.Click
        UpdateMappedSectionsCollection()
    End Sub

    Private Sub DeleteMappedSectionButton_Click(sender As System.Object, e As System.EventArgs) Handles DeleteMappedSectionButton.Click
        DeleteMapping()
    End Sub

    Private Sub AvailableGridView_SelectionChanged(sender As System.Object, e As DevExpress.Data.SelectionChangedEventArgs) Handles AvailableGridView.SelectionChanged
        ToggleAddButton()
    End Sub

    Private Sub MappedGridView_SelectionChanged(sender As System.Object, e As DevExpress.Data.SelectionChangedEventArgs) Handles MappedGridView.SelectionChanged
        ToggleDeleteButton()
    End Sub


    Private Sub UnMapContextMenuStrip_Click(sender As System.Object, e As System.EventArgs) Handles UnMapContextMenuStrip.Click
        DeleteMapping()
    End Sub

    Private Sub MapContextMenuStrip_Click(sender As System.Object, e As System.EventArgs) Handles MapContextMenuStrip.Click
        UpdateMappedSectionsCollection()
    End Sub

#End Region

#Region "Private Methods"

    Private Sub Initialize()
        ' Information bar
        Me.InformationBar.Information = mModule.Information

        'Get a list of all sections for this survey
        Me.mAllQuestionSections = QuestionSection.GetBySurveyId(Me.mModule.Survey.Id)

        'Set the Binding Source for the section lookup
        Me.QuestionSectionBindingSource.DataSource = Me.mAllQuestionSections

        'Get a list of the current mapped sections
        Me.mMappedQuestionSections = ModeSectionMapping.GetModeSectionMappingsBySurveyId(Me.mModule.Survey.Id)

        'Set the Binding Source for mapped sections grid
        ' Only going to display records where [NeedsDelete] = false
        Me.MappedGridView.ActiveFilter.NonColumnFilter = "[NeedsDelete] = false"
        Me.MappedSectionsBindingSource.DataSource = mMappedQuestionSections

        'Populate unit tree
        PopulateSectionTree()

        'Disable the add and delete buttons
        Me.ToggleAddButton()
        Me.ToggleDeleteButton()

        'Don't allow save if module is not editable
        Me.OKButton.Enabled = Me.mModule.IsEditable
        Me.ApplyButton.Enabled = Me.mModule.IsEditable

    End Sub

    Private Sub PopulateSectionTree()
        AvailableSectionsTreeView.BeginUpdate()
        AvailableSectionsTreeView.Nodes.Clear()
        For Each unit As QuestionSection In mAllQuestionSections

            Dim rootNode As New TreeNode
            rootNode.Tag = unit
            rootNode.Text = unit.Label
            Me.AvailableSectionsTreeView.Nodes.Add(rootNode)

        Next
        AvailableSectionsTreeView.ExpandAll()
        AvailableSectionsTreeView.EndUpdate()
        If AvailableSectionsTreeView.Nodes().Count > 0 Then
            AvailableSectionsTreeView.Refresh()
            AvailableSectionsTreeView.SelectedNode = AvailableSectionsTreeView.Nodes(0)
            mSelectedQuestionSection = DirectCast(AvailableSectionsTreeView.SelectedNode.Tag, QuestionSection)
            UpdateAvailableModesCollection()
        End If

    End Sub

    Private Sub UpdateAvailableModesCollection()
        Me.mAvailableModes.Clear()

        mSelectedQuestionSection = DirectCast(AvailableSectionsTreeView.SelectedNode.Tag, QuestionSection)

        ' Based on the QuestionSection selected in the treeview, load the Modes that haven't been assigned to the section
        Me.mAvailableModes = MailingStepMethod.GetBySurveyID(Me.mModule.Survey.Id)

        ' check the mapped mode list and remove anything that was added
        For Each MappedSection As ModeSectionMapping In Me.mMappedQuestionSections
            If mSelectedQuestionSection.Label = MappedSection.QuestionSectionLabel Then
                For Each StepMethod As MailingStepMethod In mAvailableModes
                    If StepMethod.Id = MappedSection.MailingStepMethodId Then
                        If MappedSection.NeedsDelete = False Then
                            mAvailableModes.Remove(StepMethod)
                        End If
                        Exit For
                    End If
                Next
            End If
        Next

        AvailableMailingStepMethodsGridControl.DataSource = Me.mAvailableModes

        ToggleAddButton()
    End Sub

    Private Sub UpdateMappedSectionsCollection()

        mSelectedQuestionSection = DirectCast(AvailableSectionsTreeView.SelectedNode.Tag, QuestionSection)

        Dim SelectedStepMethod As MailingStepMethod = MailingStepMethod.NewMailingStepMethod()
        For Each row As Integer In Me.AvailableGridView.GetSelectedRows
            SelectedStepMethod = DirectCast(Me.AvailableGridView.GetRow(row), MailingStepMethod).Clone
            Dim newMapping As ModeSectionMapping = ModeSectionMapping.NewModeSectionMapping(Me.mModule.Survey.Id, 0, SelectedStepMethod.Id, SelectedStepMethod.Name, mSelectedQuestionSection.Id, mSelectedQuestionSection.Label)
            mMappedQuestionSections.Add(newMapping)
        Next
        
        'Set the Binding Source for mapped sections grid
        Me.MappedSectionsBindingSource.DataSource = mMappedQuestionSections
        Me.MappedGridView.RefreshData()

        ToggleDeleteButton()

        UpdateAvailableModesCollection()

    End Sub

    Private Sub SaveAllChanges()
        Try
            Me.Cursor = System.Windows.Forms.Cursors.WaitCursor
            'calling update on the root unit will traverse the tree calling update on
            'child units
            For Each MappedSection As ModeSectionMapping In Me.mMappedQuestionSections
                MappedSection.UpdateObj()
            Next
        Catch ex As Exception
            Throw
        Finally
            Me.Cursor = System.Windows.Forms.Cursors.Default
        End Try

    End Sub

    Private Sub ToggleAddButton()
        Me.AddMappedSectionButton.Enabled = (Me.mModule.IsEditable AndAlso Not Me.AvailableSectionsTreeView.SelectedNode Is Nothing AndAlso Me.AvailableGridView.SelectedRowsCount > 0)
        Me.MapContextMenuStrip.Enabled = (Me.mModule.IsEditable AndAlso Not Me.AvailableSectionsTreeView.SelectedNode Is Nothing AndAlso Me.AvailableGridView.SelectedRowsCount > 0)
    End Sub

    Private Sub ToggleDeleteButton()
        Me.DeleteMappedSectionButton.Enabled = (Me.mModule.IsEditable AndAlso Me.MappedGridView.SelectedRowsCount > 0)
        Me.UnMapContextMenuStrip.Enabled = (Me.mModule.IsEditable AndAlso Me.MappedGridView.SelectedRowsCount > 0)
    End Sub

    Private Sub DeleteMapping()
        For Each row As Integer In Me.MappedGridView.GetSelectedRows
            Dim child As ModeSectionMapping = DirectCast(Me.MappedGridView.GetRow(row), ModeSectionMapping)
            For idx As Integer = 0 To mMappedQuestionSections.Count - 1
                Dim ModeMapping As ModeSectionMapping = mMappedQuestionSections.Item(idx)
                If ModeMapping.MailingStepMethodName = child.MailingStepMethodName And ModeMapping.QuestionSectionLabel = child.QuestionSectionLabel Then
                    If ModeMapping.IsNew = False Then
                        ' If this is an existing MappedQuestion, then flag it for deletion
                        ModeMapping.NeedsDelete = True
                    Else
                        'otherwise, just remove it from the list
                        mMappedQuestionSections.RemoveAt(idx)
                    End If
                    Exit For
                End If
            Next
        Next
        Me.MappedSectionsBindingSource.DataSource = mMappedQuestionSections
        Me.MappedGridView.RefreshData()
        UpdateAvailableModesCollection()
    End Sub

#End Region


  
End Class
