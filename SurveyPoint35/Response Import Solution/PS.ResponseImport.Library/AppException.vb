<Serializable()> _
Public Class AppException
    Inherits ApplicationException

    Private msg As String = String.Empty

    Public Sub New()

    End Sub
    Public Sub New(ByVal msg As String)
        Me.msg = msg
    End Sub
    Public Sub New(ByVal msgs As List(Of String))
        For Each item As String In msgs
            Me.msg += item & vbCrLf
        Next
    End Sub
End Class
