Namespace DataProvider

    Public MustInherit Class BusinessRuleProvider

#Region " Singleton Implementation "
        Private Shared mInstance As BusinessRuleProvider
        Private Const mProviderName As String = "BusinessRuleProvider"

        Public Shared ReadOnly Property Instance() As BusinessRuleProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of BusinessRuleProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region
        Protected Sub New()

        End Sub
        Public MustOverride Function SelectBusinessRule(ByVal businessRuleId As Integer, ByVal survey As Survey) As BusinessRule
        Public MustOverride Function SelectBusinessRulesBySurvey(ByVal survey As Survey) As Collection(Of BusinessRule)

        Protected NotInheritable Class ReadOnlyAccessor
            Private Sub New()
            End Sub

            Public Shared WriteOnly Property BusinessRuleId(ByVal obj As BusinessRule) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.Id = value
                    End If
                End Set
            End Property
        End Class
    End Class
End Namespace
