Imports Nrc.DataMart.Library
Imports DevExpress.XtraEditors
Imports DevExpress.XtraGrid.Views.Grid
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class CAHPSDefinitionSection

    Private WithEvents mNavigator As CAHPSNavigator
    Private mExportSetType As ExportSetType
    Private mIsInitializing As Boolean

    Private Enum ViewType
        MedicareOnly = 0
        SampleUnit = 1
    End Enum

#Region " Base Class Overrides "

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        mNavigator = TryCast(navCtrl, CAHPSNavigator)
        If mNavigator Is Nothing Then
            Throw New Exception("CAHPSDefinitionSection expects a navigation control of type CAHPSNavigator")
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
        mExportSetType = e.ExportSetType

        Select Case mExportSetType
            Case ExportSetType.OCSClient, ExportSetType.OCSNonClient
                OCSClientButton.Visible = True
                OCSNonClientButton.Visible = True
                ExportButton.Visible = False
                CCNPanel.Visible = False
                FileTypeLabel.Visible = False
                FileTypeComboBox.Visible = False

            Case Else
                OCSClientButton.Visible = False
                OCSNonClientButton.Visible = False
                ExportButton.Visible = True
                CCNPanel.Visible = True
                FileTypeLabel.Visible = True
                FileTypeComboBox.Visible = True

        End Select

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

        Dim medicareExportSets As Collection(Of ExportFileView) = ExportFileView.GetByExportType(mExportSetType, FilterStartDate.Value.Date, FilterEndDate.Value.Date)

        If mExportSetType = ExportSetType.OCSClient Then
            For Each exportFile As ExportFileView In ExportFileView.GetByExportType(ExportSetType.OCSNonClient, FilterStartDate.Value.Date, FilterEndDate.Value.Date)
                medicareExportSets.Add(exportFile)
            Next
        End If

        FileHistoryBindingSource.DataSource = medicareExportSets

        'Add Default sorting
        FileHistoryGridView.Columns("IsInError").SortOrder = DevExpress.Data.ColumnSortOrder.Descending
        FileHistoryGridView.Columns("CreatedDate").SortOrder = DevExpress.Data.ColumnSortOrder.Descending
        FileHistoryGridView.Columns("MedicareNumber").SortOrder = DevExpress.Data.ColumnSortOrder.Ascending

        'Add Default grouping
        FileHistoryGridView.Columns("ClientGroupName").Group()
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
        ViewToolStripComboBox.Items.Add(New ListItem(Of ViewType)("Medicare Number Only", ViewType.MedicareOnly))
        ViewToolStripComboBox.Items.Add(New ListItem(Of ViewType)("With Sample Unit", ViewType.SampleUnit))
        ViewToolStripComboBox.SelectedIndex = 0
        mIsInitializing = False

    End Sub

    Private Sub InitializeCCNList()

        Select Case SelectedViewType()
            Case ViewType.MedicareOnly
                CCNBindingSource.DataSource = MedicareExport.GetAllByDistinctMedicareNumber(mExportSetType, True)
                CCNGridView.Columns("SampleUnitId").Visible = False
                CCNGridView.Columns("SampleUnitName").Visible = False

            Case ViewType.SampleUnit
                CCNBindingSource.DataSource = MedicareExport.GetAllByDistinctSampleUnit(mExportSetType)
                CCNGridView.Columns("SampleUnitId").Visible = True
                CCNGridView.Columns("SampleUnitName").Visible = True

            Case Else
                Throw New ArgumentOutOfRangeException("ViewType")

        End Select

    End Sub

    Private Function GetFileName(ByVal medicareName As String, ByVal medicareNumber As String) As String

        'Set export file name.
        Select Case mExportSetType
            Case ExportSetType.CmsHcahps, ExportSetType.CmsChart
                Return String.Format("{0}_{1}_{2}_{3}", medicareName, medicareNumber, YearList.Text, MonthList.SelectedValue.ToString.PadLeft(2, "0"c))

            Case ExportSetType.CmsHHcahps
                Return String.Format("{0}_{1}_{2}_{3}_{4}", "HH", medicareName, medicareNumber, YearList.Text, MonthList.SelectedValue.ToString.PadLeft(2, "0"c))

            Case ExportSetType.OCSClient, ExportSetType.OCSNonClient
                Return String.Format("{0}_{1}_{2}", medicareName, YearList.Text, MonthList.SelectedValue.ToString.PadLeft(2, "0"c))

            Case Else
                Throw New ArgumentOutOfRangeException("mExportSetType")
        End Select

    End Function

    Private Function SelectedFileType() As FileTypeItem
        If FileTypeComboBox.SelectedItem IsNot Nothing Then
            Return TryCast(FileTypeComboBox.SelectedItem, FileTypeItem)
        Else
            Return New FileTypeItem(ExportFileType.Xml, "XML", "XML")
        End If
    End Function

    Private Function SelectedViewType() As ViewType
        Dim viewType As ListItem(Of ViewType) = CType(ViewToolStripComboBox.SelectedItem, ListItem(Of ViewType))
        Return viewType.Value
    End Function
#End Region

#Region " Private Events "

    Private Sub CAHPSDefinitionSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        FilterStartDate.Value = Now.AddDays(-1)

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

        If MessageBox.Show(String.Format("Generating {0} export(s) for {1} {2}.", selectCount, MonthList.Text, YearList.Text), "Create Export(s)", MessageBoxButtons.OKCancel, MessageBoxIcon.Information, MessageBoxDefaultButton.Button1) = DialogResult.Cancel Then
            Exit Sub
        End If

        Try
            Cursor.Current = Cursors.WaitCursor

            Dim startDate As Date = Date.Parse(String.Format("{0}/1/{1}", CType(MonthList.SelectedValue, Integer), CType(YearList.SelectedItem, Integer)))
            Dim endDate As Date = startDate.AddMonths(1).AddDays(-1)
            Dim medicareExportSets As New Collection(Of MedicareExportSet)
            Dim exportSets As New Collection(Of ExportSet)

            For x As Integer = 0 To CCNGridView.RowCount - 1
                If CType(CCNGridView.GetRowCellValue(x, "Selected"), Boolean) = True Then
                    Dim medicareNumber As String = CCNGridView.GetRowCellValue(x, "MedicareNumber").ToString
                    Dim medicareName As String = CCNGridView.GetRowCellValue(x, "MedicareName").ToString

                    Select Case SelectedViewType()
                        Case ViewType.MedicareOnly
                            medicareExportSets.Add(MedicareExportSet.CreateNewMedicareExportSet(medicareNumber, GetFileName(medicareName, medicareNumber), startDate, endDate, True, False, mExportSetType, CurrentUser.UserName))

                        Case ViewType.SampleUnit
                            Dim surveyID As Integer = CType(CCNGridView.GetRowCellValue(x, "SurveyId"), Integer)
                            Dim sampleUnitID As Integer = CType(CCNGridView.GetRowCellValue(x, "SampleUnitId"), Integer)
                            exportSets.Add(ExportSet.CreateNewExportSet(String.Format("{0}_{1}", GetFileName(medicareName, medicareNumber), sampleUnitID), surveyID, sampleUnitID, startDate, endDate, mExportSetType, CurrentUser.UserName))

                        Case Else
                            Throw New ArgumentOutOfRangeException("ViewType")

                    End Select
                End If
            Next

            Dim failedCount As Integer
            Select Case SelectedViewType()
                Case ViewType.MedicareOnly
                    failedCount = ExportFile.CreateCMSExportFile(medicareExportSets, AppConfig.Params("EMCMSOutputFolderPath").StringValue, SelectedFileType.Extension, SelectedFileType.ExportFileType, False)

                Case ViewType.SampleUnit
                    failedCount = ExportFile.CreateCMSExportFile(exportSets, AppConfig.Params("EMCMSOutputFolderPath").StringValue, SelectedFileType.Extension, SelectedFileType.ExportFileType, True, False, False, CurrentUser.UserName, False)

                Case Else
                    Throw New ArgumentOutOfRangeException("ViewType")

            End Select

            Dim crlf As String = vbCrLf & vbTab
            Dim outputPath As String = String.Format("{0}\{1}\{2}", AppConfig.Params("EMCMSOutputFolderPath").StringValue, mExportSetType.ToString, startDate.ToString("yyyyMMM"))
            Dim message As String = String.Format("Export process complete.{0}File count: {1}{0}File errors: {2}{0}File path: {3}", crlf, selectCount, failedCount, outputPath)
            MessageBox.Show(message, "Export", MessageBoxButtons.OK, MessageBoxIcon.Information)

            PopulateFileHistory()

        Finally
            Cursor.Current = Cursors.Default
        End Try

    End Sub

    Private Sub OCSClientButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles OCSClientButton.Click

        If MessageBox.Show(String.Format("Generating OCS Client export(s) for {0} {1}.", MonthList.Text, YearList.Text), "Create Export(s)", MessageBoxButtons.OKCancel, MessageBoxIcon.Information, MessageBoxDefaultButton.Button1) = DialogResult.Cancel Then
            Exit Sub
        End If

        Try
            Cursor.Current = Cursors.WaitCursor

            Dim startDate As Date = Date.Parse(String.Format("{0}/1/{1}", CType(MonthList.SelectedValue, Integer), CType(YearList.SelectedItem, Integer)))
            Dim endDate As Date = startDate.AddMonths(1).AddDays(-1)

            'Build Export Set
            Dim ocsMedicareExportSet As MedicareExportSet = MedicareExportSet.CreateNewMedicareExportSet(String.Empty, GetFileName("OCSClient", String.Empty), startDate, endDate, True, False, mExportSetType, CurrentUser.UserName)

            'Get existing HHCAHPS export sets
            Dim medicareExportSets As Collection(Of MedicareExportSet) = MedicareExportSet.GetFileGUIDsByClientGroup(SurveyType.HomeHCAHPS, "OCS", "=", startDate, endDate)

            'Remove duplication from export sets
            Dim cleanedExportSets As Collection(Of MedicareExportSet) = ResultsCleanup(medicareExportSets)

            'Build OCS file
            Dim fileCount As Integer = ExportFile.CreateOCSExportFile(ocsMedicareExportSet, cleanedExportSets, AppConfig.Params("EMCMSOutputFolderPath").StringValue, SelectedFileType.Extension, SelectedFileType.ExportFileType, False)

            Dim crlf As String = vbCrLf & vbTab
            Dim outputPath As String = String.Format("{0}\OCS\{1}", AppConfig.Params("EMCMSOutputFolderPath").StringValue, startDate.ToString("yyyyMMM"))
            Dim message As String = String.Format("OCS Client export process complete.{0}File count: {1}{0}File path: {2}", crlf, fileCount, outputPath)
            MessageBox.Show(message, "Export", MessageBoxButtons.OK, MessageBoxIcon.Information)

            PopulateFileHistory()

        Finally
            Cursor.Current = Cursors.Default
        End Try

    End Sub

    Private Sub OCSNonClientButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles OCSNonClientButton.Click

        If MessageBox.Show(String.Format("Generating OCS NonClient export(s) for {0} {1}.", MonthList.Text, YearList.Text), "Create Export(s)", MessageBoxButtons.OKCancel, MessageBoxIcon.Information, MessageBoxDefaultButton.Button1) = DialogResult.Cancel Then
            Exit Sub
        End If

        Try
            Dim startDate As Date = Date.Parse(String.Format("{0}/1/{1}", CType(MonthList.SelectedValue, Integer), CType(YearList.SelectedItem, Integer)))
            Dim endDate As Date = startDate.AddMonths(1).AddDays(-1)

            'Build Export Set
            Dim ocsMedicareExportSet As MedicareExportSet = MedicareExportSet.CreateNewMedicareExportSet(String.Empty, GetFileName("OCSNonClient", String.Empty), startDate, endDate, True, False, ExportSetType.OCSNonClient, CurrentUser.UserName)

            'Get existing HHCAHPS export sets
            Dim medicareExportSets As Collection(Of MedicareExportSet) = MedicareExportSet.GetFileGUIDsByClientGroup(SurveyType.HomeHCAHPS, "OCS", "<>", startDate, endDate)

            'Remove duplication from export sets
            Dim cleanedExportSets As Collection(Of MedicareExportSet) = ResultsCleanup(medicareExportSets)

            'Build OCS file
            Dim fileCount As Integer = ExportFile.CreateOCSExportFile(ocsMedicareExportSet, cleanedExportSets, AppConfig.Params("EMCMSOutputFolderPath").StringValue, SelectedFileType.Extension, SelectedFileType.ExportFileType, False)

            Dim crlf As String = vbCrLf & vbTab
            Dim outputPath As String = String.Format("{0}\OCS\{1}", AppConfig.Params("EMCMSOutputFolderPath").StringValue, startDate.ToString("yyyyMMM"))
            Dim message As String = String.Format("OCS NonClient export process complete.{0}File count: {1}{0}File path: {2}", crlf, fileCount, outputPath)
            MessageBox.Show(message, "Export", MessageBoxButtons.OK, MessageBoxIcon.Information)

            PopulateFileHistory()

        Finally
            Cursor.Current = Cursors.Default

        End Try

    End Sub

    Private Sub FilterToolStripButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterToolStripButton.Click

        PopulateFileHistory()

    End Sub

    Private Shared Function ResultsCleanup(ByRef medicareExportSets As System.Collections.ObjectModel.Collection(Of MedicareExportSet)) As System.Collections.ObjectModel.Collection(Of MedicareExportSet)

        Dim cleanedExportSets As New System.Collections.ObjectModel.Collection(Of MedicareExportSet)
        Dim exportSetDictionary As New Dictionary(Of Integer, Integer)

        Try

            For i As Integer = 0 To medicareExportSets.Count - 1

                Dim keyID As Integer = medicareExportSets(i).MedicareExportSetId

                If Not exportSetDictionary.ContainsKey(keyID) Then
                    exportSetDictionary.Add(keyID, i)
                Else
                    'get medicare export set index from dictionary
                    Dim index As Integer = Nothing
                    Dim valueInDictionary As Boolean = exportSetDictionary.TryGetValue(keyID, index)

                    If valueInDictionary Then
                        'get dates created for current set in loop and specific indexed export set
                        Dim indexedDateCreated As DateTime = medicareExportSets(index).DateCreated

                        If indexedDateCreated.CompareTo(medicareExportSets(i).DateCreated) = 1 Then
                            exportSetDictionary(keyID) = i
                        End If
                    End If
                End If
            Next

            For Each keypair As KeyValuePair(Of Integer, Integer) In exportSetDictionary
                cleanedExportSets.Add(medicareExportSets(keypair.Value))
            Next

        Catch ex As Exception
            Return medicareExportSets
        End Try

        Return cleanedExportSets

    End Function

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
