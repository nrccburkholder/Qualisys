Namespace DataProvider
    Public MustInherit Class MedicareGlobalCalculationDefaultProvider

#Region " Singleton Implementation "
        Private Shared mInstance As MedicareGlobalCalculationDefaultProvider
        Private Const mProviderName As String = "MedicareGlobalCalculationDefaultProvider"
        Public Shared ReadOnly Property Instance() As MedicareGlobalCalculationDefaultProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of MedicareGlobalCalculationDefaultProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function [Get](ByVal medicareGlobalCalcDefaultId As Integer) As MedicareGlobalCalculationDefault
        Public MustOverride Function GetAll() As MedicareGlobalCalculationDefaultCollection
        Public MustOverride Function Insert(ByVal instance As MedicareGlobalCalculationDefault) As Integer
        Public MustOverride Sub Update(ByVal instance As MedicareGlobalCalculationDefault)
        Public MustOverride Sub Delete(ByVal medicareGlobalCalcDefaultId As Integer)
    End Class
End Namespace