Imports Nrc.DataMart.Library

Public Class FileTypeItem

    Private mFileType As ExportFileType
    Private mFileExtension As String
    Private mLabel As String


    Public ReadOnly Property ExportFileType() As ExportFileType
        Get
            Return mFileType
        End Get
    End Property


    Public ReadOnly Property Label() As String
        Get
            Return mLabel
        End Get
    End Property


    Public ReadOnly Property Extension() As String
        Get
            Return mFileExtension
        End Get
    End Property


    Sub New(ByVal fileType As ExportFileType, ByVal label As String, ByVal extension As String)
        mFileType = fileType
        mLabel = label
        mFileExtension = extension
    End Sub


    Public Overrides Function ToString() As String
        Return mLabel
    End Function

End Class
