Imports System.Data
Imports System.IO
Imports System.Collections.ObjectModel

Namespace Data

    Public MustInherit Class DataWriter

#Region " ReportProgress Event "
        Public Class ReportProgressEventArgs
            Inherits EventArgs

            Private mRecordsWritten As Integer

            Public ReadOnly Property RecordsWritten() As Integer
                Get
                    Return mRecordsWritten
                End Get
            End Property

            Public Sub New(ByVal recordsWritten As Integer)
                mRecordsWritten = recordsWritten
            End Sub
        End Class
        Public Event ReportProgress As EventHandler(Of ReportProgressEventArgs)

#End Region

#Region " Private Members "
        Private mFilePath As String
        Private mReader As IDataReader

        Private mSchemaTable As DataTable
        Private mColumns As New Collection(Of DataWriterColumn)
        Private mShortColumnNames As New Dictionary(Of String, String)
#End Region

#Region " Protected Properties "
        Protected ReadOnly Property FilePath() As String
            Get
                Return mFilePath
            End Get
        End Property

        Protected ReadOnly Property FolderPath() As String
            Get
                Return Path.GetDirectoryName(mFilePath)
            End Get
        End Property

        Protected ReadOnly Property FileName() As String
            Get
                Return Path.GetFileName(mFilePath)
            End Get
        End Property

        Protected Overridable ReadOnly Property TableName() As String
            Get
                Return Path.GetFileNameWithoutExtension(mFilePath)
            End Get
        End Property
#End Region

#Region " Public Properties "
        Public ReadOnly Property Columns() As Collection(Of DataWriterColumn)
            Get
                Return mColumns
            End Get
        End Property
#End Region

#Region " Constructors "

        Protected Sub New(ByVal table As DataTable)
            Me.New(New DataTableReader(table))
        End Sub

        Protected Sub New(ByVal reader As IDataReader)
            Me.mReader = reader

            'Initialize the data schema 
            Me.InitSchemaTable()
        End Sub
#End Region

#Region " Public Methods "
        Public Function Write(ByVal filePath As String) As Integer
            Return Me.Write(filePath, 100)
        End Function

        Public Function Write(ByVal filePath As String, ByVal reportProgressInterval As Integer) As Integer
            Dim recordsWritten As Integer = 0
            'Store path
            Me.mFilePath = filePath

            'Overwrite the file if exists
            If File.Exists(mFilePath) Then
                File.Delete(mFilePath)
            End If

            'Allow derived classes to perform operations before writing begins
            Me.BeginWrite()

            'Write each row
            While mReader.Read
                Me.WriteRow(mReader)
                recordsWritten += 1

                If recordsWritten > 0 AndAlso (recordsWritten Mod reportProgressInterval = 0) Then
                    Me.OnReportProgress(New ReportProgressEventArgs(recordsWritten))
                End If
            End While

            'Allow derived classes to perform operations after writing ends
            Me.EndWrite(recordsWritten)

            Return recordsWritten
        End Function

#End Region

#Region " Protected Methods "
        Protected MustOverride ReadOnly Property ColumnNameMaxLength() As Integer

        Protected Overridable Sub InitSchemaTable()
            mSchemaTable = mReader.GetSchemaTable

            For Each row As DataRow In mSchemaTable.Rows
                Dim col As New DataWriterColumn
                col.Name = row("ColumnName").ToString
                col.ShortName = Me.GetShortColumnName(col.Name)
                col.Size = CType(row("ColumnSize"), Integer)
                col.DataType = row("DataType").ToString
                col.Ordinal = CType(row("ColumnOrdinal"), Integer)

                Me.mColumns.Add(col)
            Next
        End Sub

        Protected Overridable Sub BeginWrite()
        End Sub

        Protected MustOverride Sub WriteRow(ByVal reader As IDataReader)

        Protected Overridable Sub EndWrite(ByVal recordsWritten As Integer)
        End Sub

        Protected Overridable Sub OnReportProgress(ByVal e As ReportProgressEventArgs)
            RaiseEvent ReportProgress(Me, e)
        End Sub
#End Region

#Region " Private Methods "
        Private Function GetShortColumnName(ByVal columnName As String) As String
            If Not mShortColumnNames.ContainsKey(columnName) Then
                Dim cleanName As String = columnName
                If columnName.Length > Me.ColumnNameMaxLength Then
                    cleanName = columnName.Substring(0, Me.ColumnNameMaxLength)
                End If

                Dim i As Integer = 1
                While Me.mShortColumnNames.ContainsValue(cleanName)
                    If i > Me.ColumnNameMaxLength Then
                        cleanName = columnName.Substring(0, Me.ColumnNameMaxLength) & i.ToString
                    Else
                        cleanName = columnName.Substring(0, Me.ColumnNameMaxLength - 1) & i.ToString
                    End If
                    i += 1
                End While

                Me.mShortColumnNames.Add(columnName, cleanName)
            End If

            Return mShortColumnNames(columnName)
        End Function

#End Region

#Region " Shared Methods "
        Public Shared Function WriteExcel(ByVal reader As IDataReader, ByVal filePath As String) As Integer
            Dim writer As New ExcelWriter(reader)
            Return writer.Write(filePath)
        End Function
        Public Shared Function WriteExcel(ByVal table As DataTable, ByVal filePath As String) As Integer
            Dim writer As New ExcelWriter(table)
            Return writer.Write(filePath)
        End Function

        Public Shared Function WriteDbf(ByVal reader As IDataReader, ByVal filePath As String) As Integer
            Dim writer As New DbfWriter(reader)
            Return writer.Write(filePath)
        End Function

        Public Shared Function WriteDbf(ByVal reader As IDataReader, ByVal filePath As String, ByRef filesCreated As Integer) As Integer
            Dim writer As New DbfWriter(reader)
            Return writer.Write(filePath, 100, filesCreated)
        End Function

        Public Shared Function WriteCsv(ByVal reader As IDataReader, ByVal filePath As String) As Integer
            Dim writer As New CsvWriter(reader)
            Return writer.Write(filePath)
        End Function

        Public Shared Function WriteCsv(ByVal table As DataTable, ByVal filePath As String) As Integer
            Dim writer As New CsvWriter(table)
            Return writer.Write(filePath)
        End Function

#End Region

    End Class

End Namespace
