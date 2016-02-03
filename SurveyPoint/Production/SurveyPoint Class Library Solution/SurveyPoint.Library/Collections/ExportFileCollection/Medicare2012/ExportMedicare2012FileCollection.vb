Imports Nrc.Framework.BusinessLogic
''' <summary>Holds a collectio of ExportFile Objects used in creates and logged an export</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
<Serializable()> _
Public Class ExportMedicare2012FileCollection
    Inherits BusinessListBase(Of ExportMedicare2012FileCollection, ExportMedicare2012File)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As ExportMedicare2012File = ExportMedicare2012File.NewExportMedicare2012File
        Me.Add(newObj)
        Return newObj
    End Function
End Class

