Imports System.Data
Imports MailMergePrep.Library

Public Class XMLViewerSection
#Region " Fields "
    Dim mNavigator As XMLViewerNavigator
    Dim dt As DataTable
#End Region
#Region " Overrides "
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        MyBase.RegisterNavControl(navCtrl)

        mNavigator = TryCast(navCtrl, XMLViewerNavigator)

    End Sub

    Public Overrides Sub ActivateSection()
        'AddHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub

    Public Overrides Sub InactivateSection()
        'RemoveHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub
#End Region
#Region " Event Handlers "
    Private Sub cmdSelectFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSelectFile.Click
        Dim result As DialogResult = Me.OpenFileDialog1.ShowDialog()
        If result = DialogResult.OK Then
            Me.txtXMLFilePath.Text = Me.OpenFileDialog1.FileName
        End If
    End Sub

    Private Sub cmdExport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdExport.Click
        ExportFile()
    End Sub

    Private Sub XMLViewerSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If System.IO.Directory.Exists(Config.DefaultTransferPath) Then
            Me.OpenFileDialog1.InitialDirectory = Config.DefaultTransferPath
        End If
    End Sub
    Private Sub cmdSaveFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSaveFile.Click
        Dim result As DialogResult = Me.SaveFileDialog1.ShowDialog()
        If result = DialogResult.OK Then
            Me.txtSaveFile.Text = Me.SaveFileDialog1.FileName
        End If
    End Sub

    Private Sub cmdGetData_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdGetData.Click
        Try
            dt = CommonMethods.DeserializeXMLDataset(Me.txtXMLFilePath.Text)
            If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                dgResults.DataSource = dt
                grpData.Visible = True
            End If
        Catch ex As Exception
            Globals.ReportException(ex)
        End Try
    End Sub
#End Region

    
    Private Sub ExportFile()
        Dim sWrite As System.IO.StreamWriter = Nothing
        Try
            Dim fi As New System.IO.FileInfo(Me.txtSaveFile.Text)
            Dim dir As String = fi.DirectoryName
            If System.IO.Directory.Exists(dir) Then
                sWrite = New System.IO.StreamWriter(Me.txtSaveFile.Text)
                sWrite.Write(CommonMethods.DataFileToCSV(dt))
                MessageBox.Show("Export to CSV was successful.", "Export", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If sWrite IsNot Nothing Then
                sWrite.Close()
            End If
        End Try
    End Sub
End Class
