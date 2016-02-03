Imports Microsoft.ApplicationBlocks.Data

Partial Class frmCopyQuestions
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

    Private m_oQuestions As QMS.clsQuestions
    Private m_oConn As SqlClient.SqlConnection
    Private m_sDSName As String

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
        m_oQuestions = New QMS.clsQuestions(m_oConn)
        m_sDSName = Request.Url.AbsolutePath

        'Determine whether page setup is required:
        'questions has posted back to same page
        If Not Page.IsPostBack Then PageLoad()

    End Sub

    Private Sub LoadDataSet()
        Dim drCriteria As DataRow

        drCriteria = m_oQuestions.RestoreSearch(ViewState("search").ToString, m_sDSName)
        m_oQuestions.FillQuestionType()
        m_oQuestions.FillQuestionFolders(drCriteria)
        m_oQuestions.FillMain(drCriteria)

    End Sub

    Private Sub PageLoad()
        'security check
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.SURVEY_DESIGNER) Then
            'run page setup
            PageSetup()
            'clean up page objects
            PageCleanUp()

        Else
            'SurveyInstance does not have SurveyInstance viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

        End If

    End Sub

    Private Sub PageSetup()
        Dim dr As SqlClient.SqlDataReader
        Dim iSurveyID As Integer = CInt(Request.QueryString("sid"))

        'setup page variables
        ViewState("LastSort") = "QuestionFolderID, ItemOrder"
        ViewState("search") = ""
        ViewState("SurveyID") = iSurveyID

        'setup page controls
        dr = QMS.clsQuestionFolders.GetQuestionFolderList(m_oConn)
        ddlQuestionFolderID.DataSource = dr
        ddlQuestionFolderID.DataTextField = "Name"
        ddlQuestionFolderID.DataValueField = "QuestionFolderID"
        ddlQuestionFolderID.DataBind()
        ddlQuestionFolderID.Items.Insert(0, New ListItem("Select Folder", "0"))
        dr.Close()

        ltSurveyName.Text = String.Format("Add Questions To {0}", GetSurveyName(iSurveyID))
        hlCancel.NavigateUrl = String.Format("surveydetails.aspx?id={0}", iSurveyID)

        'format datagrid
        dgQuestions.DataKeyField = "QuestionID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgQuestions)
        QuestionsGridBind()

    End Sub

    Private Sub BuildSearch()
        Dim dr As QMS.dsQuestions.SearchRow

        dr = CType(m_oQuestions.NewSearchRow, QMS.dsQuestions.SearchRow)

        If tbQuestionID.Text.Length > 0 Then dr.QuestionID = CInt(tbQuestionID.Text)
        If ddlQuestionFolderID.SelectedIndex > 0 Then dr.QuestionFolderID = CInt(ddlQuestionFolderID.SelectedItem.Value)
        If tbKeyword.Text.Length > 0 Then dr.Keyword = String.Format("%{0}%", tbKeyword.Text)

        ViewState("search") = m_oQuestions.SaveSearch(dr, m_sDSName)

    End Sub

    Private Sub PageCleanUp()
        'clean up page objects
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oQuestions) Then
            m_oQuestions.Close()
            m_oQuestions = Nothing
        End If

    End Sub

    Private Sub QuestionsGridBind()
        Dim iRowCount As Integer

        iRowCount = m_oQuestions.DataGridBind(dgQuestions, ViewState("LastSort").ToString)
        ltResultsFound.Text = String.Format("{0} Questions", iRowCount)
        If iRowCount > 0 Then
            If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.SURVEY_DESIGNER) Then
                ibAdd.Visible = True

            End If

        Else
            ibAdd.Visible = False

        End If
    End Sub

    Private Sub dgQuestions_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgQuestions.SortCommand
        LoadDataSet()
        Viewstate("LastSort") = m_oQuestions.DataGridSort(dgQuestions, e, Viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub btnSearch_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSearch.Click
        BuildSearch()
        LoadDataSet()
        dgQuestions.CurrentPageIndex = 0
        QuestionsGridBind()
        PageCleanUp()

    End Sub

    Private Sub ibAdd_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibAdd.Click
        LoadDataSet()
        m_oQuestions.DataGridAddQuestions(CInt(ViewState("SurveyID")), dgQuestions, ViewState("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Function GetSurveyName(ByVal iSurveyID As Integer) As String
        Return SqlHelper.ExecuteScalar(m_oConn, CommandType.Text, String.Format("SELECT Name FROM Surveys WHERE SurveyID = {0}", iSurveyID))

    End Function

    Private Sub dgQuestions_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgQuestions.ItemDataBound
        Dim drv As DataRowView = CType(e.Item.DataItem, DataRowView)

        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            'set folder name
            CType(e.Item.FindControl("lblQuestionFolderName"), Label).Text = drv.Row.GetParentRow("QuestionFoldersQuestions").Item("Name")
            'set question text
            CType(e.Item.FindControl("lblQuestionText"), Label).Text = String.Format("<b>{0}</b><br>{1}", drv.Item("ShortDesc"), drv.Item("Text"))
            'set question type name
            CType(e.Item.FindControl("lblQuestionTypeName"), Label).Text = drv.Row.GetParentRow("QuestionTypesQuestions").Item("Name")

        End If

    End Sub
End Class
