Partial Class frmSurveyInstanceDetails
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

    Public Const SURVEYINSTANCE_ID_KEY As String = "id"
    Public Const COPY_SURVEYINSTANCE_ID_KEY As String = "copyid"
    Public Const SURVEY_ID_KEY As String = "sid"
    Public Const CLIENT_ID_KEY As String = "cid"

    Private m_oSurveyInstance As QMS.clsSurveyInstances
    Private m_oConn As SqlClient.SqlConnection

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)

        'Determine whether page setup is required:
        'SurveyInstance has posted back to same page
        If Not Page.IsPostBack Then
            PageLoad()

        Else
            'retrieve search row
            LoadDataSet()

        End If

    End Sub

    Private Sub PageLoad()
        'security check
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.INSTANCE_VIEWER) Then
            PageSetup()
            SecuritySetup()
            PageCleanUp()

        Else
            'SurveyInstance does not have SurveyInstance viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

        End If

    End Sub

    Private Sub PageSetup()
        Dim sqlDR As SqlClient.SqlDataReader

        'set up search row
        If IsNumeric(Request.QueryString(SURVEYINSTANCE_ID_KEY)) Then
            'save entity id on page
            viewstate(SURVEYINSTANCE_ID_KEY) = Request.QueryString(SURVEYINSTANCE_ID_KEY)

        ElseIf IsNumeric(Request.QueryString(COPY_SURVEYINSTANCE_ID_KEY)) Then
            viewstate(SURVEYINSTANCE_ID_KEY) = m_oSurveyInstance.Copy(Integer.Parse(Request.QueryString(COPY_SURVEYINSTANCE_ID_KEY)))

        Else
            'save viewstate for future id
            viewstate(SURVEYINSTANCE_ID_KEY) = ""

            'setup new survey instance controls
            sqlDR = QMS.clsSurveys.GetSurveyList(m_oConn)
            ddlSurveyID.DataSource = sqlDR
            ddlSurveyID.DataValueField = "SurveyID"
            ddlSurveyID.DataTextField = "Name"
            ddlSurveyID.DataBind()
            ddlSurveyID.Items.Insert(0, New ListItem("Select Survey", 0))
            sqlDR.Close()

            sqlDR = QMS.clsClients.GetClientList(m_oConn)
            ddlClientID.DataSource = sqlDR
            ddlClientID.DataValueField = "ClientID"
            ddlClientID.DataTextField = "Name"
            ddlClientID.DataBind()
            ddlClientID.Items.Insert(0, New ListItem("Select Client", 0))
            sqlDR.Close()
            sqlDR = Nothing

            'check for querystring settings
            If IsNumeric(Request.QueryString(SURVEY_ID_KEY)) Then
                ddlSurveyID.SelectedIndex = ddlSurveyID.Items.IndexOf(ddlSurveyID.Items.FindByValue(Request.QueryString(SURVEY_ID_KEY).ToString))
            End If

            If IsNumeric(Request.QueryString(CLIENT_ID_KEY)) Then
                ddlClientID.SelectedIndex = ddlClientID.Items.IndexOf(ddlClientID.Items.FindByValue(Request.QueryString(CLIENT_ID_KEY).ToString))
            End If

        End If

        'setup form controls
        sqlDR = QMS.clsProtocols.GetProtocolList(m_oConn)
        ddlProtocolID.DataSource = sqlDR
        ddlProtocolID.DataBind()
        ddlProtocolID.Items.Insert(0, New ListItem("Select Protocol", 0))
        sqlDR.Close()
        sqlDR = Nothing

        QMS.clsQMSTools.SetSurveyInstanceCategoryDDL(m_oConn, CType(ddlSurveyInstanceCategoryID, ListControl))

        'get SurveyInstance data
        LoadDataSet()

        LoadDetailsForm()

    End Sub

    Private Sub LoadDataSet()
        Dim dr As DataRow
        m_oSurveyInstance = New QMS.clsSurveyInstances(m_oConn)

        If IsNumeric(viewstate(SURVEYINSTANCE_ID_KEY)) Then
            m_oSurveyInstance.FillAll(CInt(viewstate(SURVEYINSTANCE_ID_KEY)), False)
            m_oSurveyInstance.FillDefaultScripts()

        Else
            m_oSurveyInstance.AddMainRow()

        End If

    End Sub

    Private Sub PageCleanUp()
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oSurveyInstance) Then
            m_oSurveyInstance.Close()
            m_oSurveyInstance = Nothing
        End If

    End Sub

    Private Sub LoadDetailsForm()
        Dim drSurveyInstance As QMS.dsSurveyInstances.SurveyInstancesRow

        drSurveyInstance = CType(m_oSurveyInstance.MainDataTable.Rows(0), QMS.dsSurveyInstances.SurveyInstancesRow)

        'set SurveyInstance id
        If drSurveyInstance.RowState = DataRowState.Added Then
            'new SurveyInstance, no SurveyInstance id
            lblSurveyInstanceID.Text = "NEW"

            'hide script dropdownlists
            ddlDataEntryScriptID.Visible = False
            ddlCATIScriptID.Visible = False
            ddlReminderScriptID.Visible = False

        Else
            'existing SurveyInstance, display SurveyInstance id
            lblSurveyInstanceID.Text = drSurveyInstance.SurveyInstanceID

            'setup default script dropdowns
            SetDefaultScriptDropDown(CInt(ViewState(SURVEYINSTANCE_ID_KEY)), 1, ddlDataEntryScriptID)
            SetDefaultScriptDropDown(CInt(ViewState(SURVEYINSTANCE_ID_KEY)), 2, ddlCATIScriptID)
            SetDefaultScriptDropDown(CInt(ViewState(SURVEYINSTANCE_ID_KEY)), 3, ddlReminderScriptID)

        End If

        tbName.Text = drSurveyInstance.Name
        ddlProtocolID.SelectedIndex = ddlProtocolID.Items.IndexOf(ddlProtocolID.Items.FindByValue(drSurveyInstance.ProtocolID))
        cbActive.Checked = CBool(IIf(drSurveyInstance.Active = 1, True, False))
        If drSurveyInstance.IsInstanceDateNull Then
            cdrInstanceDate.SelectedDate = Now()
            cdrInstanceDate.VisibleDate = Now()

        Else
            cdrInstanceDate.SelectedDate = drSurveyInstance.InstanceDate
            cdrInstanceDate.VisibleDate = drSurveyInstance.InstanceDate

        End If
        If drSurveyInstance.IsStartDateNull Then
            cdrStartDate.SelectedDate = Now()
            cdrStartDate.VisibleDate = Now()

        Else
            cdrStartDate.SelectedDate = drSurveyInstance.StartDate
            cdrStartDate.VisibleDate = drSurveyInstance.StartDate

        End If
        cbGroupByHousehold.Checked = CBool(IIf(drSurveyInstance.GroupByHousehold = 1, True, False))

        If Not drSurveyInstance.IsQuarterEndingNull Then tbQuarterEnding.Text = drSurveyInstance.QuarterEnding.ToShortDateString()

        If Not drSurveyInstance.IsSurveyInstanceCategoryIDNull Then
            DMI.WebFormTools.SetListControl(CType(ddlSurveyInstanceCategoryID, ListControl), drSurveyInstance.SurveyInstanceCategoryID.ToString)

        End If

        UpdateDetailsLink()
        UpdateProtocolDetailsLink()
        UpdateOptionLinks()

    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.INSTANCE_ADMIN) Then
            'must be instance administrator to update instance
            ibSave.Visible = False

        End If

    End Sub

    Private Sub ibSave_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibSave.Click
        Dim drSurveyInstance As QMS.dsSurveyInstances.SurveyInstancesRow
        Dim bNew As Boolean = False

        If Page.IsValid Then

            drSurveyInstance = CType(m_oSurveyInstance.MainDataTable.Rows(0), QMS.dsSurveyInstances.SurveyInstancesRow)

            'set other fields
            drSurveyInstance.Name = tbName.Text
            drSurveyInstance.ProtocolID = ddlProtocolID.SelectedItem.Value
            drSurveyInstance.Active = CByte(IIf(cbActive.Checked, 1, 0))
            drSurveyInstance.InstanceDate = cdrInstanceDate.SelectedDate
            drSurveyInstance.StartDate = cdrStartDate.SelectedDate
            drSurveyInstance.GroupByHousehold = CByte(IIf(cbGroupByHousehold.Checked, 1, 0))
            If ddlSurveyInstanceCategoryID.SelectedIndex > 0 Then
                drSurveyInstance.SurveyInstanceCategoryID = CInt(ddlSurveyInstanceCategoryID.SelectedValue)
            Else
                drSurveyInstance.SetSurveyInstanceCategoryIDNull()
            End If

            If drSurveyInstance.RowState = DataRowState.Added Then
                drSurveyInstance.SurveyID = CInt(ddlSurveyID.SelectedItem.Value)
                drSurveyInstance.ClientID = CInt(ddlClientID.SelectedItem.Value)
                bNew = True

            Else
                'save default scripts
                With m_oSurveyInstance.SurveyInstanceDefaultScripts
                    If IsNumeric(ddlDataEntryScriptID.SelectedValue) Then .SetDefaultScript(CInt(ViewState(SURVEYINSTANCE_ID_KEY)), 1, ddlDataEntryScriptID.SelectedValue)
                    If IsNumeric(ddlCATIScriptID.SelectedValue) Then .SetDefaultScript(CInt(ViewState(SURVEYINSTANCE_ID_KEY)), 2, ddlCATIScriptID.SelectedValue)
                    If IsNumeric(ddlReminderScriptID.SelectedValue) Then .SetDefaultScript(CInt(ViewState(SURVEYINSTANCE_ID_KEY)), 3, ddlReminderScriptID.SelectedValue)

                End With
            End If

            If tbQuarterEnding.Text.Length > 0 Then
                Dim dtEOQ As DateTime = DMI.clsUtil.EndOfQuarter(CDate(tbQuarterEnding.Text))
                tbQuarterEnding.Text = dtEOQ.ToShortDateString
                drSurveyInstance.QuarterEnding = dtEOQ
            Else
                drSurveyInstance.SetQuarterEndingNull()
            End If

            'commit changes to database
            m_oSurveyInstance.Save()

            If m_oSurveyInstance.ErrMsg.Length = 0 And bNew Then
                Response.Redirect(String.Format("surveyinstancedetails.aspx?{1}={0}", drSurveyInstance.SurveyInstanceID, SURVEYINSTANCE_ID_KEY))

            Else
                'display error
                DMI.WebFormTools.Msgbox(Page, m_oSurveyInstance.ErrMsg)

            End If

        End If

        PageCleanUp()

    End Sub

    Private Sub ddlProtocolID_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ddlProtocolID.SelectedIndexChanged
        UpdateProtocolDetailsLink()

    End Sub

    Private Sub UpdateProtocolDetailsLink()
        If ddlProtocolID.SelectedItem.Value > 0 Then
            hlProtocolDetails.NavigateUrl = String.Format("../protocols/protocoldetails.aspx?id={0}&refer=1", _
                ddlProtocolID.SelectedItem.Value)

        End If

    End Sub

    Private Sub UpdateDetailsLink()
        Dim dr As QMS.dsSurveyInstances.SurveyInstancesRow
        dr = CType(m_oSurveyInstance.MainDataTable.Rows(0), QMS.dsSurveyInstances.SurveyInstancesRow)

        If dr.RowState = DataRowState.Added Then
            ddlSurveyID.Visible = True
            hlSurveyDetails.Visible = False
            ddlClientID.Visible = True
            hlClientDetails.Visible = False

        Else
            ddlSurveyID.Visible = False
            hlSurveyDetails.Visible = True
            ddlClientID.Visible = False
            hlClientDetails.Visible = True

            hlClientDetails.Text = dr.ClientName
            hlSurveyDetails.Text = dr.SurveyName

            hlClientDetails.NavigateUrl = String.Format("../clients/clientdetails.aspx?id={0}", dr.ClientID)
            hlSurveyDetails.NavigateUrl = String.Format("../surveys/surveydetails.aspx?id={0}", dr.SurveyID)

        End If

    End Sub

    Private Sub UpdateOptionLinks()
        Dim dr As QMS.dsSurveyInstances.SurveyInstancesRow
        dr = CType(m_oSurveyInstance.MainDataTable.Rows(0), QMS.dsSurveyInstances.SurveyInstancesRow)

        If dr.RowState = DataRowState.Added Then
            pnlOptions.Visible = False

        Else
            hlSurveyInstanceEvents.NavigateUrl = String.Format("surveyinstanceevents.aspx?siid={0}", dr.SurveyInstanceID)
            hlMailingSeeds.NavigateUrl = String.Format("mailingseeds.aspx?id={0}", dr.SurveyInstanceID)
            pnlOptions.Visible = True

        End If

    End Sub

    Private Sub SetDefaultScriptDropDown(ByVal SurveyInstanceID As Integer, ByVal ScriptTypeID As Integer, ByVal ddl As DropDownList)
        Dim ScriptID As Integer = m_oSurveyInstance.SurveyInstanceDefaultScripts.GetDefaultScript(SurveyInstanceID, ScriptTypeID)
        Dim dr As SqlClient.SqlDataReader = QMS.clsScripts.GetInputScriptsForSurveyInstance(m_oConn, ScriptTypeID, SurveyInstanceID)
        
        ddl.DataSource = dr
        ddl.DataTextField = "Name"
        ddl.DataValueField = "ScriptID"
        ddl.DataBind()

        dr.Close()
        dr = Nothing

        If ddl.Items.Count = 0 Then
            ddl.Items.Add("No Scripts")
        Else
            ddl.SelectedValue = ScriptID
        End If


    End Sub

End Class
