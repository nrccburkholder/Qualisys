Imports Nrc.DataMart.Library
Imports System.Collections.ObjectModel
Imports System.String

''' <summary>
''' Dialog Form used to alert user of terminal conditions when attempting to create export file.
''' General user has option to view terminal condition report or close (escape) file export transaction.
''' Administrative user has additional option to override terminal conditions and create an export file.
''' </summary>
Public Class ExportErrorDialog
    Dim mTpsPath As String
#Region " Constructor "
    Sub New(ByVal TpsPath As String)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        'Set Private file path to incoming parameter
        mTpsPath = TpsPath

    End Sub
#End Region

    Private Sub OK_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OK_Button.Click
        'Close the Form
        Me.DialogResult = System.Windows.Forms.DialogResult.OK
        Me.Close()

    End Sub

    Private Sub CreateFile_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CreateFile_Button.Click
        'Close the Form
        Me.DialogResult = System.Windows.Forms.DialogResult.Yes
        Me.Close()
    End Sub

    Private Sub ExportErrorDialog_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Make Create-File button visible for administrator users
        FileNameLabel.Text = System.IO.Path.GetFileNameWithoutExtension(mTpsPath)
        FileNameLabel.Text = FileNameLabel.Text.Replace(".tps", "")
        If CurrentUser.IsTPSOverride Then
            CreateFile_Button.Visible = True
        End If
    End Sub

    Private Sub LinkLabel1_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs)
        Call Shell("explorer " & mTpsPath, AppWinStyle.MaximizedFocus)
    End Sub

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        Call Shell("explorer " & mTpsPath, AppWinStyle.MaximizedFocus)
        If Not CurrentUser.IsTPSOverride Then Me.Close()
    End Sub
End Class
