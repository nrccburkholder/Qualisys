Imports Nrc.DataMart.MySolutions.Library

Partial Public Class eToolKit_Preferences
    Inherits ToolKitPage

    Protected Overrides ReadOnly Property RequiresInitialize() As Boolean
        Get
            Return True
        End Get
    End Property


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            'Load the preferences.
            LoadCompDatasets()
            LoadAnalysisVar()
            LoadContentEmailNotifications()
        End If
    End Sub

    Private Sub LoadCompDatasets()
        With rbtCompDatasets
            .DataSource = Me.ToolKitServer.CompDatasets
            .DataMember = "CompDatasets"
            .DataTextField = "strCompDataset_lbl"
            .DataValueField = "CompDataset_id"
            .DataBind()
        End With

        rbtCompDatasets.SelectedValue = MemberGroupPreference.CompDatasetId.ToString()
    End Sub

    Private Sub LoadAnalysisVar()
        Me.rbtAnalysis.SelectedValue = MemberGroupPreference.AnalysisId.ToString("d")
    End Sub

    Private Sub LoadContentEmailNotifications()
        Me.rblCENot.DataSource = NotifyMethod.GetAll
        Me.rblCENot.DataBind()
        Me.rblCENot.SelectedValue = Me.MemberPreference.ContentNotifyMethod.ToString("d")
    End Sub

    Private Sub SavePrefs()
        'Save the users selection to the Toolkit server
        MemberGroupPreference.CompDatasetId = CInt(rbtCompDatasets.SelectedItem.Value)
        MemberGroupPreference.AnalysisId = CType(CInt(Me.rbtAnalysis.SelectedValue), Legacy.ToolkitServer.AnalysisVariable)

        Me.MemberPreference.ContentNotifyMethod = CType(Me.rblCENot.SelectedValue, EmailNotifyMethod)
        Me.SavePreferences()


        'Redirect the user back to the starting page.
        If Request.QueryString("ReturnPath") Is Nothing Then
            Response.Redirect("~/eToolKit/Default.aspx")
        Else
            Response.Redirect(Request.QueryString("ReturnPath"))
        End If
    End Sub

    Private Sub SaveButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles SaveButton.Click
        Me.SavePrefs()
    End Sub

End Class