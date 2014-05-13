Imports Nrc.DataLoader.Library
Imports Nrc.Qualisys.Library
Imports System.Collections.ObjectModel
Imports DevExpress.XtraGrid.Views.Grid
Imports DevExpress.XtraEditors.Controls
Imports DevExpress.XtraGrid.Views.Base

Public Class NotesSection
#Region " Constructors "
    Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        'strip the time so that the start date starts at 00:00:00 and go back a 7 days
        Me.StartDateTimePicker.Value = Now().Date.AddDays(-7)
        Me.EndDateTimePicker.Value = Now().Date
    End Sub

#End Region
    ''' <summary>Wrapps StartDateTimePicker</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property StartDate() As Date
        Get
            Return Me.StartDateTimePicker.Value
        End Get
        Set(ByVal value As Date)
            Me.StartDateTimePicker.Value = value
        End Set
    End Property

    ''' <summary>Wrapps EndDateTimePicker</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property EndDate() As Date
        Get
            Return Me.EndDateTimePicker.Value
        End Get
        Set(ByVal value As Date)
            If value >= StartDate Then
                Me.EndDateTimePicker.Value = value
            End If
        End Set
    End Property
    Private mSelectedStudies As Collection(Of QualiSys.Library.Study)
    ''' <summary>Wrapper around mNavigator.SelectedStudies. Gets updated every time a user
    ''' changes the selection in the treeview control.</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private ReadOnly Property SelectedStudies() As Collection(Of Qualisys.Library.Study)
        Get
            Return mSelectedStudies
        End Get
    End Property

    ''' <summary>Returns a comma separated list of UploadFilePackage IDs of selected rows from
    ''' UploadFilesGridView. This comma separated list is used to pass to UploadFilePackageNote business
    ''' Object to retrieve the corresponding notes.</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private ReadOnly Property SelectedUploadFilePackageIDs() As String
        Get
            Dim SelectedUploadFilePackagesStringBuilder As New System.Text.StringBuilder
            For Each item As UploadFilePackageDisplay In SelectedUploadFilePackages
                SelectedUploadFilePackagesStringBuilder.Append(item.UploadFilePackageID)
                SelectedUploadFilePackagesStringBuilder.Append(",")
            Next
            Dim SelectedList As String = SelectedUploadFilePackagesStringBuilder.ToString
            If Not String.IsNullOrEmpty(SelectedList) Then
                SelectedList = SelectedList.Substring(0, SelectedList.Length - 1)
            End If
            Return SelectedList
        End Get
    End Property

    Dim mSelectedUploadFilePackages As List(Of UploadFilePackageDisplay)
    ''' <summary>Returns a list of UploadFilePackageDisplay objects from 
    ''' UploadedFilesGridView selected rows.</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private ReadOnly Property SelectedUploadFilePackages() As List(Of UploadFilePackageDisplay)
        Get
            If mSelectedUploadFilePackages Is Nothing Then
                mSelectedUploadFilePackages = New List(Of UploadFilePackageDisplay)
                Dim SelectedUploadFilePackagesStringBuilder As New System.Text.StringBuilder
                Dim selectedRows As Integer() = Me.UploadedFilesGridView.GetSelectedRows()
                Dim i As Integer = 0

                For Each i In selectedRows
                    Dim curRow As UploadFilePackageDisplay = DirectCast(UploadedFilesGridView.GetRow(i), UploadFilePackageDisplay)
                    mSelectedUploadFilePackages.Add(curRow)
                Next
            End If
            Return mSelectedUploadFilePackages
        End Get
    End Property
    ''' <summary>Converts SelectedStudies() into a comma separated list of Study ids.</summary>
    ''' <returns>Comma separated list of Study ids as a string.</returns>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function GetCommaSeparatedStudyIDs() As String
        If SelectedStudies Is Nothing Then Return String.Empty

        Dim StudyList As New System.Text.StringBuilder
        For Each Stdy As Study In SelectedStudies
            StudyList.Append(Stdy.Id.ToString)
            StudyList.Append(",")
        Next
        Dim CommaSeparatedList As String = StudyList.ToString
        If Not String.IsNullOrEmpty(CommaSeparatedList) Then
            CommaSeparatedList = CommaSeparatedList.Remove(CommaSeparatedList.LastIndexOf(","c))
        End If
        Return CommaSeparatedList
    End Function
    ''' <summary>Prepares the DataSource for uploaded files grid.</summary>
    ''' <returns>UploadFilePackageDisplayCollection</returns>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function GetUploadFilePackageDisplayDataSource() As UploadFilePackageDisplayCollection
        Return UploadFilePackageDisplay.GetByStudiesAndDateRange(GetCommaSeparatedStudyIDs(), Me.StartDate, Me.EndDate)
    End Function
#Region " Private Instance Fields "
    Private WithEvents mNavigator As AdminNotesNavigator
#End Region
#Region " Overrides "
    ''' <summary>Saves the reference to the AdminNotesNavigator in a local private variable (mNavigator)</summary>
    ''' <param name="navCtrl"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        Dim nav As AdminNotesNavigator = TryCast(navCtrl, AdminNotesNavigator)
        If nav Is Nothing Then
            Throw New ArgumentException("The NotesSection class expects a navigation control of type AdminNotesNavigator")
        End If

        Me.mNavigator = nav
    End Sub
    Public Overrides Function AllowInactivate() As Boolean
        Return MyBase.AllowInactivate()
    End Function
#End Region

    ''' <summary>Handles SelectionChanged event of AdminNotesNavigator which fires every time 
    ''' user changes the selected studies in the navigator treeview control.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub mNavigator_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles mNavigator.SelectionChanged
        mSelectedStudies = Me.mNavigator.SelectedStudies
        RefreshUploadFilePackageTree()
    End Sub

    ''' <summary>Opens an editor window to add a note</summary>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub AddNewNote()
        'Throw New NotImplementedException("To be implemented")
        Dim sel As List(Of UploadFilePackageDisplay) = SelectedUploadFilePackages
        Dim AddNoteDialog As New AddNoteDialog(sel)
        If AddNoteDialog.ShowDialog() = DialogResult.OK Then
            'We just saved a new note.
            RefreshNotes()
        End If
    End Sub
    ''' <summary>Event handler. Displays AddNoteDialog to add a note to the UploadFilePackageNote table.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub AddNewNoteButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddNewNoteButton.Click
        AddNewNote()
    End Sub
    ''' <summary>Rebinds the notes grid. Notes grid content dpends on UploadedFilesGridView row selection </summary>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub RefreshNotes()
        Me.UploadedFileNotesDisplayBindingSource.DataSource = UploadFilePackageNoteDisplay.SelectUploadFilePackageNoteDisplaysByUploadFilePackageIDs(Me.SelectedUploadFilePackageIDs)
    End Sub

    Private Sub UploadedFilesGridView_CalcRowHeight(ByVal sender As Object, ByVal e As DevExpress.XtraGrid.Views.Grid.RowHeightEventArgs) Handles UploadedFilesGridView.CalcRowHeight
    End Sub

    ''' <summary>Updates the Notes since the selection is changed.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub UploadedFilesGridView_SelectionChanged(ByVal sender As Object, ByVal e As DevExpress.Data.SelectionChangedEventArgs) Handles UploadedFilesGridView.SelectionChanged
        mSelectedUploadFilePackages = Nothing
        RefreshNotes()
    End Sub

    ''' <summary>DateTimePicker control event handler.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub StartDateTimePicker_ValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StartDateTimePicker.ValueChanged
        Me.StartDateTimePicker.MaxDate = Me.EndDateTimePicker.Value
        Me.EndDateTimePicker.MinDate = Me.StartDateTimePicker.Value
        RefreshUploadFilePackageTree()
    End Sub

    ''' <summary>DateTimePicker control event handler.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub EndDateTimePicker_ValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EndDateTimePicker.ValueChanged
        Me.StartDateTimePicker.MaxDate = Me.EndDateTimePicker.Value
        Me.EndDateTimePicker.MinDate = Me.StartDateTimePicker.Value
        RefreshUploadFilePackageTree()
    End Sub
    ''' <summary>Refreshes both of the grids (uploaded files grid and notes grid</summary>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub RefreshUploadFilePackageTree()
        mSelectedUploadFilePackages = Nothing
        Me.UploadFilePackageDisplayBindingSource.DataSource = GetUploadFilePackageDisplayDataSource()
        RefreshNotes()
    End Sub

    '' <summary>Opens AddNoteDialog in view mode</summary>
    ''' <CreateBy>Steve Kennedy</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub UploadedFileNotesGrid_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles UploadedFileNotesGrid.DoubleClick
        If UploadedFileNotesGridView.GetFocusedValue IsNot Nothing Then
            Dim NoteText As String = UploadedFileNotesGridView.GetFocusedValue.ToString
            Dim NoteViewDialog As AddNoteDialog = New AddNoteDialog(NoteText)
            NoteViewDialog.ShowDialog()
        End If
    End Sub


    '' <summary>Export Grid Contents to Excel;Copied from HCMG Manual Coding</summary>
    ''' <CreateBy>Steve Kennedy</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ExportToXLSToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportToXLSToolStripButton.Click

        SaveFileDialog.Filter = "Excel files (*.xls)|*.xls|All files (*.*)|*.*"
        SaveFileDialog.FilterIndex = 1
        SaveFileDialog.RestoreDirectory = True
        If SaveFileDialog.ShowDialog() = DialogResult.OK Then
            Me.UploadedFilesGrid.MainView.ExportToXls(SaveFileDialog.FileName)
        End If

    End Sub
    '' <summary>Export Grid Contents to Excel;Copied from HCMG Manual Coding</summary>
    ''' <CreateBy>Steve Kennedy</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>

    Private Sub ExportNotesToXLSToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportNotesToXLSToolStripButton.Click
        SaveFileDialog.Filter = "Excel files (*.xls)|*.xls|All files (*.*)|*.*"
        SaveFileDialog.FilterIndex = 1
        SaveFileDialog.RestoreDirectory = True
        If SaveFileDialog.ShowDialog() = DialogResult.OK Then
            Me.UploadedFileNotesGrid.MainView.ExportToXls(SaveFileDialog.FileName)
        End If
    End Sub

    ''' <summary>Handles the "Add New Note" menu item click event.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub tsmiAddNote_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tsmiAddNote.Click
        AddNewNote()
    End Sub

    ''' <summary>This menustrip event handler checks to see if there is a selected 
    ''' upload file in the UploadedFilesGridView and if none is selected then cancells the popup.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cmnAddNote_Opening(ByVal sender As System.Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles cmnAddNote.Opening
        If Me.UploadedFilesGridView.SelectedRowsCount <= 0 Then e.Cancel = True
    End Sub
End Class
