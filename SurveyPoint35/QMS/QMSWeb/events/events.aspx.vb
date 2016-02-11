Partial Class frmEvents
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

    Private Const LAST_SORT_KEY As String = "LastSort"
    Private Const SEARCH_KEY As String = "search"

    Private m_oEvents As QMS.clsEvents
    Private m_oConn As SqlClient.SqlConnection
    Private m_sDSName As String

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
            m_oEvents = New QMS.clsEvents(m_oConn)
            m_sDSName = Request.Url.AbsolutePath

            'Determine whether page setup is required:
            'SurveyInstance has posted back to same page
            If Not Page.IsPostBack Then PageLoad()

        Catch ex As Exception
            clsLog.LogError(GetType(frmEvents), "Page_Load", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured loading page.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub PageLoad()
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.EVENT_VIEWER) Then
            'run page setup
            PageSetup()
            'set controls for security privledges
            SecuritySetup()

            'load datagrid
            BuildSearch()
            LoadDataSet()
            dgEvents.CurrentPageIndex = 0
            EventsGridBind()

            'clean up page objects
            PageCleanUp()

        Else
            'user does not have event log viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

        End If

    End Sub

    Private Sub PageSetup()
        Dim sqlDR As SqlClient.SqlDataReader

        'setup sort variable
        Viewstate(LAST_SORT_KEY) = "EventID"
        ViewState(SEARCH_KEY) = ""

        'setup page controls
        'init event type dropdown
        sqlDR = QMS.clsEvents.GetEventTypesDataSource(m_oConn)
        ddlEventTypeIDSearch.DataSource = sqlDR
        ddlEventTypeIDSearch.DataTextField = "Name"
        ddlEventTypeIDSearch.DataValueField = "EventTypeID"
        ddlEventTypeIDSearch.DataBind()
        ddlEventTypeIDSearch.Items.Insert(0, New ListItem("Select Event Type", "0"))
        sqlDR.Close()

        'format datagrid
        dgEvents.DataKeyField = "EventID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgEvents)

    End Sub

    Private Sub PageCleanUp()
        'clean up page objects
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oEvents) Then
            m_oEvents.Close()
            m_oEvents = Nothing
        End If

    End Sub

    Private Sub LoadDataSet()
        Dim drCriteria As DataRow

        If ViewState(SEARCH_KEY).ToString.Length > 0 Then
            drCriteria = m_oEvents.RestoreSearch(ViewState(SEARCH_KEY).ToString, m_sDSName)
            m_oEvents.FillMain(drCriteria)

        End If

    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.EVENT_ADMIN) Then
            'must have event admin rights to add, edit, or delete events
            ibAdd.Enabled = False
            ibDelete.Enabled = False
            dgEvents.Columns(6).Visible = False

        End If

    End Sub

    Private Sub EventsGridBind(Optional ByVal sSortBy As String = "")
        Dim iRowCount As Integer

        iRowCount = m_oEvents.DataGridBind(dgEvents, ViewState(LAST_SORT_KEY).ToString)
        ltResultsFound.Text = String.Format("{0} Events", iRowCount)

    End Sub

    Private Sub BuildSearch()
        Dim dr As QMS.dsEvents.SearchRow = CType(m_oEvents.NewSearchRow, QMS.dsEvents.SearchRow)

        If IsNumeric(tbEventIDSearch.Text) Then dr.EventID = CInt(tbEventIDSearch.Text)
        If tbNameSearch.Text.Length > 0 Then dr.Keyword = String.Format("%{0}%", tbNameSearch.Text)
        If ddlEventTypeIDSearch.SelectedIndex > 0 Then dr.EventTypeID = CInt(ddlEventTypeIDSearch.SelectedValue)

        ViewState(SEARCH_KEY) = m_oEvents.SaveSearch(dr, m_sDSName)

    End Sub

    Private Sub dgEvents_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgEvents.PageIndexChanged
        Try
            LoadDataSet()
            m_oEvents.DataGridPageChange(dgEvents, e, ViewState(LAST_SORT_KEY).ToString)
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmEvents), "dgEvents_PageIndexChanged", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured paging grid.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub dgEvents_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgEvents.SortCommand
        Try
            LoadDataSet()
            m_oEvents.DataGridSort(dgEvents, e, ViewState(LAST_SORT_KEY).ToString)
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmEvents), "dgEvents_SortCommand", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured sorting.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub ibAdd_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibAdd.Click
        Try
            LoadDataSet()
            m_oEvents.DataGridNewItem(dgEvents, ViewState("LastSort").ToString)
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmEvents), "ibAdd_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured adding.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub btnSearch_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSearch.Click
        Try
            If Page.IsValid Then
                BuildSearch()
                LoadDataSet()
                dgEvents.CurrentPageIndex = 0
                EventsGridBind()

            End If
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmEvents), "btnSearch_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured searching.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub dgEvents_EditCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgEvents.EditCommand
        Try
            LoadDataSet()
            m_oEvents.DataGridEditItem(dgEvents, e, viewstate("LastSort").ToString)
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmEvents), "dgEvents_EditCommand", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured editing.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub dgEvents_CancelCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgEvents.CancelCommand
        Try
            LoadDataSet()
            m_oEvents.DataGridCancel(dgEvents, ViewState("LastSort").ToString)
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmEvents), "dgEvents_CancelCommand", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured cancelling.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub dgEvents_UpdateCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgEvents.UpdateCommand
        Try
            Dim dr As QMS.dsEvents.tblEventsRow

            If Page.IsValid Then
                LoadDataSet()
                'get existing datarow or create new datarow
                dr = CType(m_oEvents.SelectRow(dgEvents.DataKeys(CInt(e.Item.ItemIndex))), QMS.dsEvents.tblEventsRow)
                If IsNothing(dr) Then dr = CType(m_oEvents.AddMainRow, QMS.dsEvents.tblEventsRow)

                Try
                    'copy form values into datarow
                    With e.Item
                        dr.EventID = CInt(CType(.FindControl("tbEventID"), TextBox).Text)
                        dr.Name = CType(.FindControl("tbName"), TextBox).Text
                        dr.Description = CType(.FindControl("tbDescription"), TextBox).Text
                        dr.EventTypeID = CInt(CType(.FindControl("ddlEventTypeID"), DropDownList).SelectedValue)
                        dr.FinalCode = CInt(IIf(CType(.FindControl("cbFinalCode"), CheckBox).Checked, 1, 0))
                        dr.DefaultNonContact = CInt(CType(.FindControl("tbDefaultNonContact"), TextBox).Text)
                        dr.EventTypeName = CType(.FindControl("ddlEventTypeID"), DropDownList).SelectedItem.Text

                    End With

                    'commit changes to database
                    m_oEvents.Save()

                    If m_oEvents.ErrMsg.Length = 0 Then
                        'exit edit mode and rebind datagrid
                        dgEvents.EditItemIndex = -1
                        EventsGridBind()

                    Else
                        'display error
                        DMI.WebFormTools.Msgbox(Page, m_oEvents.ErrMsg)

                    End If

                Catch ex As Exception
                    DMI.WebFormTools.Msgbox(Page, ex.Message)

                End Try

            End If

            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmEvents), "dgEvents_UpdateCommand", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured updating.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub dgEvents_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgEvents.ItemDataBound
        Dim drv As DataRowView
        Dim ddl As DropDownList
        Dim tb As TextBox
        Dim sqlDR As SqlClient.SqlDataReader

        If e.Item.ItemType = ListItemType.EditItem Then
            drv = CType(e.Item.DataItem, DataRowView)

            'Setup event type dropdown
            ddl = CType(e.Item.FindControl("ddlEventTypeID"), DropDownList)
            sqlDR = QMS.clsEvents.GetEventTypesDataSource(m_oConn)
            ddl.DataSource = sqlDR
            ddl.DataTextField = "Name"
            ddl.DataValueField = "EventTypeID"
            ddl.DataBind()
            sqlDR.Close()
            sqlDR = Nothing
            DMI.WebFormTools.SetListControl(ddl, CInt(CType(drv("EventTypeID"), String)))

            'Setup event id textbox, enable if new event
            tb = CType(e.Item.FindControl("tbEventID"), TextBox)
            If drv.Row.RowState = DataRowState.Added Then
                tb.Enabled = True

            Else
                tb.Enabled = False

            End If

        End If

    End Sub

    Private Sub ibDelete_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click
        Try
            LoadDataSet()
            m_oEvents.DataGridDelete(dgEvents, ViewState(LAST_SORT_KEY).ToString)
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmEvents), "ibDelete_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured deleting.\nError has been logged, please report to administrator.")

        End Try

    End Sub
End Class
