Imports Nrc.QualiSys.Library
Imports Nrc.QualiSys.Scanning.Library

Public Class TransferResultsSurveySection

#Region " Private Members "

    Private mIsInitializing As Boolean = False
    Private mFilterMode As TransferResultsFilterModes

    Private mNode As TransferResultsSurveyNode
    Private mSurveyDataLoad As SurveyDataLoad
    Private mErrorCodes As ErrorCodeCollection

#End Region

#Region " Base Class Overrides "

    Public Overrides Sub ActivateSection()

    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        'We do not allow saving yet so always return true
        Return True

    End Function

    Public Overrides Sub InactivateSection()

    End Sub

#End Region

#Region " Constructors "

    Public Sub New(ByVal errorCodes As ErrorCodeCollection)

        mIsInitializing = True

        'Initialize the form
        InitializeComponent()

        'Save the parameters
        mErrorCodes = errorCodes

        'Setup the Image List
        With SurveyImageList.Images
            .Add(TransferResultsImageKeys.SectionOK, My.Resources.Validation16)
            .Add(TransferResultsImageKeys.SectionError, My.Resources.NoWay16)
        End With

        'Populate the filter combobox
        SetFilterMode(DirectCast(My.Settings.TransferResultsSectionFilterMode, TransferResultsFilterModes))
        Dim filterList As New List(Of ListItem(Of TransferResultsFilterModes))
        With filterList
            .Add(New ListItem(Of TransferResultsFilterModes)("<All>", TransferResultsFilterModes.All))
            .Add(New ListItem(Of TransferResultsFilterModes)("Errors", TransferResultsFilterModes.Errors))
        End With
        With SurveyDetailFilterComboBox
            .DataSource = filterList
            .DisplayMember = "Label"
            .ValueMember = "Value"
            .SelectedValue = mFilterMode
        End With

        mIsInitializing = False

    End Sub

#End Region

#Region " Events "

    Private Sub SurveyDetailFilterComboBox_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SurveyDetailFilterComboBox.SelectedIndexChanged

        If mIsInitializing Then Exit Sub

        SetFilterMode(DirectCast(SurveyDetailFilterComboBox.SelectedValue, TransferResultsFilterModes))
        PopulateGrids()

    End Sub

    Private Sub SurveyDetailExcelTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SurveyDetailExcelTSButton.Click

        With SurveyDetailSaveFileDialog
            'Setup the file save control
            .Filter = "Excel files (*.xls)|*.xls|All files (*.*)|*.*"
            .FilterIndex = 1
            .RestoreDirectory = True

            'Show the file save dialog
            If .ShowDialog() = DialogResult.OK Then
                If SurveyDetailTabControl.SelectedTab Is LithoCodeDataTabPage Then
                    LithoCodeDataGridView.ExportToXls(.FileName)

                ElseIf SurveyDetailTabControl.SelectedTab Is BubbleDataTabPage Then
                    BubbleDataGridView.ExportToXls(.FileName)

                ElseIf SurveyDetailTabControl.SelectedTab Is CommentDataTabPage Then
                    CommentDataGridView.ExportToXls(.FileName)

                ElseIf SurveyDetailTabControl.SelectedTab Is HandEntryDataTabPage Then
                    HandEntryDataGridView.ExportToXls(.FileName)

                ElseIf SurveyDetailTabControl.SelectedTab Is PopMapDataTabPage Then
                    PopMapDataGridView.ExportToXls(.FileName)

                ElseIf SurveyDetailTabControl.SelectedTab Is DispositionDataTabPage Then
                    DispositionDataGridView.ExportToXls(.FileName)

                End If
            End If
        End With

    End Sub

    Private Sub BubbleDataGridView_DataSourceChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles BubbleDataGridView.DataSourceChanged

        If BubbleDataGridView.Columns("Litho Code") IsNot Nothing Then
            With BubbleDataGridView.Columns("Litho Code")
                .Fixed = DevExpress.XtraGrid.Columns.FixedStyle.Left
                .Width = 100
            End With
        End If

    End Sub

    Private Sub CommentDataGridView_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles CommentDataGridView.DoubleClick

        If CommentDataGridView.FocusedColumn Is CommentDataCmntTextColumn Then
            Dim cmntForm As New ViewCommentForm(CType(CommentDataGridView.GetFocusedDisplayText, String))
            Dim cmnt As LithoCommentDisplay = CType(CommentDataGridView.GetRow(CommentDataGridView.FocusedRowHandle), LithoCommentDisplay)
            If cmnt IsNot Nothing Then
                cmntForm.Text = String.Format("View Comment for LithoCode: {0} QstnCore: {1}", cmnt.LithoCodeValue, cmnt.CommentNumber)
            End If
            cmntForm.ShowDialog(Me)
        End If

    End Sub

#End Region

#Region " Public Methods "

    Public Sub InitializeSection(ByVal node As TransferResultsSurveyNode)

        'Save the parameters
        mNode = node
        mSurveyDataLoad = SurveyDataLoad.Get(node.Source.SurveyDataLoadID)

        'Set the section caption
        SurveyInfoSectionPanel.Caption = String.Format("Survey Information: {0} ({1}) - {2} ({3}) - {4} ({5})", mNode.Source.VendorName, mNode.Source.VendorID, mNode.Source.DataLoadName, mNode.Source.DataLoadID, mNode.Source.SurveyName, mNode.Source.SurveyID)

        'Populate the Information Section
        ClientTextBox.Text = mSurveyDataLoad.Survey.Study.Client.DisplayLabel
        StudyTextBox.Text = mSurveyDataLoad.Survey.Study.DisplayLabel
        SurveyTextBox.Text = mSurveyDataLoad.Survey.DisplayLabel
        LithoCountTextBox.Text = mSurveyDataLoad.LithoCodes.Count.ToString
        LithoErrorCountTextBox.Text = mSurveyDataLoad.DistinctLithoCountWithErrors.ToString
        TotalErrorCountTextBox.Text = mSurveyDataLoad.TotalErrorCount.ToString

        'Setup the tabs
        SetTabErrorInfo(LithoCodeDataTabPage, mSurveyDataLoad.LithoErrorCount, "Litho Code")
        SetTabErrorInfo(BubbleDataTabPage, mSurveyDataLoad.QuestionResultErrorCount, "Bubble Data")
        SetTabErrorInfo(CommentDataTabPage, mSurveyDataLoad.CommentErrorCount, "Comments")
        SetTabErrorInfo(HandEntryDataTabPage, mSurveyDataLoad.HandEntryErrorCount, "Hand Entry Data")
        SetTabErrorInfo(PopMapDataTabPage, mSurveyDataLoad.PopMappingErrorCount, "Pop Map Data")
        SetTabErrorInfo(DispositionDataTabPage, mSurveyDataLoad.DispositionErrorCount, "Dispositions")

        'Setup the grids
        PopulateGrids()

    End Sub

#End Region

#Region " Private Methods "

    Private Sub SetTabErrorInfo(ByVal tab As TabPage, ByVal errorCount As Integer, ByVal tabText As String)

        If errorCount > 0 Then
            tab.ImageKey = TransferResultsImageKeys.SectionError
            tab.Text = String.Format("{0} ({1})", tabText, errorCount.ToString)
        Else
            tab.ImageKey = TransferResultsImageKeys.SectionOK
            tab.Text = tabText
        End If

    End Sub

    Private Sub PopulateGrids()

        Dim showErrorsOnly As Boolean = True

        'Determine the filter mode
        Select Case DirectCast(SurveyDetailFilterComboBox.SelectedValue, TransferResultsFilterModes)
            Case TransferResultsFilterModes.Errors
                showErrorsOnly = True

            Case Else
                showErrorsOnly = False

        End Select

        'Populate all of the grid controls
        LithoCodeDataBindingSource.DataSource = mSurveyDataLoad.LithoCodes.GetLithoDisplayList(showErrorsOnly, mErrorCodes)
        LithoCodeDataGrid.DataSource = LithoCodeDataBindingSource

        BubbleDataGridView.Columns.Clear()
        BubbleDataBindingSource.DataSource = mSurveyDataLoad.LithoCodes.GetBubbleDataTable(showErrorsOnly, mErrorCodes)
        BubbleDataGrid.DataSource = BubbleDataBindingSource

        CommentDataBindingSource.DataSource = mSurveyDataLoad.LithoCodes.GetLithoCommentDisplayList(showErrorsOnly, mErrorCodes)
        CommentDataGrid.DataSource = CommentDataBindingSource

        HandEntryDataBindingSource.DataSource = mSurveyDataLoad.LithoCodes.GetLithoHandEntryDisplayList(showErrorsOnly, mErrorCodes)
        HandEntryDataGrid.DataSource = HandEntryDataBindingSource

        PopMapDataBindingSource.DataSource = mSurveyDataLoad.LithoCodes.GetLithoPopMappingDisplayList(showErrorsOnly, mErrorCodes)
        PopMapDataGrid.DataSource = PopMapDataBindingSource

        DispositionDataBindingSource.DataSource = mSurveyDataLoad.LithoCodes.GetLithoDispositionDisplayList(showErrorsOnly, mErrorCodes)
        DispositionDataGrid.DataSource = DispositionDataBindingSource

    End Sub

    Private Sub SetFilterMode(ByVal filterMode As TransferResultsFilterModes)

        'Save the setting
        mFilterMode = filterMode
        My.Settings.TransferResultsSectionFilterMode = CInt(filterMode)

    End Sub

#End Region

End Class
