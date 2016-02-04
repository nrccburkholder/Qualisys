Partial Class frmPrintSurvey
    Inherits System.Web.UI.Page

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    Protected WithEvents dgAnswerCategories As System.Web.UI.WebControls.DataGrid

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Public Const REQUEST_SURVEYID_KEY As String = "id"
    Private _Connection As SqlClient.SqlConnection

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Not Page.IsPostBack Then
            _Connection = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)

            Try
                ValidateRequest()
                BindSurvey(CInt(Request.QueryString(REQUEST_SURVEYID_KEY)))

            Catch ex As Exception
                DMI.WebFormTools.Msgbox(Page, ex.Message)

            Finally
                If Not IsNothing(_Connection) Then
                    _Connection.Close()
                    _Connection.Dispose()
                End If
            End Try

        End If

    End Sub

    Private Sub ValidateRequest()
        If Not IsNumeric(Request.QueryString(REQUEST_SURVEYID_KEY)) Then
            Throw New ApplicationException("Cannot generate survey. Invalid survey id value.")
        End If
    End Sub

    Private Sub BindSurvey(ByVal surveyID As Integer)
        Dim dr As SqlClient.SqlDataReader


    End Sub

    Private Sub rptQuestions_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rptQuestions.ItemDataBound

    End Sub
End Class
