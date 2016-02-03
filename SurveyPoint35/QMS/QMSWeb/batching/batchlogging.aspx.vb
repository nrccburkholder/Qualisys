Partial Class frmBatchLogging
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
            clsLog.LogError(GetType(frmBatchLogging), "Page_Load", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured loading page.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub PageSetup()
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.BATCHER) Then
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

    Private Sub PageCleanUp()
        _BatchHandler = Nothing
        If Not IsNothing(_Connection) Then
            _Connection.Close()
            _Connection.Dispose()
            _Connection = Nothing
        End If
    End Sub

    Private Sub btnBatch_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBatch.Click
        Try
            If Page.IsValid Then
                DisplayVerification()

            End If

            'Clear respondent id text field
            tbRespondentID.Text = ""
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmBatchLogging), "btnBatch_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured batching survey.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub DisplayVerification()
        If Not _BatchHandler.NewBatch Then
            DMI.WebFormTools.DisplayMsgLabel(lblVerify, _BatchHandler.DisplayVerificationHTMLMsg(), Drawing.Color.Blue)

        Else
            DMI.WebFormTools.DisplayMsgLabel(lblVerify, _BatchHandler.DisplayVerificationHTMLMsg(), Drawing.Color.Red)
            ltSoundTag.Text = "<EMBED SRC=""../includes/batch.wav"" AUTOSTART=""True"" HIDDEN=""True""><bgsound src=""../includes/batch.wav"">"

        End If

    End Sub

    Public Sub ValidateRespondentID(ByVal source As Object, ByVal args As ServerValidateEventArgs)
        args.IsValid = True

        Try
            Dim respondentID As String
            Dim returnDate As DateTime
            Dim iLastBatch As Integer
            Dim iNewBatch As Integer = 0

            'get respondent data
            respondentID = tbRespondentID.Text.Trim
            returnDate = CDate(tbReturnDate.Text)
            If returnDate > Date.Now Then Throw New ApplicationException("Future return dates are not allowed.")

            'Get last batch id
            iLastBatch = CType(ViewState(LAST_BATCH_ID_KEY), Integer)

            'Batch respondent
            iNewBatch = _BatchHandler.BatchScan(respondentID, iLastBatch, CInt(HttpContext.Current.User.Identity.Name), returnDate, _Connection)

            'store batch id
            Viewstate(LAST_BATCH_ID_KEY) = iNewBatch

        Catch ex As Exception
            clsLog.LogError(GetType(frmBatchLogging), "ValidateRespondentID", ex)
            cuvBatchLogging.ErrorMessage = ex.Message
            args.IsValid = False

        End Try

    End Sub

End Class
