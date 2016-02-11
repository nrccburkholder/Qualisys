Option Strict On

Partial Class frmEmail
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

    Protected WithEvents cbExportHeader As System.Web.UI.WebControls.CheckBox

    Private m_oConn As SqlClient.SqlConnection

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)

        'Determine whether page setup is required:
        'FileDef has posted back to same page
        If Not Page.IsPostBack Then
            PageLoad()

        Else
            'retrieve search row
            LoadDataSet()

        End If

    End Sub

    Private Sub PageLoad()
        'security check
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.EXPORT_ACCESS) Or _
          QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.IMPORT_ACCESS) Then
            PageSetup()
            SecuritySetup()
            PageCleanUp()

        Else
            'FileDef does not have FileDef viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

        End If

    End Sub

    Private Sub PageSetup()
        'set up search row
        If IsNumeric(Request.QueryString("id")) Then
            'save entity id on page
            viewstate("id") = Request.QueryString("id")

        End If

        'get file def data
        LoadDataSet()

        LoadDetailsForm()

    End Sub

    Private Sub LoadDataSet()

    End Sub

    Private Sub PageCleanUp()
        m_oConn.Close()
        m_oConn = Nothing

    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.EXPORT_ACCESS) Then
            ibExecute.Enabled = False
        End If

    End Sub

    Private Sub LoadDetailsForm()
        Dim iSurveyID As Integer
        Dim iClientID As Integer
        Dim sqlDR As SqlClient.SqlDataReader

        'protocol step drop down
        sqlDR = QMS.clsProtocolSteps.GetSurveyInstanceProtocolSteps(m_oConn, 10)
        ddlProtocolStepID.DataSource = sqlDR
        ddlProtocolStepID.DataValueField = "RowID"
        ddlProtocolStepID.DataTextField = "Name"
        ddlProtocolStepID.DataBind()
        ddlProtocolStepID.Items.Insert(0, New ListItem("Email For Protocol Steps", "0"))
        sqlDR.Close()

        'setup survey instance export filter
        sqlDR = QMS.clsSurveyInstances.GetSurveyInstanceDataSource(m_oConn, iSurveyID, iClientID)
        ddlSurveyInstanceIDExport.DataSource = sqlDR
        ddlSurveyInstanceIDExport.DataValueField = "SurveyInstanceID"
        ddlSurveyInstanceIDExport.DataTextField = "Name"
        ddlSurveyInstanceIDExport.DataBind()
        ddlSurveyInstanceIDExport.Items.Insert(0, New ListItem("None", "0"))
        sqlDR.Close()

        'setup survey export filter
        sqlDR = QMS.clsSurveys.GetSurveyList(m_oConn)
        ddlSurveyID.DataSource = sqlDR
        ddlSurveyID.DataValueField = "SurveyID"
        ddlSurveyID.DataTextField = "Name"
        ddlSurveyID.DataBind()
        ddlSurveyID.Items.Insert(0, New ListItem("None", "0"))
        sqlDR.Close()

        'setup client export filter
        sqlDR = QMS.clsClients.GetClientList(m_oConn)
        ddlClientID.DataSource = sqlDR
        ddlClientID.DataValueField = "ClientID"
        ddlClientID.DataTextField = "Name"
        ddlClientID.DataBind()
        ddlClientID.Items.Insert(0, New ListItem("None", "0"))
        sqlDR.Close()

        'setup event filter
        sqlDR = QMS.clsEvents.GetEventDataSource(m_oConn, "2,3,4,5,7")
        ddlEventIDFilter.DataSource = sqlDR
        ddlEventIDFilter.DataValueField = "EventID"
        ddlEventIDFilter.DataTextField = "Name"
        ddlEventIDFilter.DataBind()
        ddlEventIDFilter.Items.Insert(0, New ListItem("None", "0"))
        sqlDR.Close()

        'setup file def filter
        sqlDR = QMS.clsFileDefs.GetFileDefFilterDataSource(m_oConn)
        ddlFileDefFilterID.DataSource = sqlDR
        ddlFileDefFilterID.DataTextField = "FilterName"
        ddlFileDefFilterID.DataValueField = "FileDefFilterID"
        ddlFileDefFilterID.DataBind()
        ddlFileDefFilterID.Items.Insert(0, New ListItem("None", "0"))
        sqlDR.Close()

    End Sub

    Private Sub ExecuteEmailing()

    End Sub

    Private Function SaveExportJobSettings() As Hashtable
        Dim ht As New Hashtable

        'survey instance id
        If ddlSurveyInstanceIDExport.SelectedIndex > 0 Then ht.Add("SurveyInstanceID", ddlSurveyInstanceIDExport.SelectedItem.Value)
        'survey instance date range
        If tbSurveyInstanceDateAfter.Text.Length > 0 Then ht.Add("SurveyInstanceDateAfter", tbSurveyInstanceDateAfter.Text)
        If tbSurveyInstanceDateBefore.Text.Length > 0 Then ht.Add("SurveyInstanceDateBefore", tbSurveyInstanceDateBefore.Text)
        'mailing seeds filter
        If cbIncludeMailingSeeds.Checked Then ht.Add("MailingSeeds", cbIncludeMailingSeeds.Checked)
        'survey filter
        If CInt(ddlSurveyID.SelectedItem.Value) > 0 Then ht.Add("SurveyID", ddlSurveyID.SelectedItem.Value)
        'client filter
        If CInt(ddlClientID.SelectedItem.Value) > 0 Then ht.Add("ClientID", ddlClientID.SelectedItem.Value)
        'event code filter
        If ddlEventIDFilter.SelectedIndex > 0 Then ht.Add("EventID", ddlEventIDFilter.SelectedItem.Value)
        'event code date range
        If tbEventDateAfter.Text.Length > 0 Then ht.Add("EventDateAfter", tbEventDateAfter.Text)
        If tbEventDateBefore.Text.Length > 0 Then ht.Add("EventDateBefore", tbEventDateBefore.Text)
        'Batch numbers
        If tbBatchIDs.Text.Length > 0 Then ht.Add("BatchIDs", tbBatchIDs.Text)
        'Other filters
        If ddlFileDefFilterID.SelectedIndex > 0 Then ht.Add("FileDefFilterID", ddlFileDefFilterID.SelectedItem.Value)
        'final codes
        If ddlFinal.SelectedIndex > 0 Then ht.Add("Final", ddlFinal.SelectedValue)
        'If cbExcludeFinalCodes.Checked Then ht.Add("ExcludeFinalCodes", True)
        'active respondents
        If cbActive.Checked Then ht.Add("Active", 1)

        Return ht

    End Function

    Private Sub ibExecute_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibExecute.Click
        If Page.IsValid Then
            'excute code here
            ExecuteEmailing()

        End If

    End Sub

    Private Sub btnGetCount_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnGetCount.Click
        If Page.IsValid Then
            Dim oIE As New QMS.clsImportExport(m_oConn, True)
            Dim drCriteria As DataRow = oIE.Respondents.NewSearchRow
            Dim RespondentCount As Integer

            oIE.ExportFilters = SaveExportJobSettings()
            oIE.SetSearchCriteria(drCriteria)
            RespondentCount = oIE.Respondents.GetRespondentsCount(drCriteria)
            DMI.WebFormTools.Msgbox(Page, String.Format("{0} Respondents", RespondentCount))

        End If
        PageCleanUp()

    End Sub

End Class
