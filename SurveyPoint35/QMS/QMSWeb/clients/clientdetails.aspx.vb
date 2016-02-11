Option Explicit On 
Option Strict On

Partial Class frmClientDetails
    Inherits System.Web.UI.Page
    Protected WithEvents uctTemplates As ucTemplates

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

    Private m_oClient As QMS.clsClients
    Private m_oSurveyInstances As QMS.clsSurveyInstances
    Private m_oConn As SqlClient.SqlConnection

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)

            'Determine whether page setup is required:
            'user has posted back to same page
            If Not Page.IsPostBack Then
                PageLoad()

            Else
                'load dataset
                LoadDataSet()

            End If

        Catch ex As Exception
            clsLog.LogError(GetType(frmClientDetails), "Page_Load", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured loading page.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub PageLoad()
        'security check
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.CLIENT_VIEWER) Then
            PageSetup()
            SecuritySetup()
            PageCleanUp()

        Else
            'user does not have user viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

        End If

    End Sub

    Private Sub PageSetup()
        Dim sqlDR As SqlClient.SqlDataReader

        viewstate("LastSort") = "InstanceDate DESC"

        'identify entity id
        If IsNumeric(Request.QueryString("id")) Then
            'save entity id on page
            viewstate("id") = Request.QueryString("id")

        Else
            'save viewstate for future id
            viewstate("id") = ""

        End If

        'get user data
        LoadDataSet()

        LoadDetailsForm()
        'TP Temp Change
        If m_oConn.State = ConnectionState.Closed Then
            m_oConn.Dispose()
            m_oConn = Nothing
            m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
        End If
        sqlDR = QMS.clsQMSTools.GetStatesDataSource(m_oConn)
        ddlState.DataValueField = "State"
        ddlState.DataTextField = "StateName"
        ddlState.DataSource = sqlDR
        ddlState.DataBind()
        ddlState.Items.Insert(0, New ListItem("Select State", ""))
        sqlDR.Close()
        sqlDR = Nothing

        'setup survey instance grid
        QMS.clsQMSTools.FormatQMSDataGrid(dgSurveyInstances)
        SurveyInstancesGridBind()

    End Sub

    Private Sub PageCleanUp()
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oSurveyInstances) Then
            m_oSurveyInstances.Close()
            m_oSurveyInstances = Nothing
        End If
        If Not IsNothing(m_oClient) Then
            m_oClient.Close()
            m_oClient = Nothing
        End If
    End Sub

    Private Sub SecuritySetup()

        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.CLIENT_ADMIN) Then
            'must have client admin rights to update client
            ibSubmit.Visible = False

        End If

        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.INSTANCE_ADMIN) Then
            'must have instance admin rights to add survey instance
            hlAddSurveyInstance.Visible = False

        End If

    End Sub

    Private Sub LoadDataSet()
        m_oClient = New QMS.clsClients(m_oConn)
        If IsNumeric(viewstate("id")) Then
            'fill with selected record
            m_oClient.FillAll(CInt(viewstate("id")), True)

        Else
            'new row
            m_oClient.AddMainRow()

        End If

        m_oSurveyInstances = New QMS.clsSurveyInstances(m_oConn)
        m_oSurveyInstances.MainDataTable = m_oClient.SurveyInstanceTable

    End Sub

    Private Sub LoadDetailsForm()
        Dim drClient As QMS.dsClients.ClientsRow

        drClient = CType(m_oClient.MainDataTable.Rows(0), QMS.dsClients.ClientsRow)

        'set client id
        If drClient.RowState = DataRowState.Added Then
            'new client, no client id
            lblClientID.Text = "NEW"
            hlAddSurveyInstance.Visible = False
            uctTemplates.Visible = False
        Else
            'existing client, display client id
            lblClientID.Text = drClient.ClientID.ToString
            'survey instances may only be added to active clients
            If drClient.Active = 0 Then hlAddSurveyInstance.Visible = False
            hlAddSurveyInstance.NavigateUrl = String.Format("../surveyinstances/surveyinstancedetails.aspx?cid={0}", drClient.ClientID)

            uctTemplates.SurveyClientID = drClient.ClientID
            uctTemplates.fillGrid()

        End If

        tbName.Text = drClient.Name
        tbAddress1.Text = drClient.Address1
        tbAddress2.Text = drClient.Address2
        tbCity.Text = drClient.City
        ddlState.SelectedIndex = ddlState.Items.IndexOf(ddlState.Items.FindByValue(drClient.State))
        tbPostalCode.Text = drClient.PostalCode
        tbTelephone.Text = drClient.Telephone
        tbFax.Text = drClient.Fax
        cbActive.Checked = CBool(IIf(drClient.Active = 1, True, False))

        DMI.WebFormTools.SetReferingURL(Request, hlCancel)

    End Sub

    Private Sub SurveyInstancesGridBind()
        Dim iRowCount As Integer

        iRowCount = m_oSurveyInstances.DataGridBind(dgSurveyInstances, viewstate("LastSort").ToString)
        'ltResultsFound.Text = String.Format("{0} Survey Instances", iRowCount)

    End Sub

    Private Sub dgSurveyInstances_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgSurveyInstances.PageIndexChanged
        m_oSurveyInstances.DataGridPageChange(dgSurveyInstances, e, viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub dgSurveyInstances_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgSurveyInstances.SortCommand
        Viewstate("LastSort") = m_oSurveyInstances.DataGridSort(dgSurveyInstances, e, Viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub ibSubmit_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibSubmit.Click
        Try
            Dim drClient As QMS.dsClients.ClientsRow

            If Page.IsValid Then
                drClient = CType(m_oClient.MainDataTable.Rows(0), QMS.dsClients.ClientsRow)

                drClient.Name = tbName.Text
                drClient.Address1 = tbAddress1.Text
                drClient.Address2 = tbAddress2.Text
                drClient.City = tbCity.Text
                drClient.State = ddlState.SelectedItem.Value
                drClient.PostalCode = tbPostalCode.Text
                drClient.Telephone = tbTelephone.Text
                drClient.Fax = tbFax.Text
                drClient.Active = CByte(IIf(cbActive.Checked, 1, 0))

                'commit changes to database
                m_oClient.Save()

                If m_oClient.ErrMsg.Length = 0 Then
                    'update user id display and search row
                    lblClientID.Text = drClient.ClientID.ToString
                    viewstate("id") = drClient.ClientID

                    'reset form controls
                    If cbActive.Checked Then
                        hlAddSurveyInstance.NavigateUrl = String.Format("../surveyinstances/surveyinstancedetails.aspx?cid={0}", drClient.ClientID)
                        hlAddSurveyInstance.Visible = True
                    Else
                        hlAddSurveyInstance.Visible = False

                    End If

                Else
                    'display error
                    DMI.WebFormTools.Msgbox(Page, m_oClient.ErrMsg)

                End If

            End If

            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmClientDetails), "ibSubmit_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured updating details.\nError has been logged, please report to administrator.")

        End Try

    End Sub

End Class
