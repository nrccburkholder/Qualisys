Option Explicit On 
Option Strict On

'This is just a string that represents one line of text in the TextColumnBreaker control
'It is used to provide design-time support for the control (even though we really won't ever need it)
<Serializable()> _
Public Class FixedTextColumnBreakerLine
    Private _Text As String = ""
    Private _Length As Integer

#Region " Public Properties "
    Public Property Text() As String
        Get
            Return Me._Text
        End Get
        Set(ByVal Value As String)
            Me._Text = Value
        End Set
    End Property
    Public ReadOnly Property Length() As Integer
        Get
            Return Me._Text.Length
        End Get
    End Property
#End Region

    Public Sub New()
    End Sub
    Public Sub New(ByVal strText As String)
        Me._Text = strText
    End Sub

End Class

'Collection of Lines
<Serializable()> _
Public Class FixedTextColumnBreakerLineCollection
    Inherits CollectionBase

    Default Public Property Item(ByVal index As Integer) As FixedTextColumnBreakerLine
        Get
            Return CType(MyBase.List(index), FixedTextColumnBreakerLine)
        End Get
        Set(ByVal Value As FixedTextColumnBreakerLine)
            MyBase.List(index) = Value
        End Set
    End Property

    Public Sub Add(ByVal line As FixedTextColumnBreakerLine)
        MyBase.List.Add(line)
    End Sub

    Public Sub New()

    End Sub

    Public Function GetMaxLength() As Integer
        Dim ln As FixedTextColumnBreakerLine
        Dim max As Integer = 0
        For Each ln In Me
            If ln.Length > max Then max = ln.Length
        Next

        Return max
    End Function

End Class

