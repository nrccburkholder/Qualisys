Public Class ListBoxItem
    Private mValue As Integer
    Private mText As String

    Public Property Value() As Integer
        Get
            Return mValue
        End Get
        Set(ByVal Value As Integer)
            mValue = Value
        End Set
    End Property

    Public Property Text() As String
        Get
            Return mText
        End Get
        Set(ByVal Value As String)
            mText = Value
        End Set
    End Property

    Public Sub New(ByVal value As Integer, ByVal text As String)
        mValue = value
        mText = text
    End Sub

    Public Overrides Function ToString() As String
        Return mText
    End Function
End Class
