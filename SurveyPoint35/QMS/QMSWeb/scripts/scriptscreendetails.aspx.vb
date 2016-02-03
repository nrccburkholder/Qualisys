Imports Microsoft.ApplicationBlocks.Data

Partial Class frmScriptScreenScreenDetails
    Inherits System.Web.UI.Page
    Protected WithEvents ucDescription As HtmlEditor

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

    Private Const LAST_SORT_KEY As String = "LastSort"
    Private Const SCRIPT_SCREEN_ID_KEY As String = "ScriptScreenID"
    Private Const SCRIPT_ID_KEY As String = "ScriptID"
    'Private Const CHANGED_SURVEY_QUESTION_KEY As String = "ChangedSurveyQuestion"

    Public Const REQUEST_SCRIPT_ID_KEY = "scr"
    Public Const REQUEST_SCRIPT_SCREEN_ID_KEY = "id"

    Private m_oScriptScreens As QMS.clsScriptScreens
    Private m_oScriptScreenCategories As QMS.clsScriptScreenCategories
    Private m_oAnswerCategories As QMS.clsAnswerCategories
    Private m_dtScreenList As DataTable
    Private m_oConn As SqlClient.SqlConnection
    Private m_sDSName As String

    'Private m_FakeScriptScreenCategoriesDataTable As QMS.dsScriptScreenCategories.ScriptScreenCategoriesDataTable = Nothing

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
        m_oScriptScreens = New QMS.clsScriptScreens(m_oConn)
        m_oScriptScreenCategories = m_oScriptScreens.ScriptScreenCategories
        m_oAnswerCategories = m_oScriptScreens.AnswerCategories

        m_sDSName = Request.Url.AbsolutePath

        'Determine whether page setup is required:
        'user has posted back to same page
        If Not Page.IsPostBack Then
            PageLoad()
        Else
            'retrieve search row
            LoadDataSet()
        End If
    End Sub

    Private Sub PageLoad()
        'security check
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.SCRIPT_VIEWER) Then
            PageSetup()
            SecuritySetup()
            PageCleanUp()
        Else
            'Survey does not have Survey viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))
        End If
    End Sub

    Private Sub PageSetup()
        Dim iScriptID = Integer.Parse(String.Format("0{0}", Request.QueryString(REQUEST_SCRIPT_ID_KEY)))
        Dim iScriptScreenID = Integer.Parse(String.Format("0{0}", Request.QueryString(REQUEST_SCRIPT_SCREEN_ID_KEY)))

        'setup view state vars
        ViewState(SCRIPT_ID_KEY) = iScriptID
        ViewState(SCRIPT_SCREEN_ID_KEY) = iScriptScreenID
        ViewState(LAST_SORT_KEY) = "AnswerValue"
        'ViewState(CHANGED_SURVEY_QUESTION_KEY) = False

        'get datset
        LoadDataSet()

        'setup form
        LoadDetailsForm()

        'setup datagrid
        dgScriptScreenCategories.DataKeyField = "AnswerCategoryID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgScriptScreenCategories)
        ScriptScreenCategoriesGridBind()

    End Sub

    Private Sub LoadDataSet()
        Dim ssDR As QMS.dsScriptScreens.SearchRow = CType(m_oScriptScreens.NewSearchRow, QMS.dsScriptScreens.SearchRow)

        m_oScriptScreens.FillLookups(ssDR)
        If CInt(ViewState(SCRIPT_SCREEN_ID_KEY)) <= 0 Then
            '*** new row
            'set parent script
            ssDR.ScriptID = CInt(ViewState(SCRIPT_ID_KEY))
            m_oScriptScreens.ScriptID = ssDR.ScriptID
            'get new row
            Dim newSSDR As QMS.dsScriptScreens.ScriptScreensRow = CType(m_oScriptScreens.AddMainRow(), QMS.dsScriptScreens.ScriptScreensRow)
            newSSDR.ScriptID = ssDR.ScriptID
            newSSDR.CalculationTypeID = 3
            ViewState(SCRIPT_SCREEN_ID_KEY) = 0

        Else
            '*** existing row
            'set script screen id
            ssDR.ScriptScreenID = CInt(ViewState(SCRIPT_SCREEN_ID_KEY))
            'get script screen data
            m_oScriptScreens.FillMain(ssDR)
            'get answer categories
            m_oScriptScreens.FillAnswerCategories()
            'get script screen categories
            m_oScriptScreens.FillScriptScreenCategories(ssDR)
            m_oScriptScreenCategories.ScriptScreenID = ssDR.ScriptScreenID

        End If

        ssDR = Nothing

    End Sub

    Private Sub PageCleanUp()
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oScriptScreens) Then
            m_oScriptScreens.Close()
            m_oScriptScreens = Nothing
        End If
        If Not IsNothing(m_oScriptScreenCategories) Then
            m_oScriptScreenCategories.Close()
            m_oScriptScreenCategories = Nothing
        End If
        If Not IsNothing(m_oAnswerCategories) Then
            m_oAnswerCategories.Close()
            m_oAnswerCategories = Nothing
        End If
        m_dtScreenList = Nothing

    End Sub


    Private Sub LoadDetailsForm()
        Dim ssDR As QMS.dsScriptScreens.ScriptScreensRow = CType(m_oScriptScreens.MainDataTable.Rows(0), QMS.dsScriptScreens.ScriptScreensRow)
        Dim iSurveyID = SqlHelper.ExecuteScalar(m_oConn, CommandType.Text, String.Format("SELECT Surveys.SurveyID FROM Scripts INNER JOIN Surveys ON Scripts.SurveyID = Surveys.SurveyID WHERE (Scripts.ScriptID = {0})", ssDR.ScriptID))

        SetupSurveyQuestionDDL(ddlSurveyQuestionID)

        ddlCalculationTypeID.DataSource = m_oScriptScreens.CalculationTypesTable
        ddlCalculationTypeID.DataBind()
        ddlCalculationTypeID.Items.Insert(0, New ListItem("Select Calculation Type", 0))

        ltItemOrder.Text = ssDR.ItemOrder

        If ssDR.RowState = DataRowState.Added Or ssDR.ScriptScreenID <= 0 Then
            ltScriptScreenID.Text = "NEW"
        Else
            ltScriptScreenID.Text = ssDR.ScriptScreenID
            ViewState(SCRIPT_ID_KEY) = ssDR.ScriptID
        End If

        ltScriptName.Text = SqlHelper.ExecuteScalar(m_oConn, CommandType.Text, String.Format("SELECT Name FROM Scripts WHERE ScriptID = {0}", ssDR.ScriptID))
        ltSurveyName.Text = SqlHelper.ExecuteScalar(m_oConn, CommandType.Text, String.Format("SELECT Surveys.Name FROM Scripts INNER JOIN Surveys ON Scripts.SurveyID = Surveys.SurveyID WHERE (Scripts.ScriptID = {0})", ssDR.ScriptID))

        If ssDR.IsSurveyQuestionIDNull Then
            ddlSurveyQuestionID.SelectedIndex = ddlSurveyQuestionID.Items.IndexOf(ddlSurveyQuestionID.Items.FindByValue(0))
        Else
            ddlSurveyQuestionID.SelectedIndex = ddlSurveyQuestionID.Items.IndexOf(ddlSurveyQuestionID.Items.FindByValue(ssDR.SurveyQuestionID))
        End If

        tbTitle.Text = ssDR.Title
        'TP Change
        ucDescription.Text = ssDR.Text
        ddlCalculationTypeID.SelectedIndex = ddlCalculationTypeID.Items.IndexOf(ddlCalculationTypeID.Items.FindByValue(ssDR.CalculationTypeID))

        QMS.clsQMSTools.SetScriptScreensDDL(Me.m_oConn, CType(ddlGoToScriptScreenID, ListControl), CInt(ViewState(SCRIPT_ID_KEY)))
        DMI.clsUtil.SetDropDownSelection(ddlGoToScriptScreenID, ViewState(SCRIPT_SCREEN_ID_KEY).ToString)

        hlCancel.NavigateUrl = String.Format("scriptdetails.aspx?{1}={0}", ViewState(SCRIPT_ID_KEY), frmScriptDetails.REQUEST_SCRIPT_ID_KEY)
        UpdateDetailsLink()

    End Sub

    Sub ScriptScreenCategoriesGridBind()
        Dim iRowCount As Integer = m_oAnswerCategories.DataGridBind(dgScriptScreenCategories, ViewState(LAST_SORT_KEY).ToString)

    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.SCRIPT_DESIGNER) Then
            'must be script designer to add or delete scripts
            ibSave.Visible = False
            ibSaveNew.Visible = False
            ibUpdateCategories.Visible = False
            ibResetQuestionText.Visible = False
        End If
    End Sub

    Private Sub ibSave_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibSave.Click
        Dim bNew As Boolean = False

        If Page.IsValid Then
            If m_oScriptScreens.MainDataTable.Rows(0).RowState = DataRowState.Added Then bNew = True

            SubmitScriptScreen()

            If bNew Then
                Response.Redirect(String.Format("scriptscreendetails.aspx?{1}={0}", m_oScriptScreens.MainDataTable.Rows(0).Item("ScriptScreenID"), REQUEST_SCRIPT_SCREEN_ID_KEY))

            Else
                ScriptScreenCategoriesGridBind()

            End If

        End If
        PageCleanUp()

    End Sub

    Private Sub ibSaveNew_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibSaveNew.Click
        Dim iScriptScreenID As Integer

        If Page.IsValid Then
            SubmitScriptScreen()

            If m_oScriptScreens.ErrMsg.Length = 0 Then
                iScriptScreenID = m_oScriptScreens.MainDataTable.Rows(0).Item("ScriptID")
                PageCleanUp()
                'reset page
                Response.Redirect(String.Format("scriptscreendetails.aspx?{1}={0}", iScriptScreenID, REQUEST_SCRIPT_ID_KEY))

            End If

        End If

        PageCleanUp()

    End Sub

    Private Sub ddlSurveyQuestionID_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlSurveyQuestionID.SelectedIndexChanged
        UpdateDetailsLink()

        If ucDescription.Text.Length = 0 Then
            GetQuestionText()
        End If

        If tbTitle.Text.Length = 0 Then
            GetQuestionTitle()
        End If


    End Sub

    Private Sub UpdateDetailsLink()
        Dim iQuestionID As Integer
        Dim sbSQL As New System.Text.StringBuilder

        If ddlSurveyQuestionID.SelectedIndex > 0 Then
            sbSQL.Append("SELECT QuestionID FROM SurveyQuestions ")
            sbSQL.AppendFormat("WHERE SurveyQuestionID = {0} ", ddlSurveyQuestionID.SelectedItem.Value)
            iQuestionID = SqlHelper.ExecuteScalar(m_oConn, CommandType.Text, sbSQL.ToString)
            hlSurveyQuestionDetails.NavigateUrl = String.Format("../questionbank/questiondetails.aspx?id={0}", iQuestionID)
            hlSurveyQuestionDetails.Visible = True
        Else
            hlSurveyQuestionDetails.Visible = False
        End If
    End Sub

    Private Sub dgScriptScreenCategories_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgScriptScreenCategories.ItemDataBound
        Dim drvAC As DataRowView
        Dim drSSC() As DataRow
        Dim ddl As DropDownList
        Dim sqlDR As SqlClient.SqlDataReader

        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            drvAC = CType(e.Item.DataItem, DataRowView)
            drSSC = drvAC.Row.GetChildRows("AnswerCategoriesScriptScreenCategories")

            'set answer category type literal
            CType(e.Item.FindControl("ltAnswerCategoryTypeName"), Literal).Text = drvAC.Row.GetParentRow("AnswerCategoryTypesAnswerCategories").Item("Name").ToString

            'setup jump to ddl
            ddl = CType(e.Item.FindControl("ddlJumpToScriptScreenID"), DropDownList)
            Me.SetupJumpToScreenDDL(ddl)

            'check if answer category is used
            If drSSC.Length > 0 Then
                'set show checkbox
                CType(e.Item.FindControl("cbShowCategory"), CheckBox).Checked = True

                'set category text
                CType(e.Item.FindControl("tbCategoryText"), TextBox).Text = drSSC(0).Item("Text").ToString

                'set jump to value
                ddl.SelectedIndex = ddl.Items.IndexOf(ddl.Items.FindByValue(drSSC(0).Item("JumpToScriptScreenID").ToString))

            Else
                'set category text
                CType(e.Item.FindControl("tbCategoryText"), TextBox).Text = drvAC.Item("AnswerText").ToString

            End If

        End If

    End Sub

    Private Sub ibUpdateCategories_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibUpdateCategories.Click

        If Page.IsValid Then
            UpdateCategories()
        End If

        PageCleanUp()

    End Sub

    Private Sub UpdateCategories()
        Dim dgi As DataGridItem
        Dim dr() As DataRow
        Dim drSSC As QMS.dsScriptScreens.ScriptScreenCategoriesRow

        For Each dgi In dgScriptScreenCategories.Items
            dr = m_oScriptScreenCategories.MainDataTable.Select(String.Format("AnswerCategoryID = {0}", dgScriptScreenCategories.DataKeys(dgi.ItemIndex)))

            If CType(dgi.FindControl("cbShowCategory"), CheckBox).Checked Then
                'include category
                If dr.Length > 0 Then
                    'existing row
                    drSSC = CType(dr(0), QMS.dsScriptScreens.ScriptScreenCategoriesRow)
                Else
                    'new row
                    m_oScriptScreenCategories.AnswerCategoryID = CInt(dgScriptScreenCategories.DataKeys(dgi.ItemIndex))
                    drSSC = CType(m_oScriptScreenCategories.AddMainRow(), QMS.dsScriptScreens.ScriptScreenCategoriesRow)

                End If
                'TP Change
                drSSC.Text = CType(dgi.FindControl("tbCategoryText"), TextBox).Text
                drSSC.JumpToScriptScreenID = CInt(CType(dgi.FindControl("ddlJumpToScriptScreenID"), DropDownList).SelectedItem.Value)
                m_oScriptScreenCategories.Save()

            Else
                'exclude category, delete existing
                If dr.Length > 0 Then
                    dr(0).Delete()
                    m_oScriptScreenCategories.Save()

                End If

            End If

        Next

        If m_oScriptScreenCategories.ErrMsg.Length > 0 Then
            DMI.WebFormTools.Msgbox(Me, m_oScriptScreenCategories.ErrMsg)

        End If

        ScriptScreenCategoriesGridBind()

    End Sub

    Private Sub GetQuestionText()
        Dim sbSQL As New StringBuilder

        If ddlSurveyQuestionID.SelectedIndex > 0 Then
            sbSQL.Append("SELECT q.Text FROM SurveyQuestions sq INNER JOIN ")
            sbSQL.Append("Questions q ON sq.QuestionID = q.QuestionID ")
            sbSQL.AppendFormat("WHERE sq.SurveyQuestionID = {0} ", ddlSurveyQuestionID.SelectedItem.Value)

            ucDescription.Text = SqlHelper.ExecuteScalar(m_oConn, CommandType.Text, sbSQL.ToString).ToString
        End If
    End Sub

    Private Sub GetQuestionTitle()
        Dim sbSQL As New StringBuilder

        If ddlSurveyQuestionID.SelectedIndex > 0 Then
            sbSQL.Append("SELECT q.ShortDesc FROM SurveyQuestions sq INNER JOIN ")
            sbSQL.Append("Questions q ON sq.QuestionID = q.QuestionID ")
            sbSQL.AppendFormat("WHERE sq.SurveyQuestionID = {0} ", ddlSurveyQuestionID.SelectedItem.Value)

            tbTitle.Text = SqlHelper.ExecuteScalar(m_oConn, CommandType.Text, sbSQL.ToString).ToString
        End If
    End Sub

    Private Sub SubmitScriptScreen()
        Dim ssResultsRow As QMS.dsScriptScreens.ScriptScreensRow = CType(m_oScriptScreens.MainDataTable.Rows(0), QMS.dsScriptScreens.ScriptScreensRow)
        Dim bRefreshCategories As Boolean = False

        'If CBool(ViewState(CHANGED_SURVEY_QUESTION_KEY)) Then ClearCategories()

        If ddlSurveyQuestionID.SelectedIndex > 0 Then
            'check for change in survey question
            If Not ssResultsRow.IsSurveyQuestionIDNull Then
                If CInt(ddlSurveyQuestionID.SelectedItem.Value) <> ssResultsRow.SurveyQuestionID Then
                    'change survey question
                    ClearCategories()
                    bRefreshCategories = True

                End If
            Else
                'added survey question
                bRefreshCategories = True

            End If
            'assign survey question
            ssResultsRow.SurveyQuestionID = ddlSurveyQuestionID.SelectedItem.Value

        Else
            If Not ssResultsRow.IsSurveyQuestionIDNull Then
                'removed survey question
                ClearCategories()
            End If

            'null survey question
            ssResultsRow.SetSurveyQuestionIDNull()

        End If

        ssResultsRow.Title = tbTitle.Text
        'TP Change
        ssResultsRow.Text = ucDescription.Text
        ssResultsRow.CalculationTypeID = ddlCalculationTypeID.SelectedItem.Value

        m_oScriptScreens.Save()

        'If CBool(ViewState(CHANGED_SURVEY_QUESTION_KEY)) Then
        If bRefreshCategories Then
            m_oScriptScreens.FillAnswerCategories()
            m_oScriptScreens.AddAllScriptScreenCategories()

        End If

        If m_oScriptScreens.ErrMsg.Length > 0 Then
            'display error messages
            DMI.WebFormTools.Msgbox(Page, m_oScriptScreens.ErrMsg)

        End If

        'ViewState(CHANGED_SURVEY_QUESTION_KEY) = False

    End Sub

    Private Sub ClearCategories()
        Dim dr As DataRow

        'remove categories for old survey question
        For Each dr In m_oScriptScreenCategories.MainDataTable.Rows
            dr.Delete()

        Next
        m_oScriptScreenCategories.Save()
        m_oAnswerCategories.MainDataTable.Clear()

    End Sub

    Public Sub ValidateScreenText(ByVal source As Object, ByVal args As ServerValidateEventArgs)
        If ucDescription.Text.Length = 0 Then
            'Screen text is blank
            args.IsValid = False
            cuvScreenText.ErrorMessage = "Screen text is required"

        ElseIf ucDescription.Text.Length > 4000 Then
            'Screen text is greater than 4000 characters
            cuvScreenText.ErrorMessage = "Screen text cannot be greater than 4000 characters (including HTML tags)"
            args.IsValid = False

        Else
            args.IsValid = True
        End If
    End Sub

    Private Sub ibResetQuestionText_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibResetQuestionText.Click
        GetQuestionTitle()
        GetQuestionText()
    End Sub

    Private Sub SetupSurveyQuestionDDL(ByVal ddl As DropDownList)
        Dim sqlDR As SqlClient.SqlDataReader = m_oScriptScreens.GetSurveyQuestionsList

        Do Until Not sqlDR.Read
            ddl.Items.Add(New ListItem(String.Format("{0}. {1}", sqlDR.Item("ItemOrder"), sqlDR.Item("ShortDesc")), sqlDR.Item("SurveyQuestionID").ToString))

        Loop
        ddl.Items.Insert(0, New ListItem("No Question", ""))

        sqlDR.Close()
        sqlDR = Nothing

    End Sub

    Private Sub SetupJumpToScreenDDL(ByVal ddl As DropDownList)
        Dim dr As DataRow
        Dim iCurrentItemOrder As Integer = 0

        If IsNothing(m_dtScreenList) Then
            m_dtScreenList = m_oScriptScreens.GetScriptScreensTable()
        End If
        iCurrentItemOrder = CInt(m_oScriptScreens.MainDataTable.Rows(0).Item("ItemOrder"))

        For Each dr In m_dtScreenList.Rows
            If CInt(dr.Item("ItemOrder")) > iCurrentItemOrder Then
                ddl.Items.Add(New ListItem(String.Format("{0}. {1}", dr.Item("ItemOrder"), dr.Item("Title")), dr.Item("ScriptScreenID").ToString))
            End If
        Next
        ddl.Items.Insert(0, New ListItem("End of Survey", -999))
        ddl.Items.Insert(0, New ListItem("Exit Survey", -99))
        ddl.Items.Insert(0, New ListItem("None", 0))

    End Sub

    Private Sub btnGoToScriptScreen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnGoToScriptScreen.Click
        If IsNumeric(ddlGoToScriptScreenID.SelectedValue) Then
            Response.Redirect(String.Format("scriptscreendetails.aspx?{0}={1}&{2}={3}", REQUEST_SCRIPT_SCREEN_ID_KEY, ddlGoToScriptScreenID.SelectedValue, REQUEST_SCRIPT_ID_KEY, ViewState(SCRIPT_ID_KEY)))

        End If
    End Sub

End Class
