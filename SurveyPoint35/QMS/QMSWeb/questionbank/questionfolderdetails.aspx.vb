Partial Class frmQuestionFolderDetails
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
    Private m_oQuestionFolder As QMS.clsQuestionFolders 'handles details form data
    Private m_oQuestions As QMS.clsQuestions            'handles datagrid data
    Private m_oConn As SqlClient.SqlConnection

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)

        'Determine whether page setup is required:
        'QuestionFolder has posted back to same page
        If Not Page.IsPostBack Then
            PageLoad()

        Else
            'retrieve search row
            LoadDataSet()

        End If

    End Sub

    Private Sub PageLoad()
        'security check
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.SURVEY_VIEWER) Then
            PageSetup()
            SecuritySetup()
            PageCleanUp()

        Else
            'QuestionFolder does not have QuestionFolder viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

        End If

    End Sub

    Private Sub PageSetup()
        ViewState("LastSort") = "ItemOrder"
        'set up search row
        If IsNumeric(Request.QueryString("id")) Then
            'save entity id on page
            viewstate("id") = Request.QueryString("id")

        Else
            'save viewstate for future id
            viewstate("id") = ""

        End If

        'get QuestionFolder data
        LoadDataSet()

        'setup form
        LoadDetailsForm()

        'setup datagrid
        QMS.clsQMSTools.FormatQMSDataGrid(dgQuestions)
        dgQuestions.DataKeyField = "QuestionID"
        QuestionsGridBind()

    End Sub

    Private Sub LoadDataSet()
        Dim dr As DataRow
        m_oQuestionFolder = New QMS.clsQuestionFolders(m_oConn)

        If IsNumeric(viewstate("id")) Then
            m_oQuestionFolder.FillAll(CInt(viewstate("id")), True)

        Else

            m_oQuestionFolder.AddMainRow()

        End If

        m_oQuestions = New QMS.clsQuestions(m_oConn)
        m_oQuestions.MainDataTable = m_oQuestionFolder.QuestionsTable

    End Sub

    Private Sub PageCleanUp()
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oQuestions) Then
            m_oQuestions.Close()
            m_oQuestions = Nothing
        End If
        If Not IsNothing(m_oQuestionFolder) Then
            m_oQuestionFolder.Close()
            m_oQuestionFolder = Nothing
        End If

    End Sub

    Private Sub LoadDetailsForm()
        Dim dr As QMS.dsQuestionFolders.QuestionFoldersRow

        dr = CType(m_oQuestionFolder.MainDataTable.Rows(0), QMS.dsQuestionFolders.QuestionFoldersRow)

        'set QuestionFolder id
        If dr.RowState = DataRowState.Added Then
            'new QuestionFolder, no QuestionFolder id
            lblQuestionFolderID.Text = "NEW"
            pnlQuestions.Visible = False
        Else
            'existing QuestionFolder, display QuestionFolder id
            lblQuestionFolderID.Text = dr.QuestionFolderID
            pnlQuestions.Visible = True
        End If

        tbName.Text = dr.Name
        tbDescription.Text = dr.Description
        cbActive.Checked = CBool(IIf(dr.Active = 1, True, False))
        hlAdd.NavigateUrl = String.Format("questiondetails.aspx?pid={0}", lblQuestionFolderID.Text)

        'setup form controls
        LoadCopyToQuestionFolderDDL()

    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.INSTANCE_ADMIN) Then
            'must be instance administrator to update instance
            If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.SURVEY_DESIGNER) Then
                'must be survey designer to edit or update question folder and questions
                ibSave.Visible = False
                hlAdd.Visible = False
                ibUpdateOrder.Visible = False
                ibDelete.Visible = False
                ddlCopyToQuestionFolderID.Visible = False

            End If

        End If

    End Sub

    Private Sub LoadCopyToQuestionFolderDDL()
        Dim dr As SqlClient.SqlDataReader = m_oQuestionFolder.GetQuestionFolderList()

        ddlCopyToQuestionFolderID.DataValueField = "QuestionFolderID"
        ddlCopyToQuestionFolderID.DataTextField = "Name"
        ddlCopyToQuestionFolderID.DataSource = dr
        ddlCopyToQuestionFolderID.DataBind()

        dr.Close()
        dr = Nothing

        ddlCopyToQuestionFolderID.SelectedIndex = ddlCopyToQuestionFolderID.Items.IndexOf(ddlCopyToQuestionFolderID.Items.FindByValue(m_oQuestionFolder.MainDataTable.Rows(0).Item("QuestionFolderID")))

    End Sub

    Private Sub ibSave_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibSave.Click
        Dim dr As QMS.dsQuestionFolders.QuestionFoldersRow
        Dim bNew As Boolean = False
        Dim iQuestionFolderID As Integer

        If Page.IsValid Then
            dr = CType(m_oQuestionFolder.MainDataTable.Rows(0), QMS.dsQuestionFolders.QuestionFoldersRow)

            'set other fields
            dr.Name = tbName.Text
            dr.Description = tbDescription.Text
            dr.Active = CByte(IIf(cbActive.Checked, 1, 0))

            If dr.RowState = DataRowState.Added Then bNew = True

            'commit changes to database
            m_oQuestionFolder.Save()

            If m_oQuestionFolder.ErrMsg.Length = 0 Then
                iQuestionFolderID = dr.QuestionFolderID

            Else
                'display error
                DMI.WebFormTools.Msgbox(Page, m_oQuestionFolder.ErrMsg)
                bNew = False

            End If

        End If

        PageCleanUp()

        If bNew Then Response.Redirect(String.Format("questionfolderdetails.aspx?id={0}", iQuestionFolderID))

    End Sub

    Private Sub QuestionsGridBind()
        Dim iRowCount As Integer

        iRowCount = DMI.clsDataGridTools.DataGridBind(dgQuestions, m_oQuestions.MainDataTable, ViewState("LastSort").ToString)

    End Sub

    Private Sub dgQuestions_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgQuestions.SortCommand
        Viewstate("LastSort") = m_oQuestions.DataGridSort(dgQuestions, e, Viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub ibDelete_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click
        m_oQuestions.DataGridDelete(dgQuestions, viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub dgQuestions_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgQuestions.ItemDataBound
        Dim drv As DataRowView
        Dim ddl As DropDownList
        Dim ddlValue As Integer

        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            drv = CType(e.Item.DataItem, DataRowView)

            'set question text
            CType(e.Item.FindControl("lblQuestionText"), Label).Text = String.Format("<b>{0}</b><br>{1}", drv.Item("ShortDesc"), drv.Item("Text"))

            'set order column
            ddl = CType(e.Item.FindControl("ddlSortIndex"), DropDownList)
            ddlValue = drv("ItemOrder")
            DMI.WebFormTools.GetSortOrderList(ddl, ddlValue, m_oQuestionFolder.QuestionsTable.Rows.Count)

            'set question type name column
            CType(e.Item.FindControl("lblTypeName"), Label).Text = drv.Row.GetParentRow("QuestionTypesQuestions").Item("Name")

        End If

    End Sub

    Private Sub ibUpdateOrder_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibUpdateOrder.Click
        m_oQuestions.DataGridUpdateOrder(dgQuestions, viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub ibCopyTo_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibCopyTo.Click
        m_oQuestions.DataGridCopyTo(dgQuestions, CInt(ddlCopyToQuestionFolderID.SelectedItem.Value), viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

End Class

