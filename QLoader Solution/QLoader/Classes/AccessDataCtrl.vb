Option Explicit On 
Option Strict On

Imports system.Data
Imports system.Data.OleDb
Imports Nrc.Qualisys.QLoader.Library

Public Class AccessDataCtrl

#Region " Private Members "

    Private mTableList As ArrayList
    Private mSelectedTable As String

#End Region

#Region " Public Properties "

    Public Property TableList() As ArrayList
        Get
            Return mTableList
        End Get
        Set(ByVal Value As ArrayList)
            mTableList = Value
        End Set
    End Property

    Public Property SelectedTable() As String
        Get
            Return mSelectedTable
        End Get
        Set(ByVal Value As String)
            mSelectedTable = Value
        End Set
    End Property

#End Region

#Region " Public Methods "

    Public Sub New(ByVal path As String)
        Dim conn As OleDb.OleDbConnection = Nothing

        Try
            'Get Access schema
            conn = (New DTSAccessData).GetConnection(path)
            conn.Open()
            Dim schemaTable As DataTable = _
                    conn.GetOleDbSchemaTable( _
                            OleDbSchemaGuid.Tables, _
                            New Object() {Nothing, Nothing, Nothing, "TABLE"} _
                        )

            Dim i As Integer
            Dim tables As New ArrayList
            Dim tableName As String

            'Add table names to table list
            For i = 0 To schemaTable.Rows.Count - 1
                tableName = schemaTable.Rows(i).ItemArray(2).ToString()
                tables.Add(New ListItem(tableName))
            Next
            Me.TableList = tables

            'If init selected table name to the first table name
            Me.SelectedTable = CType(Me.TableList.Item(0), ListItem).Text

        Catch ex As Exception
            Throw New ArgumentException(ex.Message)
        Finally
            If (Not conn Is Nothing) Then conn.Close()
        End Try
    End Sub

#End Region

End Class
