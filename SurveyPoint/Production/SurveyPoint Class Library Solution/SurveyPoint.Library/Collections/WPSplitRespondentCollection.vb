Imports Nrc.Framework.BusinessLogic
''' <summary>Holds a collectio of WPSplitRespondent Objects.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
<Serializable()> _
Public Class WPSplitRespondentCollection
    Inherits BusinessListBase(Of WPSplitRespondentCollection, WPSplitRespondent)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As WPSplitRespondent = WPSplitRespondent.NewWPSplitRespondent
        Me.Add(newObj)
        Return newObj
    End Function
End Class
