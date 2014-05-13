Imports System.Text
Public Class SQLScriptGenerator
#Region "Private Fields"
    Private mStoredProcedureName As String
    Private mIgnoreIdentityColumn As Boolean = True
    Private mFilterParameters As New List(Of SqlClient.SqlParameter)
    Private mSourceTableData As System.Data.DataTable
    Private mWhereClause As String
    Private mUseStoredProcedure As Boolean = True
    Private mSourceTable As TableSchema
#End Region
#Region "Public Properties"
    Public Property StoredProcedureName() As String
        Get
            Return mStoredProcedureName
        End Get
        Set(ByVal value As String)
            mStoredProcedureName = value
        End Set
    End Property
    Public Property FilterParameters() As List(Of SqlClient.SqlParameter)
        Get
            Return mFilterParameters
        End Get
        Set(ByVal value As List(Of SqlClient.SqlParameter))
            mFilterParameters = value
        End Set
    End Property
    Public Property IgnoreIdentityColumn() As Boolean
        Get
            Return mIgnoreIdentityColumn
        End Get
        Set(ByVal value As Boolean)
            mIgnoreIdentityColumn = value
        End Set
    End Property
    Public Property WhereClause() As String
        Get
            Return mWhereClause
        End Get
        Set(ByVal value As String)
            If mFilterParameters.Count > 0 Then
                Throw New Exception("Can't use FilterParameters and WhereClause at the same time")
            End If
            mWhereClause = value
        End Set
    End Property
    Public Property SourceTableData() As System.Data.DataTable
        Get
            If mSourceTableData Is Nothing Then
                'mSourceTableData = SourceTable.GetTableData()
                mSourceTableData = Me.GetDataTable()
            End If
            Return mSourceTableData
        End Get
        Set(ByVal value As System.Data.DataTable)
            mSourceTableData = value
        End Set
    End Property

    Public Property SourceTable() As TableSchema
        Get
            Return mSourceTable
        End Get
        Set(ByVal value As TableSchema)
            mSourceTable = value
        End Set
    End Property
    Public Property UseStoredProcedure() As Boolean
        Get
            Return mUseStoredProcedure
        End Get
        Set(ByVal value As Boolean)
            mUseStoredProcedure = value
        End Set
    End Property

#End Region
#Region "Public Methods"
    Public Sub New()
    End Sub
    Public Sub New(ByVal schema As TableSchema)
        mSourceTable = schema
    End Sub
    Public Function GetInsertStatements() As String
        If Me.UseStoredProcedure Then
            Return GetSPStatements()
        End If
        Dim builder As New StringBuilder()
        If Not IgnoreIdentityColumn Then
            builder.AppendFormat("TRUNCATE TABLE {0}{1}{2}", GetTableOwner(), SourceTable.Name, vbCrLf)
            builder.AppendFormat("DBCC CHECKIDENT ('{0}{1}', RESEED, 1001){2}", GetTableOwner(), SourceTable.Name, vbCrLf)
            builder.AppendFormat("SET IDENTITY_INSERT {0}{1} ON {2}", GetTableOwner(), SourceTable.Name, vbCrLf)
        End If
        builder.AppendFormat("INSERT INTO  {0}{1}{2}({3}", GetTableOwner(), SourceTable.Name, vbCrLf, vbCrLf)
        For i As Integer = 0 To SourceTable.Columns.Count - 1 Step i + 1
            If IgnoreIdentityColumn AndAlso IsIdentity(SourceTable.Columns(i)) Then
                Continue For
            End If
            builder.AppendFormat("[{0}]", SourceTable.Columns(i).ColumnName)
            If i < SourceTable.Columns.Count - 1 Then
                builder.AppendLine(",")
            End If
        Next
        builder.AppendFormat("{0}){1}", vbCrLf, vbCrLf)
        For i As Integer = 0 To SourceTableData.Rows.Count - 1 Step i + 1
            builder.AppendFormat("{0} SELECT {1} ", "", GetTableRowValues(SourceTableData.Rows(i)))
            If i < SourceTableData.Rows.Count - 1 Then
                builder.AppendLine("UNION")
            End If
        Next
        If Not IgnoreIdentityColumn Then
            builder.AppendFormat("{0} SET IDENTITY_INSERT {1} {2} OFF", vbCrLf, GetTableOwner(), SourceTable.Name)
        End If
        Return builder.ToString
    End Function

#End Region
#Region "Private Methods"
    Private Function GetDataTable() As DataTable
        Using conn As New SqlClient.SqlConnection(SourceTable.TableConnectionString)
            Using cmd As New SqlClient.SqlCommand()
                cmd.Connection = conn
                cmd.CommandType = CommandType.Text
                Dim selectText As New StringBuilder(String.Format("Select * from {0}", SourceTable.Name))

                If FilterParameters IsNot Nothing AndAlso FilterParameters.Count > 0 Then
                    For Each param As SqlClient.SqlParameter In FilterParameters
                        cmd.Parameters.Add(param)
                    Next
                    selectText.AppendLine(" Where ")
                    For I As Integer = 0 To FilterParameters.Count - 1 Step I + 1
                        selectText.AppendFormat("{0} = @{1}", FilterParameters(I).ParameterName, FilterParameters(I).ParameterName)
                        If I < FilterParameters.Count - 1 Then
                            selectText.AppendLine("AND")
                        End If
                    Next
                    'There's an option to send a whole expression as a Where Clause (like: strParam_grp = 'Qloader')
                ElseIf Not String.IsNullOrEmpty(WhereClause) Then
                    selectText.AppendLine(" Where ")
                    selectText.AppendLine(WhereClause)
                End If

                cmd.CommandText = selectText.ToString
                cmd.Connection.Open()
                Dim adapter As New SqlClient.SqlDataAdapter(cmd)

                Dim table As New Data.DataTable(SourceTable.Name)
                adapter.Fill(table)
                Return table

            End Using
        End Using

    End Function
    Private Function IsIdentity(ByVal cs As DataColumn) As Boolean
        Return cs.ColumnName = Me.mSourceTable.IdentityColumnName
    End Function
    Private Function GetTableRowValues(ByVal row As System.Data.DataRow) As String
        Dim rowBuilder As New System.Text.StringBuilder

        Dim i As Integer
        For i = 0 To SourceTable.Columns.Count - 1 Step i + 1
            Dim column As DataColumn = SourceTable.Columns(i)
            If IsIdentity(column) AndAlso IgnoreIdentityColumn Then
                Continue For
            End If
            If IsNumericType(column) Then
                If row(i) Is DBNull.Value Then
                    rowBuilder.Append("NULL, ")
                Else
                    rowBuilder.Append(row(i).ToString())
                    rowBuilder.Append(", ")
                End If
            Else
                If row(i) Is DBNull.Value Then
                    rowBuilder.Append("NULL, ")
                ElseIf TypeOf row(i) Is DateTime Then
                    rowBuilder.Append("'")
                    rowBuilder.Append((CType(row(i), DateTime)).ToString("MM-dd-yyyy HH:mm:ss.fff"))
                    rowBuilder.Append("'")
                    rowBuilder.Append(", ")
                Else
                    rowBuilder.Append("'")
                    rowBuilder.Append(PrepareValue(row(i).ToString()))
                    rowBuilder.Append("'")
                    rowBuilder.Append(", ")
                End If
            End If
        Next

        Return rowBuilder.ToString().Substring(0, rowBuilder.ToString().Length - 2)
    End Function
    Private Shared Function PrepareValue(ByVal value As String) As String
        Return value.Replace("'", "''").Replace("\r\n", "' + CHAR(13) + CHAR(10) + '").Replace("\n", "' + CHAR(10) + '")
    End Function
    Private Shared Function IsNumericType(ByVal column As DataColumn) As Boolean
        Select Case column.DataType.ToString().ToLower()
            Case "bigint"
                '		case "bit":
            Case "decimal"
            Case "float"
            Case "int"
            Case "money"
            Case "numeric"
            Case "real"
            Case "real"
            Case "smallint"
            Case "smallmoney"
            Case "tinyint" : Return True
            Case Else : Return False
        End Select
    End Function
    Private Function GetTableOwner() As String
        Return GetTableOwner(True)
    End Function
    Private Function GetTableOwner(ByVal includeDot As Boolean) As String
        If SourceTable.Owner.Length > 0 Then
            Return "[" + SourceTable.Owner + "]."
        Else
            Return ""
        End If
    End Function
    Private Function GetSPStatements() As String
        If String.IsNullOrEmpty(StoredProcedureName) Then
            Return "Please enter the stored procedure name."
        End If
        'Do not try to touch the Identity column when generating SP statements
        Me.IgnoreIdentityColumn = True
        Dim builder As New StringBuilder()
        For i As Integer = 0 To SourceTableData.Rows.Count - 1 Step i + 1
            builder.AppendFormat(" Exec {0} {1} {2}", StoredProcedureName, GetTableRowValues(SourceTableData.Rows(i)), vbCrLf)
        Next
        Return builder.ToString
    End Function
#End Region
End Class