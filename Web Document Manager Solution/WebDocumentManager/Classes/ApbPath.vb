Option Explicit On 
Option Strict On

Public Class ApbPath
    Private mGroupID As Integer
    Private mFullPath As String
    Private mReports As New ApbReportListCollection

    Public Property GroupID() As Integer
        Get
            Return mGroupID
        End Get
        Set(ByVal Value As Integer)
            mGroupID = Value
        End Set
    End Property

    Public Property FullPath() As String
        Get
            'Return mFullPath
            Return mFullPath
        End Get
        Set(ByVal Value As String)
            mFullPath = Value
        End Set
    End Property

    Public Property Reports() As ApbReportListCollection
        Get
            Return mReports
        End Get
        Set(ByVal Value As ApbReportListCollection)
            mReports = Value
        End Set
    End Property

    Public Sub New(ByVal groupID As Integer, ByVal fullPath As String)
        mGroupID = groupID
        mFullPath = fullPath
    End Sub

End Class
