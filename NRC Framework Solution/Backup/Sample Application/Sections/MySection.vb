Public Class MySection
    Friend WithEvents mNavigator As MyNavigator

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        mNavigator = DirectCast(navCtrl, MyNavigator)

    End Sub

    Public Sub mNavigator_TreeSelected(ByVal sender As Object, ByVal e As NotificationEventArgs) Handles mNavigator.TreeSelected
        MessageBox.Show("Here")
    End Sub
End Class
