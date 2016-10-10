Public Class HoldsDialog

    Public Sub New(ByVal holds As DataTable)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        PopulateHoldsGrid(holds)

    End Sub

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        Me.Close()
    End Sub

    Private Sub PopulateHoldsGrid(ByVal holds As DataTable)

        dgvHolds.AutoGenerateColumns = True

        dgvHolds.DataSource = holds

        With dgvHolds

            .Columns("EncounterHoldDate").HeaderText = "Encounter Hold Date"
            .Columns("HoldReason").HeaderText = "Reason"
            .Columns("HoldStatus").HeaderText = "Status"
            .Columns("SurveyManager").HeaderText = "Survey Manager"
            .Columns("AccountManager").HeaderText = "Account Manager"
            .Columns("DataManager").HeaderText = "Data Manager"
            .Columns("Requester").HeaderText = "Requestor"
            .Columns("DateCreated").HeaderText = "Created"


            .ColumnHeadersDefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells

            .Columns("HoldID").Visible = False
            .Columns("TicketNumber").Visible = False
            .Columns("CompletionDate").Visible = False
            .Columns("DateModified").Visible = False

        End With

    End Sub

End Class
