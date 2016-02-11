Imports SurveyPointClasses
Imports SurveyPointDAL

Partial Class templatedetails
    Inherits System.Web.UI.Page

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Public Const QUERYSTRING_TEMPLATEID As String = "id"
    Public Const QUERYSTRING_SURVEYID As String = "sid"
    Public Const QUERYSTRING_CLIENTID As String = "cid"
    Public Const KEY_REFERRER As String = "r"
    Private _TemplateRow As dsSurveyPoint.TemplatesRow = Nothing

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            If (Not Page.IsPostBack) Then initPage()

        Catch ex As Exception
            clsLog.LogError(GetType(templatedetails), "Page_Load", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub initPage()
        ReferrerURL = Request.QueryString(KEY_REFERRER)
        hlCancel.NavigateUrl = ReferrerURL
        If (IsNumeric(Request.QueryString(QUERYSTRING_TEMPLATEID)) AndAlso loadTemplateData()) Then
            initTemplatePage()
        Else
            initNewTemplatePage()
        End If
    End Sub

    Private Sub initNewTemplatePage()
        If IsNumeric(Request.QueryString(QUERYSTRING_SURVEYID)) Then
            Dim iSurveyId As Integer = CInt(Request.QueryString(QUERYSTRING_SURVEYID))
            fillDDL(iSurveyId)
            ltTemplateId.Text = "NEW"
            Dim surveyRow As dsSurveyPoint.SurveysRow = clsSurvey.getSurvey(iSurveyId)
            If (Not IsNothing(surveyRow)) Then ltSurveyName.Text = surveyRow.Name
        End If
    End Sub

    Private Sub initTemplatePage()
        If (Not IsNothing(_TemplateRow)) Then
            fillDDL(_TemplateRow.SurveyID)
            ltTemplateId.Text = _TemplateRow.TemplateID.ToString()
            ltSurveyName.Text = _TemplateRow.SurveyName
            If (Not _TemplateRow.IsNotesNull()) Then tbName.Text = _TemplateRow.Notes
            If (Not _TemplateRow.IsDescriptionNull()) Then tbDecription.Text = _TemplateRow.Description
            ddlClientID.SelectedValue = _TemplateRow.ClientID
            ddlScriptID.SelectedValue = _TemplateRow.ScriptID
            If (Not _TemplateRow.IsFileDefIDNull()) Then ddlFileDefID.SelectedValue = _TemplateRow.FileDefID
        End If
    End Sub

    Private Sub fillDDL(ByVal iSurveyID As Integer)
        clsWebTools.fillClientDDLBySurvey(ddlClientID, iSurveyID)
        clsWebTools.fillScriptDDLBySurvey(ddlScriptID, iSurveyID)
        clsWebTools.fillFileDefImportUpdatesDDLBySurvey(ddlFileDefID, iSurveyID)
        If (IsNumeric(Request.QueryString(QUERYSTRING_CLIENTID))) Then
            Dim sClientID As String = Request.QueryString(QUERYSTRING_CLIENTID)
            ddlClientID.SelectedValue = sClientID
        End If
    End Sub

    Private Function loadTemplateData() As Boolean
        Dim iTemplateId As Integer = CInt(Request.QueryString(QUERYSTRING_TEMPLATEID))
        _TemplateRow = clsTemplate.getTemplate(iTemplateId)
        Return Not IsNothing(_TemplateRow)
    End Function

    Private Sub ibSave_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibSave.Click
        Dim bRedirect As Boolean = False

        Try
            If (Page.IsValid) Then
                getFormValues()
                If (IsNumeric(ltTemplateId.Text)) Then
                    clsTemplate.updateTemplate(_TemplateRow)
                    If (ddlFileDefID.SelectedValue = "GENERATE") Then
                        clsFileDefs.generateFileDefForTemplate(_TemplateRow.TemplateID)
                        bRedirect = True
                    End If
                Else
                    clsTemplate.insertTemplate(_TemplateRow)
                    If (ddlFileDefID.SelectedValue = "GENERATE") Then
                        clsFileDefs.generateFileDefForTemplate(_TemplateRow.TemplateID)
                    End If
                    bRedirect = True
                End If
            End If

        Catch ex As Exception
            clsLog.LogError(GetType(templatedetails), "ibSave_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try

        If bRedirect Then Response.Redirect(getURL(_TemplateRow.TemplateID, 0, 0, ReferrerURL))

    End Sub

    Private Sub getFormValues()
        _TemplateRow = (New dsSurveyPoint).Templates.NewTemplatesRow()
        If (IsNumeric(ltTemplateId.Text)) Then _TemplateRow.TemplateID = CInt(ltTemplateId.Text)
        _TemplateRow.Notes = tbName.Text
        _TemplateRow.Description = tbDecription.Text
        _TemplateRow.ClientID = CInt(ddlClientID.SelectedValue)
        _TemplateRow.ScriptID = CInt(ddlScriptID.SelectedValue)
        If (ddlFileDefID.SelectedIndex > 0 AndAlso ddlFileDefID.SelectedValue <> "GENERATE") Then
            _TemplateRow.FileDefID = CInt(ddlFileDefID.SelectedValue)
        Else
            _TemplateRow.SetFileDefIDNull()
        End If
    End Sub

    Public Shared Function getURL(ByVal iTemplateID As Integer, ByVal iSurveyID As Integer, ByVal iClientID As Integer, Optional ByVal sURL As String = "") As String
        Dim qsKey As String
        Dim qsValue As Integer
        Dim sb As StringBuilder = New StringBuilder

        If (iTemplateID > 0) Then
            qsKey = QUERYSTRING_TEMPLATEID
            qsValue = iTemplateID
        Else
            qsKey = QUERYSTRING_SURVEYID
            qsValue = iSurveyID
        End If

        sb.AppendFormat("templatedetails.aspx?{0}={1}", qsKey, qsValue)
        If (iClientID > 0) Then sb.AppendFormat("&{0}={1}", QUERYSTRING_CLIENTID, iClientID)
        If (sURL.Length > 0) Then sb.AppendFormat("&{0}={1}", KEY_REFERRER, sURL)

        Return sb.ToString()

    End Function

    Public Sub validateClientScriptTemplate(ByVal source As Object, ByVal args As ServerValidateEventArgs)
        Dim result As Boolean = False
        If (ddlClientID.SelectedIndex > 0 AndAlso ddlScriptID.SelectedIndex > 0) Then
            Dim iClientID As Integer = CInt(ddlClientID.SelectedValue)
            Dim iScriptID As Integer = CInt(ddlScriptID.SelectedValue)
            Dim iTemplateID As Integer
            If (ltTemplateId.Text = "NEW") Then
                iTemplateID = -1
            Else
                iTemplateID = CInt(ltTemplateId.Text)
            End If
            result = Not clsTemplate.existClientScriptTemplate(iClientID, iScriptID, iTemplateID)
        End If
        args.IsValid = result
    End Sub

    Public Property ReferrerURL() As String
        Get
            Return ViewState(KEY_REFERRER)
        End Get
        Set(ByVal Value As String)
            ViewState(KEY_REFERRER) = Value
        End Set
    End Property

    Private Sub ibClient_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibClient.Click
        If (ddlClientID.SelectedIndex > 0) Then
            Response.Redirect(String.Format("../clients/clientdetails.aspx?id={0}", ddlClientID.SelectedValue))
        End If
    End Sub

    Private Sub ibScript_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibScript.Click
        If (ddlScriptID.SelectedIndex > 0) Then
            Response.Redirect(String.Format("../scripts/scriptdetails.aspx?id={0}", ddlScriptID.SelectedValue))
        End If
    End Sub

    Private Sub ibFileDef_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibFileDef.Click
        If (ddlFileDefID.SelectedIndex > 0) Then
            Response.Redirect(String.Format("../filedefinitions/filedefinitiondetails.aspx?id={0}", ddlFileDefID.SelectedValue))
        End If
    End Sub
End Class
