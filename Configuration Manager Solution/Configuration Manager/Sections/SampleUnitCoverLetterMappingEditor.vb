Imports Nrc.QualiSys.Library
Imports DevExpress.XtraTreeList.Nodes
Imports DevExpress.XtraTreeList.Columns

Public Class SampleUnitCoverLetterMappingEditor

#Region "Enums"

    Public Enum CoverLetterPageTypes

        CoverLetter = 1
        Artifact = 4

    End Enum

    Public Enum MappingStatus
        OK = 0
        IsNew = 1
        Duplicate = 2
    End Enum

#End Region

#Region " Private Fields "
    Private mModule As SampleUnitCoverLetterMappingModule
    Private mEndConfigCallBack As EndConfigCallBackMethod
    Private mCoverLetterList As New Collection(Of CoverLetter)
    Private mArtifactList As New Collection(Of CoverLetter)
    Private mMappings As New List(Of CoverLetterMapping)
    'Private mSelectedSampleUnits As New Collection(Of SampleUnit)
    Private mAllSampleUnits As Collection(Of SampleUnit)
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

    Private Sub gvMappings_CustomDrawCell(sender As Object, e As DevExpress.XtraGrid.Views.Base.RowCellCustomDrawEventArgs) Handles gvMappings.CustomDrawCell
        If e.Column.Name <> "colStatusImage" Then
            Dim status As MappingStatus = DirectCast(gvMappings.GetRowCellValue(e.RowHandle, "Status"), MappingStatus)

            Select Case status
                Case MappingStatus.OK
                    e.Appearance.ForeColor = Color.Blue
                Case MappingStatus.IsNew
                    e.Appearance.ForeColor = Color.Green
                Case MappingStatus.Duplicate
                    e.Appearance.ForeColor = Color.Red
            End Select

        End If
    End Sub

    Private Sub gvMappings_CustomUnboundColumnData(sender As Object, e As DevExpress.XtraGrid.Views.Base.CustomColumnDataEventArgs) Handles gvMappings.CustomUnboundColumnData

        If e.Column.Name = "colStatusImage" AndAlso e.IsGetData Then

            Dim status As MappingStatus = DirectCast(gvMappings.GetRowCellValue(e.RowHandle, "Status"), MappingStatus)

            Select Case status
                Case MappingStatus.OK
                    e.Value = My.Resources.GreenLight
                Case MappingStatus.IsNew
                    e.Value = My.Resources.New16
                Case MappingStatus.Duplicate
                    e.Value = My.Resources.Error16
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

        btnMap.Enabled = SampleUnitTreeView.Selection.Count > 0 And gvCoverLetters.SelectedRowsCount > 0 And gvArtifacts.SelectedRowsCount > 0
        btnUnmap.Enabled = gvMappings.SelectedRowsCount > 0

        ApplyButton.Enabled = IsValidMappings()
        OKButton.Enabled = IsValidMappings()

    End Sub

    Private Sub SampleUnitCoverLetterMappingEditor_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Initialize()
    End Sub

    Private Sub CancelButton_Click(sender As System.Object, e As System.EventArgs) Handles CancelButton.Click
        Me.mEndConfigCallBack(ConfigResultActions.None, Nothing)
        Me.mEndConfigCallBack = Nothing
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
        mCoverLetterList = CoverLetter.GetBySurveyIdAndPageType(Me.mModule.Survey.Id, CoverLetterPageTypes.CoverLetter)
        CoverLetterBindingSource.DataSource = GetCoverLetters(mCoverLetterList)

        'Get a list of all the artifacts for this survey
        mArtifactList = CoverLetter.GetBySurveyIdAndPageType(Me.mModule.Survey.Id, CoverLetterPageTypes.Artifact)
        ArtifactBindingSource.DataSource = GetCoverLetters(mArtifactList)

        PopulateMappings()

        'Don't allow save if module is not editable
        Me.OKButton.Enabled = Me.mModule.IsEditable
        Me.ApplyButton.Enabled = Me.mModule.IsEditable

        PopulateUnitTree()

        SampleUnitTreeView.Selection.Clear()

    End Sub

    Private Sub PopulateMappings()
        'Get a list of the current mapped sections
        mMappings.Clear()
        mMappings = CoverLetterMapping.GetCoverLetterMappingsBySurveyId(Me.mModule.Survey.Id)
        'Set the binding source for the sampleunit lookup
        Me.SampleUnitBindingSource.DataSource = mMappings


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
        If SampleUnitTreeView.Nodes().Count > 0 Then
            SampleUnitTreeView.SetFocusedNode(SampleUnitTreeView.Nodes(0))
            SampleUnitTreeView.Selection.Add(SampleUnitTreeView.Nodes(0))
            UpdateMappingsFilter()
        End If
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
                inList = inList & sunit.Id.ToString() & ","
            End If

        Next

        If Not inList.Equals(String.Empty) Then
            ' remove the last comma from the IN statement
            inList = inList.Substring(0, inList.Length - 1)
            criteriaString = " AND [SampleUnit_Id] IN (" & inList & ")"
        End If

        gvMappings.ActiveFilter.NonColumnFilter = "[NeedsDelete] = false" & criteriaString

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
                    coverLetterList.Add(New MyCoverLetter(cletter.Id, cletter.Survey_Id, coverLetterName, item.ItemID, item.Label))
                Next
            End If
        Next

        Return coverLetterList

    End Function

    Private Sub MapSampleUnits()

        If SampleUnitTreeView.Selection.Count > 0 And gvCoverLetters.SelectedRowsCount > 0 And gvArtifacts.SelectedRowsCount > 0 Then

            For Each node As TreeListNode In SampleUnitTreeView.Selection
                Dim sUnit As SampleUnit = DirectCast(node.Tag, SampleUnit)
                Dim sampleUnitName As String = sUnit.SampleUnitName

                For Each rowHandle As Integer In gvCoverLetters.GetSelectedRows()

                    Dim coverLetterName As String = gvCoverLetters.GetRowCellValue(rowHandle, "CoverLetterName").ToString().Trim()
                    Dim coverLetterTextBoxName As String = gvCoverLetters.GetRowCellValue(rowHandle, "Label").ToString().Trim()
                    Dim coverLetterCoverID As Integer = Convert.ToInt32(gvCoverLetters.GetRowCellValue(rowHandle, "CoverID"))
                    Dim coverLetterItem_Id As Integer = Convert.ToInt32(gvCoverLetters.GetRowCellValue(rowHandle, "ItemID"))

                    Dim artifactpagename As String = gvArtifacts.GetRowCellValue(gvArtifacts.FocusedRowHandle, "CoverLetterName").ToString().Trim()
                    Dim artifactitemname As String = gvArtifacts.GetRowCellValue(gvArtifacts.FocusedRowHandle, "Label").ToString().Trim()
                    Dim artifactCoverID As Integer = Convert.ToInt32(gvArtifacts.GetRowCellValue(rowHandle, "CoverID"))
                    Dim artifactitem_Id As Integer = Convert.ToInt32(gvArtifacts.GetRowCellValue(rowHandle, "ItemID"))


                    Dim mappedUnit As CoverLetterMapping = CoverLetterMapping.NewCoverLetterMapping(-1, Me.mModule.Survey.Id, sUnit.Id, sampleUnitName, CoverLetterItemType.TEXTBOX, coverLetterCoverID, coverLetterName, coverLetterItem_Id, coverLetterTextBoxName, artifactCoverID, artifactpagename, artifactitem_Id, artifactitemname)

                    ' check to see if this mapping already exists
                    If ValidateMapping(mappedUnit) Then

                        mappedUnit.Status = MappingStatus.IsNew
                    Else
                        'MsgBox("Duplicate Cover Letter Mapping!", MsgBoxStyle.Critical, "Cover Letter Mapping Error")

                        mappedUnit.Status = MappingStatus.Duplicate

                    End If

                    mMappings.Add(mappedUnit)

                Next
            Next

            SampleUnitBindingSource.DataSource = mMappings

            SampleUnitBindingSource.ResetBindings(False)

            gvMappings.ClearSelection()

        End If
    End Sub

    Private Sub DeleteMapping()

        For Each rowHandle As Integer In gvMappings.GetSelectedRows()

            Dim child As CoverLetterMapping = DirectCast(gvMappings.GetRow(rowHandle), CoverLetterMapping)

            For idx As Integer = 0 To mMappings.Count - 1
                Dim mappedItem As CoverLetterMapping = mMappings.Item(idx)
                If mappedItem.UniqueID = child.UniqueID Then
                    If mappedItem.IsNew = False Then
                        ' If this is an existing MappedQuestion, then flag it for deletion
                        mappedItem.NeedsDelete = True
                        ResetDuplicate(mappedItem)
                    Else
                        'otherwise, just remove it from the list
                        mMappings.RemoveAt(idx)
                    End If
                    Exit For
                End If
            Next
        Next

        SampleUnitBindingSource.DataSource = mMappings
        SampleUnitBindingSource.ResetBindings(False)
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
            If mapping.Equals(mapping) Then
                result = False
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
#End Region
End Class

Friend Class MyCoverLetter
    Private mCoverID As Integer
    Private mSurvey_id As Integer
    Private mCoverLetterName As String
    Private mItemID As Integer
    Private mLabel As String


    Public Property CoverID As Integer
        Get
            Return mCoverID
        End Get
        Set(value As Integer)
            mCoverID = value
        End Set
    End Property

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

    Public Property ItemID As Integer
        Get
            Return mItemID
        End Get
        Set(value As Integer)
            mItemID = value
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



    Public Sub New(ByVal id As Integer, ByVal surveyid As Integer, ByVal name As String, ByVal itemid As Integer, ByVal itemLabel As String)
        mCoverID = id
        mSurvey_id = surveyid
        mCoverLetterName = name
        mItemID = itemid
        mLabel = itemLabel

    End Sub
End Class
