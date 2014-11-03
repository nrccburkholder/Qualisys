Namespace DataProvider
    Public MustInherit Class StudyDatasetProvider

#Region " Singleton Implementation "
        Private Shared mInstance As StudyDatasetProvider
        Private Const mProviderName As String = "StudyDatasetProvider"

        Public Shared ReadOnly Property Instance() As StudyDatasetProvider
            <DebuggerHidden()> _
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of StudyDatasetProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectByStudyId(ByVal studyId As Integer, ByVal creationFilsterStartDate As Nullable(Of Date), ByVal creationFilterEndDate As Nullable(Of Date)) As Collection(Of StudyDataset)
        Public MustOverride Sub Delete(ByVal datasetId As Integer)

        Protected NotInheritable Class ReadOnlyAccessor
            Private Sub New()
            End Sub

            Public Shared WriteOnly Property StudyDatasetId(ByVal obj As StudyDataset) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.Id = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property StudyDatasetStudyId(ByVal obj As StudyDataset) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.StudyId = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property StudyDatasetDateLoaded(ByVal obj As StudyDataset) As Date
                Set(ByVal value As Date)
                    If obj IsNot Nothing Then
                        obj.DateLoaded = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property StudyDatasetRecordCount(ByVal obj As StudyDataset) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.RecordCount = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property StudyDatasetHasBeenSampled(ByVal obj As StudyDataset) As Boolean
                Set(ByVal value As Boolean)
                    If obj IsNot Nothing Then
                        obj.HasBeenSampled = value
                    End If
                End Set
            End Property

        End Class
    End Class

End Namespace
