Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class SPTI_ExportDefinitionCollection
    Inherits BusinessListBase(Of SPTI_ExportDefinitionCollection, SPTI_ExportDefinition)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As SPTI_ExportDefinition = SPTI_ExportDefinition.NewSPTI_ExportDefinition
        Me.Add(newObj)
        Return newObj
    End Function
End Class

