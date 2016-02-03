Imports Nrc.SurveyPoint.Library

Public Class UpdateEventCodesSection

#Region "Private Members"

    Private mUpdating As Boolean = False
    Private mLoading As Boolean = False
    Private mViewMode As UpdateEventCodesViewModes
    Private mFileNames As String()
    Private mLogItem As UpdateFileLog
    Private mUpdateTypes As UpdateTypeCollection

#End Region

#Region "Properties"

    Public Property FileNames() As String()
        Get
            Return mFileNames
        End Get
        Set(ByVal value As String())
            mFileNames = value
            If mFileNames.Length = 0 Then
                FileNameTextBox.Text = String.Empty
            Else
                FileNameTextBox.Text = Chr(34) & String.Join(Chr(34) & ", " & Chr(34), mFileNames) & Chr(34)
            End If
        End Set
    End Property
#End Region

#Region "Constructors"

    Public Sub New(ByVal viewMode As UpdateEventCodesViewModes)

        'Initialize the form
        InitializeComponent()

        'Save the parameters
        mViewMode = viewMode

        'Setup the form
        SetupForm()

    End Sub

    Public Sub New(ByVal viewMode As UpdateEventCodesViewModes, ByVal logItem As UpdateFileLog)

        'Initialize the form
        InitializeComponent()

        'Save the parameters
        mViewMode = viewMode
        mLogItem = logItem

        'Setup the form
        SetupForm()

    End Sub
#End Region

#Region "Baseclass Overrides"

    Public Overrides Function AllowInactivate() As Boolean

        Return Not mUpdating

    End Function

#End Region

#Region "Events"

    Private Sub UpdateCodesButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UpdateCodesButton.Click

        UpdateCodes()

    End Sub

    Private Sub UpdateTypeComboBox_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UpdateTypeComboBox.SelectedIndexChanged

        If mLoading Then Exit Sub

        LoadMappings(CType(UpdateTypeComboBox.SelectedValue, Integer), CType(EventTypeComboBox.SelectedValue, EventTypesEnum))

    End Sub

    Private Sub EventTypeComboBox_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EventTypeComboBox.SelectedIndexChanged

        If mLoading Then Exit Sub

        LoadMappings(CType(UpdateTypeComboBox.SelectedValue, Integer), CType(EventTypeComboBox.SelectedValue, EventTypesEnum))

    End Sub

    Private Sub FileNameButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FileNameButton.Click

        MissingCodesBindingSource.DataSource = Nothing

        With UpdateCodesOpenFileDialog
            'Show the open file dialog
            .ShowDialog()
            FileNames = .FileNames
        End With

        UpdateTypeComboBox.Focus()

    End Sub

    Private Sub MissingCodesExcelTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MissingCodesExcelTSButton.Click

        'Prompt user for filename
        If SaveFileDialog.ShowDialog = DialogResult.OK Then
            'Save the file
            MissingCodesGridView.ExportToXls(SaveFileDialog.FileName)
        End If

    End Sub

    Private Sub MissingCodesPrintTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MissingCodesPrintTSButton.Click

        'Open the Preview window.
        MissingCodesGrid.ShowPreview()

    End Sub

    Private Sub UpdateFileCollection_UpdateProgress(ByVal sender As Object, ByVal e As UpdateProgressEventArgs)

        UpdateCodesProgressBar.Value = e.PercentComplete
        FileCountCurrentLabel.Text = e.FileCounter.ToString
        FileCountNameLabel.Text = e.FileName
        Application.DoEvents()

    End Sub

#End Region

#Region "Private Methods"

    Private Sub SetupForm()

        Dim updateTypes As New UpdateTypeCollection

        'Set the flag to indicate we are loading the form
        mLoading = True

        'Populate the master UpdateTypes collection
        mUpdateTypes = UpdateType.GetAll

        'Setup based on view mode
        Select Case mViewMode
            Case UpdateEventCodesViewModes.FileMode
                UpdateOptionsSectionPanel.Caption = "Update Options"
                FileNameLabel.Text = "File Name(s):"
                FileNameButton.Enabled = True
                ImportDateTimePicker.Enabled = True
                updateTypes = mUpdateTypes.GetUpdateTypesByGroup(UpdateTypeGroups.Mail)

            Case UpdateEventCodesViewModes.EventLogMode
                UpdateOptionsSectionPanel.Caption = "Rerun Log Entry Options"
                FileNameLabel.Text = "Respondent ID(s):"
                FileNames = UpdateFileLog.GetUpdatedRespondents(mLogItem.FileLogID)
                FileNameButton.Enabled = False
                ImportDateTimePicker.Enabled = False
                updateTypes = mUpdateTypes.GetUpdateTypesByUpdateTypeID(mLogItem.UpdateTypeID)

        End Select

        'Disable the print button if the printing engine is not installed
        If Not MissingCodesGrid.IsPrintingAvailable Then
            MissingCodesPrintTSButton.Enabled = False
            MissingCodesExcelTSButton.Enabled = False
        End If

        'Populate the EventTypeComboBox
        With EventTypeComboBox
            .DataSource = UpdateMapping.GetEventTypes
            .DisplayMember = "Label"
            .ValueMember = "Value"
        End With

        'Populate the UpdateTypeComboBox
        With UpdateTypeComboBox
            .DataSource = updateTypes
            .DisplayMember = "Name"
            .ValueMember = "UpdateTypeID"
        End With

        ImportDateTimePicker.Value = Date.Today

        'Hide the progress bar
        HideProgressBar()

        'Set the flag to indicate we are finished loading the form
        mLoading = False

        'Populate the UpdateMappingsGrid
        LoadMappings(CType(UpdateTypeComboBox.SelectedValue, Integer), CType(EventTypeComboBox.SelectedValue, EventTypesEnum))

    End Sub

    Private Sub LoadMappings(ByVal updateTypeID As Integer, ByVal eventType As EventTypesEnum)

        UpdateMappingBindingSource.DataSource = UpdateMapping.GetByUpdateTypeIDEventType(updateTypeID, eventType)

    End Sub

    Private Sub LockControls(ByVal locked As Boolean)

        UpdateOptionsSectionPanel.Enabled = Not locked
        MissingCodesSectionPanel.Enabled = Not locked

    End Sub

    Private Sub HideProgressBar()

        UpdateCodesProgressBar.Visible = False
        FileCountLabel.Visible = False
        FileCountCurrentLabel.Visible = False
        FileCountOfLabel.Visible = False
        FileCountTotalLabel.Visible = False
        FileCountNameLabel.Visible = False

    End Sub

    Private Sub ShowProgressBarLoading()

        With UpdateCodesProgressBar
            .Visible = True
            .Value = 0
        End With
        With FileCountLabel
            .Visible = True
            .Text = "Loading Files...  Please Wait..."
        End With
        FileCountCurrentLabel.Visible = False
        FileCountOfLabel.Visible = False
        FileCountTotalLabel.Visible = False
        FileCountNameLabel.Visible = False
        Application.DoEvents()

    End Sub

    Private Sub ShowProgressBarUpdating(ByVal totalFileCnt As Integer)

        With UpdateCodesProgressBar
            .Visible = True
            .Value = 0
        End With
        With FileCountLabel
            .Visible = True
            .Text = "Updating File:"
        End With
        With FileCountCurrentLabel
            .Visible = True
            .Text = "0"
        End With
        FileCountOfLabel.Visible = True
        With FileCountTotalLabel
            .Visible = True
            .Text = totalFileCnt.ToString
        End With
        With FileCountNameLabel
            .Visible = True
            .Text = ""
        End With
        Application.DoEvents()

    End Sub

    Private Function IsValid() As Boolean

        Dim message As String = String.Empty

        If String.IsNullOrEmpty(FileNameTextBox.Text.Trim) Then
            message = "You must select one or more files to be updated!"
            FileNameTextBox.Focus()
        ElseIf UpdateTypeComboBox.SelectedIndex < 0 Then
            message = "You must select an Update Type!"
            UpdateTypeComboBox.Focus()
        ElseIf EventTypeComboBox.SelectedIndex < 0 Then
            message = "You must select an Event Type!"
            EventTypeComboBox.Focus()
        End If

        If Not String.IsNullOrEmpty(message) Then
            MessageBox.Show(message, "Update Event Codes Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False
        Else
            Return True
        End If

    End Function

    Private Sub UpdateCodes()

        'Validate the form
        If Not IsValid() Then Exit Sub

        'Lock things down
        mUpdating = True
        Dim saveCursor As Cursor = Cursor.Current
        Cursor.Current = Cursors.WaitCursor
        LockControls(True)

        'Show the progress bar
        ShowProgressBarLoading()

        'Get the specified conversions
        Dim updateMappings As UpdateMappingCollection = CType(UpdateMappingBindingSource.DataSource, UpdateMappingCollection)

        'Take action based on which view mode we are in
        Dim updateMissing As Boolean
        Dim files As New UpdateFileCollection

        Select Case mViewMode
            Case UpdateEventCodesViewModes.FileMode
                'Get the collection of files to be updated
                files = UpdateFile.GetAll(mFileNames, ImportDateTimePicker.Value)

                'Check for files with no updates
                Dim noUpdates As UpdateFileCollection = files.CheckForFilesWithNoUpdates()
                If noUpdates.Count > 0 Then
                    Dim exceptionDialog As New UpdateExceptionsDialog(noUpdates, UpdateExceptionsDialogViewModes.ViewFileNamesOnly)
                    exceptionDialog.ShowDialog()
                End If

                updateMissing = True

            Case UpdateEventCodesViewModes.EventLogMode
                'Get the collection of files to be updated
                files.Add(UpdateFile.NewUpdateFile(mLogItem))

                updateMissing = False

        End Select

        'Add the handlers for the UpdateFileCollection object
        AddHandler files.UpdateProgress, AddressOf UpdateFileCollection_UpdateProgress

        'Setup progress bar
        ShowProgressBarUpdating(files.Count)

        'Process missing codes and conversions
        MissingCodesBindingSource.DataSource = files.ProcessFiles(updateMappings, CType(UpdateTypeComboBox.SelectedValue, Integer), CurrentUser.UserName, updateMissing)

        'Check for errors
        Dim exceptions As UpdateFileCollection = files.Exceptions
        If exceptions.Count > 0 Then
            Dim exceptionDialog As New UpdateExceptionsDialog(exceptions, UpdateExceptionsDialogViewModes.ViewExpanded)
            exceptionDialog.ShowDialog()
        End If

        'Remove the handlers for the UpdateFilesCollection object
        RemoveHandler files.UpdateProgress, AddressOf UpdateFileCollection_UpdateProgress

        'Hide the progress bar
        HideProgressBar()

        'Unlock things
        LockControls(False)
        Cursor.Current = saveCursor
        mUpdating = False

    End Sub

#End Region

End Class
