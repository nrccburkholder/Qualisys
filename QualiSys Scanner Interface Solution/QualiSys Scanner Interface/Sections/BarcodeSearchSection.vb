Imports Nrc.QualiSys.Scanning.Library
Imports System.Collections.ObjectModel

Public Class BarcodeSearchSection

#Region "Private Members"

    Private mCanceling As Boolean = False
    Private mSearchActive As Boolean = False

    Private mBarcodeSearchNavigator As BarcodeSearchNavigator
    Private WithEvents mBarcodeSearchResults As BarcodeSearchResultCollection

#End Region

#Region "Events"

    Public Event BarcodeFileSearchBegin As EventHandler(Of BarcodeFileSearchBeginEventArgs)
    Public Event BarcodeFileSearchComplete As EventHandler(Of BarcodeFileSearchCompleteEventArgs)

#End Region

#Region "Base Class Overrides"

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        'Call into the base class
        MyBase.RegisterNavControl(navCtrl)

        'Save a reference to the navigator
        mBarcodeSearchNavigator = TryCast(navCtrl, BarcodeSearchNavigator)

    End Sub

    Public Overrides Sub ActivateSection()

        Me.SuspendLayout()

        'Call into the base class
        MyBase.ActivateSection()

        'Initialize the screen
        FAQSSLocationProductionRadioButton.Checked = True
        TemplatePatternTextBox.Text = "*"
        BatchDateRangeCheckBox.Checked = True
        BatchDateRangeFromDateTimePicker.Value = Date.Today.AddMonths(-1)
        BatchDateRangeToDateTimePicker.Value = Date.Today
        BarcodeListBox.Items.Clear()
        BarcodeTextBox.Text = String.Empty
        PartialBarcodeCheckBox.Checked = False
        PartialStartingPositionNumericUpDown.Value = 1
        PartialExactRadioButton.Checked = True
        SearchResultsSectionPanel.Enabled = False

        'Populate the archive folder combo box
        Dim archiveFolders As List(Of String) = BarcodeSearchResultCollection.GetArchiveFolders(True)
        If archiveFolders.Count > 0 Then
            FAQSSLocationArchiveComboBox.DataSource = archiveFolders
            FAQSSLocationArchiveRadioButton.Enabled = True
        Else
            FAQSSLocationArchiveComboBox.DataSource = archiveFolders
            FAQSSLocationArchiveRadioButton.Enabled = False
        End If

        'Clear the grid
        mBarcodeSearchResults = Nothing
        BarcodeSearchResultBindingSource.DataSource = Nothing

        Me.ResumeLayout()

    End Sub

    Public Overrides Sub InactivateSection()

        'Call into the base class
        MyBase.InactivateSection()

    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        If mSearchActive Then
            Return False
        Else
            Return True
        End If

    End Function

#End Region

#Region "Event Handlers"

#Region "Event Handlers - Main"

    Private Sub FAQSSLocationProductionRadioButton_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FAQSSLocationProductionRadioButton.CheckedChanged

        If FAQSSLocationProductionRadioButton.Checked Then
            FAQSSLocationArchiveComboBox.Enabled = False
        End If

    End Sub

    Private Sub FAQSSLocationArchiveRadioButton_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FAQSSLocationArchiveRadioButton.CheckedChanged

        If FAQSSLocationArchiveRadioButton.Checked Then
            FAQSSLocationArchiveComboBox.Enabled = True
        End If

    End Sub

    Private Sub BatchDateRangeCheckBox_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BatchDateRangeCheckBox.CheckedChanged

        With BatchDateRangeCheckBox
            BatchDateRangeFromLabel.Enabled = .Checked
            BatchDateRangeFromDateTimePicker.Enabled = .Checked
            BatchDateRangeToLabel.Enabled = .Checked
            BatchDateRangeToDateTimePicker.Enabled = .Checked
        End With

    End Sub

    Private Sub PartialBarcodeCheckBox_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles PartialBarcodeCheckBox.CheckedChanged

        With PartialBarcodeCheckBox
            PartialStartingPositionNumericUpDown.Enabled = .Checked
            PartialExactRadioButton.Enabled = .Checked
            PartialAfterRadioButton.Enabled = .Checked
        End With

    End Sub

    Private Sub BarcodeAddButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BarcodeAddButton.Click

        If Not BarcodeTextBox.Text.Length = 0 Then
            'Check to see if this entry already exists
            If BarcodeListBox.FindStringExact(BarcodeTextBox.Text.ToUpper) = ListBox.NoMatches Then
                BarcodeListBox.Items.Add(BarcodeTextBox.Text.ToUpper)
            End If
        End If

        BarcodeTextBox.Text = String.Empty
        BarcodeTextBox.Focus()

    End Sub

    Private Sub BarcodePasteButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BarcodePasteButton.Click

        'Get the clipboard data object
        Dim data As IDataObject = Clipboard.GetDataObject

        'Check to see if there is any data in text format, converting it if necessary.
        If data.GetDataPresent(DataFormats.Text, True) Then
            'Get the contents of the clipboard as a string
            Dim lithos As String = data.GetData(DataFormats.Text, True).ToString

            'Setup the array of separators
            Dim separators As String() = {vbCrLf, ","}

            'Split the clipboard data into individual strings and insert them into the listbox
            Dim lithoList As String() = lithos.Split(separators, StringSplitOptions.RemoveEmptyEntries)
            For Each litho As String In lithoList
                If litho.Trim.Length > 0 Then
                    BarcodeListBox.Items.Add(litho.ToUpper)
                End If
            Next
        End If

    End Sub

    Private Sub BarcodeTextBox_KeyDown(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles BarcodeTextBox.KeyDown

        If e.KeyData = Keys.Enter Then
            BarcodeAddButton.PerformClick()
            e.Handled = True
        End If

    End Sub

#End Region

#Region "Event Handlers - SearchCriteriaToolStrip"

    Private Sub SearchCriteriaSearchTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SearchCriteriaSearchTSButton.Click

        Dim message As String = String.Empty

        If SearchCriteriaSearchTSButton.Text = "Search" Then
            'Validate the screen
            If TemplatePatternTextBox.Text.Trim.Length = 0 Then
                message = "Template Pattern cannot be blank!"
            ElseIf BarcodeListBox.Items.Count = 0 Then
                message = "You must provide at least one barcode to search for!"
            ElseIf FAQSSLocationArchiveRadioButton.Checked AndAlso FAQSSLocationArchiveComboBox.SelectedIndex < 0 Then
                message = "You must select an Archive Folder!"
            End If
            If message.Length > 0 Then
                MessageBox.Show(message, "Invalid Entry", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Exit Sub
            End If

            'We are going to do a search so set things up
            mCanceling = False
            mSearchActive = True
            SearchCriteriaSearchTSButton.Text = "Cancel Search"
            SearchCriteriaClearTSButton.Enabled = False
            PathInfoGroupBox.Enabled = False
            BarcodeInfoGroupBox.Enabled = False
            LocationInfoGroupBox.Enabled = False
            SearchResultsSectionPanel.Enabled = False

            'Clear the grid
            mBarcodeSearchResults = Nothing
            BarcodeSearchResultBindingSource.DataSource = Nothing

            'Set the cursor
            Me.Cursor = Cursors.WaitCursor
            mBarcodeSearchNavigator.SearchMoviePictureBox.Visible = True
            mBarcodeSearchNavigator.SearchMoviePictureBox.Refresh()

            'Get the screen input
            Dim faqssLocation As FAQSSLocation
            Dim archiveFolder As String
            If FAQSSLocationArchiveRadioButton.Checked Then
                faqssLocation = QualiSys.Scanning.Library.FAQSSLocation.Archive
                archiveFolder = FAQSSLocationArchiveComboBox.SelectedItem.ToString
            Else
                faqssLocation = QualiSys.Scanning.Library.FAQSSLocation.Production
                archiveFolder = String.Empty
            End If

            Dim searchStrings As New List(Of String)
            For Each item As Object In BarcodeListBox.Items
                searchStrings.Add(item.ToString)
            Next

            'Let's perform the search
            mBarcodeSearchResults = New BarcodeSearchResultCollection
            mBarcodeSearchResults.Populate(faqssLocation, archiveFolder, TemplatePatternTextBox.Text, _
                                           BatchDateRangeCheckBox.Checked, BatchDateRangeFromDateTimePicker.Value, _
                                           BatchDateRangeToDateTimePicker.Value, searchStrings, PartialBarcodeCheckBox.Checked, _
                                           CType(PartialStartingPositionNumericUpDown.Value, Integer), PartialExactRadioButton.Checked)
            BarcodeSearchResultBindingSource.DataSource = mBarcodeSearchResults
            SearchResultsSectionPanel.Enabled = True

        Else
            'The user has clicked on cancel so clean up and we are out of here
            mCanceling = True

        End If

        'Reset the cursor
        mSearchActive = False
        SearchCriteriaSearchTSButton.Text = "Search"
        SearchCriteriaClearTSButton.Enabled = True
        PathInfoGroupBox.Enabled = True
        BarcodeInfoGroupBox.Enabled = True
        LocationInfoGroupBox.Enabled = True
        Me.Cursor = Cursors.Default
        mBarcodeSearchNavigator.SearchMoviePictureBox.Visible = False
        RaiseEvent BarcodeFileSearchComplete(sender, New BarcodeFileSearchCompleteEventArgs())

    End Sub

    Private Sub SearchCriteriaClearTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SearchCriteriaClearTSButton.Click

        ActivateSection()

    End Sub

#End Region

#Region "Event Handlers - SearchResultsToolStrip"

    Private Sub SearchResultsCreateStrTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SearchResultsCreateStrTSButton.Click

        If BarcodeSearchResultBindingSource.DataSource Is Nothing OrElse BarcodeSearchResultBindingSource.List.Count = 0 Then Exit Sub

        With SaveFileDialog
            .Title = "Create STR File"
            .DefaultExt = "str"
            .FileName = String.Empty
            .Filter = "FAQSS String Files (*.str)|*.str"
            If .ShowDialog() = DialogResult.OK Then
                Me.Cursor = Cursors.WaitCursor
                mBarcodeSearchResults.CreateSTRFile(.FileName)
                Me.Cursor = Cursors.Default
            End If
        End With

    End Sub

    Private Sub SearchResultsExcelTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SearchResultsExcelTSButton.Click

        If BarcodeSearchResultBindingSource.DataSource Is Nothing OrElse BarcodeSearchResultBindingSource.List.Count = 0 Then Exit Sub

        With SaveFileDialog
            .Title = "Export To Excel"
            .DefaultExt = "xls"
            .FileName = String.Empty
            .Filter = "Excel Files (*.xls)|*.xls"
            If .ShowDialog() = DialogResult.OK Then
                Me.Cursor = Cursors.WaitCursor
                colSelected.Visible = False
                Dim ExportOptions As New DevExpress.XtraPrinting.XlsExportOptions(DevExpress.XtraPrinting.TextExportMode.Text)
                SearchResultsGridView.ExportToXls(.FileName, ExportOptions)
                colSelected.Visible = True
                Me.Cursor = Cursors.Default
            End If
        End With

    End Sub

    Private Sub SearchResultsCheckTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SearchResultsCheckTSButton.Click

        Dim searchResults As BarcodeSearchResultCollection = DirectCast(BarcodeSearchResultBindingSource.DataSource, BarcodeSearchResultCollection)
        If Not (searchResults Is Nothing) Then
            For Each searchResult As BarcodeSearchResult In searchResults
                searchResult.Selected = True
            Next
            BarcodeSearchResultBindingSource.ResetBindings(False)
        End If

    End Sub

    Private Sub SearchResultsUncheckTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SearchResultsUncheckTSButton.Click

        Dim searchResults As BarcodeSearchResultCollection = DirectCast(BarcodeSearchResultBindingSource.DataSource, BarcodeSearchResultCollection)
        If Not (searchResults Is Nothing) Then
            For Each searchResult As BarcodeSearchResult In searchResults
                searchResult.Selected = False
            Next
            BarcodeSearchResultBindingSource.ResetBindings(False)
        End If

    End Sub

#End Region

#Region "Event Handlers - SearchResultsGridView"

    Private Sub RepositoryItemCheckEdit_EditValueChanging(ByVal sender As Object, ByVal e As DevExpress.XtraEditors.Controls.ChangingEventArgs) Handles RepositoryItemCheckEdit.EditValueChanging

        Dim selectedRow As Integer = SearchResultsGridView.GetSelectedRows(0)
        Dim searchResult As BarcodeSearchResult = DirectCast(SearchResultsGridView.GetRow(selectedRow), BarcodeSearchResult)

        searchResult.Selected = CBool(e.NewValue)

    End Sub

#End Region

#Region "Envent Handlers - BarcodeListBoxContextMenu"

    Private Sub BarcodeListBoxEditTSMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BarcodeListBoxEditTSMenuItem.Click

        If Not BarcodeListBox.SelectedItem Is Nothing Then
            'Add the currently selected item to the textbox
            BarcodeTextBox.Text = BarcodeListBox.SelectedItem.ToString

            'Remove the currently selected item from the listbox
            BarcodeListBox.Items.Remove(BarcodeListBox.SelectedItem)
        End If

    End Sub

    Private Sub BarcodeListBoxRemoveTSMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BarcodeListBoxRemoveTSMenuItem.Click

        If Not BarcodeListBox.SelectedItem Is Nothing Then
            'Remove the currently selected item from the listbox
            BarcodeListBox.Items.Remove(BarcodeListBox.SelectedItem)
        End If

    End Sub

    Private Sub BarcodeListBoxClearTSMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BarcodeListBoxClearTSMenuItem.Click

        BarcodeListBox.Items.Clear()

    End Sub

#End Region

#Region "Event Handlers - mBarcodeSearchResults"

    Private Sub mBarcodeSearchResults_BarcodeFileSearchComplete(ByVal sender As Object, ByVal e As QualiSys.Scanning.Library.BarcodeFileSearchCompleteEventArgs) Handles mBarcodeSearchResults.BarcodeFileSearchComplete

        e.Cancel = mCanceling
        Application.DoEvents()

    End Sub

    Private Sub mBarcodeSearchResults_BarcodeFileSearchBegin(ByVal sender As Object, ByVal e As QualiSys.Scanning.Library.BarcodeFileSearchBeginEventArgs) Handles mBarcodeSearchResults.BarcodeFileSearchBegin

        RaiseEvent BarcodeFileSearchBegin(sender, e)
        e.Cancel = mCanceling
        Application.DoEvents()

    End Sub

#End Region

#End Region
End Class
