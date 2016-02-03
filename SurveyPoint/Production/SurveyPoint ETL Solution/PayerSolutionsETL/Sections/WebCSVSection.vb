Imports System.Text
Imports System.IO
Imports System.Data

Public Class WebCSVSection
#Region " Private Variables "
    Private mWebNavigator As WebCSVNavigator
    Private HIGHMARKFILE As String = "HighMark File"
    Private COVMEDFILE As String = "Coventry Medicaid File"
    Private SELECTFILE As String = "Select a File Type"
#End Region
#Region " Overrides "
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        MyBase.RegisterNavControl(navCtrl)

        mWebNavigator = TryCast(navCtrl, WebCSVNavigator)

    End Sub

    Public Overrides Sub ActivateSection()
        'AddHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub

    Public Overrides Sub InactivateSection()
        'RemoveHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub
#End Region
#Region " Event Handlers "
    Private Sub cmdSource_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSource.Click
        Dim result As DialogResult = Me.OpenFileDialog1.ShowDialog
        If result = DialogResult.OK Then
            Me.txtSource.Text = Me.OpenFileDialog1.FileName
        End If
    End Sub

    Private Sub cmdDestination_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdDestination.Click
        Dim result As DialogResult = Me.SaveFileDialog1.ShowDialog
        If result = DialogResult.OK Then
            Me.txtDestination.Text = Me.SaveFileDialog1.FileName
        End If
    End Sub

    Private Sub cmdConvertFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdConvertFile.Click
        If ValidateScreen() Then
            If Me.cboFileType.SelectedItem = Me.COVMEDFILE Then
                ConvertCovFile()
            ElseIf Me.cboFileType.SelectedItem = Me.HIGHMARKFILE Then
                ConvertHighmarkFile()
            Else
                MessageBox.Show("Invalid File Type")
            End If
        Else
            MessageBox.Show("One or more of the options you have selected is invalid.")
        End If
    End Sub

    Private Sub WebCSVSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.cboFileType.Items.Add(SELECTFILE)
        Me.cboFileType.Items.Add(HIGHMARKFILE)
        Me.cboFileType.Items.Add(COVMEDFILE)
        Me.cboFileType.SelectedItem = SELECTFILE
        Dim sb As New StringBuilder
        sb.AppendLine("This section takes a Web export file in CSV format and converts it to a fixed length file.")
        Me.txtDescription.Text = sb.ToString
    End Sub
#End Region
#Region " Private Methods "
    Private Function ValidateScreen() As Boolean
        If Me.cboFileType.SelectedItem = Me.SELECTFILE Then
            Return False
        End If
        If Me.txtDestination.Text.Length = 0 OrElse Me.txtSource.Text.Length = 0 Then
            Return False
        End If
        If Not System.IO.File.Exists(Me.txtSource.Text) Then
            Return False
        End If
        Dim path As String = Me.txtDestination.Text.Substring(0, Me.txtDestination.Text.LastIndexOf("\"c))
        If Not System.IO.Directory.Exists(path) Then
            Return False
        End If
        If Me.txtDestination.Text = Me.txtSource.Text Then
            Return False
        End If
        Return True
    End Function
    Private Sub ConvertHighmarkFile()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtDestination.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()
            'For Each col As DataColumn In readTable.Columns
            '    Debug.Print(col.ColumnName)
            'Next
            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                newLine.Append(" ")
                Dim tempDate As Date = Now
                newLine.Append(tempDate.ToString("yyyyMMdd"))
                newLine.Append(" ")
                newLine.Append(PadString(row(13), 8, Direction.Left, " "))    'Property_FAQSS_TEMPLATE_ID
                newLine.Append(PadString(row(11), 5, Direction.Right, "0"))    'TemplateID
                newLine.Append(PadString(row(10), 8, Direction.Right, "0"))    'RESPONDENTID
                newLine.Append(PadString("", 3, Direction.Left, " "))
                Dim outOfOrderLine As String = String.Empty
                For i As Integer = 15 To 109
                    Dim l As Integer = 1
                    If i = 17 Then
                        l = 2
                    ElseIf i = 18 Then
                        l = 2
                    ElseIf i = 89 Then
                        l = 2
                    ElseIf i = 90 Then
                        l = 3
                    ElseIf i = 96 Then
                        l = 32
                    ElseIf i = 101 Then
                        outOfOrderLine = PadString(row(i), l, Direction.Left, " ")
                    ElseIf i = 102 Or i = 103 Then
                        l = 32
                    ElseIf i = 109 Then
                        l = 30
                    End If
                    If Not i = 101 Then
                        If i = 89 Then
                            newLine.Append(PadString(row(i), l, Direction.Left, " ", True))
                        Else
                            newLine.Append(PadString(row(i), l, Direction.Left, " "))
                        End If
                        If i = 102 Then
                            newLine.Append(outOfOrderLine)
                        End If
                    End If
                Next
                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub
    Private Sub ConvertCovFile()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtDestination.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()
            'For Each col As DataColumn In readTable.Columns
            '    Debug.Print(col.ColumnName)
            'Next
            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                newLine.Append(" ")
                Dim tempDate As Date = Now
                newLine.Append(tempDate.ToString("yyyyMMdd"))
                newLine.Append(" ")
                newLine.Append(PadString(row(13), 8, Direction.Left, " "))    'Property_FAQSS_TEMPLATE_ID
                newLine.Append(PadString(row(11), 5, Direction.Right, "0"))    'TemplateID
                newLine.Append(PadString(row(6), 8, Direction.Left, " "))    'RESPONDENTID
                newLine.Append(PadString("", 3, Direction.Left, " "))
                newLine.Append(PadString(row(18), 1, Direction.Left, " "))
                newLine.Append(PadString(row(19), 3, Direction.Left, " "))
                newLine.Append(PadString(row(20), 1, Direction.Left, " "))
                newLine.Append(PadString(row(21), 2, Direction.Left, " "))
                For i As Integer = 22 To 121
                    Dim l As Integer = 1
                    If i = 35 Then
                        l = 31
                    ElseIf i = 36 Then
                        l = 10
                    ElseIf i = 109 Then
                        l = 2
                    ElseIf i = 112 Then
                        l = 2
                    ElseIf i = 120 Then
                        l = 32
                    ElseIf i = 121 Then
                        l = 10
                    End If
                    newLine.Append(PadString(row(i), l, Direction.Left, " "))
                Next
                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub
    Private Function PadString(ByVal value As Object, ByVal length As Integer, ByVal padDir As Direction, ByVal fillChar As String, Optional ByVal truncateNonNumeric As Boolean = False) As String
        Dim retVal As String = "'"
        If IsDBNull(value) Then
            retVal = ""
        Else
            retVal = Trim(CStr(value))
        End If
        If truncateNonNumeric Then
            Dim newVal As String = String.Empty
            For Each c As Char In retVal.ToCharArray
                If IsNumeric(c) Then
                    newVal += c
                Else
                    Exit For
                End If
            Next
            retVal = newVal
        End If
        If retVal.Length > length Then
            Return retVal.Substring(0, length)
        End If
        If retVal.Length < length Then
            Dim tempString As String = ""
            For i As Integer = 1 To (length - retVal.Length)
                tempString += fillChar
            Next
            If padDir = Direction.Left Then
                Return (retVal & tempString)
            Else
                Return (tempString & retVal)
            End If

        Else
            Return retVal
        End If
    End Function
    Private Function GetImportTable() As System.Data.DataTable
        Dim path As String = Me.txtSource.Text.Substring(0, Me.txtSource.Text.LastIndexOf("\"c))
        Dim headerVal As String
        Dim fileName As String = Me.txtSource.Text.Substring(Me.txtSource.Text.LastIndexOf("\"c) + 1)
        Dim ds As New DataSet
        If Me.chkHasHeader.Checked Then
            headerVal = "Yes"
        Else
            headerVal = "No"
        End If
        Dim connStr As String = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & _
            path & ";Extended Properties=""Text;HDR=" & headerVal & ";FMT=Delimited"""
        Dim conn As New OleDb.OleDbConnection(connStr)
        Dim da As New OleDb.OleDbDataAdapter("Select * from " & "[" & fileName & "]", conn)
        da.Fill(ds, "TextFile")
        Return ds.Tables(0)
    End Function
#End Region
End Class
