Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class SPTI_ExportDefintionFileCollection
    Inherits BusinessListBase(Of SPTI_ExportDefintionFileCollection, SPTI_ExportDefintionFile)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As SPTI_ExportDefintionFile = SPTI_ExportDefintionFile.NewSPTI_ExportDefintionFile
        Me.Add(newObj)
        Return newObj
    End Function

    Public Sub RemoveExportDefinitionFile(ByVal item As SPTI_ExportDefintionFile)
        Dim index As Integer = 0
        For i As Integer = 0 To Me.Count - 1
            If Me(i).ReferenceGuid = item.ReferenceGuid Then
                index = i
                Exit For
            End If
        Next
        MyBase.RemoveItem(index)
    End Sub
End Class