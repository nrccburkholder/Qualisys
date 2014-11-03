Imports Nrc.Framework.BusinessLogic

<Serializable()> _
Public Class MedicarePropCalcTypeCollection
    Inherits BusinessListBase(Of MedicarePropCalcTypeCollection, MedicarePropCalcType)

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As MedicarePropCalcType = MedicarePropCalcType.NewMedicarePropCalcType
        Me.Add(newObj)
        Return newObj

    End Function

End Class
