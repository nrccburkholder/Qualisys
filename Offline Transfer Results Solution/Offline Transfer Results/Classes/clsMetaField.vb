Public Class clsMetaField

    Private mstrFieldName As String = ""
    Private mintFieldLength As Integer
    Private mbolTruncate As Boolean = False

    Public Sub New(ByVal strFieldName As String, ByVal intFieldLength As Integer)

        'Save the values passed in
        mstrFieldName = strFieldName
        mintFieldLength = intFieldLength

    End Sub

    Public ReadOnly Property FieldName() As String
        Get
            Return mstrFieldName
        End Get
    End Property

    Public ReadOnly Property FieldLength() As Integer
        Get
            Return mintFieldLength
        End Get
    End Property

    Public Property Truncate() As Boolean
        Get
            Return mbolTruncate
        End Get
        Set(ByVal Value As Boolean)
            mbolTruncate = Value
        End Set
    End Property

End Class
