Namespace DataProvider
    Public MustInherit Class StudyProvider

#Region " Singleton Implementation "
        Private Shared mInstance As StudyProvider
        Private Const mProviderName As String = "StudyProvider"

        Public Shared ReadOnly Property Instance() As StudyProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of StudyProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region
        Protected Sub New()

        End Sub
        Public MustOverride Function [Select](ByVal studyId As Integer) As Study
        Public MustOverride Function SelectByClientId(ByVal client As Client) As Collection(Of Study)
        Public MustOverride Sub Delete(ByVal studyId As Integer)
        Public MustOverride Function AllowDelete(ByVal studyId As Integer) As Boolean
        Public MustOverride Function InsertStudy(ByVal instance As Study) As Integer
        Public MustOverride Sub UpdateStudy(ByVal instance As Study)
        Public MustOverride Sub SetUpStudyOwnedTables(ByVal studyId As Integer)

        Protected NotInheritable Class ReadOnlyAccessor
            Private Sub New()
            End Sub

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

        End Class
    End Class

End Namespace
