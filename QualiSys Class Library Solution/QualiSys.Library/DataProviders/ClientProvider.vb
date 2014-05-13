Namespace DataProvider
    Public MustInherit Class ClientProvider

#Region " Singleton Implementation "

        Private Shared mInstance As ClientProvider
        Private Const mProviderName As String = "ClientProvider"

        Public Shared ReadOnly Property Instance() As ClientProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of ClientProvider)(mProviderName)
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

        Public MustOverride Function [Select](ByVal clientId As Integer) As Client
        Public MustOverride Function SelectClientsAndStudiesByUser(ByVal userName As String, ByVal showAllClients As Boolean) As Collection(Of Client)
        Public MustOverride Function SelectClientsStudiesAndSurveysByUser(ByVal userName As String, ByVal showAllClients As Boolean) As Collection(Of Client)
        Public MustOverride Function SelectClientsByClientGroupID(ByVal clientGroup As ClientGroup) As Collection(Of Client)
        Public MustOverride Function Insert(ByVal clientName As String, ByVal isActive As Boolean, ByVal clientGroupID As Integer) As Integer
        Public MustOverride Sub Delete(ByVal clientId As Integer)
        Public MustOverride Function AllowDelete(ByVal clientId As Integer) As Boolean
        Public MustOverride Sub Update(ByVal clnt As Client)

#End Region

#Region " Public Methods "

        Public Function SelectClientsAndStudiesByUser(ByVal userName As String) As Collection(Of Client)

            Return SelectClientsAndStudiesByUser(userName, False)

        End Function

        Public Function SelectClientsStudiesAndSurveysByUser(ByVal userName As String) As Collection(Of Client)

            Return SelectClientsStudiesAndSurveysByUser(userName, False)

        End Function

#End Region

#Region " ReadOnly Accessor "

        Protected NotInheritable Class ReadOnlyAccessor
            Private Sub New()
            End Sub

            Public Shared WriteOnly Property ClientId(ByVal obj As Client) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.Id = value
                    End If
                End Set
            End Property

            Public Shared WriteOnly Property StudyId(ByVal obj As Study) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.Id = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property StudyAccountDirectorEmployeeId(ByVal obj As Study) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.AccountDirectorEmployeeId = value
                    End If
                End Set
            End Property

            Public Shared WriteOnly Property SurveyId(ByVal obj As Survey) As Integer
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
