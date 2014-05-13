Imports System.Linq
Imports Nrc.NRCAuthLib
Imports Nrc.NRCAuthLib.OUH

' This class embeds the OUHEditor in a dialog to allow selection of OUs for a group
Public Class GroupOUHDialog
    Private WithEvents mOUHEditor As OUHEditor
    Private mGroup As Group

    Public Sub New(ByVal group As Group)
        ' This call is required by the Windows Form Designer.
        Me.InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.Caption = "OUH Editor for " & group.Name
        mOUHEditor = New OUHEditor(Function() OUHModel.GetGroupOUs(group))
        Me.OUHPanel.Controls.Add(mOUHEditor)

        mGroup = group
    End Sub

    Private Sub OK_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Ok_Button.Click
        Me.DialogResult = System.Windows.Forms.DialogResult.OK
        OUHModel.SetGroupOUs(mGroup, mOUHEditor.CheckedOrgUnitIDs)
        Me.Close()
    End Sub

    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Me.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Close()
    End Sub

    Private Sub OUHPanel_Paint(sender As Object, e As PaintEventArgs) Handles OUHPanel.Paint

    End Sub
End Class
