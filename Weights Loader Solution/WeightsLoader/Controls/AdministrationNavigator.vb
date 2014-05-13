Public Class AdministrationNavigator
    Private mManageCategoriesSection As New ManageTypesControl

    Public Event SelectionChanged(ByVal control As AdministrationControlTemplate)

    Private Sub ManageCategoriesLinkLabel_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles ManageCategoriesLinkLabel.LinkClicked
        RaiseEvent SelectionChanged(mManageCategoriesSection)
    End Sub
End Class
