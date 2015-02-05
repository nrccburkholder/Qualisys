Namespace DataProvider

    Public MustInherit Class CriteriaProvider

#Region " Singleton Implementation "
        Private Shared mInstance As CriteriaProvider
        Private Const mProviderName As String = "CriteriaProvider"

        Public Shared ReadOnly Property Instance() As CriteriaProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of CriteriaProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region
        Protected Sub New()

        End Sub
        Public MustOverride Function SelectCriteria(ByVal criteriaStatementId As Integer) As Criteria
        Public MustOverride Function SelectCriteriaClauseByStatementAndPhraseId(ByVal criteriaStatementId As Integer, ByVal criteriaPhraseId As Integer) As Collection(Of CriteriaClause)
        Public MustOverride Function SelectCriteriaPhraseByCriteriaStatementId(ByVal criteriaStatementId As Integer) As Collection(Of CriteriaPhrase)
        Public MustOverride Function SelectCriteriaInListByCriteriaClause(ByVal criteriaClauseId As Integer) As Collection(Of CriteriaInValue)

        Protected NotInheritable Class ReadOnlyAccessor
            Private Sub New()
            End Sub

            Public Shared WriteOnly Property CriteriaId(ByVal obj As Criteria) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.Id = value
                    End If
                End Set
            End Property

            Public Shared WriteOnly Property CriteriaClauseId(ByVal obj As CriteriaClause) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.Id = value
                    End If
                End Set
            End Property

            Public Shared WriteOnly Property CriteriaInValueId(ByVal obj As CriteriaInValue) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.Id = value
                    End If
                End Set
            End Property

        End Class

    End Class
End Namespace
