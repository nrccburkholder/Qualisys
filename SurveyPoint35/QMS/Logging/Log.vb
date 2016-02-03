Public Interface ILog
    ReadOnly Property ClassName() As String
    Sub WarnFormat(ByVal message As String)
    Sub [Error](ByVal methodName As String, ByVal ex As System.Exception)
End Interface
Public Class LogManager
    Public Shared Function GetLogger(ByVal className As String) As ILog
        Return New Log(className)
    End Function
End Class
Public Class Log
    Implements ILog

    Private mClassName As String = String.Empty

    Public Sub New(ByVal className As String)
        Me.mClassName = className
    End Sub
    Public ReadOnly Property ClassName() As String Implements ILog.ClassName
        Get
            Return Me.mClassName
        End Get
    End Property
    Public Sub WarnFormat(ByVal message As String) Implements ILog.WarnFormat

    End Sub
    Public Sub [Error](ByVal methodName As String, ByVal ex As System.Exception) Implements ILog.Error

    End Sub
End Class
