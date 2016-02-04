Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class SPTI_ExportDefinitionLogCollection
    Inherits BusinessListBase(Of SPTI_ExportDefinitionLogCollection, SPTI_ExportDefinitionLog)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As SPTI_ExportDefinitionLog = SPTI_ExportDefinitionLog.NewSPTI_ExportDefinitionLog
        Me.Add(newObj)
        Return newObj
    End Function
End Class