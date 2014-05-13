Imports System
Imports System.IO

Public Class OCSTranslator

    ''' <summary>
    ''' Translate OCS's file structure with header record into a flat csv file.
    ''' </summary>
    ''' <param name="fileName">Input file</param>
    ''' <param name="outFileName">Output file</param>
    ''' <remarks></remarks>
    Public Shared Sub Translate(ByVal fileName As String, ByVal outFileName As String)

        'Make sure the input file exists
        Dim fileInfo As New FileInfo(fileName)
        If Not fileInfo.Exists Then
            Throw New InvalidFileException("Specified file not found.  File not processed!", fileName)
        End If

        'Make sure the output file path exists
        Dim lastSlash As Integer = IIf(outFileName.LastIndexOf("\".ToCharArray) <= 0, outFileName.Length, outFileName.LastIndexOf("\".ToCharArray) + 1)
        Dim dirinfo As New DirectoryInfo(outFileName.Substring(0, lastSlash))
        If Not dirinfo.Exists Then
            Throw New InvalidFileException("Output directory path not found.  File not processed!", fileName)
        End If
        If outFileName.Length = lastSlash Then
            Throw New InvalidFileException("No output file defined.  File not processed!", fileName)
        End If

        Dim sr As StreamReader = Nothing
        Dim sw As StreamWriter = Nothing

        Try
            Try
                'Check to see if you can read file
                sr = New StreamReader(fileName)

            Catch ex As Exception
                Throw New InvalidFileException("Unable to open file using Text reader.  File not processed!", fileName, ex)
            End Try


            'Get header column name row record
            Dim headerColumnNames() As String = sr.ReadLine.Split(CChar(","))
            Dim columnHeader As String = String.Empty

            If headerColumnNames.GetUpperBound(0) <= 0 Then
                Throw New InvalidFileException("File doen't contain expected comma separators.  File not processed!", fileName)
            End If

            'Get header values row record
            Dim headerValues As String = String.Empty
            Dim headerRecords() As String = sr.ReadLine.Split(CChar(","))

            'Loop through header column name array getting only those with a value.
            For x As Integer = 0 To headerColumnNames.GetUpperBound(0)
                If headerColumnNames(x).Trim <> String.Empty Then
                    columnHeader += String.Concat(headerColumnNames(x).Trim, ",")
                End If
            Next

            'Loop through header record array getting only those with a value.
            For x As Integer = 0 To headerRecords.GetUpperBound(0)
                If headerRecords(x).Trim <> String.Empty Then
                    headerValues += String.Concat(headerRecords(x).Trim, ",")
                End If
            Next

            'Get body column name row record
            Dim bodyColumnNames() As String = sr.ReadLine.Split(CChar(","))
            Dim bodycolumnHeader As String = String.Empty

            'Loop through trim off extra spaces
            For x As Integer = 0 To bodyColumnNames.GetUpperBound(0)
                If x = bodyColumnNames.GetUpperBound(0) Then
                    bodycolumnHeader += bodyColumnNames(x).Trim
                Else
                    bodycolumnHeader += String.Concat(bodyColumnNames(x).Trim, ",")
                End If
            Next

            'Create/write column output file header row
            sw = New StreamWriter(outFileName)
            sw.WriteLine(String.Concat(columnHeader, bodycolumnHeader))

            'Loop through remainder of input file writing out data rows
            Dim bodyRecord As String = sr.ReadLine
            While Not bodyRecord Is Nothing
                sw.WriteLine(String.Concat(headerValues, bodyRecord))
                bodyRecord = sr.ReadLine
            End While

        Finally
            If Not sr Is Nothing Then sr.Close()
            If Not sw Is Nothing Then
                sw.Flush()
                sw.Close()
            End If
        End Try

    End Sub

End Class
