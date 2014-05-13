Option Explicit On 
Option Strict On

'ColumnBreak Class
'This class is used to store info about a column break
'It is implemented as a dictionary to make search efficient
Public Class FixedTextColumnBreak

    Dim _xPosition As Single
    Dim _yPosition As Single
    Dim _height As Integer = 50
    Dim _length As Single

#Region " Public Properites "
    Public Property X() As Single
        Get
            Return Me._xPosition
        End Get
        Set(ByVal Value As Single)
            Me._xPosition = Value
        End Set
    End Property
    Public Property Y() As Single
        Get
            Return Me._yPosition
        End Get
        Set(ByVal Value As Single)
            Me._yPosition = Value
        End Set
    End Property
    Public Property Height() As Integer
        Get
            Return Me._height
        End Get
        Set(ByVal Value As Integer)
            Me._height = Value
        End Set
    End Property

    Public Property Length() As Single
        Get
            Return (_length)
        End Get
        Set(ByVal Value As Single)
            _length = Value
        End Set
    End Property
#End Region

    Public Sub New(ByVal x As Single, ByVal y As Single, ByVal height As Integer)
        Me._xPosition = x
        Me._yPosition = y
        Me._height = height
    End Sub

End Class

'Collection of ColumnBreaks
Public Class FixedTextColumnBreakCollection
    Inherits DictionaryBase

    Default Public Property Item(ByVal key As Single) As FixedTextColumnBreak
        Get
            Return CType(Me.Dictionary.Item(key), FixedTextColumnBreak)
        End Get
        Set(ByVal Value As FixedTextColumnBreak)
            Me.Dictionary.Item(key) = Value
        End Set
    End Property

    Public Sub Add(ByVal break As FixedTextColumnBreak)
        Me.Dictionary.Add(break.X, break)
        SetLengths()
    End Sub

    Public Sub Remove(ByVal key As Single)
        Me.Dictionary.Remove(key)
        SetLengths()
    End Sub

    Public Function Contains(ByVal key As Single) As Boolean
        Return Me.Dictionary.Contains(key)
    End Function

    Public ReadOnly Property Values() As ICollection
        Get
            Return Dictionary.Values
        End Get
    End Property


    Private Sub SetLengths()
        Dim break As FixedTextColumnBreak
        For Each break In Me.Dictionary.Values
            SetBreakLength(break)
        Next
    End Sub

    Private Sub SetBreakLength(ByVal break As FixedTextColumnBreak)
        Dim prevX As Single = 0
        Dim prevBreak As FixedTextColumnBreak
        For Each prevBreak In Me.Dictionary.Values
            If (prevBreak.X < break.X AndAlso prevBreak.X > prevX) Then
                prevX = prevBreak.X
            End If
        Next
        break.Length = break.X - prevX
    End Sub
End Class
