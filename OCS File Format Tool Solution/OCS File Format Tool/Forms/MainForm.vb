Imports Nrc.Framework.BusinessLogic.Configuration
Imports System.IO

Public Class MainForm

    Private mSourceChanged As Boolean

    Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        InitializeUI()
        Location = My.Settings.MainFormLocation
        Size = My.Settings.MainFormSize
        WindowState = My.Settings.MainFormWindowState
        SourceFileTextBox.Text = My.Settings.SourceFilePath
        DestinationFileTextBox.Text = My.Settings.DestinationFilePath

    End Sub

    Private Sub InitializeUI()

        Text = My.Application.Info.Title
        EnvironmentLabel.Text = AppConfig.EnvironmentName
        VersionLabel.Text = "v" & My.Application.Info.Version.ToString
        UserNameLabel.Text = String.Format("{0} ({1})", CurrentUser.DisplayName, My.User.Name)

    End Sub

    Private Sub MainForm_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing

        'Save the window state and then set it to normal so we can get the size and location
        My.Settings.MainFormWindowState = WindowState
        WindowState = FormWindowState.Normal

        'Save the form size and location
        My.Settings.MainFormLocation = Location
        My.Settings.MainFormSize = Size

        'Save the last file path info
        If File.Exists(SourceFileTextBox.Text) Then
            Dim file As New FileInfo(SourceFileTextBox.Text)
            My.Settings.SourceFilePath = String.Concat(file.DirectoryName, "\")
        End If
        If File.Exists(DestinationFileTextBox.Text) Then
            Dim file As New FileInfo(DestinationFileTextBox.Text)
            My.Settings.DestinationFilePath = String.Concat(file.DirectoryName, "\")
        End If

    End Sub

    Private Sub ExitToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitToolStripMenuItem.Click
        'Close the application
        Close()
    End Sub

    Private Sub SourceFileButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SourceFileButton.Click

        Dim dialog As New OpenFileDialog
        Try
            With dialog
                .InitialDirectory = SourceFileTextBox.Text
                .Filter = "CSV files (*.csv)|*.csv|All files (*.*)|*.*"
                .FilterIndex = 1
                .RestoreDirectory = True
                .Multiselect = False
            End With

            If dialog.ShowDialog = Windows.Forms.DialogResult.OK Then
                SourceFileTextBox.Text = dialog.FileName
            Else
                Exit Try
            End If
            If File.Exists(DestinationFileTextBox.Text) Then
                Dim file As New FileInfo(DestinationFileTextBox.Text)
                DestinationFileTextBox.Text = String.Concat(file.DirectoryName, "\")
            End If

        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            dialog.Dispose()
        End Try

    End Sub

    Private Sub DestinationFileButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DestinationFileButton.Click

        Dim dialog As New SaveFileDialog
        Try
            With dialog
                .InitialDirectory = DestinationFileTextBox.Text
                .Filter = "CSV files (*.csv)|*.csv|All files (*.*)|*.*"
                .FilterIndex = 1
                .RestoreDirectory = True
            End With

            If dialog.ShowDialog = Windows.Forms.DialogResult.OK Then
                DestinationFileTextBox.Text = dialog.FileName
            End If

        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            dialog.Dispose()
        End Try

    End Sub

    Private Sub ConvertButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ConvertButton.Click

        Try
            OCSTranslator.Translate(SourceFileTextBox.Text, DestinationFileTextBox.Text)
            MessageBox.Show("File conversion complete", "Converting OCS File")

        Catch ex As Exception
            Globals.ReportException(ex)
        End Try

    End Sub

    Private Sub SourceFileTextBox_Leave(ByVal sender As Object, ByVal e As System.EventArgs) Handles SourceFileTextBox.Leave

        If File.Exists(DestinationFileTextBox.Text) AndAlso mSourceChanged Then
            Dim file As New FileInfo(DestinationFileTextBox.Text)
            DestinationFileTextBox.Text = String.Concat(file.DirectoryName, "\")
        End If
        mSourceChanged = False

    End Sub

    Private Sub SourceFileTextBox_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles SourceFileTextBox.TextChanged

        mSourceChanged = True

    End Sub
End Class

