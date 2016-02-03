Imports Microsoft.ApplicationBlocks.Data

Partial Class frmUserSessions
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

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Not Page.IsPostBack Then GenerateReport()
    End Sub

    Private Sub GenerateReport()
        Dim cn As New SqlClient.SqlConnection(DMI.DataHandler.sConnection)

        Try
            Dim ds As DataSet
            ds = SqlHelper.ExecuteDataset(cn, CommandType.Text, "SELECT * FROM vr_UserSessions")
            dbdgUserSessions.DataSource = ds.Tables(0)
            dbdgUserSessions.DataBind()
            ltResultsFound.Text = String.Format("{0} Users", ds.Tables(0).Rows.Count)

        Catch ex As Exception
            DMI.WebFormTools.Msgbox(Me, ex.Message)
        Finally
            If Not IsNothing(cn) Then
                cn.Close()
                cn.Dispose()
                cn = Nothing
            End If
        End Try


    End Sub
End Class
