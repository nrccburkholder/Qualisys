Namespace DataProvider
    Public MustInherit Class ClientGroupProvider

#Region " Singleton Implementation "

        Private Shared mInstance As ClientGroupProvider
        Private Const mProviderName As String = "ClientGroupProvider"

        Public Shared ReadOnly Property Instance() As ClientGroupProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of ClientGroupProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property

#End Region

#Region " Constructors "

        Protected Sub New()

        End Sub

#End Region

#Region " MustOverride Methods "

        Public MustOverride Function [Select](ByVal clientGroupID As Integer) As ClientGroup
        Public MustOverride Function SelectAllClientGroups() As Collection(Of ClientGroup)
        Public MustOverride Function SelectClientGroupsAndClientsByUser(ByVal userName As String, ByVal showAllClients As Boolean) As Collection(Of ClientGroup)
        Public MustOverride Function SelectClientGroupsClientsAndStudiesByUser(ByVal userName As String, ByVal showAllClients As Boolean) As Collection(Of ClientGroup)
        Public MustOverride Function SelectClientGroupsClientsStudiesAndSurveysByUser(ByVal userName As String, ByVal showAllClients As Boolean) As Collection(Of ClientGroup)
        Public MustOverride Function Insert(ByVal name As String, ByVal reportName As String, ByVal isActive As Boolean) As Integer
        Public MustOverride Sub Delete(ByVal clientGroupID As Integer)
        Public MustOverride Function AllowDelete(ByVal clientGroupID As Integer) As Boolean
        Public MustOverride Sub Update(ByVal clntGroup As ClientGroup)

#End Region

#Region " Public Methods "

        Public Function SelectClientGroupsAndClientsByUser(ByVal userName As String) As Collection(Of ClientGroup)

            Return SelectClientGroupsAndClientsByUser(userName, False)

        End Function

        Public Function SelectClientGroupsClientsAndStudiesByUser(ByVal userName As String) As Collection(Of ClientGroup)

            Return SelectClientGroupsClientsAndStudiesByUser(userName, False)

        End Function

        Public Function SelectClientGroupsClientsStudiesAndSurveysByUser(ByVal userName As String) As Collection(Of ClientGroup)

            Return SelectClientGroupsClientsStudiesAndSurveysByUser(userName, False)

        End Function

#End Region

#Region " ReadOnly Accessor "

        Protected NotInheritable Class ReadOnlyAccessor

            Private Sub New()
            End Sub

            Public Shared WriteOnly Property ClientGroupID(ByVal obj As ClientGroup) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.Id = value
                    End If
                End Set
            End Property

        End Class

#End Region

    End Class
End Namespace
