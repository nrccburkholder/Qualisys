Imports Nrc.SurveyPoint.Library
''' <summary>UI code for ViewExportLogSection</summary>
''' <CreateBy>Arman Mnatsakanyan</CreateBy>
''' <RevisionList><list type="table">
''' <listheader>
''' <term>Date Modified - Modified By</term>
''' <description>Description</description></listheader>
''' <item>
''' <term>	</term>
''' <description>
''' <para></para></description></item>
''' <item>
''' <term>	</term>
''' <description>
''' <para></para></description></item></list></RevisionList>
Public Class ViewExportLogSection
    Dim controller As New ExportLogSectionController()

    Private mExportGroupID As Integer
    Private mParentSection As ExportSection

    ''' <summary>Here we need to pass the ExportGroupID to the controller. The
    ''' controller will populate the log collection on the &quot;Set&quot; of the
    ''' SelectedExportGroupID property</summary>
    ''' <param name="parent"></param>
    ''' <param name="SelectedExportGroupID"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public Sub New(ByVal parent As ExportSection, ByVal SelectedExportGroupID As Integer)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mParentSection = parent
        mExportGroupID = SelectedExportGroupID
        controller.SelectedExportGroupID = mExportGroupID

        Me.MinDateTimePicker.Value = controller.StartDate
        Me.MaxDateTimePicker.Value = controller.EndDate






    End Sub

    ''' <summary>Refreshes the log grid with fresh data from the controller
    ''' object</summary>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Private Sub RefreshUI()
        controller.SelectedExportGroupID = Me.mExportGroupID
        Me.ExportGroupLogBindingSource.DataSource = controller.ExportFileLogs

        If CurrentUser.canResetisActive Then
            For Each ExportFileLog As ExportFileLog In Me.ExportGroupLogBindingSource.List
                If ExportFileLog.IsActive = True Then
                    Me.UpdateEventLogGridView.Columns("IsActive").OptionsColumn.AllowEdit = True
                End If
            Next
        End If

    End Sub

#Region "Event Handlers"
    Private Sub ViewExportLogSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        RefreshUI()
    End Sub

    Private Sub MinDateTimePicker_ValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MinDateTimePicker.ValueChanged
        controller.SelectedExportGroupID = mExportGroupID
        controller.StartDate = MinDateTimePicker.Value
        RefreshUI()
    End Sub

    Private Sub MaxDateTimePicker_ValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MaxDateTimePicker.ValueChanged
        controller.SelectedExportGroupID = mExportGroupID
        controller.EndDate = MaxDateTimePicker.Value
        RefreshUI()
    End Sub
    Public Sub LoadExportGroup(ByVal ExportGroupID As Integer)
        mExportGroupID = ExportGroupID
        controller.SelectedExportGroupID = mExportGroupID
        RefreshUI()
    End Sub
    Public Sub SetShowSelectedMode(ByVal ShowSelectedOnly As Boolean)
        controller.ShowLogsForSelelctedGroupOnly = ShowSelectedOnly
        RefreshUI()
    End Sub

    Private Sub UpdateEventLogRerunTSButton_Click_1(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UpdateEventLogRerunTSButton.Click
        'Get the currently selected record
        Dim logItem As ExportFileLog = TryCast(ExportGroupLogBindingSource.Current, ExportFileLog)

        'Check to see if the user had an entry selected
        If logItem Is Nothing Then
            MessageBox.Show("You must select the log entry to be reran!", "Rerun Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub

        ElseIf MessageBox.Show(String.Format("You have selected the following file to be reran:{0}{0}Answer File: {1}{2}{0}Question File: {1}{3}{0}{0}Do you want to continue?", vbCrLf, vbTab, logItem.AnswerFileName, logItem.QuestionFileName), "Rerun Log Entry", MessageBoxButtons.OKCancel, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) = DialogResult.Cancel Then
            'The user picked cancel
            Exit Sub
        End If

        'Rerun the selected entry
        mParentSection.RerunLogItem(logItem)

    End Sub
#End Region

    Private Sub UpdateEventLogExcelTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UpdateEventLogExcelTSButton.Click

        'Prompt user for filename
        If SaveFileDialog.ShowDialog = DialogResult.OK Then
            'Save the file
            UpdateEventLogGridView.ExportToXls(SaveFileDialog.FileName)
        End If

    End Sub

    Private Sub UpdateEventLogPrintTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UpdateEventLogPrintTSButton.Click
        Me.ExportFileLogGrid.ShowPreview()
    End Sub


    'Steve Kennedy - comment this code
    Private Sub UpdateEventLogGridView_CellValueChanged(ByVal sender As Object, ByVal e As DevExpress.XtraGrid.Views.Base.CellValueChangedEventArgs) Handles UpdateEventLogGridView.CellValueChanged
        If CurrentUser.canResetisActive Then
            For Each ExportFileLog As ExportFileLog In Me.ExportGroupLogBindingSource.List
                If ExportFileLog.IsActive = True Then
                    Me.UpdateEventLogGridView.Columns("IsActive").OptionsColumn.AllowEdit = True
                End If
            Next
        End If
    End Sub

 
    'Steve Kennedy - comment this code
    
    Private Sub UpdateEventLogGridView_CellValueChanging(ByVal sender As Object, ByVal e As DevExpress.XtraGrid.Views.Base.CellValueChangedEventArgs) Handles UpdateEventLogGridView.CellValueChanging

        If e.Column Is Me.UpdateEventLogGridView.Columns("IsActive") Then
            If CBool(e.Value) = False Then
                If CurrentUser.canResetisActive Then
                    If MessageBox.Show("Are you sure you want to reset this to inactive?", "Confirm", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = MsgBoxResult.Yes Then
                        ExportFileLog.MarkExportFileLogInActive(CInt(Me.UpdateEventLogGridView.GetRowCellValue(e.RowHandle, "ExportLogFileID")))
                    Else
                        Me.UpdateEventLogGridView.Columns("IsActive").OptionsColumn.AllowEdit = False
                        Me.UpdateEventLogGridView.SetRowCellValue(e.RowHandle, e.Column.FieldName, True)
                    End If
                End If
            Else
                MessageBox.Show("You cannot manually set this log to IsActive. You must re-run the log entry.", "Information", MessageBoxButtons.OK, MessageBoxIcon.Stop)
                Me.UpdateEventLogGridView.Columns("IsActive").OptionsColumn.AllowEdit = False
                Me.UpdateEventLogGridView.SetRowCellValue(e.RowHandle, e.Column.FieldName, False)
            End If
        End If

    End Sub

 
    
End Class
