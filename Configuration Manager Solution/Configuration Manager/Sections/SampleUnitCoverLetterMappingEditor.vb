Imports Nrc.QualiSys.Library
Imports DevExpress.XtraTreeList.Nodes
Imports DevExpress.XtraTreeList.Columns
Imports DevExpress.XtraGrid.Views.Base
Imports DevExpress.XtraGrid.Views.Base.ViewInfo
Imports DevExpress.XtraGrid.Views.Grid.ViewInfo
Imports System.Text.RegularExpressions

Public Class SampleUnitCoverLetterMappingEditor

#Region "Enums"

    Public Enum MappingStatus
        OK = 0
        IsNew = 1
        Duplicate = 2
        NeedsDelete = 3
    End Enum

#End Region

#Region " Private Fields "
    Private mModule As SampleUnitCoverLetterMappingModule
    Private mEndConfigCallBack As EndConfigCallBackMethod
    Private mCoverLetterList As New Collection(Of CoverLetter)
    Private mArtifactList As New Collection(Of CoverLetter)
    Private mMappings As New List(Of CoverLetterMapping)
    Private mAllSampleUnits As Collection(Of SampleUnit)
    Private newRepositoryItem As New DevExpress.XtraEditors.Repository.RepositoryItem
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

    Private Sub gvMappings_RowClick(sender As Object, e As DevExpress.XtraGrid.Views.Grid.RowClickEventArgs) Handles gvMappings.RowClick

        Dim mapping As CoverLetterMapping = DirectCast(gvMappings.GetRow(e.RowHandle), CoverLetterMapping)

        Dim sampleUnit_name As String = mapping.SampleUnit_name

        Dim node As TreeListNode = SearchTree(SampleUnitTreeView.Nodes, sampleUnit_name)

        ' SampleUnitTreeView.SetFocusedNode(node)



    End Sub

    Private Sub tsbtnExportToExcel_Click(sender As System.Object, e As System.EventArgs) Handles tsbtnExportToExcel.Click
        ExportMappingsToExcel()
    End Sub

    Private Sub UnMapContextMenu_Click(sender As System.Object, e As System.EventArgs) Handles UnMapContextMenu.Click
        DeleteMapping()
    End Sub

    Private Sub gvMappings_CustomDrawCell(sender As Object, e As DevExpress.XtraGrid.Views.Base.RowCellCustomDrawEventArgs) Handles gvMappings.CustomDrawCell

        ' need this here otherwise the grid blows up and the application closes.
        If e.RowHandle = DevExpress.XtraGrid.GridControl.AutoFilterRowHandle Then
            Exit Sub
        End If

        If e.Column.Name <> "colStatusImage" Then

            Dim status As MappingStatus = DirectCast(gvMappings.GetRowCellValue(e.RowHandle, "Status"), MappingStatus)

            Select Case status
                'Case MappingStatus.OK
                '    e.Appearance.ForeColor = Color.Blue
                'Case(MappingStatus.IsNew)
                '    e.Appearance.ForeColor = Color.Green
                Case MappingStatus.Duplicate
                    e.Appearance.ForeColor = Color.Red
                Case MappingStatus.NeedsDelete
                    'e.Appearance.Font = New Font(e.Appearance.Font, e.Appearance.Font.Style Or FontStyle.Strikeout)
            End Select

        End If
    End Sub



    Private Sub gvMappings_CustomUnboundColumnData(sender As Object, e As DevExpress.XtraGrid.Views.Base.CustomColumnDataEventArgs) Handles gvMappings.CustomUnboundColumnData

        If String.Compare(e.Column.Name, "colStatusImage", False) = 0 AndAlso e.IsGetData Then

            Dim status As MappingStatus = DirectCast(gvMappings.GetRowCellValue(e.RowHandle, "Status"), MappingStatus)

            Select Case status
                Case MappingStatus.OK
                    e.Value = My.Resources.Validation16
                Case MappingStatus.IsNew
                    e.Value = My.Resources.New16
                Case MappingStatus.Duplicate
                    e.Value = My.Resources.NoWay16
                Case MappingStatus.NeedsDelete
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
        If e.Node IsNot Nothing Then
            If e.Node.ParentNode Is Nothing Then
                e.CanFocus = False ' prevents the root node from being selected
            End If
        End If

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
        SampleUnitTreeView.Selection.Clear()
    End Sub

    Public Sub IdleEvent(ByVal sender As System.Object, ByVal e As System.EventArgs)

        ' only map if 
        btnMap.Enabled = SampleUnitTreeView.Selection.Count > 0 And gvCoverLetters.SelectedRowsCount > 0 And gvArtifacts.SelectedRowsCount > 0
        btnUnmap.Enabled = gvMappings.SelectedRowsCount > 0

        'Don't allow save unless all mappings are valid (that is, they are not duplicates)
        ApplyButton.Enabled = IsValidMappings()
        OKButton.Enabled = IsValidMappings()

        Dim pos As Integer = gvMappings.ActiveFilter.NonColumnFilter.IndexOf("[SampleUnit_Id]")
        If pos >= 0 Then
            ToolStripStatusLabel1.Text = gvMappings.ActiveFilter.NonColumnFilter.Substring(pos)
        Else
            ToolStripStatusLabel1.Text = ""
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
        Me.OKButton.Enabled = Me.mModule.IsEditable
        Me.ApplyButton.Enabled = Me.mModule.IsEditable

        SampleUnitTreeView.Selection.Clear()

    End Sub

    Private Sub PopulateMappings()
        'Get a list of the current mapped sections
        mMappings.Clear()
        mMappings = CoverLetterMapping.GetCoverLetterMappingsBySurveyId(Me.mModule.Survey.Id)
        'Set the binding source for the sampleunit lookup
        'Me.SampleUnitBindingSource.DataSource = mMappings
        gcMappings.DataSource = mMappings

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
                rootNode.Visible = False
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

        Dim criteriaString As String = String.Empty
        Dim inList As String = String.Empty

        For Each node As TreeListNode In Me.SampleUnitTreeView.Selection
            'Me.mSelectedSampleUnits.Add(DirectCast(node.Tag, SampleUnit))
            Dim sunit As SampleUnit = DirectCast(node.Tag, SampleUnit)
            If sunit IsNot Nothing Then
                inList = String.Concat(inList, sunit.Id.ToString(), ",")
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
        gvMappings.ClearSelection()
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
                    coverLetterList.Add(New MyCoverLetter(cletter.Survey_Id, coverLetterName, item.Label))
                Next
            End If
        Next

        Return coverLetterList

    End Function

    Private Sub MapSampleUnits()

        If SampleUnitTreeView.Selection.Count > 0 And gvCoverLetters.SelectedRowsCount > 0 And gvArtifacts.SelectedRowsCount > 0 Then

            Dim hasDuplicate As Boolean = False

            For Each node As TreeListNode In SampleUnitTreeView.Selection
                Dim sUnit As SampleUnit = DirectCast(node.Tag, SampleUnit)
                Dim sampleUnitName As String = sUnit.SampleUnitName

                For Each rowHandle As Integer In gvCoverLetters.GetSelectedRows()

                    Dim coverLetterName As String = gvCoverLetters.GetRowCellValue(rowHandle, "CoverLetterName").ToString().Trim()
                    Dim coverLetterTextBoxName As String = gvCoverLetters.GetRowCellValue(rowHandle, "Label").ToString().Trim()
                    'Dim coverLetterCoverID As Integer = Convert.ToInt32(gvCoverLetters.GetRowCellValue(rowHandle, "CoverID"))
                    'Dim coverLetterItem_Id As Integer = Convert.ToInt32(gvCoverLetters.GetRowCellValue(rowHandle, "ItemID"))

                    Dim artifactpagename As String = gvArtifacts.GetRowCellValue(gvArtifacts.FocusedRowHandle, "CoverLetterName").ToString().Trim()
                    Dim artifactitemname As String = gvArtifacts.GetRowCellValue(gvArtifacts.FocusedRowHandle, "Label").ToString().Trim()
                    'Dim artifactCoverID As Integer = Convert.ToInt32(gvArtifacts.GetRowCellValue(gvArtifacts.FocusedRowHandle, "CoverID"))
                    'Dim artifactitem_Id As Integer = Convert.ToInt32(gvArtifacts.GetRowCellValue(gvArtifacts.FocusedRowHandle, "ItemID"))

                    Dim mappedUnit As CoverLetterMapping = CoverLetterMapping.NewCoverLetterMapping(-1, Me.mModule.Survey.Id, sUnit.Id, sampleUnitName, CoverLetterItemType.TEXTBOX, coverLetterName, coverLetterTextBoxName, artifactpagename, artifactitemname)

                    ' check to see if this mapping already exists
                    If ValidateMapping(mappedUnit) Then

                        mappedUnit.Status = MappingStatus.IsNew
                    Else
                        mappedUnit.Status = MappingStatus.Duplicate
                        hasDuplicate = True

                    End If

                    mMappings.Add(mappedUnit)

                Next
            Next

            If hasDuplicate Then
                MsgBox("One or more Cover Letter Mappings are duplicates!", MsgBoxStyle.Critical, "Cover Letter Mapping Error")
            End If

            gcMappings.DataSource = mMappings
            gcMappings.RefreshDataSource()

            gvMappings.ClearSelection()

        End If
    End Sub

    Private Sub DeleteMapping()

        'For Each rowHandle As Integer In gvMappings.GetSelectedRows()
        '    Dim item As CoverLetterMapping = DirectCast(gvMappings.GetRow(rowHandle), CoverLetterMapping)
        '    For idx As Integer = 0 To mMappings.Count - 1
        '        Dim mappedItem As CoverLetterMapping = mMappings.Item(idx)
        '        If mappedItem.UniqueID = item.UniqueID Then
        '            mappedItem.NeedsDelete = True
        '            ResetDuplicate(mappedItem)
        '            Exit For
        '        End If
        '    Next
        'Next
        ''  Now remove those items from the mapping list where IsNew = True and flagged as NeedsDelete
        ''  We will not be removing any existing (that is previously stored" records because we need 
        ''  to delete those from the database.
        'For x As Integer = mMappings.Count - 1 To 0 Step -1
        '    Dim m As CoverLetterMapping = mMappings.Item(x)
        '    If m.IsNew And m.NeedsDelete Then
        '        mMappings.RemoveAt(x)
        '    End If
        'Next

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
                            mappedItem.Status = MappingStatus.NeedsDelete
                            ResetDuplicate(mappedItem)
                        Else
                            'otherwise, just remove it from the list
                            mMappings.RemoveAt(idx)
                        End If
                        Exit For
                    End If
                Next
            End If
        Next

        gcMappings.DataSource = mMappings
        gcMappings.RefreshDataSource()
        gvMappings.ClearSelection()
        UpdateMappingsFilter()

    End Sub

    Private Sub ResetDuplicate(ByVal mapping As CoverLetterMapping)

        For Each item As CoverLetterMapping In mMappings
            If item.Equals(mapping) And item.Status = MappingStatus.Duplicate Then
                item.Status = MappingStatus.IsNew
            End If
        Next

    End Sub

    Private Sub ShowAllMappings()
        gvMappings.ActiveFilter.NonColumnFilter = "[NeedsDelete] = false"
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

    Private Function ValidateMapping(ByVal unit As CoverLetterMapping) As Boolean
        ' return true if mapping does not match a current mapping, false if it matches
        Dim result As Boolean = True

        For Each mapping As CoverLetterMapping In mMappings
            If Not mapping.NeedsDelete Then ' ignore mappings that have already been marked as NeedsDelete
                If mapping.Equals(unit) Then
                    result = False
                End If
            End If
        Next

        Return result

    End Function

    Private Function IsValidMappings() As Boolean

        Dim result As Boolean = True

        For Each MappedItem As CoverLetterMapping In mMappings

            If MappedItem.Status = MappingStatus.Duplicate Then
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

            If MsgBox("Exit without saving changes?", MsgBoxStyle.YesNo, "Cover Letter Mapping") = MsgBoxResult.No Then
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

    Private Function SearchTree(ByVal nodes As TreeListNodes, ByVal sampleUnitName As String) As TreeListNode
        For Each node As TreeListNode In nodes
            Dim name As String = DirectCast(node.Tag, SampleUnit).Name
            If name = sampleUnitName Then
                Return node
            Else
                If node.HasChildren Then
                    Return SearchTree(node.Nodes, sampleUnitName)
                End If
            End If
        Next
        Return Nothing
    End Function

#End Region
End Class

Friend Class MyCoverLetter

    Private mSurvey_id As Integer
    Private mCoverLetterName As String

    Private mLabel As String



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



    Public Sub New(ByVal surveyid As Integer, ByVal name As String, ByVal itemLabel As String)

        mSurvey_id = surveyid
        mCoverLetterName = name
        mLabel = itemLabel

    End Sub
End Class
