Imports SurveyPointClasses

Partial Class settemplateinfo
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
        Try
            If (Not Page.IsPostBack) Then InitPage()

        Catch ex As Exception
            clsLog.LogError(GetType(settemplateinfo), "Page_Load", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try
    End Sub

    Private Sub InitPage()
        clsWebTools.fillSurveyInstanceDDL(ddlSurveyInstanceID)
    End Sub

    Private Sub ibExecute_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibExecute.Click
        If (Page.IsValid()) Then
            Try
                clsNCRTools.setTemplateInfoForSurveyInstance(CInt(ddlSurveyInstanceID.SelectedValue), tbProjectID.Text, tbFAQSSTemplateID.Text, tbTemplateID.Text)
                DMI.WebFormTools.Msgbox(Page, "Finished!")
            Catch ex As Exception
                clsLog.LogError(GetType(settemplateinfo), "Page_Load", ex)
                DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
            End Try
        End If
    End Sub
End Class
