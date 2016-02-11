Imports System.Text
Imports System.IO
Imports System.Data
Imports Nrc.SurveyPoint.Library

Public Class VRTDispositionSection
#Region " Fields "
    Dim mNavigator As VRTDispositionsNavigator
#End Region
#Region " Overrides "
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        MyBase.RegisterNavControl(navCtrl)

        mNavigator = TryCast(navCtrl, VRTDispositionsNavigator)

    End Sub

    Public Overrides Sub ActivateSection()
        'AddHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub

    Public Overrides Sub InactivateSection()
        'RemoveHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub
#End Region

#Region " Event handlers "
    Private Sub cmdDispOpen_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdDispOpen.Click
        Dim result As DialogResult = Me.OpenFileDialog1.ShowDialog()
        If result = DialogResult.OK Then
            Me.txtDispositionPath.Text = Me.OpenFileDialog1.FileName
        End If
    End Sub

    Private Sub cmdLogFileOpen_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdLogFileOpen.Click
        Dim result As DialogResult = Me.SaveFileDialog1.ShowDialog()
        If result = DialogResult.OK Then
            Me.txtLogFilePath.Text = Me.SaveFileDialog1.FileName
        End If
    End Sub

    Private Sub cmdImport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdImport.Click
        If GUIValidateImport() Then
            Me.txtResults.Text = "Starting to process file."
            ImportFile()
        Else
            MessageBox.Show("You have not given a valid path to either the log and/or import file.")
        End If
    End Sub
#End Region
#Region " Private Methods "
    Private Function GUIValidateImport() As Boolean
        Dim retVal As Boolean = False
        Try
            If System.IO.File.Exists(Me.txtDispositionPath.Text) Then
                Dim FolderPath = Me.txtLogFilePath.Text.Substring(0, Me.txtLogFilePath.Text.LastIndexOf("\"c))
                If System.IO.Directory.Exists(FolderPath) Then
                    retVal = True
                    Me.txtResults.Text = ""
                End If
            End If
        Catch ex As System.Exception
            'do nothing
        End Try
        Return retVal
    End Function
    Private Sub ImportFile()        
        'Load the file into the object.
        Dim myDispositions As New VRTDispositions
        Dim errorCaught As Boolean = False
        Try
            Dim TempDir As String = "C:\TempVRTDispSchema"
            If Not Directory.Exists(TempDir) Then
                Directory.CreateDirectory(TempDir)
            End If
            Dim tempString As String = Me.txtDispositionPath.Text
            Dim fileName As String = tempString.Substring(tempString.LastIndexOf("\"c) + 1)
            Dim path As String = tempString.Substring(0, tempString.LastIndexOf("\"c))
            File.Copy(Me.txtDispositionPath.Text, TempDir & "\" & fileName)
            CreateSchemaINIFile(fileName)
            Dim connStr As String = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & _
            TempDir & ";Extended Properties=""Text;HDR=1;FMT=Delimited\"""
            Dim sbOutput As New StringBuilder()
            Dim conn As New OleDb.OleDbConnection(connStr)
            Dim ds As New DataSet
            Dim da As New OleDb.OleDbDataAdapter("Select * from " & fileName, conn)
            da.Fill(ds, "TextFile")
            For Each row As Data.DataRow In ds.Tables(0).Rows
                Dim respID As Integer
                Dim phone As String = String.Empty
                Dim callCode1 As String = String.Empty
                Dim callCode2 As String = String.Empty
                Dim callCode3 As String = String.Empty
                Dim callDate1 As Nullable(Of DateTime) = Nothing
                Dim callDate2 As Nullable(Of DateTime) = Nothing
                Dim callDate3 As Nullable(Of DateTime) = Nothing
                respID = CInt(row(0))
                phone = cStrNull(row(1))
                callCode1 = cStrNull(row(3))
                callCode2 = cStrNull(row(5))
                callCode3 = cStrNull(row(7))
                callDate1 = cDateNullable(row(2))
                callDate2 = cDateNullable(row(4))
                callDate3 = cDateNullable(row(6))
                myDispositions.Add(VRTDisposition.NewVRTDisposition(respID, phone, callCode1, callCode2, callCode3, callDate1, callDate2, callDate3))
            Next
            Dim myFiles As String() = Directory.GetFiles(TempDir)
            For Each str As String In myFiles
                File.Delete(str)
            Next
            Directory.Delete(TempDir)
        Catch ex As System.Exception
            txtResults.Text = "The Following error occurred during loading of the file:" & vbCrLf
            txtResults.Text += ex.Message & vbCrLf
            txtResults.Text += "No rows were processed." & vbCrLf
            errorCaught = True
        End Try
        If Not errorCaught Then
            If myDispositions.GenericCount > 0 Then 'There are rows to process
                Dim sb As StringBuilder = myDispositions.ProcessVRTDispositionImport()
                txtResults.Text = sb.ToString & vbCrLf
                WriteLog(sb)
            Else
                txtResults.Text = "There are no rows to process." & vbCrLf
            End If
        End If
        Me.txtResults.Text += vbCrLf & "File Processing Complete."
    End Sub
    Private Function cDateNullable(ByVal obj As Object) As Nullable(Of DateTime)
        Dim retVal As Nullable(Of DateTime) = Nothing
        If Not IsDBNull(obj) Then
            If IsDate(obj) Then
                retVal = CDate(obj)
            End If
        End If
        Return retVal
    End Function
    Private Function cStrNull(ByVal obj As Object) As String
        If IsDBNull(obj) Then
            Return ""
        Else
            Return CStr(obj)
        End If
    End Function
    Private Sub WriteLog(ByVal sb As StringBuilder)
        Dim mywriter As StreamWriter = Nothing
        Try
            mywriter = New StreamWriter(Me.txtLogFilePath.Text)
            mywriter.Write(sb.ToString)
        Catch ex As System.Exception
            Globals.ReportException(ex)
        Finally
            mywriter.close()
        End Try
    End Sub
    Public Sub CreateSchemaINIFile(ByVal fileName As String)
        Dim schemaWriter As StreamWriter = Nothing
        Try
            schemaWriter = File.CreateText("C:\TempVRTDispSchema\Schema.ini")
            schemaWriter.WriteLine("[" & fileName & "]")
            schemaWriter.WriteLine("Format=CSVDelimited")
            schemaWriter.WriteLine()
            schemaWriter.WriteLine("Col1=RespondentID Text")
            schemaWriter.WriteLine("Col2=Phone Text")
            schemaWriter.WriteLine("Col3=CallDate1 Text")
            schemaWriter.WriteLine("Col4=CallCode1 Text")
            schemaWriter.WriteLine("Col5=CallDate2 Text")
            schemaWriter.WriteLine("Col6=CallCode2 Text")
            schemaWriter.WriteLine("Col7=CallDate3 Text")
            schemaWriter.WriteLine("Col8=CallCode3 Text")
        Catch ex As Exception
            Throw ex
        Finally
            schemaWriter.Close()
            schemaWriter = Nothing
        End Try

    End Sub
#End Region
End Class
