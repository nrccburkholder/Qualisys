Option Explicit On 
Option Strict On

Public Class ApbGroupListItem
    Private mGroupID As Integer
    Private mGroupName As String
    Private mReports As New ApbReportCollection

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

    Public Property Reports() As ApbReportCollection
        Get
            Return mReports
        End Get
        Set(ByVal Value As ApbReportCollection)
            mReports = Value
        End Set
    End Property

    Public Property DoPost() As Boolean
        Get
            Dim postCnt As Integer = 0
            Dim report As ApbReport

            For Each report In Me.Reports.Values
                If report.DoPost(Me.mGroupID) Then
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
            Dim report As ApbReport
            For Each report In Me.Reports.Values
                report.DoPost(Me.mGroupID) = Value
            Next
        End Set
    End Property

    Public Property DoRollback() As Boolean
        Get
            Dim postCnt As Integer = 0
            Dim report As ApbReport

            For Each report In Me.Reports.Values
                If report.DoRollback(Me.mGroupID) Then
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
            Dim report As ApbReport
            For Each report In Me.Reports.Values
                report.DoRollback(Me.mGroupID) = Value
            Next
        End Set
    End Property

End Class
