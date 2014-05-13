<Serializable()> _
Public Class InvalidFileException
    Inherits Exception

#Region " Private Members "

    Private mFileName As String = String.Empty
    Private mErrorList As List(Of TranslatorError)

#End Region

#Region " Public Properties "

    Public ReadOnly Property FileName() As String
        Get
            Return mFileName
        End Get
    End Property

    Public ReadOnly Property ErrorList() As List(Of TranslatorError)
        Get
            If mErrorList Is Nothing Then
                mErrorList = New List(Of TranslatorError)
            End If
            Return mErrorList
        End Get
    End Property

#End Region

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

        MyBase.New(message)
        mFileName = fileName

    End Sub

    Public Sub New(ByVal message As String, ByVal fileName As String, ByVal innerException As Exception)

        MyBase.New(message, innerException)
        mFileName = fileName

    End Sub

    Public Sub New(ByVal message As String, ByVal fileName As String, ByVal errorList As List(Of TranslatorError))

        MyBase.New(message)
        mFileName = fileName
        mErrorList = errorList

    End Sub

    Protected Sub New(ByVal info As System.Runtime.Serialization.SerializationInfo, ByVal context As System.Runtime.Serialization.StreamingContext)

        MyBase.New(info, context)

    End Sub

#End Region

End Class
