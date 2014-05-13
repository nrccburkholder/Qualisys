Public Class Groupings
#Region " Private Members"

    Private mgroupingName As String
    Private mgroupingID As Integer

#End Region

#Region " Public Properties"
    Public Property GroupingName() As String
        Get
            Return mgroupingName
        End Get
        Set(ByVal Value As String)
            mgroupingName = Value
        End Set
    End Property

    Public Property GroupingID() As Integer
        Get
            Return mgroupingID
        End Get
        Set(ByVal Value As Integer)
            mgroupingID = Value
        End Set
    End Property

    Public Overrides Function ToString() As String
        Return mgroupingName
    End Function
#End Region

End Class
