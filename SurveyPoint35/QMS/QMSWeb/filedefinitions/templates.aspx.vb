Imports SurveyPointClasses
Imports SurveyPointDAL

Partial Class templates
    Inherits System.Web.UI.Page

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    Protected WithEvents uctTemplates As ucTemplates

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
            If (Not Page.IsPostBack) Then initPage()

        Catch ex As Exception
            clsLog.LogError(GetType(templates), "Page_Load", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try
    End Sub

    Private Sub initPage()
        fillDDL()
        uctTemplates.fillGrid()
    End Sub

    Private Sub fillDDL()
        clsWebTools.fillSurveyDDL(ddlSearchSurveyID, "NONE")
        fillClientDDL(0)
        fillScriptDDL(0)
    End Sub


    Private Sub ddlSearchSurveyID_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ddlSearchSurveyID.SelectedIndexChanged
        Try
            If (ddlSearchSurveyID.SelectedIndex > 0) Then
                Dim iSurveyID = CInt(ddlSearchSurveyID.SelectedValue)
                fillClientDDL(iSurveyID)
                fillScriptDDL(iSurveyID)
            Else
                fillClientDDL(0)
                fillScriptDDL(0)
            End If

        Catch ex As Exception
            clsLog.LogError(GetType(templates), "ddlSearchSurveyID_SelectedIndexChanged", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try
    End Sub

    Public Sub fillClientDDL(ByVal iSurveyID As Integer)
        If (iSurveyID > 0) Then
            ddlSearchClientID.Items.Clear()
            clsWebTools.fillClientDDLBySurvey(ddlSearchClientID, iSurveyID, "")
        Else
            ddlSearchClientID.Items.Add("NONE")
        End If
    End Sub

    Public Sub fillScriptDDL(ByVal iSurveyID As Integer)
        If (iSurveyID > 0) Then
            ddlSearchScriptID.Items.Clear()
            clsWebTools.fillScriptDDLBySurvey(ddlSearchScriptID, iSurveyID, "")
        Else
            ddlSearchScriptID.Items.Add("NONE")
        End If

    End Sub


    Private Sub btnSearch_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSearch.Click
        Try
            If (Page.IsValid) Then
                If (ddlSearchSurveyID.SelectedIndex > 0) Then
                    uctTemplates.SurveyID = CInt(ddlSearchSurveyID.SelectedValue)
                Else
                    uctTemplates.SurveyID = uctTemplates.NOT_SET
                End If
                If (ddlSearchClientID.SelectedIndex > 0) Then
                    uctTemplates.SurveyClientID = CInt(ddlSearchClientID.SelectedValue)
                Else
                    uctTemplates.SurveyClientID = uctTemplates.NOT_SET
                End If
                If (ddlSearchScriptID.SelectedIndex > 0) Then
                    uctTemplates.ScriptID = CInt(ddlSearchScriptID.SelectedValue)
                Else
                    uctTemplates.ScriptID = uctTemplates.NOT_SET
                End If
                uctTemplates.Search()
            End If

        Catch ex As Exception
            clsLog.LogError(GetType(templates), "btnSearch_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try

    End Sub
End Class
