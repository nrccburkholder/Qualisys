Public Class AdministrationSection
    Private WithEvents mNavigator As AdministrationNavigator
    Private mAllowUnload As Boolean = True

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        MyBase.RegisterNavControl(navCtrl)
        mNavigator = TryCast(navCtrl, AdministrationNavigator)
        If mNavigator Is Nothing Then
            Throw New Exception("The ConfigSection control expects a Navigator control of type ClientStudySurveyNavigator")
        End If
    End Sub

    Public Overrides Function AllowUnload() As Boolean
        Return mAllowUnload
    End Function

    Private Sub ChangeControl(ByVal adminControl As AdministrationControlTemplate)
        Me.AdminPanel.Controls.Clear()
        Me.AdminPanel.Controls.Add(adminControl)
        adminControl.Dock = DockStyle.Fill
        Me.MainPanel.Caption = adminControl.Title
    End Sub

    Private Sub mNavigator_SelectionChanged(ByVal adminControl As AdministrationControlTemplate) Handles mNavigator.SelectionChanged
        ChangeControl(adminControl)
    End Sub
End Class
