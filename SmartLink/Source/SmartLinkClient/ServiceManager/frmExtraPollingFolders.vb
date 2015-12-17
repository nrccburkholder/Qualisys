Public Class frmExtraPollingFolders

    Private Sub frmExtraPollingFolders_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If lstExtraPollingFolders.Items.Count > 0 Then
            lstExtraPollingFolders.SelectedIndex = 0
        End If
        lstExtraPollingFolders_SelectedIndexChanged(sender, e)
        lstExtraPollingFolders.Focus()
    End Sub

    Private Function SelectDirectory(Optional ByVal CurrentPath As String = "") As String
        Dim sMsg As String
        Dim bValidFolder As Boolean

        'Set default path to current address if there is a valid path
        SelectDirectory = String.Empty
        If System.IO.Directory.Exists(CurrentPath) Then
            fbdFolderBrowserDialog.SelectedPath = CurrentPath
        End If

        'Loops until the user selects a valid path
        bValidFolder = False
        Do While Not bValidFolder
            If fbdFolderBrowserDialog.ShowDialog() <> Windows.Forms.DialogResult.OK Then
                Exit Do
            End If

            If fbdFolderBrowserDialog.SelectedPath.Length = 3 Then
                'Makes sure the user does not chose the root of any of the Drives
                sMsg = "Selected folder can not be " & fbdFolderBrowserDialog.SelectedPath _
                    & vbCrLf & vbCrLf & "Please select a subfolder in the drive"
                MsgBox(sMsg, MsgBoxStyle.Information, "Invalid Path")


            ElseIf (fbdFolderBrowserDialog.SelectedPath = System.Environment.GetFolderPath(System.Environment.SpecialFolder.ProgramFiles) _
                Or fbdFolderBrowserDialog.SelectedPath = System.Environment.GetFolderPath(System.Environment.SpecialFolder.System) _
                Or fbdFolderBrowserDialog.SelectedPath.ToUpper Like "*WINDOWS*" _
                Or fbdFolderBrowserDialog.SelectedPath.ToUpper Like "*WINNT*") _
                Or fbdFolderBrowserDialog.SelectedPath Like System.Environment.SystemDirectory & "*" Then

                'Makes sure the user does not chose any of the system folders

                sMsg = "Selected folder can not be " & fbdFolderBrowserDialog.SelectedPath _
                    & vbCrLf & vbCrLf & "Please select a folder that is not restricted by the Operating System"
                MsgBox(sMsg, MsgBoxStyle.Information, "Invalid Path")

            Else
                bValidFolder = True
            End If

        Loop

        If bValidFolder Then
            SelectDirectory = fbdFolderBrowserDialog.SelectedPath
        End If

    End Function

    Private Sub cmdAdd_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdAdd.Click
        Dim sNewPollingFolder As String

        sNewPollingFolder = SelectDirectory()

        If sNewPollingFolder <> String.Empty Then
            If lstExtraPollingFolders.Items.Count > 0 Then
                Dim iCounter As Integer
                For iCounter = 0 To lstExtraPollingFolders.Items.Count - 1
                    If sNewPollingFolder = lstExtraPollingFolders.Items.Item(iCounter) Then
                        MessageBox.Show("The polling folder you have selected is already part of the list", "Polling folder already exists", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        Exit Sub
                    End If
                Next
            End If
            lstExtraPollingFolders.Items.Add(sNewPollingFolder)
        End If

    End Sub

    Private Sub cmdEdit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdEdit.Click
        Dim sPollingfolder As String

        sPollingfolder = String.Empty

        If lstExtraPollingFolders.SelectedIndex >= 0 Then
            sPollingfolder = SelectDirectory(lstExtraPollingFolders.SelectedItem.ToString)
            If lstExtraPollingFolders.Items.Count > 0 Then
                Dim iCounter As Integer
                For iCounter = 0 To lstExtraPollingFolders.Items.Count - 1
                    If sPollingfolder = lstExtraPollingFolders.Items.Item(iCounter) And lstExtraPollingFolders.SelectedIndex <> iCounter Then
                        MessageBox.Show("The polling folder you have selected is already part of the list", "Polling folder already exists", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        Exit Sub
                    End If
                Next
            End If
        End If

        If sPollingfolder <> String.Empty Then
            lstExtraPollingFolders.Items.Item(lstExtraPollingFolders.SelectedIndex) = sPollingfolder
        End If
    End Sub

    Private Sub cmdRemove_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdRemove.Click
        Dim iPrevious As Integer = lstExtraPollingFolders.SelectedIndex
        If lstExtraPollingFolders.SelectedIndex >= 0 Then
            lstExtraPollingFolders.Items.RemoveAt(lstExtraPollingFolders.SelectedIndex)
            If lstExtraPollingFolders.Items.Count > 0 Then
                If iPrevious >= lstExtraPollingFolders.Items.Count Then
                    lstExtraPollingFolders.SelectedIndex = lstExtraPollingFolders.Items.Count - 1
                Else
                    lstExtraPollingFolders.SelectedIndex = iPrevious
                End If
            End If
        End If
    End Sub

    Public Property ExtraPollingFolders() As String()
        Get
            Dim sExtraFolders(0) As String

            Array.Resize(sExtraFolders, lstExtraPollingFolders.Items.Count)

            Dim iCounter As Integer
            For iCounter = 0 To lstExtraPollingFolders.Items.Count - 1
                sExtraFolders(iCounter) = lstExtraPollingFolders.Items.Item(iCounter)
            Next
            ExtraPollingFolders = sExtraFolders
        End Get
        Set(ByVal value() As String)
            Dim iCounter As Integer
            lstExtraPollingFolders.Items.Clear()
            For iCounter = 0 To value.Length - 1
                lstExtraPollingFolders.Items.Add(value(iCounter))
            Next
        End Set
    End Property

    Private Sub cmdOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdOK.Click
        Me.Hide()
    End Sub

    Private Sub lstExtraPollingFolders_KeyDown(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles lstExtraPollingFolders.KeyDown
        If e.KeyCode = 46 Then
            cmdRemove_Click(sender, e)
        End If
    End Sub

    Private Sub lstExtraPollingFolders_MouseDoubleClick(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles lstExtraPollingFolders.MouseDoubleClick
        If cmdEdit.Enabled Then
            cmdEdit_Click(sender, e)
        End If
    End Sub

    Private Sub lstExtraPollingFolders_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lstExtraPollingFolders.SelectedIndexChanged
        If lstExtraPollingFolders.SelectedIndex >= 0 Then
            cmdEdit.Enabled = True
            cmdRemove.Enabled = True
        Else
            cmdEdit.Enabled = False
            cmdRemove.Enabled = False
        End If
    End Sub
End Class