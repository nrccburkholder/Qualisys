Option Explicit On 
Option Strict On

Public Class ListItem
    Private mValue As Object
    Private mText As String

    Public Sub New(ByVal value As Object, ByVal text As String)
        mValue = value
        mText = text
    End Sub

    Public Sub New(ByVal text As String)
        mValue = text
        mText = text
    End Sub

    Public ReadOnly Property Value() As Object
        Get
            Return mValue
        End Get
    End Property

    Public ReadOnly Property Text() As String
        Get
            Return mText
        End Get
    End Property

    Public Overrides Function ToString() As String
        Return mText
    End Function

End Class
