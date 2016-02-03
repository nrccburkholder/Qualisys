Partial Class frmProtocolDetails
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

    Private m_oProtocol As QMS.clsProtocols
    Private m_oProtocolSteps As QMS.clsProtocolSteps
    Private m_oProtocolStepParams As QMS.clsProtocolStepParameters
    Private m_oConn As SqlClient.SqlConnection

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
        m_oProtocol = New QMS.clsProtocols(m_oConn)
        m_oProtocolStepParams = m_oProtocol.ProtocolStepParameters
        m_oProtocolSteps = m_oProtocol.ProtocolSteps

        'Determine whether page setup is required:
        'Question has posted back to same page
        If Not Page.IsPostBack Then
            PageLoad()

        Else
            'retrieve search row
            LoadDataSet()

        End If

    End Sub

    Private Sub PageLoad()
        'security check
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.PROTOCOL_VIEWER) Then
            PageSetup()
            SecuritySetup()
            PageCleanUp()

        Else
            'user does not have viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

        End If

    End Sub

    Private Sub PageSetup()
        ViewState("LastSort") = "StartDay"
        ViewState("NewProtocolStepTypeID") = 0
        'set up search row
        If IsNumeric(Request.QueryString("id")) Then
            'save entity id on page
            viewstate("id") = Request.QueryString("id")

        Else
            'save viewstate for future id
            viewstate("id") = ""

        End If

        'get datset
        LoadDataSet()

        'setup form
        LoadDetailsForm()

        'setup datagrid
        QMS.clsQMSTools.FormatQMSDataGrid(dgProtocolSteps)
        dgProtocolSteps.DataKeyField = "ProtocolStepID"
        ProtocolStepsGridBind("StartDay")

    End Sub

    Private Sub LoadDataSet()
        Dim dr As DataRow

        'Fill Lookup table
        m_oProtocol.FillUsers()
        m_oProtocolSteps.FillProtocolStepType(m_oConn, m_oProtocol.ProtocolStepTypesTable)
        m_oProtocolStepParams.FillProtocolStepParameterType(m_oConn, m_oProtocol.ProtocolStepParameterTypesTable)

        If IsNumeric(viewstate("id")) Then
            'fill child tables
            dr = m_oProtocol.NewSearchRow
            dr.Item("ProtocolID") = CInt(viewstate("id"))
            m_oProtocol.EnforceConstraints = False
            m_oProtocol.FillProtocolStepParameters(dr)
            m_oProtocol.FillProtocolSteps(dr)

            'get protocol row
            m_oProtocol.FillMain(dr)

            m_oProtocol.EnforceConstraints = True
            dr = Nothing

        Else
            'get new protocol row
            m_oProtocol.AuthorUserID = CInt(HttpContext.Current.User.Identity.Name)
            m_oProtocol.AddMainRow()

        End If

    End Sub

    Private Sub PageCleanUp()
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        m_oProtocolStepParams = Nothing
        m_oProtocolSteps = Nothing
        If Not IsNothing(m_oProtocol) Then
            m_oProtocol.Close()
            m_oProtocol = Nothing
        End If

    End Sub

    Private Sub LoadDetailsForm()
        Dim dr As QMS.dsProtocols.ProtocolsRow

        dr = CType(m_oProtocol.MainDataTable.Rows(0), QMS.dsProtocols.ProtocolsRow)

        'set id
        If dr.RowState = DataRowState.Added Then
            'new protocol, no id
            lblProtocolID.Text = "NEW"
            pnlProtocolStepLinks.Visible = False
        Else
            'existing protocol, display id
            lblProtocolID.Text = dr.ProtocolID
            pnlProtocolStepLinks.Visible = True

        End If

        lblCreatedBy.Text = dr.GetParentRow("UsersProtocols").Item("Username").ToString
        tbName.Text = dr.Name
        tbDescription.Text = dr.Description

        DMI.WebFormTools.SetReferingURL(Request, hlCancel, "protocoldetails\.aspx", Session)

        'setup add protocol step ddl
        ddlProtocolStepTypeID.DataSource = m_oProtocol.ProtocolStepTypesTable
        ddlProtocolStepTypeID.DataValueField = "ProtocolStepTypeID"
        ddlProtocolStepTypeID.DataTextField = "Name"
        ddlProtocolStepTypeID.DataBind()
        ddlProtocolStepTypeID.Items.Insert(0, New ListItem("Select Step Type", 0))

    End Sub

    Sub ProtocolStepsGridBind(ByVal sSortBy As String)
        Dim iRowCount As Integer

        iRowCount = m_oProtocolSteps.DataGridBind(dgProtocolSteps, ViewState("LastSort").ToString)

    End Sub

    Private Sub SecuritySetup()

        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.PROTOCOL_DESIGNER) Then
            'must be protocol designer to update protocol details and protocol steps
            ibSave.Visible = False
            ddlProtocolStepTypeID.Visible = False
            ibDelete.Visible = False

        End If

    End Sub

    Private Sub ibSave_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibSave.Click
        Dim dr As QMS.dsProtocols.ProtocolsRow
        If dgProtocolSteps.EditItemIndex = -1 Then
            If Page.IsValid Then
                dr = CType(m_oProtocol.MainDataTable.Rows(0), QMS.dsProtocols.ProtocolsRow)

                dr.Name = tbName.Text
                dr.Description = tbDescription.Text

                m_oProtocol.Save()

                If m_oProtocol.ErrMsg.Length = 0 Then
                    'no errors, update controls
                    lblProtocolID.Text = dr.ProtocolID.ToString
                    pnlProtocolStepLinks.Visible = True
                    ViewState("id") = dr.ProtocolID
                    m_oProtocolSteps.ProtocolID = dr.ProtocolID

                Else
                    'display error messages
                    DMI.WebFormTools.Msgbox(Page, m_oProtocol.ErrMsg)

                End If

            End If

        End If

        PageCleanUp()

    End Sub

    Private Sub ibAdd_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibAdd.Click
        'verify user selected a step type to add
        If ddlProtocolStepTypeID.SelectedIndex > 0 Then
            'set step settings
            m_oProtocolSteps.ProtocolStepTypeID = CInt(ddlProtocolStepTypeID.SelectedItem.Value)
            m_oProtocolSteps.ProtocolID = CInt(ViewState("id"))
            'save new step type
            ViewState("NewProtocolStepTypeID") = m_oProtocolSteps.ProtocolStepTypeID
            'add new step to datagrid
            m_oProtocolSteps.DataGridNewItem(dgProtocolSteps, "StartDay")
            'reset step type dropdown
            ddlProtocolStepTypeID.SelectedIndex = 0
            pnlProtocolStepLinks.Visible = False

        Else
            'must select a step type before adding
            DMI.WebFormTools.Msgbox(Page, "Please select step type.")

        End If
        PageCleanUp()

    End Sub

    Private Sub dgProtocolSteps_EditCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgProtocolSteps.EditCommand
        m_oProtocolSteps.DataGridEditItem(dgProtocolSteps, e, ViewState("LastSort").ToString)
        pnlProtocolStepLinks.Visible = False
        PageCleanUp()

    End Sub

    Private Sub dgProtocolSteps_CancelCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgProtocolSteps.CancelCommand
        m_oProtocolSteps.DataGridCancel(dgProtocolSteps, ViewState("LastSort").ToString)
        pnlProtocolStepLinks.Visible = True
        PageCleanUp()

    End Sub

    Private Sub dgProtocolSteps_UpdateCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgProtocolSteps.UpdateCommand
        Dim dr As QMS.dsProtocols.ProtocolStepsRow

        If Page.IsValid Then
            'get existing datarow or create new datarow
            dr = CType(m_oProtocolSteps.SelectRow(String.Format("ProtocolStepID = {0}", dgProtocolSteps.DataKeys(e.Item.ItemIndex))), QMS.dsProtocols.ProtocolStepsRow)
            If IsNothing(dr) Then
                m_oProtocolSteps.ProtocolID = CInt(ViewState("id"))
                m_oProtocolSteps.ProtocolStepTypeID = CInt(ViewState("NewProtocolStepTypeID"))
                dr = CType(m_oProtocolSteps.AddMainRow, QMS.dsProtocols.ProtocolStepsRow)

            End If

            'copy form values into datarow
            With e.Item
                dr.StartDay = CInt(CType(.FindControl("tbStartDay"), TextBox).Text)
                dr.Name = CType(.FindControl("tbProtocolStepName"), TextBox).Text

            End With

            'commit changes to database
            m_oProtocolSteps.Save()

            'check for save errors
            If m_oProtocolSteps.ErrMsg.Length = 0 Then
                'read parameter values from form and save to database
                m_oProtocolStepParams.ReadHTMLParameterInputs(dr.GetChildRows("ProtocolStepsProtocolStepParameters"), Page.Request())
                m_oProtocolStepParams.MainDataTable.DataSet.EnforceConstraints = False
                m_oProtocolStepParams.Save()
                m_oProtocolStepParams.MainDataTable.DataSet.EnforceConstraints = True

                If m_oProtocolStepParams.ErrMsg.Length = 0 Then
                    'exit edit mode and rebind datagrid
                    dgProtocolSteps.EditItemIndex = -1
                    pnlProtocolStepLinks.Visible = True

                Else
                    'display save errors
                    DMI.WebFormTools.Msgbox(Page, m_oProtocolStepParams.ErrMsg)

                End If

                ProtocolStepsGridBind("StartDay")

            Else
                'display save errors
                DMI.WebFormTools.Msgbox(Page, m_oProtocolSteps.ErrMsg)

            End If

        End If

        PageCleanUp()

    End Sub

    Private Sub ibDelete_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click
        m_oProtocolSteps.DataGridDelete(dgProtocolSteps, ViewState("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub dgProtocolSteps_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgProtocolSteps.ItemDataBound
        Dim drv As DataRowView

        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            '*** display rows
            drv = e.Item.DataItem

            'set step type name
            CType(e.Item.FindControl("ltProtocolStepTypeName"), Literal).Text = drv.Row.GetParentRow("ProtocolStepTypesProtocolSteps").Item("Name").ToString
            'set step parameters
            CType(e.Item.FindControl("ltParameters"), Literal).Text = m_oProtocolStepParams.DisplayHTMLParameters(drv.Row.GetChildRows("ProtocolStepsProtocolStepParameters"))

        ElseIf e.Item.ItemType = ListItemType.EditItem Then
            '*** edit rows
            drv = e.Item.DataItem

            'set step type name
            CType(e.Item.FindControl("ltProtocolStepTypeName2"), Literal).Text = drv.Row.GetParentRow("ProtocolStepTypesProtocolSteps").Item("Name").ToString
            'set step parameters
            CType(e.Item.FindControl("ltEditParameters"), Literal).Text = m_oProtocolStepParams.DisplayHTMLParameterInputs(drv.Row.GetChildRows("ProtocolStepsProtocolStepParameters"))

        End If

    End Sub

End Class
