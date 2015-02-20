Namespace DataProvider

    Public MustInherit Class MedicarePropCalcTypeProvider

#Region " Singleton Implementation "

        Private Shared mInstance As MedicarePropCalcTypeProvider
        Private Const mProviderName As String = "MedicarePropCalcTypeProvider"

        Public Shared ReadOnly Property Instance() As MedicarePropCalcTypeProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of MedicarePropCalcTypeProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property

#End Region

        Protected Sub New()

        End Sub

        Public MustOverride Function [Select](ByVal medicarePropCalcTypeId As Integer) As MedicarePropCalcType
        Public MustOverride Function SelectAll() As MedicarePropCalcTypeCollection

    End Class

End Namespace
