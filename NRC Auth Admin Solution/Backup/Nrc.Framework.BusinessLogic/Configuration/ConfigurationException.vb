Namespace Configuration

    <Serializable()> _
    Public Class ConfigurationException
        Inherits Exception

        Public Sub New()

        End Sub

        Public Sub New(ByVal message As String)

            MyBase.New(message)

        End Sub

        Public Sub New(ByVal message As String, ByVal innerException As Exception)

            MyBase.New(message, innerException)

        End Sub

        Protected Sub New(ByVal info As System.Runtime.Serialization.SerializationInfo, _
                          ByVal context As System.Runtime.Serialization.StreamingContext)

            MyBase.New(info, context)

        End Sub

    End Class

End Namespace
