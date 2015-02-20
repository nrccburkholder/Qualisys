Namespace DataProvider

    Public MustInherit Class SamplePeriodProvider

#Region " Singleton Implementation "
        Private Shared mInstance As SamplePeriodProvider
        Private Const mProviderName As String = "SamplePeriodProvider"

        Public Shared ReadOnly Property Instance() As SamplePeriodProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of SamplePeriodProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region
        Protected Sub New()

        End Sub
        Public MustOverride Function SelectBySurveyId(ByVal surveyId As Integer) As SamplePeriodCollection
        Public MustOverride Function SelectSamplePeriod(ByVal samplePeriodId As Integer) As SamplePeriod
        Public MustOverride Function SelectActivePeriodId(ByVal surveyId As Integer) As Integer
        Public MustOverride Function Insert(ByVal instance As SamplePeriod) As Integer
        Public MustOverride Sub Update(ByVal instance As SamplePeriod)
        Public MustOverride Sub Delete(ByVal samplePeriodId As Integer)


        Protected NotInheritable Class ReadOnlyAccessor
            Private Sub New()
            End Sub

            Public Shared WriteOnly Property SamplePeriodId(ByVal obj As SamplePeriod) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.Id = value
                    End If
                End Set
            End Property

            Public Shared WriteOnly Property PeriodTimeFrame(ByVal obj As SamplePeriod) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.PeriodTimeFrame = DirectCast(value, SamplePeriod.TimeFrame)
                    End If
                End Set
            End Property

            Public Shared WriteOnly Property SamplePeriodSurveyId(ByVal obj As SamplePeriod) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.SurveyId = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property SamplePeriodCreationDate(ByVal obj As SamplePeriod) As Date
                Set(ByVal value As Date)
                    If obj IsNot Nothing Then
                        obj.CreationDate = value
                    End If
                End Set
            End Property

        End Class
    End Class

End Namespace
