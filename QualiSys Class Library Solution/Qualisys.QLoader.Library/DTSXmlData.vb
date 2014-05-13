Option Explicit On 
Option Strict On

Imports System.IO
Imports System.Text

Public Class DTSXmlData
    Inherits DTSDataSet

#Region " Private Members "

    Protected mTableName As String

#End Region

#Region " Public Properties "

    Public Property TableName() As String
        Get
            Return mTableName
        End Get
        Set(ByVal Value As String)
            mTableName = Value
        End Set
    End Property

#End Region

#Region " Constructors "

    Public Sub New()

        MyBase.New(DataSetTypes.XML)

    End Sub

    Sub New(ByVal tableName As String)

        MyBase.New(DataSetTypes.XML)
        mTableName = tableName

    End Sub

#End Region

#Region " Public Methods "

    Public Overrides Sub SplitSettings(ByVal settings As String)

        Dim args() As String = settings.Split(SEPARATOR)

        If args.Length <> 2 Then
            Throw New ArgumentException("Setting string in source data set is incorrect")
        End If

        'Template file name
        TemplateFileName = args(0)

        'Table name
        TableName = args(1)

    End Sub

    Public Overrides Function ConcatSettings() As String

        Dim settings As String = String.Format("{0}{1}{2}", TemplateFileName, SEPARATOR, TableName)

        Return (settings)

    End Function

    Public Overrides Function GetDataTable(ByVal filePath As String, ByVal rowCount As Integer) As System.Data.DataTable

        Using ds As New DataSet()
            ds.ReadXml(filePath)

            For Each dt As DataTable In ds.Tables
                If dt.TableName = TableName Then
                    Return (dt)
                End If
            Next
        End Using

        Return Nothing

    End Function

    Public Overrides Function GetRecordCount(ByVal filePath As String) As Integer

        Dim dt As DataTable = GetDataTable(filePath, 0)

        If dt Is Nothing Then
            Return 0
        End If

        Return (dt.Rows.Count)

    End Function

    Protected Overrides Function GetSchema(ByVal filePath As String) As System.Data.DataTable

        Dim dt As DataTable
        Dim table As DataTable = Nothing
        Dim dr As DataRow
        Dim columnOrdinal As Integer = 0

        Using ds As New DataSet()
            'Load XML schema
            ds.ReadXmlSchema(filePath)

            'Find the table used for this package
            For Each dt In ds.Tables
                If dt.TableName = TableName Then
                    table = dt
                    Exit For
                End If
            Next

            'Table doesn't exist
            If (table Is Nothing) Then Return (Nothing)

            'Create schema table
            dt = New DataTable("SchemaTable")
            dt.Columns.Add("ColumnName", GetType(System.String))
            dt.Columns.Add("ColumnOrdinal", GetType(System.Int32))
            dt.Columns.Add("ColumnSize", GetType(System.Int32))
            dt.Columns.Add("DataType", GetType(System.Object))

            For Each column As DataColumn In table.Columns
                dr = dt.NewRow
                dr("ColumnName") = column.ColumnName
                dr("ColumnOrdinal") = columnOrdinal
                dr("ColumnSize") = CInt(IIf(column.MaxLength > 0, column.MaxLength, Nrc.Qualisys.QLoader.Library.Column.MAX_VARCHAR_LENGTH))
                dr("DataType") = column.DataType
                dt.Rows.Add(dr)
                columnOrdinal += 1
            Next

            Return (dt)

        End Using

    End Function

    Public Sub CreateXsd(ByVal path As String, ByVal tableName As String)

        Dim sw As StreamWriter = File.CreateText(path)

        sw.WriteLine("<xsd:schema xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" xmlns:sql=""urn:schemas-microsoft-com:mapping-schema"">")
        sw.WriteLine("  <xsd:element name=""{0}"" sql:relation=""{1}"" >", Me.TableName, tableName)
        sw.WriteLine("    <xsd:complexType>")
        sw.WriteLine("      <xsd:sequence>")

        For Each col As SourceColumn In Columns
            sw.WriteLine("        <xsd:element name=""{0}"" type=""xsd:string"" sql:field=""{1}"" />", col.ColumnName, col.ColumnName)
        Next

        sw.WriteLine("      </xsd:sequence>")
        sw.WriteLine("    </xsd:complexType>")
        sw.WriteLine("  </xsd:element>")
        sw.WriteLine("</xsd:schema>")

        sw.Close()

    End Sub

    'This method is only used for testing/debugging
    Public Overrides Function Settings() As String

        Dim str As New StringBuilder

        str.Append(String.Format("Dataset type: {0}{1}", DataSetType, vbCrLf))
        str.Append(String.Format("Table name: {0}{1}{1}", TableName, vbCrLf))
        str.Append(String.Format("Ordinal: Name  Data Type  Length  Original Name  Source ID{0}", vbCrLf))
        str.Append(String.Format("================================{0}", vbCrLf))

        For Each col As SourceColumn In Columns
            With col
                str.Append(String.Format("{0}:  ", .Ordinal))
                str.Append(String.Format("{0}    ", .ColumnName))
                str.Append(String.Format("{0} ({1})    ", .DataType, .DataTypeString))
                str.Append(String.Format("{0}    ", .Length))
                str.Append(String.Format("{0}    ", .OriginalName))
                str.Append(String.Format("{0}{1}", .SourceID, vbCrLf))
            End With
        Next

        Return str.ToString

    End Function

#End Region

End Class
