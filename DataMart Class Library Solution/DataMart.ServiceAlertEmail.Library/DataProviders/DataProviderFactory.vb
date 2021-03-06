Friend NotInheritable Class DataProviderFactory

    Private Sub New()

    End Sub

    Public Shared Function CreateInstance(Of T)(ByVal providerName As String) As T

        Dim instance As T

        Dim providerAssemblyName As String = "NRC.DataMart.ServiceAlertEmail.Library.SQLProvider"
        Dim providerTypeName As String = String.Format("{0}.{1}", providerAssemblyName, providerName)
        Dim providerType As Type = Type.GetType(String.Format("{0}, {1}", providerTypeName, providerAssemblyName), True)

        Try
            instance = CType(Activator.CreateInstance(providerType), T)
            Return instance

        Catch ex As System.Reflection.TargetInvocationException
            Throw ex.InnerException

        End Try

    End Function

End Class
