<Serializable()> _
Public Class InvalidFileException
    Inherits Exception

#Region " Constructors "

    Private Sub New()

        MyBase.New()

    End Sub

    Private Sub New(ByVal message As String)

        MyBase.New(message)

    End Sub

    Private Sub New(ByVal message As String, ByVal innerException As Exception)

        MyBase.New(message, innerException)

    End Sub

    Public Sub New(ByVal message As String, ByVal fileName As String)

        MyBase.New(String.Format("{0} File Name: {1}.", message, fileName))

    End Sub

    Public Sub New(ByVal message As String, ByVal fileName As String, ByVal innerException As Exception)

        MyBase.New(String.Format("{0} File Name: {1}.", message, fileName), innerException)

    End Sub

    Protected Sub New(ByVal info As System.Runtime.Serialization.SerializationInfo, ByVal context As System.Runtime.Serialization.StreamingContext)

        MyBase.New(info, context)

    End Sub

#End Region

End Class
