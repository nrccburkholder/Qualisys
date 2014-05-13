Option Strict On

Imports System.IO

Public MustInherit Class DTSDataSet

#Region " Private Constants "

    Private Const TEMPLATE_FILE_NAME As String = "Template"
    Protected Const SEPARATOR As Char = Chr(1)

#End Region

#Region " Private Members "

    Protected mDataSetType As DataSetTypes
    Protected mColumns As ColumnCollection
    Protected mTemplateFile As String
    Protected mBadRecordThreshold As Single = 0.1

#End Region

#Region " Public Properites "

    Public Property DataSetType() As DataSetTypes
        Get
            Return mDataSetType
        End Get
        Set(ByVal Value As DataSetTypes)
            mDataSetType = Value
        End Set
    End Property

    Public Property Columns() As ColumnCollection
        Get
            Return mColumns
        End Get
        Set(ByVal Value As ColumnCollection)
            mColumns = Value
        End Set
    End Property

    Public Property TemplateFileName() As String
        Get
            Return mTemplateFile
        End Get
        Set(ByVal Value As String)
            mTemplateFile = Value
        End Set
    End Property

    Public Property BadRecordThreshold() As Single
        Get
            Return mBadRecordThreshold
        End Get
        Set(ByVal Value As Single)
            mBadRecordThreshold = Value
        End Set
    End Property

#End Region

#Region " Constructors "

    Sub New(ByVal dataType As DataSetTypes)

        mDataSetType = dataType
        mColumns = New ColumnCollection

    End Sub

#End Region

#Region " MustOverride Methods "

    Public MustOverride Function GetRecordCount(ByVal filePath As String) As Integer
    Public MustOverride Function GetDataTable(ByVal filePath As String, ByVal rowCount As Integer) As DataTable
    Protected MustOverride Function GetSchema(ByVal filePath As String) As DataTable

#End Region

#Region " Public Methods "

    Public Sub LoadColumnsFromFile(ByVal strPath As String)

        Dim column As SourceColumn
        Dim row As DataRow
        Dim type As String

        Columns.Clear()

        Dim table As DataTable = GetSchema(strPath)

        For Each row In table.Rows
            column = New SourceColumn
            column.ColumnName = row("ColumnName").ToString()
            column.OriginalName = row("ColumnName").ToString()
            column.Ordinal = CType(row("ColumnOrdinal"), Integer) + 1
            column.Length = CType(row("ColumnSize"), Integer)
            type = row("DataType").ToString.ToLower.Replace("system.", "")

            Select Case type
                Case "string"
                    column.DataType = DataTypes.Varchar

                Case "integer"
                    column.DataType = DataTypes.Int

                Case "int32"
                    column.DataType = DataTypes.Int

                Case "int16"
                    column.DataType = DataTypes.Int

                Case "datetime"
                    column.DataType = DataTypes.DateTime

                Case Else
                    column.DataType = DataTypes.Varchar
                    column.Length = 8000

            End Select

            Columns.Add(column)
        Next

    End Sub

    Public Overridable Sub SplitSettings(ByVal settings As String)

        'By default do nothing...

    End Sub

    Public Overridable Function ConcatSettings() As String

        Return String.Empty

    End Function

    'If the data source is ado.net enabled and has column names, like MS Access,
    'dBase, XML, we will use this method to validate source file.
    'For the data source which is not ado.net enabled (like text file), or may not
    'have column name (like Excel), an individual version of "ValidateFile" method 
    'will override this version to do validation.
    Public Overridable Function ValidateFile(ByVal filePath As String, ByRef errMsg As String) As FileValidationResults

        Try
            'Get schema of the table in input file
            Dim dt As DataTable = GetSchema(filePath)
            If (dt Is Nothing) Then
                errMsg = "Can not get schema from file " + filePath
                Return FileValidationResults.InvalidFile
            End If

            'Check column number
            If (dt.Rows.Count <> Columns.Count) Then
                errMsg = "Number of columns is different from that in DTS package"
                Return FileValidationResults.InvalidFile
            End If

            'Check column names and types
            Dim i As Integer
            Dim dtsColumnName As String
            Dim fileColumnName As String
            Dim type As String
            Dim size As Integer
            For i = 0 To dt.Rows.Count - 1
                'check column name
                dtsColumnName = mColumns(i).ColumnName
                fileColumnName = dt.Rows(i)("ColumnName").ToString
                If (dtsColumnName <> fileColumnName) Then
                    errMsg = String.Format("Name mismatch for column {0}.{1}", (i + 1), vbCrLf)
                    errMsg += String.Format("Column name in DTS package is {0}.{1}", dtsColumnName, vbCrLf)
                    errMsg += String.Format("Column name in loading file is {0}.", fileColumnName)
                    Return FileValidationResults.InvalidFile
                End If

                'check column data type
                type = dt.Rows(i).Item("DataType").ToString.ToLower.Replace("system.", "")
                size = CType(dt.Rows(i).Item("ColumnSize"), Integer)
                'Dim np As String = dt.Rows(i).Item("NumericPrecision").ToString
                Select Case mColumns(i).DataType
                    Case DataTypes.Int
                        If ((type <> "integer") AndAlso _
                            (type <> "int32") AndAlso _
                            (type <> "int16")) Then
                            errMsg = String.Format("Data type mismatch for Column {0}.{1}", (i + 1), vbCrLf)
                            errMsg += String.Format("Data type in DTS package is integer.{0}", vbCrLf)
                            errMsg += String.Format("Data type in loading file is {0}", type)
                            Return FileValidationResults.InvalidFile
                        End If

                    Case DataTypes.DateTime
                        If (type <> "datetime") Then
                            errMsg = String.Format("Data type mismatch for column {0}.{1}", (i + 1), vbCrLf)
                            errMsg += String.Format("Data type in DTS package is datatime.{0}", vbCrLf)
                            errMsg += String.Format("Data type in loading file is {0}", type)
                            Return FileValidationResults.InvalidFile
                        End If

                    Case DataTypes.Varchar
                        If type = "string" AndAlso Not mColumns(i).Length = size Then
                            errMsg = String.Format("Data type mismatch for column {0}.{1}", (i + 1), vbCrLf)
                            errMsg += String.Format("Field length in DTS package is {0}.{1}", size, vbCrLf)
                            errMsg += String.Format("Field length in loading file is {0}.", mColumns(i).Length)
                            Return FileValidationResults.InvalidFile
                        End If

                        If Not type = "integer" AndAlso Not type = "int32" AndAlso Not type = "int16" AndAlso Not type = "datetime" AndAlso Not type = "string" Then
                            If Not mColumns(i).Length = 8000 Then
                                errMsg = String.Format("Data type mismatch for column {0}.{1}", (i + 1), vbCrLf)
                                errMsg += String.Format("Data type in DTS package is varchar({0}).{1}", size, vbCrLf)
                                errMsg += String.Format("Data type in loading file is {0} and should be mapped to a varchar(8000) field.", type)
                                Return FileValidationResults.InvalidFile
                            End If
                        End If

                End Select

            Next

            Return FileValidationResults.ValidFile

        Catch ex As Exception
            errMsg = ex.Message
            Return FileValidationResults.InvalidFile

        End Try

    End Function

    ' This method is only used for testing/debugging
    Public Overridable Function Settings() As String

        Return ""

    End Function

    Public Sub SetTemplateFileName(ByVal path As String)

        Dim fi As New FileInfo(path)
        mTemplateFile = TEMPLATE_FILE_NAME + fi.Extension

    End Sub

#End Region

#Region " Protected Methods "

    Protected Shared Function GetFolder(ByVal filePath As String) As String

        Dim file As New IO.FileInfo(filePath)
        Return file.DirectoryName

    End Function

    Protected Shared Function GetFileName(ByVal filePath As String) As String

        Dim file As New IO.FileInfo(filePath)
        Return file.Name

    End Function

#End Region

End Class
