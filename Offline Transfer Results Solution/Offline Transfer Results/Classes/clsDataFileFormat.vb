Public Class clsDataFileFormat

    Public Enum enuDataFileFormatConstants
        enuDFCDBF = 0
    End Enum

    Private menuFormatID As enuDataFileFormatConstants
    Private mstrFormatName As String = ""

    Public Sub New(ByVal enuFormatID As enuDataFileFormatConstants, ByVal strFormatName As String)

        MyBase.New()

        menuFormatID = enuFormatID
        mstrFormatName = strFormatName

    End Sub

    Public ReadOnly Property FormatID() As enuDataFileFormatConstants
        Get
            Return menuFormatID
        End Get
    End Property

    Public ReadOnly Property FormatName() As String
        Get
            Return mstrFormatName
        End Get
    End Property

    Public Overrides Function ToString() As String

        Return Me.FormatName & " (" & Me.FormatID.ToString & ")"

    End Function

End Class
