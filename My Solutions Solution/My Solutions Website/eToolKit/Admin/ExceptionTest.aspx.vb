Public Partial Class eToolKit_Admin_ExceptionTest
    Inherits ToolKitPage

    Protected Overrides ReadOnly Property LogPageExceptions() As Boolean
        Get
            Return True
        End Get
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Throw New NullReferenceException("Dude, it's nuttin")
    End Sub

End Class