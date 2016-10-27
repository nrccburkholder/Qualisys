Public Class HoldsDialog

    Private mShowAlert As Boolean = False

    Public Sub New(ByVal holds As DataTable, ByVal showAlert As Boolean)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mShowAlert = showAlert

        SetAlertMessage()
        PopulateHoldsGrid(holds)

    End Sub

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        Me.Close()
    End Sub

    Private Sub PopulateHoldsGrid(ByVal holds As DataTable)

        dgvHolds.AutoGenerateColumns = True

        dgvHolds.DataSource = holds

        With dgvHolds

            .ColumnHeadersDefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter


            .Columns("HoldID").DisplayIndex = 0
            .Columns("ClientID").DisplayIndex = 1
            .Columns("StudyID").DisplayIndex = 2
            .Columns("SurveyID").DisplayIndex = 3
            .Columns("ClientName").DisplayIndex = 4
            .Columns("StudyName").DisplayIndex = 5
            .Columns("SurveyName").DisplayIndex = 6
            .Columns("EncounterHoldDate").DisplayIndex = 7
            .Columns("HoldReason").DisplayIndex = 8
            .Columns("HoldStatus").DisplayIndex = 9
            .Columns("TicketNumber").DisplayIndex = 10
            .Columns("Requester").DisplayIndex = 11
            .Columns("CompletionDate").DisplayIndex = 12
            .Columns("DateCreated").DisplayIndex = 13
            .Columns("DateModified").DisplayIndex = 14


            .Columns("EncounterHoldDate").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
            .Columns("DateCreated").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter

            .Columns("EncounterHoldDate").HeaderText = "Encounter Hold Date"
            .Columns("HoldReason").HeaderText = "Reason"
            .Columns("HoldStatus").HeaderText = "Status"
            .Columns("Requester").HeaderText = "Requester"
            .Columns("DateCreated").HeaderText = "Created"

            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells

            .Columns("HoldID").Visible = False
            .Columns("ClientID").Visible = False
            .Columns("StudyID").Visible = False
            .Columns("SurveyID").Visible = False
            .Columns("TicketNumber").Visible = False
            .Columns("CompletionDate").Visible = False
            .Columns("DateModified").Visible = False

        End With

    End Sub

    Private Sub SetAlertMessage()
        If mShowAlert Then
            pbAlert.Visible = True
            lblAlertMessage.Visible = True
            lblAlertMessage.Text = "Sampling is disabled due to existing holds!"
        Else
            pbAlert.Visible = False
            lblAlertMessage.Visible = False
        End If


    End Sub

End Class
