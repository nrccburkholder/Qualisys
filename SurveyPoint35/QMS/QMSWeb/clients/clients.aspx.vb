Partial Class frmClients
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


    Private m_oClients As QMS.clsClients
    Private m_oConn As SqlClient.SqlConnection

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)

            'Determine whether page setup is required:
            'user has posted back to same page
            If Not Page.IsPostBack Then
                PageLoad()

            Else
                LoadDataSet()

            End If

        Catch ex As Exception
            clsLog.LogError(GetType(frmClients), "Page_Load", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured loading page.\nError has been logged, please report to administrator.")

        End Try


    End Sub

    Private Sub PageLoad()
        'security check
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.CLIENT_VIEWER) Then
            'run page setup
            PageSetup()
            'set controls for security privledges
            SecuritySetUp()
            'clean up page objects
            PageCleanUp()

        Else
            'user does not have user viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

        End If

    End Sub

    Private Sub PageSetup()
        'setup sort variable
        Viewstate("LastSort") = "Active DESC, Name"
        'fill main table
        LoadDataSet()

        'format datagrid
        dgClients.DataKeyField = "ClientID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgClients)
        ClientsGridBind()

    End Sub

    Private Sub PageCleanUp()
        'clean up page objects
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oClients) Then
            m_oClients.Close()
            m_oClients = Nothing
        End If

    End Sub

    Private Sub LoadDataSet()
        m_oClients = New QMS.clsClients(m_oConn)
        m_oClients.FillMain()

    End Sub

    Private Sub ClientsGridBind()
        Dim iRowCount As Integer

        iRowCount = m_oClients.DataGridBind(dgClients, Viewstate("LastSort").ToString)
        ltResultsFound.Text = String.Format("{0} Clients", iRowCount)

    End Sub

    Private Sub SecuritySetUp()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.CLIENT_ADMIN) Then
            'must have client admin rights to add and delete clients
            hlAddClient.Visible = False
            ibDelete.Visible = False

        End If

    End Sub

    Private Sub dgClients_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgClients.PageIndexChanged
        Try
            m_oClients.DataGridPageChange(dgClients, e, viewstate("LastSort").ToString)
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmClients), "dgClients_PageIndexChanged", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured changing page.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub dgClients_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgClients.SortCommand
        Try
            Viewstate("LastSort") = m_oClients.DataGridSort(dgClients, e, Viewstate("LastSort").ToString)
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmClients), "dgClients_SortCommand", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured sorting.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub ibDelete_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click
        Try
            m_oClients.DataGridDelete(dgClients, viewstate("LastSort").ToString)
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmClients), "ibDelete_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured deleting.\nError has been logged, please report to administrator.")

        End Try

    End Sub

End Class
