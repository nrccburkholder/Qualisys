Imports SurveyPointClasses
Imports SurveyPointDAL

Partial Class triggers
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

    Private Const VIEWSTATE_SORT As String = "SORT"

    Private _TriggerHelper As clsTriggers = Nothing
    Private _DBConn As SqlClient.SqlConnection = Nothing

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If (Not Page.IsPostBack) Then InitPage()

    End Sub

    Protected Sub InitPage()
        clsWebTools.fillSurveyDDL(CType(ddlSurveyID, ListControl), "")
        clsWebTools.fillTriggerTypeDDL(CType(ddlType, ListControl), "")
        ddlType.Items.Remove("1") 'remove script screen triggers
        clsWebTools.fillInvocationPointDDL(CType(ddlInvocationPoint, ListControl), "")
        QMS.clsQMSTools.FormatQMSDataGrid(dgTriggers)
        ViewState(VIEWSTATE_SORT) = "TriggerID"

    End Sub

    Protected Sub FillTriggersGrid()
        Dim dt As dsSurveyPoint.TriggersDataTable = getTriggers()
        Dim dv As DataView = dt.DefaultView
        dv.Sort = ViewState(VIEWSTATE_SORT)

        dgTriggers.DataSource = dv
        dgTriggers.DataKeyField = "TriggerID"
        dgTriggers.DataBind()

        If (dt.Rows.Count > 0) Then
            ltResultsFound.Text = String.Format("{0} triggers(s) found", dt.Rows.Count)
        Else
            ltResultsFound.Text = "No triggers found"
        End If

    End Sub

    Protected Function getTriggers() As dsSurveyPoint.TriggersDataTable
        Dim SurveyID As Integer = -1
        Dim TriggerTypeID As Integer = -1
        Dim InvocationPointID As Integer = -1
        Dim TriggerName As String = Nothing

        If (ddlSurveyID.SelectedIndex > 0) Then SurveyID = CInt(ddlSurveyID.SelectedValue)
        If (ddlType.SelectedIndex > 0) Then TriggerTypeID = CInt(ddlType.SelectedValue)
        If (ddlInvocationPoint.SelectedIndex > 0) Then InvocationPointID = CInt(ddlInvocationPoint.SelectedValue)
        If (tbTriggerName.Text.Length > 0) Then TriggerName = tbTriggerName.Text

        Return clsTriggers.GetTriggers(SurveyID, TriggerTypeID, InvocationPointID, TriggerName, False, False)

    End Function

    Private Sub dgTriggers_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgTriggers.PageIndexChanged
        dgTriggers.CurrentPageIndex = e.NewPageIndex
        FillTriggersGrid()

    End Sub

    Private Sub dgTriggers_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgTriggers.SortCommand
        If (e.SortExpression = ViewState(VIEWSTATE_SORT)) Then
            ViewState(VIEWSTATE_SORT) = String.Format("{0} DESC", e.SortExpression)
        Else
            ViewState(VIEWSTATE_SORT) = e.SortExpression
        End If
        FillTriggersGrid()

    End Sub

    Private Sub ibDelete_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click

        Dim iCount As Integer = 0
        For Each dgi As DataGridItem In dgTriggers.Items
            Dim cb As CheckBox = CType(dgi.FindControl("cbSelect"), CheckBox)
            If (cb.Checked) Then
                Dim iTriggerID As Integer = CInt(dgTriggers.DataKeys(dgi.ItemIndex))
                TriggerHelper.DeleteTrigger(iTriggerID)
                iCount += 1
            End If
        Next

        If iCount > 0 Then
            DMI.WebFormTools.Msgbox(Me, String.Format("{0} Trigger(s) deleted", iCount))
        Else
            DMI.WebFormTools.Msgbox(Me, "No triggers selected")
        End If

        FillTriggersGrid()


    End Sub

    Private Sub btnSearch_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSearch.Click
        If Page.IsValid Then
            dgTriggers.CurrentPageIndex = 0
            FillTriggersGrid()
        End If
    End Sub

    Protected ReadOnly Property TriggerHelper() As clsTriggers
        Get
            If IsNothing(_TriggerHelper) Then
                _TriggerHelper = New clsTriggers
                _TriggerHelper.DBConnection = DBConnection
            End If
            Return _TriggerHelper
        End Get
    End Property

    Protected ReadOnly Property DBConnection() As SqlClient.SqlConnection
        Get
            If IsNothing(_DBConn) Then _DBConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
            Return _DBConn
        End Get
    End Property

    Private Sub Page_Unload(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Unload
        If Not IsNothing(_DBConn) Then
            If _DBConn.State = ConnectionState.Open Then _DBConn.Close()
            _DBConn.Dispose()
        End If

    End Sub
End Class
