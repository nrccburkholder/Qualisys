Option Explicit On
Option Strict On

Public Enum TextFileDataTypes
    CHAR_TYPE = 1
    FLOAT_TYPE = 2
    INTEGER_TYPE = 3
    LONGCHAR_TYPE = 4
    DATE_TYPE = 5

End Enum

#Region "MultiUpdateFileWriterStreamContainer"
Public Class MultiUpdateFileWriterStreamContainer
    Protected _streamWritter As IO.StreamWriter
    Protected _bAccessed As Boolean = False

    Public Sub New(ByVal fileName As String)
        Dim s As IO.Stream = IO.File.Open(fileName, IO.FileMode.Create, IO.FileAccess.Write, IO.FileShare.None)
        _streamWritter = New IO.StreamWriter(s)
    End Sub

    Public Sub WriteLine(ByVal text As String)
        If _streamWritter Is Nothing Then
            Throw New InvalidOperationException("Can not write to MultiUpdateFileWriterStreamContainer after it has been closed.")
        End If

        _bAccessed = True
        _streamWritter.WriteLine(text)
    End Sub

    Public Sub Close()
        Dim s As IO.Stream = _streamWritter.BaseStream()

        'clean up file access
        _streamWritter.Close()
        s.Close()
        _streamWritter = Nothing
        s = Nothing
    End Sub

    Public ReadOnly Property HasStreamAccessOccured() As Boolean
        Get
            Return _bAccessed
        End Get
    End Property
End Class
#End Region

Public Interface MultiUpdateFileWriter
    Function UpdateFileBegin() As MultiUpdateFileWriterStreamContainer
    Sub UpdateFileEnd(ByRef swc As MultiUpdateFileWriterStreamContainer)
    Sub UpdateFile(ByRef swc As MultiUpdateFileWriterStreamContainer, ByRef ds As System.Data.DataSet, Optional ByVal sTable As String = "")
End Interface

Public Interface MultiFillFileReader
    Function MaxRecordFill(ByRef ds As System.Data.DataSet, ByVal iStartRecord As Integer, ByVal iMaxRecords As Integer, ByVal sTable As String) As Integer
    Function RecordCount() As Integer
End Interface

Public MustInherit Class clsFIETextFile
    Inherits clsFileImportExport
    Implements MultiUpdateFileWriter
    Implements MultiFillFileReader

    Public Const EXPORT_WRITER_PROPERTY_FORMAT_STRING As String = "FormatString"
    Public Const EXPORT_WRITER_PROPERTY_WIDTH As String = "Width"

    Protected _sFileFormat As String = ""

    Protected _bUseODBCExport As Boolean = False

    Public Sub New(Optional ByVal sFilename As String = "")
        MyBase.New(sFilename)

        If (m_ExportHeaders AndAlso _bUseODBCExport) Then
            Throw New InvalidOperationException("Including a header row in the export is impossible when the output text file is in ODBC Export mode!")
        End If
    End Sub

    Protected Overrides Function ConnectionString() As String
        Dim sbConn As New Text.StringBuilder

        'data source for text driver is a folder with text files
        'the folder is treated like database, and each text file is a table
        sbConn.AppendFormat("Provider=Microsoft.Jet.OLEDB.4.0; Data Source={0}; Extended Properties=""text""", Me._sPath)

        Return sbConn.ToString

    End Function

    Public Overrides Property ExportHeaderRow() As Boolean
        Get
            Return Me.m_ExportHeaders
        End Get
        Set(ByVal Value As Boolean)
            If (Value AndAlso _bUseODBCExport) Then
                Throw New InvalidOperationException("Including a header row in the export is impossible when the output text file is in ODBC Export mode!")
            End If
            Me.m_ExportHeaders = Value
        End Set
    End Property


    Function RecordCount() As Integer Implements MultiFillFileReader.RecordCount
        Dim cn As OleDb.OleDbConnection = New OleDb.OleDbConnection(ConnectionString())
        Dim dc As OleDb.OleDbCommand = New OleDb.OleDbCommand(String.Format("SELECT COUNT(*) FROM {0}", Me._sFile), cn)

        dc.CommandType = CommandType.Text
        cn.Open()

        Try
            Return CInt(dc.ExecuteScalar())
        Finally
            dc = Nothing
            cn.Close()
            cn = Nothing
        End Try
    End Function

    Function MaxRecordFill(ByRef ds As System.Data.DataSet, ByVal iStartRecord As Integer, ByVal iMaxRecords As Integer, ByVal sTable As String) As Integer Implements MultiFillFileReader.MaxRecordFill
        Dim sbSelect As New Text.StringBuilder
        Dim cn As OleDb.OleDbConnection
        Dim da As OleDb.OleDbDataAdapter
        Dim recCount As Integer = -1

        MakeSchema()

        sbSelect.AppendFormat("SELECT * FROM {0}", Me._sFile)
        cn = New OleDb.OleDbConnection(ConnectionString())
        da = New OleDb.OleDbDataAdapter(sbSelect.ToString, cn)

        cn.Open()

        Try
            recCount = da.Fill(ds, iStartRecord, iMaxRecords, sTable)
        Finally
            cn.Close()
            cn = Nothing
            da = Nothing
        End Try

        CleanSchema()

        Return recCount
    End Function

    Public Overrides Sub Fill(ByRef ds As System.Data.DataSet, Optional ByVal sTable As String = "")
        Dim sbSelect As New Text.StringBuilder
        Dim cn As OleDb.OleDbConnection
        Dim da As OleDb.OleDbDataAdapter

        MakeSchema()

        sbSelect.AppendFormat("SELECT * FROM {0}", Me._sFile)
        cn = New OleDb.OleDbConnection(ConnectionString())
        da = New OleDb.OleDbDataAdapter(sbSelect.ToString, cn)

        cn.Open()
        If sTable.Length > 0 Then
            da.Fill(ds, sTable)
        Else
            da.Fill(ds)
        End If
        cn.Close()

        cn = Nothing
        da = Nothing
        CleanSchema()
    End Sub

    Public Overrides Sub Update(ByRef ds As System.Data.DataSet, Optional ByVal sTable As String = "")
        Dim cn As OleDb.OleDbConnection
        Dim da As OleDb.OleDbDataAdapter
        Dim cmd As OleDb.OleDbCommand
        Dim f As IO.File
        Dim fs As IO.FileStream

        If Me._bUseODBCExport Then
            If (m_ExportHeaders) Then
                Throw New InvalidOperationException("Including a header row in the export is impossible when the output text file is in ODBC Export mode!")
            End If

            MakeSchema()

            If Not f.Exists(Me._sFilename) Then
                fs = f.Create(Me._sFilename)
                fs.Close()

            End If

            cn = New OleDb.OleDbConnection(ConnectionString())
            da = New OleDb.OleDbDataAdapter
            cmd = MakeInsertCmd(cn)

            da.InsertCommand = cmd
            cn.Open()

            If sTable.Length > 0 Then
                da.Update(ds, sTable)

            Else
                da.Update(ds.Tables(0))
            End If
            cn.Close()

            cn = Nothing
            da = Nothing
            cmd = Nothing
            CleanSchema()

        Else
            UpdateNonODBC(ds, sTable)

        End If

    End Sub

    Private Sub MakeSchema()
        Dim dr As dsFileDef.tblFileDefRow
        Dim sb As Text.StringBuilder

        'load schema file
        Dim sFilename As String = String.Format("{0}schema.ini", Me._sPath)
        Dim oSchemaIni As New clsIniFile(sFilename)

        'get section for text file
        oSchemaIni.SetSection(Me._sFile)

        'clear existing section keys
        oSchemaIni.Keys.Clear()
        'add file type key
        oSchemaIni.Keys.Add("Format", Me._sFileFormat)
        'add header option key
        oSchemaIni.Keys.Add("ColNameHeader", Me.HasHeader.ToString)

        'add column definition keys
        Me._dsFileDef.tblFileDef.DefaultView.Sort = "ColOrder"
        For Each dr In Me._dsFileDef.tblFileDef.Rows
            sb = New Text.StringBuilder
            sb.AppendFormat("{0} {1}", dr.ColName, GetTypeName(dr.ColType))
            If Not dr.IsColWidthNull Then
                If dr.ColWidth > 0 Then
                    sb.AppendFormat(" Width {0}", dr.ColWidth)

                End If
            End If

            oSchemaIni.Keys.Add(String.Format("Col{0}", dr.ColOrder), sb.ToString)

        Next

        'save schema
        oSchemaIni.SaveSection()

        oSchemaIni = Nothing

    End Sub

    Private Sub CleanSchema()
        'load schema file
        Dim sFilename As String = String.Format("{0}schema.ini", Me._sPath)
        Dim oSchemaIni As New clsIniFile(sFilename)

        oSchemaIni.DeleteSection(sFilename)

        oSchemaIni = Nothing

    End Sub

    Private Function MakeInsertCmd(ByRef cn As OleDb.OleDbConnection) As OleDb.OleDbCommand
        Dim sbInsert As New Text.StringBuilder
        Dim dr As dsFileDef.tblFileDefRow
        Dim cmd As OleDb.OleDbCommand

        'build insert sql
        sbInsert.AppendFormat("INSERT INTO {0} (", _sFile)

        'add table fields
        Me._dsFileDef.tblFileDef.DefaultView.Sort = "ColOrder"
        For Each dr In Me._dsFileDef.tblFileDef.Rows
            sbInsert.AppendFormat("[{0}], ", dr.ColName)

        Next
        sbInsert.Remove(sbInsert.Length - 2, 2)
        sbInsert.Append(") VALUES (")

        'add value parameters
        For Each dr In Me._dsFileDef.tblFileDef.Rows
            sbInsert.AppendFormat("@{0}, ", dr.ColName)

        Next
        sbInsert.Remove(sbInsert.Length - 2, 2)
        sbInsert.Append(")")

        'create insert command
        cmd = New OleDb.OleDbCommand(sbInsert.ToString, cn)
        cmd.CommandType = CommandType.Text

        'add parameters to command
        For Each dr In Me._dsFileDef.tblFileDef.Rows
            cmd.Parameters.Add(New OleDb.OleDbParameter(String.Format("@{0}", dr.ColName), GetOleDbType(dr.ColType), dr.ColWidth, dr.ColName))

        Next

        Return cmd

    End Function

    Protected Overridable Function GetOleDbType(ByVal iType As Integer) As OleDb.OleDbType
        Select Case iType
            Case CInt(TextFileDataTypes.CHAR_TYPE)
                Return Data.OleDb.OleDbType.Char

            Case CInt(TextFileDataTypes.DATE_TYPE)
                Return Data.OleDb.OleDbType.VarChar

            Case CInt(TextFileDataTypes.FLOAT_TYPE)
                Return Data.OleDb.OleDbType.Double

            Case CInt(TextFileDataTypes.INTEGER_TYPE)
                Return Data.OleDb.OleDbType.Integer

            Case CInt(TextFileDataTypes.LONGCHAR_TYPE)
                Return Data.OleDb.OleDbType.LongVarChar

        End Select

    End Function

    Protected Overridable Function GetTypeName(ByVal iType As Integer) As String
        Select Case iType
            Case CInt(TextFileDataTypes.CHAR_TYPE)
                Return "Char"

            Case CInt(TextFileDataTypes.DATE_TYPE)
                Return "Date"

            Case CInt(TextFileDataTypes.FLOAT_TYPE)
                Return "Double"

            Case CInt(TextFileDataTypes.INTEGER_TYPE)
                Return "Integer"

            Case CInt(TextFileDataTypes.LONGCHAR_TYPE)
                Return "LongChar"

        End Select

    End Function

    Private Function GenerateHeaderRow(ByRef sortedDataView As DataView) As String
        Dim sb As System.Text.StringBuilder = New System.Text.StringBuilder
        Dim drColDef As DataRowView

        For Each drColDef In sortedDataView
            sb.AppendFormat(GetColName(drColDef))
        Next

        Return sb.ToString()
    End Function

    Protected Overridable Sub UpdateNonODBC(ByRef ds As System.Data.DataSet, Optional ByVal sTable As String = "")
        Dim dr As DataRow
        Dim dt As DataTable
        Dim dv As DataView
        Dim drColDef As DataRowView
        Dim sw As IO.StreamWriter
        Dim f As IO.File
        Dim s As IO.Stream
        Dim sb As System.Text.StringBuilder

        'open file for writing
        s = f.Open(Me._sFilename, IO.FileMode.Create, IO.FileAccess.Write, IO.FileShare.None)
        sw = New IO.StreamWriter(s)

        'get table reference
        If sTable.Length = 0 Then dt = ds.Tables(0) Else dt = ds.Tables(sTable)

        'Make sure file def data is sorted in column order
        dv = Me._dsFileDef.tblFileDef.DefaultView
        dv.Sort = "ColOrder"

        If Me.ExportHeaderRow Then
            'emit column labels
            sw.WriteLine(GenerateHeaderRow(dv))
        End If

        'loop through data rows
        For Each dr In dt.Rows
            'new string builder
            sb = New System.Text.StringBuilder

            'loop through data columns
            For Each drColDef In dv
                sb.Append(GetColValue(dr, drColDef))

            Next

            'write row to file
            sw.WriteLine(sb.ToString)

        Next

        'clean up file access
        sw.Close()
        s.Close()
        sw = Nothing
        s = Nothing

    End Sub

    Protected Function CastToType(ByRef oObject As Object, ByVal iType As TextFileDataTypes) As Object
        Select Case iType
            Case TextFileDataTypes.CHAR_TYPE
                Return CType(oObject, Char)
            Case TextFileDataTypes.DATE_TYPE
                Return CType(oObject, DateTime)
            Case TextFileDataTypes.FLOAT_TYPE
                Return CType(oObject, Double)
            Case TextFileDataTypes.INTEGER_TYPE
                Return CType(oObject, Integer)
            Case TextFileDataTypes.LONGCHAR_TYPE
                Return CType(oObject, String)
            Case Else
                Throw New ArgumentOutOfRangeException("iType", iType, "Unknown data type supplied to CastToType().")
        End Select
    End Function

    Protected Overridable Function GetColName(ByVal drColDef As System.Data.DataRowView) As String
        Return CleanValue(drColDef.Item("ColName").ToString(), TextFileDataTypes.LONGCHAR_TYPE)
    End Function

    Protected Overridable Function GetColValue(ByVal dr As DataRow, ByVal drColDef As DataRowView) As String
        Dim sColName As String = drColDef.Item("ColName").ToString
        Dim iDataType As TextFileDataTypes = CType(drColDef.Item("ColType"), TextFileDataTypes)
        Dim extendedProps As PropertyCollection = dr.Table.Columns(sColName).ExtendedProperties()

        Dim objValue As Object = dr.Item(sColName)
        Dim sValue As String

        If (TypeOf objValue Is DBNull) Then
            sValue = ""
        Else
            If (extendedProps.ContainsKey(EXPORT_WRITER_PROPERTY_FORMAT_STRING)) Then
                Dim sFormat As String = CStr(extendedProps(EXPORT_WRITER_PROPERTY_FORMAT_STRING))
                objValue = CastToType(objValue, iDataType)
                sValue = CType(objValue, IFormattable).ToString(sFormat, Nothing)
            Else
                sValue = objValue.ToString
            End If
        End If

        Return CleanValue(sValue, iDataType)
    End Function

    Protected Function CleanValue(ByVal sValue As String, ByVal iDataType As TextFileDataTypes) As String
        Select Case iDataType
            Case TextFileDataTypes.CHAR_TYPE, TextFileDataTypes.LONGCHAR_TYPE
                Return String.Format("""{0}""", sValue)
            Case Else
                Return sValue
        End Select
    End Function

    Public Function UpdateFileBegin() As MultiUpdateFileWriterStreamContainer Implements MultiUpdateFileWriter.UpdateFileBegin
        Return New MultiUpdateFileWriterStreamContainer(Me._sFilename)
    End Function

    Public Sub UpdateFileEnd(ByRef swc As MultiUpdateFileWriterStreamContainer) Implements MultiUpdateFileWriter.UpdateFileEnd
        swc.Close()
    End Sub

    Public Sub UpdateFile(ByRef swc As MultiUpdateFileWriterStreamContainer, ByRef ds As System.Data.DataSet, Optional ByVal sTable As String = "") Implements MultiUpdateFileWriter.UpdateFile
        Dim dr As DataRow
        Dim dt As DataTable
        Dim dv As DataView
        Dim drColDef As DataRowView
        Dim sb As System.Text.StringBuilder

        'get table reference
        If sTable.Length = 0 Then dt = ds.Tables(0) Else dt = ds.Tables(sTable)

        'Make sure file def data is sorted in column order
        dv = Me._dsFileDef.tblFileDef.DefaultView
        dv.Sort = "ColOrder"

        If Me.ExportHeaderRow Then
            'emit column labels
            If Not swc.HasStreamAccessOccured Then
                swc.WriteLine(GenerateHeaderRow(dv))
            End If
        End If

        'loop through data rows
        For Each dr In dt.Rows
            'new string builder
            sb = New System.Text.StringBuilder

            'loop through data columns
            For Each drColDef In dv
                sb.Append(GetColValue(dr, drColDef))
            Next

            'write row to file
            swc.WriteLine(sb.ToString)
        Next
    End Sub
End Class
