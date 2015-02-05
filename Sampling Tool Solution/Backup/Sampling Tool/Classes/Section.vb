Public Class Section
    Inherits UserControl

    Public Overridable Sub RegisterNavControl(ByVal navCtrl As Navigator)
    End Sub

    Public Overridable Function AllowUnload() As Boolean
        Return True
    End Function

End Class
