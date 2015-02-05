Namespace DataProvider

    Public MustInherit Class QualisysParamsProvider

#Region " Singleton Implementation "
        Private Shared mInstance As QualisysParamsProvider
        Private Const mProviderName As String = "QualisysParamsProvider"

        Public Shared ReadOnly Property Instance() As QualisysParamsProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of QualisysParamsProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region
        Protected Sub New()

        End Sub
        Public MustOverride Function [Select](ByVal paramName As String) As QualisysParam


        Protected NotInheritable Class ReadOnlyAccessor
            Private Sub New()
            End Sub

            Public Shared WriteOnly Property QualisysParamId(ByVal obj As QualisysParam) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.Id = value
                    End If
                End Set
            End Property

        End Class
    End Class

End Namespace
