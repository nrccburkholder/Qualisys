Namespace Types
    ''' <summary>
    ''' Simple Type to show a display value for foriegn keys.
    ''' </summary>
    ''' <remarks></remarks>
    Public Class KeyValue
#Region " Private Variables "
        Private mKey As Integer = -1
        Private mValue As String = String.Empty
#End Region
#Region " Constructors "
        Public Sub New(ByVal key As Integer, ByVal value As String)
            Me.mKey = key
            Me.mValue = value
        End Sub
        Public Sub New()

        End Sub
#End Region
#Region " Public Properties "
        Public Property Key() As Integer
            Get
                Return Me.mKey
            End Get
            Set(ByVal value As Integer)
                Me.mKey = value
            End Set
        End Property
        Public Property Value() As String
            Get
                Return Me.mValue
            End Get
            Set(ByVal value As String)
                Me.mValue = value
            End Set
        End Property
#End Region
#Region " Overrides "
        Public Overrides Function ToString() As String
            Return "Key: " & mKey & " Value: " & Me.mValue
        End Function
        Public Overrides Function Equals(ByVal obj As Object) As Boolean
            Dim other As Types.KeyValue = DirectCast(obj, Types.KeyValue)
            If Me.Key = other.Key AndAlso Me.Value = other.Value Then
                Return True
            Else
                Return False
            End If
        End Function
#End Region
    End Class
End Namespace
