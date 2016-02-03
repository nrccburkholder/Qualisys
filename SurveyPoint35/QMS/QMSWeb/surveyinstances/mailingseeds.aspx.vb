Option Explicit On 

Partial Class frmMailingSeeds
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

    Private m_oMailingSeeds As QMS.clsMailingSeeds
    Private m_oConn As SqlClient.SqlConnection

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
        m_oMailingSeeds = New QMS.clsMailingSeeds(m_oConn)

        'Determine whether page setup is required:
        'user has posted back to same page
        If Not Page.IsPostBack Then
            PageLoad()

        Else
            LoadDataSet()

        End If

    End Sub

    Private Sub PageLoad()
        'security check
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.INSTANCE_VIEWER) Then
            'run page setup
            PageSetup()
            'set controls for security privledges
            SecuritySetup()
            'clean up page objects
            PageCleanUp()

        Else
            'user does not have user viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

        End If

    End Sub

    Private Sub PageSetup()
        'set up search row
        If IsNumeric(Request.QueryString("id")) Then
            'save entity id on page
            viewstate("id") = Request.QueryString("id")
        End If

        'setup sort variable
        Viewstate("LastSort") = ""

        'setup return link
        UpdateSurveyInstanceLink(CInt(ViewState("id")))

        'format datagrid
        dgMailingSeeds.DataKeyField = "RespondentID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgMailingSeeds)

        'fill main table
        LoadDataSet()

        'set data source and bind grid
        MailingSeedsGridBind()

    End Sub

    Private Sub PageCleanUp()
        'clean up page objects
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oMailingSeeds) Then
            m_oMailingSeeds.Close()
            m_oMailingSeeds = Nothing
        End If

    End Sub

    Private Sub LoadDataSet()
        Dim dr As DataRow = m_oMailingSeeds.NewSearchRow()

        dr.Item("SurveyInstanceID") = CInt(ViewState("id").ToString)
        m_oMailingSeeds.SurveyInstanceID = CInt(ViewState("id").ToString)
        m_oMailingSeeds.FillMain(dr)

    End Sub

    Private Sub MailingSeedsGridBind()
        Dim iRowCount As Integer

        iRowCount = m_oMailingSeeds.DataGridBind(dgMailingSeeds, ViewState("LastSort").ToString)
        ltResultsFound.Text = String.Format("{0} Mailing Seeds", iRowCount)

    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.INSTANCE_ADMIN) Then
            'must be instance administrator to add, edit or delete mailing seeds
            ibAdd.Visible = False
            ibDelete.Visible = False

        End If

    End Sub

    Private Sub dgMailingSeeds_CancelCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgMailingSeeds.CancelCommand
        m_oMailingSeeds.DataGridCancel(dgMailingSeeds, ViewState("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub dgMailingSeeds_EditCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgMailingSeeds.EditCommand
        m_oMailingSeeds.DataGridEditItem(dgMailingSeeds, e, viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub dgMailingSeeds_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgMailingSeeds.PageIndexChanged
        m_oMailingSeeds.DataGridPageChange(dgMailingSeeds, e, viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub dgMailingSeeds_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgMailingSeeds.SortCommand
        Viewstate("LastSort") = m_oMailingSeeds.DataGridSort(dgMailingSeeds, e, Viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub dgMailingSeeds_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgMailingSeeds.ItemDataBound
        Dim drv As DataRowView
        Dim ddl As DropDownList
        Dim sValue As String
        Dim sqlDR As SqlClient.SqlDataReader

        If e.Item.ItemType = ListItemType.EditItem Then
            drv = CType(e.Item.DataItem, DataRowView)

            'Setup MailingSeed type dropdown
            ddl = CType(e.Item.FindControl("ddlState"), DropDownList)
            sValue = CType(drv("State"), String)
            sqlDR = QMS.clsQMSTools.GetStatesDataSource(m_oConn)
            ddl.DataValueField = "State"
            ddl.DataTextField = "StateName"
            ddl.DataSource = sqlDR
            ddl.DataBind()
            DMI.WebFormTools.SetListControl(ddl, sValue)
            sqlDR.Close()
            sqlDR = Nothing

        End If

    End Sub

    Private Sub dgMailingSeeds_UpdateCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgMailingSeeds.UpdateCommand
        Dim dr As QMS.dsMailingSeeds.MailingSeedsRow

        If Page.IsValid Then
            'get existing datarow or create new datarow
            dr = CType(m_oMailingSeeds.SelectRow(String.Format("RespondentID = {0}", dgMailingSeeds.DataKeys(e.Item.ItemIndex))), QMS.dsMailingSeeds.MailingSeedsRow)
            If IsNothing(dr) Then dr = CType(m_oMailingSeeds.AddMainRow, QMS.dsMailingSeeds.MailingSeedsRow)

            'copy form values into datarow
            With e.Item
                dr.SurveyInstanceID = m_oMailingSeeds.SurveyInstanceID
                dr.FirstName = CType(.FindControl("tbFirstName"), TextBox).Text
                dr.MiddleInitial = CType(.FindControl("tbInitial"), TextBox).Text
                dr.LastName = CType(.FindControl("tbLastName"), TextBox).Text
                dr.Address1 = CType(.FindControl("tbAddress1"), TextBox).Text
                dr.Address2 = CType(.FindControl("tbAddress2"), TextBox).Text
                dr.City = CType(.FindControl("tbCity"), TextBox).Text
                dr.State = CType(.FindControl("ddlState"), DropDownList).SelectedItem.Value
                dr.PostalCode = CType(.FindControl("tbPostalCode"), TextBox).Text

            End With

            'commit changes to database
            m_oMailingSeeds.Save()

            If m_oMailingSeeds.ErrMsg.Length = 0 Then
                'exit edit mode and rebind datagrid
                dgMailingSeeds.EditItemIndex = -1
                MailingSeedsGridBind()

            Else
                'display error
                DMI.WebFormTools.Msgbox(Page, m_oMailingSeeds.ErrMsg)

            End If

        End If

        PageCleanUp()

    End Sub

    Private Sub UpdateSurveyInstanceLink(ByVal iSurveyInstanceID As Integer)
        Dim si As New QMS.clsSurveyInstances(m_oConn)
        si.FillAll(iSurveyInstanceID)
        hlSurveyInstance.Text = String.Format("{0}:&nbsp;{1}:&nbsp;{2}", _
            si.MainDataTable.Rows(0).Item("SurveyName"), _
            si.MainDataTable.Rows(0).Item("ClientName"), _
            si.MainDataTable.Rows(0).Item("Name"))
        hlSurveyInstance.NavigateUrl = String.Format("surveyinstancedetails.aspx?id={0}", iSurveyInstanceID)

        si.Close()
        si = Nothing

    End Sub

    Private Sub ibAdd_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibAdd.Click
        m_oMailingSeeds.DataGridNewItem(dgMailingSeeds, ViewState("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub ibDelete_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click
        m_oMailingSeeds.DataGridDelete(dgMailingSeeds, viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

End Class
