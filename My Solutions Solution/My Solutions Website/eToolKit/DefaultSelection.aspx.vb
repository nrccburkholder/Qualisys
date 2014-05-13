Public Partial Class DefaultSelection
    Inherits ToolKitPage

    Protected Overrides ReadOnly Property RequiresInitialize() As Boolean
        Get
            Return True
        End Get
    End Property

    Protected Overrides ReadOnly Property RequiresDataSelection() As Boolean
        Get
            Return True
        End Get
    End Property

    Protected Overrides Sub OnPreInit(ByVal e As System.EventArgs)
        MyBase.OnPreInit(e)
        If MemberGroupPreference.IsChooseQuestionSelected Then
            Response.Redirect("QuestionSelection.aspx")
        Else
            Response.Redirect("ThemeSelection.aspx")
        End If
    End Sub

End Class