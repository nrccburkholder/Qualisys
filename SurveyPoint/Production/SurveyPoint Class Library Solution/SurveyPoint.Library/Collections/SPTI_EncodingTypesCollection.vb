Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class SPTI_EncodingTypeCollection
    Inherits BusinessListBase(Of SPTI_EncodingTypeCollection, SPTI_EncodingType)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As SPTI_EncodingType = SPTI_EncodingType.NewSPTI_EncodingType
        Me.Add(newObj)
        Return newObj
    End Function
End Class