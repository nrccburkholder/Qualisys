Imports System.Data
Imports System.Data.SqlClient

Public Class uploadguide
    Inherits System.Web.UI.Page

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    Protected WithEvents maxdownloads1 As System.Web.UI.WebControls.Literal
    Protected WithEvents litMaxDays As System.Web.UI.WebControls.Literal

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
        'Put user code to initialize the page here
        ' retrieve the maximum number of downloads value
        Dim objCon As New SqlConnection
        Dim objCom As New SqlCommand
        Dim objReader As SqlDataReader
        Dim maxDays, maxDL As String

        With objCon
            .ConnectionString = AppConfig.Instance.DataExchangeConnection
            .Open()
        End With

        With objCom
            .Connection = objCon
            .CommandType = CommandType.Text
            .CommandText = "SELECT * FROM DBParam"
        End With

        objReader = objCom.ExecuteReader

        While objReader.Read
            If objReader("strKey") = "ExpirationDays" Then
                maxDays = objReader("strValue")
            End If
            If objReader("strKey") = "MaxDownloads" Then
                maxDL = objReader("strValue")
            End If
        End While

        objReader.Close()
        objCom.Dispose()
        objCon.Close()

        maxdownloads1.Text = maxDL
        litMaxDays.Text = maxDays

    End Sub

End Class
