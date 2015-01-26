Namespace DataProvider
    Public MustInherit Class MedicareGlobalCalcDateProvider

#Region " Singleton Implementation "
        Private Shared mInstance As MedicareGlobalCalcDateProvider
        Private Const mProviderName As String = "MedicareGlobalCalcDateProvider"
        Public Shared ReadOnly Property Instance() As MedicareGlobalCalcDateProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of MedicareGlobalCalcDateProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function [Get](ByVal medicareGlobalCalcDateId As Integer) As MedicareGlobalCalcDate
        Public MustOverride Function GetAll() As MedicareGlobalCalcDateCollection
        Public MustOverride Function GetByGlobalDefaultID(ByVal medicareGlobalDefaultID As Integer) As MedicareGlobalCalcDateCollection
        Public MustOverride Function Insert(ByVal instance As MedicareGlobalCalcDate) As Integer
        Public MustOverride Sub Update(ByVal instance As MedicareGlobalCalcDate)
        Public MustOverride Sub Delete(ByVal medicareGlobalCalcDateId As Integer)
        Public MustOverride Sub DeleteCalcDatesByGlobalDefaultID(ByVal medicareGlobalCalcDefaultID As Integer)
    End Class
End Namespace