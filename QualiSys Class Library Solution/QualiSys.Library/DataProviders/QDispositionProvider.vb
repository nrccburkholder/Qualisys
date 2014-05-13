Namespace DataProvider

    Public MustInherit Class QDispositionProvider

#Region " Singleton Implementation "
        Private Shared mInstance As QDispositionProvider
        Private Const mProviderName As String = "QDispositionProvider"
        Public Shared ReadOnly Property Instance() As QDispositionProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of QDispositionProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region
        Protected Sub New()

        End Sub

        Public MustOverride Function [Select](ByVal dispositionId As Integer) As QDisposition
        Public MustOverride Function SelectBySurveyId(ByVal surveyId As Integer) As QDispositionCollection

        Protected NotInheritable Class ReadOnlyAccessor
            Private Sub New()
            End Sub

            Public Shared WriteOnly Property DispositionId(ByVal obj As QDisposition) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.Id = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property DispositionName(ByVal obj As QDisposition) As String
                Set(ByVal value As String)
                    If obj IsNot Nothing Then
                        obj.Name = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property DispositionAction(ByVal obj As QDisposition) As DispositionAction
                Set(ByVal value As DispositionAction)
                    If obj IsNot Nothing Then
                        obj.Action = value
                    End If
                End Set
            End Property

        End Class

    End Class

End Namespace
