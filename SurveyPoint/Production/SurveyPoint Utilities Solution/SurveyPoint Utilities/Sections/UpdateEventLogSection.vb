Imports Nrc.SurveyPoint.Library

Public Class UpdateEventLogSection

#Region "Private Members"

    Private mParentSection As UpdateEventSection

#End Region

#Region "Baseclass Overrides"

    Public Overrides Sub ActivateSection()

    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        Return True

    End Function

    Public Overrides Sub InactivateSection()

    End Sub

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

    End Sub

#End Region

#Region "Constructors"

    Public Sub New(ByVal parent As UpdateEventSection)

        'Initialize the form
        InitializeComponent()

        'Save the parameters
        mParentSection = parent

    End Sub

#End Region

#Region "Events"

    Private Sub UpdateEventLogSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Disable the print button if the printing engine is not installed
        If Not UpdateEventLogGrid.IsPrintingAvailable Then
            UpdateEventLogPrintTSButton.Enabled = False
            UpdateEventLogExcelTSButton.Enabled = False
        End If

        'Set the date range
        Dim maxDate As Date = Date.Now.Date.Add(New TimeSpan(23, 59, 59))
        Dim minDate As Date = Date.Now.Date.AddMonths(-1)
        MinDateTimePicker.Value = minDate
        MaxDateTimePicker.Value = maxDate

        'Load the data
        UpdateEventLogBindingSource.DataSource = UpdateFileLog.GetByDate(minDate, maxDate)

    End Sub

    Private Sub UpdateEventLogExcelTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UpdateEventLogExcelTSButton.Click

        'Prompt user for filename
        If SaveFileDialog.ShowDialog = DialogResult.OK Then
            'Save the file
            UpdateEventLogGridView.ExportToXls(SaveFileDialog.FileName)
        End If

    End Sub

    Private Sub UpdateEventLogPrintTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UpdateEventLogPrintTSButton.Click

        'Opens the Preview window.
        UpdateEventLogGrid.ShowPreview()

    End Sub

    Private Sub UpdateEventLogRerunTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UpdateEventLogRerunTSButton.Click

        'Get the currently selected record
        Dim logItem As UpdateFileLog = TryCast(UpdateEventLogBindingSource.Current, UpdateFileLog)

        'Check to see if the user had an entry selected
        If logItem Is Nothing Then
            MessageBox.Show("You must select the log entry to be reran!", "Rerun Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        ElseIf logItem.NumUpdated = 0 Then
            MessageBox.Show("The selected log entry does not contain any records to be updated!", "Rerun Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        ElseIf MessageBox.Show(String.Format("You have selected the following file to be reran:{0}{0}File: {1}{2}{0}Date: {1}{3}{0}Updates: {1}{4}{0}{0}Do you want to continue?", vbCrLf, vbTab, logItem.FileName, logItem.DateLoaded, logItem.NumUpdated), "Rerun Log Entry", MessageBoxButtons.OKCancel, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) = DialogResult.Cancel Then
            'The user picked cancel
            Exit Sub
        End If

        'Rerun the selected entry
        mParentSection.RerunLogItem(logItem)

    End Sub

    Private Sub MinDateTimePicker_ValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MinDateTimePicker.ValueChanged

        'Load the data
        UpdateEventLogBindingSource.DataSource = UpdateFileLog.GetByDate(MinDateTimePicker.Value.Date, MaxDateTimePicker.Value.Date.Add(New TimeSpan(23, 59, 59)))

    End Sub

    Private Sub MaxDateTimePicker_ValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MaxDateTimePicker.ValueChanged

        'Load the data
        UpdateEventLogBindingSource.DataSource = UpdateFileLog.GetByDate(MinDateTimePicker.Value.Date, MaxDateTimePicker.Value.Date.Add(New TimeSpan(23, 59, 59)))

    End Sub

#End Region

End Class
