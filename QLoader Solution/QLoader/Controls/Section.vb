Public Class Section
    Inherits UserControl

    Public Overridable Sub RegisterNavControl(ByVal navCtrl As Navigator)
    End Sub

    Public Overridable Sub ActivateSection()
    End Sub

    Public Overridable Sub InactivateSection()
    End Sub

    Public Overridable Function AllowInactivate() As Boolean
        Return True
    End Function

    Public Overridable ReadOnly Property ToolStripItems() As List(Of ToolStripItem)
        Get
            Return Nothing
        End Get
    End Property

End Class
