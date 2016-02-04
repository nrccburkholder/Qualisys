Imports SurveyPointClasses
Imports SurveyPointDAL
Imports DataAccess

Partial Class ucTemplates
    Inherits System.Web.UI.UserControl

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

    Public Const NOT_SET As Integer = -1
    Private Const VIEWSTATE_SURVEYID As String = "SURVEYID"
    Private Const VIEWSTATE_SCRIPTID As String = "SCRIPTID"
    Private Const VIEWSTATE_CLIENTID As String = "CLIENTID"
    Private Const VIEWSTATE_FILEDEFID As String = "FILEDEFID"
    Private Const VIEWSTATE_SORT As String = "SORT"
    Private Const VIEWSTATE_REFERRER As String = "REFERRER"

    Private _SurveyID As Integer = NOT_SET
    Private _ScriptID As Integer = NOT_SET
    Private _ClientID As Integer = NOT_SET
    Private _FileDefID As Integer = NOT_SET

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            If (Not Page.IsPostBack) Then initPage()
        Catch ex As Exception
            DMI.WebFormTools.Msgbox(Page, Server.HtmlDecode(String.Format("An error occured loading the page.\n{0}\n{1}\n{2}", ex.Message, ex.StackTrace, ex.Source)))
        End Try

    End Sub

    Public Property SurveyID() As Integer
        Get
            If (IsNumeric(ViewState(Me.ClientID + VIEWSTATE_SURVEYID))) Then
                _SurveyID = CInt(ViewState(Me.ClientID + VIEWSTATE_SURVEYID))
            End If

            Return _SurveyID

        End Get
        Set(ByVal Value As Integer)
            _SurveyID = Value
            ViewState(Me.ClientID + VIEWSTATE_SURVEYID) = Value
        End Set
    End Property

    Public Property ScriptID() As Integer
        Get
            If (IsNumeric(ViewState(Me.ClientID + VIEWSTATE_SCRIPTID))) Then
                _ScriptID = CInt(ViewState(Me.ClientID + VIEWSTATE_SCRIPTID))
            End If
            Return _ScriptID
        End Get
        Set(ByVal Value As Integer)
            _ScriptID = Value
            ViewState(Me.ClientID + VIEWSTATE_SCRIPTID) = Value
        End Set
    End Property

    Public Property SurveyClientID() As Integer
        Get
            If (IsNumeric(ViewState(Me.ClientID + VIEWSTATE_CLIENTID))) Then
                _ClientID = CInt(ViewState(Me.ClientID + VIEWSTATE_CLIENTID))
            End If
            Return _ClientID
        End Get
        Set(ByVal Value As Integer)
            _ClientID = Value
            ViewState(Me.ClientID + VIEWSTATE_CLIENTID) = Value
        End Set
    End Property

    Public Property FileDefID() As Integer
        Get
            If (IsNumeric(ViewState(Me.ClientID + VIEWSTATE_FILEDEFID))) Then
                _FileDefID = CInt(ViewState(Me.ClientID + VIEWSTATE_FILEDEFID))
            End If
            Return _FileDefID
        End Get
        Set(ByVal Value As Integer)
            _FileDefID = Value
            ViewState(Me.ClientID + VIEWSTATE_FILEDEFID) = Value
        End Set
    End Property

    Public Property ReferrerURL() As String
        Get
            If (ViewState(VIEWSTATE_REFERRER) Is Nothing OrElse ViewState(VIEWSTATE_REFERRER) = "") Then
                Return Request.RawUrl()
            Else
                Return ViewState(VIEWSTATE_REFERRER)
            End If
        End Get
        Set(ByVal Value As String)
            ViewState(VIEWSTATE_REFERRER) = Value
        End Set
    End Property

    Private Sub initPage()
        ViewState(Me.ClientID + VIEWSTATE_SORT) = "TemplateID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgTemplates)
        SurveyPointClasses.clsWebTools.fillSurveyDDL(ddlSurvey)
        setNewTemplateAlert()
    End Sub

    Public Sub fillGrid()
        Dim dt As dsSurveyPoint.TemplatesDataTable = getTemplates()
        Dim dv As DataView = dt.DefaultView
        dv.Sort = ViewState(Me.ClientID + VIEWSTATE_SORT)

        dgTemplates.DataSource = dv
        dgTemplates.DataKeyField = "TemplateID"
        dgTemplates.DataBind()

        If (dt.Rows.Count > 0) Then
            ltTemplateResults.Text = String.Format("{0} template(s) found", dt.Rows.Count)
        Else
            ltTemplateResults.Text = "No templates found"
        End If

    End Sub

    Public Sub Search()
        dgTemplates.CurrentPageIndex = 0
        fillGrid()
    End Sub

    Protected Function getTemplates() As dsSurveyPoint.TemplatesDataTable
        Dim filter As DBFilter = New DBFilter
        If (Me.SurveyID <> NOT_SET) Then filter.AddSelectNumericFilter(clsTemplate.COL_SURVEYID, Me.SurveyID.ToString())
        If (Me.ScriptID <> NOT_SET) Then filter.AddSelectNumericFilter(clsTemplate.COL_SCRIPTID, Me.ScriptID.ToString())
        If (Me.SurveyClientID <> NOT_SET) Then filter.AddSelectNumericFilter(clsTemplate.COL_CLIENTID, Me.SurveyClientID.ToString())
        If (Me.FileDefID <> NOT_SET) Then filter.AddSelectNumericFilter(clsTemplate.COL_FILEDEFID, Me.FileDefID.ToString())
        Return clsTemplate.getTemplates(filter)
    End Function

    Private Sub ddlSurvey_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ddlSurvey.SelectedIndexChanged
        Try
            If (ddlSurvey.SelectedIndex > 0) Then
                Dim iSurveyID = CInt(ddlSurvey.SelectedValue)
                hlAdd.NavigateUrl = String.Format("../filedefinitions/{0}", templatedetails.getURL(0, iSurveyID, SurveyClientID, Server.UrlEncode(ReferrerURL)))
                hlAdd.Attributes.Remove("onClick")
            Else
                setNewTemplateAlert()
            End If

        Catch ex As Exception
            DMI.WebFormTools.Msgbox(Page, ex.Message)

        End Try
    End Sub

    Private Sub setNewTemplateAlert()
        hlAdd.Attributes.Add("onClick", "javascript:alert('Please select a survey.');")
        hlAdd.NavigateUrl = ""
    End Sub

    Private Sub dgTemplates_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgTemplates.PageIndexChanged
        Try
            dgTemplates.CurrentPageIndex = e.NewPageIndex
            fillGrid()

        Catch ex As Exception
            DMI.WebFormTools.Msgbox(Page, ex.Message)

        End Try

    End Sub

    Private Sub dgTemplates_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgTemplates.SortCommand
        Try
            Dim sSort As String = e.SortExpression
            Dim sLastSort As String = ViewState(Me.ClientID + VIEWSTATE_SORT)
            If (sSort = sLastSort) Then
                ViewState(Me.ClientID + VIEWSTATE_SORT) = String.Format("{0} DESC", sSort)
            Else
                ViewState(Me.ClientID + VIEWSTATE_SORT) = sSort
            End If
            fillGrid()

        Catch ex As Exception
            DMI.WebFormTools.Msgbox(Page, ex.Message)

        End Try

    End Sub

    Private Sub ibDelete_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click
        Try
            Dim iCountDelete = 0

            For Each dgi As DataGridItem In dgTemplates.Items
                If CType(dgi.FindControl("cbSelected"), CheckBox).Checked Then
                    Dim iTemplateID As Integer = CInt(dgTemplates.DataKeys(dgi.ItemIndex))
                    clsTemplate.deleteTemplate(iTemplateID)
                    iCountDelete += 1
                End If
            Next

            fillGrid()

            If (iCountDelete > 0) Then
                DMI.WebFormTools.Msgbox(Page, String.Format("{0} template(s) deleted", iCountDelete))
            Else
                DMI.WebFormTools.Msgbox(Page, "No templates selected")
            End If

        Catch ex As Exception
            DMI.WebFormTools.Msgbox(Page, ex.Message)

        End Try
    End Sub
End Class
