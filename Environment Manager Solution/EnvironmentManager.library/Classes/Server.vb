Imports System.Data.SqlClient

Public Class ServerProperty
    Private _ServerName As String
    Private _InstanceName As String
    Private _IsClustered As String
    Private _Version As String
    Public Property InstanceName() As String
        Get
            Return _InstanceName
        End Get
        Set(ByVal value As String)
            _InstanceName = value
        End Set
    End Property
    Public Property IsClustered() As String
        Get
            Return _IsClustered
        End Get
        Set(ByVal value As String)
            _IsClustered = value
        End Set
    End Property
    Public Property ServerName() As String
        Get
            Return _ServerName
        End Get
        Set(ByVal value As String)
            _ServerName = value
        End Set
    End Property
    Public Property Version() As String
        Get
            Return _Version
        End Get
        Set(ByVal value As String)
            _Version = value
        End Set
    End Property
    Public ReadOnly Property Fullname() As String
        Get
            Return String.Format("{0}{1}{2}", ServerName, Separator, InstanceName)
        End Get
    End Property
    Private ReadOnly Property Separator() As String
        Get
            If Not String.IsNullOrEmpty(InstanceName) Then
                Return "\"
            End If
            Return String.Empty
        End Get
    End Property
    Public Sub New()
    End Sub
    Public Sub New(ByVal pName As String)
        ServerName = pName
    End Sub
    Public Shared Function GetServerList(ByVal pServersDataTable As DataTable) As ListOfServers
        Dim ServerList As New ListOfServers
        For Each row As DataRow In pServersDataTable.Rows
            Dim server As New ServerProperty
            server.ServerName = row("ServerName").ToString
            server.IsClustered = row("IsClustered").ToString
            server.InstanceName = row("InstanceName").ToString
            server.Version = row("Version").ToString
            ServerList.Add(server)
        Next
        Return ServerList
    End Function
    'Private Function GetString()
End Class
