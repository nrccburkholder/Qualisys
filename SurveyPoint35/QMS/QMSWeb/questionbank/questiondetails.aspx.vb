Imports Microsoft.ApplicationBlocks.Data

Partial Class frmQuestionDetails
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
    Private m_oQuestion As QMS.clsQuestions                'handles details form data
    Private m_oAnswerCategories As QMS.clsAnswerCategories  'handles datagrid data
    Private m_oConn As SqlClient.SqlConnection

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)

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
        ViewState("LastSort") = "AnswerValue"
        'set up search row
        If IsNumeric(Request.QueryString("id")) Then
            'save entity id on page
            viewstate("id") = Request.QueryString("id")

        Else
            'save viewstate for future id
            viewstate("id") = ""

        End If

        'set done button link
        DMI.WebFormTools.SetReferingURL(Request, hlCancel, "/questionbank/questiondetails\.aspx", Session)

        'get Question data
        LoadDataSet()

        'setup form
        LoadDetailsForm()

        'setup datagrid
        QMS.clsQMSTools.FormatQMSDataGrid(dgAnswerCategories)
        dgAnswerCategories.DataKeyField = "AnswerCategoryID"
        AnswerCategoriesGridBind()

    End Sub

    Private Sub LoadDataSet()
        Dim dr As DataRow
        m_oQuestion = New QMS.clsQuestions(m_oConn)

        If IsNumeric(viewstate("id")) Then
            m_oQuestion.FillAll(CInt(viewstate("id")), True)

        Else
            m_oQuestion.QuestionFolderID = CInt(Request.QueryString("pid"))
            dr = m_oQuestion.NewSearchRow
            dr.Item("QuestionFolderID") = m_oQuestion.QuestionFolderID
            m_oQuestion.FillQuestionType(m_oConn, m_oQuestion.QuestionTypesTable)
            m_oQuestion.FillQuestionFolders(dr)
            m_oQuestion.AddMainRow()
            dr = Nothing

        End If

        m_oAnswerCategories = New QMS.clsAnswerCategories(m_oConn)
        m_oAnswerCategories.MainDataTable = m_oQuestion.AnswerCategoriesTable
        If IsNumeric(viewstate("id")) Then m_oAnswerCategories.QuestionID = CInt(ViewState("id"))

    End Sub

    Private Sub PageCleanUp()
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oAnswerCategories) Then
            m_oAnswerCategories.Close()
            m_oAnswerCategories = Nothing
        End If
        If Not IsNothing(m_oQuestion) Then
            m_oQuestion.Close()
            m_oQuestion = Nothing
        End If

    End Sub

    Private Sub LoadDetailsForm()
        Dim dr As QMS.dsQuestions.QuestionsRow

        dr = CType(m_oQuestion.MainDataTable.Rows(0), QMS.dsQuestions.QuestionsRow)

        'set question folder labels
        lblQuestionFolderID.Text = dr.QuestionFolderID
        lblQuestionFolderName.Text = dr.GetParentRow("QuestionFoldersQuestions").Item("Name")

        'set Question id
        If dr.RowState = DataRowState.Added Then
            'new QuestionFolder, no QuestionFolder id
            lblQuestionID.Text = "NEW"
            pnlAnswerCategoryLinks.Visible = False
        Else
            'existing QuestionFolder, display QuestionFolder id
            lblQuestionID.Text = dr.QuestionID
            pnlAnswerCategoryLinks.Visible = True
        End If
        'TP Change
        tbText.Text = dr.Text
        tbShortDesc.Text = dr.ShortDesc

        ddlQuestionTypeID.DataValueField = "QuestionTypeID"
        ddlQuestionTypeID.DataTextField = "Name"
        ddlQuestionTypeID.DataSource = m_oQuestion.QuestionTypesTable
        ddlQuestionTypeID.DataBind()
        ddlQuestionTypeID.SelectedIndex = ddlQuestionTypeID.Items.IndexOf(ddlQuestionTypeID.Items.FindByValue(dr.QuestionTypeID))
        If Request.QueryString("refer") = "1" Then ibSaveNew.Visible = False

    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.SURVEY_DESIGNER) Then
            'must be survey designer to update or edit question and question categories
            ibSave.Visible = False
            ibSaveNew.Visible = False
            ibAdd.Visible = False
            ibDelete.Visible = False

        End If

    End Sub

    Private Sub ibSave_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibSave.Click
        If Page.IsValid Then SubmitQuestion()
        PageCleanUp()

    End Sub

    Private Sub ibSaveNew_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibSaveNew.Click
        Dim iQuestionFolderID As Integer

        If Page.IsValid Then
            SubmitQuestion()

            If m_oQuestion.ErrMsg.Length = 0 Then
                iQuestionFolderID = m_oQuestion.MainDataTable.Rows(0).Item("QuestionFolderID")
                PageCleanUp()
                'reset page
                Response.Redirect(String.Format("questiondetails.aspx?pid={0}", iQuestionFolderID))

            End If

        End If

        PageCleanUp()

    End Sub

    Private Sub SubmitQuestion()
        Dim dr As QMS.dsQuestions.QuestionsRow

        With Me.m_oQuestion
            dr = CType(m_oQuestion.MainDataTable.Rows(0), QMS.dsQuestions.QuestionsRow)
            'TP Change
            dr.Text = tbText.Text
            dr.ShortDesc = tbShortDesc.Text
            dr.QuestionTypeID = CInt(ddlQuestionTypeID.SelectedItem.Value)

            m_oQuestion.Save()

            If m_oQuestion.ErrMsg.Length = 0 Then
                'no errors, update controls
                lblQuestionID.Text = dr.QuestionID.ToString
                pnlAnswerCategoryLinks.Visible = True
                ViewState("id") = dr.QuestionID
                m_oAnswerCategories.QuestionID = CInt(ViewState("id"))

            Else
                'display error messages
                DMI.WebFormTools.Msgbox(Page, m_oQuestion.ErrMsg)

            End If

        End With

    End Sub


    Sub AnswerCategoriesGridBind()
        Dim iRowCount As Integer

        iRowCount = m_oAnswerCategories.DataGridBind(dgAnswerCategories, ViewState("LastSort").ToString)

    End Sub

    Private Sub dgAnswerCategories_CancelCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgAnswerCategories.CancelCommand
        m_oAnswerCategories.DataGridCancel(dgAnswerCategories, viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub dgAnswerCategories_EditCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgAnswerCategories.EditCommand
        m_oAnswerCategories.DataGridEditItem(dgAnswerCategories, e, viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub dgAnswerCategories_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgAnswerCategories.ItemDataBound
        Dim drv As DataRowView = CType(e.Item.DataItem, DataRowView)

        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            'set question type name column
            CType(e.Item.FindControl("lblCategoryTypeName"), Label).Text = drv.Row.GetParentRow("AnswerCategoryTypesAnswerCategories").Item("Name")

        ElseIf e.Item.ItemType = ListItemType.EditItem Then
            Dim ddl As DropDownList

            'init category type dropdownlist
            ddl = CType(e.Item.FindControl("ddlAnswerCategoryTypeID"), DropDownList)
            ddl.DataTextField = "Name"
            ddl.DataValueField = "AnswerCategoryTypeID"
            ddl.DataSource = m_oQuestion.AnswerCategoryTypesTable
            ddl.DataBind()
            DMI.WebFormTools.SetListControl(ddl, CType(drv("AnswerCategoryTypeID"), String))

        End If

    End Sub

    Private Sub dgAnswerCategories_UpdateCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgAnswerCategories.UpdateCommand
        Dim dr As QMS.dsQuestions.AnswerCategoriesRow

        If Page.IsValid Then
            'get existing datarow or create new datarow
            dr = CType(m_oAnswerCategories.SelectRow(String.Format("AnswerCategoryID = {0}", dgAnswerCategories.DataKeys(e.Item.ItemIndex))), QMS.dsQuestions.AnswerCategoriesRow)
            If IsNothing(dr) Then
                m_oAnswerCategories.AnswerCategoryType = CInt(m_oQuestion.AnswerCategoryTypesTable.Rows(0).Item("AnswerCategoryTypeID"))
                dr = CType(m_oAnswerCategories.AddMainRow, QMS.dsQuestions.AnswerCategoriesRow)
            End If

            'copy form values into datarow
            With e.Item
                dr.AnswerValue = CInt(CType(.FindControl("tbAnswerValue"), TextBox).Text)
                dr.AnswerText = CType(.FindControl("tbAnswerText"), TextBox).Text
                dr.AnswerCategoryTypeID = CInt(CType(.FindControl("ddlAnswerCategoryTypeID"), DropDownList).SelectedItem.Value)

            End With

            'commit changes to database
            m_oAnswerCategories.Save()

            'check for save errors
            If m_oAnswerCategories.ErrMsg.Length = 0 Then
                'exit edit mode and rebind datagrid
                dgAnswerCategories.EditItemIndex = -1
                AnswerCategoriesGridBind()

            Else
                'display save errors
                DMI.WebFormTools.Msgbox(Page, m_oAnswerCategories.ErrMsg)

            End If

        End If

        PageCleanUp()

    End Sub

    Private Sub ibAdd_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibAdd.Click
        m_oAnswerCategories.AnswerCategoryType = CInt(m_oQuestion.AnswerCategoryTypesTable.Rows(0).Item("AnswerCategoryTypeID"))
        m_oAnswerCategories.DataGridNewItem(dgAnswerCategories, Viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub ibDelete_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click
        m_oAnswerCategories.DataGridDelete(dgAnswerCategories, viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Function GetQuestionFolderName(ByVal iQuestionFolderID As Integer) As String
        Return SqlHelper.ExecuteScalar(m_oConn, CommandType.Text, String.Format("SELECT Name FROM QuestionFolders WHERE QuestionFolderID = {0}", iQuestionFolderID))

    End Function

End Class
