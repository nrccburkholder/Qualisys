Imports System.Text

Public Class TableSchema
    Dim mTableConnectionString As String
    Dim mName As String
    Dim mDatabase As String
    Dim mIdentityColumnName As String
    Public Property IdentityColumnName() As String
        Get
            If String.IsNullOrEmpty(mIdentityColumnName) Then
                mIdentityColumnName = GetIdentityColumnName()
            End If
            Return mIdentityColumnName
        End Get
        Set(ByVal value As String)
            mIdentityColumnName = value
        End Set
    End Property
    Public Property TableConnectionString() As String
        Get
            Return mTableConnectionString
        End Get
        Set(ByVal value As String)
            mTableConnectionString = value
        End Set
    End Property

    Public Property Database() As String
        Get
            Return mDatabase
        End Get
        Set(ByVal value As String)
            mDatabase = value
        End Set
    End Property
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            mName = value
        End Set
    End Property
    Public Sub New(ByVal pConnectionString As String, ByVal tableName As String)
        Me.TableConnectionString = pConnectionString
        Using Connection As New SqlClient.SqlConnection(pConnectionString)
            Database = Connection.Database
        End Using
        Name = tableName
        Owner = GetOwnerName()
    End Sub
    Private Function GetSchema() As DataTable
        Using Connection As New SqlClient.SqlConnection(Me.TableConnectionString)
            Connection.Open()
            Dim restrictions(3) As String
            restrictions(0) = Connection.Database
            restrictions(2) = Name
            restrictions(3) = "BASE TABLE"
            Return Connection.GetSchema("Tables", restrictions)
        End Using
    End Function
    Private Function GetOwnerName()
        Dim schema As DataTable = GetSchema()
        Return schema.Rows(0)("TABLE_SCHEMA")
    End Function
    Private mOwner As String
    Public Property Owner() As String
        Get
            Return mOwner
        End Get
        Set(ByVal value As String)
            mOwner = value
        End Set
    End Property
    Private mTableData As DataTable
    Public Property TableData() As DataTable
        Get
            If mTableData Is Nothing Then
                mTableData = GetTableData()
            End If
            Return mTableData

        End Get
        Set(ByVal value As DataTable)
            mTableData = value
        End Set
    End Property
    Private Function GetTableData() As DataTable
        Using connection As New SqlClient.SqlConnection(Me.TableConnectionString)
            Using cmd As New SqlClient.SqlCommand(String.Format("Select * from {0}", Name), connection)
                connection.Open()
                Dim adapter As New SqlClient.SqlDataAdapter(cmd)
                Dim table As New Data.DataTable(Name)
                adapter.Fill(table)
                Return table
            End Using
        End Using
    End Function
    Public ReadOnly Property Columns() As DataColumnCollection
        Get
            If TableData Is Nothing Then
                Return Nothing
            End If
            Return TableData.Columns
        End Get
    End Property
    Private Function GetIdentityColumnName() As String
        Dim cmdText As String = String.Format("SELECT name FROM syscolumns WHERE OBJECT_NAME(id) = '{0}' AND COLUMNPROPERTY(id, name, 'IsIdentity') = 1", Name)
        Using connection As New SqlClient.SqlConnection(Me.TableConnectionString)
            Using cmd As New SqlClient.SqlCommand(cmdText)
                cmd.CommandTimeout = 1200
                cmd.Connection = connection
                cmd.Connection.Open()
                Dim obj As Object = cmd.ExecuteScalar()
                If obj Is DBNull.Value Then
                    Return String.Empty
                Else
                    Return obj.ToString
                End If
            End Using
        End Using
    End Function

End Class