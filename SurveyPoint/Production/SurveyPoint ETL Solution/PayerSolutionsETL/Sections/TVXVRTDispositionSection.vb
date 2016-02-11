Imports System.Text
Imports System.IO
Imports System.Data
Imports Nrc.SurveyPoint.Library

Public Class TVXVRTDispositionSection
#Region " Fields "
    Dim mNavigator As TVXVRTDispositionNavigator
#End Region
#Region " Overrides "
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        MyBase.RegisterNavControl(navCtrl)

        mNavigator = TryCast(navCtrl, TVXVRTDispositionNavigator)

    End Sub

    Public Overrides Sub ActivateSection()
        'AddHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub

    Public Overrides Sub InactivateSection()
        'RemoveHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub
#End Region

#Region " Event Handlers "
    Private Sub cmdDispositionFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdDispositionFile.Click
        Dim result As DialogResult = Me.OpenFileDialog1.ShowDialog()
        If result = DialogResult.OK Then
            Me.txtDispositionFile.Text = Me.OpenFileDialog1.FileName
        End If
    End Sub

    Private Sub cmdLogFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdLogFile.Click
        Dim result As DialogResult = Me.SaveFileDialog1.ShowDialog()
        If result = DialogResult.OK Then
            Me.txtLogFile.Text = Me.SaveFileDialog1.FileName
        End If
    End Sub

    Private Sub cmdImportDispositions_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdImportDispositions.Click
        Try
            If GUIValidateImport() Then
                Me.txtResults.Text = "Starting to process file."
                ImportFile()
                If txtResults.Text.Length > 0 Then
                    Dim sr As New System.IO.StreamWriter(Me.txtLogFile.Text, False)
                    sr.Write(Me.txtResults.Text)
                    sr.Close()
                End If
            Else
                MessageBox.Show("You have not given a valid path to either the log and/or import file.")
            End If
        Catch ex As System.Exception
            Globals.ReportException(ex)
        End Try
    End Sub
#End Region
#Region " Private Methods "
    Private Function GUIValidateImport() As Boolean
        Dim retVal As Boolean = False
        Try
            If System.IO.File.Exists(Me.txtDispositionFile.Text) Then
                Dim FolderPath = Me.txtLogFile.Text.Substring(0, Me.txtLogFile.Text.LastIndexOf("\"c))
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
        Dim myDispositions As New VRTDispositionTVXs
        Dim errorCaught As Boolean = False
        Try
            Dim TempDir As String = "C:\TempTuvoxVRTDispSchema"
            If Not Directory.Exists(TempDir) Then
                Directory.CreateDirectory(TempDir)
            End If
            Dim tempString As String = Me.txtDispositionFile.Text
            Dim fileName As String = tempString.Substring(tempString.LastIndexOf("\"c) + 1)
            Dim path As String = tempString.Substring(0, tempString.LastIndexOf("\"c))
            File.Copy(Me.txtDispositionFile.Text, TempDir & "\" & fileName)
            CreateSchemaINIFile(fileName)
            Dim connStr As String = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & _
            TempDir & ";Extended Properties=""Text;HDR=1;FMT=Delimited\"""
            Dim sbOutput As New StringBuilder()
            Dim conn As New OleDb.OleDbConnection(connStr)
            Dim ds As New DataSet
            Dim da As New OleDb.OleDbDataAdapter("Select * from " & fileName, conn)
            da.Fill(ds, "TextFile")

            Dim CleanedData As DataTable = CleanData(ds.Tables(0))

            For Each row As Data.DataRow In CleanedData.Rows
                Dim respID As Integer
                Dim dateTimeStamp As String = String.Empty
                Dim callOutcome As String = String.Empty
                Dim CallType As String = String.Empty
                respID = CInt(row("RespondentID"))
                dateTimeStamp = cStrNull(row("dateTimeStamp"))
                callOutcome = cStrNull(row("callOutcome"))
                CallType = cStrNull(row("CallType"))
                myDispositions.Add(VRTDispositionTVX.NewVRTDispositionTVX(respID, callOutcome, dateTimeStamp, CallType))
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
                Dim sb As StringBuilder = myDispositions.ProcessVRTDispositionTVXImport()
                txtResults.Text = sb.ToString & vbCrLf
                WriteLog(sb)
            Else
                txtResults.Text = "There are no rows to process." & vbCrLf
            End If
        End If
        Me.txtResults.Text += vbCrLf & "File Processing Complete."
    End Sub
    Private Function CleanData(ByVal tbl As DataTable) As DataTable
        tbl.DefaultView.Sort = "CallType, RespondentID, DateTimeStamp Desc"
        Dim result As DataTable = tbl.DefaultView.ToTable()
        Dim RowsToRemove As List(Of DataRow) = New List(Of DataRow)
        Dim PreviousRespondentID As String = String.Empty
        Dim PreviousDate As String = String.Empty

        For Each R As DataRow In result.Rows
            If IsDBNull(R("RespondentID")) Then 'reject all records without an ID
                RowsToRemove.Add(R)
                Continue For
            End If

            If R("CallType").ToString().ToUpper() = "INBOUND" Then 'accept all inbounds that have an ID
                PreviousRespondentID = String.Empty
                Continue For
            End If

            If PreviousRespondentID = R("RespondentID").ToString() Then
                If PreviousDate = R("datetimestamp").ToString().Replace(".", String.Empty).Substring(0, 8) Then
                    RowsToRemove.Add(R) 'accept only the outbound record with the greatest timestamp for a given day
                End If
            End If
            PreviousDate = R("datetimestamp").ToString().Replace(".", String.Empty).Substring(0, 8)
            PreviousRespondentID = R("RespondentID").ToString()
        Next
        For Each R As DataRow In RowsToRemove
            result.Rows.Remove(R)
        Next
        Return result
    End Function

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
            mywriter = New StreamWriter(Me.txtLogFile.Text)
            mywriter.Write(sb.ToString)
        Catch ex As System.Exception
            Globals.ReportException(ex)
        Finally
            mywriter.Close()
        End Try
    End Sub
    Public Sub CreateSchemaINIFile(ByVal fileName As String)
        Dim schemaWriter As StreamWriter = Nothing
        Try
            schemaWriter = File.CreateText("C:\TempTuvoxVRTDispSchema\Schema.ini")
            schemaWriter.WriteLine("[" & fileName & "]")
            schemaWriter.WriteLine("Format=CSVDelimited")
            schemaWriter.WriteLine()
            schemaWriter.WriteLine("Col1=DateTimeStamp Text")
            schemaWriter.WriteLine("Col2=SessionID Text")
            schemaWriter.WriteLine("Col3=DNIS Text")
            schemaWriter.WriteLine("Col4=ANI Text")
            schemaWriter.WriteLine("Col5=CallOutcome Text")
            schemaWriter.WriteLine("Col6=CallType Text")
            schemaWriter.WriteLine("Col7=RespondentID Text")
            schemaWriter.WriteLine("Col8=VXMLSessionID Text")
        Catch ex As Exception
            Throw ex
        Finally
            schemaWriter.Close()
            schemaWriter = Nothing
        End Try

    End Sub
#End Region
End Class
