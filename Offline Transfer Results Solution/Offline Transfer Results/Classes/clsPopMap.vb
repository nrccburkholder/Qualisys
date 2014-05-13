Public Class clsPopMap

    Private mstrSourceField As String = ""
    Private mstrPopField As String = ""

    Public Sub New(ByVal strSourceField As String, ByVal strPopField As String)

        'Save the property values
        mstrSourceField = strSourceField
        mstrPopField = strPopField

    End Sub

    Public ReadOnly Property SourceField() As String
        Get
            Return mstrSourceField
        End Get
    End Property

    Public ReadOnly Property PopField() As String
        Get
            Return mstrPopField
        End Get
    End Property

End Class
