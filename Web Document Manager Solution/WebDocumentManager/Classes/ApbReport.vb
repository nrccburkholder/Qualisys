Option Explicit On 
Option Strict On

Public Class ApbReport
    Private mJobID As Integer
    Private mApID As String
    Private mDocumentID As Integer = 0
    Private mDateRangeBegin As Date
    Private mDateRangeEnd As Date
    Private mDocumentName As String
    Private mFilePath As String
    Private mUrl As String
    Private mGroups As New ApbGroupCollection

    Public Property JobID() As Integer
        Get
            Return mJobID
        End Get
        Set(ByVal Value As Integer)
            mJobID = Value
        End Set
    End Property

    Public Property ApID() As String
        Get
            Return mApID
        End Get
        Set(ByVal Value As String)
            mApID = Value
        End Set
    End Property

    Public Property DocumentID() As Integer
        Get
            Return mDocumentID
        End Get
        Set(ByVal Value As Integer)
            mDocumentID = Value
        End Set
    End Property

    Public Property DateRangeBegin() As Date
        Get
            Return mDateRangeBegin
        End Get
        Set(ByVal Value As Date)
            mDateRangeBegin = Value
        End Set
    End Property

    Public Property DateRangeEnd() As Date
        Get
            Return mDateRangeEnd
        End Get
        Set(ByVal Value As Date)
            mDateRangeEnd = Value
        End Set
    End Property

    Public Property DocumentName() As String
        Get
            Return mDocumentName
        End Get
        Set(ByVal Value As String)
            mDocumentName = Value
        End Set
    End Property

    Public Property FilePath() As String
        Get
            Return mFilePath
        End Get
        Set(ByVal Value As String)
            mFilePath = Value
        End Set
    End Property

    Public Property Url() As String
        Get
            Return mUrl
        End Get
        Set(ByVal Value As String)
            mUrl = Value
        End Set
    End Property

    Public Property Groups() As ApbGroupCollection
        Get
            Return mGroups
        End Get
        Set(ByVal Value As ApbGroupCollection)
            mGroups = Value
        End Set
    End Property

    Public ReadOnly Property DatePosted(ByVal groupID As Integer) As Date
        Get
            Dim group As ApbGroup = mGroups(groupID)
            If (group Is Nothing) Then Return Nothing
            Return (group.DatePosted)
        End Get
    End Property

    Public Property DoPost() As Boolean
        Get
            Dim postCnt As Integer = 0
            Dim group As ApbGroup

            For Each group In Me.Groups.Values
                If group.DoPost Then
                    postCnt += 1
                End If
            Next
            If (postCnt = 0) Then
                Return False
            Else
                Return True
            End If
        End Get
        Set(ByVal Value As Boolean)
            Dim group As ApbGroup
            For Each group In Me.Groups.Values
                group.DoPost = Value
            Next
        End Set
    End Property

    Public Property DoPost(ByVal groupID As Integer) As Boolean
        Get
            Dim group As ApbGroup = mGroups(groupID)
            If (group Is Nothing) Then Return False
            Return (group.DoPost)
        End Get
        Set(ByVal Value As Boolean)
            Dim group As ApbGroup = mGroups(groupID)
            If (group Is Nothing) Then Return
            group.DoPost = Value
        End Set
    End Property

    Public Property DoRollback() As Boolean
        Get
            Dim rollbackCnt As Integer = 0
            Dim group As ApbGroup

            For Each group In Me.Groups.Values
                If group.DoRollback Then
                    rollbackCnt += 1
                End If
            Next
            If (rollbackCnt = 0) Then
                Return False
            Else
                Return True
            End If
        End Get
        Set(ByVal Value As Boolean)
            Dim group As ApbGroup
            For Each group In Me.Groups.Values
                group.DoRollback = Value
            Next
        End Set
    End Property

    Public Property DoRollback(ByVal groupID As Integer) As Boolean
        Get
            Dim group As ApbGroup = mGroups(groupID)
            If (group Is Nothing) Then Return False
            Return (group.DoRollback)
        End Get
        Set(ByVal Value As Boolean)
            Dim group As ApbGroup = mGroups(groupID)
            If (group Is Nothing) Then Return
            group.DoRollback = Value
        End Set
    End Property

End Class
