Imports System.Linq
Imports Nrc.NRCAuthLib
Imports Nrc.NRCAuthLib.OUH

' This class embeds the OUHEditor in a dialog to allow selection of OUs for a member
Public Class MemberOUHDialog
    Private WithEvents mOUHEditor As OUHEditor
    Private mMember As Member

    Public Sub New(ByVal mbr As Member)
        ' This call is required by the Windows Form Designer.
        Me.InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.Caption = "OUH Editor for " & mbr.DisplayLabel
        mOUHEditor = New OUHEditor(Function() OUHModel.GetMemberOUs(mbr))

        Me.OUHPanel.Controls.Add(mOUHEditor)

        mMember = mbr
    End Sub

    Private Sub OK_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Ok_Button.Click
        Me.DialogResult = System.Windows.Forms.DialogResult.OK
        OUHModel.SetMemberOUs(mMember, mOUHEditor.CheckedOrgUnitIDs)
        Me.Close()
    End Sub

    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Me.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Close()
    End Sub
End Class
