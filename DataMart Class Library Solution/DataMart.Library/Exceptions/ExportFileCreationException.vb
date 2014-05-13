Public Class ExportFileCreationException
    Inherits Exception

    Public Enum ExportExceptionCause
        Unknown = 0
        ZeroRecordsFound = 1
    End Enum

    Private mExceptionCause As ExportExceptionCause = ExportExceptionCause.Unknown

    Public ReadOnly Property ExceptionCause() As ExportExceptionCause
        Get
            Return mExceptionCause
        End Get
    End Property

    Public Sub New(ByVal message As String)
        MyBase.New(message)
        If message = "Export file creation failed: No records exported." Then
            mExceptionCause = ExportExceptionCause.ZeroRecordsFound
        End If
    End Sub

    Public Sub New(ByVal message As String, ByVal innerException As Exception)
        MyBase.New(message, innerException)
        If message = "Export file creation failed: No records exported." Then
            mExceptionCause = ExportExceptionCause.ZeroRecordsFound
        End If
    End Sub

    Public Sub New(ByVal info As System.Runtime.Serialization.SerializationInfo, ByVal context As System.Runtime.Serialization.StreamingContext)
        MyBase.New(info, context)
        If Message = "Export file creation failed: No records exported." Then
            mExceptionCause = ExportExceptionCause.ZeroRecordsFound
        End If
    End Sub

End Class
