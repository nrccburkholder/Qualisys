Imports System.Data.Odbc
Imports System.IO
Imports System.Collections.ObjectModel
Imports Nrc.QualiSys.Library

Friend Class QueuedVendorFileProvider
    Inherits QualiSys.Scanning.Library.QueuedVendorFileProvider

#Region " Private Members "

    Private mFixedColumns As Collection(Of FixedColumn)

#End Region

#Region " Public Methods "

    Public Overrides Function GetDataTable(ByVal filename As String) As DataTable

        Dim isCanada As Boolean = QualisysParams.CountryCode = CountryCode.Canada

        'Get the information on the file to be loaded
        Dim fileInfo As New FileInfo(filename)

        'Make sure the file exists
        If Not fileInfo.Exists Then
            Throw New InvalidFileException("Specified file not found.  File not processed!", filename)
        End If

        'Some formats require a preliminary schema.ini file in order to open them to determine the full schema
        CreateSchemaFile(fileInfo, Nothing, True)

        'Build the connection string
        Dim connString As String = String.Format("Driver={{Microsoft Text Driver (*.txt; *.csv)}};DBQ={0};", fileInfo.DirectoryName)

        'Open the connection
        Dim conn As OdbcConnection
        Try
            conn = New OdbcConnection(connString)
            conn.Open()

        Catch ex As Exception
            Throw New InvalidFileException("Unable to open file using Text ODBC driver.  File not processed!", filename, ex)

        End Try

        'Create the SCHEMA.INI file
        CreateSchemaFile(fileInfo, conn, False)

        'Create the data table to be populated
        Dim dataTbl As New DataTable
        With dataTbl.Columns
            .Add("HCAHPSSamp", GetType(Integer))
            .Add("Litho", GetType(String))
            .Add("Survey_ID", GetType(Integer))
            .Add("SampleSet_ID", GetType(Integer))
            .Add("Phone", GetType(String))
            .Add("AltPhone", GetType(String))
            .Add("FName", GetType(String))
            .Add("LName", GetType(String))
            .Add("Addr", GetType(String))
            .Add("Addr2", GetType(String))
            .Add("City", GetType(String))
            If isCanada Then
                .Add("Province", GetType(String))
                .Add("PostalCode", GetType(String))
            Else
                .Add("St", GetType(String))
                .Add("Zip5", GetType(String))
            End If        
            .Add("PhServDate", GetType(Date))
            .Add("LangID", GetType(Integer))
            .Add("Telematch", GetType(String))
            .Add("PhFacName", GetType(String))
            .Add("PhServInd1", GetType(String))
            .Add("PhServInd2", GetType(String))
            .Add("PhServInd3", GetType(String))
            .Add("PhServInd4", GetType(String))
            .Add("PhServInd5", GetType(String))
            .Add("PhServInd6", GetType(String))
            .Add("PhServInd7", GetType(String))
            .Add("PhServInd8", GetType(String))
            .Add("PhServInd9", GetType(String))
            .Add("PhServInd10", GetType(String))
            .Add("PhServInd11", GetType(String))
            .Add("PhServInd12", GetType(String))
            .Add("AgeRange", GetType(String))
        End With

        'Populate the dataset
        Dim dataAdapter As OdbcDataAdapter = New OdbcDataAdapter(String.Format("SELECT * FROM [{0}]", fileInfo.Name), conn)
        dataAdapter.Fill(dataTbl)

        Return dataTbl

    End Function

#End Region

#Region " Private Methods "

    Private Sub CreateSchemaFile(ByVal fileInfo As FileInfo, ByVal conn As OdbcConnection, ByVal headerOnly As Boolean)

        Dim columnCount As Integer = 0
        Dim formatLine As String = String.Empty
        Dim column As FixedColumn = Nothing
        Dim schema As DataTable = Nothing

        If Not headerOnly Then
            'Get the schema table
            Try
                Using command As OdbcCommand = New OdbcCommand(String.Format("SELECT TOP 1 * FROM [{0}]", fileInfo.Name), conn)
                    Dim dataRdr As OdbcDataReader = command.ExecuteReader
                    schema = dataRdr.GetSchemaTable
                    dataRdr.Close()
                End Using

            Catch ex As Exception
                Throw New InvalidFileException("Unable to read file using Text ODBC driver.  File not processed!", fileInfo.FullName, ex)

            End Try

            'Check to see if all of the fixed columns are present
            Dim missingColumns As String = String.Empty
            If Not DoAllFixedColumnsExist(schema, missingColumns) Then
                Throw New InvalidFileException(String.Format("Missing fixed columns found ({0}).  File not processed!", missingColumns), fileInfo.FullName)
            End If
        End If

        'Open the schema file
        Dim schemaFile As TextWriter
        Try
            schemaFile = File.CreateText(Path.Combine(fileInfo.DirectoryName, "schema.ini"))

        Catch ex As Exception
            Throw New InvalidFileException("Unable to create schema.ini file.  File not processed!", fileInfo.FullName, ex)

        End Try

        'Write the schema file
        Try
            'Write the header information
            '#65001	is code pages Identifier for utf-8	Unicode (UTF-8)
            With schemaFile
                .WriteLine("[{0}]", fileInfo.Name)
                .WriteLine("ColNameHeader=True")
                .WriteLine("MaxScanRows=10")
                .WriteLine("CharacterSet=65001")
                .WriteLine("Format=CSVDelimited")
            End With

            If Not headerOnly Then
                'Write out all column information
                For Each row As DataRow In schema.Rows
                    columnCount += 1
                    column = GetFixedColumn(row("ColumnName").ToString)
                    If column IsNot Nothing Then
                        'This is a valid column
                        formatLine = "Col{0}={1} " & column.DataType
                        schemaFile.WriteLine(formatLine, columnCount, column.Name)
                    Else
                        'This is not a valid column for this file type
                        Throw New InvalidFileException(String.Format("Invalid column name ({0}) found.  File not processed!", column.Name), fileInfo.FullName)
                    End If
                Next
            End If

        Catch invalidFileEx As InvalidFileException
            Throw
            Exit Try

        Catch ex As Exception
            Throw New InvalidFileException("Unable to write to schema.ini file.  File not processed!", fileInfo.FullName, ex)

        End Try

        'Close the file
        schemaFile.Flush()
        schemaFile.Close()

    End Sub

    Private Function GetFixedColumns() As Collection(Of FixedColumn)

        Dim isCanada As Boolean = QualisysParams.CountryCode = CountryCode.Canada

        If mFixedColumns Is Nothing Then
            'Populate the fixed column collection
            mFixedColumns = New Collection(Of FixedColumn)

            With mFixedColumns
                .Add(New FixedColumn("HCAHPSSamp", "Integer"))
                .Add(New FixedColumn("Litho", "Char Width 10"))
                .Add(New FixedColumn("Survey_ID", "Integer"))
                .Add(New FixedColumn("SampleSet_ID", "Integer"))
                .Add(New FixedColumn("Phone", "Char Width 10"))
                .Add(New FixedColumn("AltPhone", "Char Width 10"))
                .Add(New FixedColumn("FName", "Char Width 42"))
                .Add(New FixedColumn("LName", "Char Width 42"))
                .Add(New FixedColumn("Addr", "Char Width 42"))
                .Add(New FixedColumn("Addr2", "Char Width 42"))
                .Add(New FixedColumn("City", "Char Width 42"))
                If isCanada Then
                    .Add(New FixedColumn("Province", "Char Width 2"))
                    .Add(New FixedColumn("PostalCode", "Char Width 7"))
                Else
                    .Add(New FixedColumn("St", "Char Width 2"))
                    .Add(New FixedColumn("Zip5", "Char Width 5"))
                End If    
                .Add(New FixedColumn("PhServDate", "Char Width 22"))
                .Add(New FixedColumn("LangID", "Integer"))
                .Add(New FixedColumn("Telematch", "Char Width 15"))
                .Add(New FixedColumn("PhFacName", "Char Width 100"))
                .Add(New FixedColumn("PhServInd1", "Char Width 100"))
                .Add(New FixedColumn("PhServInd2", "Char Width 100"))
                .Add(New FixedColumn("PhServInd3", "Char Width 100"))
                .Add(New FixedColumn("PhServInd4", "Char Width 100"))
                .Add(New FixedColumn("PhServInd5", "Char Width 100"))
                .Add(New FixedColumn("PhServInd6", "Char Width 100"))
                .Add(New FixedColumn("PhServInd7", "Char Width 100"))
                .Add(New FixedColumn("PhServInd8", "Char Width 100"))
                .Add(New FixedColumn("PhServInd9", "Char Width 100"))
                .Add(New FixedColumn("PhServInd10", "Char Width 100"))
                .Add(New FixedColumn("PhServInd11", "Char Width 100"))
                .Add(New FixedColumn("PhServInd12", "Char Width 100"))                
                '.Add(New FixedColumn("AgeRange", "Char Width 10"))
            End With
        Else
            'Reset the quantity
            For Each col As FixedColumn In mFixedColumns
                col.Quantity = 0
            Next
        End If

        Return mFixedColumns

    End Function

    Private Function GetFixedColumn(ByVal columnName As String) As FixedColumn

        For Each column As FixedColumn In GetFixedColumns()
            If column.Name.ToUpper = columnName.ToUpper Then
                Return column
            End If
        Next

        Return Nothing

    End Function

    Private Function DoAllFixedColumnsExist(ByVal schema As DataTable, ByRef missingColumns As String) As Boolean

        Dim fixedColumns As Collection(Of FixedColumn) = GetFixedColumns()

        'Check all columns
        For Each row As DataRow In schema.Rows
            For Each column As FixedColumn In fixedColumns
                If column.Name.ToUpper = row("ColumnName").ToString.ToUpper Then
                    column.Quantity += 1
                End If
            Next
        Next

        'Determine if any of the fixed columns were not found
        missingColumns = String.Empty
        For Each column As FixedColumn In fixedColumns
            If column.Quantity = 0 Then
                If missingColumns.Length > 0 Then
                    missingColumns &= ","
                End If
                missingColumns &= column.Name
            End If
        Next

        Return (missingColumns.Length = 0)

    End Function

#End Region

End Class
