Partial Class TaskCalendar
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

    Private connection As SqlClient.SqlConnection

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        connection = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
    End Sub

    Private Sub cdrSurveyTasks_DayRender(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DayRenderEventArgs) Handles cdrSurveyTasks.DayRender
        Dim dr As SqlClient.SqlDataReader

        Try
            Dim sbDay As New System.Text.StringBuilder
            dr = QMS.clsProtocolSteps.GetProtocolStepsByDay(connection, e.Day.Date())
            While dr.Read
                sbDay.AppendFormat("<li><b>{0}</b>: <i>{1}</i> {2}", dr("ClientName"), dr("InstanceName"), dr("ProtocolStepTypeName"))
            End While
            If sbDay.Length > 0 Then
                sbDay.Insert(0, "<ul>")
                sbDay.Append("</ul>")
                sbDay.Insert(0, e.Day.DayNumberText)
                e.Cell.Text = sbDay.ToString
            End If
        Finally
            If Not IsNothing(dr) Then dr.Close()
        End Try


    End Sub

    Protected Overrides Sub OnUnload(ByVal e As System.EventArgs)
        If Not IsNothing(connection) Then
            connection.Close()
            connection.Dispose()
        End If
    End Sub

End Class
