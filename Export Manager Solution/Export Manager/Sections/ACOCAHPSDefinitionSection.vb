Imports Nrc.DataMart.Library
Imports DevExpress.XtraEditors
Imports DevExpress.XtraGrid.Views.Grid
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class ACOCAHPSDefinitionSection

    Private WithEvents mNavigator As ACOCAHPSNavigator
    Private mIsInitializing As Boolean

    Private Enum ViewType
        Active = 0
        ShowAll = 1
    End Enum

#Region " Base Class Overrides "

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        mNavigator = TryCast(navCtrl, ACOCAHPSNavigator)
        If mNavigator Is Nothing Then
            Throw New Exception("ACOCAHPSDefinitionSection expects a navigation control of type ACOCAHPSNavigator")
        End If
    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        Dim isDirty As Boolean

        If Me.FileHistoryGridView.RowCount > 0 Then
            For Each exportFile As ExportFileView In DirectCast(FileHistoryBindingSource.DataSource, Collection(Of ExportFileView))
                If exportFile.IsDirty Then isDirty = True
            Next
        End If

        'Check to see if file tracking was modified before loading next node
        If isDirty Then
            MessageBox.Show("Please save or cancel changes to File History Tracking before navigating to another CAHPS type.", "File Tracking", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
            Return False
        End If

        Return True

    End Function

#End Region

#Region " Constructors "

    Public Sub New()
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
    End Sub
#End Region

#Region " Navigator Events "

    Private Sub mNavigator_SelectedNodeChanging(ByVal sender As Object, ByVal e As SelectedNodeChangingEventArgs) Handles mNavigator.SelectedNodeChanging

        e.Cancel = Not AllowInactivate()

    End Sub

    Private Sub mNavigator_ExportSetTypeSelectionChanged(ByVal sender As Object, ByVal e As ExportSetTypeSelectionChangedEventArgs) Handles mNavigator.ExportSetTypeSelectionChanged

        'Set member variables
        'mExportSetType = e.ExportSetType

        'Select Case mExportSetType
        '    Case ExportSetType.OCSClient, ExportSetType.OCSNonClient
        '        ExportButton.Visible = False
        '        CCNPanel.Visible = False
        '        FileTypeComboBox.Visible = False

        '    Case Else
        '        ExportButton.Visible = True
        '        CCNPanel.Visible = True
        '        FileTypeComboBox.Visible = True

        'End Select

        'Populate definition
        InitializeMonthList()
        InitializeYearList()
        InitializeFileTypes()
        InitializeViewToolStripMenu()
        InitializeCCNList()

        'Populate file history
        PopulateFileHistory()

    End Sub
#End Region

#Region " Private Methods "

    Private Sub PopulateFileHistory()

        Dim ACOExportSets As Collection(Of ExportFileView) = ExportFileView.GetByExportType(ExportSetType.ACOCAHPS, FilterStartDate.Value.Date, FilterEndDate.Value.Date)

        'For Each exportFile As ExportFileView In ExportFileView.GetByExportType(ExportSetType.ACOCAHPS, FilterStartDate.Value.Date, FilterEndDate.Value.Date)
        '    ACOExportSets.Add(exportFile)
        'Next

        FileHistoryBindingSource.DataSource = ACOExportSets

        'Add Default sorting
        'FileHistoryGridView.Columns("IsInError").SortOrder = DevExpress.Data.ColumnSortOrder.Descending
        FileHistoryGridView.Columns("CreatedDate").SortOrder = DevExpress.Data.ColumnSortOrder.Descending
        'FileHistoryGridView.Columns("MedicareNumber").SortOrder = DevExpress.Data.ColumnSortOrder.Ascending

        'Add Default grouping
        FileHistoryGridView.Columns("CreatedDate").Group()
        FileHistoryGridView.ExpandAllGroups()

    End Sub

    Private Sub InitializeMonthList()
        MonthList.DataSource = Nothing

        Dim months As New List(Of MonthListItem)
        months.Add(New MonthListItem("January", 1))
        months.Add(New MonthListItem("February", 2))
        months.Add(New MonthListItem("March", 3))
        months.Add(New MonthListItem("April", 4))
        months.Add(New MonthListItem("May", 5))
        months.Add(New MonthListItem("June", 6))
        months.Add(New MonthListItem("July", 7))
        months.Add(New MonthListItem("August", 8))
        months.Add(New MonthListItem("September", 9))
        months.Add(New MonthListItem("October", 10))
        months.Add(New MonthListItem("November", 11))
        months.Add(New MonthListItem("December", 12))
        MonthList.DisplayMember = "MonthName"
        MonthList.ValueMember = "MonthNumber"
        MonthList.DataSource = months
        MonthList.SelectedValue = Date.Today.Month
    End Sub

    Private Sub InitializeYearList()
        Dim startYear As Integer = Date.Today.Year - 5
        YearList.Items.Clear()

        For i As Integer = 0 To 10
            YearList.Items.Add(startYear + i)
        Next

        YearList.SelectedItem = Date.Today.Year
    End Sub

    Private Sub InitializeFileTypes()

        FileTypeComboBox.Items.Clear()
        FileTypeComboBox.Items.Add(New FileTypeItem(ExportFileType.DBase, "dBase File (.dbf)", "dbf"))
        FileTypeComboBox.Items.Add(New FileTypeItem(ExportFileType.Csv, "CSV File (.csv)", "csv"))
        FileTypeComboBox.Items.Add(New FileTypeItem(ExportFileType.Xml, "XML File (.xml)", "xml"))

        FileTypeComboBox.SelectedIndex = 2

    End Sub

    Private Sub InitializeViewToolStripMenu()

        mIsInitializing = True
        ViewToolStripComboBox.Items.Clear()
        ViewToolStripComboBox.Items.Add(New ListItem(Of ViewType)("Active", ViewType.Active))
        ViewToolStripComboBox.Items.Add(New ListItem(Of ViewType)("Show All", ViewType.ShowAll))
        ViewToolStripComboBox.SelectedIndex = 0
        mIsInitializing = False

    End Sub

    Private Sub InitializeCCNList()

        CCNBindingSource.DataSource = MedicareExport.GetAllByDistinctMedicareNumber(ExportSetType.ACOCAHPS, SelectedViewType() = ViewType.Active)

    End Sub

    Public Function GetFileName(ByVal path As String, ByVal fileExtension As String) As String

        If Not (IO.Directory.Exists(path + "\ACOCAHPS\")) Then
            IO.Directory.CreateDirectory(path + "\ACOCAHPS\")
        End If
        Dim version As Integer = 1
        Dim finalPath As String = path + "\ACOCAHPS\NationalResearch.submission" + version.ToString() + "." + Today.ToString("MMddyy") + fileExtension
        While IO.File.Exists(finalPath) Or IO.File.Exists(finalPath.Replace("ACOCAHPS", "ACOCAHPS\ExportErrors"))
            version += 1
            finalPath = path + "\ACOCAHPS\NationalResearch.submission" + version.ToString() + "." + Today.ToString("MMddyy") + fileExtension
        End While

        Return finalPath

    End Function

    Private Function SelectedFileType() As FileTypeItem

        Return New FileTypeItem(ExportFileType.CustomFixedWidth, "txt", "txt")

    End Function

    Private Function SelectedViewType() As ViewType
        Dim viewType As ListItem(Of ViewType) = CType(ViewToolStripComboBox.SelectedItem, ListItem(Of ViewType))
        Return viewType.Value
    End Function
#End Region

#Region " Private Events "

    Private Sub CAHPSDefinitionSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        FilterStartDate.Value = DateTime.Parse(Now.Month.ToString() + "/1/" + Now.Year.ToString())
        FilterEndDate.Value = FilterStartDate.Value.AddMonths(1).AddDays(-1)

        'Populate file history
        PopulateFileHistory()

    End Sub

    Private Sub SelectAllToolStripButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles SelectAllToolStripButton.Click

        CCNGridView.BeginUpdate()
        Try
            For x As Integer = 0 To CCNGridView.RowCount - 1
                CCNGridView.SetRowCellValue(x, "Selected", True)
            Next
        Finally
            CCNGridView.EndDataUpdate()
        End Try

    End Sub

    Private Sub DeselectAllToolStripButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles DeselectAllToolStripButton.Click

        CCNGridView.BeginUpdate()
        Try
            For x As Integer = 0 To CCNGridView.RowCount - 1
                CCNGridView.SetRowCellValue(x, "Selected", False)
            Next
        Finally
            CCNGridView.EndDataUpdate()
        End Try

    End Sub

    Private Sub ViewToolStripComboBox_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ViewToolStripComboBox.SelectedIndexChanged

        If Not mIsInitializing Then
            InitializeCCNList()
        End If

    End Sub

    Private Sub ExportButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles ExportButton.Click

        Dim selectCount As Integer = 0
        For x As Integer = 0 To CCNGridView.RowCount - 1
            If CType(CCNGridView.GetRowCellValue(x, "Selected"), Boolean) = True Then
                selectCount += 1
            End If
        Next
        Dim fileName As String = GetFileName(AppConfig.Params("EMCMSOutputFolderPath").StringValue, ".txt.pgp")

        If MessageBox.Show(String.Format("Generating {0} export(s) for {1} {2}.", selectCount, MonthList.Text, YearList.Text), "Create Export(s)", MessageBoxButtons.OKCancel, MessageBoxIcon.Information, MessageBoxDefaultButton.Button1) = DialogResult.Cancel Then
            Exit Sub
        End If

        Try
            Cursor.Current = Cursors.WaitCursor

            Dim startDate As Date = Date.Parse(String.Format("{0}/1/{1}", CType(MonthList.SelectedValue, Integer), CType(YearList.SelectedItem, Integer)))
            Dim endDate As Date = startDate.AddMonths(1).AddDays(-1)
            Dim ACOCAHPSExportSets As New Collection(Of ExportSet)
            'Dim exportSets As New Collection(Of ExportSet)

            For x As Integer = 0 To CCNGridView.RowCount - 1
                If CType(CCNGridView.GetRowCellValue(x, "Selected"), Boolean) = True Then
                    'Dim medicareNumber As String = CCNGridView.GetRowCellValue(x, "MedicareNumber").ToString
                    'Dim medicareName As String = CCNGridView.GetRowCellValue(x, "MedicareName").ToString

                    Dim surveyID As Integer = CType(CCNGridView.GetRowCellValue(x, "SurveyId"), Integer)
                    Dim clientName As String = CType(CCNGridView.GetRowCellValue(x, "ClientName"), String)
                    Dim surveyName As String = CType(CCNGridView.GetRowCellValue(x, "SurveyName"), String)
                    ACOCAHPSExportSets.Add(ExportSet.CreateNewExportSet(clientName + " - " + surveyName, surveyID, startDate, endDate, ExportSetType.ACOCAHPS, CurrentUser.UserName))
                End If
            Next

            Dim failedCount As Integer
            failedCount = ExportFile.CreateACOCAHPSExportFile(ACOCAHPSExportSets, fileName, False, Me.InterimFileCheckBox.Checked)

            Dim crlf As String = vbCrLf & vbTab
            Dim message As String = String.Format("Export process complete.{0}File count: {1}{0}File errors: {2}{0}File path: {3}", crlf, selectCount, failedCount, fileName)
            MessageBox.Show(message, "Export", MessageBoxButtons.OK, MessageBoxIcon.Information)

            PopulateFileHistory()

        Finally
            Cursor.Current = Cursors.Default
        End Try

    End Sub

    Private Sub FilterToolStripButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterToolStripButton.Click

        PopulateFileHistory()

    End Sub

    Private Sub SubmittedToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SubmittedToolStripButton.Click

        Dim rows() As Integer = FileHistoryGridView.GetSelectedRows
        FileHistoryGridView.BeginUpdate()
        Try
            For Each row As Integer In rows
                If FileHistoryGridView.GetRowCellValue(row, "datSubmitted") Is Nothing Then
                    FileHistoryGridView.SetRowCellValue(row, "datSubmitted", Now.Date)
                Else
                    FileHistoryGridView.SetRowCellValue(row, "datSubmitted", Nothing)
                End If
            Next
        Finally
            FileHistoryGridView.EndDataUpdate()
        End Try

    End Sub

    Private Sub AcceptedStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AcceptedStripButton.Click

        Dim rows() As Integer = FileHistoryGridView.GetSelectedRows
        FileHistoryGridView.BeginUpdate()
        Try
            For Each row As Integer In rows
                If FileHistoryGridView.GetRowCellValue(row, "datAccepted") Is Nothing Then
                    FileHistoryGridView.SetRowCellValue(row, "datAccepted", Now.Date)
                Else
                    FileHistoryGridView.SetRowCellValue(row, "datAccepted", Nothing)
                End If
            Next
        Finally
            FileHistoryGridView.EndDataUpdate()
        End Try

    End Sub

    Private Sub RejectedToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RejectedToolStripButton.Click

        Dim rows() As Integer = FileHistoryGridView.GetSelectedRows
        FileHistoryGridView.BeginUpdate()
        Try
            For Each row As Integer In rows
                If FileHistoryGridView.GetRowCellValue(row, "datRejected") Is Nothing Then
                    FileHistoryGridView.SetRowCellValue(row, "datRejected", Now.Date)
                Else
                    FileHistoryGridView.SetRowCellValue(row, "datRejected", Nothing)
                End If
            Next
        Finally
            FileHistoryGridView.EndDataUpdate()
        End Try

    End Sub

    Private Sub IgnoreRepositoryItemCheckEdit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles IgnoreRepositoryItemCheckEdit.Click

        'Using send keys to get a quick refresh
        SendKeys.Send("+{TAB}")
        SendKeys.Send("{TAB}")

    End Sub

    Private Sub OverrideRepositoryItemCheckEdit_CheckStateChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles OverrideRepositoryItemCheckEdit.CheckStateChanged

        Dim checkbox As CheckEdit = TryCast(sender, CheckEdit)

        If checkbox.Checked Then
            FileHistoryGridView.SetRowCellValue(FileHistoryGridView.FocusedRowHandle, "datOverride", Now.Date)
            FileHistoryGridView.SetRowCellValue(FileHistoryGridView.FocusedRowHandle, "OverrideErrorName", CurrentUser.UserName)
        Else
            FileHistoryGridView.SetRowCellValue(FileHistoryGridView.FocusedRowHandle, "datOverride", Nothing)
            FileHistoryGridView.SetRowCellValue(FileHistoryGridView.FocusedRowHandle, "OverrideErrorName", String.Empty)
        End If

    End Sub

    Private Sub OverrideRepositoryItemCheckEdit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles OverrideRepositoryItemCheckEdit.Click

        'Using send keys to get a quick refresh
        SendKeys.Send("+{TAB}")
        SendKeys.Send("{TAB}")

    End Sub

    Private Sub FileHistoryGridView_ShownEditor(ByVal sender As Object, ByVal e As System.EventArgs) Handles FileHistoryGridView.ShownEditor

        Dim view As GridView = TryCast(sender, GridView)
        If Not CType(view.GetRowCellValue(view.FocusedRowHandle, "IsInError"), Boolean) AndAlso view.FocusedColumn.FieldName = "OverrideError" Then
            view.ActiveEditor.Properties.ReadOnly = True
        End If

    End Sub

    Private Sub CancelButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles CancelButton.Click

        PopulateFileHistory()

    End Sub

    Private Sub SaveButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles SaveButton.Click

        'Commit any uncommitted contact changes
        If FileHistoryGridView.IsEditing Then
            If FileHistoryGridView.ValidateEditor Then
                FileHistoryGridView.CloseEditor()
            End If
        End If

        For Each exportFile As ExportFileView In DirectCast(FileHistoryBindingSource.DataSource, Collection(Of ExportFileView))
            If exportFile.IsDirty Then exportFile.UpdateTracking()
        Next

        PopulateFileHistory()

    End Sub
#End Region

End Class
