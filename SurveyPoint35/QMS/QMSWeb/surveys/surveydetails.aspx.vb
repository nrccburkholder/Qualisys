Partial Class frmSurveyDetails
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

    Private m_oSurvey As QMS.clsSurveys
    Private m_oSurveyQuestions As QMS.clsSurveyQuestions
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
            CopySurvey()
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

        LoadDetailsForm()

        'load datagrid
        QMS.clsQMSTools.FormatQMSDataGrid(dgSurveyQuestions)
        dgSurveyQuestions.DataKeyField = "SurveyQuestionID"
        SurveyQuestionsGridBind()

    End Sub

    Private Sub LoadDataSet()
        Dim dr As DataRow
        m_oSurvey = New QMS.clsSurveys(m_oConn)

        If IsNumeric(viewstate("id")) Then
            m_oSurvey.FillAll(CInt(viewstate("id")), True)

        Else
            m_oSurvey.FillUsers()
            m_oSurvey.AuthorUserID = CInt(HttpContext.Current.User.Identity.Name)
            m_oSurvey.AddMainRow()

        End If

        m_oSurveyQuestions = New QMS.clsSurveyQuestions(m_oConn)
        m_oSurveyQuestions.MainDataTable = m_oSurvey.SurveyQuestionsTable

    End Sub

    Private Sub PageCleanUp()
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oSurveyQuestions) Then
            m_oSurveyQuestions.Close()
            m_oSurveyQuestions = Nothing
        End If
        If Not IsNothing(m_oSurvey) Then
            m_oSurvey.Close()
            m_oSurvey = Nothing
        End If

    End Sub

    Private Sub LoadDetailsForm()
        Dim dr As QMS.dsSurveys.SurveysRow

        dr = CType(m_oSurvey.MainDataTable.Rows(0), QMS.dsSurveys.SurveysRow)

        'set survey id
        If dr.RowState = DataRowState.Added Then
            'new QuestionFolder, no QuestionFolder id
            lblSurveyID.Text = "NEW"
            DisplayDetailLinks = False
        Else
            'existing QuestionFolder, display QuestionFolder id
            lblSurveyID.Text = dr.SurveyID
            DisplayDetailLinks = True
        End If

        lblCreatedBy.Text = dr.GetParentRow("UsersSurveys").Item("Username").ToString
        tbName.Text = dr.Name
        tbDescription.Text = dr.Description
        lblCreatedOnDate.Text = String.Format("{0:d}", dr.CreatedOnDate)
        cbActive.Checked = CBool(IIf(dr.Active = 1, True, False))
        'DMI.WebFormTools.SetReferingURL(Request, hlCancel, "copyquestions\.aspx", Session)

    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.SURVEY_DESIGNER) Then
            'must be survey designer to edit survey
            ibSave.Visible = False
            hlAddSurveyQuestion.Visible = False
            ibUpdateOrder.Visible = False
            ibDelete.Visible = False

        End If

    End Sub

    Private Sub ibSave_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibSave.Click
        Dim dr As QMS.dsSurveys.SurveysRow
        Dim bNew As Boolean = False
        Dim iSurveyID As Integer

        If Page.IsValid Then
            dr = CType(m_oSurvey.MainDataTable.Rows(0), QMS.dsSurveys.SurveysRow)

            'set other fields
            dr.Name = tbName.Text
            dr.Description = tbDescription.Text
            dr.Active = CByte(IIf(cbActive.Checked, 1, 0))

            If dr.RowState = DataRowState.Added Then bNew = True

            'commit changes to database
            m_oSurvey.Save()

            If m_oSurvey.ErrMsg.Length = 0 Then
                iSurveyID = dr.SurveyID

            Else
                'display error
                DMI.WebFormTools.Msgbox(Page, m_oSurvey.ErrMsg)
                bNew = False

            End If


        End If
        SurveyQuestionsGridBind()
        PageCleanUp()

        If bNew Then Response.Redirect(String.Format("surveydetails.aspx?id={0}", iSurveyID))

    End Sub

    Private Sub SurveyQuestionsGridBind()
        Dim iRowCount As Integer

        iRowCount = m_oSurveyQuestions.DataGridBind(dgSurveyQuestions, ViewState("LastSort").ToString)
        ltResultsFound.Text = String.Format("{0} Survey Questions", iRowCount)

    End Sub

    Private Sub dgSurveyQuestions_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgSurveyQuestions.SortCommand
        m_oSurveyQuestions.DataGridSort(dgSurveyQuestions, e, ViewState("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub dgSurveyQuestions_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgSurveyQuestions.ItemDataBound
        Dim drv As DataRowView
        Dim ddl As DropDownList
        Dim ddlValue As Integer

        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            drv = CType(e.Item.DataItem, DataRowView)

            ddl = CType(e.Item.FindControl("ddlItemOrder"), DropDownList)
            ddlValue = drv("ItemOrder")
            DMI.WebFormTools.GetSortOrderList(ddl, ddlValue, m_oSurvey.SurveyQuestionsTable.Rows.Count)

            CType(e.Item.FindControl("ltQuestionText"), Literal).Text = String.Format("<b>{0}</b><br>{1}", _
                    drv.Row.GetParentRow("QuestionsSurveyQuestions").Item("ShortDesc"), _
                    drv.Row.GetParentRow("QuestionsSurveyQuestions").Item("Text"))

        End If


    End Sub

    Private Sub ibUpdateOrder_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibUpdateOrder.Click
        m_oSurveyQuestions.DataGridUpdateOrder(dgSurveyQuestions, ViewState("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub ibDelete_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click
        m_oSurveyQuestions.DataGridDelete(dgSurveyQuestions, ViewState("LastSort").ToString)
        PageCleanUp()

    End Sub

    Public WriteOnly Property DisplayDetailLinks() As Boolean
        Set(ByVal Value As Boolean)
            Dim iSurveyID As Integer

            hlViewSurveyInstances.Visible = Value
            hlViewScripts.Visible = Value
            hlPrint.Visible = Value
            pnlSurveyQuestionLinks.Visible = Value

            If Value Then
                iSurveyID = CInt(m_oSurvey.MainDataTable.Rows(0).Item("SurveyID"))

                hlViewSurveyInstances.NavigateUrl = _
                    String.Format("../surveyinstances/surveyinstances.aspx?id={0}", iSurveyID)
                hlViewScripts.NavigateUrl = _
                    String.Format("../scripts/scripts.aspx?sid={0}", iSurveyID)
                hlAddSurveyQuestion.NavigateUrl = _
                    String.Format("copyquestions.aspx?sid={0}", iSurveyID)
                hlPrint.NavigateUrl = _
                    String.Format("printsurvey.aspx?{0}={1}", frmPrintSurvey.REQUEST_SURVEYID_KEY, iSurveyID)

            End If

        End Set

    End Property

    Private Sub CopySurvey()
        Dim iNewSurveyID As Integer

        'copy id?
        If IsNumeric(Request.QueryString("copyid")) Then
            'check for designer privledges
            If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.SURVEY_DESIGNER) Then
                'execute copy
                iNewSurveyID = m_oSurvey.CopySurvey(CInt(Request.QueryString("copyid")), CInt(HttpContext.Current.User.Identity.Name), m_oConn)

                'refresh form with new survey
                Response.Redirect(String.Format("surveydetails.aspx?id={0}", iNewSurveyID))

            Else
                'exit, user cannot copy
                Response.Redirect("surveys.aspx")

            End If

        End If

    End Sub

End Class
