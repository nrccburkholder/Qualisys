<AttributeUsage(AttributeTargets.Property Or AttributeTargets.Field, AllowMultiple:=False, Inherited:=True)> _
Public NotInheritable Class LogableAttribute
    Inherits Attribute

    Private mPropertyName As String = ""

    Public ReadOnly Property PropertyName() As String
        Get
            Return mPropertyName
        End Get
    End Property

    Public Sub New()
    End Sub

    Public Sub New(ByVal propertyName As String)
        mPropertyName = propertyName
    End Sub
End Class
