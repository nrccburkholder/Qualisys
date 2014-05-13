Public Class ContentControlBase
    Inherits UserControl

    Sub New()
    End Sub

    Public Overridable Function AllowUnload() As Boolean
        Return True
    End Function

    Public Overridable Sub RegisterNavControl(ByVal navControl As Control)

    End Sub
End Class

