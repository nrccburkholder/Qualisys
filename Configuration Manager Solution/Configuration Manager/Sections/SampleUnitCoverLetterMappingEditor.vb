Imports Nrc.QualiSys.Library
Imports DevExpress.XtraTreeList.Nodes
Imports DevExpress.XtraTreeList.Columns
Imports DevExpress.XtraGrid.Views.Base
Imports DevExpress.XtraGrid.Views.Base.ViewInfo
Imports DevExpress.XtraGrid.Views.Grid.ViewInfo
Imports System.Text.RegularExpressions
Imports DevExpress.Utils
Imports DevExpress.XtraGrid.Views.Grid
Imports DevExpress.XtraGrid.Columns
Imports System.Windows.Forms


Public Class SampleUnitCoverLetterMappingEditor


#Region " Private Fields "
    Private mModule As SampleUnitCoverLetterMappingModule
    Private mEndConfigCallBack As EndConfigCallBackMethod
    Private mCoverLetterList As New Collection(Of CoverLetter)
    Private mArtifactList As New Collection(Of CoverLetter)
    Private mMappings As New List(Of CoverLetterMapping)
    Private mDuplicateMappings As New List(Of CoverLetterMapping)
    Private mMisMatchedArtifacts As New List(Of CoverLetterMapping)
    Private mAllSampleUnits As Collection(Of SampleUnit)
    Private newRepositoryItem As New DevExpress.XtraEditors.Repository.RepositoryItem
    Private IsShowingDiscreteMappingElements As Boolean = False
#End Region

#Region " Constructors "
    Public Sub New(ByVal surveyModule As SampleUnitCoverLetterMappingModule, ByVal endConfigCallBack As EndConfigCallBackMethod)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.

        AddHandler Application.Idle, AddressOf IdleEvent

        mModule = surveyModule
        Me.mEndConfigCallBack = endConfigCallBack
    End Sub
#End Region

#Region "event handlers"

    Private Sub gvCoverLetters_CustomDrawCell(sender As Object, e As DevExpress.XtraGrid.Views.Base.RowCellCustomDrawEventArgs) Handles gvCoverLetters.CustomDrawCell, gvArtifacts.CustomDrawCell

        '  Nothing is really happening here.  It was just something I was playing around with.
        '  The intent was to change the backcolor of the selected row in the Cover Letters and Artifacts grids if the status was set to Selected.
        '  It works, but probably is more trouble than it's worth.  Keeping the code for future use, perhaps.

        'Dim gv As GridView = DirectCast(sender, GridView)

        '' need this here otherwise the grid blows up and the application closes.
        'If e.RowHandle = DevExpress.XtraGrid.GridControl.AutoFilterRowHandle Then
        '
        '    Exit Sub
        'End If

        'Dim status As CoverLetterMappingStatusCodes = DirectCast(gv.GetRowCellValue(e.RowHandle, "Status"), CoverLetterMappingStatusCodes)

        'Select Case status
        '    Case CoverLetterMappingStatusCodes.None Or CoverLetterMappingStatusCodes.Selected
        '        e.Appearance.BackColor = Color.LimeGreen
        '        e.Appearance.Font = New Font(e.Appearance.Font, e.Appearance.Font.Style Or FontStyle.Italic)
        '    Case Else
        '        e.Appearance.ForeColor = Color.Black
        '        e.Appearance.Font = New Font(e.Appearance.Font, e.Appearance.Font.Style Or FontStyle.Regular)
        'End Select

    End Sub

    Private Sub gvMappings_ShowGridMenu(sender As Object, e As DevExpress.XtraGrid.Views.Grid.GridMenuEventArgs) Handles gvMappings.ShowGridMenu

        Dim View As GridView = CType(sender, GridView)

        Dim hitInfo As GridHitInfo

        hitInfo = View.CalcHitInfo(e.Point)

        If hitInfo.InRow And View.GetSelectedRows.Length > 0 Then



            View.FocusedRowHandle = hitInfo.RowHandle

            ContextMenuStrip1.Items.Clear()

            If hitInfo.RowHandle = DevExpress.XtraGrid.GridControl.AutoFilterRowHandle Then
                Exit Sub
            End If

            Dim col As GridColumn = hitInfo.Column

            ' If col IsNot Nothing Then

            'If col.FieldName = "Image" Then

            Dim status As CoverLetterMappingStatusCodes = DirectCast(gvMappings.GetRowCellValue(hitInfo.RowHandle, "Status"), CoverLetterMappingStatusCodes)
            Dim tipText As String = String.Empty
            Dim o As Object = hitInfo.HitTest.ToString() + hitInfo.RowHandle.ToString()
            Select Case status
                Case CoverLetterMappingStatusCodes.NeedsDelete
                    Dim CancelDeleteSubMenuItem As New ToolStripMenuItem
                    CancelDeleteSubMenuItem.Name = "CancelDelete_" & hitInfo.RowHandle.ToString()
                    CancelDeleteSubMenuItem.Text = "Cancel Delete"
                    CancelDeleteSubMenuItem.Tag = hitInfo.RowHandle.ToString()
                    AddHandler (CancelDeleteSubMenuItem.Click), AddressOf MyUndeleteContextMenu_Click
                    ContextMenuStrip1.Items.Add(CancelDeleteSubMenuItem)
                Case Else
                    Dim UnMapSubMenuItem As New ToolStripMenuItem
                    UnMapSubMenuItem.Name = "UnMap_" & hitInfo.RowHandle.ToString()
                    UnMapSubMenuItem.Text = "UnMap"
                    UnMapSubMenuItem.Tag = hitInfo.RowHandle.ToString()
                    AddHandler (UnMapSubMenuItem.Click), AddressOf MyUnMapContextMenu_Click
                    ContextMenuStrip1.Items.Add(UnMapSubMenuItem)
            End Select

            Dim ShowElementsSubMenuItem As New ToolStripMenuItem
            ShowElementsSubMenuItem.Name = "ShowElements_" & hitInfo.RowHandle.ToString()
            ShowElementsSubMenuItem.Text = "Show Mapped Elements"
            ShowElementsSubMenuItem.Tag = hitInfo.RowHandle.ToString()
            AddHandler (ShowElementsSubMenuItem.Click), AddressOf ShowElementsOfMapping_Click
            ContextMenuStrip1.Items.Add(ShowElementsSubMenuItem)
            'End If
            'End If

            ContextMenuStrip1.Show(View.GridControl, e.Point)
        End If

    End Sub

    Private Sub MyUnMapContextMenu_Click(sender As System.Object, e As System.EventArgs)
        DeleteMapping()
    End Sub

    Private Sub MyUndeleteContextMenu_Click(sender As System.Object, e As System.EventArgs)

        Dim mySubMenuItem As ToolStripMenuItem = DirectCast(sender, ToolStripMenuItem)
        Dim mapping As CoverLetterMapping = DirectCast(gvMappings.GetRow(CInt(mySubMenuItem.Tag)), CoverLetterMapping)
        UndoDelete(mapping)

    End Sub

    Private Sub ShowElementsOfMapping_Click(sender As System.Object, e As System.EventArgs)

        IsShowingDiscreteMappingElements = True

        Dim mySubMenuItem As ToolStripMenuItem = DirectCast(sender, ToolStripMenuItem)
        Dim mapping As CoverLetterMapping = DirectCast(gvMappings.GetRow(CInt(mySubMenuItem.Tag)), CoverLetterMapping)

        HighlightMappingElements(mapping)

        IsShowingDiscreteMappingElements = False

    End Sub

    Private Sub ToolTipController1_GetActiveObjectInfo(sender As System.Object, e As DevExpress.Utils.ToolTipControllerGetActiveObjectInfoEventArgs) Handles ToolTipController1.GetActiveObjectInfo
        If Not e.SelectedControl Is gcMappings Then Return

        Dim info As ToolTipControlInfo = Nothing
        'Get the view at the current mouse position
        Dim view As GridView = CType(gcMappings.GetViewAt(e.ControlMousePosition), GridView)
        If view Is Nothing Then Return
        'Get the view's element information that resides at the current position
        Dim hitInfo As GridHitInfo = view.CalcHitInfo(e.ControlMousePosition)
        'Display a hint for row indicator cells

        If hitInfo.InRow Then

            If hitInfo.RowHandle = DevExpress.XtraGrid.GridControl.AutoFilterRowHandle Then
                Exit Sub
            End If

            Dim col As GridColumn = hitInfo.Column

            If col IsNot Nothing Then

                If col.FieldName = "Image" Then
                    Dim status As CoverLetterMappingStatusCodes = DirectCast(gvMappings.GetRowCellValue(hitInfo.RowHandle, "Status"), CoverLetterMappingStatusCodes)
                    Dim tipText As String = String.Empty
                    Dim o As Object = hitInfo.HitTest.ToString() + hitInfo.RowHandle.ToString()
                    Select Case status
                        Case CoverLetterMappingStatusCodes.None
                            tipText = "OK"
                            info = New ToolTipControlInfo(o, tipText)
                        Case (CoverLetterMappingStatusCodes.IsNew)
                            tipText = "New"
                            info = New ToolTipControlInfo(o, tipText)
                        Case CoverLetterMappingStatusCodes.Duplicate
                            tipText = "Duplicate Mapping"
                            info = New ToolTipControlInfo(o, tipText)
                        Case CoverLetterMappingStatusCodes.NeedsDelete
                            tipText = "Flagged for Deletion"
                            info = New ToolTipControlInfo(o, tipText)
                    End Select

                End If
            End If

        End If

        'Supply tooltip information if applicable, otherwise preserve default tooltip (if any)
        If Not info Is Nothing Then e.Info = info
    End Sub

    Private Sub gvMappings_CustomRowCellEdit(sender As Object, e As DevExpress.XtraGrid.Views.Grid.CustomRowCellEditEventArgs) Handles gvMappings.CustomRowCellEdit
        If gvMappings.IsFilterRow(e.RowHandle) AndAlso e.Column.FieldName = "Image" Then
            e.RepositoryItem = newRepositoryItem
        End If
    End Sub

    Private Sub tsbtnExportToExcel_Click(sender As System.Object, e As System.EventArgs) Handles tsbtnExportToExcel.Click
        ExportMappingsToExcel()
    End Sub

    Private Sub UnMapContextMenu_Click(sender As System.Object, e As System.EventArgs)
        DeleteMapping()
    End Sub

    Private Sub gvMappings_CustomDrawCell(sender As Object, e As DevExpress.XtraGrid.Views.Base.RowCellCustomDrawEventArgs) Handles gvMappings.CustomDrawCell

        ' need this here otherwise the grid blows up and the application closes.
        If e.RowHandle = DevExpress.XtraGrid.GridControl.AutoFilterRowHandle Then
            Exit Sub
        End If

        If e.Column.Name <> "colStatusImage" Then

            Dim status As CoverLetterMappingStatusCodes = DirectCast(gvMappings.GetRowCellValue(e.RowHandle, "Status"), CoverLetterMappingStatusCodes)

            Select Case status
                Case CoverLetterMappingStatusCodes.NeedsDelete
                    e.Appearance.Font = New Font(e.Appearance.Font, e.Appearance.Font.Style Or FontStyle.Strikeout)
                Case Else
                    e.Appearance.Font = New Font(e.Appearance.Font, e.Appearance.Font.Style Or FontStyle.Regular)
            End Select

        End If
    End Sub

    Private Sub gvMappings_CustomUnboundColumnData(sender As Object, e As DevExpress.XtraGrid.Views.Base.CustomColumnDataEventArgs) Handles gvMappings.CustomUnboundColumnData

        If String.Compare(e.Column.Name, "colStatusImage", False) = 0 AndAlso e.IsGetData Then

            Dim status As CoverLetterMappingStatusCodes = DirectCast(gvMappings.GetRowCellValue(e.RowHandle, "Status"), CoverLetterMappingStatusCodes)

            Select Case status
                Case CoverLetterMappingStatusCodes.None And CoverLetterMappingStatusCodes.Selected
                    e.Value = My.Resources.Validation16
                Case CoverLetterMappingStatusCodes.IsNew
                    e.Value = My.Resources.New16
                Case CoverLetterMappingStatusCodes.Duplicate
                    e.Value = My.Resources.Caution16
                Case CoverLetterMappingStatusCodes.NeedsDelete
                    e.Value = My.Resources.DeleteRed16
                Case CoverLetterMappingStatusCodes.None Or CoverLetterMappingStatusCodes.Selected
                    e.Value = My.Resources.Validation16
                Case CoverLetterMappingStatusCodes.IsNew Or CoverLetterMappingStatusCodes.Selected
                    e.Value = My.Resources.New16
                Case CoverLetterMappingStatusCodes.NeedsDelete Or CoverLetterMappingStatusCodes.Selected
                    e.Value = My.Resources.DeleteRed16
            End Select

        End If
    End Sub

    Private Sub btnUnselectAllMappings_Click(sender As System.Object, e As System.EventArgs) Handles btnUnselectAllMappings.Click
        gvMappings.ClearSelection()
    End Sub

    Private Sub btnUnmap_Click(sender As System.Object, e As System.EventArgs) Handles btnUnmap.Click
        DeleteMapping()
    End Sub

    Private Sub btnSelectAllMappings_Click(sender As System.Object, e As System.EventArgs) Handles btnSelectAllMappings.Click
        gvMappings.SelectAll()
    End Sub

    Private Sub SampleUnitTreeView_BeforeFocusNode(sender As Object, e As DevExpress.XtraTreeList.BeforeFocusNodeEventArgs) Handles SampleUnitTreeView.BeforeFocusNode
        'If e.Node IsNot Nothing Then
        '    If e.Node.ParentNode Is Nothing Then
        '        e.CanFocus = False ' prevents the root node from being selected
        '    End If
        'End If

    End Sub

    Private Sub SampleUnitTreeView_SelectionChanged(sender As System.Object, e As System.EventArgs) Handles SampleUnitTreeView.SelectionChanged
        UpdateMappingsFilter()
    End Sub

    Private Sub btnSampleUnitsClearSelections_Click(sender As Object, e As System.EventArgs) Handles btnSampleUnitsClearSelections.Click
        SampleUnitTreeView.Selection.Clear()
        UpdateMappingsFilter()
    End Sub

    Private Sub btnArtifactsClearSelections_Click(sender As System.Object, e As System.EventArgs) Handles btnArtifactsClearSelections.Click
        gvArtifacts.ClearSelection()
    End Sub

    Private Sub btnCoverLettersClearnSelections_Click(sender As System.Object, e As System.EventArgs) Handles btnCoverLettersClearnSelections.Click
        gvCoverLetters.ClearSelection()
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
        PopulateMappings()
    End Sub

    Private Sub btnShowAllMappings_Click(sender As System.Object, e As System.EventArgs) Handles btnShowAllMappings.Click
        ShowAllMappings()
    End Sub

    Public Sub IdleEvent(ByVal sender As System.Object, ByVal e As System.EventArgs)

        Dim isRootNodeSelected As Boolean = SampleUnitTreeView.Nodes(0).Selected

        ' only map if there is a sample unit, cover letter and artifact selected, unless the sample unit is the root.  Then the map button will be disabled.
        btnMap.Enabled = SampleUnitTreeView.Selection.Count > 0 And gvCoverLetters.SelectedRowsCount > 0 And gvArtifacts.SelectedRowsCount > 0 And Not isRootNodeSelected

        btnUnmap.Enabled = gvMappings.SelectedRowsCount > 0

        'Don't allow save unless all mappings are valid (that is, they are not duplicates)
        ApplyButton.Enabled = IsValidMappings() And mModule.IsEditable
        OKButton.Enabled = IsValidMappings() And mModule.IsEditable

        Dim pos As Integer = gvMappings.ActiveFilter.NonColumnFilter.IndexOf("[SampleUnit_Id]")
        If pos >= 0 Then
            ToolStripStatusLabel1.Text = gvMappings.ActiveFilter.NonColumnFilter.Substring(pos)
        Else
            ToolStripStatusLabel1.Text = "Showing All"
        End If

    End Sub

    Private Sub SampleUnitCoverLetterMappingEditor_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Initialize()
    End Sub

    Private Sub CancelButton_Click(sender As System.Object, e As System.EventArgs) Handles CancelButton.Click

        CancelForm()

    End Sub

    Private Sub btnMap_Click(sender As System.Object, e As System.EventArgs) Handles btnMap.Click
        MapSampleUnits()
    End Sub
#End Region

#Region "private methods"

    Private Sub Initialize()

        ' Information bar
        InformationBar.Information = mModule.Information

        'Get a list of all sampleunits for this survey
        mAllSampleUnits = SampleUnit.GetSampleUnitsBySurveyId(Me.mModule.Survey)

        'Get a list of all the coverletters for this survey
        mCoverLetterList = CoverLetter.GetBySurveyIdAndPageType(Me.mModule.Survey.Id, CoverLetterPageType.CoverLetter)
        CoverLetterBindingSource.DataSource = GetCoverLetters(mCoverLetterList)

        'Get a list of all the artifacts for this survey
        mArtifactList = CoverLetter.GetBySurveyIdAndPageType(Me.mModule.Survey.Id, CoverLetterPageType.Artifact)
        ArtifactBindingSource.DataSource = GetCoverLetters(mArtifactList)

        PopulateUnitTree()

        PopulateMappings()

        'Don't allow save if module is not editable
        SplitContainerMainView.Enabled = mModule.IsEditable
        OKButton.Enabled = mModule.IsEditable
        ApplyButton.Enabled = mModule.IsEditable

        'SampleUnitTreeView.Selection.Clear()

    End Sub

    Private Sub PopulateMappings()
        'Get a list of the current mapped sections
        mMappings.Clear()
        mMappings = CoverLetterMapping.GetCoverLetterMappingsBySurveyId(Me.mModule.Survey.Id)
        'Set the binding source for the sampleunit lookup
        gcMappings.DataSource = mMappings
        gvMappings.ClearSelection()

    End Sub

    Private Sub PopulateUnitTree()
        SampleUnitTreeView.BeginUpdate()
        SampleUnitTreeView.Nodes.Clear()

        For Each unit As SampleUnit In mAllSampleUnits
            If unit.NeedsDelete Then Continue For
            'Detemine the root unit
            If unit.ParentUnit Is Nothing Then
                Dim parentForRootNodes As TreeListNode = Nothing
                Dim rootNode As TreeListNode = SampleUnitTreeView.AppendNode(New Object() {unit.DisplayLabel, unit.CAHPSTypeName}, parentForRootNodes)
                rootNode.Tag = unit
                PopulateChildTreeNodes(rootNode)
            End If
        Next
        SampleUnitTreeView.ExpandAll()
        SampleUnitTreeView.EndUpdate()
        'If SampleUnitTreeView.Nodes().Count > 0 Then
        '    UpdateMappingsFilter()
        'End If

    End Sub

    Private Sub PopulateChildTreeNodes(ByVal parentTreeNode As TreeListNode)
        If (parentTreeNode Is Nothing) Then Return
        Dim parentUnit As SampleUnit = TryCast(parentTreeNode.Tag, SampleUnit)
        If (parentUnit Is Nothing OrElse parentUnit.ChildUnits Is Nothing) Then Return

        For Each unit As SampleUnit In parentUnit.ChildUnits
            If unit.NeedsDelete Then Continue For
            Dim childNode As TreeListNode = SampleUnitTreeView.AppendNode(New Object() {unit.DisplayLabel, unit.CAHPSTypeName}, parentTreeNode)
            childNode.Tag = unit

            Me.PopulateChildTreeNodes(childNode)
        Next
    End Sub

    Private Sub UpdateMappingsFilter()
        'Me.mSelectedSampleUnits.Clear()

        If IsShowingDiscreteMappingElements Then
            Exit Sub
        End If

        Dim criteriaString As String = String.Empty
        Dim inList As String = String.Empty


        ' if there are multiple selections, but one of the selections is the root, unselect the root
        If SampleUnitTreeView.Selection.Count > 1 Then
            If SampleUnitTreeView.Nodes(0).Selected Then SampleUnitTreeView.Nodes(0).Selected = False
        End If

        For Each node As TreeListNode In Me.SampleUnitTreeView.Selection
            If Not node.ParentNode Is Nothing Then  ' this will exclude the root node
                Dim sunit As SampleUnit = DirectCast(node.Tag, SampleUnit)
                If sunit IsNot Nothing Then
                    inList = String.Concat(inList, sunit.Id.ToString(), ",")
                End If
            End If
        Next

        If Not inList.Equals(String.Empty) Then
            ' remove the last comma from the IN statement
            inList = inList.Substring(0, inList.Length - 1)
            'criteriaString = String.Format(" AND [SampleUnit_Id] IN ({0})", inList)
            criteriaString = String.Format("[SampleUnit_Id] IN ({0})", inList)
        End If

        'gvMappings.ActiveFilter.NonColumnFilter = "[NeedsDelete] = false" & criteriaString
        gvMappings.ActiveFilter.NonColumnFilter = criteriaString
        '
    End Sub

    Private Function GetCoverLetters(ByVal coverLetters As Collection(Of CoverLetter)) As List(Of MyCoverLetter)

        Dim coverLetterList As New List(Of MyCoverLetter)

        ' Need to flatten out the data to display it in the gridcontrol
        For Each cletter As CoverLetter In coverLetters
            Dim coverLetterName As String = cletter.Name
            Dim coverLetterID As Integer = cletter.Id
            If Not cletter.Items Is Nothing Then
                For Each item As CoverLetterItem In cletter.Items
                    Dim label As String = item.Label
                    coverLetterList.Add(New MyCoverLetter(cletter.Survey_Id, coverLetterName, item.Label, item.ItemType))
                Next
            End If
        Next

        Return coverLetterList

    End Function

    Private Sub MapSampleUnits()

        mDuplicateMappings.Clear()
        mMisMatchedArtifacts.Clear()

        If SampleUnitTreeView.Selection.Count > 0 And gvCoverLetters.SelectedRowsCount > 0 And gvArtifacts.SelectedRowsCount > 0 Then

            For Each node As TreeListNode In SampleUnitTreeView.Selection
                Dim sUnit As SampleUnit = DirectCast(node.Tag, SampleUnit)
                Dim sampleUnitName As String = sUnit.SampleUnitName

                For Each rowHandle As Integer In gvCoverLetters.GetSelectedRows()

                    Dim coverLetter_Name As String = gvCoverLetters.GetRowCellValue(rowHandle, "CoverLetterName").ToString().Trim()
                    Dim coverLetter_label As String = gvCoverLetters.GetRowCellValue(rowHandle, "Label").ToString().Trim()
                    Dim coverLetterItemType As Integer = CInt(gvCoverLetters.GetRowCellValue(rowHandle, "ItemType"))

                    Dim artifact_name As String = gvArtifacts.GetRowCellValue(gvArtifacts.FocusedRowHandle, "CoverLetterName").ToString().Trim()
                    Dim artifact_label As String = gvArtifacts.GetRowCellValue(gvArtifacts.FocusedRowHandle, "Label").ToString().Trim()
                    Dim artifactItemType As Integer = CInt(gvArtifacts.GetRowCellValue(rowHandle, "ItemType"))

                    Dim mappedUnit As CoverLetterMapping = CoverLetterMapping.NewCoverLetterMapping(-1, Me.mModule.Survey.Id, sUnit.Id, sampleUnitName, coverLetterItemType, coverLetter_Name, coverLetter_label, artifact_name, artifact_label)

                    ' check to see if this mapping already exists
                    If Not HasMappingErrors(mappedUnit) Then 'CheckForDuplicates(mappedUnit) Or ValidateAncestors(mappedUnit) Or ValidateDescendants(mappedUnit) Then         
                        mappedUnit.Status = CoverLetterMappingStatusCodes.IsNew
                        mMappings.Add(mappedUnit)
                    End If
                    'mMappings.Add(mappedUnit)
                Next
            Next

            RefreshMappingDataSource()
            gvMappings.ClearSelection()

            If mDuplicateMappings.Count > 0 Or mMisMatchedArtifacts.Count > 0 Then

                Dim msg As String = String.Format("{0}{1}{2}", "INVALID COVER LETTER MAPPING!", vbCrLf, vbCrLf)

                For Each dup As CoverLetterMapping In mDuplicateMappings
                    msg = String.Format("{0}{1} DUPLICATE:  {2} - {3}.{4}{5}", msg, Chr(149), dup.SampleUnit_name, dup.CoverLetter_name, dup.CoverLetterItem_label, vbCrLf)
                Next

                For Each dup As CoverLetterMapping In mMisMatchedArtifacts
                    msg = String.Format("{0}{1} MISMATCH:   {2} - {3}.{4}{5}", msg, Chr(149), dup.SampleUnit_name, dup.CoverLetter_name, dup.CoverLetterItem_label, vbCrLf)
                Next

                MessageBox.Show(msg, "Cover Letter Mapping Error", MessageBoxButtons.OK, MessageBoxIcon.Error)

                'highlight the duplicates
                For i As Integer = 0 To gvMappings.RowCount - 1
                    For Each dup As CoverLetterMapping In mDuplicateMappings
                        Dim uid As String = gvMappings.GetRowCellValue(i, UniqueID).ToString()
                        If uid = dup.UniqueID.ToString() Then
                            gvMappings.SelectRow(i)
                        End If
                    Next
                Next

            End If

        End If
    End Sub

    Private Sub DeleteMapping()

        ' this method starts from the bottom of the grid and list and works its way up to avoid index out of range errors
        For i As Integer = gvMappings.SelectedRowsCount - 1 To 0 Step -1
            If gvMappings.GetSelectedRows()(i) >= 0 Then
                Dim item As CoverLetterMapping = DirectCast(gvMappings.GetRow(gvMappings.GetSelectedRows()(i)), CoverLetterMapping)
                For idx As Integer = mMappings.Count - 1 To 0 Step -1
                    Dim mappedItem As CoverLetterMapping = mMappings.Item(idx)
                    If mappedItem.UniqueID = item.UniqueID Then
                        If mappedItem.IsNew = False Then
                            ' If this is an existing MappedQuestion, then flag it for deletion
                            mappedItem.NeedsDelete = True
                            mappedItem.Status = CoverLetterMappingStatusCodes.NeedsDelete
                            'ResetDuplicate(mappedItem)
                        Else
                            'otherwise, just remove it from the list
                            'ResetDuplicate(mappedItem)
                            mMappings.RemoveAt(idx)
                        End If
                        Exit For
                    End If
                Next
            End If
        Next

        RefreshMappingDataSource()
        UpdateMappingsFilter()
        gvMappings.ClearSelection()

    End Sub

    Private Sub ShowAllMappings()
        'gvMappings.ActiveFilter.NonColumnFilter = ""
        SampleUnitTreeView.Selection.Clear()
        SampleUnitTreeView.SetFocusedNode(SampleUnitTreeView.Nodes(0))
        gvMappings.ClearSelection()
        ' Sets focus on MappedGridView control to the filter box at the top
        gvMappings.FocusedRowHandle = DevExpress.XtraGrid.GridControl.AutoFilterRowHandle
    End Sub

    Private Sub SaveAllChanges()
        Try
            Me.Cursor = System.Windows.Forms.Cursors.WaitCursor
            For Each MappedItem As CoverLetterMapping In mMappings
                MappedItem.UpdateObj()
            Next
        Catch ex As Exception
            Throw
        Finally
            Me.Cursor = System.Windows.Forms.Cursors.Default
        End Try

    End Sub

#Region "mapping validation methods"

    Private Function HasMappingErrors(ByVal unit As CoverLetterMapping) As Boolean
        Return CheckForDuplicates(unit) Or ValidateAncestors(unit) Or ValidateDescendants(unit)
    End Function

    Private Function CheckForDuplicates(ByVal unit As CoverLetterMapping) As Boolean
        ' return false if mapping does not match a current mapping, true if it matches
        Dim result As Boolean = False

        For Each mapping As CoverLetterMapping In mMappings
            If Not mapping.NeedsDelete Then ' ignore mappings that have already been marked as NeedsDelete
                If mapping.HasMatchingCoverLetterItems(unit) Then
                    'If mapping.IsNew Then
                    '    mapping.Status = CoverLetterMappingStatusCodes.IsNew_Duplicate
                    'Else
                    '    mapping.Status = CoverLetterMappingStatusCodes.Duplicate
                    'End If
                    mDuplicateMappings.Add(mapping)
                    result = True
                End If
            End If
        Next
        Return result
    End Function

    Private Function ValidateAncestors(ByVal unit As CoverLetterMapping) As Boolean

        ' this looks at the parents of the node that we are mapping

        Dim sampleUnit_name As String = unit.SampleUnit_name

        ' get the node with this sampleunit name
        Dim node As TreeListNode = TraverseTheTree(SampleUnitTreeView.Nodes, sampleUnit_name)

        ' now we check the parent nodes
        Return CheckParentNodeForMismatchedArtifacts(node.ParentNode, unit)

    End Function

    Private Function CheckParentNodeForMismatchedArtifacts(ByVal node As TreeListNode, ByVal unit As CoverLetterMapping) As Boolean

        Dim result As Boolean = False
        ' now get the node's parent 
        If node IsNot Nothing Then

            If node.Level = 0 Then
                Return False
            End If

            Dim sunit As SampleUnit = DirectCast(node.Tag, SampleUnit)

            Dim mappedUnit As CoverLetterMapping = CoverLetterMapping.NewCoverLetterMapping(-1, Me.mModule.Survey.Id, sunit.Id, sunit.SampleUnitName, unit.CoverLetterItemType_Id, unit.CoverLetter_name, unit.CoverLetterItem_label, unit.Artifact_name, unit.ArtifactItem_label)

            For Each mapping As CoverLetterMapping In mMappings
                If Not mapping.NeedsDelete Then ' ignore mappings that have already been marked as NeedsDelete
                    If mapping.HasMismatchedArtifactItems(unit) Then
                        mMisMatchedArtifacts.Add(mapping)
                        result = True
                    Else
                        result = CheckParentNodeForMismatchedArtifacts(node.ParentNode, unit)
                    End If
                End If
            Next

        End If

        Return result

    End Function

    Private Function ValidateDescendants(ByVal unit As CoverLetterMapping) As Boolean

        ' this looks at the children of the node we are mapping

        Dim sampleUnit_name As String = unit.SampleUnit_name

        ' get the node for the sample unit because that's where we will start checking for Mismatches
        Dim node As TreeListNode = TraverseTheTree(SampleUnitTreeView.Nodes, sampleUnit_name)

        Return CheckChildNodeForMismatchedArtifacts(node, unit)

    End Function

    Private Function CheckChildNodeForMismatchedArtifacts(ByVal node As TreeListNode, ByVal unit As CoverLetterMapping) As Boolean

        Dim result As Boolean = False

        If node IsNot Nothing Then
            If node.HasChildren Then
                For Each childNode As TreeListNode In node.Nodes
                    Dim sunit As SampleUnit = DirectCast(childNode.Tag, SampleUnit)
                    Dim mappedUnit As CoverLetterMapping = CoverLetterMapping.NewCoverLetterMapping(-1, Me.mModule.Survey.Id, sunit.Id, sunit.SampleUnitName, unit.CoverLetterItemType_Id, unit.CoverLetter_name, unit.CoverLetterItem_label, unit.Artifact_name, unit.ArtifactItem_label)
                    For Each mapping As CoverLetterMapping In mMappings
                        If Not mapping.NeedsDelete Then ' ignore mappings that have already been marked as NeedsDelete
                            ' find the sampleunit node for this mapping
                            Dim sampleUnitNode As TreeListNode = TraverseTheTree(SampleUnitTreeView.Nodes, mapping.SampleUnit_name)
                            ' We don't care about mappings whose sample unit isn't on the same branch of the tree 
                            If sampleUnitNode.ParentNode.Id = childNode.ParentNode.Id Then
                                If mapping.HasMismatchedArtifactItems(unit) Then
                                    mMisMatchedArtifacts.Add(mapping)
                                    result = True
                                Else
                                    result = CheckChildNodeForMismatchedArtifacts(childNode, unit)
                                End If
                            End If
                        End If
                    Next
                Next
            End If
        End If

        Return result

    End Function

#End Region

    Private Function IsValidMappings() As Boolean

        Dim result As Boolean = True

        For Each MappedItem As CoverLetterMapping In mMappings

            If MappedItem.Status = CoverLetterMappingStatusCodes.Duplicate Then 'Or MappedItem.Status = CoverLetterMappingStatusCodes.IsNew_Duplicate Then
                result = False
                Exit For
            End If

        Next

        Return result

    End Function

    Private Function HasUnsavedChanges() As Boolean
        Dim result As Boolean = False

        For Each MappedItem As CoverLetterMapping In mMappings

            If (MappedItem.NeedsDelete And MappedItem.IsNew = False) Or (MappedItem.IsNew And MappedItem.NeedsDelete = False) Then
                result = True
                Exit For
            End If
        Next

        Return result
    End Function

    Private Sub CancelForm()

        If HasUnsavedChanges() Then

            If MessageBox.Show("Exit without saving changes?", "Cover Letter Mapping", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.No Then
                Exit Sub
            End If
        End If

        Me.mEndConfigCallBack(ConfigResultActions.None, Nothing)
        Me.mEndConfigCallBack = Nothing
    End Sub

    Private Sub ExportMappingsToExcel()
        If SaveFileDialog1.ShowDialog = DialogResult.OK Then
            gvMappings.ExportToXlsx(SaveFileDialog1.FileName)
        End If
    End Sub

    Private Function TraverseTheTree(ByVal nodes As TreeListNodes, ByVal sampleUnitName As String) As TreeListNode
        For Each node As TreeListNode In nodes
            Dim name As String = DirectCast(node.Tag, SampleUnit).Name
            If name = sampleUnitName Then
                Return node
            Else
                If node.HasChildren Then
                    Return TraverseTheTree(node.Nodes, sampleUnitName)
                End If
            End If
        Next
        Return Nothing
    End Function

    Private Sub SelectSampleUnitNodeByName(ByVal nodes As TreeListNodes, ByVal sampleUnitName As String)
        For Each node As TreeListNode In nodes
            Dim name As String = DirectCast(node.Tag, SampleUnit).Name
            If name = sampleUnitName Then
                node.Selected = True
            Else
                If node.HasChildren Then
                    SelectSampleUnitNodeByName(node.Nodes, sampleUnitName)
                End If
            End If
        Next
    End Sub

    Private Sub UndoDelete(ByVal mapping As CoverLetterMapping)
        mapping.NeedsDelete = False
        mapping.Status = CoverLetterMappingStatusCodes.None
        RefreshMappingDataSource()
        gvMappings.ClearSelection()
    End Sub

    Private Sub RefreshMappingDataSource()
        gcMappings.DataSource = mMappings
        gcMappings.RefreshDataSource()
    End Sub

    Private Sub HighlightMappingElements(ByVal mapping As CoverLetterMapping)

        ' Select the Sample Unit node in the tree
        SampleUnitTreeView.Selection.Clear()
        Dim sampleUnit_name As String = mapping.SampleUnit_name
        SelectSampleUnitNodeByName(SampleUnitTreeView.Nodes, sampleUnit_name)

        'Select Cover Letter record
        gvCoverLetters.ClearSelection()
        Dim CoverLetter_Name As String = mapping.CoverLetter_name.Trim
        Dim CoverLetter_Label As String = mapping.CoverLetterItem_label.Trim

        For i As Integer = 0 To gvCoverLetters.RowCount - 1
            Dim cl As MyCoverLetter = DirectCast(gvCoverLetters.GetRow(i), MyCoverLetter)
            If cl.CoverLetterName.Trim = CoverLetter_Name And cl.Label.Trim = CoverLetter_Label Then
                gvCoverLetters.SelectRow(i)
                Exit For
                '    'cl.Status = CoverLetterMappingStatusCodes.None Or CoverLetterMappingStatusCodes.Selected
                'Else
                '    'cl.Status = CoverLetterMappingStatusCodes.None
            End If
        Next

        'Select Artifact record
        gvArtifacts.ClearSelection()
        Dim Artifact_Name As String = mapping.Artifact_name.Trim
        Dim Artifact_Label As String = mapping.ArtifactItem_label.Trim

        For i As Integer = 0 To gvArtifacts.RowCount - 1
            Dim cl As MyCoverLetter = DirectCast(gvArtifacts.GetRow(i), MyCoverLetter)
            If cl.CoverLetterName.Trim = Artifact_Name And cl.Label.Trim = Artifact_Label Then
                gvArtifacts.FocusedRowHandle = i
                Exit For
                '    'cl.Status = CoverLetterMappingStatusCodes.None Or CoverLetterMappingStatusCodes.Selected
                'Else
                '    'cl.Status = CoverLetterMappingStatusCodes.None
            End If

        Next
    End Sub
#End Region
End Class

Friend Class MyCoverLetter

    Private mSurvey_id As Integer
    Private mCoverLetterName As String
    Private mLabel As String
    Private mStatus As Integer = CoverLetterMappingStatusCodes.None
    Private mItemType As Integer


    Public Property Survey_Id As Integer
        Get
            Return mSurvey_id
        End Get
        Set(value As Integer)
            mSurvey_id = value
        End Set
    End Property


    Public Property CoverLetterName As String
        Get
            Return mCoverLetterName
        End Get
        Set(value As String)
            mCoverLetterName = value
        End Set
    End Property



    Public Property Label As String
        Get
            Return mLabel
        End Get
        Set(value As String)
            mLabel = value
        End Set
    End Property

    Public Property Status As Integer
        Get
            Return mStatus
        End Get
        Set(value As Integer)
            mStatus = value
        End Set
    End Property

    Public Property ItemType As Integer
        Get
            Return mItemType
        End Get
        Set(value As Integer)
            mItemType = value
        End Set
    End Property


    Public Sub New(ByVal surveyid As Integer, ByVal name As String, ByVal itemLabel As String, ByVal fItemType As Integer)

        mSurvey_id = surveyid
        mCoverLetterName = name
        mLabel = itemLabel
        mItemType = fItemType

    End Sub
End Class
