Public Class UpdateProgressEventArgs
    Inherits EventArgs

    Private mFileName As String
    Private mFileCounter As Integer
    Private mPercentComplete As Integer

    Public ReadOnly Property FileName() As String
        Get
            Return mFileName
        End Get
    End Property

    Public ReadOnly Property FileCounter() As Integer
        Get
            Return mFileCounter
        End Get
    End Property

    Public ReadOnly Property PercentComplete() As Integer
        Get
            Return mPercentComplete
        End Get
    End Property

    Public Sub New(ByVal fileName As String, ByVal fileCounter As Integer, ByVal percentComplete As Integer)

        mFileName = fileName
        mFileCounter = fileCounter
        mPercentComplete = percentComplete

    End Sub

End Class
