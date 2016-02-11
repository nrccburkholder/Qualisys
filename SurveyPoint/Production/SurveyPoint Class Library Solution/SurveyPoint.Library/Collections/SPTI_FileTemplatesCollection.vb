Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class SPTI_FileTemplateCollection
    Inherits BusinessListBase(Of SPTI_FileTemplateCollection, SPTI_FileTemplate)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As SPTI_FileTemplate = SPTI_FileTemplate.NewSPTI_FileTemplate
        Me.Add(newObj)
        Return newObj
    End Function
End Class