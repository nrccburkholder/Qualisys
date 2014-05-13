Imports Nrc.QualiSys.Library
Imports Nrc.QualiSys.Scanning.Library

Public Class TransferResultsFileSection

#Region " Private Members "

    Private mNode As TransferResultsFileNode
    Private mDataLoad As DataLoad
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

        'Initialize the form
        InitializeComponent()

        'Save the parameters
        mErrorCodes = errorCodes

        'Setup the Image List
        With FileImageList.Images
            .Add(TransferResultsImageKeys.SectionOK, My.Resources.Validation16)
            .Add(TransferResultsImageKeys.SectionError, My.Resources.NoWay16)
        End With

    End Sub

#End Region

#Region " Events "

    Private Sub FileDetailExcelTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FileDetailExcelTSButton.Click

        'Setup the file save control
        FileDetailSaveFileDialog.Filter = "Excel files (*.xls)|*.xls|All files (*.*)|*.*"
        FileDetailSaveFileDialog.FilterIndex = 1
        FileDetailSaveFileDialog.RestoreDirectory = True

        'Show the file save dialog
        If FileDetailSaveFileDialog.ShowDialog() = DialogResult.OK Then
            BadLithoCodeDataGridView.ExportToXls(FileDetailSaveFileDialog.FileName)
        End If

    End Sub

#End Region

#Region " Public Methods "

    Public Sub InitializeSection(ByVal node As TransferResultsFileNode)

        'Save the parameters
        mNode = node
        mDataLoad = DataLoad.Get(node.Source.DataLoadID)

        'Set the section caption
        FileInfoSectionPanel.Caption = String.Format("File Information: {0} ({1}) - {2} ({3})", mNode.Source.VendorName, mNode.Source.VendorID, mDataLoad.DisplayName, mDataLoad.DataLoadId)

        'Populate the Information Section
        OriginalFileNameTextBox.Text = mDataLoad.OrigFileName
        DisplayNameTextBox.Text = mDataLoad.DisplayName
        DateLoadedTextBox.Text = mDataLoad.DateLoaded.ToString("MM/dd/yyyy HH:mm:ss")
        SurveyCountTextBox.Text = mDataLoad.Surveys.Count.ToString
        RecordCountTextBox.Text = mDataLoad.TotalRecordsLoaded.ToString
        DispositionUpdateTextBox.Text = mDataLoad.TotalDispositionUpdateRecords.ToString

        'Setup the tabs
        SetTabErrorInfo(BadLithoCodeDataTabPage, mDataLoad.BadLithoCodes.Count, "Bad Litho Code Data")

        'Setup the grids
        BadLithoCodeDataBindingSource.DataSource = mDataLoad.BadLithoCodes
        BadLithoCodeDataGrid.DataSource = BadLithoCodeDataBindingSource

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

#End Region

End Class
