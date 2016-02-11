Partial Class frmQuestionBank
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

    Private m_oQuestionFolders As QMS.clsQuestionFolders
    Private m_oConn As SqlClient.SqlConnection

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)

        'Determine whether page setup is required:
        'QuestionFolder has posted back to same page
        If Not Page.IsPostBack Then
            PageLoad()

        Else
            LoadDataSet()            
        End If

    End Sub

    Private Sub PageLoad()
        'security check
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.SURVEY_VIEWER) Then
            'run page setup
            PageSetup()
            'set controls for security privledges
            SecuritySetup()
            'clean up page objects
            PageCleanUp()

        Else
            'QuestionFolder does not have QuestionFolder viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

        End If

    End Sub

    Private Sub PageSetup()
        'setup sort variable
        Viewstate("LastSort") = "Active DESC, Name"
        'format datagrid
        dgQuestionFolders.DataKeyField = "QuestionFolderID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgQuestionFolders)
        'fill main table
        LoadDataSet()
        'set data source and bind grid
        QuestionFoldersGridBind()

    End Sub

    Private Sub PageCleanUp()
        'clean up page objects
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oQuestionFolders) Then
            m_oQuestionFolders.Close()
            m_oQuestionFolders = Nothing
        End If

    End Sub

    Private Sub LoadDataSet()
        m_oQuestionFolders = New QMS.clsQuestionFolders(m_oConn)
        m_oQuestionFolders.FillMain()

    End Sub

    Private Sub QuestionFoldersGridBind()
        Dim iRowCount As Integer

        iRowCount = m_oQuestionFolders.DataGridBind(dgQuestionFolders, ViewState("LastSort").ToString)
        ltResultsFound.Text = String.Format("{0} Question Folders", iRowCount)

    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.SURVEY_DESIGNER) Then
            'must be survey designer to add or delete QuestionFolders
            hlAdd.Visible = False
            ibDelete.Visible = False

        End If

    End Sub

    Private Sub dgQuestionFolders_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgQuestionFolders.SortCommand
        Viewstate("LastSort") = m_oQuestionFolders.DataGridSort(dgQuestionFolders, e, Viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub ibDelete_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click
        m_oQuestionFolders.DataGridDelete(dgQuestionFolders, viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub dgQuestionFolders_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgQuestionFolders.PageIndexChanged
        m_oQuestionFolders.DataGridPageChange(dgQuestionFolders, e, viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub dgQuestionFolders_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgQuestionFolders.ItemDataBound
        Dim drv As DataRowView

        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            drv = CType(e.Item.DataItem, DataRowView)
            'set survey name column
            CType(e.Item.FindControl("ltFolderName"), Literal).Text = String.Format("<b>{0}</b><br>{1}", drv.Item("Name"), drv.Item("Description"))
            'set author name column
            CType(e.Item.FindControl("ltActive"), Literal).Text = IIf(drv.Item("Active") = 1, "Yes", "No")

        End If

    End Sub
End Class
