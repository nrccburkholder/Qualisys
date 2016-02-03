Imports Nrc.Framework.BusinessLogic
''' <summary>Allows for a collection of ExportScriptSelected objects.  Selected
''' scripts have extension data (avaiable scripts do not).</summary>
''' <RevisionList><list type="table">
''' <listheader>
''' <term>Date Modified - Modified By</term>
''' <description>Description</description></listheader>
''' <item>
''' <term>03/10/2008 - Arman Mnatsakanyan</term>
''' <description>Add method should mark the Survey. It is done with ListChanged event handler.</description></item>
''' <item>
''' <term>	</term>
''' <description>
''' <para></para></description></item></list></RevisionList>
<Serializable()> _
Public Class ExportScriptSelectedCollection
    Inherits BusinessListBase(Of ExportScriptSelectedCollection, ExportScriptSelected)
    Dim mParentSurvey As ExportSurvey
    Protected Overrides Function AddNewCore() As Object
        Dim newObj As ExportScriptSelected = ExportScriptSelected.NewExportScriptSelected
        Me.Add(newObj)
        Return newObj
    End Function
End Class
