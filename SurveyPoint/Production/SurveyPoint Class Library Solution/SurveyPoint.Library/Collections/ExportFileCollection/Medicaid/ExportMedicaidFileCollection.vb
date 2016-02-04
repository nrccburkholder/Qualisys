Imports Nrc.Framework.BusinessLogic
''' <summary>Holds a collectio of ExportMedicaidFile Objects used in creates and logged an export</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
<Serializable()> _
Public Class ExportMedicaidFileCollection
    Inherits BusinessListBase(Of ExportMedicaidFileCollection, ExportMedicaidFile)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As ExportMedicaidFile = ExportMedicaidFile.NewExportMedicaidFile
        Me.Add(newObj)
        Return newObj
    End Function
End Class

