Imports Nrc.Framework.BusinessLogic
''' <summary>Holds a collectio of ExportFile Objects used in creates and logged an export</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
<Serializable()> _
Public Class ExportWPMedicareFileCollection
    Inherits BusinessListBase(Of ExportWPMedicareFileCollection, ExportWPMedicareFile)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As ExportWPMedicareFile = ExportWPMedicareFile.NewExportWPMedicareFile
        Me.Add(newObj)
        Return newObj
    End Function
End Class