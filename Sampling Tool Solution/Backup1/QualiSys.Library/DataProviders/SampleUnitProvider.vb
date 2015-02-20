Namespace DataProvider

    Public MustInherit Class SampleUnitProvider

#Region " Singleton Implementation "
        Private Shared mInstance As SampleUnitProvider
        Private Const mProviderName As String = "SampleUnitProvider"

        Public Shared ReadOnly Property Instance() As SampleUnitProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of SampleUnitProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region
        Protected Sub New()

        End Sub
        Public MustOverride Function SelectBySurvey(ByVal survey As Survey) As Collection(Of SampleUnit)
        Public MustOverride Function [Select](ByVal sampleUnitId As Integer, ByVal survey As Survey) As SampleUnit
        Public MustOverride Function SelectByParentId(ByVal parentSampleUnitId As Integer, ByVal survey As Survey) As Collection(Of SampleUnit)
        Public MustOverride Sub Update(ByVal rootUnit As SampleUnit, ByVal qualisysEmployeeId As Integer)
        Public MustOverride Function IsDeletable(ByVal sampleUnitId As Integer, ByRef mUndeletableReasons As Collection(Of String)) As Boolean
        Public MustOverride Function SelectAllForSurvey(ByVal survey As Survey) As Collection(Of SampleUnit)

        Protected NotInheritable Class ReadOnlyAccessor
            Private Sub New()
            End Sub

            Public Shared WriteOnly Property SampleUnitId(ByVal obj As SampleUnit) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.Id = value
                    End If
                End Set
            End Property

        End Class
    End Class

End Namespace
