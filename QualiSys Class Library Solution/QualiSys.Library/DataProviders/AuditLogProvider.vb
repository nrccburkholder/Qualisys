Namespace DataProvider
    Public MustInherit Class AuditLogProvider


#Region " Singleton Implementation "
        Private Shared mInstance As AuditLogProvider
        Private Const mProviderName As String = "AuditLogProvider"

        Public Shared ReadOnly Property Instance() As AuditLogProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of AuditLogProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Sub InsertAuditLogChange(ByVal userName As String, ByVal objectId As Integer, ByVal objectType As AuditLogObject, ByVal propertyName As String, ByVal changeType As AuditLogChangeType, ByVal initialValue As String, ByVal finalValue As String)

    End Class
End Namespace
