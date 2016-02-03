Imports System
Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Drawing
Imports System.Data
Imports System.Text
Imports System.Windows.Forms
Imports System.IO
Imports System.Data.OleDb

Partial Public Class PivotFileSection
    Private Pivot As PivotFiles
    Public Sub New()
        InitializeComponent()
    End Sub
    Private Sub PivotFileSection_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Pivot = New PivotFiles()
        SourceDelimiter.Text = Pivot.SourceDelimiter
        TargetDelimiter.Text = Pivot.TargetDelimiter
        TargetHeader.Checked = Pivot.OutputHeader
        cbQuotes.Checked = Pivot.OutputQuotes
    End Sub
    Private Sub SourceBrowse_Click(ByVal sender As Object, ByVal e As EventArgs) Handles SourceBrowse.Click
        Dim dlg As New OpenFileDialog()
        dlg.Filter = "Delimited File (csv, txt)|*.csv;*.txt"
        dlg.Multiselect = False
        dlg.Title = "Select file to pivot"
        If dlg.ShowDialog() <> DialogResult.OK Then
            Exit Sub
        End If
        SourcePath.Text = dlg.FileName
    End Sub
    Private Sub LoadSource_Click(ByVal sender As Object, ByVal e As EventArgs) Handles LoadSource.Click
        Pivot.SourceDelimiter = SourceDelimiter.Text
        Pivot.LoadSourceFile(SourcePath.Text)
        FillColumnGrid()
        TargetGB.Enabled = True
    End Sub
    Private Sub FillColumnGrid()
        ColumnGrid.AutoGenerateColumns = False
        Dim bs As New BindingSource()
        bs.DataSource = Pivot.Columns
        ColumnGrid.DataSource = bs
    End Sub
    Private Sub Convert_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Convert.Click
        If Pivot.Columns Is Nothing Then
            MessageBox.Show("Please load your file and select the columns to pivot on.")
        End If
        Pivot.TargetDelimiter = TargetDelimiter.Text
        Pivot.OutputHeader = TargetHeader.Checked
        Dim dlg As New SaveFileDialog()
        dlg.Filter = "Delimited File (.csv)|*.csv"
        If dlg.ShowDialog() <> DialogResult.OK Then
            Exit Sub
        End If

        Cursor.Current = Cursors.WaitCursor
        Pivot.ConvertFile(dlg.FileName)
        Cursor.Current = Cursors.[Default]
        ColumnGrid.DataSource = Nothing
        SourcePath.Text = String.Empty
        TargetGB.Enabled = False
        System.Media.SystemSounds.Beep.Play()
        System.Media.SystemSounds.Beep.Play()
    End Sub

    Private Sub cbQuotes_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cbQuotes.CheckedChanged
        Pivot.OutputQuotes = cbQuotes.Checked
    End Sub

End Class


Public Class PivotFiles 'hack: functionality doesn't belong in user control.
    Private SourcePath As String
    Private _Columns As DataTable
    Public Property Columns() As DataTable
        Get
            Return _Columns
        End Get
        Set(ByVal value As DataTable)
            _Columns = value
        End Set
    End Property
    Public SourceDelimiter As String = ","
    Public SourceHeader As Boolean = True
    Public TargetDelimiter As String = ","
    Public OutputHeader As Boolean = True
    Public OutputQuotes As Boolean = True
    Public Sub LoadSourceFile(ByVal SourceFilePath As String)
        If (Not File.Exists(SourceFilePath)) Then
            Exit Sub
        End If
        SourcePath = SourceFilePath
        _Columns = New DataTable()
        _Columns.Columns.Add("ColumnName", GetType(String))
        _Columns.Columns.Add("IsPivot", GetType(Boolean))
        Dim Header As String = String.Empty
        Using sr As New StreamReader(SourceFilePath)
            Header = sr.ReadLine()
        End Using
        Header = Header.Replace("""", String.Empty)
        Dim HeaderColumns As String() = Header.Split(New String() {SourceDelimiter}, StringSplitOptions.None)
        For Each s As String In HeaderColumns
            _Columns.Rows.Add(New Object() {s, s.Contains("_")})
        Next
    End Sub
    Public Sub ConvertFile(ByVal TargetFilePath As String)
        Dim PivotColumns As New List(Of String)()
        Dim StaticColumns As New List(Of String)()
        For Each r As DataRow In _Columns.Rows
            If Convert.ToBoolean(r("IsPivot")) Then
                PivotColumns.Add(r("ColumnName").ToString())
            Else
                StaticColumns.Add(r("ColumnName").ToString())
            End If
        Next

        Using FinalProduct As New DataTable()
            For Each s As String In StaticColumns
                FinalProduct.Columns.Add(s)
            Next
            FinalProduct.Columns.Add("Key")
            FinalProduct.Columns.Add("Value")

            Dim CellValueFormat As String
            If (OutputQuotes) Then
                CellValueFormat = "{0}{1}{0}"
            Else
                CellValueFormat = "{1}"
            End If

            If OutputHeader Then
                Dim HeaderCells As Object() = New Object(StaticColumns.Count + 1) {}
                For i As Integer = 0 To StaticColumns.Count - 1
                    HeaderCells(i) = String.Format(CellValueFormat, """", StaticColumns(i))
                Next
                HeaderCells(StaticColumns.Count) = String.Format(CellValueFormat, """", "Key")
                HeaderCells(StaticColumns.Count + 1) = String.Format(CellValueFormat, """", "Value")
                FinalProduct.Rows.Add(HeaderCells)
            End If

            Using RawSource As DataTable = LoadCSV(SourcePath)
                For j As Integer = 1 To RawSource.Rows.Count - 1 'skip header row
                    For Each DynamicRow As String In PivotColumns
                        Dim cells As Object() = New Object(StaticColumns.Count + 1) {}
                        For i As Integer = 0 To StaticColumns.Count - 1
                            cells(i) = String.Format(CellValueFormat, """", RawSource.Rows(j)(StaticColumns(i)))
                        Next
                        cells(StaticColumns.Count) = String.Format(CellValueFormat, """", DynamicRow)
                        cells(StaticColumns.Count + 1) = String.Format(CellValueFormat, """", RawSource.Rows(j)(DynamicRow))
                        FinalProduct.Rows.Add(cells)
                    Next
                Next
                WriteCSV(FinalProduct, TargetFilePath)
            End Using
        End Using
        SourcePath = String.Empty
    End Sub
    Private Function LoadCSV(ByVal Path As String) As DataTable
        Dim result As DataTable = New DataTable()
        Using sr As New StreamReader(Path)
            For Each s As String In sr.ReadLine().Split(SourceDelimiter)
                result.Columns.Add(s)
            Next
            Dim ColumnCount As Integer = result.Columns.Count

            Dim ln As String = sr.ReadLine()
            Dim line As String() = Nothing
            If Not ln Is Nothing Then
                line = ln.Split(SourceDelimiter)
            End If
            While Not (line Is Nothing)
                Dim cells As Object() = New Object(ColumnCount - 1) {}
                For i As Integer = 0 To ColumnCount - 1
                    cells(i) = line(i)
                Next
                result.Rows.Add(cells)
                line = Nothing
                ln = sr.ReadLine()
                If Not ln Is Nothing Then
                    line = ln.Split(SourceDelimiter)
                End If
            End While
        End Using
        Return result
    End Function
    Private Sub WriteCSV(ByVal Data As DataTable, ByVal TargetFilePath As String)
        Using sw As New StreamWriter(TargetFilePath, False)
            For Each r As DataRow In Data.Rows
                For Each c As DataColumn In Data.Columns
                    sw.Write(r(c).ToString())
                    If Data.Columns.IndexOf(c) <> Data.Columns.Count - 1 Then
                        sw.Write(TargetDelimiter)
                    End If
                Next
                sw.Write(Environment.NewLine)
            Next
            sw.Close()
        End Using
    End Sub
End Class
