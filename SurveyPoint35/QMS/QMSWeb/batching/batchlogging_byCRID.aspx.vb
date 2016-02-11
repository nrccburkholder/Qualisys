Partial Class frmBatchLoggingByCRID
    Inherits System.Web.UI.Page

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region
    Private Const LAST_BATCH_ID_KEY As String = "LastBatchID"
    Private Const MAILING_ID_KEY As String = "MailingID"
    Public Const REQUEST_LAST_BATCH_ID_KEY As String = "last"


    Private _BatchHandler As QMS.clsBatchHandler
    Private _Connection As SqlClient.SqlConnection

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            _Connection = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
            _BatchHandler = New QMS.clsBatchHandler
            Session.Remove("ds")

            If Not Page.IsPostBack Then
                PageSetup()
                PageCleanUp()
            End If

        Catch ex As Exception
            clsLog.LogError(GetType(frmBatchLoggingByCRID), "Page_Load", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured loading page.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub PageSetup()
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.BATCHER) Then
            ViewState(MAILING_ID_KEY) = ""
            If IsNumeric(Request.QueryString(REQUEST_LAST_BATCH_ID_KEY)) Then
                'init variables
                ViewState(LAST_BATCH_ID_KEY) = CInt(Request.QueryString(REQUEST_LAST_BATCH_ID_KEY))
            Else
                ViewState(LAST_BATCH_ID_KEY) = 0
            End If
            tbReturnDate.Text = Date.Now.ToShortDateString

        Else
            'does not have access privledges, reflect back
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

        End If

    End Sub

    Private Sub DisplayVerification()
        If Not _BatchHandler.NewBatch Then
            DMI.WebFormTools.DisplayMsgLabel(lblVerify, _BatchHandler.DisplayVerificationHTMLMsg(), Drawing.Color.Blue)

        Else
            DMI.WebFormTools.DisplayMsgLabel(lblVerify, _BatchHandler.DisplayVerificationHTMLMsg(), Drawing.Color.Red)
            ltSoundTag.Text = "<EMBED SRC=""../includes/batch.wav"" AUTOSTART=""True"" HIDDEN=""True""><bgsound src=""../includes/batch.wav"">"

        End If

    End Sub

    Private Sub PageCleanUp()
        _BatchHandler = Nothing
        If Not IsNothing(_Connection) Then
            _Connection.Close()
            _Connection.Dispose()
            _Connection = Nothing
        End If

    End Sub

    Private Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        Try
            If Page.IsValid Then
                DisplayVerification()

            ElseIf _BatchHandler.RespondentsTable.Rows.Count > 0 Then
                DisplayRespondents()

            End If

            'clear text box
            tbClientRespondentID.Text = ""
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmBatchLoggingByCRID), "btnSubmit_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured batching survey.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub BatchRespondent(ByVal respondentID As Integer)
        Dim iLastBatch As Integer
        Dim iNewBatch As Integer = 0
        Dim returnDate As DateTime

        'Get last batch id and mailing id from scan
        iLastBatch = CType(ViewState(LAST_BATCH_ID_KEY), Integer)
        _BatchHandler.MailingID = ViewState(MAILING_ID_KEY)

        'Batch respondent
        iNewBatch = _BatchHandler.BatchRespondent(respondentID, iLastBatch, CInt(HttpContext.Current.User.Identity.Name), returnDate, _Connection)

        'Display verification message
        DisplayVerification()

        'store batch id
        Viewstate(LAST_BATCH_ID_KEY) = iNewBatch

    End Sub

    Public Sub ValidateRespondentID(ByVal source As Object, ByVal args As ServerValidateEventArgs)
        args.IsValid = True

        Try
            Dim clientRespondentID As String
            Dim returnDate As DateTime
            Dim iLastBatch As Integer
            Dim iNewBatch As Integer = 0

            'get respondent data
            clientRespondentID = tbClientRespondentID.Text.Trim
            returnDate = CDate(tbReturnDate.Text)

            If returnDate > Date.Now Then Throw New ApplicationException("Future return dates are not allowed.")

            'Get last batch id
            iLastBatch = CType(ViewState(LAST_BATCH_ID_KEY), Integer)

            'Batch respondent
            iNewBatch = _BatchHandler.BatchScan(clientRespondentID, iLastBatch, CInt(HttpContext.Current.User.Identity.Name), returnDate, _Connection, QMS.clsBatchHandler.BatchMode.ByCRID)

            'store batch id
            ViewState(MAILING_ID_KEY) = _BatchHandler.MailingID
            Viewstate(LAST_BATCH_ID_KEY) = iNewBatch

        Catch ex As Exception
            clsLog.LogError(GetType(frmBatchLoggingByCRID), "ValidateRespondentID", ex)
            cuvClientRespondentID.ErrorMessage = ex.Message
            args.IsValid = False

        End Try

    End Sub

    Private Sub DisplayRespondents()
        Dim respondentCount As Integer = 0

        QMS.clsQMSTools.FormatQMSDataGrid(dgRespondents)
        dgRespondents.DataKeyField = "RespondentID"
        respondentCount = _BatchHandler.RespondentsObj.DataGridBind(dgRespondents, "LastName, FirstName")

    End Sub

    Private Sub dgRespondents_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles dgRespondents.SelectedIndexChanged
        Try
            Dim respondentID As Integer

            respondentID = CInt(dgRespondents.DataKeys(dgRespondents.SelectedIndex))
            BatchRespondent(respondentID)

            _BatchHandler.RespondentsObj.ClearMainTable()
            DisplayRespondents()

        Catch ex As Exception
            clsLog.LogError(GetType(frmBatchLoggingByCRID), "dgRespondents_SelectedIndexChanged", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured changing grid page.\nError has been logged, please report to administrator.")

        Finally
            'clear text box
            tbClientRespondentID.Text = ""
            PageCleanUp()

        End Try

    End Sub

    Private Sub dgRespondents_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgRespondents.ItemDataBound
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim drv As DataRowView
            drv = CType(e.Item.DataItem, DataRowView)
            'set name column
            CType(e.Item.FindControl("ltRespondentName"), Literal).Text = String.Format("{0}, {1}", drv.Item("FirstName"), drv.Item("LastName"))
            'set address column
            CType(e.Item.FindControl("ltAddress"), Literal).Text = DMI.clsUtil.FormatHTMLAddress(drv.Item("Address1"), drv.Item("Address2"), drv.Item("City"), drv.Item("State"), drv.Item("PostalCode"))
            'set survey instance column
            CType(e.Item.FindControl("ltSurveyInstanceName"), Literal).Text = String.Format("{0}: {1}: {2}", drv.Item("SurveyName"), drv.Item("ClientName"), drv.Item("SurveyInstanceName"))

        End If

    End Sub
End Class
