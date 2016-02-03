Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class SPTI_DataTypeCollection
    Inherits BusinessListBase(Of SPTI_DataTypeCollection, SPTI_DataType)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As SPTI_DataType = SPTI_DataType.NewSPTI_DataType
        Me.Add(newObj)
        Return newObj
    End Function
End Class