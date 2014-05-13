Option Explicit On 
Option Strict On

Public Class XmlDataCtrl

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
        Try
            Dim ds As New DataSet
            Dim dt As DataTable
            Dim tables As New ArrayList
            Dim tableName As String = ""

            'Load XML schema
            ds.ReadXmlSchema(path)

            'Add table names to table list
            For Each dt In ds.Tables
                tableName = dt.TableName
                tables.Add(New ListItem(tableName))
            Next
            Me.TableList = tables

            'If only one table in Access, save this table name as selected
            If (tables.Count = 1) Then
                Me.SelectedTable = tableName
            End If

        Catch ex As Exception
            Throw New ArgumentException(ex.Message)
        End Try

    End Sub

#End Region

End Class
