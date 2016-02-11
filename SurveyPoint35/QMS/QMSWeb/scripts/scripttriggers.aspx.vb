Imports Microsoft.ApplicationBlocks.Data

Partial Class frmScriptTriggers
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

    Private _Connection As SqlClient.SqlConnection
    Private _ScriptTriggerDetails As QMS.clsScriptTriggerDetails
    Private _dt As DataTable
    Private _DSName As String
    Private Const LAST_SORT_KEY As String = "LastSort"
    Private Const SEARCH_KEY As String = "search"
    Public Const SCRIPT_ID_KEY As String = "id"
    Public Const SCREEN_ID_KEY As String = "scr"

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        _Connection = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
        _ScriptTriggerDetails = New QMS.clsScriptTriggerDetails(_Connection)
        _DSName = Request.Url.AbsolutePath

        'Determine whether page setup is required:
        'user has posted back to same page
        If Not Page.IsPostBack Then PageLoad()

    End Sub

    Private Sub PageLoad()

        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.SCRIPT_VIEWER) Then
            'run page setup
            PageSetup()
            'set controls for security privledges
            SecuritySetup()
            'clean up page objects
            PageCleanUp()

        Else
            'Survey does not have Survey viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

        End If

    End Sub

    Private Sub PageSetup()
        Dim sqlDR As SqlClient.SqlDataReader

        'setup sort variable
        Viewstate(LAST_SORT_KEY) = "ItemOrder"
        ViewState(SEARCH_KEY) = ""
        If IsNumeric(Request.Item(SCRIPT_ID_KEY)) Then
            ViewState(SCRIPT_ID_KEY) = CInt(Request.Item(SCRIPT_ID_KEY))
        Else
            DMI.WebFormTools.Msgbox(Page, "Invalid Script ID passed")
        End If
        If IsNumeric(Request.Item(SCREEN_ID_KEY)) Then
            ViewState(SCREEN_ID_KEY) = CInt(Request.Item(SCREEN_ID_KEY))
        Else
            ViewState(SCREEN_ID_KEY) = ""
        End If

        'setup page controls
        hlScriptName.Text = SqlHelper.ExecuteScalar(_Connection, CommandType.Text, _
            String.Format("SELECT Name FROM Scripts WHERE ScriptID = {0}", ViewState(SCRIPT_ID_KEY)))
        hlScriptName.NavigateUrl = String.Format("scriptdetails.aspx?{0}={1}", frmScriptDetails.REQUEST_SCRIPT_ID_KEY, ViewState(SCRIPT_ID_KEY))
        hlAdd.NavigateUrl = String.Format("scripttriggerdetails.aspx?{0}={1}", frmScriptTriggerDetails.SCRIPT_ID_KEY, ViewState(SCRIPT_ID_KEY))

        'format datagrid
        dgScriptTriggers.DataKeyField = "ScriptedTriggerID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgScriptTriggers)

        'setup datagrid
        BuildSearch()
        LoadDataSet()
        dgScriptTriggers.CurrentPageIndex = 0
        ScriptTriggersGridBind()

    End Sub

    Private Sub PageCleanUp()
        'clean up page objects
        If Not IsNothing(_Connection) Then
            _Connection.Close()
            _Connection.Dispose()
            _Connection = Nothing
        End If
        If Not IsNothing(_ScriptTriggerDetails) Then
            _ScriptTriggerDetails.Close()
            _ScriptTriggerDetails = Nothing
        End If

    End Sub

    Private Sub LoadDataSet()
        Dim drCriteria As DataRow

        If ViewState(SEARCH_KEY).ToString.Length > 0 Then
            drCriteria = _ScriptTriggerDetails.ScriptTriggers.RestoreSearch(ViewState(SEARCH_KEY).ToString, _DSName)
            _ScriptTriggerDetails.FillTriggers(drCriteria)
            _ScriptTriggerDetails.FillScriptTriggers(drCriteria)

        End If

    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.SCRIPT_DESIGNER) Then
            hlAdd.Visible = False
            ibDelete.Visible = False

        End If

    End Sub

    Private Sub BuildSearch()
        Dim dr As QMS.dsScriptTriggers.SearchRow

        dr = CType(_ScriptTriggerDetails.ScriptTriggers.NewSearchRow, QMS.dsScriptTriggers.SearchRow)

        If IsNumeric(ViewState(SCRIPT_ID_KEY)) Then dr.ScriptID = CInt(ViewState(SCRIPT_ID_KEY))
        If IsNumeric(ViewState(SCREEN_ID_KEY)) Then dr.ScriptScreenID = CInt(ViewState(SCREEN_ID_KEY))

        ViewState(SEARCH_KEY) = _ScriptTriggerDetails.ScriptTriggers.SaveSearch(dr, _DSName)

    End Sub

    Private Sub ScriptTriggersGridBind()
        Dim iRowCount As Integer

        iRowCount = _ScriptTriggerDetails.ScriptTriggers.DataGridBind(dgScriptTriggers, ViewState(LAST_SORT_KEY).ToString)
        ltResultsFound.Text = String.Format("{0} Triggers", iRowCount)

    End Sub

    Private Sub dgScriptTriggers_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgScriptTriggers.ItemDataBound
        Dim drv As DataRowView

        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            drv = CType(e.Item.DataItem, DataRowView)
            If Not IsDBNull(drv.Item("TriggerName")) Then
                CType(e.Item.FindControl("ltTriggerName"), Literal).Text = drv.Item("TriggerName")
            Else
                CType(e.Item.FindControl("ltTriggerName"), Literal).Text = "NONE"
            End If

            If Not IsDBNull(drv.Item("ScreenTitle")) Then
                CType(e.Item.FindControl("ltScreenTitle"), Literal).Text = String.Format("{0}. {1}", drv.Item("ItemOrder"), drv.Item("ScreenTitle"))
            Else
                CType(e.Item.FindControl("ltScreenTitle"), Literal).Text = "SCRIPT LEVEL"
            End If

            If drv.Item("TriggerIDValue4") = 1 Then
                CType(e.Item.FindControl("ltPrePost"), Literal).Text = "Post"
            Else
                CType(e.Item.FindControl("ltPrePost"), Literal).Text = "Pre"
            End If
            CType(e.Item.FindControl("hlDetails"), HyperLink).NavigateUrl = String.Format("scripttriggerdetails.aspx?{0}={1}", frmScriptTriggerDetails.SCRIPT_TRIGGER_ID_KEY, drv.Item("ScriptedTriggerID"))
            drv = Nothing

        End If

    End Sub

    Private Sub ibDelete_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click
        Dim iRowCount As Integer

        LoadDataSet()
        _ScriptTriggerDetails.ScriptTriggers.DataGridDelete(dgScriptTriggers, ViewState(LAST_SORT_KEY).ToString)
        iRowCount = _ScriptTriggerDetails.ScriptTriggers.MainDataTable.Rows.Count
        ltResultsFound.Text = String.Format("{0} Triggers", iRowCount)
        PageCleanUp()

    End Sub

End Class
