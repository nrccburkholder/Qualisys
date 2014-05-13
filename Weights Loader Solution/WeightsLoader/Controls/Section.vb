Public Class Section
    Inherits UserControl


    Public Overridable Sub RegisterNavControl(ByVal navCtrl As Navigator)
    End Sub

    Public Overridable Function AllowUnload() As Boolean
        Return True
    End Function

    Private Sub InitializeComponent()
        Me.SuspendLayout()
        '
        'Section
        '
        Me.AutoScroll = True
        Me.Name = "Section"
        Me.ResumeLayout(False)

    End Sub
End Class
