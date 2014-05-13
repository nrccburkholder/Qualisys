Option Explicit On 
Option Strict On

Imports System.Collections.Specialized

Public Class ApbGroup
    Private mGroupID As Integer
    Private mGroupName As String
    Private mTreeGroupID As Integer
    Private mDatePosted As Date
    Private mDoPost As Boolean = True
    Private mDoRollback As Boolean = False
    Private mDocCopies As New ApbDocCopyCollection

    Public Property GroupID() As Integer
        Get
            Return mGroupID
        End Get
        Set(ByVal Value As Integer)
            mGroupID = Value
        End Set
    End Property

    Public Property GroupName() As String
        Get
            Return mGroupName
        End Get
        Set(ByVal Value As String)
            mGroupName = Value
        End Set
    End Property

    Public Property TreeGroupID() As Integer
        Get
            Return mTreeGroupID
        End Get
        Set(ByVal Value As Integer)
            mTreeGroupID = Value
        End Set
    End Property

    Public Property DoPost() As Boolean
        Get
            Return mDoPost
        End Get
        Set(ByVal Value As Boolean)
            mDoPost = Value
        End Set
    End Property

    Public Property DoRollback() As Boolean
        Get
            Return mDoRollback
        End Get
        Set(ByVal Value As Boolean)
            mDoRollback = Value
        End Set
    End Property

    Public Property DatePosted() As Date
        Get
            Return mDatePosted
        End Get
        Set(ByVal Value As Date)
            mDatePosted = Value
        End Set
    End Property

    Public Property DocCopies() As ApbDocCopyCollection
        Get
            Return mDocCopies
        End Get
        Set(ByVal Value As ApbDocCopyCollection)
            mDocCopies = Value
        End Set
    End Property

    Public Sub New(ByVal groupID As Integer, ByVal groupName As String)
        mGroupID = groupID
        mGroupName = groupName
    End Sub

    Public Sub New(ByVal groupID As Integer, ByVal groupName As String, ByVal treeGroupID As Integer)
        mGroupID = groupID
        mGroupName = groupName
        mTreeGroupID = treeGroupID
    End Sub

End Class
