Public Class TestSection
    Friend WithEvents mNavigator As TestNavigator
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        mNavigator = DirectCast(navCtrl, TestNavigator)
    End Sub

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        Try           
            Throw New System.Exception("This is a test.")
        Catch ex As Exception
            Globals.ReportException(ex)
        End Try
    End Sub
End Class
